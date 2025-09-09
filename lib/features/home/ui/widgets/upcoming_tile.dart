import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../subscriptions/data/subscription.dart';

class UpcomingTile extends StatelessWidget {
  final Subscription sub;
  final String trailingPrice;
  const UpcomingTile({
    super.key,
    required this.sub,
    required this.trailingPrice,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('d MMM yyyy', 'sv_SE');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.autorenew)),
      title: Text(sub.name),
      subtitle: Text('Förnyas ${dateFmt.format(sub.nextRenewal)}'),
      trailing: Text(
        trailingPrice,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: () {
        // TODO: Navigate to details/edit screen
      },
    );
  }
}
