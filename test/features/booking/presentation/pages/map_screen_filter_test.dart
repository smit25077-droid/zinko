import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A minimal widget that replicates the MapScreen's filter chip logic
/// so we can test it independently without needing GoogleMaps.
class _FilterTestWidget extends StatefulWidget {
  const _FilterTestWidget();

  @override
  State<_FilterTestWidget> createState() => _FilterTestWidgetState();
}

class _FilterTestWidgetState extends State<_FilterTestWidget> {
  final List<String> _filters = ['All', 'Cafes', 'Workspaces', 'People'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              key: const Key('filter_list'),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  key: Key('filter_chip_$filter'),
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filter,
                      key: Key('filter_label_$filter'),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Display area showing what's filtered
          Text('Active filter: $_selectedFilter', key: const Key('active_filter_display')),
        ],
      ),
    );
  }
}

void main() {
  group('MapScreen Filter Chip Widget Tests', () {
    Widget buildTestWidget() {
      return const MaterialApp(
        home: _FilterTestWidget(),
      );
    }

    testWidgets('renders all filter chips', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byKey(const Key('filter_chip_All')), findsOneWidget);
      expect(find.byKey(const Key('filter_chip_Cafes')), findsOneWidget);
      expect(find.byKey(const Key('filter_chip_Workspaces')), findsOneWidget);
      expect(find.byKey(const Key('filter_chip_People')), findsOneWidget);
    });

    testWidgets('default selected filter is "All"', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text && widget.data == 'Active filter: All') {
            return true;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Cafes" updates the selected filter', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('filter_chip_Cafes')));
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text && widget.data == 'Active filter: Cafes') {
            return true;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Workspaces" updates the selected filter',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('filter_chip_Workspaces')));
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text && widget.data == 'Active filter: Workspaces') {
            return true;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('tapping "People" updates the selected filter', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.byKey(const Key('filter_chip_People')));
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text && widget.data == 'Active filter: People') {
            return true;
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('tapping another filter updates from previous selection',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // First select Cafes
      await tester.tap(find.byKey(const Key('filter_chip_Cafes')));
      await tester.pump();

      // Then switch to People
      await tester.tap(find.byKey(const Key('filter_chip_People')));
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text && widget.data == 'Active filter: People'),
        findsOneWidget,
      );

      // Verify Cafes is no longer selected
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text && widget.data == 'Active filter: Cafes'),
        findsNothing,
      );
    });

    testWidgets('tapping "All" resets filter back to All', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Select Workspaces first
      await tester.tap(find.byKey(const Key('filter_chip_Workspaces')));
      await tester.pump();

      // Then reset to All
      await tester.tap(find.byKey(const Key('filter_chip_All')));
      await tester.pump();

      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text && widget.data == 'Active filter: All'),
        findsOneWidget,
      );
    });
  });
}
