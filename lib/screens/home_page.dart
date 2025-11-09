import 'package:dailypulse/models/mood_entry.dart';
import 'package:dailypulse/screens/add_mood_page.dart';
import 'package:dailypulse/screens/analytics_screen.dart';
import 'package:dailypulse/screens/dashboard_screen.dart';
import 'package:dailypulse/screens/history_screen.dart';
import 'package:dailypulse/services/storage_services.dart';
import 'package:flutter/material.dart';

// Home Page
class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  
  const HomePage({super.key, required this.onThemeToggle});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;
  final StorageService _storage = StorageService();
  List<MoodEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadEntries();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    final entries = await _storage.loadEntries();
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _addEntry(MoodEntry entry) async {
    setState(() {
      _entries.insert(0, entry);
    });
    await _storage.saveEntries(_entries);
  }

  void _navigateToAddMood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMoodPage(onSave: _addEntry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(entries: _entries),
      HistoryScreen(entries: _entries),
      AnalyticsScreen(entries: _entries),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DailyPulse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : screens[_selectedIndex],
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
        ),
        child: FloatingActionButton.extended(
          onPressed: _navigateToAddMood,
          icon: const Icon(Icons.add),
          label: const Text('Log Mood'),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            _fabController.forward();
          } else {
            _fabController.reverse();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
