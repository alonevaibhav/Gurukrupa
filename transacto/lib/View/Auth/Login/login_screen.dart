// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../Controller/auth_controller.dart';
// import '../../Vendor/vendor.dart';
// import 'auth_controller.dart';
//
// class LoginPage extends StatelessWidget {
//   final AuthControllerr authController = Get.put(AuthControllerr());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: authController.emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: authController.passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             Obx(() => authController.isLoading.value
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: authController.login,
//               child: Text('Login'),
//             )),
//             TextButton(
//               onPressed: () =>Get.to(RegisterPage()),
//               child: Text('Don\'t have an account? Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RegisterPage extends StatelessWidget {
//   final AuthControllerr authController = Get.put(AuthControllerr());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: authController.emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: authController.passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             Obx(() => authController.isLoading.value
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: authController.register,
//               child: Text('Register'),
//             )),
//             TextButton(
//               onPressed: () =>Get.to(LoginPage()),
//               child: Text('Already have an account? Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transacto/View/Auth/Login/auth_controller.dart';
import '../../../Controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthControllerr authController = Get.put(AuthControllerr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.purple.shade600],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo or Brand Icon
                Hero(
                  tag: 'logo',
                  child: Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                // Email Field
                Padding(
                  padding: const EdgeInsets.only(left: 400,right: 400),
                  child: _buildTextField(
                    controller: authController.emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                ),
                SizedBox(height: 20),
                // Password Field
                Padding(
                  padding: const EdgeInsets.only(left: 400,right: 400),

                  child: _buildTextField(
                    controller: authController.passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                ),
                SizedBox(height: 30),
                // Login Button
                Obx(
                      () => authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Padding(

                        padding: const EdgeInsets.only(left: 400,right: 400),
                        child: _buildButton(
                                            text: 'Login',
                                            onPressed: authController.login,
                                            color: Colors.white,
                                            textColor: Colors.blue.shade900,
                                          ),
                      ),
                ),
                SizedBox(height: 20),
                // Register Link
                TextButton(
                  onPressed: () => Get.to(() => RegisterPage(),
                      transition: Transition.rightToLeft),
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final AuthControllerr authController = Get.put(AuthControllerr());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade600, Colors.blue.shade900],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Join Our Store',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Create an account to start shopping',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 400,right: 400),
                  child: _buildTextField(
                    controller: authController.emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 400,right: 400),
                  child: _buildTextField(
                    controller: authController.passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                ),
                SizedBox(height: 30),
                Obx(
                      () => authController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Padding(
                        padding: const EdgeInsets.only(left: 400,right: 400),
                        child: _buildButton(
                                            text: 'Register',
                                            onPressed: authController.register,
                                            color: Colors.white,
                                            textColor: Colors.purple.shade900,
                                          ),
                      ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.to(() => LoginPage(),
                      transition: Transition.leftToRight),
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

// Same _buildTextField and _buildButton methods as above
// I've omitted them here to avoid repetition, but they should be included
}