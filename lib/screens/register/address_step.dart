// lib/screens/register/address_step.dart
import 'package:flutter/material.dart';
import 'package:village_banking/models/registration_data.dart';

class AddressStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegistrationData registrationData;
  
  const AddressStep({
    Key? key,
    required this.formKey,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Residential Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Country
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Country *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.flag),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Country is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.country = value!,
          ),
          const SizedBox(height: 16),
          
          // Province
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Province *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.map),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Province is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.province = value!,
          ),
          const SizedBox(height: 16),
          
          // District
          TextFormField(
            decoration: InputDecoration(
              labelText: 'District *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'District is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.district = value!,
          ),
          const SizedBox(height: 16),
          
          // Compound/Street
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Compound/Street *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.streetview),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Compound/Street is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.compoundStreet = value!,
          ),
          const SizedBox(height: 16),
          
          // House Number
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'House number is required';
              }
              return null;
            },
            onSaved: (value) => widget.registrationData.houseNumber = value!,
          ),
        ],
      ),
    );
  }
}