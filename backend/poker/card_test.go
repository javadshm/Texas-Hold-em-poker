package poker

import (
	"testing"
)

func TestParseCard(t *testing.T) {
	tests := []struct {
		input    string
		expected Card
		hasError bool
	}{
		{"HA", Card{Hearts, Ace}, false},
		{"S7", Card{Spades, Seven}, false},
		{"CT", Card{Clubs, Ten}, false},
		{"DK", Card{Diamonds, King}, false},
		{"H2", Card{Hearts, Two}, false},
		{"", Card{}, true},
		{"X", Card{}, true},
		{"ABC", Card{}, true},
		{"HX", Card{}, true},
		{"XA", Card{}, true},
	}

	for _, tt := range tests {
		result, err := ParseCard(tt.input)
		if tt.hasError {
			if err == nil {
				t.Errorf("Expected error for input %q, got none", tt.input)
			}
		} else {
			if err != nil {
				t.Errorf("Unexpected error for input %q: %v", tt.input, err)
			}
			if result.Suit != tt.expected.Suit || result.Rank != tt.expected.Rank {
				t.Errorf("For input %q, expected %v, got %v", tt.input, tt.expected, result)
			}
		}
	}
}

func TestCardString(t *testing.T) {
	tests := []struct {
		card     Card
		expected string
	}{
		{Card{Hearts, Ace}, "HA"},
		{Card{Spades, Seven}, "S7"},
		{Card{Clubs, Ten}, "CT"},
		{Card{Diamonds, King}, "DK"},
		{Card{Hearts, Two}, "H2"},
	}

	for _, tt := range tests {
		result := tt.card.String()
		if result != tt.expected {
			t.Errorf("Expected %s, got %s", tt.expected, result)
		}
	}
}

func TestParseCards(t *testing.T) {
	input := []string{"HA", "HK", "HQ", "HJ", "HT"}
	expected := []Card{
		{Hearts, Ace},
		{Hearts, King},
		{Hearts, Queen},
		{Hearts, Jack},
		{Hearts, Ten},
	}

	result, err := ParseCards(input)
	if err != nil {
		t.Fatalf("Unexpected error: %v", err)
	}

	if len(result) != len(expected) {
		t.Fatalf("Expected %d cards, got %d", len(expected), len(result))
	}

	for i := range result {
		if result[i] != expected[i] {
			t.Errorf("Card %d: expected %v, got %v", i, expected[i], result[i])
		}
	}
}
