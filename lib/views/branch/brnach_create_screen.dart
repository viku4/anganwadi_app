import 'package:anganwadi_connect/components/custom_dropdown.dart';
import 'package:anganwadi_connect/components/input_fields.dart';
import 'package:anganwadi_connect/controllers/branch_provider.dart';
import 'package:anganwadi_connect/controllers/home_provider.dart';
import 'package:anganwadi_connect/models/state_dictrict_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BranchAddScreen extends StatefulWidget {
  const BranchAddScreen({super.key});

  @override
  State<BranchAddScreen> createState() => _BranchAddScreenState();
}

class _BranchAddScreenState extends State<BranchAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _centerController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _pincodeController = TextEditingController();
  bool _obscurePassword = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await homeProvider.getStates();
    });
  }

  StateDictrictBlocModel? _selectedState;
  StateDictrictBlocModel? _selectedDistrict;
  StateDictrictBlocModel? _selectedBlock;
  StateDictrictBlocModel? _selectedVillage;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _centerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget _sectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final branchProvider = Provider.of<BranchProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Create Branch"), centerTitle: true),
      body: (homeProvider.isLoading || branchProvider.isLoading)
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        title: "Branch Details",
                        icon: Icons.home_work_outlined,
                      ),

                      const SizedBox(height: 20),

                      TextFieldData(
                        controller: _centerController,
                        label: "Branch Center Name",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        prefixIcon: Icon(Icons.home_work_outlined),
                        hintText: "Enter Branch center name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter Branch center";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFieldData(
                        controller: _addressController,
                        label: "Address",
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        prefixIcon: Icon(Icons.location_on_outlined),
                        hintText: "Enter complete address",
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter address";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownSearch(
                        items: homeProvider.states,
                        hintText: 'Select State',
                        showSearchBox: false,
                        selectedItem: _selectedState,
                        popupType: PopupType.dialog,
                        itemAsString: (p1) => p1.name ?? "",
                        prefixIcon: Icons.badge_outlined,
                        onChanged: (p0) async {
                          if (_selectedState != p0) {
                            setState(() {
                              _selectedState = p0;
                              _selectedVillage = null;
                              _selectedDistrict = null;
                              _selectedBlock = null;
                            });
                            await homeProvider.getDistricts(
                              stateId: _selectedState?.id,
                            );
                          }
                        },
                      ),
                      if (_selectedState != null) const SizedBox(height: 10),
                      if (_selectedState != null)
                        CustomDropdownSearch(
                          items: homeProvider.dictricts,
                          hintText: 'Select Dictrict',
                          showSearchBox: false,
                          selectedItem: _selectedDistrict,
                          popupType: PopupType.dialog,
                          itemAsString: (p1) => p1.name ?? "",
                          prefixIcon: Icons.badge_outlined,
                          onChanged: (p0) async {
                            if (_selectedDistrict != p0) {
                              setState(() {
                                _selectedVillage = null;
                                _selectedDistrict = p0;
                                _selectedBlock = null;
                              });
                              await homeProvider.getBlocks(
                                stateId: _selectedState?.id,
                                districtId: _selectedDistrict?.id,
                              );
                            }
                          },
                        ),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null))
                        const SizedBox(height: 10),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null))
                        CustomDropdownSearch(
                          items: homeProvider.blocks,
                          hintText: 'Select Block',
                          showSearchBox: false,
                          selectedItem: _selectedBlock,
                          popupType: PopupType.dialog,
                          itemAsString: (p1) => p1.name ?? "",
                          prefixIcon: Icons.badge_outlined,
                          onChanged: (p0) async {
                            if (_selectedBlock != p0) {
                              setState(() {
                                _selectedVillage = null;
                                _selectedBlock = p0;
                              });
                              await homeProvider.getVillages(
                                stateId: _selectedState?.id,
                                districtId: _selectedDistrict?.id,
                                blockId: _selectedBlock?.id,
                              );
                            }
                          },
                        ),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null) &&
                          (_selectedBlock != null))
                        const SizedBox(height: 10),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null) &&
                          (_selectedBlock != null))
                        CustomDropdownSearch(
                          items: homeProvider.villages,
                          hintText: 'Select Block',
                          showSearchBox: false,
                          selectedItem: _selectedVillage,
                          popupType: PopupType.dialog,
                          itemAsString: (p1) => p1.name ?? "",
                          prefixIcon: Icons.badge_outlined,
                          onChanged: (p0) async {
                            if (_selectedVillage != p0) {
                              setState(() {
                                _selectedVillage = p0;
                              });
                            }
                          },
                        ),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null) &&
                          (_selectedBlock != null) &&
                          (_selectedVillage != null))
                        const SizedBox(height: 10),
                      if ((_selectedState != null) &&
                          (_selectedDistrict != null) &&
                          (_selectedBlock != null) &&
                          (_selectedVillage != null))
                        TextFieldData(
                          controller: _pincodeController,
                          label: "PIN Code",
                          hintText: "Enter PIN code",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "PIN code is required";
                            }

                            if (value.trim().length != 6) {
                              return "Enter a valid 6-digit PIN code";
                            }

                            if (value.trim().startsWith('0')) {
                              return "Enter a valid PIN code";
                            }

                            return null;
                          },
                        ),
                      const SizedBox(height: 20),
                      _sectionTitle(
                        title: "Branch Person",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      TextFieldData(
                        controller: _nameController,
                        label: "Name",
                        prefixIcon: Icon(Icons.person_outline),
                        hintText: "Enter name",
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter name";
                          }

                          if (value.trim().length < 3) {
                            return "Name must be at least 3 characters";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFieldData(
                        controller: _emailController,
                        label: "Email",
                        autovalidateMode: AutovalidateMode.onUserInteraction,

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

                      const SizedBox(height: 10),

                      TextFieldData(
                        controller: _phoneController,
                        label: "Phone",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,

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
                      const SizedBox(height: 10),
                      TextFieldData(
                        controller: _userNameController,
                        label: "Username",
                        autovalidateMode: AutovalidateMode.onUserInteraction,

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
                      const SizedBox(height: 10),

                      TextFieldData(
                        controller: _passwordController,
                        label: "Password",
                        autovalidateMode: AutovalidateMode.onUserInteraction,

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

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: branchProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    Object payload = {
                                      "name": _centerController.text,
                                      "stateId": _selectedState?.id,
                                      "districtId": _selectedDistrict?.id,
                                      "blockId": _selectedBlock?.id,
                                      "villageId": _selectedVillage?.id,
                                      "pincode": _pincodeController.text,
                                      "address": _addressController.text,
                                      "partnerName": _nameController.text,
                                      "partnerUsername":
                                          _userNameController.text,
                                      "partnerPassword":
                                          _passwordController.text,
                                      "partnerEmail": _emailController.text,
                                      "partnerPhone": _phoneController.text,
                                    };

                                    await branchProvider.createBranch(
                                      payload: payload,
                                    );
                                  }
                                },
                          child: const Text(
                            "Create Branch",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
