import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Accueil'},
      {'icon': Icons.people_rounded, 'label': 'Clients'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Commandes'},
      {'icon': Icons.payments_rounded, 'label': 'Paiements'},
      {'icon': Icons.settings_rounded, 'label': 'Réglages'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmWhite.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: active
                          ? AppColors.caramel.withOpacity(0.08)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[i]['icon'] as IconData,
                          size: active ? 24 : 22,
                          color: active
                              ? AppColors.caramel
                              : AppColors.midGrey,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i]['label'] as String,
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: active
                                ? AppColors.caramel
                                : AppColors.midGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Status Pill ─────────────────────────────────────────────────────────────
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.caramel,
                letterSpacing: 1,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: AppColors.lightGrey, width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.midGrey,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.deepBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAB ─────────────────────────────────────────────────────────────────────
class AppFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AppFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.caramel, AppColors.gold],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.caramel.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}

// ─── Payment Progress Bar ────────────────────────────────────────────────────
class PaymentProgressBar extends StatelessWidget {
  final double percent;
  final double total;
  final double paid;

  const PaymentProgressBar({
    super.key,
    required this.percent,
    required this.total,
    required this.paid,
  });

  @override
  Widget build(BuildContext context) {
    final reste = total - paid;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: AppColors.lightGrey,
            valueColor: AlwaysStoppedAnimation(
              percent >= 1 ? AppColors.sage : AppColors.caramel,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percent * 100).round()}% payé',
              style: GoogleFonts.dmSans(
                  fontSize: 11, color: AppColors.midGrey),
            ),
            Text(
              'Reste : ${_formatF(reste)}',
              style: GoogleFonts.dmSans(
                  fontSize: 11, color: AppColors.midGrey),
            ),
          ],
        ),
      ],
    );
  }

  String _formatF(double v) {
    if (v <= 0) return '0 F';
    return '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';
  }
}

// ─── Toast helper ─────────────────────────────────────────────────────────────
void showAppToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.gold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xE61C1008),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      duration: const Duration(seconds: 2),
    ),
  );
}
