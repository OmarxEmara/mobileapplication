import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiBaseUrl = 'http://localhost:5000';
  
  static Future<Map<String, dynamic>> predict(List<double> featureArray) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'feature_array': featureArray}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to make prediction: ${response.reasonPhrase}');
    }
  }
}
