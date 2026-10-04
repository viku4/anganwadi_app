import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:flutter/material.dart';

class AnganwadiListScreen extends StatefulWidget {
  const AnganwadiListScreen({super.key});

  @override
  State<AnganwadiListScreen> createState() => _AnganwadiListScreenState();
}

class _AnganwadiListScreenState extends State<AnganwadiListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          RoutingService().pushNamed(Routes.anganwadiAddScreen.name);
        },
        backgroundColor: const Color(0xFF3F7D3A),
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(
          'Add Anganwadi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
