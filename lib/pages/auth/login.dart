import 'package:arcane/services/auth_service.dart';
import 'package:arcane/widgets/buttons/textbtn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    // ignore: unused_local_variable
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

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
                                        "Hello, welcome!",
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
  bool rememberMe = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService auth = AuthService();

  void toRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/auth/register');
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final user =
          await auth.loginWithEmailPassword(email: email, password: password);

      if (user != null) {
        context.go("/");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка входа. Проверьте данные.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final buttonWidthLogin = isMobile ? double.infinity : 200.0;
    final buttonWidthReg = isMobile ? double.infinity : 140.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //ВХОД через google
                ElevatedButton(
                  onPressed: () async {
                    final user = await AuthService().signInWithGoogle();
                    if (user != null) {
                      print("Вошли как: ${user.email}");
                    }
                  },
                  child: const Text("Sign in with Google"),
                ),
                TextFormField(
                  controller: _emailController,
                  cursorWidth: 1.0,
                  cursorRadius: const Radius.circular(1),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Type your email",
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb31217))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return "Enter a valid email address";
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
                    hintText: "Type your password",
                    prefixIcon:
                        Icon(Icons.lock_outline_rounded, color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFb31217))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => rememberMe = !rememberMe),
                      child: Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) =>
                                setState(() => rememberMe = value ?? false),
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
                            width: buttonWidthLogin,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFb31217),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: buttonWidthReg,
                            child: ElevatedButton(
                              onPressed: () => context.go("/auth/register"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 88, 10, 13),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Sign up",
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
                              width: buttonWidthLogin,
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFb31217),
                                  minimumSize: const Size(110, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Login",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: buttonWidthReg,
                            child: ElevatedButton(
                              onPressed: () => context.go("/auth/register"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 88, 10, 13),
                                minimumSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Sign up",
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
