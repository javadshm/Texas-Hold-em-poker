package api

import (
	"encoding/json"
	"net/http"

	"github.com/javadshm/Texas-Hold-em-poker/backend/poker"
)

// EvaluateRequest represents the request for /api/evaluate
type EvaluateRequest struct {
	PlayerCards    []string `json:"playerCards"`
	CommunityCards []string `json:"communityCards"`
}

// EvaluateResponse represents the response for /api/evaluate
type EvaluateResponse struct {
	BestHand     []string `json:"bestHand"`
	HandRank     string   `json:"handRank"`
	HandRankName string   `json:"handRankName"`
}

// CompareRequest represents the request for /api/compare
type CompareRequest struct {
	Player1Cards   []string `json:"player1Cards"`
	Player2Cards   []string `json:"player2Cards"`
	CommunityCards []string `json:"communityCards"`
}

// CompareResponse represents the response for /api/compare
type CompareResponse struct {
	Player1Hand     []string `json:"player1Hand"`
	Player1Rank     string   `json:"player1Rank"`
	Player1RankName string   `json:"player1RankName"`
	Player2Hand     []string `json:"player2Hand"`
	Player2Rank     string   `json:"player2Rank"`
	Player2RankName string   `json:"player2RankName"`
	Winner          int      `json:"winner"` // 1, 2, or 0 for tie
}

// MonteCarloRequest represents the request for /api/montecarlo
type MonteCarloRequest struct {
	PlayerCards    []string `json:"playerCards"`
	CommunityCards []string `json:"communityCards"`
	NumPlayers     int      `json:"numPlayers"`
	NumSimulations int      `json:"numSimulations"`
}

// MonteCarloResponse represents the response for /api/montecarlo
type MonteCarloResponse struct {
	WinProbability  float64 `json:"winProbability"`
	TieProbability  float64 `json:"tieProbability"`
	LossProbability float64 `json:"lossProbability"`
	Simulations     int     `json:"simulations"`
}

// HandleEvaluate handles POST /api/evaluate
func HandleEvaluate(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req EvaluateRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Parse cards
	playerCards, err := poker.ParseCards(req.PlayerCards)
	if err != nil {
		http.Error(w, "Invalid player cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	communityCards, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		http.Error(w, "Invalid community cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	// Evaluate hand
	allCards := append(playerCards, communityCards...)
	hand := poker.EvaluateHand(allCards)

	// Convert best hand to strings
	bestHandStrs := make([]string, len(hand.Cards))
	for i, card := range hand.Cards {
		bestHandStrs[i] = card.String()
	}

	response := EvaluateResponse{
		BestHand:     bestHandStrs,
		HandRank:     hand.Rank.String(),
		HandRankName: hand.RankDesc,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// HandleCompare handles POST /api/compare
func HandleCompare(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req CompareRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Parse cards
	player1Cards, err := poker.ParseCards(req.Player1Cards)
	if err != nil {
		http.Error(w, "Invalid player1 cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	player2Cards, err := poker.ParseCards(req.Player2Cards)
	if err != nil {
		http.Error(w, "Invalid player2 cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	communityCards, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		http.Error(w, "Invalid community cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	// Compare hands
	result := poker.CompareHands(player1Cards, player2Cards, communityCards)

	// Convert hands to strings
	player1HandStrs := make([]string, len(result.Hand1.Cards))
	for i, card := range result.Hand1.Cards {
		player1HandStrs[i] = card.String()
	}

	player2HandStrs := make([]string, len(result.Hand2.Cards))
	for i, card := range result.Hand2.Cards {
		player2HandStrs[i] = card.String()
	}

	response := CompareResponse{
		Player1Hand:     player1HandStrs,
		Player1Rank:     result.Hand1.Rank.String(),
		Player1RankName: result.Hand1.RankDesc,
		Player2Hand:     player2HandStrs,
		Player2Rank:     result.Hand2.Rank.String(),
		Player2RankName: result.Hand2.RankDesc,
		Winner:          result.Winner,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

// HandleMonteCarlo handles POST /api/montecarlo
func HandleMonteCarlo(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req MonteCarloRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	// Parse cards
	playerCards, err := poker.ParseCards(req.PlayerCards)
	if err != nil {
		http.Error(w, "Invalid player cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	communityCards, err := poker.ParseCards(req.CommunityCards)
	if err != nil {
		http.Error(w, "Invalid community cards: "+err.Error(), http.StatusBadRequest)
		return
	}

	// Validate input
	if req.NumPlayers < 2 || req.NumPlayers > 10 {
		http.Error(w, "Number of players must be between 2 and 10", http.StatusBadRequest)
		return
	}

	if req.NumSimulations < 1 || req.NumSimulations > 100000 {
		http.Error(w, "Number of simulations must be between 1 and 100000", http.StatusBadRequest)
		return
	}

	// Run Monte Carlo simulation
	result := poker.MonteCarlo(playerCards, communityCards, req.NumPlayers, req.NumSimulations)

	response := MonteCarloResponse{
		WinProbability:  result.WinProbability,
		TieProbability:  result.TieProbability,
		LossProbability: result.LossProbability,
		Simulations:     result.Simulations,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
