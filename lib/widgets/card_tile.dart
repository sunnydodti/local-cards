import 'package:flutter/material.dart';

import '../models/card.dart';
import 'colored_text_box.dart';

typedef EditCallback = void Function(CardModel card);
typedef DeleteCallback = void Function(String id);

class CardTile extends StatelessWidget {
  final CardModel card;
  final EditCallback? onEdit;
  final DeleteCallback? onDelete;

  const CardTile({super.key, required this.card, this.onEdit, this.onDelete});

  Color _typeColor(CardType type) {
    switch (type) {
      case CardType.credit:
        return Colors.green;
      case CardType.debit:
        return Colors.orange;
      case CardType.other:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.holderName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(card.maskedNumber, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ColoredTextBox(
                        text: card.type.name,
                        color: _typeColor(card.type),
                        fontSize: 12,
                        upperCase: false,
                      ),
                      const SizedBox(width: 8),
                      if (card.brand != null) Text(card.brand!),
                      const Spacer(),
                      Text('${card.expiryMonth.toString().padLeft(2, '0')}/${card.expiryYear.toString().substring(2)}'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => onEdit?.call(card),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDelete?.call(card.id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
