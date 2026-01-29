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
  backgroundColor: Colors.grey.shade100,
  appBar: AppBar(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        10.height,

        /// TOP IMAGE
        Image.asset(
          "assets/images/login yellow.png",
          height: 170.h,
        ),

        20.height,

        /// TITLE
        Text(
          "Secure Your Account",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),

        8.height,
        Text(
          "Login to continue",
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),

        30.height,

        /// FORM CARD
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// MOBILE NUMBER
                TextFormField(
                  controller: loginController.mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: provider.validatePhone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: "Enter mobile number",
                    counterText: "",
                    errorText: provider.phoneError,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: appColor.secondColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                20.height,

                /// PASSWORD
                TextFormField(
                  controller: loginController.passwordController,
                  obscureText: !provider.isPasswordVisible,
                  onChanged: provider.validatePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: "Enter password",
                    errorText: provider.passwordError,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: appColor.secondColor,
                        width: 2,
                      ),
                    ),
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

                10.height,

                /// FORGOT
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

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () async => _loginUser(provider: provider),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        25.height,

        /// SIGNUP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            6.width,
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
                "Sign Up",
                style: TextStyle(
                  color: appColor.secondColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);


  }

  Future<void> _loginUser({required LoginProvider provider}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(savedData.fcmToken);
    debugPrint("Token is: $token");
    if (!provider.validateAll()) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Please enter all and correct data",
      );
    }

    await provider.login(
      number: loginController.mobileController.text,
      password: loginController.passwordController.text,
      token: token ?? "",
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
    prefs.setString(savedData.email, provider.response?.userEmail ?? "");
    prefs.setString(savedData.mob, provider.response?.userPhoneNo ?? "");
    prefs.setInt(savedData.userId, provider.response?.userId ?? 0);

    appNavigator.pushAndRemoveUntil(BottomNav(initialIndex: 2));
    loginController.clear();
  }
}
