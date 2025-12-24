import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/provider/signup_provider.dart';

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
      appBar: AppBar(
        // automaticallyImplyActions: false
        automaticallyImplyLeading: false,
        // title: const Text("Sign Up"),
        // centerTitle: true,
      ),
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
              onChanged: provider.userNameValidate,
              decoration: const InputDecoration(
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
                prefixIcon: Icon(Icons.email),
              ),
            ),
        
            10.height,
        
            /// MOBILE NUMBER
            TextFormField(
              onChanged: provider.validMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Enter mobile number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
        
            10.height,
        
            /// PASSWORD
            TextFormField(
              onChanged: provider.validPassword,
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
