import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ToggleRow extends StatelessWidget {
  const ToggleRow({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: value ? const Color(0x403B82F6) : const Color(0x0D0F172A),
              width: value ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: value ? Colors.white : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                boxShadow: value
                    ? [
                        BoxShadow(
                            color: appBlue.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2))
                      ]
                    : null,
              ),
              child: Icon(icon, color: value ? appBlue : appMuted, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: value ? const Color(0xFF1D4ED8) : appInk,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: TextStyle(
                      color: value
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
                value: value, onChanged: onChanged, activeThumbColor: appBlue),
          ],
        ),
      ),
    );
  }
}
