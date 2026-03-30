# Corrections appliquées

## Corrections techniques
- Création du dossier `assets/` manquant pour éviter l'échec de `flutter pub get` / build.
- Suppression des dossiers parasites issus de l'archive (`{lib...`).
- Mise à jour de la configuration Gradle Android vers une structure cohérente avec le plugin Flutter moderne.
- Harmonisation du plugin Kotlin Android.
- Passage de la compilation Java/Kotlin en version 17 côté Android.

## Corrections Flutter
- `main()` rendu asynchrone avec `await SystemChrome.setPreferredOrientations(...)`.
- Correction de l'écran **Clients** :
  - le filtre visuel (`Tous / VIP / Actifs / Inactifs`) est maintenant réellement appliqué ;
  - la recherche est normalisée (`trim` + minuscule) ;
  - le compteur affiché correspond désormais au nombre de clientes visibles ;
  - libération du `TextEditingController` dans `dispose()`.

## Limite de validation
L'environnement de correction ne contient pas Flutter, donc les commandes `flutter analyze`, `flutter test` et `flutter build apk` n'ont pas pu être exécutées ici.
