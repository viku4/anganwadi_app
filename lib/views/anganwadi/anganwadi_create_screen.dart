import 'package:anganwadi_connect/components/custom_dropdown.dart';
import 'package:anganwadi_connect/controllers/home_provider.dart';
import 'package:anganwadi_connect/models/state_dictrict_bloc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AnganwadiAddScreen extends StatefulWidget {
  const AnganwadiAddScreen({super.key});

  @override
  State<AnganwadiAddScreen> createState() => _AnganwadiAddScreenState();
}

class _AnganwadiAddScreenState extends State<AnganwadiAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  bool _isActive = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _centerController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createAnganwadi() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedState == null) {
      _showError("Please select state");
      return;
    }

    if (_selectedDistrict == null) {
      _showError("Please select district");
      return;
    }

    if (_selectedBlock == null) {
      _showError("Please select block");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> data = {
        "name": _nameController.text.trim(),
        "mobile": _mobileController.text.trim(),
        "state": _selectedState,
        "district": _selectedDistrict,
        "block": _selectedBlock,
        "anganwadiCenter": _centerController.text.trim(),
        "address": _addressController.text.trim(),
        "isActive": _isActive,
      };

      debugPrint("Anganwadi Data: $data");

      // TODO: Call your API here.
      //
      // await api.createAnganwadi(data);

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anganwadi created successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      _showError("Something went wrong");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1.5),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
    );
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      decoration: _inputDecoration(label: label, icon: icon, hint: hint),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Anganwadi"), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(
                  title: "Personal Information",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _nameController,
                  label: "Name",
                  icon: Icons.person_outline,
                  hint: "Enter name",
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

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _mobileController,
                  label: "Mobile",
                  icon: Icons.phone_outlined,
                  hint: "Enter 10 digit mobile number",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter mobile number";
                    }

                    if (value.length != 10) {
                      return "Enter valid 10 digit mobile number";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                _sectionTitle(
                  title: "Location",
                  icon: Icons.location_on_outlined,
                ),

                const SizedBox(height: 16),
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
                        _selectedDistrict = null;
                        _selectedBlock = null;
                      });
                      await homeProvider.getDistricts(
                        stateId: _selectedState?.id,
                      );
                    }
                  },
                ),
                if (_selectedState != null) const SizedBox(height: 28),
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
                if ((_selectedState != null) && (_selectedDistrict != null))
                  const SizedBox(height: 28),
                if ((_selectedState != null) && (_selectedDistrict != null))
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
                          _selectedBlock = p0;
                        });
                      }
                    },
                  ),

                const SizedBox(height: 28),
                _sectionTitle(
                  title: "Anganwadi Details",
                  icon: Icons.home_work_outlined,
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _centerController,
                  label: "Anganwadi Center",
                  icon: Icons.home_work_outlined,
                  hint: "Enter Anganwadi center name",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter Anganwadi center";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _addressController,
                  label: "Address",
                  icon: Icons.location_on_outlined,
                  hint: "Enter complete address",
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter address";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 0,
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: const Text(
                      "Active Status",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _isActive
                          ? "Anganwadi is active"
                          : "Anganwadi is inactive",
                    ),
                    secondary: Icon(
                      _isActive
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                    ),
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createAnganwadi,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Create Anganwadi",
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
