import 'package:catalog/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddPropertyFour extends StatelessWidget {
  const AddPropertyFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Kuhli,
        title: Text("add_property".tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 25.h,
              horizontal: MediaQuery.of(context).size.width * .05),
          child: Column(),
        ),
      ),
    );
  }
}
