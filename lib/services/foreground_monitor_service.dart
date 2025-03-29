import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

class ForegroundMonitorService {
  StreamController<String> _appStreamController = StreamController<String>.broadcast();
  Stream<String> get appStream => _appStreamController.stream;

  void startMonitoring() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      List<EventUsageInfo> events = await UsageStats.queryEvents(
        DateTime.now().subtract(Duration(minutes: 1)),
        DateTime.now(),
      );

      if (events.isNotEmpty) {
        EventUsageInfo lastEvent = events.last;
        _appStreamController.add(lastEvent.packageName ?? "Unknown");
      } else {
        _appStreamController.add("Unknown");
      }
    });
  }
}
