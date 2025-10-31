import 'package:flutter/material.dart';
import '../enums/card_tile_type.dart';
import '../enums/card_type.dart';
import '../models/card.dart';
import '../models/card_network.dart';
import '../widgets/card_tile.dart';
import '../widgets/my_appbar.dart';
import '../widgets/mobile_wrapper.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final issuerController = TextEditingController();
  final cardNameController = TextEditingController();
  final numberController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();
  final cvvController = TextEditingController();
  final holderNameController = TextEditingController();
  CardNetwork? network = CardNetwork.values.first;
  CardType type = CardType.values.first;
  CardColorScheme? colorScheme;
  late final CardViewModel card;

  @override
  void initState() {
    super.initState();
    card = CardViewModel();
    card.type = type;
    card.network = network;
  }

  @override
  void dispose() {
    issuerController.dispose();
    cardNameController.dispose();
    numberController.dispose();
    monthController.dispose();
    yearController.dispose();
    cvvController.dispose();
    holderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        appBar: MyAppbar.build(context, title: 'Add Card', back: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: CardTile(
                type: CardTileType.preview,
                card: card.toModel(id: ''),
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
                        _buildBuildIssuerField(),
                        _buildNetworkField(),
                        _buildCardNumberField(),
                        _buildCardNameField(),
                        _buildValidityAndCVVFields(),
                        _buildCardHolderField(),
                        _buildCardTypeField(),
                        const SizedBox(height: 24),
                        _buildSaveButton(context),
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

  Row _buildValidityAndCVVFields() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildMonthField()),
        const SizedBox(width: 8),
        Expanded(flex: 1, child: _buildYearField()),
        const SizedBox(width: 8),
        Expanded(flex: 1, child: _buildCVVField()),
      ],
    );
  }

  TextFormField _buildCVVField() {
    return TextFormField(
      controller: cvvController,
      decoration: const InputDecoration(labelText: 'CVV'),
      keyboardType: TextInputType.number,
      maxLength: 4,
      onChanged: (_) {
        card.cvv = cvvController.text;
        setState(() {});
      },
    );
  }

  TextFormField _buildYearField() {
    return TextFormField(
      controller: yearController,
      decoration: const InputDecoration(labelText: 'YY'),
      keyboardType: TextInputType.number,
      maxLength: 2,
      onChanged: (v) {
        card.year = int.tryParse(v);
        setState(() {});
      },
    );
  }

  TextFormField _buildMonthField() {
    return TextFormField(
      controller: monthController,
      decoration: const InputDecoration(labelText: 'MM'),
      keyboardType: TextInputType.number,
      maxLength: 2,
      onChanged: (_) {
        card.month = int.tryParse(monthController.text);
        setState(() {});
      },
    );
  }

  ElevatedButton _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // TODO: Add your card saving logic here, e.g. call provider/service
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card saved!')),
          );
          Navigator.of(context).pop();
        }
      },
      child: const Text('Save Card'),
    );
  }

  DropdownButtonFormField<CardType> _buildCardTypeField() {
    return DropdownButtonFormField<CardType>(
      value: type,
      items: CardType.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
          .toList(),
      onChanged: (v) {
        setState(() {
          CardType c = CardType.values.firstWhere((e) => e == (v ?? type));
          card.type = c;
          type = c;
        });
      },
      decoration: const InputDecoration(labelText: 'Card Type'),
    );
  }

  TextFormField _buildCardHolderField() {
    return TextFormField(
      controller: holderNameController,
      decoration:
          const InputDecoration(labelText: 'Cardholder Name (optional)'),
      onChanged: (_) {
        card.holderName = holderNameController.text;
        setState(() {});
      },
    );
  }

  TextFormField _buildCardNameField() {
    return TextFormField(
      controller: cardNameController,
      decoration: const InputDecoration(labelText: 'Card Name'),
      onChanged: (_) {
        card.cardName = cardNameController.text;
        setState(() {});
      },
    );
  }

  Center _buildCardNumberField() {
    return Center(
      child: TextFormField(
        controller: numberController,
        decoration: const InputDecoration(labelText: 'Card Number'),
        keyboardType: TextInputType.number,
        onChanged: (_) {
          card.number = numberController.text;
          setState(() {});
        },
        validator: (v) =>
            (v == null || v.trim().length < 12) ? 'Invalid' : null,
      ),
    );
  }

  DropdownButtonFormField<CardNetwork> _buildNetworkField() {
    return DropdownButtonFormField<CardNetwork>(
      value: network,
      items: CardNetwork.values
          .map((n) =>
              DropdownMenuItem(value: n, child: Text(n.name.toUpperCase())))
          .toList(),
      onChanged: (v) {
        CardNetwork c =
            CardNetwork.values.firstWhere((e) => e == (v ?? network));
        card.network = c;
        setState(() => network = c);
      },
      decoration: const InputDecoration(labelText: 'Card Network'),
    );
  }

  TextFormField _buildBuildIssuerField() {
    return TextFormField(
      controller: issuerController,
      decoration: const InputDecoration(labelText: 'Issuer (Bank, etc)'),
      onChanged: (_) {
        card.issuer = issuerController.text;
        setState(() {});
      },
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
    final last =
        number.length >= 4 ? number.substring(number.length - 4) : number;
    return '•••• •••• •••• $last';
  }

  @override
  Widget build(BuildContext context) {
    final bg = colorScheme?.bgColor != null
        ? Color(colorScheme!.bgColor)
        : Theme.of(context).colorScheme.primary;
    final txt = colorScheme?.textColor != null
        ? Color(colorScheme!.textColor)
        : Colors.white;
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
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 16,
              offset: Offset(0, 6)),
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
                  child: Text(bankName ?? '',
                      style: textTheme.titleMedium?.copyWith(color: txt)),
                ),
                Text(network?.name.toUpperCase() ?? '',
                    style: textTheme.titleMedium?.copyWith(color: txt)),
              ],
            ),
            const SizedBox(height: 10),
            // Row 2: Card Number (masked) centered
            Center(
              child: Text(
                masked
                    ? (cardNumber.isEmpty
                        ? '•••• •••• •••• 0000'
                        : _maskedDisplay(cardNumber))
                    : (cardNumber.isEmpty ? '0000 0000 0000 0000' : cardNumber),
                style: textTheme.headlineSmall?.copyWith(
                    color: txt, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Row 3: Card Name (left), Expiry and CVV (right)
            Row(
              children: [
                Expanded(
                  child: Text(cardName ?? '',
                      style: textTheme.bodyLarge?.copyWith(color: txt)),
                ),
                Text(
                  ((month != null && year != null)
                          ? '${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}'
                          : '') +
                      ((cvv != null && cvv!.isNotEmpty)
                          ? '  ${cvv!.padRight(3, '•')}'
                          : ''),
                  style: textTheme.bodyLarge?.copyWith(color: txt),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 4: Cardholder Name (left), Card Type (right)
            Row(
              children: [
                Expanded(
                  child: Text(holderName?.toUpperCase() ?? '',
                      style: textTheme.bodyLarge?.copyWith(color: txt)),
                ),
                Text(cardType.name.toUpperCase(),
                    style: textTheme.bodyLarge?.copyWith(color: txt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
