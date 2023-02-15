import 'dart:io';

import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/models/pinned_estate.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/control_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedValue = 0;

  final qrKey = GlobalKey();

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller!.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          borderColor: Colors.white,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        this.barcode = scanData;
        int codeId = int.parse(this.barcode!.code!);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int homeId = prefs.getInt("homepId")!;
        Get.find<PropertyController>().postCode(homeId, codeId);
        Get.find<ControlViewModel>().changeSelectedValue2(selectedValue: 2);
        Get.to(ControlView());
      });
    });
    controller.pauseCamera();
    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan result',
          maxLines: 3,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Qr scan".tr),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 25.h,
            horizontal: MediaQuery.of(context).size.width * .05),
        child: GetBuilder<PropertyController>(builder: (propertycontroller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("الرجاء مسح رمز QR لدى المكتب العقاري "),
              SizedBox(
                height: 20.h,
              ),
              // Text("الرجاء  اختيار مكتب عقاري لربط العقار معه"),
              // ListView(
              //   shrinkWrap: true,
              //   padding: EdgeInsets.symmetric(vertical: 5.h),
              //   children: [
              //     RadioListTile<int>(
              //       value: 0,
              //       groupValue: selectedValue,
              //       title: Text("دفع مباشر"),
              //       onChanged: (value) => setState(() {
              //         selectedValue = 0;
              //       }),
              //     ),
              //     RadioListTile<int>(
              //       value: 1,
              //       groupValue: selectedValue,
              //       title: Text("دفع عند البيع"),
              //       onChanged: (value) => setState(() {
              //         selectedValue = 1;
              //       }),
              //     ),
              //   ],
              // ),
              SizedBox(height: Get.height * .4, child: buildQrView(context)),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "في حال عدم توفر الرمز يمكنك تخطي هذه الخطوة وإكمالها لاحقاً عند التواجد لدى المكتب العقاري.",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "يمكنك الرجوع إلى هذه الواجهة من المزيد>الملف الشخصي.",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(200.w, 0)),
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return AppColor.BlueBtn;
                      }
                      return AppColor.BlueBtn;
                    }),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w)),
                    elevation: MaterialStateProperty.all<double>(0.5),
                  ),
                  onPressed: () async {
                    PinnedPropertyModel pinnedproperty = PinnedPropertyModel(
                        userId:
                            Get.find<AuthViewModel>().userModel!.id!.toString(),
                        propertyId:
                            propertycontroller.home.realEstate!.id.toString(),
                        brokerId: propertycontroller.broker.id!.toString(),
                        brokername: propertycontroller.broker.name!,
                        address:
                            propertycontroller.home.realEstate!.addressTitle!);
                    Get.find<PropertyController>()
                        .insertPinnedProperty(pinnedproperty);
                    Get.find<ControlViewModel>()
                        .changeSelectedValue2(selectedValue: 2);
                    Get.to(ControlView());
                    // controller.postBroker(propertyId);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      'تخطي'.tr,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
