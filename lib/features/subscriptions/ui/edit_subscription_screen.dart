import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../subscriptions/data/subscription.dart';
import '../logic/edit_sub_provider.dart';

class EditSubscriptionScreen extends ConsumerStatefulWidget {
  final Subscription sub;
  const EditSubscriptionScreen({super.key, required this.sub});

  @override
  ConsumerState<EditSubscriptionScreen> createState() =>
      _EditSubscriptionScreenState();
}

class _EditSubscriptionScreenState
    extends ConsumerState<EditSubscriptionScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _customIntervalCtrl;
  late final TextEditingController _notifyDaysCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final s = widget.sub;
    _nameCtrl = TextEditingController(text: s.name);
    _categoryCtrl = TextEditingController(text: s.category ?? '');
    _priceCtrl = TextEditingController(text: (s.price).toString());
    _customIntervalCtrl = TextEditingController(
      text: (s.customInterval ?? 1).toString(),
    );
    _notifyDaysCtrl = TextEditingController(
      text: (s.notifyDaysBefore).toString(),
    );
    _notesCtrl = TextEditingController(text: s.notes ?? '');
  }

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

  Future<void> _pickDate(
    DateTime current,
    void Function(DateTime) onPick,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      locale: const Locale('sv'),
    );
    if (picked != null) onPick(picked);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSubProvider(widget.sub));
    final noti = ref.read(editSubProvider(widget.sub).notifier);
    final custom = state.period == BillingPeriod.custom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redigera abonnemang'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Radera abonnemang'),
                  content: const Text(
                    'Är du säker på att du vill radera abonnemanget ifrån appen?',
                  ),
                  actions: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Avbryt'),
                        ),
                        Spacer(),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Radera'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                final ok = await noti.delete();
                if (!mounted) return;
                if (ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abonnemang raderat')),
                  );
                  Navigator.of(context).pop(true);
                } else if (state.error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error!)));
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Namn'),
            onChanged: noti.setName,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _categoryCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Kategori'),
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
              decoration: const InputDecoration(labelText: 'Var X månad(er)'),
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
            onTap: () => _pickDate(state.nextRenewal, noti.setNextRenewal),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notifyDaysCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Påminnelse (dagar innan)',
            ),
            onChanged: (v) =>
                noti.setNotifyDays(int.tryParse(v) ?? state.notifyDaysBefore),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            minLines: 1,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              labelText: 'Anteckningar (valfritt)',
              //hintText: 't.ex. kundnr, uppsägningstid, avtalslängd…',
            ),
            onChanged: noti.setNotes, // ⬅️ new
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
            onPressed: (!state.valid || state.isSaving)
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final ok = await noti.save();
                    if (!mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ändringar sparade')),
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
