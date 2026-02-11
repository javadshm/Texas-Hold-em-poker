package poker

import (
	"math/rand"
	"time"
)

// Deck represents a deck of 52 cards
type Deck struct {
	Cards []Card
}

// NewDeck creates a new standard 52-card deck
func NewDeck() *Deck {
	deck := &Deck{
		Cards: make([]Card, 0, 52),
	}

	for suit := Hearts; suit <= Spades; suit++ {
		for rank := Two; rank <= Ace; rank++ {
			deck.Cards = append(deck.Cards, Card{Suit: suit, Rank: rank})
		}
	}

	return deck
}

// Shuffle shuffles the deck
func (d *Deck) Shuffle() {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	r.Shuffle(len(d.Cards), func(i, j int) {
		d.Cards[i], d.Cards[j] = d.Cards[j], d.Cards[i]
	})
}

// Deal deals n cards from the deck
func (d *Deck) Deal(n int) []Card {
	if n > len(d.Cards) {
		n = len(d.Cards)
	}
	cards := d.Cards[:n]
	d.Cards = d.Cards[n:]
	return cards
}

// Remove removes specific cards from the deck
func (d *Deck) Remove(cards []Card) {
	cardMap := make(map[Card]bool)
	for _, card := range cards {
		cardMap[card] = true
	}

	newCards := make([]Card, 0, len(d.Cards))
	for _, card := range d.Cards {
		if !cardMap[card] {
			newCards = append(newCards, card)
		}
	}
	d.Cards = newCards
}
