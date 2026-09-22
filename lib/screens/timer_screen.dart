import 'dart:async';
import 'package:flutter/material.dart';
import '../models/timer_model.dart';
import '../widgets/quick_duration_chip.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_input.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;

  final TextEditingController minutesController = TextEditingController(
    text: '05',
  );

  final TextEditingController secondsController = TextEditingController(
    text: '00',
  );

  TimerModel timerModel = TimerModel(
    durationInSeconds: 300,
    remainingSeconds: 300,
    isRunning: false,
    isPaused: false,
  );

  @override
  void dispose() {
    timer?.cancel();
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }

  void startTimer() {
    final minutes = int.tryParse(minutesController.text) ?? 0;
    final seconds = int.tryParse(secondsController.text) ?? 0;

    final totalSeconds = (minutes * 60) + seconds;

    if (totalSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid time.')),
      );
      return;
    }

    timer?.cancel();

    setState(() {
      timerModel = TimerModel(
        durationInSeconds: totalSeconds,
        remainingSeconds: totalSeconds,
        isRunning: true,
        isPaused: false,
      );
    });

    runCountdown();
  }

  void runCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerModel.remainingSeconds <= 1) {
        timer.cancel();

        setState(() {
          timerModel = TimerModel(
            durationInSeconds: timerModel.durationInSeconds,
            remainingSeconds: 0,
            isRunning: false,
            isPaused: false,
          );
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Time's up!")));

        return;
      }

      setState(() {
        timerModel = TimerModel(
          durationInSeconds: timerModel.durationInSeconds,
          remainingSeconds: timerModel.remainingSeconds - 1,
          isRunning: true,
          isPaused: false,
        );
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      timerModel = TimerModel(
        durationInSeconds: timerModel.durationInSeconds,
        remainingSeconds: timerModel.remainingSeconds,
        isRunning: false,
        isPaused: true,
      );
    });
  }

  void resumeTimer() {
    setState(() {
      timerModel = TimerModel(
        durationInSeconds: timerModel.durationInSeconds,
        remainingSeconds: timerModel.remainingSeconds,
        isRunning: true,
        isPaused: false,
      );
    });

    runCountdown();
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      timerModel = TimerModel(
        durationInSeconds: 300,
        remainingSeconds: 300,
        isRunning: false,
        isPaused: false,
      );

      minutesController.text = '05';
      secondsController.text = '00';
    });
  }

  void setQuickDuration(int minutes) {
    timer?.cancel();

    setState(() {
      minutesController.text = minutes.toString().padLeft(2, '0');

      secondsController.text = '00';

      timerModel = TimerModel(
        durationInSeconds: minutes * 60,
        remainingSeconds: minutes * 60,
        isRunning: false,
        isPaused: false,
      );
    });
  }

  String get actionLabel {
    if (timerModel.isRunning) {
      return 'Pause';
    }

    if (timerModel.isPaused) {
      return 'Resume';
    }

    return 'Start';
  }

  IconData get actionIcon {
    if (timerModel.isRunning) {
      return Icons.pause;
    }

    return Icons.play_arrow;
  }

  void handleAction() {
    if (timerModel.isRunning) {
      pauseTimer();
    } else if (timerModel.isPaused) {
      resumeTimer();
    } else {
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Blue AppBar to match Unit Converter
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Timer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Set a countdown for your task.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            // Timer display
            TimerDisplay(remainingSeconds: timerModel.remainingSeconds),

            const SizedBox(height: 20),

            // Minutes and seconds
            TimerInput(
              minutesController: minutesController,
              secondsController: secondsController,
            ),

            const SizedBox(height: 24),

            // Start / Pause / Resume
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: handleAction,
                icon: Icon(actionIcon),
                label: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Reset
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: resetTimer,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Quick durations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                QuickDurationChip(
                  label: '1 min',
                  icon: Icons.timer,
                  onPressed: () => setQuickDuration(1),
                ),
                QuickDurationChip(
                  label: '5 min',
                  icon: Icons.timer,
                  onPressed: () => setQuickDuration(5),
                ),
                QuickDurationChip(
                  label: '10 min',
                  icon: Icons.timer,
                  onPressed: () => setQuickDuration(10),
                ),
                QuickDurationChip(
                  label: '15 min',
                  icon: Icons.timer,
                  onPressed: () => setQuickDuration(15),
                ),
                QuickDurationChip(
                  label: '30 min',
                  icon: Icons.timer,
                  onPressed: () => setQuickDuration(30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
