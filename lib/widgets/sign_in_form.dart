import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit_app/models/sign_in_model.dart';
import 'package:toolkit_app/navigation/main_navigation.dart';
import 'package:toolkit_app/widgets/custom_nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInForm extends StatefulWidget {
  final VoidCallback onSignup;
  final VoidCallback onSignIn;
  final VoidCallback onForgotPassword;

  const SignInForm({
    super.key,
    required this.onSignup,
    required this.onSignIn,
    required this.onForgotPassword,
  });

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to sign in. Please try again.')),
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
          _label('Email address'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration(hint: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          _label('Password'),

          const SizedBox(height: 8),

          TextFormField(
            controller: _passwordController,
            decoration: _inputDecoration(hint: 'Password'),
            obscureText: _hidePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
              TextButton(
                onPressed: widget.onForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
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
                _isLoading ? 'Signing In...' : 'Sign In',
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
                  'or sign in with',
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                ),
              ),
              Expanded(
                child: Divider(color: Color(0xFF777777), thickness: 0.7),
              ),
            ],
          ),

          const SizedBox(height: 24),

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

          const SizedBox(height: 40),

          Center(
            child: GestureDetector(
              onTap: widget.onSignup,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                  children: [
                    TextSpan(text: 'Don\'t have an account? '),
                    TextSpan(
                      text: 'Sign Up',
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
