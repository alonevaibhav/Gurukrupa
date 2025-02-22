import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Constants/api_con.dart';
import '../../Vendor/vendor.dart';
import 'login_screen.dart';

class AuthControllerr extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse(baseUrl + signIn),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(VendorPage());
    } else {
      Get.snackbar('Error', 'Login failed');
    }
    isLoading.value = false;
  }

  Future<void> register() async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse(baseUrl + logIn),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Registration successful');
      Get.to(LoginPage());
    } else {
      Get.snackbar('Error', 'Registration failed');
    }
    isLoading.value = false;
  }
}
