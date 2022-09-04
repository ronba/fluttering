// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// - https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
/// - constants/test/ex2_widgets_and_constants_test.dart
///
/// Goal:
/// Understand the lifecycle of a [StatelessWidget] by fixing the expect
/// statements.
void main() {
  /// Follow-up Questions/Exercises:
  /// Modify [_SimpleWidget] to reduce the number of times it is rebuilt.
  /// (hint: const)
  testWidgets("Lifecycle of a StatelessWidget", (tester) async {
    var built = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(builder: (context, setState) {
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
                key: const Key('MySimpleWidget'),
                onBuild: () {
                  built++;
                },
              ),
            ],
          );
        }),
      ),
    );

    await tester.tap(find.byKey(const Key('PressMe')));
    await tester.pumpAndSettle();

    expect(built, null, reason: '');
  });
}

class _SimpleWidget extends StatelessWidget {
  final VoidCallback onBuild;

  _SimpleWidget({
    super.key,
    required this.onBuild,
  });

  @override
  Widget build(BuildContext context) {
    onBuild();
    return Container();
  }
}
