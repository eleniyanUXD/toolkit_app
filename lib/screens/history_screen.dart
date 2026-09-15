import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../widgets/history_card.dart';
import '../services/recent_activity_service.dart';
import '../widgets/history_filter_chip.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryModel> history = [];
  List<HistoryModel> filteredHistory = [];

  String selectedFilter = 'All';

  final TextEditingController searchController = TextEditingController();

  final List<String> filters = ['All', 'Conversions', 'Calculator', 'Notes'];

  @override
  void initState() {
    super.initState();
    loadHistory();

    searchController.addListener(filterHistory);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadHistory() async {
    final activities = await RecentActivityService.getActivities();

    final loadedHistory = activities.map((activity) {
      return HistoryModel(
        title: activity['title'] ?? '',
        subtitle: activity['subtitle'] ?? '',
        result: activity['result'] ?? '',
        icon: activity['icon'] ?? '',
        tool: activity['tool'] ?? '',
        timestamp:
            DateTime.tryParse(activity['timestamp'] ?? '') ?? DateTime.now(),
      );
    }).toList();

    if (!mounted) return;

    setState(() {
      history = loadedHistory;
      filteredHistory = loadedHistory;
    });
  }

  void filterHistory() {
    final searchText = searchController.text.toLowerCase();

    setState(() {
      filteredHistory = history.where((item) {
        final matchesSearch =
            item.title.toLowerCase().contains(searchText) ||
            item.subtitle.toLowerCase().contains(searchText) ||
            item.result.toLowerCase().contains(searchText);

        final matchesFilter =
            selectedFilter == 'All' ||
            (selectedFilter == 'Conversions' && item.tool == 'currency') ||
            (selectedFilter == 'Conversions' && item.tool == 'unit') ||
            (selectedFilter == 'Calculator' && item.tool == 'calculator') ||
            (selectedFilter == 'Notes' && item.tool == 'notes');

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void selectFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });

    filterHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search history...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // FILTERS
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];

                  return HistoryFilterChip(
                    label: filter,
                    selected: selectedFilter == filter,
                    onTap: () => selectFilter(filter),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // HISTORY LIST
            Expanded(
              child: filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.history,
                            size: 56,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          const Text('No history yet'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Explore tools',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredHistory.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];

                        return HistoryCard(
                          history: item,
                          onTap: () {
                            openHistoryItem(item);
                          },
                          onDelete: () {
                            deleteHistoryItem(index);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void openHistoryItem(HistoryModel item) {
    // We will connect this to the appropriate tool later.
  }

  Future<void> deleteHistoryItem(int index) async {
    // We will add individual deletion to the service later.
  }

  Future<void> clearHistory() async {
    // We will add clear-history functionality to the service later.
  }
}
