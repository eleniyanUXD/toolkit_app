import 'package:flutter/material.dart';

class CalculatorModel {
  final String label;
  final IconData? icon;
  final bool isOperator;

  CalculatorModel({required this.label, this.icon, this.isOperator = false});
}
