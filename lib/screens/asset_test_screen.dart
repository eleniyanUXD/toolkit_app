import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetTestScreen extends StatelessWidget {
  const AssetTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Test'),
      ),
      body: Center(
        child: SvgPicture.asset(
          'assets/illustrations/onboardingg1.svg',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}