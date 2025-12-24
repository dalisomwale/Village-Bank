// lib/screens/register/next_of_kin_step.dart
import 'package:flutter/material.dart';
import 'package:village_banking/models/registration_data.dart';

class NextOfKinStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegistrationData registrationData;
  
  const NextOfKinStep({
    Key? key,
    required this.formKey,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<NextOfKinStep> createState() => _NextOfKinStepState();
}

class _NextOfKinStepState extends State<NextOfKinStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Next of Kin Details',
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
            onSaved: (value) => widget.registrationData.nextOfKinFullName = value!,
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
            onSaved: (value) => widget.registrationData.nextOfKinPhoneNumber = value!,
          ),
          const SizedBox(height: 16),
          
          // Email
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => widget.registrationData.nextOfKinEmail = value ?? '',
          ),
          const SizedBox(height: 16),
          
          // NRC
          TextFormField(
            decoration: InputDecoration(
              labelText: 'NRC Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'NRC number is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.nextOfKinNrc = value!,
          ),
          const SizedBox(height: 16),
          
          // Relationship
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Relationship *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.group),
              hintText: 'Spouse, Parent, Sibling, etc.',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Relationship is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.nextOfKinRelationship = value!,
          ),
        ],
      ),
    );
  }
}