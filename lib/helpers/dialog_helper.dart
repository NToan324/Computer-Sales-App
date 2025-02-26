import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  //dialog
  static void showDialog(
      {String title = 'Error', String description = 'something went wrong'}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              Text(description),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }
  //toastify
  //snackbar
  //bottomsheet
  //loading
}
