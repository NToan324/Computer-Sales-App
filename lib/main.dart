import 'package:computer_sales_app/controllers/api_controller.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'views/pages/login/login_view.dart';

void main() async {
  // await dotenv.load(fileName: '.env');
  return runApp(GetMaterialApp(
    home: LoginView(),
    debugShowCheckedModeBanner: false,
  ));
}

class ApiApp extends StatefulWidget {
  const ApiApp({super.key});

  @override
  State<ApiApp> createState() => _ApiAppState();
}

class _ApiAppState extends State<ApiApp> {
  var apiController = APIController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Responsive.isMobile(context)
            ? dotenv.env['API_URL']!
            : 'Hello World'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () async {
            //Call the API
            apiController.getApiData();
          },
          child: const Text(
            'Get API',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
