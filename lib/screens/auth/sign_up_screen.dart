import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/provider/signup_provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundColor: Colors.black),
            const SizedBox(height: 25),

            Text(
              "Create Account",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            /// USERNAME
            TextFormField(
              controller: provider.signUserController,
              onChanged: provider.validateUserName,
              decoration: InputDecoration(
                hintText: "Enter username",
                prefixIcon: const Icon(Icons.person),
                errorText: provider.userNameError,
              ),
            ),

            const SizedBox(height: 10),

            /// EMAIL
            TextFormField(
              controller: provider.signEmailController,
              onChanged: provider.validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter email",
                prefixIcon: const Icon(Icons.email),
                errorText: provider.emailError,
              ),
            ),

            const SizedBox(height: 10),

            /// MOBILE
            TextFormField(
              controller: provider.signPhoneController,
              onChanged: provider.validateMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter mobile number",
                prefixIcon: const Icon(Icons.phone),
                errorText: provider.phoneNumberError,
              ),
            ),

            const SizedBox(height: 10),

            /// PASSWORD
            TextFormField(
              controller: provider.signPasswordController,
              onChanged: provider.validatePassword,
              obscureText: !provider.isPasswordVisible,
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

            const SizedBox(height: 25),

            /// SIGNUP BUTTON
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        await provider.signup();

                        if (provider.validateAll()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Signup Successful")),
                          );
                        }
                      },
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => Navigator.pop(context),
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
}
