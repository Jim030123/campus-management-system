import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchUsers() async {
  final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to fetch users');
  }
}
