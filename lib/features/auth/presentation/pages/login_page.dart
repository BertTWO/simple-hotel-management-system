import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jordanhotel/core/di/injector.dart';
import 'package:jordanhotel/features/auth/presentation/cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Use pushReplacementNamed for successful login navigation
            Navigator.pushReplacementNamed(context, '/Dashboard');
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildUI(context),
              if (state is AuthLoading) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.background, // Use theme color
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context),

                _buildForm(context),
                const SizedBox(height: 32),
                _buildButton(context),
                const SizedBox(height: 16),
                _buildForgotPwdLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ HEADER (Logo and Text) ------------------
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 210, // Adjust size as needed
          width: 210,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // ------------------ FORM ------------------
  Widget _buildForm(BuildContext context) {
    return Card(
      // Changed Container to Card for better theme integration and elevation
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // USERNAME
              TextFormField(
                controller: _usernameController,
                decoration: _inputStyle(
                  label: "Username",
                  icon: Icons.person_outline,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Enter username" : null,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20), // Adjusted spacing
              // PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: _inputStyle(
                  label: "Password",
                  icon: Icons.lock_outline,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Enter password" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Form Input Style
  InputDecoration _inputStyle({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    // Leveraging the theme's input decoration and customizing prefix/suffix colors
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
      ),
      suffixIcon: suffix,
      // The rest of the styling comes from the InputDecorationTheme in app_theme.dart
    );
  }

  // ------------------ LOGIN BUTTON (with Interactive Effect) ------------------
  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 1.0,
          end: context.watch<AuthCubit>().state is AuthLoading ? 0.95 : 1.0,
        ),
        duration: const Duration(milliseconds: 150),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: ElevatedButton(
              onPressed: context.watch<AuthCubit>().state is AuthLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().login(
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      }
                    },
              // The style is inherited from the theme's ElevatedButtonThemeData
              child: const Text("Sign In"),
            ),
          );
        },
      ),
    );
  }

  // ------------------ Forgot Password Link (Interactive Element) ------------------
  Widget _buildForgotPwdLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Placeholder for Forgot Password action
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Forgot password functionality coming soon!"),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Text(
        "Forgot Password?",
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ------------------ LOADING OVERLAY ------------------
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.35), // Slightly darker overlay
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }

  // ------------------ CLEAN DISPOSE ------------------
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
