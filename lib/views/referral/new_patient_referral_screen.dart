import 'package:anganwadi_connect/components/input_fields.dart';
import 'package:flutter/material.dart';

class NewPatientReferralScreen extends StatefulWidget {
  const NewPatientReferralScreen({super.key});

  @override
  State<NewPatientReferralScreen> createState() =>
      _NewPatientReferralScreenState();
}

class _NewPatientReferralScreenState extends State<NewPatientReferralScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController(text: '28');
  final _mobileController = TextEditingController();
  final _villageController = TextEditingController();

  bool _consentConfirmed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.watch<ReferralProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New Patient Referral Form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextFieldData(
                controller: _nameController,

                label: 'Patient Full Name *',
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFieldData(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      label: 'Age',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 2,
                    child: TextFieldData(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,

                      label: 'Mobile *',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              TextFieldData(
                controller: _villageController,
                decoration: const InputDecoration(
                  labelText: 'Village / Ward',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _consentConfirmed,
                      onChanged: (value) {
                        setState(() {
                          _consentConfirmed = value ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        'I confirm that the patient has been informed and voluntarily consented to visit the hospital.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006677),
                  ),
                  onPressed: null,
                  // _consentConfirmed && _nameController.text.trim().isNotEmpty
                  // ? () {
                  //     provider.createReferral(
                  //       referralCode: provider.currentReferralCode,
                  //       patientName: _nameController.text.trim(),
                  //       patientAge: int.tryParse(_ageController.text) ?? 25,
                  //       patientGender: 'FEMALE',
                  //       patientMobile: _mobileController.text.trim(),
                  //       guardianName: '',
                  //       village: _villageController.text.trim(),
                  //       hospitalId: 1,
                  //       hospitalName:
                  //           'NAYAN JYOTI EYE HOSPITAL PIPCHO KODERMA JHARKHAND',
                  //       department: 'Ophthalmology',
                  //       doctor: 'Dr. Meenakshi Roy',
                  //       // visitType: VisitType.opd,
                  //       appointmentDate: DateTime.now()
                  //           .toIso8601String()
                  //           .split('T')[0],
                  //       consentConfirmed: _consentConfirmed,
                  //     );

                  //     Navigator.pop(context);
                  //   }
                  // : null,
                  child: const Text('Submit Referral'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
