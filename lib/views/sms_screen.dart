import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SmsScreen extends StatelessWidget {
  SmsScreen({Key? key}) : super(key: key);
  GlobalKey<FormState> _smsformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: GetBuilder<AuthViewModel>(builder: (authcontroller) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                    SvgPicture.asset('assets/images/AcrossMENA _logo.svg',
                        height: 100.h),
                    Text(
                      "تأكيد التسجيل",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "لقد قمنا بأرسال رسالة تتضمن رمز التأكيد على الرقم الذي قمت ب ادخاله",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      children: [
                        Form(
                          key: _smsformKey,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: authcontroller.smsCodeController,
                            autocorrect: false,
                            autofocus: false,
                            decoration: const InputDecoration(
                              hintText: '*****',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 25.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            onSaved: (code) {
                              authcontroller.code = code!;
                            },
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'emptytextfieldvalidation'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            authcontroller.resendcode();
                          },
                          child: const Text(
                            ' اعادة ارسال رمز التأكيد',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 180.h,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 30.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(Get.width * .9, 50),
                          ),
                          onPressed: () {
                            if (_smsformKey.currentState!.validate()) {
                              _smsformKey.currentState?.save();
                              authcontroller.checkMessageCode();
                            }
                            // AuthService().signInWithOTP(
                            //     context, _smsController.text, widget.verificationId);
                          },
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'التالي',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.sp),
                                ),
                                authcontroller.loading.value
                                    ? const SizedBox(
                                        width: 25,
                                      )
                                    : const Text(""),
                                authcontroller.loading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("")
                                // Icon(Icons.arrow_circle_left_outlined,
                                //     color:  AppColor.GreyIcons),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
