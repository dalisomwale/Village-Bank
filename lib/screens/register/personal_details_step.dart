// lib/screens/register/personal_details_step.dart
import 'package:flutter/material.dart';
import 'package:village_banking/models/registration_data.dart';

class PersonalDetailsStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegistrationData registrationData;
  
  const PersonalDetailsStep({
    Key? key,
    required this.formKey,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Personal Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Full Name
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Full Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.fullName = value!,
          ),
          const SizedBox(height: 16),
          
          // Email
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email Address *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email address';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.email = value!,
          ),
          const SizedBox(height: 16),
          
          // Phone Number
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.phoneNumber = value!,
          ),
          const SizedBox(height: 16),
          
          // Gender
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Gender *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: ['Male', 'Female', 'Other']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select gender';
              }
              return null;
            },
            onChanged: (value) => widget.registrationData.gender = value!,
          ),
          const SizedBox(height: 16),
          
          // NRC Number
          TextFormField(
            decoration: InputDecoration(
              labelText: 'NRC Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
              hintText: '123456/78/9',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'NRC number is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.nrcNumber = value!,
          ),
          const SizedBox(height: 16),
          
          // Password
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.password = value!,
          ),
          const SizedBox(height: 16),
          
          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}