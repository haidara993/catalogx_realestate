import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/phone_screen.dart';
import 'package:catalog/views/sms_screen.dart';
import 'package:catalog/views/widgets/rounded_button.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneLoginScreen extends GetWidget<AuthViewModel> {
  GlobalKey<FormState> _registerformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: Get.height,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              vertical: 5.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 35.h,
                ),
                SvgPicture.asset('assets/images/AcrossMENA _logo.svg',
                    height: 100.h),
                Text(
                  "أهلا بكم في كتالوج",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "املأ تفاصيل حسابك لتسجيل الدخول.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Form(
                  key: _registerformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: IntlPhoneField(
                          initialCountryCode: 'SY',
                          keyboardType: TextInputType.number,
                          countries: ['SY'],
                          validator: (text) {
                            if (text == null || text.number.isEmpty) {
                              return 'emptytextfieldvalidation'.tr;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف ..',
                            hintText: '09********',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          onSaved: (phone) {
                            var phonenum = (phone?.number.substring(1))!;
                            controller.phone = "963" + phonenum;
                            print(controller.phone);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      GetBuilder<AuthViewModel>(builder: (passcontroller) {
                        return TextFormField(
                          obscureText: passcontroller.obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              labelText: "كلمة المرور".tr,
                              hintText: "كلمة المرور".tr,
                              suffixIcon: IconButton(
                                onPressed: () => passcontroller.showPassword(),
                                icon: Icon(
                                  passcontroller.obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                              )),
                          onSaved: (password) {
                            controller.password = password!;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'emptytextfieldvalidation'.tr;
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'اذا لم يكن لديك حساب قم ب ',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'إنشاء واحد من هنا ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue.shade700,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(PhoneScreen());
                                  }),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Flexible(flex: 6, fit: FlexFit.tight, child: Container()),
                Column(
                  children: [
                    SizedBox(height: 30.h),
                    GetBuilder<AuthViewModel>(builder: (authcontroller) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width * .9, 50),
                        ),
                        onPressed: () {
                          if (_registerformKey.currentState!.validate()) {
                            _registerformKey.currentState?.save();
                            // authcontroller.login();
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التالي',
                              // style: TextStyle(
                              //     color: Colors.white, fontSize: 20.sp),
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
                      );
                    }),
                  ],
                ),
                Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
