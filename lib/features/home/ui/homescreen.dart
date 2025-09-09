import 'package:flutter/material.dart';
import 'package:subscriptions/features/home/logic/home_controller.dart';
import 'package:subscriptions/features/home/models/home_data.dart';
import '../../../shared/formatters/money.dart';
import 'widgets/big_kpi_card.dart';
import 'widgets/upcoming_card.dart';
import 'widgets/recent_card.dart';
import 'widgets/empty_state.dart';
import 'widgets/loading_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = HomeController();

  void _onAddPressed() {
    // TODO: Navigate to your "Lägg till abonnemang" screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSubscriptionScreen()));
  }

  Future<HomeData> _load() => controller.load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Översikt')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddPressed,
        icon: const Icon(Icons.add),
        label: const Text('Lägg till'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: FutureBuilder<HomeData>(
          future: _load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingSkeleton();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Ett fel uppstod. Dra ner för att uppdatera.'),
                ),
              );
            }
            final data = snapshot.data!;
            if (data.items.isEmpty) {
              return EmptyState(onAdd: _onAddPressed);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BigKpiCard(
                  title: 'Månadskostnad',
                  value: MoneyFmt.sekText(data.monthlyTotal),
                  subtitle: 'Normaliserat över alla abonnemang',
                ),
                const SizedBox(height: 16),
                UpcomingCard(items: data.upcoming),
                const SizedBox(height: 16),
                RecentCard(items: data.recent),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
