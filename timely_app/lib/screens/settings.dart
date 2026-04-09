import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timely/utils/settings_provider.dart';
import 'package:timely/widgets/setting_option_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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

            // Chunks settings,
            // Default chunk duration
            // Default start hour for new chunks
            // Show inactive chunks on timeline - toggle on or off

            // Activity settings
            // Default Activity duration
            // Show completed activies - toggle on or off
            // Sort order - by time, by name, status or priority

            // Notifications
            // Notification settings,
            // Chunk start reminders - toggle on or off,
            //    lead time (5 mins before, 10 mins before or 15 mins before)

            // Data
            // Export to csv or json
            // clear all activies
            // clear all chunks
            // reset application
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          // Profile show user name
          height: size.height * 0.20,
          width: size.width * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              // First row user stuff
              Padding(
                padding: EdgeInsetsGeometry.only(left: 16, top: 16),
                child: Row(
                  children: [
                    Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(24),
                        color: Colors.red,
                      ),
                    ),
                    Column(
                      children: [
                        Text("Here be dragons", style: TextStyle(fontSize: 24)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Edit your profile",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
