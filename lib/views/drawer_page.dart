import 'package:anganwadi_connect/components/widget.dart';
import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/core/theme/app_colors.dart';
import 'package:anganwadi_connect/core/theme/theme_provider.dart';
import 'package:anganwadi_connect/main.dart';
import 'package:anganwadi_connect/models/action_model.dart';
import 'package:anganwadi_connect/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final List<ActionTileData> actions;

  const AppDrawer({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = themeProvider.isDark;

    return Drawer(
      width: fullWidth(context) * .82,
      backgroundColor: theme.scaffoldBackgroundColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(
              context,
              loginModel: loginController.loginModel,
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                children: [
                  if (actions.isEmpty)
                    _buildEmpty(context)
                  else
                    ...actions.map(
                      (action) => _buildDrawerItem(context, action),
                    ),
                ],
              ),
            ),

            _buildBottomSection(context, isDark),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(BuildContext context, {LoginModel? loginModel}) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              // Avatar
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.scaffoldBackgroundColor,
                  border: Border.all(
                    color: Colors.white.withOpacity(.8),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    (loginModel?.name ?? "").substring(0, 1),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loginModel?.name ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      loginModel?.email ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 15,
                  color: Colors.white.withOpacity(.9),
                ),
                SizedBox(width: 6),
                Text(
                  loginModel?.roleId?.name ?? "",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER ITEM
  // ============================================================

  Widget _buildDrawerItem(BuildContext context, ActionTileData action) {
    final theme = Theme.of(context);

    final tileColor = hexToColor(action.backgroundColor ?? "#5B5FEF");

    final route = (action.routes ?? "").replaceFirst("/", "");

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (route.isNotEmpty) {
              context.pushNamed(route);
            }
          },
          borderRadius: BorderRadius.circular(17),
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: theme.dividerColor.withOpacity(.45)),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(getIcon(action.icon ?? ""), size: 21),
                ),

                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: Text(
                    action.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 21),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM
  // ============================================================

  Widget _buildBottomSection(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Divider(color: theme.dividerColor),

          const SizedBox(height: 8),

          // Logout
          _bottomItem(
            context,
            icon: Icons.logout_rounded,
            title: "Logout",
            color: AppColors.error,
            backgroundColor: AppColors.error.withOpacity(isDark ? .12 : .07),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ITEM
  // ============================================================

  Widget _bottomItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(.45)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: color.withOpacity(.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_open_rounded,
            size: 45,
            color: theme.colorScheme.onSurface.withOpacity(.25),
          ),
          const SizedBox(height: 10),
          Text(
            "No menu items",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(.55),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: theme.dividerColor.withOpacity(.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? .35 : .12),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // LOGOUT ICON
                // ==================================================
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(.10),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                      size: 30,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // TITLE
                // ==================================================
                Text(
                  "Logout?",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // DESCRIPTION
                // ==================================================
                Text(
                  "Are you sure you want to logout from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(.55),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // BUTTONS
                // ==================================================
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurface,
                            side: BorderSide(color: theme.dividerColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Logout
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);

                            await prefs.clear();

                            RoutingService().go(Routes.languageScreen.path);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, size: 18),
                              SizedBox(width: 7),
                              Text(
                                "Logout",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData getIcon(String icon) {
    switch (icon) {
      case 'badge':
        return Icons.badge;
      case 'child_care':
        return Icons.child_care;
      case 'business':
        return Icons.business;
      case 'attach_money':
        return Icons.attach_money;
      case 'book_online':
        return Icons.book_online;
      case 'group':
        return Icons.group;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'person':
        return Icons.person;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.help_outline;
    }
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
