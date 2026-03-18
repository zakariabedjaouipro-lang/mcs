/// Two-Factor Authentication Setup Screen
/// شاشة إعداد المصادقة الثنائية
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_bloc.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_event.dart';
import 'package:mcs/features/auth/presentation/bloc/advanced_auth_state.dart';

class TwoFactorAuthSetupScreen extends StatefulWidget {
  const TwoFactorAuthSetupScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<TwoFactorAuthSetupScreen> createState() =>
      _TwoFactorAuthSetupScreenState();
}

class _TwoFactorAuthSetupScreenState extends State<TwoFactorAuthSetupScreen> {
  final _codeController = TextEditingController();
  String? _secret;
  String? _qrCode;
  bool _setupComplete = false;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    // Start 2FA setup
    context.read<AdvancedAuthBloc>().add(
          TwoFactorAuthSetupRequested(widget.userId),
        );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyAndEnable2FA() {
    if (_codeController.text.isEmpty) {
      _showError(
        _isArabic ? 'يرجى إدخال الرمز' : 'Please enter the code',
      );
      return;
    }

    if (_secret == null) {
      _showError(
        _isArabic ? 'لم يتم إنشاء السر' : 'Secret not generated',
      );
      return;
    }

    context.read<AdvancedAuthBloc>().add(
          TwoFactorAuthCodeSubmitted(
            userId: widget.userId,
            code: _codeController.text.trim(),
          ),
        );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _copySecret() {
    if (_secret != null) {
      // Simulate copy to clipboard
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isArabic ? 'تم النسخ' : 'Copied',
          ),
        ),
      );
    }
  }

  void _handleSetupStarted(TwoFactorAuthSetupStarted state) {
    setState(() {
      _secret = state.secret;
      _qrCode = state.qrCode;
    });
  }

  void _handleEnabledSuccess(TwoFactorAuthEnabledSuccess state) {
    setState(() => _setupComplete = true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
        backgroundColor: Colors.green,
      ),
    );
    _showBackupCodesDialog(state.backupCodes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isArabic ? 'إعداد المصادقة الثنائية' : '2FA Setup',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<AdvancedAuthBloc, AdvancedAuthState>(
        listener: (context, state) {
          if (state is TwoFactorAuthSetupStarted) {
            _handleSetupStarted(state);
          } else if (state is TwoFactorAuthEnabledSuccess) {
            _handleEnabledSuccess(state);
          } else if (state is AdvancedAuthError) {
            _showError(state.message);
          }
        },
        child: BlocBuilder<AdvancedAuthBloc, AdvancedAuthState>(
          builder: (context, state) {
            if (state is AdvancedAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Scan QR Code
                  if (!_setupComplete) ...[
                    Text(
                      _isArabic
                          ? 'الخطوة 1: مسح رمز QR'
                          : 'Step 1: Scan QR Code',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _qrCode != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.qr_code_2,
                                      size: 80,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _isArabic ? 'رمز QR' : 'QR Code',
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Or enter secret manually
                    Text(
                      _isArabic
                          ? 'أو أدخل كود السر يدويًا'
                          : 'Or enter secret manually',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    if (_secret != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                _secret!,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: _copySecret,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 40),

                    // Step 2: Verify Code
                    Text(
                      _isArabic
                          ? 'الخطوة 2: التحقق من الرمز'
                          : 'Step 2: Verify Code',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isArabic
                          ? 'أدخل الرمز من تطبيق المصادقة'
                          : 'Enter code from authenticator app',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: _isArabic ? 'رمز المصادقة' : 'Auth Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.security),
                      ),
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state is AdvancedAuthLoading
                            ? null
                            : _verifyAndEnable2FA,
                        child: state is AdvancedAuthLoading
                            ? const CircularProgressIndicator()
                            : Text(_isArabic ? 'تفعيل' : 'Enable 2FA'),
                      ),
                    ),
                  ] else ...[
                    // Setup Complete
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _isArabic
                                ? 'تم تفعيل المصادقة الثنائية'
                                : '2FA Enabled Successfully',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBackupCodesDialog(List<String> codes) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _isArabic ? 'أكواد الاحتياطي' : 'Backup Codes',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isArabic
                  ? 'احفظ هذه الأكواد في مكان آمن'
                  : 'Save these codes in a safe place',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: codes.map((code) => Text(code)).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(_isArabic ? 'موافق' : 'OK'),
          ),
        ],
      ),
    );
  }
}
