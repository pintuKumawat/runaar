import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyActions: false
        automaticallyImplyLeading: false,
        // title: const Text("Sign Up"),
        // centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Text(
                  "Create Account",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                25.height,

                /// USERNAME
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Enter username",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                10.height,

                /// EMAIL
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                10.height,

                /// MOBILE NUMBER
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "Enter mobile number",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),

                10.height,

                /// PASSWORD
                TextFormField(
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    onPressed: () {},
                    child: const Text("Sign Up"),
                  ),
                ),

                10.height,

                /// LOGIN TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    4.width,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login", style: TextStyle(color: appColor.secondColor),),
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
