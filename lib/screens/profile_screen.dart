import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:village_banking/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  
  // Edit controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    print('✅ ProfileScreen initialized');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Initialize controllers with user data
    if (!_isEditing && user != null) {
      _nameController.text = user.fullName ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit_outlined,
              color: _isEditing ? Colors.red : Colors.green,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Avatar
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 3),
                            ),
                            child: Center(
                              child: Text(
                                _getUserInitials(user.fullName ?? 'U'),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        user.fullName ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      // Email
                      Text(
                        user.email ?? 'No email',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // User Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          user.userType?.toUpperCase() ?? 'MEMBER',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: Colors.green,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Personal'),
                      Tab(text: 'Address'),
                      Tab(text: 'Next of Kin'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPersonalTab(user),
                      _buildAddressTab(user),
                      _buildNextOfKinTab(user),
                    ],
                  ),
                ),

                // Save Button (only visible when editing)
                if (_isEditing)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _saveChanges(authProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'SAVE CHANGES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildPersonalTab(user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),

          _buildInfoCard(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: user?.fullName ?? 'N/A',
            color: Colors.blue,
            isEditable: _isEditing,
            controller: _nameController,
          ),

          _buildInfoCard(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: user?.email ?? 'N/A',
            color: Colors.orange,
            isEditable: _isEditing,
            controller: _emailController,
          ),

          _buildInfoCard(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: user?.phoneNumber ?? 'N/A',
            color: Colors.green,
            isEditable: _isEditing,
            controller: _phoneController,
          ),

          _buildInfoCard(
            icon: Icons.badge_outlined,
            label: 'NRC Number',
            value: user?.nationalId ?? 'N/A',
            color: Colors.purple,
          ),

          _buildInfoCard(
            icon: Icons.wc_outlined,
            label: 'Gender',
            value: user?.gender?.toUpperCase() ?? 'N/A',
            color: Colors.pink,
          ),

          _buildInfoCard(
            icon: Icons.calendar_today_outlined,
            label: 'Member Since',
            value: _formatDate(user?.createdAt),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTab(user) {
    final address = user?.address;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Residential Address',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),

          if (address == null)
            Center(
              child: Column(
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No address information available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else ...[
            _buildInfoCard(
              icon: Icons.public_outlined,
              label: 'Country',
              value: address.country ?? 'N/A',
              color: Colors.blue,
            ),

            _buildInfoCard(
              icon: Icons.location_city_outlined,
              label: 'Province',
              value: address.province ?? 'N/A',
              color: Colors.green,
            ),

            _buildInfoCard(
              icon: Icons.map_outlined,
              label: 'District',
              value: address.district ?? 'N/A',
              color: Colors.orange,
            ),

            _buildInfoCard(
              icon: Icons.place_outlined,
              label: 'Compound/Street',
              value: address.compoundStreet ?? 'N/A',
              color: Colors.purple,
            ),

            _buildInfoCard(
              icon: Icons.home_outlined,
              label: 'House Number',
              value: address.houseNumber?.isNotEmpty == true ? address.houseNumber! : 'Not provided',
              color: Colors.teal,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNextOfKinTab(user) {
    final nextOfKin = user?.nextOfKin;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next of Kin Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),

          if (nextOfKin == null)
            Center(
              child: Column(
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No next of kin information available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else ...[
            _buildInfoCard(
              icon: Icons.person_outline,
              label: 'Full Name',
              value: nextOfKin.fullName ?? 'N/A',
              color: Colors.blue,
            ),

            _buildInfoCard(
              icon: Icons.phone_outlined,
              label: 'Phone Number',
              value: nextOfKin.phoneNumber ?? 'N/A',
              color: Colors.green,
            ),

            _buildInfoCard(
              icon: Icons.email_outlined,
              label: 'Email Address',
              value: nextOfKin.email?.isNotEmpty == true ? nextOfKin.email! : 'Not provided',
              color: Colors.orange,
            ),

            _buildInfoCard(
              icon: Icons.badge_outlined,
              label: 'NRC Number',
              value: nextOfKin.nrcNumber ?? 'N/A',
              color: Colors.purple,
            ),

            _buildInfoCard(
              icon: Icons.group_outlined,
              label: 'Relationship',
              value: nextOfKin.relationship?.toUpperCase() ?? 'N/A',
              color: Colors.pink,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isEditable = false,
    TextEditingController? controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                isEditable && controller != null
                    ? TextFormField(
                        controller: controller,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUserInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _saveChanges(AuthProvider authProvider) async {
    try {
      // Here you would call an API to update user profile
      // For now, just show a success message
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    print('🗑️ ProfileScreen disposed');
    super.dispose();
  }
}