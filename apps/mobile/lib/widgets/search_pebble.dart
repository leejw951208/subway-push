import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'common.dart';

class SearchPebble extends StatelessWidget {
  const SearchPebble({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pebble(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  const LinearGradient(colors: [Color(0xFF3B82F6), appBlue]),
              boxShadow: [
                BoxShadow(
                    color: appBlue.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child:
                const Icon(Icons.search_rounded, color: Colors.white, size: 23),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              '알림 받을 역을 선택하세요',
              style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
