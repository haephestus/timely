import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:timely/models/chunk.dart';
import 'package:timely/screens/activity_manager.dart';
import 'package:timely/screens/chunk_manager.dart';
import 'package:timely/screens/homepage.dart';
import 'package:timely/screens/settings.dart';
import 'package:timely/utils/settings_provider.dart';
import 'package:timely/widgets/navbar.dart';
import 'package:provider/provider.dart';
import 'package:alarm/utils/alarm_set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsProvider();
  await settings.load();

  await Alarm.init();
  _listenForAlarms();

  runApp(ChangeNotifierProvider.value(value: settings, child: const Timely()));
}

void _listenForAlarms() {
  Alarm.ringing.listen((AlarmSet alarmSet) {
    for (final alarm in alarmSet.alarms) {
      Alarm.set(
        alarmSettings: AlarmSettings(
          id: alarm.id,
          dateTime: alarm.dateTime.add(const Duration(days: 1)),
          assetAudioPath: alarm.assetAudioPath,
          loopAudio: alarm.loopAudio,
          vibrate: alarm.vibrate,
          notificationSettings: alarm.notificationSettings,
          volumeSettings: alarm.volumeSettings,
        ),
      );
    }
  });
}

class Timely extends StatelessWidget {
  const Timely({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.grey.shade300,
      home: TimelyRoot(),
    );
  }
}

class TimelyRoot extends StatefulWidget {
  const TimelyRoot({super.key});

  @override
  State<TimelyRoot> createState() => _TimelyRootState();
}

class _TimelyRootState extends State<TimelyRoot> {
  int _selectedIndex = 0;
  Chunk? _selectedChunk;

  final _homekey = GlobalKey<HomePageState>();
  late List<Widget> _screens = [HomePage(), Settings()];

  @override
  void initState() {
    super.initState();

    _screens = [
      HomePage(
        key: _homekey,
        onChunkSelected: (chunk) {
          setState(() => _selectedChunk = chunk);
        },
      ),
      Settings(),
    ];
  }

  Future<void> _addActivity() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityManager(chunk: _selectedChunk, isEdit: false),
      ),
    );
    if (result != null) {
      _homekey.currentState!.loadChunkActivities(_selectedChunk!.chunkId!);
    }
  }

  Future<void> _addChunk() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChunkManager(isEdit: false)),
    );

    if (result != null) {
      _homekey.currentState!.loadChunks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Navbar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            items: [
              NavItem(name: "Home", icon: Icons.home_outlined),
              NavItem(name: "Profile", icon: Icons.person_4),
            ],
            onAddChunk: _selectedIndex == 0 ? _addChunk : null,
            onAddActivity: _selectedChunk != null ? _addActivity : null,
          ),
        ],
      ),
    );
  }
}
