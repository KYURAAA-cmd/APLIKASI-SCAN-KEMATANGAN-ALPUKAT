import 'package:avocado_scanner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen shows main scan action', (tester) async {
    await tester.pumpWidget(const AvocadoScannerApp());

    expect(find.text('Avocado Ripeness Scanner'), findsOneWidget);
    expect(find.text('Mulai Scan'), findsOneWidget);
  });
}
