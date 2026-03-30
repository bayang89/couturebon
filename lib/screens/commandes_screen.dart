import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ─── Commandes List ───────────────────────────────────────────────────────────
class CommandesScreen extends StatefulWidget {
  final Function(Commande) onCommandeTap;

  const CommandesScreen({super.key, required this.onCommandeTap});

  @override
  State<CommandesScreen> createState() => _CommandesScreenState();
}

class _CommandesScreenState extends State<CommandesScreen> {
  String _filterStatut = 'Toutes';

  @override
  Widget build(BuildContext context) {
    final all = AppData.commandes;
    final filtered = _filterStatut == 'Toutes'
        ? all
        : all.where((c) => c.statut.label == _filterStatut).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(context, all),
          _buildFilters(),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('Aucune commande',
                        style: GoogleFonts.dmSans(color: AppColors.midGrey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        _buildCommandeCard(context, filtered[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: AppFab(
        onPressed: () => showAppToast(context, 'Nouvelle commande...'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Commande> all) {
    final en_retard =
        all.where((c) => c.statut == StatutCommande.retard).length;
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
                  Text('Commandes',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepBrown)),
                  Text(
                    en_retard > 0
                        ? '$en_retard en retard · ${all.length} total'
                        : '${all.length} commandes',
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: en_retard > 0
                            ? AppColors.terracotta
                            : AppColors.midGrey),
                  ),
                ],
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.deepBrown,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sort_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = [
      'Toutes',
      'En couture',
      'Essayage',
      'Terminée',
      'En retard',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: filters.map((f) {
          final active = _filterStatut == f;
          return GestureDetector(
            onTap: () => setState(() => _filterStatut = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? AppColors.deepBrown : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active
                        ? AppColors.deepBrown
                        : AppColors.lightGrey),
              ),
              child: Text(f,
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: active
                          ? Colors.white
                          : AppColors.deepBrown)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommandeCard(BuildContext context, Commande c) {
    return GestureDetector(
      onTap: () => widget.onCommandeTap(c),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: c.statut == StatutCommande.retard
                ? AppColors.terracotta.withOpacity(0.3)
                : AppColors.lightGrey,
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: c.client.couleurAvatar.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(c.client.initiales,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.client.couleurAvatar)),
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
                      Text('${c.typeVetement} · ${c.tissu}',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: AppColors.midGrey),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_formatF(c.montantTotal),
                        style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepBrown)),
                    if (c.soldeRestant > 0)
                      Text('-${_formatF(c.soldeRestant)}',
                          style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: AppColors.terracotta)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                StatusPill(
                    label: c.statut.label,
                    color: c.statut.color,
                    bgColor: c.statut.bgColor),
                const Spacer(),
                const Icon(Icons.calendar_today_rounded,
                    size: 12, color: AppColors.midGrey),
                const SizedBox(width: 4),
                Text(_fmtDate(c.dateLivraison),
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: AppColors.midGrey)),
              ],
            ),
            if (c.pourcentagePaye < 1) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: c.pourcentagePaye,
                minHeight: 4,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation(
                  c.pourcentagePaye >= 0.5
                      ? AppColors.sage
                      : AppColors.caramel,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatF(double v) =>
      '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';

  String _fmtDate(DateTime d) {
    final months = [
      '', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
      'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'
    ];
    return '${d.day} ${months[d.month]}';
  }
}

// ─── Commande Detail ──────────────────────────────────────────────────────────
class CommandeDetailScreen extends StatefulWidget {
  final Commande commande;
  final VoidCallback onBack;

  const CommandeDetailScreen({
    super.key,
    required this.commande,
    required this.onBack,
  });

  @override
  State<CommandeDetailScreen> createState() =>
      _CommandeDetailScreenState();
}

class _CommandeDetailScreenState extends State<CommandeDetailScreen> {
  static const _statuts = [
    StatutCommande.confirmee,
    StatutCommande.enCouture,
    StatutCommande.essayage,
    StatutCommande.terminee,
    StatutCommande.livree,
  ];

  @override
  Widget build(BuildContext context) {
    final c = widget.commande;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildOrderHeader(c),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: [
                _buildConfectionSection(c),
                _buildEcheancesSection(c),
                _buildPaiementsSection(c),
                _buildActionsSection(context, c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(Commande c) {
    final currentIdx = _statuts.indexOf(c.statut);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A2C1A), AppColors.deepBrown],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white60, size: 14),
                    const SizedBox(width: 6),
                    Text('Commandes',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: Colors.white60)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(c.numero.toUpperCase(),
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.gold,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(c.typeVetement,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Text(c.client.nomComplet,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: Colors.white60)),
              const SizedBox(height: 16),
              // Timeline
              _buildTimeline(currentIdx),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(int currentIdx) {
    final labels = ['Confirmée', 'Couture', 'Essayage', 'Terminée', 'Livrée'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_statuts.length, (i) {
          final done = i < currentIdx;
          final current = i == currentIdx;
          return Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? AppColors.caramel
                          : current
                              ? AppColors.gold
                              : Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: current
                            ? Colors.white
                            : done
                                ? AppColors.gold
                                : Colors.white.withOpacity(0.2),
                        width: current ? 2.5 : 2,
                      ),
                      boxShadow: current
                          ? [
                              BoxShadow(
                                  color:
                                      AppColors.gold.withOpacity(0.4),
                                  blurRadius: 8)
                            ]
                          : null,
                    ),
                    child: done
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 12)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[i],
                    style: GoogleFonts.dmSans(
                      fontSize: 8,
                      color: current
                          ? Colors.white
                          : done
                              ? AppColors.gold.withOpacity(0.8)
                              : Colors.white38,
                      fontWeight: current
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (i < _statuts.length - 1)
                Container(
                  width: 36,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 18),
                  color: i < currentIdx
                      ? AppColors.caramel.withOpacity(0.6)
                      : Colors.white.withOpacity(0.12),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildConfectionSection(Commande c) {
    return SectionCard(
      title: '🧵 Confection',
      children: [
        InfoRow(label: 'Type vêtement', value: c.typeVetement),
        InfoRow(label: 'Modèle', value: c.modele),
        InfoRow(label: 'Tissu', value: c.tissu),
        InfoRow(
            label: 'Urgence',
            value: c.urgent ? '⚡ Urgent' : '⚡ Normale',
            valueColor: c.urgent ? AppColors.terracotta : null),
        InfoRow(
            label: 'Instructions',
            value: c.instructions ?? '—',
            isLast: true),
      ],
    );
  }

  Widget _buildEcheancesSection(Commande c) {
    return SectionCard(
      title: '📅 Échéances',
      children: [
        if (c.dateEssayage != null)
          InfoRow(
              label: 'Essayage prévu',
              value: _fmtDateLong(c.dateEssayage!)),
        InfoRow(
          label: 'Livraison promise',
          value: _fmtDateLong(c.dateLivraison),
          valueColor: c.estEnRetard ? AppColors.terracotta : AppColors.caramel,
        ),
        InfoRow(
          label: 'Livraison réelle',
          value: c.dateLivraisonReelle != null
              ? _fmtDateLong(c.dateLivraisonReelle!)
              : '— en attente',
          valueColor:
              c.dateLivraisonReelle == null ? AppColors.midGrey : null,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildPaiementsSection(Commande c) {
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
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text('💰 PAIEMENTS',
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.caramel,
                    letterSpacing: 1)),
          ),
          InfoRow(
              label: 'Montant total',
              value: _formatF(c.montantTotal)),
          InfoRow(
            label: 'Acompte versé',
            value: _formatF(c.totalPaye),
            valueColor: AppColors.sage,
          ),
          InfoRow(
            label: 'Solde restant',
            value: _formatF(c.soldeRestant),
            valueColor: c.soldeRestant > 0
                ? AppColors.terracotta
                : AppColors.sage,
            isLast: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: PaymentProgressBar(
              percent: c.pourcentagePaye,
              total: c.montantTotal,
              paid: c.totalPaye,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, Commande c) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                label: 'Avancer statut',
                icon: Icons.arrow_forward_rounded,
                primary: true,
                onTap: () => showAppToast(context, 'Statut mis à jour'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionBtn(
                label: '+ Paiement',
                icon: Icons.add_card_rounded,
                warning: true,
                onTap: () => showAppToast(context, 'Paiement enregistré'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                label: '📄 Reçu',
                icon: Icons.receipt_long_rounded,
                onTap: () => showAppToast(context, 'Reçu généré'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _actionBtn(
                label: '✏️ Modifier',
                icon: Icons.edit_rounded,
                onTap: () =>
                    showAppToast(context, 'Modification ouverte'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    bool primary = false,
    bool warning = false,
    required VoidCallback onTap,
  }) {
    Color bg = AppColors.lightGrey;
    Color fg = AppColors.deepBrown;
    if (primary) {
      bg = AppColors.deepBrown;
      fg = Colors.white;
    } else if (warning) {
      bg = const Color(0xFFFDF3EA);
      fg = AppColors.caramel;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: fg),
          ),
        ),
      ),
    );
  }

  String _formatF(double v) =>
      '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';

  String _fmtDateLong(DateTime d) {
    final months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
}
