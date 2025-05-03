import 'package:computer_sales_app/components/custom/myTextField.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/utils/widget/CustomAppBarMobile.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/otp_input.dart';
import 'package:computer_sales_app/views/pages/client/profile/widgets/listTile_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountView();
}

class _MyAccountView extends State<MyAccountView> {
  List<Map<String, dynamic>> myAccountItems = [
    {'title': 'Personal Information', 'icon': CupertinoIcons.person},
    {'title': 'Change Password', 'icon': CupertinoIcons.lock},
    {'title': 'Address', 'icon': CupertinoIcons.location_north},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => listTileCustom(
        myAccountItems[index]['icon'],
        myAccountItems[index]['title'],
        onTap: () {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonelInformation(),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(),
              ),
            );
          }
        },
      ),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        height: 0,
      ),
      itemCount: myAccountItems.length,
    );
  }
}

//Personal Information
class PersonelInformation extends StatefulWidget {
  const PersonelInformation({super.key});

  @override
  State<PersonelInformation> createState() => _PersonelInformationState();
}

class _PersonelInformationState extends State<PersonelInformation> {
  final bool _loading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarMobile(
        title: 'Personal Information',
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(8),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 73, 73, 73),
                        ),
                        shape: WidgetStateProperty.all(
                          const CircleBorder(),
                        ),
                      ),
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'Seibon',
                    prefixIcon: CupertinoIcons.person,
                    controller: _fullNameController,
                    focusNode: _fullNameFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: '0357378876',
                    prefixIcon: CupertinoIcons.phone,
                    controller: _phoneNumberController,
                    focusNode: _phoneNumberFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'example@gmail.com',
                    prefixIcon: CupertinoIcons.envelope,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  MyTextField(
                    hintText: 'District 1, HCM City',
                    prefixIcon: CupertinoIcons.location,
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    obscureText: false,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              MyButton(
                text: 'Change Information',
                isLoading: _loading,
                onTap: (_) => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Change Password
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarMobile(
        title: 'Change Password',
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Container(
          padding: !Responsive.isMobile(context)
              ? EdgeInsets.only(top: 16, left: 64, right: 64)
              : EdgeInsets.only(top: 16, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Text(
                        'Enter your verification code!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Please enter the code sent to your email address.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 20,
                  children: [
                    Flexible(
                        child: OtpInput(
                            controller: otp1Controller, autoFocus: true)),
                    Flexible(child: OtpInput(controller: otp2Controller)),
                    Flexible(child: OtpInput(controller: otp3Controller)),
                    Flexible(child: OtpInput(controller: otp4Controller)),
                  ],
                ),
                MyButton(
                  text: 'Get code',
                  isLoading: false,
                  onTap: (_) => {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
