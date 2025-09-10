import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const EmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.subscriptions_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text('Inga abonnemang ännu', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Lägg till ditt första abonnemang för att se månadskostnad och få påminnelser.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            /* FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Lägg till abonnemang'),
            ), */
          ],
        ),
      ),
    );
  }
}
