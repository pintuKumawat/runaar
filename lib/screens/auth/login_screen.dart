import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/provider/auth/validate/login_provider.dart';
import 'package:runaar/screens/auth/sign_up_screen.dart';
import 'package:runaar/screens/home/bottom_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: 10.all,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              Text(
                "Welcome Back",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              10.height,
              Text("Login to continue", style: theme.textTheme.titleSmall),
              25.height,

              // MOBILE NUMBER (LIVE VALIDATION)
              TextFormField(
                controller: provider.loginPhoneController,
                keyboardType: TextInputType.phone,
                onChanged: provider.validatePhone,
                decoration: InputDecoration(
                  hintText: "Enter mobile number",
                  prefixIcon: const Icon(Icons.phone),
                  errorText: provider.phoneError,
                ),
              ),

              15.height,

              ///  PASSWORD (LIVE VALIDATION)
              TextFormField(
                controller: provider.loginPasswordController,
                obscureText: !provider.isPasswordVisible,
                onChanged: provider.validatePassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: const Icon(Icons.lock),
                  errorText: provider.passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: provider.togglePasswordVisibility,
                  ),
                ),
              ),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),

              20.height,

              /// 🚀 LOGIN BUTTON (Provider login)
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          await provider.login();

                          // Navigate only if validation passed
                          if (provider.phoneError == null &&
                              provider.passwordError == null) {
                            appNavigator.pushAndRemoveUntil(const BottomNav());
                          }
                        },
                        child: const Text("Login"),
                      ),
              ),

              15.height,

              /// SIGN UP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  4.width,
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: appColor.secondColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
