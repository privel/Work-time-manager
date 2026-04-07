import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _jobCtrl;
  late TextEditingController _salaryCtrl;
  late TextEditingController _hoursCtrl;

  String _salaryPeriod = 'month';
  bool _isLoading = false;
  bool _isEditing = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: authService.username ?? '');
    _emailCtrl = TextEditingController(text: authService.email ?? '');
    _jobCtrl = TextEditingController(text: authService.jobTitle ?? '');
    _salaryCtrl = TextEditingController(
      text: authService.salaryAmount?.toString() ?? '',
    );
    _hoursCtrl = TextEditingController(
      text: authService.hoursPerWeek?.toString() ?? '',
    );
    _salaryPeriod = authService.salaryPeriod ?? 'month';
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _jobCtrl.dispose();
    _salaryCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final data = await ApiService.updateUser(
        authService.userId!,
        username: _usernameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        jobTitle: _jobCtrl.text.trim().isEmpty ? null : _jobCtrl.text.trim(),
        salaryAmount: _salaryCtrl.text.isEmpty ? null : double.tryParse(_salaryCtrl.text),
        salaryPeriod: _salaryPeriod,
        hoursPerWeek: _hoursCtrl.text.isEmpty ? null : double.tryParse(_hoursCtrl.text),
      );

      await authService.login(
        userId: data['id'],
        username: data['username'],
        email: data['email'],
        jobTitle: data['job_title'],
        salaryAmount: data['salary_amount']?.toDouble(),
        salaryPeriod: data['salary_period'],
        hoursPerWeek: data['hours_per_week']?.toDouble(),
      );

      setState(() {
        _isEditing = false;
        _successMessage = 'Saved successfully';
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await authService.logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF4A148C)),
                      onPressed: () => context.go('/home'),
                    ),
                    if (!_isEditing)
                      IconButton(
                        // icon: const Icon(Icons.edit, color: Color(0xFF4A148C)),
                        icon:Icon(IconlyLight.edit, color: Color(0xFF4A148C)), 
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                            _successMessage = null;
                            _errorMessage = null;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 32),

                if (_successMessage != null)
                  _buildMessage(_successMessage!, true),
                if (_errorMessage != null)
                  _buildMessage(_errorMessage!, false),
                const SizedBox(height: 16),

                _sectionTitle('Account'),
                const SizedBox(height: 12),
                _field('Username', _usernameCtrl, Icons.person_outline,
                    enabled: _isEditing),
                const SizedBox(height: 12),
                _field('Email', _emailCtrl, Icons.email_outlined,
                    enabled: _isEditing, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 24),

                _sectionTitle('Work'),
                const SizedBox(height: 12),
                _field('Job Title', _jobCtrl, Icons.work_outline,
                    enabled: _isEditing),
                const SizedBox(height: 12),
                _field('Salary', _salaryCtrl, Icons.payments_outlined,
                    enabled: _isEditing, keyboardType: TextInputType.number),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _field('Hours/Week', _hoursCtrl, Icons.schedule_outlined,
                          enabled: _isEditing, keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    _salaryPeriodDropdown(),
                  ],
                ),
                const SizedBox(height: 32),

                if (_isEditing) ...[
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _usernameCtrl.text = authService.username ?? '';
                        _emailCtrl.text = authService.email ?? '';
                        _jobCtrl.text = authService.jobTitle ?? '';
                        _salaryCtrl.text = authService.salaryAmount?.toString() ?? '';
                        _hoursCtrl.text = authService.hoursPerWeek?.toString() ?? '';
                        _salaryPeriod = authService.salaryPeriod ?? 'month';
                        _errorMessage = null;
                        _successMessage = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF666666),
                      side: const BorderSide(color: Color(0xFFCCCCCC)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 54),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 32),
                ],

                const Divider(color: Color(0xFFE0E0E0), height: 32),

                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.8),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF666666),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool enabled = true, TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(
        color: enabled ? const Color(0xFF1A1A2E) : const Color(0xFF999999),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? const Color(0xFF666666) : const Color(0xFFCCCCCC),
        ),
        prefixIcon: Icon(icon, color: enabled ? const Color(0xFF4A148C) : const Color(0xFFCCCCCC)),
        filled: true,
        fillColor: enabled
            ? Colors.white
            : const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7B1FA2), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) {
        if (label == 'Email' && (v == null || v.isEmpty)) return 'Enter email';
        if (label == 'Username' && (v == null || v.isEmpty)) return 'Enter username';
        return null;
      },
    );
  }

  Widget _salaryPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _salaryPeriod,
          dropdownColor: Colors.white,
          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A148C)),
          items: const [
            DropdownMenuItem(value: 'month', child: Text('/month')),
            DropdownMenuItem(value: 'year', child: Text('/year')),
          ],
          onChanged: _isEditing ? (v) => setState(() => _salaryPeriod = v!) : null,
        ),
      ),
    );
  }

  Widget _buildMessage(String message, bool isSuccess) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.greenAccent.withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSuccess ? Colors.greenAccent.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: isSuccess ? Colors.green : Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isSuccess ? const Color(0xFF2E7D32) : Colors.redAccent,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
