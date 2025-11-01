import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/card_type.dart';
import '../models/card.dart';
import '../data/provider/card_provider.dart';
import '../models/card_network.dart';

class CardFormDialog extends StatefulWidget {
  final CardModel? existing;

  const CardFormDialog({super.key, this.existing});

  @override
  State<CardFormDialog> createState() => _CardFormDialogState();
}

class _CardFormDialogState extends State<CardFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String? issuer;
  late CardNetwork? network;
  late String? cardName;
  late String number;
  late int month;
  late int year;
  late String cvv;
  late String? holderName;
  CardType type = CardType.credit;
  CardColorScheme? colorScheme;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      issuer = e.issuer;
      network = e.network;
      cardName = e.cardName;
      number = e.cardNumber;
      month = e.expiryMonth;
      year = e.expiryYear;
      cvv = e.cvv;
      holderName = e.holderName;
      type = e.type;
      colorScheme = e.colorScheme;
    } else {
      issuer = '';
      network = null;
      cardName = '';
      number = '';
      month = DateTime.now().month;
      year = DateTime.now().year + 3;
      cvv = '';
      holderName = '';
      type = CardType.credit;
      colorScheme = null;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final prov = context.read<CardProvider>();
    final model = CardModel(
      id: widget.existing?.id ?? '',
      issuer: issuer,
      network: network,
      cardName: cardName,
      cardNumber: number,
      expiryMonth: month,
      expiryYear: year,
      cvv: cvv,
      holderName: holderName,
      type: type,
      colorScheme: colorScheme,
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
                initialValue: issuer,
                decoration:
                    const InputDecoration(labelText: 'Issuer (Bank, etc)'),
                onSaved: (v) => issuer = v?.trim(),
              ),
              DropdownButtonFormField<CardNetwork>(
                value: network,
                items: CardNetwork.values
                    .map((n) => DropdownMenuItem(
                        value: n, child: Text(n.name.toUpperCase())))
                    .toList(),
                onChanged: (v) => setState(() => network = v),
                decoration: const InputDecoration(labelText: 'Card Network'),
              ),
              TextFormField(
                initialValue: cardName,
                decoration: const InputDecoration(
                    labelText: 'Card Name (Black, Privilege, etc)'),
                onSaved: (v) => cardName = v?.trim(),
              ),
              TextFormField(
                initialValue: number,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                onSaved: (v) => number = v?.replaceAll(' ', '') ?? '',
                validator: (v) =>
                    (v == null || v.trim().length < 12) ? 'Invalid' : null,
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
                initialValue: cvv,
                decoration:
                    const InputDecoration(labelText: 'CVV/CVC/CVD (optional)'),
                keyboardType: TextInputType.number,
                onSaved: (v) => cvv = v!.trim(),
              ),
              TextFormField(
                initialValue: holderName,
                decoration: const InputDecoration(
                    labelText: 'Cardholder Name (optional)'),
                onSaved: (v) => holderName = v?.trim(),
              ),
              DropdownButtonFormField<CardType>(
                value: type,
                items: CardType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => type = v ?? CardType.credit),
                decoration: const InputDecoration(labelText: 'Card Type'),
              ),
              // Color scheme picker can be added here if needed
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
