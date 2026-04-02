import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/roles_bloc.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Roles & Permissions', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Add Role')),
      ]),
      const SizedBox(height: 24),

      Expanded(child: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state is RolesLoading) return const Center(child: CircularProgressIndicator());
          final roles = state is RolesLoaded ? state.roles : <RolePermissionEntity>[];

          return ListView.builder(itemCount: roles.length, itemBuilder: (context, index) {
            final role = roles[index];
            return Card(margin: const EdgeInsets.only(bottom: 16), child: ExpansionTile(
              leading: Icon(role.isEdit ? Icons.edit : Icons.lock, color: role.isEdit ? colorScheme.secondary : colorScheme.outline),
              title: Text(role.roleTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${role.permissions.length} permissions', style: theme.textTheme.bodySmall),
              trailing: role.isEdit ? IconButton(icon: Icon(Icons.delete_outline, color: colorScheme.error),
                  onPressed: () => context.read<RolesBloc>().add(RoleDeleteRequested(role.id))) : const Icon(Icons.lock, size: 18),
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: SizedBox(width: double.infinity, child: DataTable(
                  columnSpacing: 24,
                  columns: const [DataColumn(label: Text('Module')), DataColumn(label: Text('View')), DataColumn(label: Text('Create')), DataColumn(label: Text('Update')), DataColumn(label: Text('Delete'))],
                  rows: role.permissions.map((p) => DataRow(cells: [
                    DataCell(Text(p.title)),
                    DataCell(Icon(p.isView ? Icons.check_circle : Icons.cancel, size: 18, color: p.isView ? const Color(0xFF27C041) : colorScheme.outline)),
                    DataCell(Icon(p.isCreate ? Icons.check_circle : Icons.cancel, size: 18, color: p.isCreate ? const Color(0xFF27C041) : colorScheme.outline)),
                    DataCell(Icon(p.isUpdate ? Icons.check_circle : Icons.cancel, size: 18, color: p.isUpdate ? const Color(0xFF27C041) : colorScheme.outline)),
                    DataCell(Icon(p.isDelete ? Icons.check_circle : Icons.cancel, size: 18, color: p.isDelete ? const Color(0xFF27C041) : colorScheme.outline)),
                  ])).toList(),
                ))),
              ],
            ));
          });
        },
      )),
    ]));
  }
}
