import 'package:flutter/material.dart';
import 'package:siresep/core/constants/app_colors.dart';
import 'package:siresep/core/constants/app_sizes.dart';
import 'package:siresep/core/constants/app_text_styles.dart';
import 'package:siresep/core/widgets/custom_text_field.dart';

class ChangeNamePage extends StatefulWidget {
  final String initialName;

  const ChangeNamePage({
    super.key,
    required this.initialName,
  });

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTextStyles.bodySecondary,
          ),
        ),
        title: Text(
          'Change Name',
          style: AppTextStyles.h2,
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _onSave,
            child: _isLoading
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              'Done',
              style: AppTextStyles.smallBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSizes.spaceS),
            CustomTextField(
              controller: _controller,
              hintText: 'Masukkan nama',
            ),
          ],
        ),
      ),
    );
  }
}