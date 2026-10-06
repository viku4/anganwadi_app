import 'package:anganwadi_connect/components/input_fields.dart';
import 'package:anganwadi_connect/config/route_names.dart';
import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/controllers/employee_provider.dart';
import 'package:anganwadi_connect/controllers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await employeeProvider.fetchEmployeeList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final employees = employeeProvider.employeeList;
    final filteredEmployees = employees.where((employee) {
      final query = searchQuery.toLowerCase();
      return (employee.name ?? '').toLowerCase().contains(query) ||
          (employee.username ?? '').toLowerCase().contains(query) ||
          (employee.phone ?? '').toLowerCase().contains(query) ||
          (employee.email ?? '').toLowerCase().contains(query);
    }).toList();
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee List',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),

      body: employeeProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFieldData(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },

                    hintText: 'Search employee...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              setState(() {
                                searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 15),
                Expanded(
                  child: filteredEmployees.isEmpty
                      ? _EmptyEmployeeView(searchQuery: searchQuery)
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: filteredEmployees.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];

                            return _EmployeeCard(
                              name: employee.name ?? 'Unknown Employee',
                              username: employee.username ?? '-',
                              phone: employee.phone ?? '-',
                              email: employee.email ?? '-',
                              role: employee.roleId?.name ?? 'Employee',
                              status: employee.status == 1,
                              onTap: () {
                                // TODO: Open employee details
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

      // --------------------------------------------------
      // Floating Add Button
      // --------------------------------------------------
      floatingActionButton:
          [
            "branch_head",
            "aganwadi_head",
          ].contains(loginProvider.loginModel?.roleId?.slug)
          ? FloatingActionButton.extended(
              onPressed: () {
                RoutingService().pushNamed(Routes.employeeAddScreen.name);
              },
              backgroundColor: const Color(0xFF3F7D3A),
              foregroundColor: Colors.white,
              elevation: 3,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text(
                'Add Employee',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          : null,
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final String name;
  final String username;
  final String phone;
  final String email;
  final String role;
  final bool status;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.role,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstLetter = name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : '?';

    return Material(
      // color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    height: 54,
                    width: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF75A96E), Color(0xFF3F7D3A)],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        // color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Name + username
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            // color: Color(0xFF172017),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@$username',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            // color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: status
                          ? const Color(0xFFE7F5E5)
                          : const Color(0xFFFCEAEA),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: status
                                ? const Color(0xFF3F8C39)
                                : const Color(0xFFD9534F),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          status ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: status
                                ? const Color(0xFF34732F)
                                : const Color(0xFFC03935),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(height: 1, color: Color(0xFFEEF1EC)),

              const SizedBox(height: 14),

              // Role
              Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 17,
                    // color: Color(0xFF687267),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      role,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xFF4D564C),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Phone
              Row(
                children: [
                  const Icon(
                    Icons.phone_outlined,
                    size: 17,
                    // color: Color(0xFF687267),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 13,
                        // color: Color(0xFF5E675D),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Email
              Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 17,
                    // color: Color(0xFF687267),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        // color: Color(0xFF5E675D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptyEmployeeView extends StatelessWidget {
  final String searchQuery;

  const _EmptyEmployeeView({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4E8),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.groups_outlined,
                size: 45,
                color: Color(0xFF4C8C47),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSearching ? 'No employees found' : 'No employees yet',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172017),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? 'Try searching with a different name or username.'
                  : 'Add your first employee to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
