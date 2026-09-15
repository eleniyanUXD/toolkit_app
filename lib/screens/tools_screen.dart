import 'package:flutter/material.dart';
import 'package:toolkit_app/widgets/quick_action_card.dart';
import 'package:toolkit_app/screens/currency_converter_screen.dart';
import 'package:toolkit_app/screens/unit_converter_screen.dart';
import 'package:toolkit_app/screens/calculator_screen.dart';
import 'package:toolkit_app/screens/add_note_screen.dart';
import 'package:toolkit_app/screens/timer_screen.dart';
import 'package:toolkit_app/screens/date_calculator_screen.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final List<Map<String, dynamic>> tools = [
    {
      'title': 'Currency Converter',
      'subtitle': 'Convert currencies',
      'icon': Icons.currency_exchange,
    },
    {
      'title': 'Unit Converter',
      'subtitle': 'Convert different units',
      'icon': Icons.straighten,
    },
    {
      'title': 'Calculator',
      'subtitle': 'Perform calculations',
      'icon': Icons.calculate_outlined,
    },
    {
      'title': 'Add Notes',
      'subtitle': 'Create and manage notes',
      'icon': Icons.note,
    },
    {
      'title': 'Timer',
      'subtitle': 'Set a countdown',
      'icon': Icons.timer_outlined,
    },
    {
      'title': 'Date Calculator',
      'subtitle': 'Calculate dates',
      'icon': Icons.calendar_month_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,

        title: const Text(
          'Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All tools',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tools.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final tool = tools[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        if (tool['title'] == 'Currency Converter') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CurrencyConverterScreen(),
                            ),
                          );
                        } else if (tool['title'] == 'Unit Converter') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UnitConverterScreen(),
                            ),
                          );
                        } else if (tool['title'] == 'Calculator') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CalculatorScreen(),
                            ),
                          );
                        } else if (tool['title'] == 'Timer') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TimerScreen(),
                            ),
                          );
                        } else if (tool['title'] == 'Date Calculator') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DateCalculatorScreen(),
                            ),
                          );
                        } else if (tool['title'] == 'Add Notes') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNotesScreen(),
                            ),
                          );
                        }
                      },
                      child: QuickActionCard(
                        title: tool['title'],
                        subtitle: tool['subtitle'],
                        icon: tool['icon'],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
