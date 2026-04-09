import 'package:alarm/alarm.dart';

class Notify {
  Future<void> set(id, name, startHour, startMinute) async {
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: id,
        dateTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startHour,
          startMinute,
        ),
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: false,
        vibrate: true,
        notificationSettings: NotificationSettings(
          title: '$name is starting',
          body: 'Your chunk is starting now',
          stopButton: 'Dismiss',
        ),
        volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 5)),
      ),
    );
  }

  Future<void> stop(id) async {
    await Alarm.stop(id);
  }
}
