import 'package:flutter_test/flutter_test.dart';

import 'package:nhatnguyet/main.dart';

void main() {
  testWidgets('App renders home screen with today date',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NhatNguyetApp());

    expect(find.text('Nhật Nguyệt'), findsOneWidget);
    expect(find.textContaining('Dương lịch:'), findsOneWidget);
    expect(find.textContaining('Âm lịch:'), findsOneWidget);
  });
}
