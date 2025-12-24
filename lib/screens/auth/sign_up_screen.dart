import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/auth/sign_up_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/validate/signup_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //  mainAxisAlignment: .center,
          children: [
            CircleAvatar(radius: 60, backgroundColor: Colors.black),
            const SizedBox(height: 25),

            Text(
              "Create Account",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            25.height,

            /// USERNAME
            TextFormField(
              controller: signUpController.nameController,
              onChanged: provider.validateUserName,
              decoration: InputDecoration(
                hintText: "Enter username",

                prefixIcon: Icon(Icons.person),
              ),
            ),

            10.height,

            /// EMAIL
            TextFormField(
              onChanged: provider.emailValidate,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter email",
                prefixIcon: const Icon(Icons.email),
                errorText: provider.emailError,
              ),
            ),

            10.height,

            /// MOBILE NUMBER
            TextFormField(
              onChanged: provider.validMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Enter mobile number",
                prefixIcon: const Icon(Icons.phone),
                errorText: provider.phoneNumberError,
              ),
            ),

            10.height,

            /// PASSWORD
            TextFormField(
              onChanged: provider.validPassword,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Enter password",
                errorText: provider.passwordError,
                prefixIcon: const Icon(Icons.lock),
                errorText: provider.passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: provider.togglePasswordVisibility,
                ),
              ),
            ),

            25.height,

            /// SIGNUP BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Sign Up"),
              ),
            ),

            10.height,

            /// LOGIN TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: appColor.secondColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp(SignupProvider provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await provider.signup(
      name: signUpController.nameController.text,
      email: signUpController.emailController.text,
      number: signUpController.mobileController.text,
      password: signUpController.passwordController.text,
    );

    if (provider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(context, provider.errorMessage ?? "");
      return;
    }
    appSnackbar.showSingleSnackbar(
      context,
      provider.response?.message ?? "Sign up Successful",
    );

    prefs.setBool(savedData.isFirstLauch, false);

    appNavigator.pushReplacement(LoginScreen());
  }
}
