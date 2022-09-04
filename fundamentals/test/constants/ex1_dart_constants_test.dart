import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// https://api.dart.dev/be/137051/dart-core/Object/operator_equals.html
/// https://dart-lang.github.io/linter/lints/prefer_const_constructors.html
///
/// Goal:
/// Understand constants by making the below tests pass.
///
///
/// Follow-Up Questions/Exercises:
/// 1) What do you think constants would be useful for?
/// 2) Could a class with a constant constructor have a non-final field? Why?
/// 3) Add a new const constructor which uses named fields to the [Simple] class.
///    What role does the required keyword play here?
/// 4) Why is the prefer_const_constructors useful? What kind of issues does it
///    help prevent?
void main() {
  test('Understanding const constructors', () {
    const simple1 = Simple.asConstant('1');
    const simple2 = Simple.asConstant('1');

    expect(simple1 == simple2, null, reason: '');
    expect(simple1.hashCode == simple2.hashCode, null, reason: '');

    // ignore: prefer_const_constructors
    final simple3 = Simple.asConstant('1');
    // ignore: prefer_const_constructors
    final simple4 = Simple.asConstant('1');
    expect(simple3 == simple4, null, reason: '');
    expect(simple1 == simple3, null, reason: '');

    final simple5 = Simple('1');
    final simple6 = Simple('1');
    expect(simple5 == simple6, null, reason: '');
    expect(simple1 == simple5, null, reason: '');

    const property = '1';
    const simple7 = Simple.asConstant(property);
    const simple8 = Simple.asConstant(property);
    expect(simple7 == simple8, null, reason: '');
    expect(simple1 == simple7, null, reason: '');

    // ignore: prefer_const_declarations
    final property2 = '2';

    // Question: are simple9 and simple10 constants? Why/Why not?
    // Answer:
    final simple9 = Simple.asConstant(property2);
    final simple10 = Simple.asConstant(property2);
    expect(simple9 == simple10, null, reason: '');
  });
}

class Simple {
  final String property;

  Simple(this.property);
  const Simple.asConstant(this.property);
}
