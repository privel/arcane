import 'package:arcane/services/auth_service.dart';
import 'package:arcane/widgets/buttons/textbtn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    final double containerWidth = isMobile
        ? double.infinity
        : isTablet
            ? 600
            : 1000;

    final double? containerHeight = isMobile ? null : 600;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // общие углы
            child: Container(
              height: containerHeight,
              width: containerWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: isMobile
                  ? const Column(
                      children: [
                        buildRightPanel(),
                      ],
                    )
                  : Row(
                      children: [
                        // Левая панель
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/img/backgrounds/redback.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      child: Text("LOGO"),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 32),
                                      Text(
                                        ", welcome!",
                                        style: TextStyle(
                                          fontSize: 42,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nisi risus.",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontFamily: "Inter",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Правая панель
                        const Expanded(
                          flex: 3,
                          child: buildRightPanel(),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class buildRightPanel extends StatefulWidget {
  const buildRightPanel({super.key});

  @override
  State<buildRightPanel> createState() => _buildRightPanelState();
}

class _buildRightPanelState extends State<buildRightPanel> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AuthService auth = AuthService();

  bool rememberMe = false;

  void toLoginPage(BuildContext context) {
    Navigator.pushNamed(context, '/auth/login');
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      auth.registerWithEmailPassword(email: email, password: password);
      Navigator.pushNamed(context, "/");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Регистрация прошла успешно")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final buttonWidthReg = isMobile ? double.infinity : 200.0;
    final buttonWidthLogin = isMobile ? double.infinity : 140.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  cursorWidth: 1.0,
                  cursorRadius: const Radius.circular(1),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                    hintText: "Type your email",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb31217))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorWidth: 1.0,
                  cursorRadius: const Radius.circular(1),
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon:
                        Icon(Icons.lock_outline_rounded, color: Colors.grey),
                    hintText: "Type your password",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb31217))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  cursorWidth: 1.0,
                  cursorRadius: const Radius.circular(1),
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon:
                        Icon(Icons.lock_outline_rounded, color: Colors.grey),
                    hintText: "Repeat your password",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb31217))),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text("Remember me"),
                        ],
                      ),
                    ),
                    Textbtn(
                      onpressed: () {
                        print("forgot password press");
                      },
                      textparamets: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Inter",
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: buttonWidthReg,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFb31217),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _submit,
                              child: Text(
                                "Sign up",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: buttonWidthLogin,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 88, 10, 13),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => context.go("/auth/login"),
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: buttonWidthReg,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFb31217),
                                  minimumSize: const Size(110, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _submit,
                                child: Text(
                                  "Sign up",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: buttonWidthLogin,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 88, 10, 13),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => context.go("/auth/login"),
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("FOLLOW  "),
                    Icon(Icons.facebook, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.abc, size: 20),
                    SizedBox(width: 12),
                    Icon(Icons.email_outlined, size: 20),
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
