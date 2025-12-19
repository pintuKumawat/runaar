import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: 20.all,
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

                Text("Login to continue", style: theme.textTheme.bodyMedium),

                25.height,

                /// MOBILE NUMBER
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter mobile number",
                    prefixIcon: Icon(Icons.phone, size: 16.sp),
                  ),
                ),

                const SizedBox(height: 15),

                /// PASSWORD
                TextFormField(
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    prefixIcon: Icon(Icons.lock, size: 16.sp),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 14.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => appNavigator.push(BottomNav()),
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(height: 15),

                /// SIGN UP TEXT
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
                            builder: (context) => SignupScreen(),
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
      ),
    );
  }
}
