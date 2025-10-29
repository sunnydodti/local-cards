import 'package:flutter/material.dart';
import '../models/card.dart';
import '../widgets/my_appbar.dart';
import '../widgets/mobile_wrapper.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String? issuer = '';
  CardNetwork? network = CardNetwork.values.first;
  String? cardName = '';
  String number = '';
  int month = DateTime.now().month;
  int year = DateTime.now().year + 3;
  String? cvv = '';
  String? holderName = '';
  CardType type = CardType.values.first;
  CardColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        appBar: MyAppbar.build(context, title: 'Add Card', back: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _CardPreview(
                bankName: issuer,
                network: network,
                cardNumber: number,
                cardName: cardName,
                month: month,
                year: year,
                cvv: cvv,
                holderName: holderName,
                cardType: type,
                colorScheme: colorScheme,
                masked: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: issuer,
                          decoration: const InputDecoration(labelText: 'Issuer (Bank, etc)'),
                          onChanged: (v) => setState(() => issuer = v),
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
                        Center(
                          child: TextFormField(
                            initialValue: number,
                            decoration: const InputDecoration(labelText: 'Card Number'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => setState(() => number = v),
                            onSaved: (v) => number = v?.replaceAll(' ', '') ?? '',
                            validator: (v) => (v == null || v.trim().length < 12) ? 'Invalid' : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: cardName,
                                decoration: const InputDecoration(labelText: 'Card Name (Black, Privilege, etc)'),
                                onChanged: (v) => setState(() => cardName = v),
                                onSaved: (v) => cardName = v?.trim(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: month.toString(),
                                decoration: const InputDecoration(labelText: 'MM'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => setState(() => month = int.tryParse(v) ?? month),
                                onSaved: (v) => month = int.tryParse(v ?? '') ?? month,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: year.toString(),
                                decoration: const InputDecoration(labelText: 'YYYY'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => setState(() => year = int.tryParse(v) ?? year),
                                onSaved: (v) => year = int.tryParse(v ?? '') ?? year,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                initialValue: cvv,
                                decoration: const InputDecoration(labelText: 'CVV'),
                                keyboardType: TextInputType.number,
                                onChanged: (v) => setState(() => cvv = v),
                                onSaved: (v) => cvv = v?.trim(),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          initialValue: holderName,
                          decoration: const InputDecoration(labelText: 'Cardholder Name (optional)'),
                          onChanged: (v) => setState(() => holderName = v),
                          onSaved: (v) => holderName = v?.trim(),
                        ),
                        DropdownButtonFormField<CardType>(
                          value: type,
                          items: CardType.values
                              .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              type = v ?? CardType.values.first;
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Card Type'),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              // TODO: Add your card saving logic here, e.g. call provider/service
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Card saved!')),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save Card'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// ...existing code...
// ...existing code...
}

class _CardPreview extends StatelessWidget {
  final String? bankName;
  final CardNetwork? network;
  final String cardNumber;
  final String? cardName;
  final int? month;
  final int? year;
  final String? cvv;
  final String? holderName;
  final CardType cardType;
  final CardColorScheme? colorScheme;
  final bool masked;
  const _CardPreview({
    this.bankName,
    this.network,
    required this.cardNumber,
    this.cardName,
    this.month,
    this.year,
    this.cvv,
    this.holderName,
    required this.cardType,
    this.colorScheme,
    this.masked = false,
  });

  String _maskedDisplay(String number) {
    final last = number.length >= 4 ? number.substring(number.length - 4) : number;
    return '•••• •••• •••• $last';
  }

  @override
  Widget build(BuildContext context) {
    final bg = colorScheme?.bgColor != null ? Color(colorScheme!.bgColor) : Theme.of(context).colorScheme.primary;
    final txt = colorScheme?.textColor != null ? Color(colorScheme!.textColor) : Colors.white;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bg,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Bank Name (left), Card Network (right)
            Row(
              children: [
                Expanded(
                  child: Text(bankName ?? '', style: textTheme.titleMedium?.copyWith(color: txt)),
                ),
                Text(network?.name.toUpperCase() ?? '', style: textTheme.titleMedium?.copyWith(color: txt)),
              ],
            ),
            const SizedBox(height: 10),
            // Row 2: Card Number (masked) centered
            Center(
              child: Text(
                masked
                  ? (cardNumber.isEmpty ? '•••• •••• •••• 0000' : _maskedDisplay(cardNumber))
                  : (cardNumber.isEmpty ? '0000 0000 0000 0000' : cardNumber),
                style: textTheme.headlineSmall?.copyWith(color: txt, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Row 3: Card Name (left), Expiry and CVV (right)
            Row(
              children: [
                Expanded(
                  child: Text(cardName ?? '', style: textTheme.bodyLarge?.copyWith(color: txt)),
                ),
                Text(
                  ((month != null && year != null) ? '${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}' : '') +
                  ((cvv != null && cvv!.isNotEmpty) ? '  ${cvv!.padRight(3, '•')}' : ''),
                  style: textTheme.bodyLarge?.copyWith(color: txt),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 4: Cardholder Name (left), Card Type (right)
            Row(
              children: [
                Expanded(
                  child: Text(holderName?.toUpperCase() ?? '', style: textTheme.bodyLarge?.copyWith(color: txt)),
                ),
                Text(cardType.name.toUpperCase(), style: textTheme.bodyLarge?.copyWith(color: txt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
