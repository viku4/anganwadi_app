import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:anganwadi_connect/models/action_model.dart';
import 'package:anganwadi_connect/views/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

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
    );
  }
}
