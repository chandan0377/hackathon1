import 'package:hive_flutter/hive_flutter.dart';

class pref {
  static late Box _box;

  static Future<void> initialize() async {
    // Initialize Hive with Flutter
    await Hive.initFlutter();

    // Open the box
    _box = await Hive.openBox('myData');
  }

  static bool get showOnboarding =>
      _box.get('showOnboarding', defaultValue: true);

  static set showOnboarding(bool v) =>
      _box.put('showOnboarding', v);

  // Cleanup method
  static Future<void> clear() async {
    await _box.clear();
  }

  // Close box method for cleanup
  static Future<void> close() async {
    await _box.close();
  }
}