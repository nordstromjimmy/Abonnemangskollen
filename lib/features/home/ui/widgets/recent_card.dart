import 'package:flutter/material.dart';
import '../../../../shared/formatters/money.dart';
import '../../../subscriptions/data/subscription.dart';

class RecentCard extends StatelessWidget {
  final List<Subscription> items;
  const RecentCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Senast tillagt', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('Inga abonnemang tillagda ännu')
            else
              ...items.map(
                (s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.receipt_long),
                  title: Text(s.name),
                  subtitle: Text(s.category ?? '—'),
                  trailing: Text(MoneyFmt.sekText(s.price)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
