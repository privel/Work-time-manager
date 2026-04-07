import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/services/local_storage_service.dart';

class AuthService extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final StreamController<void> _streamController = StreamController<void>.broadcast();
  Stream<void> get stream => _streamController.stream;

  bool _isReady = false;
  bool _isLoggedIn = false;
  int? _userId;
  String? _username;
  String? _email;
  String? _jobTitle;
  double? _salaryAmount;
  String? _salaryPeriod;
  double? _hoursPerWeek;

  bool get isReady => _isReady;
  bool get isLoggedIn => _isLoggedIn;
  int? get userId => _userId;
  String? get username => _username;
  String? get email => _email;
  String? get jobTitle => _jobTitle;
  double? get salaryAmount => _salaryAmount;
  String? get salaryPeriod => _salaryPeriod;
  double? get hoursPerWeek => _hoursPerWeek;

  Future<void> init() async {
    _userId = await _storage.getUserId();
    _username = await _storage.getUsername();
    _email = await _storage.getEmail();
    _jobTitle = await _storage.getJobTitle();
    _salaryAmount = await _storage.getSalaryAmount();
    _salaryPeriod = await _storage.getSalaryPeriod();
    _hoursPerWeek = await _storage.getHoursPerWeek();
    _isLoggedIn = await _storage.isLoggedIn();
    _isReady = true;
    notifyListeners();
    _streamController.add(null);
  }

  Future<void> login({
    required int userId,
    required String username,
    String? email,
    String? jobTitle,
    double? salaryAmount,
    String? salaryPeriod,
    double? hoursPerWeek,
  }) async {
    await _storage.saveUser(
      userId: userId,
      username: username,
      email: email,
      jobTitle: jobTitle,
      salaryAmount: salaryAmount,
      salaryPeriod: salaryPeriod,
      hoursPerWeek: hoursPerWeek,
    );
    _userId = userId;
    _username = username;
    _email = email;
    _jobTitle = jobTitle;
    _salaryAmount = salaryAmount;
    _salaryPeriod = salaryPeriod;
    _hoursPerWeek = hoursPerWeek;
    _isLoggedIn = true;
    notifyListeners();
    _streamController.add(null);
  }

  Future<void> logout() async {
    await _storage.clearUser();
    _userId = null;
    _username = null;
    _email = null;
    _jobTitle = null;
    _salaryAmount = null;
    _salaryPeriod = null;
    _hoursPerWeek = null;
    _isLoggedIn = false;
    notifyListeners();
    _streamController.add(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
