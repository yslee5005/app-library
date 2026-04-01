import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Profile editing form with avatar picker, name, bio, and save button.
class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({
    required this.onSave,
    this.initialName,
    this.initialBio,
    this.avatarUrl,
    this.onAvatarTap,
    this.nameLabel = 'Name',
    this.bioLabel = 'Bio',
    this.saveLabel = 'Save',
    this.isLoading = false,
    super.key,
  });

  /// Called with name and bio when save is tapped.
  final void Function(String name, String bio) onSave;

  /// Initial display name.
  final String? initialName;

  /// Initial bio.
  final String? initialBio;

  /// Current avatar URL.
  final String? avatarUrl;

  /// Called when the avatar is tapped (to pick a new image).
  final VoidCallback? onAvatarTap;

  /// Field labels.
  final String nameLabel;
  final String bioLabel;
  final String saveLabel;

  /// Loading state.
  final bool isLoading;

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bioController = TextEditingController(text: widget.initialBio);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _nameController.text.trim(),
        _bioController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Avatar picker
          Center(
            child: GestureDetector(
              onTap: widget.onAvatarTap,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: widget.avatarUrl != null
                        ? NetworkImage(widget.avatarUrl!)
                        : null,
                    child: widget.avatarUrl == null
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: widget.nameLabel),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${widget.nameLabel} is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Bio
          TextFormField(
            controller: _bioController,
            decoration: InputDecoration(labelText: widget.bioLabel),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Save button
          FilledButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.saveLabel),
          ),
        ],
      ),
    );
  }
}
