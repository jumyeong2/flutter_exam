import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

class ShareUtils {
  // 내 성향 결과를 URL로 변환
  static String generateProfileShareUrl(Map<String, double> myScores) {
    final data = {'type': 'profile', 'scores': myScores};
    return _encodeToUrl(data);
  }

  // 팀 궁합 결과를 URL로 변환
  static String generateTeamShareUrl(
    Map<String, double> myScores,
    List<Map<String, dynamic>> partnersList,
  ) {
    final data = {
      'type': 'team',
      'myScores': myScores,
      'partnersList': partnersList,
    };
    return _encodeToUrl(data);
  }

  // 데이터를 URL로 인코딩
  static String _encodeToUrl(Map<String, dynamic> data) {
    try {
      final jsonString = jsonEncode(data);
      final base64String = base64Encode(utf8.encode(jsonString));
      final encodedData = Uri.encodeComponent(base64String);

      // 웹에서는 /result 경로 사용, 앱에서는 쿼리 파라미터 사용
      if (kIsWeb) {
        return '${Uri.base.origin}/result?data=$encodedData';
      } else {
        return 'https://cosynctest.web.app/result?data=$encodedData';
      }
    } catch (e) {
      debugPrint('Error encoding data: $e');
      if (kIsWeb) {
        return Uri.base.origin;
      } else {
        return 'https://cosynctest.web.app';
      }
    }
  }

  // URL에서 데이터 디코딩 (나중에 웹에서 결과 복원 시 사용)
  static Map<String, dynamic>? decodeFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final encodedData = uri.queryParameters['data'];
      if (encodedData == null) return null;

      final decodedData = Uri.decodeComponent(encodedData);
      final jsonString = utf8.decode(base64Decode(decodedData));
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding data: $e');
      return null;
    }
  }
}
