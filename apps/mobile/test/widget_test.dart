import 'package:flutter_test/flutter_test.dart';
import 'package:subway_push/main.dart';

void main() {
    testWidgets('renders subway push home screen', (tester) async {
        await tester.pumpWidget(const SubwayPushApp());

        expect(find.text('지하철 푸시'), findsOneWidget);
        expect(find.text('역 이름을 검색해보세요'), findsOneWidget);
        expect(find.text('내 알림'), findsOneWidget);
    });
}
