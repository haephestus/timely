import 'package:alarm/alarm.dart';
import 'package:timely/models/chunk.dart';

class Notify {
  // TODO: schedule multiple alarms
  // schedule alarms according to chunkfrequency
  // pass a list of all chunks from chunk service.getAllChunks
  // map dbChunks to chunk models
  // get upcoming chunks and schedule alarms for upcoming chunks (todays chunks)

  Future<void> _set(id, name, startHour, startMinute) async {
    var scheduleDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startHour,
      startMinute,
    );

    if (scheduleDate.isBefore(DateTime.now())) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
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
