package poker

import (
	"fmt"
	"strings"
)

// Suit represents a card suit
type Suit int

const (
	Hearts Suit = iota
	Diamonds
	Clubs
	Spades
)

// Rank represents a card rank (2-14, where 14 is Ace)
type Rank int

const (
	Two Rank = iota + 2
	Three
	Four
	Five
	Six
	Seven
	Eight
	Nine
	Ten
	Jack
	Queen
	King
	Ace
)

// Card represents a playing card
type Card struct {
	Suit Suit
	Rank Rank
}

// ParseCard parses a card string like "HA" (Heart-Ace) or "S7" (Spade-7)
func ParseCard(s string) (Card, error) {
	s = strings.ToUpper(strings.TrimSpace(s))
	if len(s) != 2 {
		return Card{}, fmt.Errorf("invalid card format: %s", s)
	}

	// Parse suit (first character)
	var suit Suit
	switch s[0] {
	case 'H':
		suit = Hearts
	case 'D':
		suit = Diamonds
	case 'C':
		suit = Clubs
	case 'S':
		suit = Spades
	default:
		return Card{}, fmt.Errorf("invalid suit: %c", s[0])
	}

	// Parse rank (second character)
	var rank Rank
	switch s[1] {
	case '2':
		rank = Two
	case '3':
		rank = Three
	case '4':
		rank = Four
	case '5':
		rank = Five
	case '6':
		rank = Six
	case '7':
		rank = Seven
	case '8':
		rank = Eight
	case '9':
		rank = Nine
	case 'T':
		rank = Ten
	case 'J':
		rank = Jack
	case 'Q':
		rank = Queen
	case 'K':
		rank = King
	case 'A':
		rank = Ace
	default:
		return Card{}, fmt.Errorf("invalid rank: %c", s[1])
	}

	return Card{Suit: suit, Rank: rank}, nil
}

// ParseCards parses multiple card strings
func ParseCards(cards []string) ([]Card, error) {
	result := make([]Card, len(cards))
	for i, cardStr := range cards {
		card, err := ParseCard(cardStr)
		if err != nil {
			return nil, err
		}
		result[i] = card
	}
	return result, nil
}

// String returns a string representation of the card
func (c Card) String() string {
	suits := []string{"H", "D", "C", "S"}
	ranks := []string{"", "", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"}
	return suits[c.Suit] + ranks[c.Rank]
}
