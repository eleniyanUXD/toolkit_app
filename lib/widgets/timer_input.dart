import 'package:flutter/material.dart';

class TimerInput extends StatelessWidget {
  final TextEditingController minutesController;
  final TextEditingController secondsController;

  const TimerInput({
    super.key,
    required this.minutesController,
    required this.secondsController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimeField(label: 'Minutes', controller: minutesController),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TimeField(label: 'Seconds', controller: secondsController),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _TimeField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '00',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
