import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatefulWidget {
  const CounterImageToggleApp({super.key});

  @override
  State<CounterImageToggleApp> createState() => _CounterImageToggleAppState();
}

class _CounterImageToggleAppState extends State<CounterImageToggleApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    required this.isDark,
    required this.onToggleTheme,
    super.key,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _step = 1;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() => _counter += _step);
  }

  void _decrementCounter() {
    if (_counter == 0) {
      return;
    }
    setState(() {
      _counter -= _step;
      if (_counter < 0) {
        _counter = 0;
      }
    });
  }

  void _resetCounter() {
    if (_counter == 0) {
      return;
    }
    setState(() => _counter = 0);
  }

  void _setStep(int value) {
    setState(() => _step = value);
  }

  void _toggleImage() {
    setState(() => _isFirstImage = !_isFirstImage);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CW1 Counter & Toggle'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Step +1'),
                    selected: _step == 1,
                    onSelected: (_) => _setStep(1),
                  ),
                  ChoiceChip(
                    label: const Text('Step +5'),
                    selected: _step == 5,
                    onSelected: (_) => _setStep(5),
                  ),
                  ChoiceChip(
                    label: const Text('Step +10'),
                    selected: _step == 10,
                    onSelected: (_) => _setStep(10),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Current step: $_step'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _counter == 0 ? null : _decrementCounter,
                    child: const Text('Decrement'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _counter == 0 ? null : _resetCounter,
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  _isFirstImage ? 'assets/wolf.jpg' : 'assets/tiger.jpeg',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
