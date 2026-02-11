package poker

import (
	"testing"
)

func TestEvaluateRoyalFlush(t *testing.T) {
	cards := []Card{
		{Hearts, Ten},
		{Hearts, Jack},
		{Hearts, Queen},
		{Hearts, King},
		{Hearts, Ace},
		{Spades, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != RoyalFlush {
		t.Errorf("Expected Royal Flush, got %s", hand.RankDesc)
	}
}

func TestEvaluateStraightFlush(t *testing.T) {
	cards := []Card{
		{Hearts, Three},
		{Hearts, Four},
		{Hearts, Five},
		{Hearts, Six},
		{Hearts, Seven},
		{Spades, Two},
		{Clubs, King},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != StraightFlush {
		t.Errorf("Expected Straight Flush, got %s", hand.RankDesc)
	}
}

func TestEvaluateWheelStraightFlush(t *testing.T) {
	// A-2-3-4-5 straight flush (wheel)
	cards := []Card{
		{Hearts, Ace},
		{Hearts, Two},
		{Hearts, Three},
		{Hearts, Four},
		{Hearts, Five},
		{Spades, King},
		{Clubs, Queen},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != StraightFlush {
		t.Errorf("Expected Straight Flush (wheel), got %s", hand.RankDesc)
	}
}

func TestEvaluateFourOfAKind(t *testing.T) {
	cards := []Card{
		{Hearts, King},
		{Diamonds, King},
		{Clubs, King},
		{Spades, King},
		{Hearts, Ace},
		{Diamonds, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != FourOfAKind {
		t.Errorf("Expected Four of a Kind, got %s", hand.RankDesc)
	}
}

func TestEvaluateFullHouse(t *testing.T) {
	cards := []Card{
		{Hearts, King},
		{Diamonds, King},
		{Clubs, King},
		{Hearts, Ace},
		{Diamonds, Ace},
		{Spades, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != FullHouse {
		t.Errorf("Expected Full House, got %s", hand.RankDesc)
	}
}

func TestEvaluateFlush(t *testing.T) {
	cards := []Card{
		{Hearts, Two},
		{Hearts, Five},
		{Hearts, Seven},
		{Hearts, Nine},
		{Hearts, King},
		{Spades, Ace},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != Flush {
		t.Errorf("Expected Flush, got %s", hand.RankDesc)
	}
}

func TestEvaluateStraight(t *testing.T) {
	cards := []Card{
		{Hearts, Five},
		{Diamonds, Six},
		{Clubs, Seven},
		{Spades, Eight},
		{Hearts, Nine},
		{Diamonds, King},
		{Clubs, Two},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != Straight {
		t.Errorf("Expected Straight, got %s", hand.RankDesc)
	}
}

func TestEvaluateWheelStraight(t *testing.T) {
	// A-2-3-4-5 straight (wheel)
	cards := []Card{
		{Hearts, Ace},
		{Diamonds, Two},
		{Clubs, Three},
		{Spades, Four},
		{Hearts, Five},
		{Diamonds, King},
		{Clubs, Queen},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != Straight {
		t.Errorf("Expected Straight (wheel), got %s", hand.RankDesc)
	}
}

func TestEvaluateThreeOfAKind(t *testing.T) {
	cards := []Card{
		{Hearts, King},
		{Diamonds, King},
		{Clubs, King},
		{Spades, Ace},
		{Hearts, Queen},
		{Diamonds, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != ThreeOfAKind {
		t.Errorf("Expected Three of a Kind, got %s", hand.RankDesc)
	}
}

func TestEvaluateTwoPairs(t *testing.T) {
	cards := []Card{
		{Hearts, King},
		{Diamonds, King},
		{Clubs, Queen},
		{Spades, Queen},
		{Hearts, Ace},
		{Diamonds, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != TwoPairs {
		t.Errorf("Expected Two Pairs, got %s", hand.RankDesc)
	}
}

func TestEvaluateOnePair(t *testing.T) {
	cards := []Card{
		{Hearts, King},
		{Diamonds, King},
		{Clubs, Queen},
		{Spades, Jack},
		{Hearts, Ten},
		{Diamonds, Two},
		{Clubs, Three},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != OnePair {
		t.Errorf("Expected One Pair, got %s", hand.RankDesc)
	}
}

func TestEvaluateHighCard(t *testing.T) {
	cards := []Card{
		{Hearts, Ace},
		{Diamonds, King},
		{Clubs, Queen},
		{Spades, Jack},
		{Hearts, Nine},
		{Diamonds, Seven},
		{Clubs, Two},
	}

	hand := EvaluateHand(cards)

	if hand.Rank != HighCard {
		t.Errorf("Expected High Card, got %s", hand.RankDesc)
	}
}
