// models/client.dart
import 'package:flutter/material.dart';

class Mesures {
  final double poitrine;
  final double taille;
  final double hanches;
  final double epaules;
  final double longueurRobe;
  final double longueurPantalon;
  final DateTime date;

  Mesures({
    required this.poitrine,
    required this.taille,
    required this.hanches,
    required this.epaules,
    required this.longueurRobe,
    required this.longueurPantalon,
    required this.date,
  });
}

class Client {
  final String id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? adresse;
  final Color couleurAvatar;
  final List<Mesures> mesures;
  final int nbCommandes;
  final double totalDepense;
  final String? preferences;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.adresse,
    required this.couleurAvatar,
    this.mesures = const [],
    this.nbCommandes = 0,
    this.totalDepense = 0,
    this.preferences,
  });

  String get nomComplet => '$prenom $nom';
  String get initiales =>
      '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'
          .toUpperCase();
}

// models/commande.dart
enum StatutCommande {
  confirmee,
  enCouture,
  essayage,
  terminee,
  livree,
  retard,
}

extension StatutCommandeExt on StatutCommande {
  String get label {
    switch (this) {
      case StatutCommande.confirmee:
        return 'Confirmée';
      case StatutCommande.enCouture:
        return 'En couture';
      case StatutCommande.essayage:
        return 'Essayage';
      case StatutCommande.terminee:
        return 'Terminée';
      case StatutCommande.livree:
        return 'Livrée';
      case StatutCommande.retard:
        return 'En retard';
    }
  }

  Color get color {
    switch (this) {
      case StatutCommande.confirmee:
        return const Color(0xFF7B5EA7);
      case StatutCommande.enCouture:
        return const Color(0xFF4A6FA5);
      case StatutCommande.essayage:
        return const Color(0xFFC4813A);
      case StatutCommande.terminee:
        return const Color(0xFF7B9E87);
      case StatutCommande.livree:
        return const Color(0xFF7B9E87);
      case StatutCommande.retard:
        return const Color(0xFFC0614B);
    }
  }

  Color get bgColor {
    switch (this) {
      case StatutCommande.confirmee:
        return const Color(0xFFF0EEFA);
      case StatutCommande.enCouture:
        return const Color(0xFFEEF3FD);
      case StatutCommande.essayage:
        return const Color(0xFFFDF3EA);
      case StatutCommande.terminee:
        return const Color(0xFFEAF5EE);
      case StatutCommande.livree:
        return const Color(0xFFEAF5EE);
      case StatutCommande.retard:
        return const Color(0xFFFDECEA);
    }
  }
}

class Paiement {
  final double montant;
  final DateTime date;
  final String description;

  Paiement({
    required this.montant,
    required this.date,
    required this.description,
  });
}

class Commande {
  final String id;
  final String numero;
  final Client client;
  final String typeVetement;
  final String modele;
  final String tissu;
  final String? instructions;
  final bool urgent;
  StatutCommande statut;
  final DateTime dateCreation;
  final DateTime? dateEssayage;
  final DateTime dateLivraison;
  DateTime? dateLivraisonReelle;
  final double montantTotal;
  final List<Paiement> paiements;

  Commande({
    required this.id,
    required this.numero,
    required this.client,
    required this.typeVetement,
    required this.modele,
    required this.tissu,
    this.instructions,
    this.urgent = false,
    required this.statut,
    required this.dateCreation,
    this.dateEssayage,
    required this.dateLivraison,
    this.dateLivraisonReelle,
    required this.montantTotal,
    this.paiements = const [],
  });

  double get totalPaye =>
      paiements.fold(0, (sum, p) => sum + p.montant);
  double get soldeRestant => montantTotal - totalPaye;
  double get pourcentagePaye =>
      montantTotal > 0 ? (totalPaye / montantTotal).clamp(0, 1) : 0;

  bool get estEnRetard =>
      DateTime.now().isAfter(dateLivraison) &&
      statut != StatutCommande.livree;
}

// models/app_data.dart - données de démonstration
class AppData {
  static final List<Client> clients = [
    Client(
      id: 'c1',
      nom: 'Kamga',
      prenom: 'Alphonsine',
      telephone: '+237 699 123 456',
      adresse: 'Bastos, Yaoundé',
      couleurAvatar: const Color(0xFFC4813A),
      nbCommandes: 7,
      totalDepense: 185000,
      preferences: 'Tissu bazin, Broderies dorées',
      mesures: [
        Mesures(
          poitrine: 92,
          taille: 74,
          hanches: 98,
          epaules: 38,
          longueurRobe: 120,
          longueurPantalon: 98,
          date: DateTime(2026, 1, 15),
        ),
      ],
    ),
    Client(
      id: 'c2',
      nom: 'Ngo Mbele',
      prenom: 'Fatima',
      telephone: '+237 677 234 567',
      adresse: 'Mvan, Yaoundé',
      couleurAvatar: const Color(0xFF7B9E87),
      nbCommandes: 3,
      totalDepense: 75000,
      preferences: 'Wax coloré',
      mesures: [
        Mesures(
          poitrine: 88,
          taille: 70,
          hanches: 94,
          epaules: 36,
          longueurRobe: 115,
          longueurPantalon: 96,
          date: DateTime(2026, 2, 8),
        ),
      ],
    ),
    Client(
      id: 'c3',
      nom: 'Ewondo',
      prenom: 'Joëlle',
      telephone: '+237 655 345 678',
      adresse: 'Nlongkak, Yaoundé',
      couleurAvatar: const Color(0xFFD4938A),
      nbCommandes: 5,
      totalDepense: 132000,
      preferences: 'Coupe ajustée',
    ),
    Client(
      id: 'c4',
      nom: 'Bilong',
      prenom: 'Madeleine',
      telephone: '+237 690 456 789',
      adresse: 'Biyem-Assi, Yaoundé',
      couleurAvatar: const Color(0xFF7B5EA7),
      nbCommandes: 2,
      totalDepense: 45000,
    ),
  ];

  static List<Commande> get commandes => [
        Commande(
          id: 'o1',
          numero: 'CMD-2026-042',
          client: clients[1],
          typeVetement: 'Ensemble boubou',
          modele: 'Modèle Royale #14',
          tissu: 'Bazin bleu royal',
          instructions: 'Broderies dorées col & manches',
          statut: StatutCommande.enCouture,
          dateCreation: DateTime(2026, 3, 18),
          dateEssayage: DateTime(2026, 3, 25),
          dateLivraison: DateTime(2026, 3, 28),
          montantTotal: 45000,
          paiements: [
            Paiement(
              montant: 30000,
              date: DateTime(2026, 3, 18),
              description: 'Acompte',
            ),
          ],
        ),
        Commande(
          id: 'o2',
          numero: 'CMD-2026-041',
          client: clients[0],
          typeVetement: 'Robe soirée',
          modele: 'Robe cérémonie',
          tissu: 'Dentelle ivoire',
          statut: StatutCommande.terminee,
          dateCreation: DateTime(2026, 3, 10),
          dateLivraison: DateTime(2026, 3, 22),
          montantTotal: 65000,
          paiements: [
            Paiement(
              montant: 30000,
              date: DateTime(2026, 3, 10),
              description: 'Acompte',
            ),
            Paiement(
              montant: 35000,
              date: DateTime(2026, 3, 22),
              description: 'Solde',
            ),
          ],
        ),
        Commande(
          id: 'o3',
          numero: 'CMD-2026-038',
          client: clients[2],
          typeVetement: 'Robe wax',
          modele: 'Robe africaine moderne',
          tissu: 'Wax orange/noir',
          statut: StatutCommande.livree,
          dateCreation: DateTime(2026, 3, 5),
          dateLivraison: DateTime(2026, 3, 20),
          dateLivraisonReelle: DateTime(2026, 3, 20),
          montantTotal: 32000,
          paiements: [
            Paiement(
              montant: 32000,
              date: DateTime(2026, 3, 20),
              description: 'Paiement complet',
            ),
          ],
        ),
        Commande(
          id: 'o4',
          numero: 'CMD-2026-035',
          client: clients[3],
          typeVetement: 'Tailleur 3 pièces',
          modele: 'Tailleur classique',
          tissu: 'Pagne vert forêt',
          statut: StatutCommande.retard,
          dateCreation: DateTime(2026, 2, 28),
          dateLivraison: DateTime(2026, 3, 15),
          montantTotal: 55000,
          paiements: [
            Paiement(
              montant: 35000,
              date: DateTime(2026, 2, 28),
              description: 'Acompte',
            ),
          ],
        ),
      ];
}
