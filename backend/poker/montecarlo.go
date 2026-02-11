package poker

import (
	"math/rand"
	"time"
)

// MonteCarloResult represents the result of a Monte Carlo simulation
type MonteCarloResult struct {
	WinProbability  float64
	TieProbability  float64
	LossProbability float64
	Simulations     int
}

// MonteCarlo runs a Monte Carlo simulation to calculate win probability
func MonteCarlo(playerCards []Card, communityCards []Card, numPlayers, numSimulations int) MonteCarloResult {
	if numPlayers < 2 {
		numPlayers = 2
	}

	wins := 0
	ties := 0
	losses := 0

	r := rand.New(rand.NewSource(time.Now().UnixNano()))

	for sim := 0; sim < numSimulations; sim++ {
		// Create a new deck and remove known cards
		deck := NewDeck()
		allKnownCards := append([]Card{}, playerCards...)
		allKnownCards = append(allKnownCards, communityCards...)
		deck.Remove(allKnownCards)

		// Shuffle the remaining deck
		r.Shuffle(len(deck.Cards), func(i, j int) {
			deck.Cards[i], deck.Cards[j] = deck.Cards[j], deck.Cards[i]
		})

		// Complete community cards if needed
		simCommunityCards := make([]Card, len(communityCards))
		copy(simCommunityCards, communityCards)

		cardsNeeded := 5 - len(communityCards)
		if cardsNeeded > 0 {
			simCommunityCards = append(simCommunityCards, deck.Deal(cardsNeeded)...)
		}

		// Deal cards to opponents
		opponentHands := make([][]Card, numPlayers-1)
		for i := 0; i < numPlayers-1; i++ {
			opponentHands[i] = deck.Deal(2)
		}

		// Evaluate player's hand
		playerFullHand := append([]Card{}, playerCards...)
		playerFullHand = append(playerFullHand, simCommunityCards...)
		playerHand := EvaluateHand(playerFullHand)

		// Evaluate opponent hands
		playerWon := true
		tieCount := 0

		for _, oppCards := range opponentHands {
			oppFullHand := append([]Card{}, oppCards...)
			oppFullHand = append(oppFullHand, simCommunityCards...)
			oppHand := EvaluateHand(oppFullHand)

			comparison := compareHands(playerHand, oppHand)
			if comparison < 0 {
				playerWon = false
				break
			} else if comparison == 0 {
				tieCount++
			}
		}

		if !playerWon {
			losses++
		} else if tieCount > 0 {
			ties++
		} else {
			wins++
		}
	}

	return MonteCarloResult{
		WinProbability:  float64(wins) / float64(numSimulations),
		TieProbability:  float64(ties) / float64(numSimulations),
		LossProbability: float64(losses) / float64(numSimulations),
		Simulations:     numSimulations,
	}
}
