import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class TechSopport extends StatelessWidget {
  const TechSopport({Key? key}) : super(key: key);

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "add_property".tr,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          LimitedBox(
            maxHeight: 200.0,
            maxWidth: 200.0,
            child: Lottie.asset(
              'assets/lottiefiles/121527-tech-support-and-customer-service.json',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 70.h,
          ),
          const Text(
            "نحن هنا من أجلك",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'smith@example.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Example Subject & Symbols are allowed!',
                  }),
                );

                launchUrl(emailLaunchUri);
                // showModalBottomSheet(
                //   backgroundColor: Colors.white.withOpacity(0),
                //   context: context,
                //   builder: (BuildContext context) {
                //     return Container(
                //       decoration: BoxDecoration(
                //           color: Colors.grey[800],
                //           borderRadius: BorderRadius.only(
                //               topLeft: Radius.circular(25),
                //               topRight: Radius.circular(25))),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Center(
                //               child: Container(
                //                 height: 2,
                //                 width: 15,
                //                 decoration: BoxDecoration(
                //                     color: Colors.white30,
                //                     borderRadius: BorderRadius.circular(45)),
                //               ),
                //             ),
                //             const SizedBox(
                //               height: 20,
                //             ),
                //             Text(
                //               "راسلنا من خلال",
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 18,
                //               ),
                //             ),
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Divider(),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 GestureDetector(
                //                   onTap: () {
                //                     final Uri emailLaunchUri = Uri(
                //                       scheme: 'mailto',
                //                       path: 'smith@example.com',
                //                       query: encodeQueryParameters(<String,
                //                           String>{
                //                         'subject':
                //                             'Example Subject & Symbols are allowed!',
                //                       }),
                //                     );

                //                     launchUrl(emailLaunchUri);
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                         padding: const EdgeInsets.all(8.0),
                //                         width: 48,
                //                         height: 48,
                //                         decoration: BoxDecoration(
                //                           shape: BoxShape.circle,
                //                           color: Colors.white,
                //                         ),
                //                         child: SvgPicture.asset(
                //                             'assets/svgs/gmail.svg',
                //                             height: 40.h),
                //                       ),
                //                       const SizedBox(
                //                         height: 10,
                //                       ),
                //                       Text(
                //                         "أرسل إيميل",
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 GestureDetector(
                //                   onTap: () {
                //                     final Uri smsLaunchUri = Uri(
                //                       scheme: 'sms',
                //                       path: '.963930059138',
                //                       queryParameters: <String, String>{
                //                         'body': Uri.encodeComponent(
                //                             'Example Subject & Symbols are allowed!'),
                //                       },
                //                     );
                //                     launchUrl(smsLaunchUri);
                //                   },
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                           padding: const EdgeInsets.all(8.0),
                //                           width: 48,
                //                           height: 48,
                //                           decoration: BoxDecoration(
                //                             shape: BoxShape.circle,
                //                             color: Colors.white,
                //                           ),
                //                           child: SvgPicture.asset(
                //                               'assets/svgs/sms.svg',
                //                               height: 40.h)),
                //                       const SizedBox(
                //                         height: 10,
                //                       ),
                //                       Text(
                //                         "أرسل رسالة",
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(
                //               height: 50,
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              child: Container(
                height: 30.h,
                width: Get.width * .7,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text("اكتب إلينا".tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
