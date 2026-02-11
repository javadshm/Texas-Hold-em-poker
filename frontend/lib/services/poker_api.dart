import 'dart:convert';
import 'package:http/http.dart' as http;

class PokerApi {
  final String baseUrl;

  PokerApi({this.baseUrl = 'https://poker-backend-q18i.onrender.com'});

  Future<EvaluateResponse> evaluate(
      List<String> playerCards, List<String> communityCards) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/evaluate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'playerCards': playerCards,
        'communityCards': communityCards,
      }),
    );

    if (response.statusCode == 200) {
      return EvaluateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to evaluate hand: ${response.body}');
    }
  }

  Future<CompareResponse> compare(
      List<String> player1Cards,
      List<String> player2Cards,
      List<String> communityCards) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/compare'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'player1Cards': player1Cards,
        'player2Cards': player2Cards,
        'communityCards': communityCards,
      }),
    );

    if (response.statusCode == 200) {
      return CompareResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to compare hands: ${response.body}');
    }
  }

  Future<MonteCarloResponse> monteCarlo(
      List<String> playerCards,
      List<String> communityCards,
      int numPlayers,
      int numSimulations) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/montecarlo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'playerCards': playerCards,
        'communityCards': communityCards,
        'numPlayers': numPlayers,
        'numSimulations': numSimulations,
      }),
    );

    if (response.statusCode == 200) {
      return MonteCarloResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to run Monte Carlo: ${response.body}');
    }
  }
}

class EvaluateResponse {
  final List<String> bestHand;
  final String handRank;
  final String handRankName;

  EvaluateResponse({
    required this.bestHand,
    required this.handRank,
    required this.handRankName,
  });

  factory EvaluateResponse.fromJson(Map<String, dynamic> json) {
    return EvaluateResponse(
      bestHand: List<String>.from(json['bestHand']),
      handRank: json['handRank'],
      handRankName: json['handRankName'],
    );
  }
}

class CompareResponse {
  final List<String> player1Hand;
  final String player1Rank;
  final String player1RankName;
  final List<String> player2Hand;
  final String player2Rank;
  final String player2RankName;
  final int winner;

  CompareResponse({
    required this.player1Hand,
    required this.player1Rank,
    required this.player1RankName,
    required this.player2Hand,
    required this.player2Rank,
    required this.player2RankName,
    required this.winner,
  });

  factory CompareResponse.fromJson(Map<String, dynamic> json) {
    return CompareResponse(
      player1Hand: List<String>.from(json['player1Hand']),
      player1Rank: json['player1Rank'],
      player1RankName: json['player1RankName'],
      player2Hand: List<String>.from(json['player2Hand']),
      player2Rank: json['player2Rank'],
      player2RankName: json['player2RankName'],
      winner: json['winner'],
    );
  }
}

class MonteCarloResponse {
  final double winProbability;
  final double tieProbability;
  final double lossProbability;
  final int simulations;

  MonteCarloResponse({
    required this.winProbability,
    required this.tieProbability,
    required this.lossProbability,
    required this.simulations,
  });

  factory MonteCarloResponse.fromJson(Map<String, dynamic> json) {
    return MonteCarloResponse(
      winProbability: json['winProbability'].toDouble(),
      tieProbability: json['tieProbability'].toDouble(),
      lossProbability: json['lossProbability'].toDouble(),
      simulations: json['simulations'],
    );
  }
}