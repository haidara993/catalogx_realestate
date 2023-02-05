import 'dart:io';

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

class PinnedPaymentPage extends StatefulWidget {
  final String propertyId;
  PinnedPaymentPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<PinnedPaymentPage> createState() => _PinnedPaymentPageState();
}

class _PinnedPaymentPageState extends State<PinnedPaymentPage> {
  int selectedValue = 0;

  final qrKey = GlobalKey();

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
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
        Get.find<PropertyController>()
            .postCode(int.parse(widget.propertyId), codeId);
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
            ],
          );
        }),
      ),
    );
  }
}
