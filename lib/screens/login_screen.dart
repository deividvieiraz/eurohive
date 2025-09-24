import 'dart:ui';

import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/core/constants/app_texts.dart';
import 'package:eurohive/screens/main_screen.dart';
import 'package:eurohive/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool rememberMe = true; // Padrão ligado
  bool isLoading = false;
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carrega o estado de forma assíncrona, mas mantém o padrão true
    _loadRememberMeState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMeState() async {
    try {
      // Só carrega o estado se já foi definido pelo usuário
      final hasBeenSet = await AuthService.hasRememberMeBeenSet();
      if (hasBeenSet) {
        final rememberMeState = await AuthService.isRememberMeEnabled();
        setState(() {
          rememberMe = rememberMeState;
        });
      }
      // Se não foi definido, mantém o padrão true
    } catch (e) {
      // Se houver erro, mantém o padrão true
    }
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Por favor, preencha todos os campos');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final success = await AuthService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        rememberMe: rememberMe,
      );

      if (success) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                
                return SlideTransition(
                  position: offsetAnimation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      } else {
        _showErrorDialog('Usuário ou senha incorretos');
      }
    } catch (e) {
      _showErrorDialog('Erro ao fazer login. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 20),
                child: const Text(
                  AppTexts.loginYourAccount,
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.black87,
                      child: ListView(
                        children: [
                          const Text(
                            AppTexts.provideYourData,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _usernameController,
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
                            controller: _passwordController,
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
                                    onChanged: (value) async {
                                      setState(() => rememberMe = value!);
                                      await AuthService.setRememberMe(value!);
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
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
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
                                  style: TextStyle(color: AppColors.white, fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: AppTexts.register,
                                      style: TextStyle(color: AppColors.blue, fontSize: 16),
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
