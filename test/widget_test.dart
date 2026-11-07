import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sawari/data.dart';
import 'package:sawari/main.dart';
import 'package:sawari/models.dart';
import 'package:sawari/widgets/common.dart';

void main() {
  test('formats Pakistani rupee amounts', () {
    expect(formatPkr(0), 'Rs 0');
    expect(formatPkr(380), 'Rs 380');
    expect(formatPkr(1470), 'Rs 1,470');
    expect(formatPkr(128500), 'Rs 128,500');
  });

  test('computes Mini fares and trip estimates', () {
    final mini = serviceById('mini');
    expect(mini.fareFor(14.8), 770);
    expect(estimateMinutes(14.8), 42);
  });

  testWidgets('splash opens the Lahore home screen', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SawariApp());
    expect(find.text('Sawari'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Assalam-o-Alaikum'), findsOneWidget);
    expect(find.text('Where to in Lahore?'), findsOneWidget);
    expect(find.text('Choose your sawari'), findsOneWidget);
  });
}
