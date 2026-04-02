import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/bank_bloc.dart';

class BankDetailsPage extends StatelessWidget {
  const BankDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Bank & Wallet')),
      floatingActionButton: FloatingActionButton(onPressed: () => _showAddBankDialog(context), child: const Icon(Icons.add)),
      body: BlocConsumer<BankBloc, BankState>(
        listener: (context, state) {
          if (state is WithdrawalSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Withdrawal of \$${state.withdrawal.amount.toStringAsFixed(2)} submitted')));
            context.read<BankBloc>().add(const BankAccountsLoadRequested('mock_driver'));
          }
          if (state is BankError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: colorScheme.error));
          }
        },
        builder: (context, state) {
          if (state is BankLoading) return const Center(child: CircularProgressIndicator());

          final accounts = state is BankAccountsLoaded ? state.accounts : <BankDetailsEntity>[];
          final balance = state is BankAccountsLoaded ? state.walletBalance : 0.0;

          return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Wallet balance
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF2E7D32), const Color(0xFF2E7D32).withValues(alpha: 0.8)]),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Wallet Balance', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('\$${balance.toStringAsFixed(2)}', style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: accounts.isNotEmpty ? () => _showWithdrawDialog(context, accounts.first.id) : null,
                  style: FilledButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2), foregroundColor: Colors.white),
                  child: const Text('Withdraw'),
                ),
              ]),
            ),
            const SizedBox(height: 24),

            Text('Bank Accounts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            if (accounts.isEmpty)
              Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
                Icon(Icons.account_balance_outlined, size: 40, color: colorScheme.outline),
                const SizedBox(height: 8),
                Text('No bank accounts', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                Text('Add one to withdraw earnings', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
              ])))
            else
              ...accounts.map((bank) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.account_balance, color: colorScheme.secondary),
                  title: Text(bank.bankName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${bank.holderName}\n****${bank.accountNumber.length > 4 ? bank.accountNumber.substring(bank.accountNumber.length - 4) : bank.accountNumber}'),
                  isThreeLine: true,
                  trailing: bank.isDefault ? Chip(label: const Text('Default'), backgroundColor: colorScheme.primaryContainer) : null,
                ),
              )),
          ]));
        },
      ),
    );
  }

  void _showAddBankDialog(BuildContext context) {
    final holderCtrl = TextEditingController();
    final accCtrl = TextEditingController();
    final bankCtrl = TextEditingController();
    final ifscCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Add Bank Account'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: holderCtrl, decoration: const InputDecoration(labelText: 'Account Holder Name')),
        const SizedBox(height: 12),
        TextField(controller: accCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account Number')),
        const SizedBox(height: 12),
        TextField(controller: bankCtrl, decoration: const InputDecoration(labelText: 'Bank Name')),
        const SizedBox(height: 12),
        TextField(controller: ifscCtrl, decoration: const InputDecoration(labelText: 'IFSC/SWIFT Code')),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () {
          if (holderCtrl.text.isNotEmpty && accCtrl.text.isNotEmpty && bankCtrl.text.isNotEmpty) {
            Navigator.pop(ctx);
            context.read<BankBloc>().add(BankAccountAddRequested(driverId: 'mock_driver', holderName: holderCtrl.text, accountNumber: accCtrl.text, bankName: bankCtrl.text, ifscCode: ifscCtrl.text));
          }
        }, child: const Text('Add')),
      ],
    ));
  }

  void _showWithdrawDialog(BuildContext context, String bankId) {
    final amountCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Withdraw'),
      content: TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ ')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () {
          final amount = double.tryParse(amountCtrl.text);
          if (amount != null && amount > 0) {
            Navigator.pop(ctx);
            context.read<BankBloc>().add(WithdrawalRequested(driverId: 'mock_driver', amount: amount, bankId: bankId));
          }
        }, child: const Text('Withdraw')),
      ],
    ));
  }
}
