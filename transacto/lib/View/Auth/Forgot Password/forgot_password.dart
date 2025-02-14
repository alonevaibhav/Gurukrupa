import 'package:flutter/material.dart';
import 'package:transacto/Helper/responsive.dart';
import 'package:transacto/View/Auth/Forgot%20Password/forgot_password_desktop.dart';
import 'package:transacto/View/Auth/Forgot%20Password/forgot_password_mobile.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: ForgotPasswordMobile(),
        tablet: ForgotPasswordDesktop(),
        desktop: ForgotPasswordDesktop()
    );
  }
}
