import 'package:flutter/material.dart';
import '../services/poker_api.dart';
import '../widgets/card_widget.dart';
import '../widgets/card_selector_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PokerApi _api = PokerApi();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.casino, size: 28),
            const SizedBox(width: 8),
            const Text('Texas Hold\'em Poker', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'EVALUATE', icon: Icon(Icons.analytics_outlined, size: 20)),
            Tab(text: 'COMPARE', icon: Icon(Icons.compare_arrows, size: 20)),
            Tab(text: 'MONTE CARLO', icon: Icon(Icons.insights, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          EvaluateTab(api: _api),
          CompareTab(api: _api),
          MonteCarloTab(api: _api),
        ],
      ),
    );
  }
}

// Card Slot Widget - clickable card display
class CardSlot extends StatelessWidget {
  final String? cardCode;
  final VoidCallback onTap;
  final Set<String> disabledCards;

  const CardSlot({
    super.key,
    this.cardCode,
    required this.onTap,
    required this.disabledCards,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CardWidget(
        cardCode: cardCode,
        disabled: false,
        width: 60,
        height: 80,
      ),
    );
  }
}

// Evaluate Tab
class EvaluateTab extends StatefulWidget {
  final PokerApi api;

  const EvaluateTab({super.key, required this.api});

  @override
  State<EvaluateTab> createState() => _EvaluateTabState();
}

class _EvaluateTabState extends State<EvaluateTab> {
  String? _player1;
  String? _player2;
  String? _comm1;
  String? _comm2;
  String? _comm3;
  String? _comm4;
  String? _comm5;

  String _result = '';
  List<String> _bestHandCards = [];
  bool _loading = false;

  Set<String> get _selectedCards => {
        if (_player1 != null) _player1!,
        if (_player2 != null) _player2!,
        if (_comm1 != null) _comm1!,
        if (_comm2 != null) _comm2!,
        if (_comm3 != null) _comm3!,
        if (_comm4 != null) _comm4!,
        if (_comm5 != null) _comm5!,
      };

  void _loadExample() {
    setState(() {
      // Row 2 - High Card: Player: SK, CA; Community: D6, S9, H4, S3, C2
      _player1 = 'SK';
      _player2 = 'CA';
      _comm1 = 'D6';
      _comm2 = 'S9';
      _comm3 = 'H4';
      _comm4 = 'S3';
      _comm5 = 'C2';
    });
  }

  Future<void> _selectCard(String? currentCard, Function(String?) setter) async {
    final selectedCard = await CardSelectorDialog.show(
      context,
      disabledCards: _selectedCards.where((c) => c != currentCard).toSet(),
    );

    if (selectedCard != null) {
      if (selectedCard == 'CLEAR') {
        setState(() => setter(null));
      } else {
        setState(() => setter(selectedCard));
      }
    }
  }

  Future<void> _evaluate() async {
    if (_player1 == null || _player2 == null ||
        _comm1 == null || _comm2 == null || _comm3 == null ||
        _comm4 == null || _comm5 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all cards')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _result = '';
      _bestHandCards = [];
    });

    try {
      final playerCards = [_player1!, _player2!];
      final communityCards = [_comm1!, _comm2!, _comm3!, _comm4!, _comm5!];

      final response = await widget.api.evaluate(playerCards, communityCards);

      setState(() {
        _result = response.handRankName;
        _bestHandCards = response.bestHand;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A5F38),
            const Color(0xFF084130),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Load Example Button
            OutlinedButton.icon(
              onPressed: _loadExample,
              icon: const Icon(Icons.star),
              label: const Text('Load Example'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD4AF37),
                side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Player Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Player Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardSlot(
                          cardCode: _player1,
                          onTap: () => _selectCard(_player1, (c) => _player1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _player2,
                          onTap: () => _selectCard(_player2, (c) => _player2 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Community Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        CardSlot(
                          cardCode: _comm1,
                          onTap: () => _selectCard(_comm1, (c) => _comm1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm2,
                          onTap: () => _selectCard(_comm2, (c) => _comm2 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm3,
                          onTap: () => _selectCard(_comm3, (c) => _comm3 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm4,
                          onTap: () => _selectCard(_comm4, (c) => _comm4 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm5,
                          onTap: () => _selectCard(_comm5, (c) => _comm5 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Evaluate Button
            ElevatedButton(
              onPressed: _loading ? null : _evaluate,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('EVALUATE HAND'),
            ),
            const SizedBox(height: 20),

            // Results
            if (_result.isNotEmpty)
              Card(
                elevation: 8,
                color: const Color(0xFF084130),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFD4AF37),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _result,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_bestHandCards.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Best Hand:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: _bestHandCards
                              .map((card) => CardWidget(
                                    cardCode: card,
                                    width: 50,
                                    height: 70,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Compare Tab
class CompareTab extends StatefulWidget {
  final PokerApi api;

  const CompareTab({super.key, required this.api});

  @override
  State<CompareTab> createState() => _CompareTabState();
}

class _CompareTabState extends State<CompareTab> {
  String? _p1c1;
  String? _p1c2;
  String? _p2c1;
  String? _p2c2;
  String? _comm1;
  String? _comm2;
  String? _comm3;
  String? _comm4;
  String? _comm5;

  int _winner = 0;
  List<String> _player1Hand = [];
  String _player1RankName = '';
  List<String> _player2Hand = [];
  String _player2RankName = '';
  bool _loading = false;

  Set<String> get _selectedCards => {
        if (_p1c1 != null) _p1c1!,
        if (_p1c2 != null) _p1c2!,
        if (_p2c1 != null) _p2c1!,
        if (_p2c2 != null) _p2c2!,
        if (_comm1 != null) _comm1!,
        if (_comm2 != null) _comm2!,
        if (_comm3 != null) _comm3!,
        if (_comm4 != null) _comm4!,
        if (_comm5 != null) _comm5!,
      };

  void _loadExample() {
    setState(() {
      // Row 44 - Full House comparison: P1: DQ, C2; P2: CT, C4; Community: HQ, SQ, HT, DT, C3
      _p1c1 = 'DQ';
      _p1c2 = 'C2';
      _p2c1 = 'CT';
      _p2c2 = 'C4';
      _comm1 = 'HQ';
      _comm2 = 'SQ';
      _comm3 = 'HT';
      _comm4 = 'DT';
      _comm5 = 'C3';
    });
  }

  Future<void> _selectCard(String? currentCard, Function(String?) setter) async {
    final selectedCard = await CardSelectorDialog.show(
      context,
      disabledCards: _selectedCards.where((c) => c != currentCard).toSet(),
    );

    if (selectedCard != null) {
      if (selectedCard == 'CLEAR') {
        setState(() => setter(null));
      } else {
        setState(() => setter(selectedCard));
      }
    }
  }

  Future<void> _compare() async {
    if (_p1c1 == null || _p1c2 == null ||
        _p2c1 == null || _p2c2 == null ||
        _comm1 == null || _comm2 == null || _comm3 == null ||
        _comm4 == null || _comm5 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all cards')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _winner = 0;
      _player1Hand = [];
      _player2Hand = [];
    });

    try {
      final player1Cards = [_p1c1!, _p1c2!];
      final player2Cards = [_p2c1!, _p2c2!];
      final communityCards = [_comm1!, _comm2!, _comm3!, _comm4!, _comm5!];

      final response = await widget.api.compare(player1Cards, player2Cards, communityCards);

      setState(() {
        _winner = response.winner;
        _player1Hand = response.player1Hand;
        _player1RankName = response.player1RankName;
        _player2Hand = response.player2Hand;
        _player2RankName = response.player2RankName;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A5F38),
            const Color(0xFF084130),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Load Example Button
            OutlinedButton.icon(
              onPressed: _loadExample,
              icon: const Icon(Icons.star),
              label: const Text('Load Example'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD4AF37),
                side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Player 1 Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Player 1 Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardSlot(
                          cardCode: _p1c1,
                          onTap: () => _selectCard(_p1c1, (c) => _p1c1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _p1c2,
                          onTap: () => _selectCard(_p1c2, (c) => _p1c2 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Player 2 Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Player 2 Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardSlot(
                          cardCode: _p2c1,
                          onTap: () => _selectCard(_p2c1, (c) => _p2c1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _p2c2,
                          onTap: () => _selectCard(_p2c2, (c) => _p2c2 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Community Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        CardSlot(
                          cardCode: _comm1,
                          onTap: () => _selectCard(_comm1, (c) => _comm1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm2,
                          onTap: () => _selectCard(_comm2, (c) => _comm2 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm3,
                          onTap: () => _selectCard(_comm3, (c) => _comm3 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm4,
                          onTap: () => _selectCard(_comm4, (c) => _comm4 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm5,
                          onTap: () => _selectCard(_comm5, (c) => _comm5 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Compare Button
            ElevatedButton(
              onPressed: _loading ? null : _compare,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('COMPARE HANDS'),
            ),
            const SizedBox(height: 20),

            // Results
            if (_winner != 0) ...[
              // Winner announcement
              Card(
                elevation: 8,
                color: const Color(0xFF084130),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _winner == 0
                            ? Icons.handshake
                            : Icons.emoji_events,
                        color: const Color(0xFFD4AF37),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _winner == 1
                            ? 'Player 1 Wins!'
                            : _winner == 2
                                ? 'Player 2 Wins!'
                                : 'It\'s a Tie!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Player 1 Result
              Card(
                elevation: 8,
                color: _winner == 1
                    ? Colors.green.shade900
                    : _winner == 2
                        ? Colors.red.shade900
                        : const Color(0xFF084130),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Player 1',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _winner == 1
                                  ? Colors.lightGreenAccent
                                  : Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (_winner == 1)
                            const Icon(Icons.check_circle,
                                color: Colors.lightGreenAccent),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _player1RankName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _player1Hand
                            .map((card) => CardWidget(
                                  cardCode: card,
                                  width: 50,
                                  height: 70,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Player 2 Result
              Card(
                elevation: 8,
                color: _winner == 2
                    ? Colors.green.shade900
                    : _winner == 1
                        ? Colors.red.shade900
                        : const Color(0xFF084130),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Player 2',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _winner == 2
                                  ? Colors.lightGreenAccent
                                  : Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (_winner == 2)
                            const Icon(Icons.check_circle,
                                color: Colors.lightGreenAccent),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _player2RankName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _player2Hand
                            .map((card) => CardWidget(
                                  cardCode: card,
                                  width: 50,
                                  height: 70,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Monte Carlo Tab
class MonteCarloTab extends StatefulWidget {
  final PokerApi api;

  const MonteCarloTab({super.key, required this.api});

  @override
  State<MonteCarloTab> createState() => _MonteCarloTabState();
}

class _MonteCarloTabState extends State<MonteCarloTab> {
  String? _player1;
  String? _player2;
  String? _comm1;
  String? _comm2;
  String? _comm3;
  String? _comm4;
  String? _comm5;

  int _numPlayers = 4;
  int _numSimulations = 10000;

  double _winProbability = 0;
  double _tieProbability = 0;
  double _lossProbability = 0;
  bool _loading = false;
  bool _hasResults = false;

  Set<String> get _selectedCards => {
        if (_player1 != null) _player1!,
        if (_player2 != null) _player2!,
        if (_comm1 != null) _comm1!,
        if (_comm2 != null) _comm2!,
        if (_comm3 != null) _comm3!,
        if (_comm4 != null) _comm4!,
        if (_comm5 != null) _comm5!,
      };

  void _loadExample() {
    setState(() {
      // Pocket Aces: Player: HA, SA; No community cards; 4 players; 10000 simulations
      _player1 = 'HA';
      _player2 = 'SA';
      _comm1 = null;
      _comm2 = null;
      _comm3 = null;
      _comm4 = null;
      _comm5 = null;
      _numPlayers = 4;
      _numSimulations = 10000;
    });
  }

  Future<void> _selectCard(String? currentCard, Function(String?) setter) async {
    final selectedCard = await CardSelectorDialog.show(
      context,
      disabledCards: _selectedCards.where((c) => c != currentCard).toSet(),
    );

    if (selectedCard != null) {
      if (selectedCard == 'CLEAR') {
        setState(() => setter(null));
      } else {
        setState(() => setter(selectedCard));
      }
    }
  }

  Future<void> _simulate() async {
    if (_player1 == null || _player2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select player cards')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _hasResults = false;
    });

    try {
      final playerCards = [_player1!, _player2!];
      final communityCards = <String>[
        if (_comm1 != null) _comm1!,
        if (_comm2 != null) _comm2!,
        if (_comm3 != null) _comm3!,
        if (_comm4 != null) _comm4!,
        if (_comm5 != null) _comm5!,
      ];

      final response = await widget.api.monteCarlo(
        playerCards,
        communityCards,
        _numPlayers,
        _numSimulations,
      );

      setState(() {
        _winProbability = response.winProbability;
        _tieProbability = response.tieProbability;
        _lossProbability = response.lossProbability;
        _hasResults = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A5F38),
            const Color(0xFF084130),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Load Example Button
            OutlinedButton.icon(
              onPressed: _loadExample,
              icon: const Icon(Icons.star),
              label: const Text('Load Example (Pocket Aces)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD4AF37),
                side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Player Cards
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Player Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardSlot(
                          cardCode: _player1,
                          onTap: () => _selectCard(_player1, (c) => _player1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _player2,
                          onTap: () => _selectCard(_player2, (c) => _player2 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Community Cards (Optional)
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Community Cards (Optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        CardSlot(
                          cardCode: _comm1,
                          onTap: () => _selectCard(_comm1, (c) => _comm1 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm2,
                          onTap: () => _selectCard(_comm2, (c) => _comm2 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm3,
                          onTap: () => _selectCard(_comm3, (c) => _comm3 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm4,
                          onTap: () => _selectCard(_comm4, (c) => _comm4 = c),
                          disabledCards: _selectedCards,
                        ),
                        CardSlot(
                          cardCode: _comm5,
                          onTap: () => _selectCard(_comm5, (c) => _comm5 = c),
                          disabledCards: _selectedCards,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Simulation Parameters
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Simulation Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A5F38),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Number of Players: $_numPlayers',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Slider(
                                value: _numPlayers.toDouble(),
                                min: 2,
                                max: 10,
                                divisions: 8,
                                label: _numPlayers.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _numPlayers = value.toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Simulations: $_numSimulations',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Slider(
                                value: _numSimulations.toDouble(),
                                min: 1000,
                                max: 100000,
                                divisions: 99,
                                label: _numSimulations.toString(),
                                onChanged: (value) {
                                  setState(() {
                                    _numSimulations = value.toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Simulate Button
            ElevatedButton(
              onPressed: _loading ? null : _simulate,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('RUN SIMULATION'),
            ),
            const SizedBox(height: 20),

            // Results
            if (_hasResults) ...[
              Card(
                elevation: 8,
                color: const Color(0xFF084130),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.insights,
                        color: Color(0xFFD4AF37),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Simulation Results',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Win Probability
                      _buildProbabilityBar(
                        'Win',
                        _winProbability,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),

                      // Tie Probability
                      _buildProbabilityBar(
                        'Tie',
                        _tieProbability,
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),

                      // Loss Probability
                      _buildProbabilityBar(
                        'Loss',
                        _lossProbability,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityBar(String label, double probability, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${(probability * 100).toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: probability,
            minHeight: 20,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
