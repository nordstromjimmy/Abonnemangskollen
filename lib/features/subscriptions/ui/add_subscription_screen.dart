import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../subscriptions/data/subscription.dart';
import '../logic/add_sub_provider.dart';

class AddSubscriptionScreen extends ConsumerStatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  ConsumerState<AddSubscriptionScreen> createState() =>
      _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends ConsumerState<AddSubscriptionScreen> {
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _customIntervalCtrl = TextEditingController(text: '1');
  final _notifyDaysCtrl = TextEditingController(text: '14');
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    _customIntervalCtrl.dispose();
    _notifyDaysCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      locale: const Locale('sv'),
    );
    if (picked != null) {
      ref.read(addSubProvider.notifier).setNextRenewal(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addSubProvider);
    final noti = ref.read(addSubProvider.notifier);

    final custom = state.period == BillingPeriod.custom;

    return Scaffold(
      appBar: AppBar(title: const Text('Lägg till abonnemang')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Namn',
              hintText: 't.ex. Netflix',
            ),
            onChanged: noti.setName,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _categoryCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              hintText: 't.ex. Streaming',
            ),
            onChanged: noti.setCategory,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Pris',
                    suffixText: 'kr',
                  ),
                  onChanged: noti.setPrice,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<BillingPeriod>(
                  value: state.period,
                  decoration: const InputDecoration(
                    labelText: 'Fakturaintervall',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: BillingPeriod.monthly,
                      child: Text('Månadsvis'),
                    ),
                    DropdownMenuItem(
                      value: BillingPeriod.quarterly,
                      child: Text('Kvartalsvis'),
                    ),
                    DropdownMenuItem(
                      value: BillingPeriod.yearly,
                      child: Text('Årsvis'),
                    ),
                    DropdownMenuItem(
                      value: BillingPeriod.custom,
                      child: Text('Anpassat'),
                    ),
                  ],
                  onChanged: (v) => v != null ? noti.setPeriod(v) : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (custom)
            TextField(
              controller: _customIntervalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Var X månad(er)',
                hintText: 't.ex. 2',
              ),
              onChanged: noti.setCustomInterval,
            ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Nästa förnyelse'),
            subtitle: Text(
              '${state.nextRenewal.day.toString().padLeft(2, '0')}-${state.nextRenewal.month.toString().padLeft(2, '0')}-${state.nextRenewal.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _pickDate(state.nextRenewal),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notifyDaysCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Påminnelse (dagar innan)',
            ),
            onChanged: (v) => noti.setNotifyDays(int.tryParse(v) ?? 14),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              labelText: 'Anteckningar (valfritt)',
              //hintText: 't.ex. kundnr, autogiro, uppsägningstid, avtalslängd…',
            ),
            onChanged: noti.setNotes,
          ),
          const SizedBox(height: 20),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          FilledButton.icon(
            onPressed: state.isSaving
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final ok = await noti.save();
                    if (!mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abonnemang sparat')),
                      );
                      Navigator.of(context).pop(true);
                    } else if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error!)));
                    }
                  },
            icon: state.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Spara'),
          ),
        ],
      ),
    );
  }
}
