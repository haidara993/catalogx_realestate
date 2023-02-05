import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}) {
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _builtBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: color,
        width: 1.0,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        constraints: BoxConstraints(maxWidth: Get.width * .9),
        enabledBorder: _builtBorder(Colors.grey[600]!),
        errorBorder: _builtBorder(Colors.red),
        focusedBorder: _builtBorder(Colors.blue),
        focusedErrorBorder: _builtBorder(Colors.deepPurple),
        disabledBorder: _builtBorder(Colors.grey[400]!),
        suffixStyle: _builtTextStyle(Colors.black),
        counterStyle: _builtTextStyle(Colors.grey, size: 12.0),
        floatingLabelStyle: _builtTextStyle(Colors.black),
        errorStyle: _builtTextStyle(Colors.red, size: 12.0),
        helperStyle: _builtTextStyle(Colors.black),
        hintStyle: _builtTextStyle(Colors.grey),
        labelStyle: _builtTextStyle(Colors.black),
        prefixStyle: _builtTextStyle(Colors.black),
      );
}
