import 'package:flutter/material.dart';
import 'card_widget.dart';

class CardSelectorDialog extends StatelessWidget {
  final Set<String> disabledCards; // Cards already selected

  const CardSelectorDialog({
    super.key,
    required this.disabledCards,
  });

  static Future<String?> show(
    BuildContext context, {
    required Set<String> disabledCards,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => CardSelectorDialog(disabledCards: disabledCards),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suits = ['H', 'D', 'C', 'S'];
    final ranks = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'];

    return Dialog(
      backgroundColor: const Color(0xFF0A5F38),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Clear button
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop('CLEAR'),
              icon: const Icon(Icons.clear),
              label: const Text('Clear Selection'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: suits.map((suit) {
                    return Column(
                      children: [
                        _buildSuitRow(context, suit, ranks),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuitRow(BuildContext context, String suit, List<String> ranks) {
    final suitName = _getSuitName(suit);
    final suitSymbol = _getSuitSymbol(suit);
    final isRed = suit == 'H' || suit == 'D';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '$suitSymbol $suitName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isRed ? Colors.red.shade300 : Colors.white,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ranks.map((rank) {
            final cardCode = '$suit$rank';
            final isDisabled = disabledCards.contains(cardCode);

            return CardWidget(
              cardCode: cardCode,
              disabled: isDisabled,
              width: 50,
              height: 70,
              onTap: isDisabled
                  ? null
                  : () {
                      Navigator.of(context).pop(cardCode);
                    },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getSuitSymbol(String suit) {
    switch (suit.toUpperCase()) {
      case 'H':
        return '♥';
      case 'D':
        return '♦';
      case 'C':
        return '♣';
      case 'S':
        return '♠';
      default:
        return suit;
    }
  }

  String _getSuitName(String suit) {
    switch (suit.toUpperCase()) {
      case 'H':
        return 'Hearts';
      case 'D':
        return 'Diamonds';
      case 'C':
        return 'Clubs';
      case 'S':
        return 'Spades';
      default:
        return suit;
    }
  }
}
