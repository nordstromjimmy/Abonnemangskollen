import 'package:flutter/material.dart';
import '../../../../shared/formatters/money.dart';
import '../../../subscriptions/data/subscription.dart';
import 'upcoming_tile.dart';

class UpcomingCard extends StatelessWidget {
  final List<Subscription> items;
  const UpcomingCard({super.key, required this.items});

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
            Row(
              children: [
                Text('Kommande förnyelser', style: theme.textTheme.titleMedium),
                const Spacer(),
                Icon(Icons.event, size: 18, color: theme.colorScheme.primary),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Inga förnyelser inom 30 dagar'),
              )
            else
              ...items
                  .take(6)
                  .map(
                    (s) => UpcomingTile(
                      sub: s,
                      trailingPrice: MoneyFmt.sekText(s.price),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
