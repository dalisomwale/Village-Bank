import 'package:flutter/material.dart';
import 'package:village_banking/models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nrcController;
  String? _selectedGender;
  
  late TextEditingController _countryController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _compoundController;
  late TextEditingController _houseNumberController;
  
  late TextEditingController _kinNameController;
  late TextEditingController _kinPhoneController;
  late TextEditingController _kinEmailController;
  late TextEditingController _kinNrcController;
  String? _kinRelationship;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing user data
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _nrcController = TextEditingController(text: widget.user.nationalId);
    _selectedGender = widget.user.gender;
    
    // Address data
    _countryController = TextEditingController(text: widget.user.address?['country'] ?? 'Zambia');
    _provinceController = TextEditingController(text: widget.user.address?['province'] ?? '');
    _districtController = TextEditingController(text: widget.user.address?['district'] ?? '');
    _compoundController = TextEditingController(text: widget.user.address?['compound_street'] ?? '');
    _houseNumberController = TextEditingController(text: widget.user.address?['house_number'] ?? '');
    
    // Next of kin data
    _kinNameController = TextEditingController(text: widget.user.nextOfKin?['full_name'] ?? '');
    _kinPhoneController = TextEditingController(text: widget.user.nextOfKin?['phone_number'] ?? '');
    _kinEmailController = TextEditingController(text: widget.user.nextOfKin?['email'] ?? '');
    _kinNrcController = TextEditingController(text: widget.user.nextOfKin?['nrc_number'] ?? '');
    _kinRelationship = widget.user.nextOfKin?['relationship'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Information
            _buildSection(
              title: 'Personal Information',
              icon: Icons.person_outline,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedGender = value);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nrcController,
                  decoration: const InputDecoration(
                    labelText: 'NRC Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NRC number';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Residential Address
            _buildSection(
              title: 'Residential Address',
              icon: Icons.home_outlined,
              children: [
                TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Province',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(
                    labelText: 'District',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter district';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _compoundController,
                  decoration: const InputDecoration(
                    labelText: 'Compound/Street',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter compound/street';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _houseNumberController,
                  decoration: const InputDecoration(
                    labelText: 'House Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Next of Kin
            _buildSection(
              title: 'Next of Kin',
              icon: Icons.group_outlined,
              children: [
                TextFormField(
                  controller: _kinNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter next of kin name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _kinPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _kinEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _kinNrcController,
                  decoration: const InputDecoration(
                    labelText: 'NRC Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NRC number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _kinRelationship,
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Spouse', 'Parent', 'Child', 'Sibling', 'Relative', 'Friend']
                      .map((relationship) => DropdownMenuItem(
                            value: relationship,
                            child: Text(relationship),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _kinRelationship = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select relationship';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SAVE CHANGES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here you would call an API to update the profile
      // For now, just show a success message and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nrcController.dispose();
    _countryController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _compoundController.dispose();
    _houseNumberController.dispose();
    _kinNameController.dispose();
    _kinPhoneController.dispose();
    _kinEmailController.dispose();
    _kinNrcController.dispose();
    super.dispose();
  }
}