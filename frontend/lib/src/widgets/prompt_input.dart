import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class PromptInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLength;
  final List<String>? promptHistory;
  const PromptInput({
    super.key,
    required this.controller,
    this.validator,
    this.maxLength = 800,
    this.promptHistory,
  });

  @override
  State<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends State<PromptInput> {
  bool _showClear = false;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _showClear = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 120),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextFormField(
                    controller: widget.controller,
                    maxLines: null,
                    minLines: 4,
                    maxLength: widget.maxLength,
                    style: AppTextStyles.body.copyWith(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Generate a tranquil beach sunset with waves…',
                      hintStyle: TextStyle(color: AppColors.subtextGray),
                      isCollapsed: true,
                      counterText: '',
                    ),
                    validator: widget.validator,
                  ),
                ),
              ),
            ),
            if (_showClear)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => widget.controller.clear(),
                  child: const Icon(Icons.close, color: AppColors.subtextGray, size: 22),
                ),
              ),
          ],
        ),
        if (widget.promptHistory != null && widget.promptHistory!.isNotEmpty) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _showHistory = !_showHistory),
            child: Row(
              children: [
                Text('Recent prompts', style: AppTextStyles.subtext),
                Icon(_showHistory ? Icons.expand_less : Icons.expand_more, color: AppColors.subtextGray, size: 18),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: widget.promptHistory!
                  .take(5)
                  .map((p) => ListTile(
                        title: Text(p, style: AppTextStyles.caption.copyWith(color: Colors.white)),
                        onTap: () => widget.controller.text = p,
                      ))
                  .toList(),
            ),
            crossFadeState: _showHistory ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ],
    );
  }
} 