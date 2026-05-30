// 앱에서 사용할 지하철 API 서버 주소 설정을 제공한다.
class ApiConfig {
  const ApiConfig({required this.baseUrl});

  final String baseUrl;

  static const emulator = ApiConfig(baseUrl: 'http://10.0.2.2:3000');
  static const localhost = ApiConfig(baseUrl: 'http://127.0.0.1:3000');
}
