# 🧵 CoutureApp — Gestion d'Atelier de Couture

Application mobile Flutter de gestion complète d'un atelier de couture, conçue pour le marché camerounais (FCFA, noms locaux, etc.).

---

## 📱 Fonctionnalités

| Module | Fonctionnalités |
|---|---|
| 🔐 Connexion | Rôles : Gérant, Couturier, Caissier |
| 🏠 Dashboard | Statistiques, alertes retards, commandes récentes |
| 👥 Clients | Fiche client, mesures corporelles, préférences, historique |
| 📦 Commandes | Création, suivi (timeline), statuts, instructions |
| 💰 Paiements | Acomptes, soldes, impayés, CA mensuel |
| ⚙️ Réglages | Profil, notifications, sauvegarde, déconnexion |

---

## 🚀 Obtenir l'APK via GitHub Actions

### Méthode 1 — Automatique (recommandée)

1. **Forker / cloner** ce dépôt sur GitHub
2. Aller dans **Actions** → le build se lance automatiquement à chaque `push`
3. Une fois terminé (~5 min), cliquer sur le job **Build APK**
4. Télécharger l'artefact `couture-app-release-arm64` (pour la majorité des téléphones Android modernes)

### Méthode 2 — Release avec tag

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub créera automatiquement une **Release** avec l'APK en pièce jointe.

---

## 🛠️ Développement local

### Prérequis
- Flutter 3.22+ ([flutter.dev](https://flutter.dev))
- Android Studio ou VS Code
- JDK 17+

### Installation

```bash
git clone https://github.com/VOTRE_USERNAME/couture_app.git
cd couture_app
flutter pub get
flutter run
```

### Build manuel

```bash
# APK debug (pour tester)
flutter build apk --debug

# APK release (pour distribution)
flutter build apk --release --no-tree-shake-icons

# APK par architecture (plus léger)
flutter build apk --release --split-per-abi
```

L'APK se trouve dans : `build/app/outputs/flutter-apk/`

---

## 📂 Structure du projet

```
lib/
├── main.dart                    ← Point d'entrée + navigation globale
├── utils/
│   └── app_theme.dart           ← Couleurs, thème, typographie
├── models/
│   └── models.dart              ← Client, Commande, Paiement, données démo
├── widgets/
│   └── shared_widgets.dart      ← Composants réutilisables
└── screens/
    ├── login_screen.dart
    ├── dashboard_screen.dart
    ├── clients_screen.dart
    ├── commandes_screen.dart
    ├── paiements_screen.dart
    └── reglages_screen.dart
```

---

## 🎨 Design

- **Palette** : Marron profond `#2C1810`, Caramel `#C4813A`, Or `#D4A853`
- **Typographie** : Playfair Display (titres) + DM Sans (corps)
- **Style** : Luxury/artisanal, inspiré du textile africain

---

## 📋 Dépendances principales

| Package | Usage |
|---|---|
| `google_fonts` | Playfair Display, DM Sans |
| `fl_chart` | Graphiques financiers |
| `percent_indicator` | Barres de progression |
| `shared_preferences` | Persistance locale |
| `flutter_slidable` | Gestes sur les listes |

---

## 📄 Licence

MIT — Libre d'utilisation et de modification.
