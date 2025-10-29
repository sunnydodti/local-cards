import 'package:flutter/material.dart';

import '../models/card.dart';
import '../data/ui_constants.dart';

typedef EditCallback = void Function(CardModel card);
typedef DeleteCallback = void Function(String id);

class CardTile extends StatelessWidget {
  final CardModel card;
  final EditCallback? onEdit;
  final DeleteCallback? onDelete;

  const CardTile({super.key, required this.card, this.onEdit, this.onDelete});

  String _maskedDisplay(String number) {
    final last = number.length >= 4 ? number.substring(number.length - 4) : number;
    return '•••• •••• •••• $last';
  }

  String _networkFromIssuer(String? issuer) {
    if (issuer == null) return '';
    final b = issuer.toLowerCase();
    if (b.contains('visa')) return 'VISA';
    if (b.contains('master') || b.contains('mastercard')) return 'MASTERCARD';
    if (b.contains('amex') || b.contains('american')) return 'AMEX';
    if (b.contains('discover')) return 'DISCOVER';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: UIConstants.cardVerticalMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UIConstants.cardRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: UIConstants.cardGradientOpacity),
            Color.lerp(theme.colorScheme.primary, Colors.black, 0.25)!.withValues(alpha: UIConstants.cardGradientOpacity),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(UIConstants.cardShadowAlpha),
            blurRadius: UIConstants.cardShadowBlur,
            offset: Offset(0, UIConstants.cardShadowOffsetY),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: UIConstants.cardPaddingHorizontal, vertical: UIConstants.cardPaddingVertical),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Bank Name (left), Card Network (right)
            Row(
              children: [
                Expanded(
                  child: Text(
                    card.issuer ?? '',
                    style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                  ),
                ),
                Text(
                  _networkFromIssuer(card.issuer),
                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
              ],
            ),

            // Row 2: Card Number (masked) centered
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Text(
                  _maskedDisplay(card.cardNumber),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    letterSpacing: UIConstants.maskedLetterSpacing,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Row 3: Cardholder Name (left), Card Type (right)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Holder', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(card.holderName?.toUpperCase() ?? '', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Type', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(card.type.name.toUpperCase(), style: theme.textTheme.bodySmall?.copyWith(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
