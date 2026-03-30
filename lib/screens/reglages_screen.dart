import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ReglagesScreen extends StatelessWidget {
  final VoidCallback onLogout;
  const ReglagesScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: [
                _buildProfileCard(),
                const SizedBox(height: 16),
                _buildSection('🏪 Atelier', [
                  _settingItem(Icons.store_rounded, 'Infos de l\'atelier', ''),
                  _settingItem(Icons.palette_rounded, 'Personnalisation', ''),
                  _settingItem(
                      Icons.receipt_long_rounded, 'Modèles de reçu', ''),
                ]),
                const SizedBox(height: 12),
                _buildSection('🔔 Notifications', [
                  _settingItemToggle(
                      Icons.notifications_rounded, 'Rappels livraison', true),
                  _settingItemToggle(
                      Icons.payment_rounded, 'Alertes impayés', true),
                  _settingItemToggle(
                      Icons.calendar_today_rounded, 'Essayages', false),
                ]),
                const SizedBox(height: 12),
                _buildSection('📊 Données', [
                  _settingItem(
                      Icons.backup_rounded, 'Sauvegarder', ''),
                  _settingItem(
                      Icons.download_rounded, 'Exporter CSV', ''),
                ]),
                const SizedBox(height: 12),
                _buildSection('🔒 Sécurité', [
                  _settingItem(
                      Icons.lock_rounded, 'Changer le mot de passe', ''),
                  _settingItem(
                      Icons.fingerprint_rounded, 'Biométrie', ''),
                ]),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onLogout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.terracotta.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded,
                            color: AppColors.terracotta, size: 18),
                        const SizedBox(width: 8),
                        Text('Se déconnecter',
                            style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.terracotta)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('CoutureApp v1.0.0',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.midGrey)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.warmWhite,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            border:
                Border(bottom: BorderSide(color: AppColors.lightGrey)),
          ),
          child: Row(
            children: [
              Text('Réglages',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepBrown)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepBrown, Color(0xFF4A2C1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.caramel, AppColors.gold]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text('AD',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Adama Diallo',
                    style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('Gérant · admin@couture.cm',
                    style: GoogleFonts.dmSans(
                        fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded,
              color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.caramel,
                    letterSpacing: 0.8)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: AppColors.lightGrey, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.deepBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.deepBrown)),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.midGrey, size: 18),
        ],
      ),
    );
  }

  Widget _settingItemToggle(
      IconData icon, String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: AppColors.lightGrey, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.deepBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.deepBrown)),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: AppColors.caramel,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
