import 'dart:ui';

import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/core/constants/app_texts.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.loginBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text(
                AppTexts.loginYourAccount,
                style: TextStyle(fontSize: 32, color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                AppTexts.provideYourData,
                style: TextStyle(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              hintText: AppTexts.provideEmail,
                              hintStyle: TextStyle(color: AppColors.darkGray),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.white,
                              ),
                            ),
                            style: const TextStyle(color: AppColors.white),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              hintText: AppTexts.providePassword,
                              hintStyle: TextStyle(color: AppColors.darkGray),
                              prefixIcon: const Icon(
                                Icons.key,
                                color: AppColors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.white,
                                ),
                                onPressed: () {
                                  setState(
                                    () => obscurePassword = !obscurePassword,
                                  );
                                },
                              ),
                            ),
                            style: const TextStyle(color: AppColors.white),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberMe,
                                    onChanged: (value) {
                                      setState(() => rememberMe = value!);
                                    },
                                    activeColor: AppColors.lightBlue,
                                  ),
                                  const Text(
                                    AppTexts.rememberMe,
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  AppTexts.forgotPassword,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/main');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                AppTexts.login,
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: const [
                              Expanded(child: Divider(color: AppColors.white)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  AppTexts.or,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              Expanded(child: Divider(color: AppColors.white)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                AppAssets.googleLogo,
                                height: 20,
                              ),
                              label: const Text(
                                AppTexts.google,
                                style: TextStyle(color: AppColors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text.rich(
                                TextSpan(
                                  text: AppTexts.dontHaveAccount,
                                  style: TextStyle(color: AppColors.white),
                                  children: [
                                    TextSpan(
                                      text: AppTexts.register,
                                      style: TextStyle(color: AppColors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
