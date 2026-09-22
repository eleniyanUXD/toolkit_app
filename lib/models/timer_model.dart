class TimerModel {
  final int durationInSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;

  TimerModel({
    required this.durationInSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    required this.isPaused,
  });
}