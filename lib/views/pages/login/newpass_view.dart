// TODO Implement this library.
import "package:computer_sales_app/views/pages/login/widgets/text_field.dart";
import "package:flutter/material.dart";
import 'widgets/button.dart';
class NewPasswordView extends StatelessWidget {
  NewPasswordView({super.key});
  final passwordController = TextEditingController();
  final confirmedpasswordController = TextEditingController();
  //Sign user in method
  void newPass() {
    print('Newpass');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                    'New password',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Your new password must be differrent from previously used passwords',
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
                  const SizedBox(height: 60),
                  MyTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    hintText: 'Confirmed Password',
                    prefixIcon: Icons.lock,
                    controller: confirmedpasswordController,
                    obscureText: true,
                  ),               
                  const SizedBox(height: 60),
                  MyButton(
                    text: 'Create new password',
                    onTap: newPass,
                  ),                
                  const SizedBox(height: 100),
                ],
               ),
              ),
            ),
          ),
        ),
      ) ,
    );
  }
}
