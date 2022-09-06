import 'package:flutter_test/flutter_test.dart';

/// Resources:
/// https://dart.dev/codelabs/iterables
///
/// Goal:
/// Understand iterables by completing the test cases below.
///
/// https://dart.dev/guides/language/language-tour#generators
///
/// Follow-up Questions/Exercises:
/// - Implement an Iterable that skips every third value.
/// - Implement a sync generator that duplicates the number of elements in a
///   list.
/// - Implement a circular iterable that receives a starting and ending number
///   and iterates between the two in a loop.
///   Consider the implementation of elementAt for this iterable.
///
void main() {
  late List<int> listData;

  setUp(() {
    listData = [1, 2, 3, 4, 5];
  });

  /// Follow-up Questions/Exercises:
  /// - What are possible issues with returning a raw iterable from a method?
  ///   How can these be mitigated?
  test('Basic Iterators', () {
    final divideBy2 = listData.map((e) => e / 2);
    final divideBy2List = divideBy2.toList();

    final multiplyBy2 = listData.map((e) => e * 2);
    final multiplyBy2List = multiplyBy2.toList();

    expect(divideBy2, null);
    expect(divideBy2List, null);
    expect(multiplyBy2, null);
    expect(multiplyBy2List, null);

    listData.add(6);

    expect(divideBy2, null);
    expect(divideBy2List, null);
    expect(multiplyBy2, null);
    expect(multiplyBy2List, null);
  });

  test('Iterator functions (Lists)', () {
    var mapCount = 0;
    var whereCount = 0;
    final plus1 = listData.where((e) {
      whereCount++;
      return true;
    }).map((e) {
      mapCount++;
      return e + 1;
    });

    expect(mapCount, null);
    expect(whereCount, null);
    expect(listData.hashCode == plus1.hashCode, null);

    expect(plus1.elementAt(3), null);
    expect(whereCount, null);
    expect(mapCount, null);

    // Follow-up Questions/Exercises:
    // - Why do mapCount and whereCount have different values?
    //   Hint: look at the implementation of both methods.

    // Getting the iterable's length.
    mapCount = 0;
    whereCount = 0;
    // Force an iteration of the iterable.
    expect(plus1.length, null);
    expect(mapCount, null);
    expect(whereCount, null);
  });

  test('Advanced: Using our own generator function', () {
    var mapCount = 0;
    Iterable<T> skipEvenIndices<T>(Iterable<T> iterable) sync* {
      var state = 0;
      final it = iterable.iterator;
      while (it.moveNext()) {
        if (state.isEven) {
          mapCount++;
          yield it.current;
        }

        state++;
      }
    }

    mapCount = 0;
    final withoutEvenIndices = skipEvenIndices(listData);
    expect(mapCount, null);

    mapCount = 0;
    expect(withoutEvenIndices.elementAt(2), null);
    expect(mapCount, null);

    // Let's check if the order matters.
    // Scenario 1) Add a filter on listData.
    var whereCount = 0;
    final innerFilter = skipEvenIndices(listData.where((e) {
      whereCount++;
      return true;
    }));

    expect(innerFilter.length, null);
    expect(whereCount, null);

    // Scenario 2) Add the filter on skipEvenIndices
    whereCount = 0;
    final outerFilter = skipEvenIndices(listData).where((e) {
      whereCount++;
      return true;
    });

    expect(outerFilter.length, null);
    expect(whereCount, null);
  });

  /// Questions:
  /// - Is it always safe to call toList on an iterable?
  /// - Is it possible to tell whether an iterable is finite?
  test('Advanced Iterables: An always increasing iterable?', () {
    var mapCount = 0;
    var whereCount = 0;
    final alwaysIncreasing = _AlwaysIncreasingIterable(0).where((e) {
      whereCount++;
      return true;
    }).map((e) {
      mapCount++;
      return e + 1;
    });

    final takeWhile = alwaysIncreasing.take(10);
    expect(takeWhile, null);
    expect(whereCount, null);
    expect(mapCount, null);
  });

  /// Let's experiment with elementAt.
  /// We'll compare the retrieval time of an element between a list and an
  /// [_AlwaysIncreasingIterable].
  ///
  /// Questions/Followups:
  /// 1) Should there be a difference in performance between the two? Why?
  /// 2) What is the resource tradeoff between the two iterables? Consider CPU
  ///    and memory.
  /// 3) Override the elementAt method in [_AlwaysIncreasingIterable] to
  ///    improve performance.
  test('Advanced Iterables: elementAt', () {
    final alwaysIncreasing = _AlwaysIncreasingIterable(0);
    const limit = 10000;
    final longList = List.generate(
      limit + 1,
      (index) => index,
      growable: false,
    );

    final stopwatch = Stopwatch();

    const totalAttempts = 1000;
    var longListElementAtTotalMicroseconds = 0;
    var alwaysIncreasingElementAtTotalMicroseconds = 0;

    for (int attempt = 0; attempt < totalAttempts; attempt++) {
      stopwatch.start();
      longList.elementAt(limit);
      stopwatch.stop();
      longListElementAtTotalMicroseconds += stopwatch.elapsedMicroseconds;
      stopwatch.reset();

      stopwatch.start();
      alwaysIncreasing.elementAt(limit);
      stopwatch.stop();
      alwaysIncreasingElementAtTotalMicroseconds +=
          stopwatch.elapsedMicroseconds;
      stopwatch.reset();
    }

    final longListElementAtAverageMicroseconds =
        longListElementAtTotalMicroseconds / totalAttempts;
    final alwaysIncreasingElementAtAverageMicroseconds =
        alwaysIncreasingElementAtTotalMicroseconds / totalAttempts;

    expect(
        alwaysIncreasingElementAtAverageMicroseconds >
            longListElementAtAverageMicroseconds,
        null);
  });
}

class _AlwaysIncreasingIterable extends Iterable with Iterator {
  final int _start;
  int _current;

  _AlwaysIncreasingIterable(this._start) : _current = _start;

  @override
  get current => _current;

  @override
  Iterator get iterator => _AlwaysIncreasingIterable(_start);

  // Question: at some point this will throw - when will that happen?
  @override
  bool moveNext() {
    _current++;
    return true;
  }
}
