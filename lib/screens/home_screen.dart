import 'package:flutter/material.dart';
import 'package:toolkit_app/currency_converter_screen.dart';
import 'package:toolkit_app/unit_converter_screen.dart';
import 'package:toolkit_app/notes_screen.dart';
import 'package:toolkit_app/widgets/quick_action_card.dart';
import 'package:toolkit_app/widgets/popular_tool_card.dart';
import 'package:toolkit_app/widgets/recent_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back!,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fuad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: const Icon(Icons.notifications, color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 99, 99),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 101, 99, 99),
                      size: 24,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 188, 186, 186),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Quick actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: QuickActionCard(
                        title: 'Currency Converter',
                        subtitle: 'Convert currencies easily',
                        icon: Icons.attach_money,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: QuickActionCard(
                        title: 'Unit Converter',
                        subtitle: 'Convert units quickly',
                        icon: Icons.straighten,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                'Popular tools',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              PopularToolCard(
                title: 'Temperature',
                prefixIcon: Icons.thermostat,
                suffixIcon: Icons.arrow_forward_ios,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              PopularToolCard(
                title: 'Length Converter',
                prefixIcon: Icons.straighten,
                suffixIcon: Icons.arrow_forward_ios,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              PopularToolCard(
                title: 'Weight Converter',
                prefixIcon: Icons.fitness_center,
                suffixIcon: Icons.arrow_forward_ios,
                onTap: () {},
              ),

              const SizedBox(height: 16),

              const RecentActivities(),
            ],
          ),
        ),
      ),
    );
  }
}
