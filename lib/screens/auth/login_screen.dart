import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/auth/login_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/login_provider.dart';
import 'package:runaar/screens/auth/forgot_mobile_screen.dart';
import 'package:runaar/screens/auth/sign_up_screen.dart';
import 'package:runaar/screens/home/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                controller: loginController.mobileController,
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
                controller: loginController.passwordController,
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
                  onPressed: () {
                    appNavigator.push(ForgotMobileScreen());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: appColor.secondColor),
                  ),
                ),
              ),

              20.height,

              /// 🚀 LOGIN BUTTON (Provider login)
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async => _loginUser(provider: provider),
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
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

  Future<void> _loginUser({required LoginProvider provider}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!provider.validateAll()) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Please enter all and correct data",
      );
    }

    await provider.login(
      number: loginController.mobileController.text,
      password: loginController.passwordController.text,
    );
    if (provider.errorMessage != null) {
      return appSnackbar.showSingleSnackbar(
        context,
        provider.errorMessage ?? "",
      );
    }
    appSnackbar.showSingleSnackbar(
      context,
      provider.response?.message ?? "Login Successfull!!",
    );
    prefs.setBool(savedData.isFirstLauch, false);
    prefs.setBool(savedData.isLoggedIn, true);
    prefs.setInt(savedData.userId, provider.response?.userId ?? 0);
    appNavigator.pushAndRemoveUntil(BottomNav(initialIndex: 2));

    loginController.clear();
  }
}
