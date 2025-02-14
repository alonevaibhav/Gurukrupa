import 'package:flutter/material.dart';
import 'package:transacto/Helper/responsive.dart';
import 'package:transacto/View/Auth/Login/login_desktop.dart';
import 'package:transacto/View/Auth/Login/login_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: LoginMobile(),
        tablet: LoginDesktop(),
        desktop: LoginDesktop()
    );
  }
}
