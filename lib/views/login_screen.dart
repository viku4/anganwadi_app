import 'dart:async';
import 'package:anganwadi_connect/components/input_fields.dart';
import 'package:anganwadi_connect/components/widget.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  Timer? _sliderTimer;

  int _currentPage = 0;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // ============================================================
  // LOCAL HOSPITAL IMAGES
  // ============================================================

  final List<String> _sliderImages = [
    'assets/hospitals/hospital_connect_image_1.png',
    'assets/hospitals/hospital_connect_image_2.png',
    'assets/hospitals/hospital_connect_image_3.png',
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    // ------------------------------------------------------------
    // MAIN ANIMATION
    // ------------------------------------------------------------

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // ------------------------------------------------------------
    // PULSE ANIMATION
    // ------------------------------------------------------------

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);

    _animationController.forward();

    _startAutoSlider();
  }

  // ============================================================
  // AUTO SLIDER
  // ============================================================

  void _startAutoSlider() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      int nextPage = _currentPage + 1;

      if (nextPage >= _sliderImages.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // ----------------------------------------------------------
    // ADD YOUR API LOGIN HERE
    // ----------------------------------------------------------

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Login successful',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF007A55),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // ----------------------------------------------------------
    // NAVIGATE TO HOME HERE
    // ----------------------------------------------------------
    //
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const HomeScreen(),
    //   ),
    // );
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();

    _pageController.dispose();

    _animationController.dispose();

    _pulseController.dispose();

    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final showKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      body: Column(
        spacing: 10,
        children: [
          Container(
            height: showKeyboard
                ? fullHeight(context) * 0.25
                : fullHeight(context) * 0.6,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _sliderImages.length,
                    onPageChanged: (index) {
                      if (!mounted) return;

                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _sliderImages[index];

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // IMAGE
                          Image.asset(
                            alignment: AlignmentGeometry.center,
                            item,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: const Color(0xFFE3F2EC),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: Color(0xFF007A55),
                                  ),
                                ),
                              );
                            },
                          ),

                          // ------------------------------------------------
                          // DARK GRADIENT
                          // ------------------------------------------------
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.10),
                                  Colors.black.withOpacity(0.78),
                                ],
                                stops: const [0.2, 0.45, 1],
                              ),
                            ),
                          ),

                          // ------------------------------------------------
                          // TEXT
                          // ------------------------------------------------
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 50,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF007A55),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.nayan_jyoti,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  getTitleOrSubtitle(context, index, true),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  getTitleOrSubtitle(context, index, false),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.88),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // ======================================================
                  // SLIDER INDICATORS
                  // ======================================================
                  Positioned(
                    bottom: 50,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: List.generate(_sliderImages.length, (index) {
                          final bool selected = _currentPage == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: selected ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                spacing: 10,
                children: [
                  TextFieldData(
                    hintText: AppLocalizations.of(context)!.username,
                    prefixIcon: Icon(Icons.person_outline),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.username_required;
                      }
                      return null;
                    },
                  ),
                  TextFieldData(
                    hintText: AppLocalizations.of(context)!.password,
                    prefixIcon: Icon(Icons.lock_outline),
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.password_required;
                      } else if (value.length < 6) {
                        return AppLocalizations.of(
                          context,
                        )!.password_min_length;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loginProvider.isLoggedIn
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await loginProvider.login(
                                  password: _passwordController.text,
                                  username: _emailController.text,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loginProvider.isLoggedIn
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getTitleOrSubtitle(BuildContext context, int index, bool isTitle) {
    final localization = AppLocalizations.of(context);

    if (isTitle) {
      switch (index) {
        case 0:
          return localization!.advanced_eye_care;

        case 1:
          return localization!.expert_eye_specialists;

        case 2:
          return localization!.complete_vision_care;

        default:
          return '';
      }
    } else {
      switch (index) {
        case 0:
          return localization!.modern_technology_better_vision;

        case 1:
          return localization!.professional_care_you_can_trust;

        case 2:
          return localization!.your_vision_is_our_priority;

        default:
          return '';
      }
    }
  }
}
