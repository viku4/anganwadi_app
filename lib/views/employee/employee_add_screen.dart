import 'package:anganwadi_connect/components/custom_dropdown.dart';
import 'package:anganwadi_connect/components/input_fields.dart';
import 'package:anganwadi_connect/controllers/employee_provider.dart';
import 'package:anganwadi_connect/controllers/role_controller.dart';
import 'package:anganwadi_connect/core/theme/app_colors.dart';
import 'package:anganwadi_connect/models/role_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isActive = true;

  RoleModel? _selectedRole;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      await roleController.getRoles();
      await updataAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final roleProvider = Provider.of<RoleController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Employee",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: ((roleProvider.isLoading) || (employeeProvider.isLoading))
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldData(
                        controller: _nameController,
                        label: "Employee Name",
                        hintText: "Enter Employee name",
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Employee name is required";
                          }

                          if (value.trim().length < 2) {
                            return "Enter a valid name";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFieldData(
                        controller: _emailController,
                        label: "Email",

                        hintText: "Enter email address",
                        prefixIcon: Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Email is required";
                          }

                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return "Enter a valid email";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFieldData(
                        controller: _phoneController,
                        label: "Phone",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        hintText: "Enter phone number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Phone number is required";
                          }

                          if (value.trim().length < 10) {
                            return "Enter a valid phone number";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFieldData(
                        controller: _userNameController,
                        label: "Username",
                        hintText: "Enter username",
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-z0-9_.]'),
                          ),
                          LengthLimitingTextInputFormatter(30),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Username is required";
                          }

                          if (value.trim().length < 3) {
                            return "Username must be at least 3 characters";
                          }

                          if (!RegExp(
                            r'^[a-z0-9_.]+$',
                          ).hasMatch(value.trim())) {
                            return "Only lowercase letters, numbers, _ and . are allowed";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      TextFieldData(
                        controller: _passwordController,
                        label: "Password",
                        hintText: "Enter password",
                        prefixIcon: Icon(Icons.lock_outline),
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }

                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // ROLE
                      CustomDropdownSearch(
                        items: roleController.getRole,
                        hintText: 'Select Role',
                        showSearchBox: false,
                        selectedItem: _selectedRole,
                        popupType: PopupType.dialog,
                        itemAsString: (p1) => p1.name ?? "",
                        prefixIcon: Icons.badge_outlined,
                        onChanged: (p0) {
                          setState(() {
                            _selectedRole = p0;
                          });
                        },
                      ),

                      const SizedBox(height: 28),

                      // =====================================================
                      // SAVE BUTTON
                      // =====================================================
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: roleController.isLoading
                              ? null
                              : () async {
                                  // log("ElevatedButton${widget.userModel}");

                                  Object payload = {
                                    "name": _nameController.text,
                                    "roleId": _selectedRole?.id,
                                    "phone": _phoneController.text,
                                    "username": _userNameController.text,
                                    "email": _emailController.text,

                                    "password": _passwordController.text,
                                  };
                                  await employeeProvider.setAndUpdateGuest(
                                    payload: payload,
                                  );
                                },
                          icon: roleController.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.person_add_alt_1, size: 19),
                          label: Text(
                            roleController.isLoading
                                ? "Creating Staff..."
                                : "Add Staff",
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> updataAllData() async {}
}
