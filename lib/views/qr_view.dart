import 'dart:io';

import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/views/property_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrSearchView extends StatefulWidget {
  QrSearchView({Key? key}) : super(key: key);

  @override
  State<QrSearchView> createState() => _QrSearchViewState();
}

class _QrSearchViewState extends State<QrSearchView> {
  final qrKey = GlobalKey();

  Barcode? barcode;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    var searchController = Get.put(SearchViewModel());
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.find<ControlViewModel>().changeSelectedValue2(selectedValue: 2);
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(bottom: 10, child: buildResult()),
          ],
        ),
      ),
    );
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

  // void onQRViewCreated(QRViewController p1) {
  //   setState(() {
  //     this.controller = p1;
  //   });

  //   controller?.scannedDataStream.listen((event) {
  //     setState(() {
  //       this.barcode = event;
  //     });
  //   });
  // }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        barcode = scanData;
        var numcode = barcode!.code!.substring(
            barcode!.code!.lastIndexOf('/') + 1, barcode!.code!.length);
        int propertyId = int.parse(numcode);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("homeId", propertyId);
        Get.to(PropertyInfo());
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
}
