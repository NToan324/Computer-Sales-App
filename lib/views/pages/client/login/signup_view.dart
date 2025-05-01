import 'package:flutter/material.dart';
import 'package:computer_sales_app/services/auth.service.dart';
import 'widgets/button.dart';
import 'widgets/text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();
  bool _loading = false;

  Future<void> signUp() async {
    final name = _userNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmedPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        pass.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = AuthService();

      await auth.signup(
        name: name,
        email: email,
        phone: email,
        address: address,
        password: pass,
      );

      // Lấy thông tin từ response (ví dụ như id, phone, name, role)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up successful')),
      );
      // Sau khi đăng ký thành công, chuyển sang trang xác thực email
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
               
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fill the form below to create an account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 159, 159, 159),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    hintText: 'Full Name',
                    prefixIcon: Icons.person,
                    controller: _userNameController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Phone Number',
                    prefixIcon: Icons.phone,
                    controller: _phoneController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Address',
                    prefixIcon: Icons.location_on,
                    controller: _addressController,
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
                    controller: _confirmedPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  _loading
                      ? const CircularProgressIndicator()
                      : MyButton(
                          text: 'Đăng Ký',
                          onTap: (_) => signUp(),
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}