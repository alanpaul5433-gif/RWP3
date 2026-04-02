import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/driver_auth_bloc.dart';

class DriverLoginPage extends StatefulWidget {
  const DriverLoginPage({super.key});

  @override
  State<DriverLoginPage> createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<DriverAuthBloc>().add(DriverEmailLoginRequested(
        email: _emailController.text.trim(), password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocListener<DriverAuthBloc, DriverAuthState>(
        listener: (context, state) {
          if (state is DriverAuthenticated) context.go('/home');
          if (state is DriverAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: colorScheme.error));
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Icon(Icons.drive_eta_rounded, size: 64, color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Driver', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                    Text('Sign in to start driving', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(height: 48),
                    TextFormField(
                      controller: _emailController, validator: Validators.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController, obscureText: _obscure, validator: Validators.password,
                      onFieldSubmitted: (_) => _onLogin(),
                      decoration: InputDecoration(
                        labelText: 'Password', prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => setState(() => _obscure = !_obscure)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<DriverAuthBloc, DriverAuthState>(
                      builder: (context, state) {
                        final loading = state is DriverAuthLoading;
                        return FilledButton(
                          onPressed: loading ? null : _onLogin,
                          child: loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Sign In'),
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
