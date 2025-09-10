import 'package:flutter/material.dart';
import '../../../../shared/formatters/money.dart';
import '../../../subscriptions/data/subscription.dart';

class AllSubscriptionsCard extends StatelessWidget {
  final List<Subscription> items;
  final void Function(Subscription)? onTap;
  const AllSubscriptionsCard({super.key, required this.items, this.onTap});

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
            Text('Alla dina abonnemang', style: theme.textTheme.titleMedium),
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
                  onTap: onTap == null ? null : () => onTap!(s),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
