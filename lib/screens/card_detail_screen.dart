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
  bool showNumber = true;
  bool showCVV = true;
  bool showExpiry = true;
  CardModel? card;
  
  @override
  void initState() {
    card = context.read<CardProvider>().getById(widget.cardId);
    super.initState();
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        CardTile(
          card: card!,
          type: CardTileType.detailed,
          detailVisibility: CardTileDetailVisibility(
            showNumber: showNumber,
            showCVV: showCVV,
            showExpiry: showExpiry,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _copyButton(context, label: 'Number', value: card!.cardNumber),
            _copyButton(context, label: 'Expiry', value: card!.getExpiryDisplayText),
            _copyButton(context, label: 'CVV', value: card!.cvv ?? ''),
          ],
        ),
        const SizedBox(height: 24),
        _toggleRow(),
      ],
    );
  }

  Widget _toggleRow() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Show Number'),
          value: showNumber,
          onChanged: (v) => setState(() => showNumber = v),
        ),
        SwitchListTile(
          title: const Text('Show Expiry'),
          value: showExpiry,
          onChanged: (v) => setState(() => showExpiry = v),
        ),
        SwitchListTile(
          title: const Text('Show CVV'),
          value: showCVV,
          onChanged: (v) => setState(() => showCVV = v),
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
