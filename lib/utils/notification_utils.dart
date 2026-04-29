import 'package:alarm/alarm.dart';
import 'package:timely/models/chunk.dart';

class Notify {
  // TODO: schedule multiple alarms
  // schedule alarms according to chunkfrequency

  Future<void> _set(id, name, startHour, startMinute) async {
    final now = DateTime.now();
    var scheduleDate = DateTime(
      now.year,
      now.month,
      now.day,
      startHour,
      startMinute,
      0,
      0,
    );

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    assert(!scheduleDate.isUtc);

    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: id,
        dateTime: scheduleDate,
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

  Future<void> scheduledToday(List<Chunk> chunks) async {
    for (final chunk in chunks) {
      await _set(chunk.chunkId, chunk.name, chunk.startHour, chunk.startMinute);
    }
  }
}
