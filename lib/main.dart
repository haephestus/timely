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
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();
  // NOTE: line 19 prevents landscape
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final settings = SettingsProvider();
  await settings.load();
  await Alarm.init();
  _listenForAlarms();

  runApp(ChangeNotifierProvider.value(value: settings, child: const Timely()));
}

void _listenForAlarms() {
  Alarm.ringing.listen((AlarmSet alarmSet) {
    for (final alarm in alarmSet.alarms) {
      // Reschedule for next day
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

      /*Show your custom screen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AlarmScreen(alarm: alarm),
        ),
      );
      */
    }
  });
}

class Timely extends StatelessWidget {
  const Timely({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        surface: Colors.white,
        seedColor: Colors.red, // your app's brand color
        primary: Colors.grey.shade300,
        secondary: Color(0xFF1C1C1E),
        brightness: Brightness.light,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        surface: Color(0xFF1C1C1E),
        seedColor: Colors.red,
        primary: Colors.grey.shade800,
        secondary: Colors.white,
        brightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
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
  int _selectedScreen = 0;
  Chunk? _selectedChunk;

  final _homekey = GlobalKey<HomePageState>();
  late List<Widget> _screens = [HomePage(), Settings()];
  final _navbarVisible = ValueNotifier<bool>(true);
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // In _TimelyRootState initState, replace the scroll listener with:
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final direction = _scrollController.position.userScrollDirection;
      final atTop = _scrollController.position.pixels <= 0;
      final notScrollable = _scrollController.position.maxScrollExtent == 0;

      if (direction == ScrollDirection.reverse) {
        _navbarVisible.value = false;
      } else if (direction == ScrollDirection.forward ||
          atTop ||
          notScrollable) {
        _navbarVisible.value = true;
      }
    });
    _screens = [
      HomePage(
        key: _homekey,
        scrollController: _scrollController, // pass down
        onChunkSelected: (chunk) {
          setState(() => _selectedChunk = chunk);
          _navbarVisible.value = true;
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
          _screens[_selectedScreen],
          ValueListenableBuilder<bool>(
            // TODO: make navbar visible when chunk is changed
            // TODO: make navbar visible when additional activity is deleted
            valueListenable: _navbarVisible,
            builder: (context, visible, child) {
              return AnimatedSlide(
                offset: visible ? Offset.zero : const Offset(0, 1),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Navbar(
                  selectedIndex: _selectedScreen,
                  onItemSelected: (index) {
                    setState(() => _selectedScreen = index);
                    _navbarVisible.value = true;
                  },
                  items: [
                    NavItem(name: "Home", icon: Icons.home_outlined),
                    NavItem(name: "Profile", icon: Icons.person_4),
                  ],
                  onAddChunk: _selectedScreen == 0 ? _addChunk : null,
                  onAddActivity: _selectedChunk != null ? _addActivity : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
