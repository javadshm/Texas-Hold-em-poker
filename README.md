# Texas Hold'em Poker

A full-stack Texas Hold'em poker application with hand evaluation, comparison, and Monte Carlo probability calculation.

## Tech Stack

- **Backend**: Go 1.21
- **Frontend**: Flutter/Dart (web)
- **API**: REST (JSON over HTTP)
- **Docker**: For containerization

## Features

1. **Hand Evaluation**: Evaluate the best 5-card poker hand from 7 cards (2 player + 5 community)
2. **Hand Comparison**: Compare two players' hands and determine the winner
3. **Monte Carlo Simulation**: Calculate win probability through simulation

## Project Structure

```
.
├── backend/
│   ├── main.go              # HTTP server with CORS
│   ├── go.mod               # Go dependencies
│   ├── Dockerfile           # Docker configuration
│   ├── poker/
│   │   ├── card.go          # Card parsing and representation
│   │   ├── deck.go          # Deck creation, shuffle, deal
│   │   ├── hand.go          # Hand evaluation logic
│   │   ├── compare.go       # Hand comparison logic
│   │   ├── compare_test.go  # 65 test cases from spreadsheet
│   │   └── montecarlo.go    # Monte Carlo simulation
│   └── api/
│       └── handlers.go      # REST API handlers
├── frontend/
│   ├── lib/
│   │   ├── main.dart        # Flutter app entry point
│   │   ├── services/
│   │   │   └── poker_api.dart    # REST API client
│   │   └── screens/
│   │       └── home_screen.dart  # Main UI with 3 tabs
│   ├── web/                 # Web configuration
│   └── pubspec.yaml         # Flutter dependencies
├── docker-compose.yml       # Docker Compose configuration
└── README.md               # This file
```

## Card Format

Cards are specified as 2-character strings: `{Suit}{Rank}`

- **Suits**: `H` (Heart), `D` (Diamond), `C` (Club), `S` (Spade)
- **Ranks**: `2-9`, `T` (Ten), `J` (Jack), `Q` (Queen), `K` (King), `A` (Ace)
- **Examples**: `HA` = Heart-Ace, `S7` = Spade-7, `CT` = Club-Ten

## Hand Rankings (lowest to highest)

1. High Card
2. One Pair
3. Two Pairs
4. Three of a Kind
5. Straight
6. Flush
7. Full House
8. Four of a Kind
9. Straight Flush
10. Royal Flush

## API Documentation

### Base URL

```
http://localhost:8080
```

### 1. POST `/api/evaluate`

Evaluate a single hand.

**Request:**
```json
{
  "playerCards": ["HA", "HK"],
  "communityCards": ["H2", "H3", "H4", "S5", "D6"]
}
```

**Response:**
```json
{
  "bestHand": ["HA", "HK", "H4", "H3", "H2"],
  "handRank": "Flush",
  "handRankName": "Flush"
}
```

### 2. POST `/api/compare`

Compare two hands and determine winner.

**Request:**
```json
{
  "player1Cards": ["SK", "CA"],
  "player2Cards": ["HA", "SQ"],
  "communityCards": ["D6", "S9", "H4", "S3", "C2"]
}
```

**Response:**
```json
{
  "player1Hand": ["CA", "SK", "S9", "D6", "H4"],
  "player1Rank": "High Card",
  "player1RankName": "High Card",
  "player2Hand": ["HA", "SQ", "S9", "D6", "H4"],
  "player2Rank": "High Card",
  "player2RankName": "High Card",
  "winner": 1
}
```

- `winner`: `1` if player 1 wins, `2` if player 2 wins, `0` for tie

### 3. POST `/api/montecarlo`

Run Monte Carlo simulation to calculate win probability.

**Request:**
```json
{
  "playerCards": ["HA", "HK"],
  "communityCards": [],
  "numPlayers": 4,
  "numSimulations": 10000
}
```

**Response:**
```json
{
  "winProbability": 0.394,
  "tieProbability": 0.016,
  "lossProbability": 0.59,
  "simulations": 10000
}
```

**Parameters:**
- `playerCards`: Your 2 hole cards (required)
- `communityCards`: 0, 3, 4, or 5 community cards (optional)
- `numPlayers`: Number of players (2-10)
- `numSimulations`: Number of simulations to run (1-100000)

### 4. GET `/health`

Health check endpoint.

**Response:**
```
OK
```

## Running the Application

### Prerequisites

- Go 1.21 or later
- Flutter 3.0 or later (for frontend development)
- Docker and Docker Compose (for containerized deployment)

### Running the Backend (Go)

```bash
cd backend
go run main.go
```

The server will start on `http://localhost:8080`

**Environment Variables:**
- `ALLOWED_ORIGIN`: CORS allowed origin (default: `*` for development). For production, set to your frontend URL (e.g., `https://yourapp.com`)

**Production Example:**
```bash
ALLOWED_ORIGIN=https://yourapp.com go run main.go
```

### Running the Frontend (Flutter Web)

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The web app will open in Chrome and connect to the backend at `http://localhost:8080`

### Using Docker Compose

```bash
docker-compose up --build
```

This will:
1. Build the backend Docker image
2. Start the backend on port 8080

For the frontend, you'll need to run Flutter separately or serve the built web files.

### Building the Backend

```bash
cd backend
go build -o poker-server .
./poker-server
```

### Building the Frontend for Production

```bash
cd frontend
flutter build web
```

The built files will be in `frontend/build/web/`. Serve these with any web server.

## Running Tests

### Backend Tests

All 65 test cases from the professor's spreadsheet are implemented:

```bash
cd backend
go test -v ./poker
```

**Test Coverage:**
- High Card tests (rows 2-7)
- One Pair tests (rows 9-14)
- Two Pairs tests (rows 16-21)
- Three of a Kind tests (rows 23-28)
- Straight tests (rows 30-35)
- Flush tests (rows 37-42)
- Full House tests (rows 44-49)
- Four of a Kind tests (rows 51-56)
- Straight Flush tests (rows 58-63)
- Royal Flush test (row 65)

### Running Specific Tests

```bash
# Run only High Card tests
go test -v ./poker -run TestHighCard

# Run only Straight Flush tests
go test -v ./poker -run TestStraightFlush
```

## Example Usage

### 1. Evaluate a Flush

```bash
curl -X POST http://localhost:8080/api/evaluate \
  -H "Content-Type: application/json" \
  -d '{
    "playerCards": ["HA", "HK"],
    "communityCards": ["H2", "H3", "H4", "S5", "D6"]
  }'
```

### 2. Compare Two High Card Hands

```bash
curl -X POST http://localhost:8080/api/compare \
  -H "Content-Type: application/json" \
  -d '{
    "player1Cards": ["SK", "CA"],
    "player2Cards": ["HA", "SQ"],
    "communityCards": ["D6", "S9", "H4", "S3", "C2"]
  }'
```

### 3. Calculate Win Probability (Pre-flop)

```bash
curl -X POST http://localhost:8080/api/montecarlo \
  -H "Content-Type: application/json" \
  -d '{
    "playerCards": ["HA", "HK"],
    "communityCards": [],
    "numPlayers": 4,
    "numSimulations": 10000
  }'
```

## Special Rules

- **Ace-Low Straight (Wheel)**: A-2-3-4-5 is a valid straight, with Ace counting as 1
- **Royal Flush**: Ace-high straight flush (10-J-Q-K-A of same suit)
- **Board Plays**: When the best hand is entirely on the community cards, all players tie

## Development

### Adding New Features

1. Backend: Add new handlers in `backend/api/handlers.go`
2. Frontend: Add new UI components in `frontend/lib/screens/`
3. Tests: Add tests in `backend/poker/*_test.go`

### Code Style

- Go: Follow standard Go conventions (use `gofmt`)
- Dart: Follow Flutter/Dart style guide (use `dart format`)

## License

This is an educational project for Texas Hold'em poker hand evaluation.
