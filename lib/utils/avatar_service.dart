import 'dart:convert';
import 'dart:typed_data';
import 'package:dice_bear/dice_bear.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarService {
  static const _key = 'cached_avatar_svg';

  static Future<Uint8List?> getAvatar(String seed) async {
    final prefs = await SharedPreferences.getInstance();

    // Return cached bytes if available
    final cached = prefs.getString(_key);
    if (cached != null) {
      return base64Decode(cached);
    }

    // Fetch from network and cache
    final bytes = await DiceBearRequest(
      style: DiceBearStyle.notionistsNeutral,
      coreOptions: DiceBearCoreOptions(seed: seed),
    ).fetchBytes();

    await prefs.setString(_key, base64Encode(bytes));

    return bytes;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
