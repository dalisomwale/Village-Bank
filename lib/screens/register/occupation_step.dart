// lib/screens/register/occupation_step.dart
import 'package:flutter/material.dart';
import 'package:village_banking/models/registration_data.dart';

class OccupationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final RegistrationData registrationData;
  
  const OccupationStep({
    Key? key,
    required this.formKey,
    required this.registrationData,
  }) : super(key: key);

  @override
  State<OccupationStep> createState() => _OccupationStepState();
}

class _OccupationStepState extends State<OccupationStep> {
  String _selectedOccupationType = 'employed';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Occupation Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Occupation Type
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Occupation Type *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
            value: _selectedOccupationType,
            items: [
              DropdownMenuItem(
                value: 'employed',
                child: Text('Employed'),
              ),
              DropdownMenuItem(
                value: 'self-employed',
                child: Text('Self-Employed'),
              ),
              DropdownMenuItem(
                value: 'citizen',
                child: Text('Citizen (Not Working)'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedOccupationType = value!;
                widget.registrationData.occupationType = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select occupation type';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          if (_selectedOccupationType != 'citizen') ...[
            // Position
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Position *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work_outline),
                hintText: 'Job title/position',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Position is required';
                }
                return null;
              },
              onSaved: (value) => widget.registrationData.position = value!,
            ),
            const SizedBox(height: 16),
            
            // Workplace Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Workplace Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Workplace name is required';
                }
                return null;
              },
              onSaved: (value) => widget.registrationData.workplaceName = value!,
            ),
            const SizedBox(height: 16),
            
            // Workplace Address
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Workplace Address *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Workplace address is required';
                }
                return null;
              },
              onSaved: (value) => widget.registrationData.workplaceAddress = value!,
            ),
            const SizedBox(height: 16),
          ] else ...[
            // For Citizen option
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Place of Residence *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
                hintText: 'Village/Town/City',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Place of residence is required';
                }
                return null;
              },
              onSaved: (value) => widget.registrationData.citizenPlaceOfResidence = value!,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
                hintText: 'Detailed address',
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address is required';
                }
                return null;
              },
              onSaved: (value) => widget.registrationData.citizenAddress = value!,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}