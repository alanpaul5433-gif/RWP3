import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/customers_bloc.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Customers', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              SizedBox(
                width: 300,
                child: SearchBar(
                  hintText: 'Search by name, email, phone...',
                  leading: const Icon(Icons.search),
                  onChanged: (query) {
                    if (query.length > 2) {
                      context.read<CustomersBloc>().add(CustomerSearchRequested(query));
                    } else if (query.isEmpty) {
                      context.read<CustomersBloc>().add(const CustomersLoadRequested());
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<CustomersBloc, CustomersState>(
              builder: (context, state) {
                if (state is CustomersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CustomersError) {
                  return Center(child: Text(state.message));
                }
                if (state is! CustomersLoaded) return const SizedBox.shrink();

                return Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Rides')),
                          DataColumn(label: Text('Wallet')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: state.customers.map((c) => DataRow(cells: [
                          DataCell(Text(c.fullName)),
                          DataCell(Text(c.email)),
                          DataCell(Text(c.phoneNumber)),
                          DataCell(Text('${c.totalRide}')),
                          DataCell(Text('\$${c.walletAmount.toStringAsFixed(2)}')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: c.isActive ? const Color(0xFF27C041).withValues(alpha: 0.1) : const Color(0xFFFE7235).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                c.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: c.isActive ? const Color(0xFF27C041) : const Color(0xFFFE7235),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ])).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
