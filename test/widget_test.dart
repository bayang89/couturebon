import 'package:flutter_test/flutter_test.dart';
import 'package:couture_app/main.dart';

void main() {
  testWidgets('CoutureApp lance sans erreur', (WidgetTester tester) async {
    await tester.pumpWidget(const CoutureApp());
    expect(find.byType(CoutureApp), findsOneWidget);
  });
}
