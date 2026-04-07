import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _jobCtrl = TextEditingController();
  final _salaryCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  String _salaryPeriod = 'month';
  bool _isLoading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiService.register(
        email: _emailCtrl.text.trim(),
        username: _usernameCtrl.text.trim(),
        password: _passCtrl.text,
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
        salaryAmount: data['salary_amount'],
        salaryPeriod: data['salary_period'],
        hoursPerWeek: data['hours_per_week'],
      );
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFF4A148C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.person_add_outlined,
                    size: 64,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _field('Email', _emailCtrl, Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  _field('Username', _usernameCtrl, Icons.person_outline),
                  const SizedBox(height: 12),
                  _field('Password', _passCtrl, Icons.lock_outlined,
                      obscure: true),
                  const SizedBox(height: 12),
                  _field('Job Title (optional)', _jobCtrl, Icons.work_outline),
                  const SizedBox(height: 12),
                  _field('Salary (optional)', _salaryCtrl, Icons.payments_outlined,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _field('Hours/Week', _hoursCtrl, Icons.schedule_outlined,
                            keyboardType: TextInputType.number),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _salaryPeriod,
                            dropdownColor: const Color(0xFF4A148C),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            items: const [
                              DropdownMenuItem(value: 'month', child: Text('/month')),
                              DropdownMenuItem(value: 'year', child: Text('/year')),
                            ],
                            onChanged: (v) => setState(() => _salaryPeriod = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4A148C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF4A148C),
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool obscure = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (label.contains('(optional)') || label.contains('/'))
          ? null
          : (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }
}
