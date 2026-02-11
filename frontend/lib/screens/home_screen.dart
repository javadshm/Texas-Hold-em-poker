import 'package:flutter/material.dart';
import '../services/poker_api.dart';

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
        title: const Text('Texas Hold\'em Poker'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Evaluate'),
            Tab(text: 'Compare'),
            Tab(text: 'Monte Carlo'),
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

// Evaluate Tab
class EvaluateTab extends StatefulWidget {
  final PokerApi api;

  const EvaluateTab({super.key, required this.api});

  @override
  State<EvaluateTab> createState() => _EvaluateTabState();
}

class _EvaluateTabState extends State<EvaluateTab> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _comm1Controller = TextEditingController();
  final _comm2Controller = TextEditingController();
  final _comm3Controller = TextEditingController();
  final _comm4Controller = TextEditingController();
  final _comm5Controller = TextEditingController();

  String _result = '';
  bool _loading = false;

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _comm1Controller.dispose();
    _comm2Controller.dispose();
    _comm3Controller.dispose();
    _comm4Controller.dispose();
    _comm5Controller.dispose();
    super.dispose();
  }

  Future<void> _evaluate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final playerCards = [
        _player1Controller.text.toUpperCase(),
        _player2Controller.text.toUpperCase(),
      ];
      final communityCards = [
        _comm1Controller.text.toUpperCase(),
        _comm2Controller.text.toUpperCase(),
        _comm3Controller.text.toUpperCase(),
        _comm4Controller.text.toUpperCase(),
        _comm5Controller.text.toUpperCase(),
      ];

      final response = await widget.api.evaluate(playerCards, communityCards);

      setState(() {
        _result = 'Best Hand: ${response.bestHand.join(' ')}\n'
            'Hand Rank: ${response.handRankName}';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Player Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_player1Controller, 'Card 1')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_player2Controller, 'Card 2')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Community Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm1Controller, 'Card 1')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm2Controller, 'Card 2')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm3Controller, 'Card 3')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm4Controller, 'Card 4')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm5Controller, 'Card 5')),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _evaluate,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Evaluate Hand'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_result, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'HA',
        border: const OutlineInputBorder(),
      ),
      maxLength: 2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (value.length != 2) {
          return 'Invalid';
        }
        return null;
      },
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
  final _formKey = GlobalKey<FormState>();
  final _p1c1Controller = TextEditingController();
  final _p1c2Controller = TextEditingController();
  final _p2c1Controller = TextEditingController();
  final _p2c2Controller = TextEditingController();
  final _comm1Controller = TextEditingController();
  final _comm2Controller = TextEditingController();
  final _comm3Controller = TextEditingController();
  final _comm4Controller = TextEditingController();
  final _comm5Controller = TextEditingController();

  String _result = '';
  bool _loading = false;

  @override
  void dispose() {
    _p1c1Controller.dispose();
    _p1c2Controller.dispose();
    _p2c1Controller.dispose();
    _p2c2Controller.dispose();
    _comm1Controller.dispose();
    _comm2Controller.dispose();
    _comm3Controller.dispose();
    _comm4Controller.dispose();
    _comm5Controller.dispose();
    super.dispose();
  }

  Future<void> _compare() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final player1Cards = [
        _p1c1Controller.text.toUpperCase(),
        _p1c2Controller.text.toUpperCase(),
      ];
      final player2Cards = [
        _p2c1Controller.text.toUpperCase(),
        _p2c2Controller.text.toUpperCase(),
      ];
      final communityCards = [
        _comm1Controller.text.toUpperCase(),
        _comm2Controller.text.toUpperCase(),
        _comm3Controller.text.toUpperCase(),
        _comm4Controller.text.toUpperCase(),
        _comm5Controller.text.toUpperCase(),
      ];

      final response = await widget.api.compare(player1Cards, player2Cards, communityCards);

      String winnerText;
      if (response.winner == 1) {
        winnerText = 'Player 1 Wins!';
      } else if (response.winner == 2) {
        winnerText = 'Player 2 Wins!';
      } else {
        winnerText = 'It\'s a Tie!';
      }

      setState(() {
        _result = '$winnerText\n\n'
            'Player 1: ${response.player1Hand.join(' ')}\n'
            '${response.player1RankName}\n\n'
            'Player 2: ${response.player2Hand.join(' ')}\n'
            '${response.player2RankName}';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Player 1 Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_p1c1Controller, 'Card 1')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_p1c2Controller, 'Card 2')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Player 2 Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_p2c1Controller, 'Card 1')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_p2c2Controller, 'Card 2')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Community Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm1Controller, 'Card 1')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm2Controller, 'Card 2')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm3Controller, 'Card 3')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm4Controller, 'Card 4')),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm5Controller, 'Card 5')),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _compare,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Compare Hands'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_result, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'HA',
        border: const OutlineInputBorder(),
      ),
      maxLength: 2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        if (value.length != 2) {
          return 'Invalid';
        }
        return null;
      },
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
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();
  final _comm1Controller = TextEditingController();
  final _comm2Controller = TextEditingController();
  final _comm3Controller = TextEditingController();
  final _comm4Controller = TextEditingController();
  final _comm5Controller = TextEditingController();
  final _numPlayersController = TextEditingController(text: '4');
  final _numSimsController = TextEditingController(text: '10000');

  String _result = '';
  bool _loading = false;

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _comm1Controller.dispose();
    _comm2Controller.dispose();
    _comm3Controller.dispose();
    _comm4Controller.dispose();
    _comm5Controller.dispose();
    _numPlayersController.dispose();
    _numSimsController.dispose();
    super.dispose();
  }

  Future<void> _simulate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final playerCards = [
        _player1Controller.text.toUpperCase(),
        _player2Controller.text.toUpperCase(),
      ];
      final communityCards = <String>[];
      
      if (_comm1Controller.text.isNotEmpty) {
        communityCards.add(_comm1Controller.text.toUpperCase());
      }
      if (_comm2Controller.text.isNotEmpty) {
        communityCards.add(_comm2Controller.text.toUpperCase());
      }
      if (_comm3Controller.text.isNotEmpty) {
        communityCards.add(_comm3Controller.text.toUpperCase());
      }
      if (_comm4Controller.text.isNotEmpty) {
        communityCards.add(_comm4Controller.text.toUpperCase());
      }
      if (_comm5Controller.text.isNotEmpty) {
        communityCards.add(_comm5Controller.text.toUpperCase());
      }

      final numPlayers = int.parse(_numPlayersController.text);
      final numSimulations = int.parse(_numSimsController.text);

      final response = await widget.api.monteCarlo(
        playerCards,
        communityCards,
        numPlayers,
        numSimulations,
      );

      setState(() {
        _result = 'Simulations: ${response.simulations}\n\n'
            'Win Probability: ${(response.winProbability * 100).toStringAsFixed(2)}%\n'
            'Tie Probability: ${(response.tieProbability * 100).toStringAsFixed(2)}%\n'
            'Loss Probability: ${(response.lossProbability * 100).toStringAsFixed(2)}%';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Player Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_player1Controller, 'Card 1', required: true)),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_player2Controller, 'Card 2', required: true)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Community Cards (Optional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm1Controller, 'Card 1', required: false)),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm2Controller, 'Card 2', required: false)),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm3Controller, 'Card 3', required: false)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCardField(_comm4Controller, 'Card 4', required: false)),
                const SizedBox(width: 8),
                Expanded(child: _buildCardField(_comm5Controller, 'Card 5', required: false)),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _numPlayersController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Players',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 2 || n > 10) {
                        return '2-10';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _numSimsController,
                    decoration: const InputDecoration(
                      labelText: 'Simulations',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final n = int.tryParse(value);
                      if (n == null || n < 1) {
                        return '>= 1';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _simulate,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Run Simulation'),
            ),
            const SizedBox(height: 16),
            if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_result, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardField(TextEditingController controller, String label, {required bool required}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'HA',
        border: const OutlineInputBorder(),
      ),
      maxLength: 2,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Required';
        }
        if (value != null && value.isNotEmpty && value.length != 2) {
          return 'Invalid';
        }
        return null;
      },
    );
  }
}
