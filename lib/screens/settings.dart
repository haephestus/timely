import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            // Use dropdown widgets

            // Profile show user name
            //  theme(light or dark), time format, Firstday of the week
            //  date header settings / preferences
            Divider(color: Colors.transparent),
            Center(child: ProfileWidget()),
            Divider(color: Colors.transparent),
            SettingOptionWidget(
              label: "User Preferences",
              options: [
                SwitchSettingItem(
                  label: "Dark mode",
                  value: settings.darkMode,
                  onChanged: (v) => settings.setDarkMode(v),
                ),
                /*SwitchSettingItem(
                  value: settings.saveLastPosition,
                  onChanged: (v) => settings.setSaveLastPosition(v),
                  label: "Save last position",
                ),*/
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
            // Chunks settings,
            // Default chunk duration
            // Default start hour for new chunks
            // Default break duration before new chunk
            // Show inactive chunks on timeline - toggle on or off
            /* SettingOptionWidget(
              label: 'Chunks Settings',
              options: [
                SwitchSettingItem(
                  value: settings.showInactiveChunks,
                  onChanged: (v) => settings.setShowInactiveChunks(v),
                  label: 'Show Inactive Chunks',
                ),
              ],
            ),*/
            // Activity settings
            // Default Activity duration
            // Show completed activies - toggle on or off
            // Default break duration before new activity
            // Sort order - by time, by name, status or priority
            //SizedBox(height: 12),
            //SettingOptionWidget(label: 'Activity Settings', options: []),
            // Notifications
            // Notification settings,
            // Chunk start reminders - toggle on or off,
            //    lead time (5 mins before, 10 mins before or 15 mins before)
            //SizedBox(height: 12),
            //SettingOptionWidget(label: 'Notifications Settings', options: []),
            // Data
            // Export to csv or json
            // clear all activies
            // clear all chunks
            // reset application
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
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Uint8List? _avatarBytes;
  bool _isLoading = false;
  int _totalChunks = 0;
  int _totalActivities = 0;
  int _completedActivities = 0;
  Future<void> _loadAvatar() async {
    final bytes = await AvatarService.getAvatar('your_username_here');
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
    _loadAvatar();
    _loadStats();
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
        _completedActivities =
            completions.length; // each row = one completion event
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width * 0.95,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // const Color(0xFF1C1C1E) -> Save this for Dark mode
        color: Colors.white, // dark like the reference
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + name + edit ──
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
                              color: Colors.grey.shade300,
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
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
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
                    const Text(
                      // username goes here
                      "Here be dragons",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      // other part of username goes here
                      "Timely user",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),

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
    return Column(
      children: [
        Icon(icon, color: Colors.black, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
