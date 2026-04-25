import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Simple email field + submit button for password recovery.
class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    required this.onSubmit,
    this.emailLabel = 'Email',
    this.submitLabel = 'Send Reset Link',
    this.description,
    this.isLoading = false,
    this.spacing,
    super.key,
  });

  /// Called with the email when the submit button is pressed.
  final void Function(String email) onSubmit;

  /// Label for the email field.
  final String emailLabel;

  /// Label for the submit button.
  final String submitLabel;

  /// Optional description text shown above the form.
  final String? description;

  /// Whether the form is in a loading state.
  final bool isLoading;

  /// Optional spacing between form elements. Defaults to [AppSpacing.lg].
  final double? spacing;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(_emailController.text.trim());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.description != null) ...[
              Text(
                widget.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: widget.spacing ?? AppSpacing.lg),
            ],

            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: widget.emailLabel),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${widget.emailLabel} is required';
                }
                return null;
              },
            ),
            SizedBox(height: widget.spacing ?? AppSpacing.lg),

            // Submit button
            FilledButton(
              onPressed: widget.isLoading ? null : _submit,
              child:
                  widget.isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(widget.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
