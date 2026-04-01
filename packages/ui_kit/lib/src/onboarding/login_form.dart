import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Email + password login form with social login buttons.
class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onLogin,
    this.onGoogleLogin,
    this.onAppleLogin,
    this.onForgotPassword,
    this.emailLabel = 'Email',
    this.passwordLabel = 'Password',
    this.loginLabel = 'Log In',
    this.forgotPasswordLabel = 'Forgot Password?',
    this.googleLabel = 'Continue with Google',
    this.appleLabel = 'Continue with Apple',
    this.orDividerLabel = 'or',
    this.isLoading = false,
    super.key,
  });

  /// Called with email and password when the login button is pressed.
  final void Function(String email, String password) onLogin;

  /// Called when Google login is tapped. Hidden if null.
  final VoidCallback? onGoogleLogin;

  /// Called when Apple login is tapped. Hidden if null.
  final VoidCallback? onAppleLogin;

  /// Called when forgot password is tapped. Hidden if null.
  final VoidCallback? onForgotPassword;

  /// Field labels and button text.
  final String emailLabel;
  final String passwordLabel;
  final String loginLabel;
  final String forgotPasswordLabel;
  final String googleLabel;
  final String appleLabel;
  final String orDividerLabel;

  /// Whether the form is in a loading state.
  final bool isLoading;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: widget.emailLabel),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${widget.emailLabel} is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Password
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: widget.passwordLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${widget.passwordLabel} is required';
                }
                return null;
              },
            ),

            // Forgot password
            if (widget.onForgotPassword != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onForgotPassword,
                  child: Text(widget.forgotPasswordLabel),
                ),
              ),

            const SizedBox(height: AppSpacing.md),

            // Login button
            FilledButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.loginLabel),
            ),

            // Social login section
            if (widget.onGoogleLogin != null ||
                widget.onAppleLogin != null) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Text(
                        widget.orDividerLabel,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              if (widget.onGoogleLogin != null) ...[
                OutlinedButton.icon(
                  onPressed: widget.isLoading ? null : widget.onGoogleLogin,
                  icon: const Icon(Icons.g_mobiledata),
                  label: Text(widget.googleLabel),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (widget.onAppleLogin != null)
                OutlinedButton.icon(
                  onPressed: widget.isLoading ? null : widget.onAppleLogin,
                  icon: const Icon(Icons.apple),
                  label: Text(widget.appleLabel),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
