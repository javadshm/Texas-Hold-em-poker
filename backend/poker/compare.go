package poker

// CompareResult represents the result of comparing two hands
type CompareResult struct {
	Hand1  Hand
	Hand2  Hand
	Winner int // 1 if hand1 wins, 2 if hand2 wins, 0 if tie
}

// CompareHands compares two 7-card hands
func CompareHands(player1Cards, player2Cards, communityCards []Card) CompareResult {
	// Combine player cards with community cards
	hand1Cards := append([]Card{}, player1Cards...)
	hand1Cards = append(hand1Cards, communityCards...)

	hand2Cards := append([]Card{}, player2Cards...)
	hand2Cards = append(hand2Cards, communityCards...)

	// Evaluate both hands
	hand1 := EvaluateHand(hand1Cards)
	hand2 := EvaluateHand(hand2Cards)

	// Compare
	comparison := compareHands(hand1, hand2)

	result := CompareResult{
		Hand1: hand1,
		Hand2: hand2,
	}

	if comparison > 0 {
		result.Winner = 1
	} else if comparison < 0 {
		result.Winner = 2
	} else {
		result.Winner = 0
	}

	return result
}
