// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// - https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
///
/// Goal:
/// Understand the lifecycle of a [StatefulWidget] by fixing the expect
/// statements.
void main() {
  /// This is a fairly long exercise. Take your time.
  /// Hint: adding print statements can be very useful.
  ///
  /// Follow-up Questions/Exercises:
  /// 1) How can using InheritedWidgets impact the number of rebuilds?
  /// 2) Can the number of rebuilds due to changes in InheritedWidgets be
  ///    reduced? How?
  testWidgets("Lifecycle of a StatefulWidget", (tester) async {
    var built = 0;
    var didChangeDependencies = 0;
    var didUpdateWidget = 0;
    var disposed = 0;
    var initializedState = 0;
    var stateCreated = 0;

    var widgetColor = Colors.red;
    var themeBackgroundColor = Colors.amber;
    var simpleKey = const ValueKey('SimpleWidget-1');

    await tester.pumpWidget(
      MaterialApp(
        home: Theme(
          data: ThemeData(backgroundColor: themeBackgroundColor),
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                TextButton(
                  key: const Key('PressMe'),
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Greetings!'),
                ),
                _SimpleWidget(
                  key: simpleKey,
                  color: widgetColor,
                  onDidChangeDependencies: () {
                    didChangeDependencies++;
                  },
                  onDidUpdateWidget: () {
                    didUpdateWidget++;
                  },
                  onDisposed: () {
                    disposed++;
                  },
                  onInitState: () {
                    initializedState++;
                  },
                  onStateConstructed: () {
                    stateCreated++;
                  },
                  onCreateState: () {
                    stateCreated++;
                  },
                  onBuild: () {
                    built++;
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);

    // Change nothing - only press the button.
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);

    // Does anything happen without calling setState?
    widgetColor = Colors.blue;
    await tester.pumpAndSettle();

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);

    // Let's set state with the new color.
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);

    // Changing a value of an inherited widget.
    themeBackgroundColor = Colors.green;
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);

    simpleKey = const ValueKey('SimpleWidget-2');
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(stateCreated, null);
    expect(initializedState, null);
    expect(built, null);
    expect(didChangeDependencies, null);
    expect(didUpdateWidget, null);
    expect(disposed, null);
  });
}

class _SimpleWidget extends StatefulWidget {
  final VoidCallback onBuild;
  final VoidCallback onCreateState;
  final VoidCallback onDidChangeDependencies;
  final VoidCallback onDidUpdateWidget;
  final VoidCallback onDisposed;
  final VoidCallback onInitState;
  final VoidCallback onStateConstructed;

  final Color color;

  _SimpleWidget({
    super.key,
    required this.onBuild,
    required this.onCreateState,
    required this.onDidChangeDependencies,
    required this.onDisposed,
    required this.onInitState,
    required this.onStateConstructed,
    required this.onDidUpdateWidget,
    required this.color,
  });

  @override
  // This is bad - don't ignore this in a real project.
  // ignore: no_logic_in_create_state
  State<_SimpleWidget> createState() {
    onStateConstructed();
    return _SimpleWidgetState();
  }
}

class _SimpleWidgetState extends State<_SimpleWidget> {
  _SimpleWidgetState();

  @override
  Widget build(BuildContext context) {
    widget.onBuild();
    return Container(
      color: Theme.of(context).backgroundColor,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _SimpleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onDidUpdateWidget();
  }

  @override
  void dispose() {
    widget.onDisposed();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.onInitState();
  }
}
