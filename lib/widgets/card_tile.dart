import 'package:flutter/material.dart';

import '../enums/card_tile_type.dart';
import '../models/card.dart';
import '../data/ui_constants.dart';
import 'card_display_text.dart';

typedef EditCallback = void Function(CardModel card);
typedef DeleteCallback = void Function(String id);

class CardTile extends StatelessWidget {
  final CardModel card;
  final CardTileType type;
  final EditCallback? onEdit;
  final DeleteCallback? onDelete;

  const CardTile(
      {super.key,
      required this.card,
      this.onEdit,
      this.onDelete,
      this.type = CardTileType.masked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: UIConstants.cardVerticalMargin),
      decoration: _getCardDecoration(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: UIConstants.cardPaddingHorizontal,
            vertical: UIConstants.cardPaddingVertical),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayCardNameIssuerNetworkAndType(),
            _displayCardNumber(),
            _displayCardHolderExpiryAndCVV(),
          ],
        ),
      ),
    );
  }

  Row _displayCardHolderExpiryAndCVV() {
    String cardHolderName = _holderDisplayText;
    String expiryText = _getExpiryDisplayText;
    String cvvText = _getCVVDisplayText;

    String? cardHolderSecondary;
    String? expirySecondry;
    String? cvvSecondry;

    if (cardHolderName.isNotEmpty) cardHolderSecondary = 'Card Holder';
    if (expiryText.isNotEmpty) expirySecondry = 'Expiry';
    if (cvvText.isNotEmpty) cvvSecondry = 'CVV';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CardDisplayText(
            primaryText: _holderDisplayText,
            secondaryText: cardHolderSecondary,
            scaleSecondaryText: true),
        if (type == CardTileType.preview || type == CardTileType.detailed)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CardDisplayText(
                    primaryText: expiryText, secondaryText: expirySecondry),
                SizedBox(width: 16),
                CardDisplayText(
                    primaryText: cvvText, secondaryText: cvvSecondry),
              ],
            ),
          ),
      ],
    );
  }

  Padding _displayCardNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(
          _cardNumberDisplayText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _displayCardNameIssuerNetworkAndType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardDisplayText(
            primaryText: _cardNameDisplayText,
            secondaryText: _issuerDisplayText),
        CardDisplayText(
            primaryText: _networkDisplayText,
            secondaryText: _getCardTypeDisplayText,
            alignment: CrossAxisAlignment.end)
      ],
    );
  }

  String get _issuerDisplayText {
    String displayText = '';
    if (card.issuer != null && card.issuer!.isNotEmpty) {
      displayText += card.issuer!;
    }
    if (displayText.isNotEmpty &&
        card.cardName != null &&
        card.cardName!.isNotEmpty) {
      displayText = 'by $displayText';
    }
    return displayText;
  }

  String get _networkDisplayText => _getDisplayText(card.network?.name);
  String get _holderDisplayText => _getDisplayText(card.holderName);
  String get _getCardTypeDisplayText => _getDisplayText(card.type.name);
  String get _getCVVDisplayText => _getDisplayText(card.cvv);

  String get _getExpiryDisplayText {
    String seperator = '';
    String month = '';
    String year = '';

    if (card.expiryMonth != 0 && card.expiryYear != 0) seperator = '/';
    if (card.expiryMonth != 0) month = '${card.expiryMonth}';
    if (card.expiryYear != 0) year = '${card.expiryYear}';
    return '$month$seperator$year';
  }

  String get _cardNumberDisplayText {
    return type == CardTileType.masked
        ? card.maskedNumberText
        : card.cardNumberText;
  }

  String get _cardNameDisplayText => _getDisplayText(card.cardName);
  _getDisplayText(String? text, {bool upper = true}) {
    if (text == null) return '';
    if (upper) return text.toUpperCase();
    return text;
  }

  BoxDecoration _getCardDecoration(ThemeData theme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(UIConstants.cardRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary
              .withValues(alpha: UIConstants.cardGradientOpacity),
          Color.lerp(theme.colorScheme.primary, Colors.black, 0.25)!
              .withValues(alpha: UIConstants.cardGradientOpacity),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(UIConstants.cardShadowAlpha),
          blurRadius: UIConstants.cardShadowBlur,
          offset: Offset(0, UIConstants.cardShadowOffsetY),
        ),
      ],
    );
  }
}
