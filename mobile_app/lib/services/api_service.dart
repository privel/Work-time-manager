import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.93.24.226:8000';

  // === Auth ===

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String? jobTitle,
    double? salaryAmount,
    String salaryPeriod = 'month',
    double? hoursPerWeek,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'username': username.trim(),
        'password': password,
        'job_title': jobTitle,
        'salary_amount': salaryAmount,
        'salary_period': salaryPeriod,
        'hours_per_week': hoursPerWeek,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Registration failed');
    }
  }

  // === User Management ===

  static Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<Map<String, dynamic>> updateUser(
    int userId, {
    String? email,
    String? username,
    String? password,
    String? jobTitle,
    double? salaryAmount,
    String? salaryPeriod,
    double? hoursPerWeek,
  }) async {
    final body = <String, dynamic>{};
    if (email != null) body['email'] = email.trim();
    if (username != null) body['username'] = username.trim();
    if (password != null) body['password'] = password;
    if (jobTitle != null) body['job_title'] = jobTitle;
    if (salaryAmount != null) body['salary_amount'] = salaryAmount;
    if (salaryPeriod != null) body['salary_period'] = salaryPeriod;
    if (hoursPerWeek != null) body['hours_per_week'] = hoursPerWeek;

    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to update user');
    }
  }

  // === Toilet Visits ===

  static Future<List<Map<String, dynamic>>> getVisits(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/visits'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load visits');
    }
  }

  static Future<Map<String, dynamic>> createManualVisit(
    int userId,
    double durationMinutes,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/visits/manual'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'duration_minutes': durationMinutes,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('duration_minutes is required and must be > 0');
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create visit');
    }
  }

  static Future<Map<String, dynamic>> startVisit(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/visits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to start visit');
    }
  }

  static Future<Map<String, dynamic>> endVisit(int userId, int visitId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/visits/$visitId/end'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Visit not found');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to end visit');
    }
  }

  static Future<Map<String, dynamic>> getCostEstimate(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/cost'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load cost estimate');
    }
  }

  static Future<void> deleteVisit(int userId, int visitId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/visits/$visitId'),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw Exception('Visit not found');
      }
      throw Exception('Failed to delete visit');
    }
  }

  // === Leaderboard ===

  static Future<List<Map<String, dynamic>>> getLeaderboard({
    int limit = 50,
    bool sortByTime = false,
  }) async {
    final endpoint = sortByTime ? 'leaderboard/time' : 'leaderboard';
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint?limit=$limit'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    // Fetch all leaderboard entries (limit 1000)
    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard?limit=1000'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
