import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/views/control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectModeView extends GetWidget<AuthViewModel> {
  const SelectModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthViewModel>(builder: (controller) {
        return Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    // controller.changeSelectedValue(2);
                    controller.setMode(1);
                    Get.off(ControlView());
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 17.0),
                    elevation: 3.0,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    )),
                    child: SizedBox(
                        height: 350,
                        width: Get.width * .45,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(children: [
                            Image.asset('assets/images/clasic_mode.png',
                                fit: BoxFit.fill),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: Text(
                                "Clasic Mode",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ]),
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // controller.changeSelectedValue(0);
                    controller.setMode(2);
                    Get.off(ControlView());
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 17.0),
                    elevation: 3.0,
                    clipBehavior: Clip.antiAlias,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    )),
                    child: SizedBox(
                        height: 350,
                        width: Get.width * .45,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(children: [
                            Image.asset('assets/images/catalog_mode.png',
                                fit: BoxFit.fill),
                            Expanded(
                              child: Container(),
                            ),
                            Center(
                              child: Text(
                                "Catalog Mode",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ]),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
