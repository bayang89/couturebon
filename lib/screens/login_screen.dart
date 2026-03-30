import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController(text: 'admin@couture.cm');
  final _passCtrl = TextEditingController(text: '••••••••');
  String _role = 'gerant';
  bool _loading = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBrown,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _DiamondPatternPainter()),
          ),
          // Gradient overlays
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -0.6),
                  radius: 1.2,
                  colors: [
                    AppColors.caramel.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.caramel, AppColors.gold],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.caramel.withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('✂️', style: TextStyle(fontSize: 32)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'CoutureApp',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.cream,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'GESTION D\'ATELIER',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: AppColors.midGrey,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Email
                        _buildInput(
                          controller: _emailCtrl,
                          hint: 'Email ou identifiant',
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                        // Password
                        _buildInput(
                          controller: _passCtrl,
                          hint: 'Mot de passe',
                          icon: Icons.lock_outline_rounded,
                          obscure: true,
                        ),
                        const SizedBox(height: 12),
                        // Role selector
                        _buildRoleSelector(),
                        const SizedBox(height: 24),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _loading ? null : _login,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.caramel,
                                    AppColors.gold
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.caramel.withOpacity(0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: _loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Se connecter',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Mot de passe oublié ?',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: AppColors.midGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.caramel.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(icon, color: AppColors.midGrey, size: 18),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.dmSans(
                color: AppColors.cream,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.dmSans(
                  color: AppColors.midGrey.withOpacity(0.6),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    final roles = [
      {'value': 'gerant', 'label': 'Gérant(e)', 'icon': '👑'},
      {'value': 'couturier', 'label': 'Couturier(ère)', 'icon': '🧵'},
      {'value': 'caissier', 'label': 'Caissier(ère)', 'icon': '💰'},
    ];

    return Row(
      children: roles.map((r) {
        final active = _role == r['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _role = r['value']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: r == roles.last ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.caramel.withOpacity(0.2)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active
                      ? AppColors.caramel
                      : AppColors.caramel.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(r['icon']!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    r['label']!,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: active ? AppColors.gold : AppColors.midGrey,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DiamondPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.caramel.withOpacity(0.04)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const step = 24.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        final path = Path()
          ..moveTo(x, y - step / 2)
          ..lineTo(x + step / 2, y)
          ..lineTo(x, y + step / 2)
          ..lineTo(x - step / 2, y)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
