import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card.dart';
import '../data/provider/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  // Card fields
  String? issuer = '';
  CardNetwork? network;
  String? cardName = '';
  String number = '';
  int month = DateTime.now().month;
  int year = DateTime.now().year + 3;
  String? cvv = '';
  String? holderName = '';
  CardType type = CardType.credit;
  CardColorScheme? colorScheme;

  // No animation needed for preview
  @override
  void initState() {
    super.initState();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final prov = context.read<CardProvider>();
    final model = CardModel(
      id: '',
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
    await prov.addCard(model);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
  // final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Card')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Live card preview (no animation)
              _CardPreview(
                issuer: issuer,
                network: network,
                cardName: cardName,
                number: number,
                month: month,
                year: year,
                holderName: holderName,
                type: type,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                onChanged: _onFieldChanged,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: issuer,
                      decoration: const InputDecoration(labelText: 'Issuer (Bank, etc)'),
                      onSaved: (v) => issuer = v?.trim(),
                    ),
                    DropdownButtonFormField<CardNetwork>(
                      value: network,
                      items: CardNetwork.values
                          .map((n) => DropdownMenuItem(value: n, child: Text(n.name.toUpperCase())))
                          .toList(),
                      onChanged: (v) => setState(() => network = v),
                      decoration: const InputDecoration(labelText: 'Card Network'),
                    ),
                    TextFormField(
                      initialValue: cardName,
                      decoration: const InputDecoration(labelText: 'Card Name (Black, Privilege, etc)'),
                      onSaved: (v) => cardName = v?.trim(),
                    ),
                    TextFormField(
                      initialValue: number,
                      decoration: const InputDecoration(labelText: 'Card Number'),
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
                      initialValue: cvv,
                      decoration: const InputDecoration(labelText: 'CVV/CVC/CVD (optional)'),
                      keyboardType: TextInputType.number,
                      onSaved: (v) => cvv = v?.trim(),
                    ),
                    TextFormField(
                      initialValue: holderName,
                      decoration: const InputDecoration(labelText: 'Cardholder Name (optional)'),
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save Card'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final String? issuer;
  final CardNetwork? network;
  final String? cardName;
  final String number;
  final int month;
  final int year;
  final String? holderName;
  final CardType type;
  final CardColorScheme? colorScheme;

  const _CardPreview({
    this.issuer,
    this.network,
    this.cardName,
    required this.number,
    required this.month,
    required this.year,
    this.holderName,
    required this.type,
    this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final bg = colorScheme?.bgColor != null ? Color(colorScheme!.bgColor) : Theme.of(context).colorScheme.primary;
    final txt = colorScheme?.textColor != null ? Color(colorScheme!.textColor) : Colors.white;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bg,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(issuer ?? '', style: textTheme.titleMedium?.copyWith(color: txt)),
                ),
                Text(network?.name.toUpperCase() ?? '', style: textTheme.titleMedium?.copyWith(color: txt)),
              ],
            ),
            const Spacer(),
            Center(
              child: Text(
                number.isEmpty ? '•••• •••• •••• 0000' : (number.length <= 4 ? number : '•••• •••• •••• ${number.substring(number.length - 4)}'),
                style: textTheme.headlineSmall?.copyWith(color: txt, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(holderName?.toUpperCase() ?? '', style: textTheme.bodyLarge?.copyWith(color: txt)),
                ),
                Text('${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}', style: textTheme.bodyLarge?.copyWith(color: txt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
