import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLength;
  const PromptInput({
    super.key,
    required this.controller,
    this.validator,
    this.maxLength = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 5,
          maxLength: maxLength,
          style: AppTextStyles.body,
          decoration: const InputDecoration(
            hintText: 'Type your scene…',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          validator: validator,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: Text(
            '${controller.text.length}/$maxLength',
            style: AppTextStyles.caption.copyWith(
              color: controller.text.length > maxLength
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
      ],
    );
  }
} 