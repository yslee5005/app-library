import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Sign up form with name, email, password, and confirm password fields.
class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.onSignUp,
    this.nameLabel = 'Name',
    this.emailLabel = 'Email',
    this.passwordLabel = 'Password',
    this.confirmPasswordLabel = 'Confirm Password',
    this.signUpLabel = 'Sign Up',
    this.passwordMismatchError = 'Passwords do not match',
    this.isLoading = false,
    this.spacing,
    this.buttonStyle,
    super.key,
  });

  /// Called with name, email, and password when the form is submitted.
  final void Function(String name, String email, String password) onSignUp;

  /// Field labels and button text.
  final String nameLabel;
  final String emailLabel;
  final String passwordLabel;
  final String confirmPasswordLabel;
  final String signUpLabel;
  final String passwordMismatchError;

  /// Whether the form is in a loading state.
  final bool isLoading;

  /// Optional spacing between form fields. Defaults to [AppSpacing.md].
  final double? spacing;

  /// Optional style for the sign up button.
  final ButtonStyle? buttonStyle;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: widget.nameLabel),
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '${widget.nameLabel} is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: widget.spacing ?? AppSpacing.md),

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
              SizedBox(height: widget.spacing ?? AppSpacing.md),

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
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                obscureText: _obscurePassword,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${widget.passwordLabel} is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: widget.spacing ?? AppSpacing.md),

              // Confirm password
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: widget.confirmPasswordLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                obscureText: _obscureConfirm,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return widget.passwordMismatchError;
                  }
                  return null;
                },
              ),
              SizedBox(height: widget.spacing ?? AppSpacing.lg),

              // Sign up button
              FilledButton(
                onPressed: widget.isLoading ? null : _submit,
                style: widget.buttonStyle,
                child:
                    widget.isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(widget.signUpLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
