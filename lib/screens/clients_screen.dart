import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ─── Clients List ─────────────────────────────────────────────────────────────
class ClientsScreen extends StatefulWidget {
  final Function(Client) onClientTap;

  const ClientsScreen({super.key, required this.onClientTap});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _filter = 'Tous';
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clients = AppData.clients.where((c) {
      final q = _search.trim().toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          c.nomComplet.toLowerCase().contains(q) ||
          c.telephone.toLowerCase().contains(q);

      final matchesFilter = switch (_filter) {
        'VIP' => c.nbCommandes >= 5 || c.totalDepense >= 100000,
        'Actifs' => c.nbCommandes > 0,
        'Inactifs' => c.nbCommandes == 0,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(context, clients.length),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
              itemCount: clients.length,
              itemBuilder: (_, i) => _buildClientCard(clients[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: AppFab(
        onPressed: () => showAppToast(context, 'Nouveau client...'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int filteredCount) {
    return Container(
      color: AppColors.warmWhite,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            border: Border(bottom: BorderSide(color: AppColors.lightGrey)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Clients',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepBrown)),
                  Text('$filteredCount cliente${filteredCount > 1 ? 's' : ''} affichée${filteredCount > 1 ? 's' : ''}',
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
                child: const Icon(Icons.filter_list_rounded,
                    color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded,
              color: AppColors.midGrey, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              style:
                  GoogleFonts.dmSans(fontSize: 14, color: AppColors.deepBrown),
              decoration: InputDecoration(
                hintText: 'Rechercher une cliente...',
                hintStyle: GoogleFonts.dmSans(
                    fontSize: 14, color: AppColors.midGrey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Tous', 'VIP', 'Actifs', 'Inactifs'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: filters.map((f) {
          final active = _filter == f;
          return GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? AppColors.deepBrown : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? AppColors.deepBrown
                      : AppColors.lightGrey,
                ),
              ),
              child: Text(
                f,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : AppColors.deepBrown,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClientCard(Client c) {
    return GestureDetector(
      onTap: () => widget.onClientTap(c),
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
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: c.couleurAvatar,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  c.initiales,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.nomComplet,
                      style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deepBrown)),
                  Text(c.telephone,
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.midGrey)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (c.nbCommandes > 5)
                        _tag('VIP'),
                      _tag('${c.nbCommandes} cmd'),
                      if (c.preferences != null)
                        _tag(c.preferences!.split(',').first.trim()),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.midGrey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF6E4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          color: AppColors.caramel,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Client Detail ────────────────────────────────────────────────────────────
class ClientDetailScreen extends StatefulWidget {
  final Client client;
  final VoidCallback onBack;
  final Function(Commande) onCommandeTap;

  const ClientDetailScreen({
    super.key,
    required this.client,
    required this.onBack,
    required this.onCommandeTap,
  });

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<Commande> get _clientCommandes => AppData.commandes
      .where((c) => c.client.id == widget.client.id)
      .toList();

  @override
  Widget build(BuildContext context) {
    final c = widget.client;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildClientHeader(c),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildInfoTab(c),
                _buildMesuresTab(c),
                _buildCommandesTab(),
                _buildPrefsTab(c),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientHeader(Client c) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepBrown, Color(0xFF3D2010)],
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
                    Text('Clients',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: Colors.white60)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [AppColors.caramel, AppColors.gold]),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(c.initiales,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.nomComplet,
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        Text(c.telephone,
                            style: GoogleFonts.dmSans(
                                fontSize: 13, color: Colors.white60)),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: Colors.white70, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statBadge('${c.nbCommandes}', 'Commandes'),
                  const SizedBox(width: 24),
                  _statBadge(_formatF(c.totalDepense), 'Total dépensé'),
                  const SizedBox(width: 24),
                  _statBadge(
                    c.mesures.isNotEmpty ? 'Oui' : 'Non',
                    'Mesures',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBadge(String val, String lbl) {
    return Column(
      children: [
        Text(val,
            style: GoogleFonts.playfairDisplay(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(lbl.toUpperCase(),
            style: GoogleFonts.dmSans(
                fontSize: 9, color: Colors.white38, letterSpacing: 0.6)),
      ],
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Infos', 'Mesures', 'Commandes', 'Préfs'];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabCtrl,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 6)
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.deepBrown,
        unselectedLabelColor: AppColors.midGrey,
        labelStyle: GoogleFonts.dmSans(
            fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildInfoTab(Client c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      children: [
        SectionCard(
          title: '📋 Informations personnelles',
          children: [
            InfoRow(label: 'Prénom', value: c.prenom),
            InfoRow(label: 'Nom', value: c.nom),
            InfoRow(label: 'Téléphone', value: c.telephone),
            InfoRow(
                label: 'Adresse',
                value: c.adresse ?? 'Non renseignée',
                isLast: true),
          ],
        ),
      ],
    );
  }

  Widget _buildMesuresTab(Client c) {
    if (c.mesures.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📐', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('Aucune mesure enregistrée',
                style: GoogleFonts.dmSans(color: AppColors.midGrey)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      children: c.mesures.map((m) {
        final months = ['', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
            'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
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
              Text(
                'PRISE DU ${m.date.day} ${months[m.date.month].toUpperCase()} ${m.date.year}',
                style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.caramel,
                    letterSpacing: 0.8),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 8,
                children: [
                  _measureItem('Poitrine', m.poitrine),
                  _measureItem('Taille', m.taille),
                  _measureItem('Hanches', m.hanches),
                  _measureItem('Épaules', m.epaules),
                  _measureItem('Long. robe', m.longueurRobe),
                  _measureItem('Long. pantalon', m.longueurPantalon),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _measureItem(String lbl, double val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lbl.toUpperCase(),
            style: GoogleFonts.dmSans(
                fontSize: 9, color: AppColors.midGrey, letterSpacing: 0.6)),
        Text('${val.toStringAsFixed(0)} cm',
            style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.deepBrown)),
      ],
    );
  }

  Widget _buildCommandesTab() {
    final cmds = _clientCommandes;
    if (cmds.isEmpty) {
      return Center(
        child: Text('Aucune commande',
            style: GoogleFonts.dmSans(color: AppColors.midGrey)),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      children: cmds.map((c) {
        return GestureDetector(
          onTap: () => widget.onCommandeTap(c),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.numero,
                          style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: AppColors.caramel,
                              fontWeight: FontWeight.w600)),
                      Text(c.typeVetement,
                          style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepBrown)),
                      const SizedBox(height: 4),
                      StatusPill(
                          label: c.statut.label,
                          color: c.statut.color,
                          bgColor: c.statut.bgColor),
                    ],
                  ),
                ),
                Text(
                  _formatF(c.montantTotal),
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepBrown),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrefsTab(Client c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      children: [
        SectionCard(
          title: '⭐ Préférences',
          children: [
            InfoRow(
                label: 'Tissu préféré',
                value: c.preferences?.split(',').first.trim() ?? '-'),
            InfoRow(label: 'Style', value: 'Traditionnel moderne'),
            InfoRow(
                label: 'Broderies',
                value: 'Oui, dorées',
                isLast: true),
          ],
        ),
        const SizedBox(height: 10),
        SectionCard(
          title: '📝 Notes',
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                c.preferences ?? 'Aucune note enregistrée.',
                style: GoogleFonts.dmSans(
                    fontSize: 13, color: AppColors.deepBrown, height: 1.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatF(double v) {
    return '${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ')} F';
  }
}
