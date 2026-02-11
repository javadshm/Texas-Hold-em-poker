import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String? cardCode; // e.g., "HA" for Ace of Hearts, null for empty
  final VoidCallback? onTap;
  final bool disabled;
  final double width;
  final double height;

  const CardWidget({
    super.key,
    this.cardCode,
    this.onTap,
    this.disabled = false,
    this.width = 60,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (cardCode == null || cardCode!.isEmpty) {
      // Empty card slot
      return GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white38, size: 24),
          ),
        ),
      );
    }

    final suit = cardCode![0]; // H, D, C, S
    final rank = cardCode![1]; // 2-9, T, J, Q, K, A

    final suitSymbol = _getSuitSymbol(suit);
    final isRed = suit == 'H' || suit == 'D';
    final color = isRed ? Colors.red : Colors.black;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: disabled ? Colors.grey : Colors.black26,
            width: 1,
          ),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getRankDisplay(rank),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: disabled ? Colors.grey.shade600 : color,
              ),
            ),
            Text(
              suitSymbol,
              style: TextStyle(
                fontSize: 24,
                color: disabled ? Colors.grey.shade600 : color,
              ),
            ),
          ],
        ),
      ),
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

  String _getRankDisplay(String rank) {
    switch (rank.toUpperCase()) {
      case 'T':
        return '10';
      case 'J':
        return 'J';
      case 'Q':
        return 'Q';
      case 'K':
        return 'K';
      case 'A':
        return 'A';
      default:
        return rank;
    }
  }
}
