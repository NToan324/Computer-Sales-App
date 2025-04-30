import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';
import 'verifyemail_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedpasswordController = TextEditingController();
  bool _loading = false;

  Future<void> signUp() async {
    final email = _userNameController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmedpasswordController.text.trim();

    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = AuthService();

      final response = await auth.signup(
        name: email, 
        phone: email, 
        password: pass,
      );

      // Lấy thông tin từ response (ví dụ như id, phone, name, role)
      final userId = response['data']['id']; // Lấy userId từ phản hồi

      // Sau khi đăng ký thành công, chuyển sang trang xác thực email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailView(userId: userId), // Truyền userId cho trang xác thực
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang Login
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Fill your information below or register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 159, 159, 159),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 1,
                      width: 150,
                      color: const Color.fromARGB(255, 159, 159, 159),
                    ),
                    const SizedBox(height: 30),
                    MyTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      controller: _userNameController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    MyTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock,
                      controller: _confirmedpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),
                    MyButton(
                      text: 'Sign Up',
                      onTap: _loading ? null : (_) => signUp(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
