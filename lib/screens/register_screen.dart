import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_banking/providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  
  // Personal Details Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nrcController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  
  // Residential Address Controllers
  final _countryController = TextEditingController(text: 'Zambia');
  final _provinceController = TextEditingController();
  final _districtController = TextEditingController();
  final _compoundStreetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  
  // Next of Kin Controllers
  final _kinNameController = TextEditingController();
  final _kinPhoneController = TextEditingController();
  final _kinEmailController = TextEditingController();
  final _kinNrcController = TextEditingController();
  String? _kinRelationship;

  @override
  void initState() {
    super.initState();
    print('✅ RegisterScreen initialized');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    print('🔄 Building RegisterScreen');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header with Logo
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[100]!, width: 2),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Join Village Banking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Complete all 3 steps to create your account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Progress Indicator
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStepIndicator(0, 'Personal'),
                          _buildStepDivider(),
                          _buildStepIndicator(1, 'Address'),
                          _buildStepDivider(),
                          _buildStepIndicator(2, 'Next of Kin'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Step ${_currentStep + 1} of 3',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _getStepDescription(_currentStep),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Form Content
                SizedBox(
                  height: 450,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      // Step 1: Personal Details
                      _buildPersonalDetailsForm(),
                      
                      // Step 2: Residential Address
                      _buildAddressForm(),
                      
                      // Step 3: Next of Kin
                      _buildNextOfKinForm(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Navigation Buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'BACK',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading ? null : () {
                          _handleStepNavigation(authProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _currentStep == 2 ? 'REGISTER' : 'CONTINUE',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Enter your personal information';
      case 1:
        return 'Provide your residential address';
      case 2:
        return 'Add next of kin details';
      default:
        return '';
    }
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? Colors.green : Colors.grey[300],
            shape: BoxShape.circle,
            border: isActive ? Border.all(color: Colors.green, width: 3) : null,
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.green : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey[300],
        margin: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildPersonalDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              if (!value.contains('@')) {
                return 'Enter valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: const Icon(Icons.phone, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
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
            decoration: InputDecoration(
              labelText: 'Gender',
              prefixIcon: const Icon(Icons.person_outline, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select gender';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _nrcController,
            decoration: InputDecoration(
              labelText: 'NRC Number',
              hintText: '123456/78/9',
              prefixIcon: const Icon(Icons.badge, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter NRC number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a strong password',
              prefixIcon: const Icon(Icons.lock, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
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

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Residential Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _countryController,
          decoration: InputDecoration(
            labelText: 'Country',
            prefixIcon: const Icon(Icons.flag, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
          readOnly: true,
        ),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _provinceController,
          decoration: InputDecoration(
            labelText: 'Province',
            hintText: 'Enter your province',
            prefixIcon: const Icon(Icons.location_city, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          decoration: InputDecoration(
            labelText: 'District',
            hintText: 'Enter your district',
            prefixIcon: const Icon(Icons.map, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          controller: _compoundStreetController,
          decoration: InputDecoration(
            labelText: 'Compound/Street',
            hintText: 'Enter compound or street name',
            prefixIcon: const Icon(Icons.place, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          decoration: InputDecoration(
            labelText: 'House Number (Optional)',
            hintText: 'Enter house number if available',
            prefixIcon: const Icon(Icons.home, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextOfKinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next of Kin Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _kinNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter next of kin full name',
            prefixIcon: const Icon(Icons.person, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter next of kin phone number',
            prefixIcon: const Icon(Icons.phone, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          decoration: InputDecoration(
            labelText: 'Email Address (Optional)',
            hintText: 'Enter next of kin email',
            prefixIcon: const Icon(Icons.email, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        TextFormField(
          controller: _kinNrcController,
          decoration: InputDecoration(
            labelText: 'NRC Number',
            hintText: '123456/78/9',
            prefixIcon: const Icon(Icons.badge, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
          decoration: InputDecoration(
            labelText: 'Relationship',
            prefixIcon: const Icon(Icons.group, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
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
    );
  }

  void _handleStepNavigation(AuthProvider authProvider) async {
    switch (_currentStep) {
      case 0: // Personal Details
        if (_formKey.currentState!.validate()) {
          print('✅ Step 1 validation passed');
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          print('❌ Step 1 validation failed');
        }
        break;
        
      case 1: // Address
        // Validate address fields
        if (_provinceController.text.isEmpty || 
            _districtController.text.isEmpty || 
            _compoundStreetController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please fill all required address fields'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }
        
        print('✅ Step 2 validation passed');
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
        
      case 2: // Next of Kin & Register
        if (_kinNameController.text.isEmpty ||
            _kinPhoneController.text.isEmpty ||
            _kinNrcController.text.isEmpty ||
            _kinRelationship == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please fill all required next of kin fields'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }
        
        print('✅ All steps validated, starting registration');
        await _registerUser(authProvider);
        break;
    }
  }

  Future<void> _registerUser(AuthProvider authProvider) async {
    try {
      print('📤 Starting registration process...');
      
      // Prepare complete user data
      final userData = {
        'full_name': _nameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'gender': _selectedGender?.toLowerCase(),
        'national_id': _nrcController.text,
        'address': {
          'country': _countryController.text,
          'province': _provinceController.text,
          'district': _districtController.text,
          'compound_street': _compoundStreetController.text,
          'house_number': _houseNumberController.text,
        },
        'next_of_kin': {
          'full_name': _kinNameController.text,
          'phone_number': _kinPhoneController.text,
          'email': _kinEmailController.text.isNotEmpty ? _kinEmailController.text : null,
          'nrc_number': _kinNrcController.text,
          'relationship': _kinRelationship,
        },
      };
      
      print('📤 Registration data: $userData');
      
      // Call updated register method
      await authProvider.register(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        _selectedGender ?? 'other',
        _nrcController.text,
        _countryController.text,
        _provinceController.text,
        _districtController.text,
        _compoundStreetController.text,
        _houseNumberController.text,
        _kinNameController.text,
        _kinPhoneController.text,
        _kinEmailController.text,
        _kinNrcController.text,
        _kinRelationship ?? '',
      );
      
      print('✅ Registration API call successful');
      
      if (authProvider.user != null && context.mounted) {
        print('✅ User registered successfully, redirecting to login');
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration successful! Please login with your credentials.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ Registration error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    print('🗑️ RegisterScreen disposed');
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nrcController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countryController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _compoundStreetController.dispose();
    _houseNumberController.dispose();
    _kinNameController.dispose();
    _kinPhoneController.dispose();
    _kinEmailController.dispose();
    _kinNrcController.dispose();
    super.dispose();
  }
}