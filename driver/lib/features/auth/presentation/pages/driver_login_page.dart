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
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 32, left: 24, right: 24),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.drive_eta_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text('RWP Driver', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('Drive Your\nFuture', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
                    const SizedBox(height: 8),
                    Text('Sign in to start earning', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.7))),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('EMAIL', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 1.2)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController, validator: Validators.email,
                        keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(hintText: 'driver@rwp.com', prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(height: 20),
                      Text('PASSWORD', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.5), letterSpacing: 1.2)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController, obscureText: _obscure, validator: Validators.password,
                        onFieldSubmitted: (_) => _onLogin(),
                        decoration: InputDecoration(
                          hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => setState(() => _obscure = !_obscure)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<DriverAuthBloc, DriverAuthState>(
                        builder: (context, state) {
                          final loading = state is DriverAuthLoading;
                          return FilledButton(
                            onPressed: loading ? null : _onLogin,
                            child: loading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text('Start Driving'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18),
                                  ]),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          _emailController.text = 'driver@rwp.com';
                          _passwordController.text = 'demo123';
                          _onLogin();
                        },
                        style: OutlinedButton.styleFrom(side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3))),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.play_circle_outline, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Try Demo Account', style: TextStyle(color: colorScheme.primary)),
                        ]),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
