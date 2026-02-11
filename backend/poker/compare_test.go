package poker

import (
	"testing"
)

// Test helper function
func testCompare(t *testing.T, rowNum int, community, player1, player2 []string, expectedResult int, comment string) {
	t.Helper()

	commCards, err := ParseCards(community)
	if err != nil {
		t.Fatalf("Row %d: Failed to parse community cards: %v", rowNum, err)
	}

	p1Cards, err := ParseCards(player1)
	if err != nil {
		t.Fatalf("Row %d: Failed to parse player1 cards: %v", rowNum, err)
	}

	p2Cards, err := ParseCards(player2)
	if err != nil {
		t.Fatalf("Row %d: Failed to parse player2 cards: %v", rowNum, err)
	}

	result := CompareHands(p1Cards, p2Cards, commCards)

	if result.Winner != expectedResult {
		t.Errorf("Row %d: Expected winner %d, got %d. Comment: %s\nHand1: %s (%v)\nHand2: %s (%v)",
			rowNum, expectedResult, result.Winner, comment,
			result.Hand1.RankDesc, result.Hand1.Value,
			result.Hand2.RankDesc, result.Hand2.Value)
	}
}

// High Card Tests (Rows 2-7)
func TestHighCard(t *testing.T) {
	// Row 2
	testCompare(t, 2,
		[]string{"D6", "S9", "H4", "S3", "C2"},
		[]string{"SK", "CA"},
		[]string{"HA", "SQ"},
		1, "SK > SQ")

	// Row 3 - permutation
	testCompare(t, 3,
		[]string{"D6", "S9", "H4", "S3", "C2"},
		[]string{"SK", "CA"},
		[]string{"HA", "SQ"},
		1, "permutation: hand1=D6 CA H4 SK S9, hand2=HA D6 SQ H4 S9")

	// Row 4
	testCompare(t, 4,
		[]string{"D6", "S9", "H4", "S3", "C2"},
		[]string{"SK", "CA"},
		[]string{"HA", "CK"},
		0, "tie")

	// Row 5 - permutation
	testCompare(t, 5,
		[]string{"D6", "S9", "H4", "S3", "C2"},
		[]string{"SK", "CA"},
		[]string{"HA", "CK"},
		0, "permutation")

	// Row 6
	testCompare(t, 6,
		[]string{"D6", "S9", "H4", "H3", "H2"},
		[]string{"C7", "DQ"},
		[]string{"C8", "DJ"},
		1, "DQ > DJ")

	// Row 7 - permutation
	testCompare(t, 7,
		[]string{"D6", "S9", "H4", "H3", "H2"},
		[]string{"C7", "DQ"},
		[]string{"C8", "DJ"},
		1, "permutation")
}

// One Pair Tests (Rows 9-14)
func TestOnePair(t *testing.T) {
	// Row 9
	testCompare(t, 9,
		[]string{"SK", "HT", "C8", "C7", "D2"},
		[]string{"DK", "C5"},
		[]string{"H8", "D5"},
		1, "K > 8")

	// Row 10 - permutation
	testCompare(t, 10,
		[]string{"SK", "HT", "C8", "C7", "D2"},
		[]string{"DK", "C5"},
		[]string{"H8", "D5"},
		1, "permutation")

	// Row 11
	testCompare(t, 11,
		[]string{"SK", "HT", "C8", "C7", "D2"},
		[]string{"DK", "C4"},
		[]string{"HK", "D5"},
		0, "K = K")

	// Row 12 - permutation
	testCompare(t, 12,
		[]string{"SK", "HT", "C8", "C7", "D2"},
		[]string{"DK", "C4"},
		[]string{"HK", "D5"},
		0, "permutation")

	// Row 13
	testCompare(t, 13,
		[]string{"HA", "DA", "ST", "C9", "D4"},
		[]string{"D5", "C6"},
		[]string{"H7", "C2"},
		2, "7 > 6")

	// Row 14 - permutation
	testCompare(t, 14,
		[]string{"HA", "DA", "ST", "C9", "D4"},
		[]string{"D5", "C6"},
		[]string{"H7", "C2"},
		2, "permutation")
}

// Two Pairs Tests (Rows 16-21)
func TestTwoPairs(t *testing.T) {
	// Row 16
	testCompare(t, 16,
		[]string{"SA", "DQ", "CK", "D6", "H6"},
		[]string{"HA", "C3"},
		[]string{"CQ", "H4"},
		1, "A > Q")

	// Row 17 - permutation
	testCompare(t, 17,
		[]string{"SA", "DQ", "CK", "D6", "H6"},
		[]string{"HA", "C3"},
		[]string{"CQ", "H4"},
		1, "permutation")

	// Row 18
	testCompare(t, 18,
		[]string{"SA", "DQ", "CK", "D6", "H6"},
		[]string{"HQ", "C3"},
		[]string{"SQ", "H4"},
		0, "tie")

	// Row 19 - permutation
	testCompare(t, 19,
		[]string{"SA", "DQ", "CK", "D6", "H6"},
		[]string{"HQ", "C3"},
		[]string{"SQ", "H4"},
		0, "permutation")

	// Row 20
	testCompare(t, 20,
		[]string{"SA", "DQ", "CK", "D6", "H5"},
		[]string{"HQ", "C6"},
		[]string{"CA", "HK"},
		2, "A > Q")

	// Row 21 - permutation
	testCompare(t, 21,
		[]string{"SA", "DQ", "CK", "D6", "H5"},
		[]string{"HQ", "C6"},
		[]string{"CA", "HK"},
		2, "permutation")
}

// Three of a Kind Tests (Rows 23-28)
func TestThreeOfAKind(t *testing.T) {
	// Row 23
	testCompare(t, 23,
		[]string{"SA", "D3", "H2", "C8", "SJ"},
		[]string{"HJ", "SJ"},
		[]string{"C3", "H3"},
		1, "J > 3")

	// Row 24 - permutation
	testCompare(t, 24,
		[]string{"SA", "D3", "H2", "C8", "SJ"},
		[]string{"HJ", "SJ"},
		[]string{"C3", "H3"},
		1, "permutation")

	// Row 25
	testCompare(t, 25,
		[]string{"SA", "D3", "H3", "C8", "SJ"},
		[]string{"C3", "S2"},
		[]string{"S3", "H2"},
		0, "3 = 3")

	// Row 26 - permutation
	testCompare(t, 26,
		[]string{"SA", "D3", "H3", "C8", "SJ"},
		[]string{"C3", "S2"},
		[]string{"S3", "H2"},
		0, "permutation")

	// Row 27
	testCompare(t, 27,
		[]string{"HA", "SA", "DA", "H3", "HT"},
		[]string{"S2", "S5"},
		[]string{"H2", "SK"},
		2, "K > T")

	// Row 28 - permutation
	testCompare(t, 28,
		[]string{"HA", "SA", "DA", "H3", "HT"},
		[]string{"S2", "S5"},
		[]string{"H2", "SK"},
		2, "permutation")
}

// Straight Tests (Rows 30-35)
func TestStraight(t *testing.T) {
	// Row 30
	testCompare(t, 30,
		[]string{"H3", "S4", "C5", "S6", "HT"},
		[]string{"D7", "HA"},
		[]string{"H2", "SA"},
		1, "7 > 6")

	// Row 31 - permutation
	testCompare(t, 31,
		[]string{"H3", "S4", "C5", "S6", "HT"},
		[]string{"D7", "HA"},
		[]string{"H2", "SA"},
		1, "permutation")

	// Row 32
	testCompare(t, 32,
		[]string{"H3", "S4", "C5", "S6", "HT"},
		[]string{"D7", "HA"},
		[]string{"H7", "SA"},
		0, "7 = 7")

	// Row 33 - permutation
	testCompare(t, 33,
		[]string{"H3", "S4", "C5", "S6", "HT"},
		[]string{"D7", "HA"},
		[]string{"H7", "SA"},
		0, "permutation")

	// Row 34
	testCompare(t, 34,
		[]string{"H2", "H3", "S4", "C5", "HT"},
		[]string{"HA", "S3"},
		[]string{"H6", "SA"},
		2, "6 > 5")

	// Row 35 - permutation
	testCompare(t, 35,
		[]string{"H2", "H3", "S4", "C5", "HT"},
		[]string{"HA", "S3"},
		[]string{"H6", "SA"},
		2, "permutation")
}

// Flush Tests (Rows 37-42)
func TestFlush(t *testing.T) {
	// Row 37
	testCompare(t, 37,
		[]string{"D3", "D6", "DT", "C5", "HQ"},
		[]string{"DK", "DA"},
		[]string{"D2", "DQ"},
		1, "A > Q")

	// Row 38 - permutation
	testCompare(t, 38,
		[]string{"D3", "D6", "DT", "C5", "HQ"},
		[]string{"DK", "DA"},
		[]string{"D2", "DQ"},
		1, "permutation")

	// Row 39
	testCompare(t, 39,
		[]string{"D3", "D6", "DT", "DJ", "DK"},
		[]string{"C3", "HA"},
		[]string{"S9", "HJ"},
		0, "player cards irrelevant for flush")

	// Row 40 - permutation
	testCompare(t, 40,
		[]string{"D3", "D6", "DT", "DJ", "DK"},
		[]string{"C3", "HA"},
		[]string{"S9", "HJ"},
		0, "permutation")

	// Row 41
	testCompare(t, 41,
		[]string{"D3", "D6", "DT", "C5", "HQ"},
		[]string{"D2", "D5"},
		[]string{"DJ", "DA"},
		2, "A > 5")

	// Row 42 - permutation
	testCompare(t, 42,
		[]string{"D3", "D6", "DT", "C5", "HQ"},
		[]string{"D2", "D5"},
		[]string{"DJ", "DA"},
		2, "permutation")
}

// Full House Tests (Rows 44-49)
func TestFullHouse(t *testing.T) {
	// Row 44
	testCompare(t, 44,
		[]string{"HQ", "SQ", "HT", "DT", "C3"},
		[]string{"DQ", "C2"},
		[]string{"CT", "C4"},
		1, "3×Q > 3×T")

	// Row 45 - permutation
	testCompare(t, 45,
		[]string{"HQ", "SQ", "HT", "DT", "C3"},
		[]string{"DQ", "C2"},
		[]string{"CT", "C4"},
		1, "permutation")

	// Row 46
	testCompare(t, 46,
		[]string{"SA", "HQ", "SQ", "HT", "D8"},
		[]string{"HA", "DQ"},
		[]string{"DA", "CQ"},
		0, "tie")

	// Row 47 - permutation
	testCompare(t, 47,
		[]string{"SA", "HQ", "SQ", "HT", "D8"},
		[]string{"HA", "DQ"},
		[]string{"DA", "CQ"},
		0, "permutation")

	// Row 48
	testCompare(t, 48,
		[]string{"HQ", "SQ", "HT", "DT", "C3"},
		[]string{"ST", "C2"},
		[]string{"CQ", "C4"},
		2, "3×Q > 3×T")

	// Row 49 - permutation
	testCompare(t, 49,
		[]string{"HQ", "SQ", "HT", "DT", "C3"},
		[]string{"ST", "C2"},
		[]string{"CQ", "C4"},
		2, "permutation")
}

// Four of a Kind Tests (Rows 51-56)
func TestFourOfAKind(t *testing.T) {
	// Row 51
	testCompare(t, 51,
		[]string{"HT", "ST", "CT", "DT", "HK"},
		[]string{"HA", "S7"},
		[]string{"DJ", "C5"},
		1, "A > K")

	// Row 52 - permutation
	testCompare(t, 52,
		[]string{"HT", "ST", "CT", "DT", "HK"},
		[]string{"HA", "S7"},
		[]string{"DJ", "C5"},
		1, "permutation")

	// Row 53
	testCompare(t, 53,
		[]string{"S5", "D5", "C5", "H5", "HA"},
		[]string{"CT", "HT"},
		[]string{"C4", "SQ"},
		0, "player cards irrelevant")

	// Row 54 - permutation
	testCompare(t, 54,
		[]string{"S5", "D5", "C5", "H5", "HA"},
		[]string{"CT", "HT"},
		[]string{"C4", "SQ"},
		0, "permutation")

	// Row 55
	testCompare(t, 55,
		[]string{"HT", "ST", "CT", "DT", "S8"},
		[]string{"C2", "C3"},
		[]string{"C5", "HK"},
		2, "K > 8")

	// Row 56 - permutation
	testCompare(t, 56,
		[]string{"HT", "ST", "CT", "DT", "S8"},
		[]string{"C2", "C3"},
		[]string{"C5", "HK"},
		2, "permutation")
}

// Straight Flush Tests (Rows 58-63)
func TestStraightFlush(t *testing.T) {
	// Row 58
	testCompare(t, 58,
		[]string{"H3", "H4", "H5", "H6", "HT"},
		[]string{"H7", "HA"},
		[]string{"H2", "SA"},
		1, "7 > 6")

	// Row 59 - permutation
	testCompare(t, 59,
		[]string{"H3", "H4", "H5", "H6", "HT"},
		[]string{"H7", "HA"},
		[]string{"H2", "SA"},
		1, "permutation")

	// Row 60
	testCompare(t, 60,
		[]string{"H3", "H4", "H5", "H6", "H7"},
		[]string{"HA", "ST"},
		[]string{"CQ", "D6"},
		0, "player cards irrelevant")

	// Row 61 - permutation
	testCompare(t, 61,
		[]string{"H3", "H4", "H5", "H6", "H7"},
		[]string{"HA", "ST"},
		[]string{"CQ", "D6"},
		0, "permutation")

	// Row 62
	testCompare(t, 62,
		[]string{"S7", "S8", "S9", "ST", "DK"},
		[]string{"S6", "C2"},
		[]string{"SJ", "D5"},
		2, "J > T")

	// Row 63 - permutation
	testCompare(t, 63,
		[]string{"S7", "S8", "S9", "ST", "DK"},
		[]string{"S6", "C2"},
		[]string{"SJ", "D5"},
		2, "permutation")
}

// Royal Flush Test (Row 65)
func TestRoyalFlush(t *testing.T) {
	// Row 65 - Royal Flush on board
	testCompare(t, 65,
		[]string{"DT", "DJ", "DQ", "DK", "DA"},
		[]string{"H2", "H3"},
		[]string{"C4", "C5"},
		0, "Royal Flush in community; player cards irrelevant")
}
