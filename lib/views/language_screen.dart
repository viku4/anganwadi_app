import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/controllers/language_provider.dart';
import 'package:anganwadi_connect/core/theme/theme_provider.dart';
import 'package:anganwadi_connect/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Map<String, Object>? selectedIndex;

  void selectLanguage(Map<String, Object> language) {
    setState(() {
      selectedIndex = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    final languages = L10n().all;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // Header
            // --------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
              child: Column(
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF203020)
                          : const Color(0xFFE8F3E5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      size: 40,
                      color: isDark
                          ? const Color(0xFF8BC584)
                          : const Color(0xFF3F7D3A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Choose your language',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF172017),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Select your preferred language to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------
            // Language List
            // --------------------------------------------------
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  Map<String, Object> language = languages[index];

                  final isSelected = selectedIndex?["id"] == language["id"];

                  return GestureDetector(
                    onTap: () => selectLanguage(language),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? const Color(0xFF203820)
                                  : const Color(0xFFEAF5E7))
                            : (isDark ? const Color(0xFF181E18) : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                    ? const Color(0xFF72AA6B)
                                    : const Color(0xFF4C8C47))
                              : (isDark
                                    ? const Color(0xFF293129)
                                    : const Color(0xFFE5E9E3)),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.035),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          // --------------------------------------------------
                          // Flag
                          // --------------------------------------------------
                          Container(
                            height: 52,
                            width: 52,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                        ? const Color(0xFF293F29)
                                        : Colors.white)
                                  : (isDark
                                        ? const Color(0xFF202720)
                                        : const Color(0xFFF5F7F4)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              language['flag']?.toString() ?? '🌐',
                              style: const TextStyle(fontSize: 27),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // --------------------------------------------------
                          // Language Name
                          // --------------------------------------------------
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language['nativeName']?.toString() ?? '',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF172017),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  language['name']?.toString() ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // --------------------------------------------------
                          // Check
                          // --------------------------------------------------
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFF4C8C47)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4C8C47)
                                    : (isDark
                                          ? Colors.white30
                                          : const Color(0xFFC9CEC7)),
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --------------------------------------------------
            // Continue Button
            // --------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a language'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    languageProvider.changeLanguage(
                      selectedIndex?["value"]?.toString() ?? 'en',
                    );

                    RoutingService().go(Routes.loginScreen.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F7D3A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
