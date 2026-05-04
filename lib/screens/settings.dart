import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timely/utils/avatar_service.dart';
import 'package:timely/utils/database/database.dart';
import 'package:timely/utils/settings_provider.dart';
import 'package:timely/widgets/setting_option_widget.dart';
import 'package:timely/utils/database/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final AppDb _database;
  late final ChunkActivityService _service;
  List<StartingDayOfWeek> days = [
    StartingDayOfWeek.monday,
    StartingDayOfWeek.tuesday,
    StartingDayOfWeek.wednesday,
    StartingDayOfWeek.thursday,
    StartingDayOfWeek.friday,
    StartingDayOfWeek.saturday,
    StartingDayOfWeek.sunday,
  ];

  @override
  void initState() {
    _database = AppDb();
    _service = ChunkActivityService(_database);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final username = context.watch<SettingsProvider>().username;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.primary, // ← was Colors.grey.shade300
      body: SafeArea(
        child: Column(
          children: [
            Divider(color: Colors.transparent),
            Center(child: ProfileWidget(username: username)),
            Divider(color: Colors.transparent),
            SettingOptionWidget(
              label: "User Preferences",
              options: [
                SwitchSettingItem(
                  label: "Dark mode",
                  value: settings.darkMode,
                  onChanged: (v) => settings.setDarkMode(v),
                ),
                ChoiceSettingItem(
                  label: "Time format",
                  value: settings.is24HourFormat ? 1 : 0,
                  choices: ["12hr", "24hr"],
                  onSelected: (v) => settings.set24HourFormat(v == 1),
                ),
                DropDownSettingItem(
                  label: "Week start",
                  initialSelection: settings.weekStart,
                  dropdownMenuEntries: days
                      .map(
                        (d) => DropdownMenuEntry(
                          value: d,
                          label: d.name[0].toUpperCase() + d.name.substring(1),
                        ),
                      )
                      .toList(),
                  onSelected: (v) => settings.setWeekStart(v),
                ),
              ],
            ),
            SizedBox(height: 12),
            SettingOptionWidget(
              label: 'Data & Privacy',
              options: [
                ClickableSettingItem(
                  onTapped: _service.deleteAllActvities,
                  label: "Clear All Activities",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  final String? username;
  const ProfileWidget({required this.username, super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Uint8List? _avatarBytes;
  bool _isLoading = false;
  int _totalChunks = 0;
  int _totalActivities = 0;
  int _completedActivities = 0;
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _loadAvatar() async {
    final bytes = await AvatarService.getAvatar(widget.username!);
    if (mounted) setState(() => _avatarBytes = bytes);
  }

  Future<void> _regenerateAvatar() async {
    setState(() => _isLoading = true);
    await AvatarService.clearCache();
    final bytes = await AvatarService.getAvatar(
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
    if (mounted) {
      setState(() {
        _avatarBytes = bytes;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username ?? '';
    _loadAvatar();
    _loadStats();
    _usernameController.addListener(() {
      final String text = _usernameController.text;
      _usernameController.value = _usernameController.value.copyWith(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void didUpdateWidget(covariant ProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.username != widget.username &&
        _usernameController.text != widget.username) {
      _usernameController.text = widget.username ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final db = AppDb();
    final chunks = await db.select(db.chunks).get();
    final activities = await db.select(db.activities).get();
    final completions = await db.select(db.completions).get();

    if (mounted) {
      setState(() {
        _totalChunks = chunks.length;
        _totalActivities = activities.length;
        _completedActivities = completions.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.95,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface, // ← was Colors.white
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + name ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _avatarBytes == null || _isLoading
                        ? Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: cs.primary, // ← was Colors.grey.shade300
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                          )
                        : SvgPicture.memory(
                            _avatarBytes!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isLoading ? null : _regenerateAvatar,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.refresh,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      style: TextStyle(
                        color: cs.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      onChanged: (value) {
                        if (value.length <= 16) {
                          settings.setUsername(value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter username",
                        labelStyle: TextStyle(
                          color: cs.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                        contentPadding: EdgeInsets.only(top: -16),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: cs.onSurface,
                ), // ← was Colors.white
                onPressed: () {},
              ),
            ],
          ),

          Padding(
            padding: EdgeInsetsGeometry.only(right: 9),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData ? 'v${snapshot.data!.version}' : '',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.60),
                    ),
                  );
                },
              ),
            ),
          ),

          Divider(color: cs.outlineVariant), // ← was Colors.white12
          // ── Stat pills row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatPill(
                icon: Icons.grid_view_rounded,
                value: '$_totalChunks',
                label: 'Chunks',
              ),
              _StatPill(
                icon: Icons.check_circle_outline,
                value: '$_totalActivities',
                label: 'Activities',
              ),
              _StatPill(
                icon: Icons.done_all,
                value: '$_completedActivities',
                label: 'Completed',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, color: cs.onSurface, size: 18), // ← was Colors.black
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cs.onSurface, // ← was Colors.black
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: cs.onSurface.withAlpha(130), // ← was Colors.grey.shade500
          ),
        ),
      ],
    );
  }
}
