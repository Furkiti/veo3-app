import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_text_styles.dart';

class CreditModal extends StatefulWidget {
  final void Function(int count) onBuy;
  const CreditModal({super.key, required this.onBuy});

  @override
  State<CreditModal> createState() => _CreditModalState();
}

class _CreditModalState extends State<CreditModal> {
  int? _selected;
  final _options = const [
    {'count': 1, 'price': '\$0.99'},
    {'count': 3, 'price': '\$1.99'},
    {'count': 5, 'price': '\$2.99', 'highlight': 'Most Popular'},
    {'count': 10, 'price': '\$4.99', 'highlight': 'Best Value'},
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: mq.size.height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text('Get More Credits', style: AppTextStyles.sectionTitle.copyWith(color: AppColors.charcoal))),
                const SizedBox(height: 20),
                ...List.generate(_options.length, (i) {
                  final opt = _options[i];
                  final highlight = opt['highlight'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SizedBox(
                      height: 120,
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selected == i ? AppColors.accentBlue : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              if (highlight == 'Best Value')
                                BoxShadow(
                                  color: AppColors.accentBlue.withOpacity(0.18),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: i,
                                groupValue: _selected,
                                onChanged: (v) => setState(() => _selected = v),
                                activeColor: AppColors.accentBlue,
                              ),
                              Icon(AppIcons.gem, color: Colors.amberAccent, size: 28),
                              const SizedBox(width: 12),
                              Text('${opt['count']} Prompt${opt['count'] == 1 ? '' : 's'}', style: AppTextStyles.body.copyWith(color: AppColors.charcoal, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              if (highlight == 'Most Popular')
                                Row(
                                  children: [
                                    Icon(AppIcons.flame, color: Colors.deepOrange, size: 20),
                                    const SizedBox(width: 4),
                                    Text('Most Popular', style: AppTextStyles.body.copyWith(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              if (highlight == 'Best Value')
                                Row(
                                  children: [
                                    Icon(AppIcons.badge, color: AppColors.accentBlue, size: 20),
                                    const SizedBox(width: 4),
                                    Text('Best Value', style: AppTextStyles.body.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              Text(opt['price']!.toString(), style: AppTextStyles.body.copyWith(color: AppColors.charcoal)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _selected == null ? null : () => widget.onBuy(_options[_selected!]['count'] as int),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        backgroundColor: _selected == null ? Colors.grey[300] : null,
                      ).copyWith(
                        backgroundColor: _selected != null
                            ? MaterialStateProperty.all(
                                null,
                              )
                            : null,
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: Ink(
                        decoration: _selected != null
                            ? BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF8C00), Color(0xFFFFCD3C)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              )
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('Purchase', style: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 