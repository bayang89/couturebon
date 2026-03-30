import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PaiementsScreen extends StatelessWidget {
  const PaiementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final commandes = AppData.commandes;
    final totalEncaisse =
        commandes.fold<double>(0, (s, c) => s + c.totalPaye);
    final totalImpaye =
        commandes.fold<double>(0, (s, c) => s + c.soldeRestant);
    final retards = commandes
        .where((c) => c.statut == StatutCommande.retard)
        .toList();

    // Flatten all payments for display
    final allPaiements = <Map<String, dynamic>>[];
    for (final c in commandes) {
      for (final p in c.paiements) {
        allPaiements.add({'paiement': p, 'commande': c});
      }
    }
    allPaiements.sort((a, b) =>
        (b['paiement'] as Paiement)
            .date
            .compareTo((a['paiement'] as Paiement).date));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSummaryBanner(totalEncaisse, totalImpaye, commandes.length),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                _buildSectionTitle('Derniers versements', null),
                const SizedBox(height: 8),
                ...allPaiements.take(5).map(
                      (item) => _buildPaiementEntry(
                          item['paiement'] as Paiement,
                          item['commande'] as Commande),
                    ),
                if (retards.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                      'Impayés', '${retards.length} dossiers'),
                  const SizedBox(height: 8),
                  ...retards.map((c) => _buildImpayeEntry(c)),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AppFab(
        onPressed: () =>
            showAppToast(context, 'Enregistrer un paiement...'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paiements',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepBrown)),
                  Text('${months[now.month]} ${now.year}',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.midGrey)),
                ],
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.deepBrown,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.upload_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(
      double encaisse, double impaye, int nbCommandes) {
    final ca = encaisse + impaye;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepBrown, Color(0xFF4A2C1A)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Encaissé ce mois',
              style: GoogleFonts.dmSans(
                  fontSize: 12, color: Colors.white60)),
          const SizedBox(height: 4),
          Text(_formatF(encaisse),
              style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              _summaryItem(_formatF(impaye), 'Impayés',
                  color: AppColors.terracotta),
              const SizedBox(width: 24),
              _summaryItem('$nbCommandes', 'Commandes'),
              const SizedBox(width: 24),
              _summaryItem(_formatF(ca), 'CA total',
                  color: AppColors.gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String val, String lbl, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val,
            style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color ?? Colors.white)),
        Text(lbl.toUpperCase(),
            style: GoogleFonts.dmSans(
                fontSize: 9,
                color: Colors.white38,
                letterSpacing: 0.6)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String? sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.deepBrown)),
        if (sub != null)
          Text(sub,
              style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPaiementEntry(Paiement p, Commande c) {
    final isSolde = p.description.toLowerCase().contains('solde') ||
        p.description.toLowerCase().contains('complet');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSolde ? AppColors.sage : AppColors.caramel,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.client.nomComplet,
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepBrown)),
                Text('${c.numero} · ${c.typeVetement} — ${p.description}',
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: AppColors.midGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${_formatF(p.montant)}',
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSolde
                          ? AppColors.sage
                          : AppColors.caramel)),
              Text(_relativeDate(p.date),
                  style: GoogleFonts.dmSans(
                      fontSize: 10, color: AppColors.midGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpayeEntry(Commande c) {
    final jours =
        DateTime.now().difference(c.dateLivraison).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.terracotta.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.terracotta,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.client.nomComplet,
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepBrown)),
                Text('${c.numero} · ${c.typeVetement}',
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: AppColors.midGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('-${_formatF(c.soldeRestant)}',
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.terracotta)),
              Text('Retard ${jours}j',
                  style: GoogleFonts.dmSans(
                      fontSize: 10, color: AppColors.terracotta)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatF(double v) =>
      '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';

  String _relativeDate(DateTime d) {
    final diff = DateTime.now().difference(d).inDays;
    if (diff == 0) return 'Auj.';
    if (diff == 1) return 'Hier';
    final months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month]}';
  }
}
