import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toolkit_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit_app/screens/sign_in_screen.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onSignup;
  final VoidCallback onSignIn;

  const SignupForm({super.key, required this.onSignup, required this.onSignIn});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (response.user == null) {
        throw const AuthException('Account creation failed. Please try again.');
      }

      if (response.session != null) {
        // Email confirmation is not required, or a session was created.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        widget.onSignup();
      } else {
        // Supabase may require email confirmation before login.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created! Check your email to confirm your account.',
            ),
          ),
        );
      }
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF777777), fontSize: 15),
      filled: true,
      fillColor: Colors.grey.shade300,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Full name'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(hint: 'Enter your full name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your full name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          _label('Email address'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(hint: 'Enter your email'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter your email';
              }

              if (!value.contains('@')) {
                return 'Enter a valid email';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          _label('Password'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _passwordController,
            obscureText: _hidePassword,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              hint: 'Create a password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF777777),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Create a password';
              }

              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          _label('Confirm password'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _hideConfirmPassword,
            textInputAction: TextInputAction.done,
            decoration: _inputDecoration(
              hint: 'Confirm your password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hideConfirmPassword = !_hideConfirmPassword;
                  });
                },
                icon: Icon(
                  _hideConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF777777),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm your password';
              }

              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }

              return null;
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _createAccount,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _isLoading ? 'creating account...' : 'Create Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Expanded(
                child: Divider(color: Color(0xFF777777), thickness: 0.7),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'or sign up with',
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                ),
              ),
              Expanded(
                child: Divider(color: Color(0xFF777777), thickness: 0.7),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue, width: 1),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: Icon(Icons.facebook, size: 32, color: Colors.blue),
                  label: Text(
                    'Facebook',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue, width: 1),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/google_icon.svg',
                    width: 28,
                    height: 28,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Google',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Center(
            child: GestureDetector(
              onTap: widget.onSignIn,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  children: [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
