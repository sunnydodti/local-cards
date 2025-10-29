import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card.dart';
import '../data/provider/card_provider.dart';

class CardFormDialog extends StatefulWidget {
  final CardModel? existing;

  const CardFormDialog({super.key, this.existing});

  @override
  State<CardFormDialog> createState() => _CardFormDialogState();
}

class _CardFormDialogState extends State<CardFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String holderName;
  late String number;
  late int month;
  late int year;
  String? brand;
  CardType type = CardType.other;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      holderName = e.holderName;
      number = e.cardNumber;
      month = e.expiryMonth;
      year = e.expiryYear;
      brand = e.brand;
      type = e.type;
    } else {
      holderName = '';
      number = '';
      month = DateTime.now().month;
      year = DateTime.now().year + 3;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final prov = context.read<CardProvider>();
    final model = CardModel(
      id: widget.existing?.id ?? '',
      holderName: holderName,
      cardNumber: number,
      expiryMonth: month,
      expiryYear: year,
      brand: brand,
      type: type,
    );
    if (widget.existing == null) {
      await prov.addCard(model);
    } else {
      await prov.updateCard(model);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Card' : 'Edit Card'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: holderName,
                decoration: const InputDecoration(labelText: 'Holder name'),
                onSaved: (v) => holderName = v?.trim() ?? '',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                initialValue: number,
                decoration: const InputDecoration(labelText: 'Card number'),
                keyboardType: TextInputType.number,
                onSaved: (v) => number = v?.replaceAll(' ', '') ?? '',
                validator: (v) => (v == null || v.trim().length < 12) ? 'Invalid' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: month.toString(),
                      decoration: const InputDecoration(labelText: 'MM'),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => month = int.tryParse(v ?? '') ?? month,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: year.toString(),
                      decoration: const InputDecoration(labelText: 'YYYY'),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => year = int.tryParse(v ?? '') ?? year,
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: brand,
                decoration: const InputDecoration(labelText: 'Brand (optional)'),
                onSaved: (v) => brand = v?.trim(),
              ),
              DropdownButtonFormField<CardType>(
                value: type,
                items: CardType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => type = v ?? CardType.other),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
