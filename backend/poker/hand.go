package poker

import (
	"sort"
)

// HandRank represents the rank of a poker hand
type HandRank int

const (
	HighCard HandRank = iota + 1
	OnePair
	TwoPairs
	ThreeOfAKind
	Straight
	Flush
	FullHouse
	FourOfAKind
	StraightFlush
	RoyalFlush
)

// String returns the name of the hand rank
func (hr HandRank) String() string {
	names := []string{
		"", "High Card", "One Pair", "Two Pairs", "Three of a Kind",
		"Straight", "Flush", "Full House", "Four of a Kind",
		"Straight Flush", "Royal Flush",
	}
	return names[hr]
}

// Hand represents an evaluated poker hand
type Hand struct {
	Cards    []Card
	Rank     HandRank
	RankDesc string
	Value    []int // For comparison: [HandRank, primary, secondary, kickers...]
}

// EvaluateHand finds the best 5-card hand from 7 cards
func EvaluateHand(cards []Card) Hand {
	if len(cards) < 5 {
		return Hand{}
	}

	// Try all combinations of 5 cards from 7
	var bestHand Hand
	combinations := generateCombinations(cards, 5)

	for _, combo := range combinations {
		hand := evaluateFiveCards(combo)
		if compareHands(hand, bestHand) > 0 {
			bestHand = hand
		}
	}

	return bestHand
}

// generateCombinations generates all combinations of k cards from cards
func generateCombinations(cards []Card, k int) [][]Card {
	var result [][]Card
	var current []Card

	var backtrack func(start int)
	backtrack = func(start int) {
		if len(current) == k {
			combo := make([]Card, k)
			copy(combo, current)
			result = append(result, combo)
			return
		}

		for i := start; i < len(cards); i++ {
			current = append(current, cards[i])
			backtrack(i + 1)
			current = current[:len(current)-1]
		}
	}

	backtrack(0)
	return result
}

// evaluateFiveCards evaluates exactly 5 cards
func evaluateFiveCards(cards []Card) Hand {
	if len(cards) != 5 {
		return Hand{}
	}

	// Sort cards by rank (descending)
	sorted := make([]Card, 5)
	copy(sorted, cards)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].Rank > sorted[j].Rank
	})

	hand := Hand{Cards: sorted}

	// Check for flush
	isFlush := true
	for i := 1; i < 5; i++ {
		if sorted[i].Suit != sorted[0].Suit {
			isFlush = false
			break
		}
	}

	// Check for straight
	isStraight, straightHigh := checkStraight(sorted)

	if isFlush && isStraight {
		if straightHigh == Ace {
			hand.Rank = RoyalFlush
			hand.RankDesc = "Royal Flush"
			hand.Value = []int{int(RoyalFlush), int(Ace)}
		} else {
			hand.Rank = StraightFlush
			hand.RankDesc = "Straight Flush"
			hand.Value = []int{int(StraightFlush), int(straightHigh)}
		}
		return hand
	}

	// Count ranks
	rankCounts := make(map[Rank]int)
	for _, card := range sorted {
		rankCounts[card.Rank]++
	}

	// Convert to sorted list of (count, rank) pairs
	type countRank struct {
		count int
		rank  Rank
	}
	var counts []countRank
	for rank, count := range rankCounts {
		counts = append(counts, countRank{count, rank})
	}
	sort.Slice(counts, func(i, j int) bool {
		if counts[i].count != counts[j].count {
			return counts[i].count > counts[j].count
		}
		return counts[i].rank > counts[j].rank
	})

	// Check for four of a kind
	if counts[0].count == 4 {
		hand.Rank = FourOfAKind
		hand.RankDesc = "Four of a Kind"
		hand.Value = []int{int(FourOfAKind), int(counts[0].rank), int(counts[1].rank)}
		return hand
	}

	// Check for full house
	if counts[0].count == 3 && counts[1].count == 2 {
		hand.Rank = FullHouse
		hand.RankDesc = "Full House"
		hand.Value = []int{int(FullHouse), int(counts[0].rank), int(counts[1].rank)}
		return hand
	}

	// Check for flush
	if isFlush {
		hand.Rank = Flush
		hand.RankDesc = "Flush"
		hand.Value = []int{int(Flush)}
		for _, card := range sorted {
			hand.Value = append(hand.Value, int(card.Rank))
		}
		return hand
	}

	// Check for straight
	if isStraight {
		hand.Rank = Straight
		hand.RankDesc = "Straight"
		hand.Value = []int{int(Straight), int(straightHigh)}
		return hand
	}

	// Check for three of a kind
	if counts[0].count == 3 {
		hand.Rank = ThreeOfAKind
		hand.RankDesc = "Three of a Kind"
		hand.Value = []int{int(ThreeOfAKind), int(counts[0].rank)}
		for i := 1; i < len(counts); i++ {
			hand.Value = append(hand.Value, int(counts[i].rank))
		}
		return hand
	}

	// Check for two pairs
	if counts[0].count == 2 && counts[1].count == 2 {
		hand.Rank = TwoPairs
		hand.RankDesc = "Two Pairs"
		hand.Value = []int{int(TwoPairs), int(counts[0].rank), int(counts[1].rank), int(counts[2].rank)}
		return hand
	}

	// Check for one pair
	if counts[0].count == 2 {
		hand.Rank = OnePair
		hand.RankDesc = "One Pair"
		hand.Value = []int{int(OnePair), int(counts[0].rank)}
		for i := 1; i < len(counts); i++ {
			hand.Value = append(hand.Value, int(counts[i].rank))
		}
		return hand
	}

	// High card
	hand.Rank = HighCard
	hand.RankDesc = "High Card"
	hand.Value = []int{int(HighCard)}
	for _, card := range sorted {
		hand.Value = append(hand.Value, int(card.Rank))
	}

	return hand
}

// checkStraight checks if cards form a straight and returns the high card
func checkStraight(sorted []Card) (bool, Rank) {
	// Check normal straight
	if sorted[0].Rank == sorted[1].Rank+1 &&
		sorted[1].Rank == sorted[2].Rank+1 &&
		sorted[2].Rank == sorted[3].Rank+1 &&
		sorted[3].Rank == sorted[4].Rank+1 {
		return true, sorted[0].Rank
	}

	// Check for A-2-3-4-5 (wheel)
	if sorted[0].Rank == Ace &&
		sorted[1].Rank == Five &&
		sorted[2].Rank == Four &&
		sorted[3].Rank == Three &&
		sorted[4].Rank == Two {
		return true, Five // Ace-low straight is ranked by 5
	}

	return false, 0
}

// compareHands compares two hands. Returns 1 if h1 > h2, -1 if h1 < h2, 0 if equal
func compareHands(h1, h2 Hand) int {
	if h1.Rank == 0 {
		return -1
	}
	if h2.Rank == 0 {
		return 1
	}

	// Compare values
	maxLen := len(h1.Value)
	if len(h2.Value) > maxLen {
		maxLen = len(h2.Value)
	}

	for i := 0; i < maxLen; i++ {
		v1 := 0
		if i < len(h1.Value) {
			v1 = h1.Value[i]
		}
		v2 := 0
		if i < len(h2.Value) {
			v2 = h2.Value[i]
		}

		if v1 > v2 {
			return 1
		}
		if v1 < v2 {
			return -1
		}
	}

	return 0
}
