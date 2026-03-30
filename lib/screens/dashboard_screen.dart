import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';
import '../widgets/shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int) onNavigate;
  final Function(Commande) onCommandeTap;

  const DashboardScreen({
    super.key,
    required this.onNavigate,
    required this.onCommandeTap,
  });

  @override
  Widget build(BuildContext context) {
    final commandes = AppData.commandes;
    final retards = commandes
        .where((c) => c.statut == StatutCommande.retard)
        .length;
    final enCours = commandes
        .where((c) =>
            c.statut == StatutCommande.enCouture ||
            c.statut == StatutCommande.essayage)
        .length;
    final totalMoisF = commandes.fold<double>(
        0, (s, c) => s + c.totalPaye);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: [
                _buildGreetingCard(),
                const SizedBox(height: 14),
                _buildStatsGrid(
                  context,
                  commandes.length,
                  enCours,
                  retards,
                  totalMoisF,
                ),
                const SizedBox(height: 18),
                if (retards > 0) ...[
                  _buildSectionTitle('⚠️ Alertes', null),
                  const SizedBox(height: 8),
                  ...commandes
                      .where((c) => c.statut == StatutCommande.retard)
                      .map((c) => _buildAlertCard(c)),
                  const SizedBox(height: 18),
                ],
                _buildSectionTitle('Commandes récentes',
                    () => onNavigate(2)),
                const SizedBox(height: 8),
                ...commandes.take(4).map(
                      (c) => _buildOrderCard(context, c),
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
            border: Border(
              bottom: BorderSide(color: AppColors.lightGrey),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CoutureApp',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepBrown,
                    ),
                  ),
                  Text(
                    'Tableau de bord',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.midGrey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.deepBrown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.caramel, AppColors.gold],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'AD',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Bonjour'
        : now.hour < 18
            ? 'Bon après-midi'
            : 'Bonsoir';
    final months = [
      '', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'
    ];
    final days = [
      '', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.', 'Dim.'
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepBrown, Color(0xFF4A2C1A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.2,
              child: Text('✂️',
                  style: const TextStyle(fontSize: 48)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Adama 👋',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Votre atelier vous attend',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${days[now.weekday]} ${now.day} ${months[now.month]} ${now.year}'
                    .toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.gold,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    int total,
    int enCours,
    int retards,
    double ca,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: [
        _statCard(
          icon: '📦',
          value: '$total',
          label: 'Commandes',
          badge: retards > 0 ? '$retards retards' : null,
          badgeRed: retards > 0,
          onTap: () => onNavigate(2),
        ),
        _statCard(
          icon: '🧵',
          value: '$enCours',
          label: 'En cours',
          badge: 'Actif',
          onTap: () => onNavigate(2),
        ),
        _statCard(
          icon: '👥',
          value: '${AppData.clients.length}',
          label: 'Clients',
          badge: '+2 ce mois',
          badgeGreen: true,
          onTap: () => onNavigate(1),
        ),
        _statCard(
          icon: '💰',
          value: _shortF(ca),
          label: 'CA mensuel',
          badge: '+12%',
          badgeGreen: true,
          onTap: () => onNavigate(3),
        ),
      ],
    );
  }

  Widget _statCard({
    required String icon,
    required String value,
    required String label,
    String? badge,
    bool badgeRed = false,
    bool badgeGreen = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepBrown,
                  ),
                ),
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.midGrey,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeRed
                        ? const Color(0xFFFDECEA)
                        : badgeGreen
                            ? const Color(0xFFEAF5EE)
                            : const Color(0xFFFEF6E4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: badgeRed
                          ? AppColors.terracotta
                          : badgeGreen
                              ? AppColors.sage
                              : AppColors.caramel,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.deepBrown,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'Voir tout',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.caramel,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAlertCard(Commande c) {
    final jours = DateTime.now().difference(c.dateLivraison).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.terracotta.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Text('⏰', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${c.client.nomComplet} — ${c.typeVetement} en retard de $jours jour(s)',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: const Color(0xFF8B3B29),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Commande c) {
    return GestureDetector(
      onTap: () => onCommandeTap(c),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: c.client.couleurAvatar.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  c.client.initiales,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.client.couleurAvatar,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.client.nomComplet,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepBrown,
                    ),
                  ),
                  Text(
                    '${c.typeVetement} · ${c.tissu}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.midGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      StatusPill(
                        label: c.statut.label,
                        color: c.statut.color,
                        bgColor: c.statut.bgColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _fmtDate(c.dateLivraison),
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: AppColors.midGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatF(c.montantTotal),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepBrown,
                  ),
                ),
                if (c.soldeRestant > 0)
                  Text(
                    '-${_formatF(c.soldeRestant)}',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: AppColors.terracotta,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _shortF(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).round()}k F';
    return '${v.round()} F';
  }

  String _formatF(double v) {
    return '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';
  }

  String _fmtDate(DateTime d) {
    final months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month]}';
  }
}
