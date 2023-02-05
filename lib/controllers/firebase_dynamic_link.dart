// import 'package:catalogx/controllers/control_viewmodel.dart';
// import 'package:catalogx/views/property_info.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FirebaseDynamicLinkService {
//   static Future<String> createDynamicLink(bool short, int propertyId) async {
//     String _linkMessage;

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://acrossmena.page.link',
//       link: Uri.parse(
//           'https://www.haidaracatalogy.com/propertyById?id=$propertyId'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.acrossmena.catalog',
//         minimumVersion: 1,
//       ),
//     );

//     // Uri url;
//     // if (short) {
//     //   final ShortDynamicLink shortLink = await parameters.buildShortLink();
//     //   url = shortLink.shortUrl;
//     // } else {
//     //   url = await parameters.buildUrl();
//     // }

//     final dynamicLink =
//         await FirebaseDynamicLinks.instance.buildLink(parameters);
//     final ShortDynamicLink shortLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(parameters);

//     _linkMessage = dynamicLink.toString();
//     var url = shortLink.shortUrl.toString();
//     return url;
//   }

//   static Future<void> initDynamicLink() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       print("listenning to dynamic link");
//       final Uri deepLink = dynamicLinkData.link;

//       var isProperty = deepLink.pathSegments.contains('propertyById');

//       if (isProperty) {
//         String id = deepLink.queryParameters['id']!;
//         int propertyId = int.parse(id);
//         print(propertyId);
//         prefs.setInt("homeId", propertyId);

//         Get.to(PropertyInfo(), duration: Duration(milliseconds: 900));
//       }
//     }).onError((error) {
//       // Handle errors
//     });

//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     try {
//       final Uri deepLink = (data?.link)!;
//       var isProperty = deepLink.pathSegments.contains('propertyById');
//       if (isProperty) {
//         String id = deepLink.queryParameters['id']!;
//         int propertyId = int.parse(id);
//         // TODO :Modify Accordingly
//         prefs.setInt("homeId", propertyId);
//         if (deepLink != null) {
//           // TODO : Navigate to your pages accordingly here
//           Get.to(PropertyInfo());
//         } else {
//           return null;
//         }
//       }
//     } catch (e) {
//       print('No deepLink found');
//     }
//   }
// }
