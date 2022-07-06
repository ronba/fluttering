import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// https://www.youtube.com/watch?v=IOyq-eTRhvo
/// https://docs.flutter.dev/perf/best-practices#control-build-cost
///
/// Goal:
/// Understand what happens to the build method when const widgets are
/// involved.
void main() {
  testWidgets("Widgets and constants", (WidgetTester tester) async {
    _SimpleWidget.buildTracker.clear();
    const first = _SimpleWidget(name: 'first');

    // ignore: prefer_const_constructors
    final second = _SimpleWidget(name: 'second');

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(builder: (context, setState) {
          return Column(children: [
            TextButton(
                key: const Key('PressMe'),
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Press me!')),
            first,
            second,
            // ignore: prefer_const_constructors
            _SimpleWidget(name: 'third'),
            for (int i = 1; i <= 3; i++) _SimpleWidget(name: 'dynamic$i')
          ]);
        }),
      ),
    );

    // Now let's trigger a rebuild of our widget.
    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(_SimpleWidget.buildTracker['first'], null, reason: '');
    expect(_SimpleWidget.buildTracker['second'], null, reason: '');
    expect(_SimpleWidget.buildTracker['third'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic1'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic2'], null, reason: '');
    expect(_SimpleWidget.buildTracker['dynamic3'], null, reason: '');
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
