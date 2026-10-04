import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/models/action_model.dart';
import 'package:anganwadi_connect/views/drawer_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        actions: [
          ActionTileData(
            title: "Employee Management",
            icon: "badge",
            routes: Routes.employeeListScreen.path,
          ),

          ActionTileData(
            title: "Anganwadi Management",
            icon: "child_care",
            routes: Routes.anganwadiListScreen.path,
          ),

          ActionTileData(
            title: "Branch Management",
            icon: "business",
            // routes: Routes.branchListScreen.path,
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
