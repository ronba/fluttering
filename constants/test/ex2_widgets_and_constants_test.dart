import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// https://www.youtube.com/watch?v=IOyq-eTRhvo
/// https://docs.flutter.dev/perf/best-practices#control-build-cost
///
/// Goal:
/// Understand what happens to the build method when const widgets are
/// involved.
///
/// Follow-up Questions/Exercises:
/// 1) What's the benefit of using const widgets? How does it help with
///    controlling the build cost?
/// 2) What kind of build related issues can be prevented by using the
///    prefer_const_constructors lint rule?
/// 3) What happened with the [second] widget?
/// 4) How would you reduce the number of times the `third` widget is built?
/// 5) Can the `fourth` widget to const?
/// 6) Can the number of times `dynamic` widgets are built be reduced?
/// 7) Can a [StatefulWidget] have a const constructor? Why?
/// 8) Create a [StatefulWidget] and add it to the list of widgets. Is it
///    possible to limit the number of the time it is built to 1?
void main() {
  testWidgets("Widgets and constants", (WidgetTester tester) async {
    // Start by clearing the map in _SimpleWidget tracking our built
    // widgets by their name.
    _SimpleWidget.buildTracker.clear();
    const first = _SimpleWidget(name: 'first');

    // ignore: prefer_const_constructors
    final second = _SimpleWidget(name: 'second');

    var counter = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(builder: (context, setState) {
          return Column(children: [
            TextButton(
                key: const Key('PressMe'),
                onPressed: () {
                  setState(() {
                    counter++;
                  });
                },
                child: const Text('Press me!')),
            first,
            second,
            // ignore: prefer_const_constructors
            _SimpleWidget(name: 'third'),
            _SimpleWidget(name: 'fourth-$counter'),
            for (int i = 1; i <= 3; i++) _SimpleWidget(name: 'dynamic-$i'),
          ]);
        }),
      ),
    );

    // Now let's trigger a rebuild of the StatefulBuilder.
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(_SimpleWidget.buildTracker['first'], null, reason: '');
    expect(_SimpleWidget.buildTracker['second'], null, reason: '');
    expect(_SimpleWidget.buildTracker['third'], null, reason: '');
    expect(_SimpleWidget.buildTracker['fourth-1'], null, reason: '');
    expect(_SimpleWidget.buildTracker['fourth-2'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic-1'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic-2'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic-3'], null, reason: '');
  });
}

class _SimpleWidget extends StatelessWidget {
  static final buildTracker = <String, int>{};

  final String name;

  const _SimpleWidget({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    buildTracker[name] = (buildTracker[name] ?? 0) + 1;
    return Text(name);
  }
}
