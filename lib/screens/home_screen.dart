import 'package:flutter/material.dart';
import 'package:toolkit_app/screens/currency_converter_screen.dart';
import 'package:toolkit_app/screens/unit_converter_screen.dart';
import 'package:toolkit_app/screens/add_note_screen.dart';
import 'package:toolkit_app/widgets/quick_action_card.dart';
import 'package:toolkit_app/widgets/popular_tool_card.dart';
import 'package:toolkit_app/widgets/recent_activity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit_app/screens/calculator_screen.dart';
import 'package:toolkit_app/screens/timer_screen.dart';
import 'package:toolkit_app/screens/date_calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int recentActivityRefreshKey = 0;
  final List<Map<String, dynamic>> tools = [
    {
      'title': 'Currency Converter',
      'subtitle': 'Convert currencies easily',
      'icon': Icons.attach_money,
    },
    {
      'title': 'Unit Converter',
      'subtitle': 'Convert units quickly',
      'icon': Icons.straighten,
    },
    {
      'title': 'Calculator',
      'subtitle': 'Perform quick calculations',
      'icon': Icons.calculate,
    },
    {'title': 'Timer', 'subtitle': 'Track time with ease', 'icon': Icons.timer},
    {
      'title': 'Date Calculator',
      'subtitle': 'Calculate date differences',
      'icon': Icons.calendar_month,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final query = _searchController.text.trim().toLowerCase();

    final filteredTools = tools.where((tool) {
      final title = tool['title'].toString().toLowerCase();
      final subtitle = tool['subtitle'].toString().toLowerCase();

      return title.contains(query) || subtitle.contains(query);
    }).toList();

    final userName =
        user?.userMetadata?['name'] as String? ??
        user?.email?.split('@').first ??
        'there';

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
                      Text(
                        'Welcome back 👋,',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
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
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
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

              Text(
                query.isEmpty ? 'Quick actions' : 'Search results',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              if (filteredTools.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No tools found.')),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: query.isEmpty ? 2 : filteredTools.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final tool = query.isEmpty
                        ? tools[index]
                        : filteredTools[index];

                    return GestureDetector(
                      onTap: () async {
                        final title = tool['title'];

                        if (title == 'Currency Converter') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CurrencyConverterScreen(),
                            ),
                          );
                        } else if (title == 'Unit Converter') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UnitConverterScreen(),
                            ),
                          );
                        } else if (title == 'Calculator') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorScreen(),
                            ),
                          );
                        } else if (title == 'Timer') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimerScreen(),
                            ),
                          );
                        } else if (title == 'Date Calculator') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DateCalculatorScreen(),
                            ),
                          );
                        }

                        if (!mounted) return;

                        setState(() {
                          recentActivityRefreshKey++;
                        });
                      },
                      child: QuickActionCard(
                        title: tool['title'] as String,
                        subtitle: tool['subtitle'] as String,
                        icon: tool['icon'] as IconData,
                      ),
                    );
                  },
                ),

              const SizedBox(height: 16),

              if (query.isEmpty)
                RecentActivities(refreshKey: recentActivityRefreshKey),
            ],
          ),
        ),
      ),
    );
  }
}
