import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/phone_login_screen.dart';
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

class PhoneScreen extends GetWidget<AuthViewModel> {
  GlobalKey<FormState> _registerformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
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
                    "املأ التفاصيل لإنشاء الحساب.",
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
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "اسم المستخدم".tr,
                              hintText: "اسم المستخدم".tr),
                          onSaved: (name) {
                            controller.name = name!;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'emptytextfieldvalidation'.tr;
                            }
                            return null;
                          },
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
                                  onPressed: () =>
                                      passcontroller.showPassword(),
                                  icon: Icon(
                                    passcontroller.obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
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

                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: IntlPhoneField(
                            initialCountryCode: 'SY',
                            keyboardType: TextInputType.number,
                            countries: ['SY'],
                            showDropdownIcon: false,
                            flagsButtonMargin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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

                        // TextFormField(
                        //   decoration: InputDecoration(
                        //     labelText: "رقم الجوال".tr,
                        //     hintText: "رقم الجوال : +963".tr,
                        //   ),
                        //   onSaved: (phone) {
                        //     controller.phone = phone!;
                        //   },
                        //   validator: (text) {
                        //     if (text == null || text.isEmpty) {
                        //       return 'emptytextfieldvalidation'.tr;
                        //     }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(
                          height: 15.h,
                        ),
                        // Text(
                        //   "العنوان أو اسم المدينة".tr,
                        //   style: TextStyle(
                        //       fontSize: 17.sp, fontWeight: FontWeight.bold),
                        // ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "العنوان أو اسم المدينة".tr,
                              hintText: "العنوان أو اسم المدينة".tr),
                          onSaved: (city) {
                            controller.city = city!;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'emptytextfieldvalidation'.tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'أو قم ',
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'بتسجيل الدخول ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      controller.isRegistered.value = false;
                                      Get.to(PhoneLoginScreen());
                                    }),
                              TextSpan(
                                text: 'اذا كان لديك حسابك مسبقاً ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return controller.isRegistered.value == false
                        ? const SizedBox(
                            height: 1,
                          )
                        : const Text(
                            "هذا الحساب موجود مسبقا يمكنك تسجيل الدخول.",
                            style: TextStyle(color: Colors.red),
                          );
                  }),
                  SizedBox(
                    height: 40.h,
                  ),
                  GetBuilder<AuthViewModel>(
                    builder: (controller) => CheckboxListTile(
                      title: Text.rich(
                        TextSpan(
                            text: ' الرجاء الموافقة على ',
                            style: TextStyle(fontSize: 14.sp),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'شروط الخدمة ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // code to open / launch terms of service link here
                                    }),
                              TextSpan(
                                  text: ' و',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'سياسة الخصوصية',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.blue.shade700,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {}),
                                    TextSpan(
                                      text: ' لإكمال التسجيل. ',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ]),
                            ]),
                      ),
                      value: controller.checkedValue,
                      onChanged: (newValue) {
                        controller.oncheckedValueChanged(newValue!);
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
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
                              authcontroller.register();
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
