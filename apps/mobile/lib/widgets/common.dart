import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/decorations.dart';

class Pebble extends StatelessWidget {
  const Pebble({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    this.active = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: active
                  ? const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)]
                  : const [Colors.white, Color(0xFFF8FAFD)],
            ),
            boxShadow: [
              BoxShadow(
                color: (active ? appBlue : appInk)
                    .withValues(alpha: active ? 0.12 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: (active ? appBlue : appInk)
                    .withValues(alpha: active ? 0.06 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class PebbleIconButton extends StatelessWidget {
  const PebbleIconButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: pebbleDecoration(radius: 22, shadowOpacity: 0.05),
        child: Icon(icon, color: appInk, size: 28),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.action, super.key});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: appInk, fontSize: 17, fontWeight: FontWeight.w900)),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 13,
                  fontWeight: FontWeight.w800),
            ),
        ],
      ),
    );
  }
}

class EmptyAlertPebble extends StatelessWidget {
  const EmptyAlertPebble({super.key});

  @override
  Widget build(BuildContext context) {
    return const Pebble(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      child: Column(
        children: [
          Icon(Icons.bedtime_rounded, size: 34, color: appMuted),
          SizedBox(height: 10),
          Text(
            '아직 설정된 알림이 없어요\n위에서 역을 검색해 알림을 추가하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: appMuted,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: appBlue,
          disabledBackgroundColor: const Color(0xFFCBD5E1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class DangerButton extends StatelessWidget {
  const DangerButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFEE2E2),
          foregroundColor: const Color(0xFFDC2626),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class SheetShell extends StatelessWidget {
  const SheetShell({required this.child, this.maxHeightFactor, super.key});

  final Widget child;
  final double? maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          constraints: maxHeightFactor == null
              ? null
              : BoxConstraints(maxHeight: height * maxHeightFactor!),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF8FAFD)],
            ),
            boxShadow: [
              BoxShadow(
                  color: Color(0x260F172A),
                  blurRadius: 40,
                  offset: Offset(0, -10)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class SheetGrabber extends StatelessWidget {
  const SheetGrabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
            color: const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(3)),
      ),
    );
  }
}
