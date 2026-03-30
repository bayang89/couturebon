import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/app_theme.dart';
import 'models/models.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/clients_screen.dart';
import 'screens/commandes_screen.dart';
import 'screens/paiements_screen.dart';
import 'screens/reglages_screen.dart';
import 'widgets/shared_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CoutureApp());
}

class CoutureApp extends StatelessWidget {
  const CoutureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoutureApp',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _loggedIn = false;
  int _navIndex = 0;

  // Detail state
  Client? _selectedClient;
  Commande? _selectedCommande;
  bool _showClientDetail = false;
  bool _showCommandeDetail = false;

  void _login() => setState(() => _loggedIn = true);
  void _logout() => setState(() {
        _loggedIn = false;
        _navIndex = 0;
        _selectedClient = null;
        _selectedCommande = null;
        _showClientDetail = false;
        _showCommandeDetail = false;
      });

  void _navigate(int index) {
    setState(() {
      _navIndex = index;
      _showClientDetail = false;
      _showCommandeDetail = false;
    });
  }

  void _openClient(Client c) {
    setState(() {
      _selectedClient = c;
      _showClientDetail = true;
      _showCommandeDetail = false;
      _navIndex = 1;
    });
  }

  void _openCommande(Commande c) {
    setState(() {
      _selectedCommande = c;
      _showCommandeDetail = true;
      _showClientDetail = false;
      _navIndex = 2;
    });
  }

  Widget _buildCurrentScreen() {
    if (_showClientDetail && _selectedClient != null) {
      return ClientDetailScreen(
        client: _selectedClient!,
        onBack: () => setState(() {
          _showClientDetail = false;
          _selectedClient = null;
        }),
        onCommandeTap: _openCommande,
      );
    }

    if (_showCommandeDetail && _selectedCommande != null) {
      return CommandeDetailScreen(
        commande: _selectedCommande!,
        onBack: () => setState(() {
          _showCommandeDetail = false;
          _selectedCommande = null;
        }),
      );
    }

    switch (_navIndex) {
      case 0:
        return DashboardScreen(
          onNavigate: _navigate,
          onCommandeTap: _openCommande,
        );
      case 1:
        return ClientsScreen(onClientTap: _openClient);
      case 2:
        return CommandesScreen(onCommandeTap: _openCommande);
      case 3:
        return const PaiementsScreen();
      case 4:
        return ReglagesScreen(onLogout: _logout);
      default:
        return DashboardScreen(
          onNavigate: _navigate,
          onCommandeTap: _openCommande,
        );
    }
  }

  bool get _showNav =>
      !_showClientDetail && !_showCommandeDetail;

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      return LoginScreen(onLogin: _login);
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey('$_navIndex-$_showClientDetail-$_showCommandeDetail'),
          child: _buildCurrentScreen(),
        ),
      ),
      bottomNavigationBar: _showNav
          ? AppBottomNav(
              currentIndex: _navIndex,
              onTap: _navigate,
            )
          : null,
    );
  }
}
