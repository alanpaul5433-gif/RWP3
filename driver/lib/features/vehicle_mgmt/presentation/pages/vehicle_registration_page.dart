import 'package:flutter/material.dart';
import 'package:core/core.dart';

class VehicleRegistrationPage extends StatefulWidget {
  const VehicleRegistrationPage({super.key});

  @override
  State<VehicleRegistrationPage> createState() => _VehicleRegistrationPageState();
}

class _VehicleRegistrationPageState extends State<VehicleRegistrationPage> {
  String? _selectedType;
  String? _selectedBrand;
  String? _selectedModel;
  final _numberController = TextEditingController();

  final _types = ['Economy', 'Sedan', 'SUV', 'Premium'];
  final _brands = ['Toyota', 'Honda', 'Ford', 'BMW', 'Mercedes'];
  final _models = {'Toyota': ['Camry', 'Corolla'], 'Honda': ['Civic', 'Accord'], 'Ford': ['Focus', 'Fusion'], 'BMW': ['3 Series', '5 Series'], 'Mercedes': ['C-Class', 'E-Class']};

  @override
  void dispose() { _numberController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Icon(Icons.directions_car, size: 64, color: colorScheme.primary),
          const SizedBox(height: 24),
          Text('Register your vehicle', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),

          // Vehicle type
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(labelText: 'Vehicle Type', prefixIcon: Icon(Icons.category)),
            items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _selectedType = v),
          ),
          const SizedBox(height: 16),

          // Brand
          DropdownButtonFormField<String>(
            value: _selectedBrand,
            decoration: const InputDecoration(labelText: 'Brand', prefixIcon: Icon(Icons.branding_watermark)),
            items: _brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (v) => setState(() { _selectedBrand = v; _selectedModel = null; }),
          ),
          const SizedBox(height: 16),

          // Model
          DropdownButtonFormField<String>(
            value: _selectedModel,
            decoration: const InputDecoration(labelText: 'Model', prefixIcon: Icon(Icons.directions_car_filled)),
            items: (_models[_selectedBrand] ?? []).map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
            onChanged: (v) => setState(() => _selectedModel = v),
          ),
          const SizedBox(height: 16),

          // Number
          TextFormField(
            controller: _numberController,
            textCapitalization: TextCapitalization.characters,
            validator: (v) => Validators.required(v, 'Vehicle number'),
            decoration: const InputDecoration(labelText: 'Vehicle Number', hintText: 'ABC 1234', prefixIcon: Icon(Icons.pin)),
          ),
          const SizedBox(height: 32),

          FilledButton(
            onPressed: (_selectedType != null && _selectedBrand != null && _selectedModel != null && _numberController.text.isNotEmpty)
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle registered (mock)')));
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Register Vehicle'),
          ),
        ]),
      ),
    );
  }
}
