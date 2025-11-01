
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/card.dart';
import '../data/provider/card_provider.dart';
import '../models/card_tile_detail_visibility.dart';
import '../widgets/card_tile.dart';
import '../enums/card_tile_type.dart';
import '../widgets/my_appbar.dart';

class CardDetailScreen extends StatefulWidget {
  final String cardId;
  const CardDetailScreen({super.key, required this.cardId});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  CardModel? card;
  @override
  void initState() {
    super.initState();
    card = context.read<CardProvider>().getById(widget.cardId);
    // No local state, provider handles toggles
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.build(context, title: 'Card Details', back: true),
      body: _displayBody(context),
    );
  }

  Widget _displayBody(BuildContext context) {
    if (card == null) return const Center(child: Text('Card not found.'));
    return Consumer<CardProvider>(
      builder: (context, provider, _) {
        return ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            CardTile(
              card: card!,
              type: CardTileType.detailed,
              detailVisibility: CardTileDetailVisibility(
                showNumber: provider.showNumber,
                showCVV: provider.showCVV,
                showExpiry: provider.showExpiry,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _copyButton(context, label: 'Number', value: card!.cardNumber),
                _copyButton(context, label: 'Expiry', value: card!.getExpiryDisplayText),
                _copyButton(context, label: 'CVV', value: card!.cvv),
              ],
            ),
            const SizedBox(height: 16),
            _toggleRow(context),
          ],
        );
      },
    );
  }

  Widget _toggleRow(BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: false);
    return Column(
      children: [
        SwitchListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: const Text('Show Number'),
          value: provider.showNumber,
          onChanged: (v) => provider.setShowNumber(v),
        ),
        SwitchListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: const Text('Show Expiry'),
          value: provider.showExpiry,
          onChanged: (v) => provider.setShowExpiry(v),
        ),
        SwitchListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: const Text('Show CVV'),
          value: provider.showCVV,
          onChanged: (v) => provider.setShowCVV(v),
        ),
      ],
    );
  }

  Widget _copyButton(BuildContext context, {required String label, required String value}) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.copy, size: 18),
      label: Text(label),
      onPressed: value.isEmpty
          ? null
          : () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label copied!')),
                );
              }
            },
    );
  }
}
