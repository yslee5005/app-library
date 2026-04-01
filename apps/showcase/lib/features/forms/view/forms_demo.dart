import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class FormsDemo extends StatefulWidget {
  const FormsDemo({super.key});

  @override
  State<FormsDemo> createState() => _FormsDemoState();
}

class _FormsDemoState extends State<FormsDemo> {
  double _rating = 3.5;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'AppTextField'),
          const AppTextField(
            label: 'Name',
            hint: 'Enter your name',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Password',
            hint: 'Enter password',
            prefixIcon: Icons.lock,
            obscure: true,
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Bio',
            hint: 'Tell us about yourself',
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          const AppTextField(
            label: 'Disabled',
            hint: 'Cannot edit',
            enabled: false,
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppButton variants'),
          AppButton(
            label: 'Primary',
            onPressed: () {},
            expand: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Secondary',
            variant: AppButtonVariant.secondary,
            onPressed: () {},
            expand: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Outline',
            variant: AppButtonVariant.outline,
            onPressed: () {},
            expand: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Text',
            variant: AppButtonVariant.text,
            onPressed: () {},
            expand: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'With Icon',
            icon: Icons.send,
            onPressed: () {},
            expand: true,
          ),
          const SizedBox(height: 8),
          const AppButton(
            label: 'Loading',
            isLoading: true,
            expand: true,
          ),
          const SizedBox(height: 8),
          const AppButton(label: 'Disabled', expand: true),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppDateTimePicker'),
          AppDateTimePicker(
            label: 'Select Date & Time',
            value: _selectedDate,
            onChanged: (dt) => setState(() => _selectedDate = dt),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppRatingBar'),
          AppRatingBar(
            rating: _rating,
            onRatingChanged: (r) => setState(() => _rating = r),
          ),
          const SizedBox(height: 8),
          Text('Rating: ${_rating.toStringAsFixed(1)}'),
          const SizedBox(height: 24),
          _sectionTitle(context, 'FormSection'),
          FormSection(
            title: 'Personal Info',
            description: 'Enter your basic information.',
            children: [
              const AppTextField(label: 'First Name', hint: 'John'),
              const SizedBox(height: 8),
              const AppTextField(label: 'Last Name', hint: 'Doe'),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppImagePicker'),
          AppImagePicker(
            label: 'Choose Photo',
            onPickRequested: (source) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pick from: ${source.name}')),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
