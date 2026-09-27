import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/api/api_exception.dart';
import '../../state/app_state.dart';
import '../../state/reports_provider.dart';
import '../../widgets/common/brand.dart';
import '../../widgets/common/feedback.dart';
import '../../widgets/common/surfaces.dart';
import '../../l10n/app_localizations.dart';

enum AuthMode { signIn, signUp }

/// Sign in or create an account.
///
/// An account is entirely optional: anonymous reporting is the default and
/// stays fully functional, because the product's privacy promise depends on
/// not requiring identity to contribute. Registering only makes your reports,
/// saved places and contacts portable to another phone — and the screen says
/// so rather than implying you must sign up.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signIn});

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  late AuthMode _mode = widget.initialMode;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  bool get _isSignUp => _mode == AuthMode.signUp;

  /// Accepts the formats people actually type: 03001234567, +92 300 1234567,
  /// 3001234567, with or without spaces and dashes.
  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Enter your mobile number';
    final ok = (digits.length == 11 && digits.startsWith('03')) ||
        (digits.length == 12 && digits.startsWith('92')) ||
        (digits.length == 10 && digits.startsWith('3'));
    if (!ok) return 'Enter a Pakistani mobile number, e.g. 0300 1234567';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter your password';
    if (!_isSignUp) return null;
    if (v.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[a-zA-Z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
      return 'Use letters and numbers';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    // Captured before any await, so no BuildContext crosses an async gap.
    final reports = context.read<ReportsProvider>();
    final api = reports.api;
    final app = context.read<AppState>();

    try {
      final user = _isSignUp
          ? await api.register(
              phone: _phone.text,
              password: _password.text,
              displayName: _name.text.trim(),
            )
          : await api.login(phone: _phone.text, password: _password.text);

      app.signIn(account: user);
      // Reload so the account's own reports replace the anonymous set.
      await reports.load(offline: app.offline);

      if (!mounted) return;
      Navigator.of(context).pop(true);
      Toast.show(
        context,
        _isSignUp
            ? 'Account created. Your reports moved across.'
            : 'Signed in.',
        tone: ToastTone.success,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not complete that. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gutter = Gap.page(context);
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Gap.x4l),
          children: [
            const SafarLogo(size: 56),
            const SizedBox(height: Gap.xl),
            Text(
              _isSignUp ? 'Create an account' : 'Welcome back',
              style: t.displaySmall,
            ),
            const SizedBox(height: Gap.sm),
            Text(
              _isSignUp
                  ? 'Optional. It keeps your reports, saved places and contacts '
                      'if you change phone.'
                  : 'Sign in to bring your reports and saved places to this phone.',
              style: t.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: Gap.xl),

            // --- Mode switch ----------------------------------------------
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: context.tokens.isDark
                    ? context.tokens.surfaceAlt
                    : const Color(0xFFEDF0F5),
                borderRadius: Radii.allMd,
              ),
              child: Row(
                children: [
                  for (final mode in AuthMode.values)
                    Expanded(
                      child: GestureDetector(
                        onTap: _busy
                            ? null
                            : () => setState(() {
                                  _mode = mode;
                                  _error = null;
                                }),
                        child: AnimatedContainer(
                          duration: Motion.fast,
                          padding:
                              const EdgeInsets.symmetric(vertical: Gap.md - 2),
                          decoration: BoxDecoration(
                            color: _mode == mode
                                ? context.scheme.surface
                                : Colors.transparent,
                            borderRadius: Radii.allSm,
                            boxShadow: _mode == mode
                                ? context.tokens.cardShadow
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            mode == AuthMode.signIn ? 'Sign in' : 'Sign up',
                            style: t.titleSmall?.copyWith(
                              color: _mode == mode
                                  ? context.scheme.primary
                                  : context.tokens.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: Gap.xl),

            // --- Fields ------------------------------------------------------
            if (_isSignUp) ...[
              TextFormField(
                controller: _name,
                enabled: !_busy,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: L.of(context).nameOptional,
                  hintText: L.of(context).shownOnly,
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                ),
              ),
              const SizedBox(height: Gap.md),
            ],

            TextFormField(
              controller: _phone,
              enabled: !_busy,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]')),
                LengthLimitingTextInputFormatter(18),
              ],
              validator: _validatePhone,
              decoration: InputDecoration(
                labelText: L.of(context).mobileNumber,
                hintText: '0300 1234567',
                prefixIcon: Icon(Icons.phone_outlined, size: 20),
              ),
            ),
            const SizedBox(height: Gap.md),

            TextFormField(
              controller: _password,
              enabled: !_busy,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: L.of(context).password,
                hintText: _isSignUp ? 'At least 8 characters' : null,
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Show password' : 'Hide password',
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: Gap.lg),
              InfoPanel(
                text: _error!,
                icon: Icons.error_outline_rounded,
                tone: AppColors.danger,
              ),
            ],

            const SizedBox(height: Gap.xl),
            FilledButton(
              onPressed: _busy ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isSignUp ? 'Create account' : 'Sign in'),
            ),

            const SizedBox(height: Gap.lg),
            OutlinedButton(
              onPressed: _busy ? null : () => Navigator.of(context).pop(false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(L.of(context).continueWithoutAccount),
            ),

            const SizedBox(height: Gap.xl),
            InfoPanel(
              title: L.of(context).doNeedAccount,
              text:
                  L.of(context).reportingRoutesCheckInsAll,
              icon: Icons.lock_outline_rounded,
              tone: AppColors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
