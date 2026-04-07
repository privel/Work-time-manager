import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  static const String jobTitleKey = 'job_title';
  static const String salaryAmountKey = 'salary_amount';
  static const String salaryPeriodKey = 'salary_period';
  static const String hoursPerWeekKey = 'hours_per_week';
  static const String isLoggedInKey = 'is_logged_in';

  Future<void> saveUser({
    required int userId,
    required String username,
    String? email,
    String? jobTitle,
    double? salaryAmount,
    String? salaryPeriod,
    double? hoursPerWeek,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
    await prefs.setString(usernameKey, username);
    if (email != null) await prefs.setString(emailKey, email);
    if (jobTitle != null) await prefs.setString(jobTitleKey, jobTitle);
    if (salaryAmount != null) await prefs.setDouble(salaryAmountKey, salaryAmount);
    if (salaryPeriod != null) await prefs.setString(salaryPeriodKey, salaryPeriod);
    if (hoursPerWeek != null) await prefs.setDouble(hoursPerWeekKey, hoursPerWeek);
    await prefs.setBool(isLoggedInKey, true);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<String?> getJobTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(jobTitleKey);
  }

  Future<double?> getSalaryAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(salaryAmountKey);
  }

  Future<String?> getSalaryPeriod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(salaryPeriodKey);
  }

  Future<double?> getHoursPerWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(hoursPerWeekKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(usernameKey);
    await prefs.remove(emailKey);
    await prefs.remove(jobTitleKey);
    await prefs.remove(salaryAmountKey);
    await prefs.remove(salaryPeriodKey);
    await prefs.remove(hoursPerWeekKey);
    await prefs.remove(isLoggedInKey);
  }
}