import 'package:anganwadi_connect/components/widget.dart';
import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/controllers/home_provider.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/l10n/l10n.dart';
import 'package:anganwadi_connect/models/action_model.dart';
import 'package:anganwadi_connect/views/drawer_page.dart';
import 'package:anganwadi_connect/views/referral/new_patient_referral_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await homeProvider.getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      drawer: AppDrawer(
        actions: [
          ActionTileData(
            title: "Employee Management",
            icon: "badge",
            routes: Routes.employeeListScreen.path,
          ),
          if ([
            "super_admin",
            "branch_head",
            "branch_staff",
            // "anganwadi_head",
          ].contains(loginProvider.loginModel?.roleId?.slug))
            ActionTileData(
              title: "Anganwadi Management",
              icon: "child_care",
              routes: Routes.anganwadiAddScreen.path,
            ),
          if ([
            "super_admin",
            "account",
          ].contains(loginProvider.loginModel?.roleId?.slug))
            ActionTileData(
              title: "Branch Management",
              icon: "business",
              routes: Routes.branchAddScreen.path,
            ),
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(' Dashboard'),
        centerTitle: false,
      ),
      body: homeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // color: const Color(0xFF006677),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    homeProvider.anganwadiModel?.code ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _ReferralActionButton(
                              icon: Icons.copy_rounded,
                              tooltip: "copyCode",
                              onPressed: () {
                                // Clipboard.setData(
                                //   ClipboardData(text: provider.currentReferralCode),
                                // );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("referralCodeCopied"),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(width: 6),

                            _ReferralActionButton(
                              icon: Icons.share_rounded,
                              tooltip: "share",
                              onPressed: () {
                                // Share.share(
                                //   '${l10n.myAuthorizedReferralCode}: '
                                //   '${provider.currentReferralCode}',
                                // );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Divider(
                          color: Colors.white.withOpacity(0.20),
                          height: 1,
                        ),

                        const SizedBox(height: 14),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.white.withOpacity(0.85),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Anganwadi Centre",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    homeProvider.anganwadiModel?.name ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _ReferralInfo(
                                icon: Icons.map_outlined,
                                label: "location",
                                value: [
                                  homeProvider.anganwadiModel?.stateId?.name,
                                  homeProvider.anganwadiModel?.districtId?.name,
                                  homeProvider.anganwadiModel?.blockId?.name,
                                ].join("-"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ReferralInfo(
                                icon: Icons.badge_outlined,
                                label: "awcId",
                                value: "currentAwcId",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(fullWidth(context) / 1.1, 40),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (ctx) => const NewPatientReferralScreen(),
                    );
                  },
                  label: Text("New Patient Referral"),
                  icon: Icon(Icons.person_add),
                ),
              ],
            ),
    );
  }
}

class _ReferralActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ReferralActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: Colors.white, size: 19),
          ),
        ),
      ),
    );
  }
}

class _ReferralInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReferralInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.70)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.60),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
