import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  String _serverUrl = AppConstants.baseUrl;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get serverUrl => _serverUrl;

  // Test server connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_serverUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Try different server URLs
  Future<void> findServer() async {
    final possibleUrls = [
      'http://10.19.14.201:3000',
      'http://192.168.122.1:3000',
      'http://10.0.2.2:3000',
      'http://localhost:3000',
    ];

    for (final url in possibleUrls) {
      print('🔍 Testing connection to: $url');
      try {
        final response = await http.get(
          Uri.parse('$url/api/health'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          _serverUrl = url;
          print('✅ Found working server: $url');
          return;
        }
      } catch (e) {
        print('❌ Failed to connect to: $url');
      }
    }
    
    throw Exception('No server found. Make sure backend is running.');
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final isConnected = await testConnection();
      if (!isConnected) {
        await findServer();
      }

      final response = await http.post(
        Uri.parse('$_serverUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      print('Login response: ${response.statusCode}');
      print('Response body: $data');
      
      if (response.statusCode == 200 && data['success']) {
        _user = User.fromJson(data['user']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));
        await prefs.setString('server_url', _serverUrl);
        
        print('✅ Login successful for: ${_user?.email}');
      } else {
        throw Exception(data['error'] ?? 'Login failed');
      }
    } catch (error) {
      _error = error.toString();
      print('Login error: $_error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String gender,
    String nrc,
    String country,
    String province,
    String district,
    String compoundStreet,
    String houseNumber,
    String kinName,
    String kinPhone,
    String kinEmail,
    String kinNrc,
    String kinRelationship,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final isConnected = await testConnection();
      if (!isConnected) {
        await findServer();
      }

      // Prepare complete user data
      final userData = {
        'full_name': name,
        'email': email,
        'phone_number': phone,
        'password': password,
        'gender': gender.toLowerCase(),
        'national_id': nrc,
        'address': {
          'country': country,
          'province': province,
          'district': district,
          'compound_street': compoundStreet,
          'house_number': houseNumber,
        },
        'next_of_kin': {
          'full_name': kinName,
          'phone_number': kinPhone,
          'email': kinEmail.isNotEmpty ? kinEmail : null,
          'nrc_number': kinNrc,
          'relationship': kinRelationship,
        },
      };

      print('📤 Sending registration data: ${jsonEncode(userData)}');

      final response = await http.post(
        Uri.parse('$_serverUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      
      print('Register response: ${response.statusCode}');
      print('Response body: $data');
      
      if (response.statusCode == 201 && data['success']) {
        _user = User.fromJson(data['user']);
        print('✅ Registration successful for: ${_user?.email}');
      } else {
        throw Exception(data['error'] ?? 'Registration failed');
      }
    } catch (error) {
      _error = error.toString();
      print('Registration error: $_error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    final savedUrl = prefs.getString('server_url');
    
    if (savedUrl != null) {
      _serverUrl = savedUrl;
    }
    
    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      print('🔄 Starting logout process...');
      
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove('token');
      await prefs.remove('user');
      await prefs.remove('server_url');
      
      print('✅ Local storage cleared');
      
      _user = null;
      _error = null;
      
      notifyListeners();
      
      print('✅ Logout completed successfully');
      
    } catch (error) {
      print('❌ Logout error: $error');
      throw Exception('Logout failed: $error');
    }
  }

  Future<void> loadCompleteProfile() async {}

  Future<dynamic> checkEmailAvailability(String email) async {}

  Future<dynamic> checkPhoneAvailability(String phone) async {}

  Future<dynamic> checkNrcAvailability(String nrc) async {}
}