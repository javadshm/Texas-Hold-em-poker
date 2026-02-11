package poker

import (
	"testing"
)

func TestMonteCarloBasic(t *testing.T) {
	// Test with pocket aces pre-flop
	playerCards := []Card{
		{Hearts, Ace},
		{Spades, Ace},
	}
	communityCards := []Card{}

	result := MonteCarlo(playerCards, communityCards, 2, 100)

	// Pocket aces should have high win probability heads-up
	if result.WinProbability < 0.6 {
		t.Errorf("Expected win probability > 0.6 for pocket aces, got %.2f", result.WinProbability)
	}

	// Check that probabilities sum to 1
	total := result.WinProbability + result.TieProbability + result.LossProbability
	if total < 0.99 || total > 1.01 {
		t.Errorf("Probabilities should sum to ~1.0, got %.3f", total)
	}

	if result.Simulations != 100 {
		t.Errorf("Expected 100 simulations, got %d", result.Simulations)
	}
}

func TestMonteCarloWithCommunityCards(t *testing.T) {
	// Test with flush draw
	playerCards := []Card{
		{Hearts, Ace},
		{Hearts, King},
	}
	communityCards := []Card{
		{Hearts, Two},
		{Hearts, Three},
		{Hearts, Four},
	}

	result := MonteCarlo(playerCards, communityCards, 2, 100)

	// Should have very high win probability with flush made
	if result.WinProbability < 0.7 {
		t.Errorf("Expected win probability > 0.7 with flush, got %.2f", result.WinProbability)
	}
}

func TestMonteCarloMultiplePlayers(t *testing.T) {
	// Test with more players
	playerCards := []Card{
		{Hearts, Ace},
		{Spades, Ace},
	}
	communityCards := []Card{}

	result := MonteCarlo(playerCards, communityCards, 5, 100)

	// Win probability should decrease with more players
	if result.WinProbability > 0.6 {
		t.Errorf("Expected win probability < 0.6 with 5 players, got %.2f", result.WinProbability)
	}
}
