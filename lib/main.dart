import 'dart:ui';

import 'package:computer_sales_app/controllers/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';

void main() {
  return runApp(GetMaterialApp(
    home: ApiApp(),
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
        title: Text('API App'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
          onPressed: () async {
            //Call the API
            apiController.getApiData();
          },
          child: Text(
            'Get API',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
