import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscriptions/features/home/ui/widgets/empty_state.dart';
import 'package:subscriptions/features/subscriptions/ui/add_subscription_screen.dart';
import 'package:subscriptions/features/subscriptions/ui/edit_subscription_screen.dart';
import 'package:subscriptions/shared/providers.dart';
import '../../../shared/formatters/money.dart';
import 'widgets/big_kpi_card.dart';
import 'widgets/upcoming_card.dart';
import 'widgets/all_subscriptions_card.dart';
import 'widgets/loading_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Översikt')),
      floatingActionButton: Consumer(
        builder: (context, ref, _) => FloatingActionButton.extended(
          onPressed: () async {
            final saved = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddSubscriptionScreen()),
            );
            if (saved == true) {
              ref.invalidate(homeDataProvider); // triggers immediate recompute
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Lägg till abonnemang'),
        ),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final asyncHome = ref.watch(homeDataProvider); // <-- watch the stream
          return asyncHome.when(
            loading: () => const LoadingSkeleton(),
            error: (e, st) => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Ett fel uppstod. Dra ner för att uppdatera.'),
              ),
            ),
            data: (data) {
              if (data.items.isEmpty) {
                return EmptyState(
                  onAdd: () async {
                    final saved = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddSubscriptionScreen(),
                      ),
                    );
                    if (saved == true) ref.invalidate(homeDataProvider);
                  },
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  BigKpiCard(
                    title: 'Månadskostnad',
                    value: MoneyFmt.sekText(data.monthlyTotal),
                    subtitle: 'Totalt för alla abonnemang',
                  ),
                  const SizedBox(height: 16),
                  UpcomingCard(items: data.upcoming),
                  const SizedBox(height: 16),
                  AllSubscriptionsCard(
                    items: data.items,
                    onTap: (s) async {
                      final changed = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditSubscriptionScreen(sub: s),
                        ),
                      );
                      if (changed == true) {
                        // If you’re using the StreamProvider it will auto-refresh.
                        // Optionally force it:
                        // ref.invalidate(homeDataProvider);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
