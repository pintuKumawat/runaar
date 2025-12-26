import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/auth/sign_up_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //  mainAxisAlignment: .center,
          children: [
            /// TITLE
            CircleAvatar(radius: 60.r, backgroundColor: Colors.black),
            25.height,
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
              onChanged: provider.validateUserName,inputFormatters: [FirstLetterCapitalFormatter()],
              decoration: InputDecoration(
                hintText: "Enter username",
                errorText: provider.userNameError,
                prefixIcon: Icon(Icons.person),
              ),
            ),

            10.height,

            /// EMAIL
            TextFormField(
              controller: signUpController.emailController,
              onChanged: provider.validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorText: provider.emailError,
                hintText: "Enter email",
                prefixIcon: Icon(Icons.email),
              ),
            ),

            10.height,

            /// MOBILE NUMBER
            TextFormField(
              controller: signUpController.mobileController,
              onChanged: provider.validateMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorText: provider.phoneNumberError,
                hintText: "Enter mobile number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            10.height,

            /// PASSWORD
            TextFormField(
              controller: signUpController.passwordController,
              onChanged: provider.validatePassword,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintText: "Enter password",
                errorText: provider.passwordError,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            25.height,

            /// SIGNUP BUTTON
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () async => _signUp(provider),
                child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Sign Up"),
              ),
            ),

            10.height,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                4.width,
                InkWell(
                  onTap: () {
                    appNavigator.push(LoginScreen());
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
