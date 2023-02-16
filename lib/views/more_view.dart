import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/broker_controller.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/themes/theme_controller.dart';
import 'package:catalog/themes/themes.dart';
import 'package:catalog/translations/translation_controller.dart';
import 'package:catalog/views/brokers_page.dart';
import 'package:catalog/views/saved_search_view.dart';
import 'package:catalog/views/tech_sopport.dart';
import 'package:catalog/views/user_info.dart';
import 'package:catalog/views/widgets/more_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreView extends StatefulWidget {
  MoreView({Key? key}) : super(key: key);

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> with TickerProviderStateMixin {
  final langController = Get.put(TranslationController());
  AnimationController? _animationController;
  int? _animationMiddleFrame;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationMiddleFrame =
        (_animationController?.duration?.inMilliseconds)! ~/ 2;
    _animationController?.stop();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("more".tr),
        actions: [],
      ),
      body: ListView(
        children: [
          MoreItemView(
              name: "الملف الشخصي".tr,
              moreicon: Icons.person,
              onPressed: () {
                Get.find<AuthViewModel>().getUserInfo(
                    Get.find<AuthViewModel>().userModel!.id!.toString());
                Get.to(UserInfo());
              }),
          MoreItemView(
              name: "saved_search".tr,
              moreicon: Icons.history,
              onPressed: () {
                var savedController = Get.put(SavedSearchViewModel());
                Get.to(() => SavedSearchView());
              }),
          MoreItemView(
            name: "find_broker".tr,
            moreicon: Icons.person,
            onPressed: () {
              var brokercon = Get.put(BrokerController());
              Get.to(BrokersPage());
            },
          ),
          // MoreItemView(name: "languague".tr, moreicon: Icons.language),
          // MoreItemView(
          //   name: "الثيم".tr,
          //   moreicon: Icons.image,
          //   onPressed: () {
          //     if (Get.isDarkMode) {
          //       Get.find<ThemeController>().changeTheme(Themes.lightTheme);
          //       Get.find<ThemeController>().saveTheme(false);
          //       _animationController?.reverse();
          //     } else {
          //       Get.find<ThemeController>().changeTheme(Themes.darkTheme);
          //       Get.find<ThemeController>().saveTheme(true);
          //       _animationController?.animateTo(0.5);
          //     }
          //   },
          //   themeanim: LimitedBox(
          //     maxHeight: 70.0,
          //     maxWidth: 70.0,
          //     child: Lottie.asset(
          //       'assets/lottiefiles/day-night.json',
          //       controller: _animationController,
          //       repeat: false,
          //       height: double.infinity,
          //       width: double.infinity,
          //       fit: BoxFit.cover,
          //       onLoaded: (composition) {
          //         _animationController?.duration = composition.duration;
          //         _animationMiddleFrame =
          //             (_animationController?.duration?.inMilliseconds)! ~/ 2;
          //       },
          //     ),
          //   ),
          // ),
          MoreItemView(
              name: "tech_support".tr,
              moreicon: Icons.headset_mic,
              onPressed: () => Get.to(TechSopport())),
          // MoreItemView(name: "send_feed".tr, moreicon: Icons.message_rounded),
          MoreItemView(name: "privecy_policy".tr, moreicon: Icons.lock),
          MoreItemView(
            name: "log_out".tr,
            moreicon: Icons.logout,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("token");
              prefs.remove("active");
              Get.find<AuthViewModel>().isLogged.value = false;
              Get.find<ControlViewModel>()
                  .changeSelectedValue2(selectedValue: 2);
            },
          ),
          // MoreItemView(name: "tech_support".tr, moreicon: Icons.headset_mic),
        ],
      ),
    );
  }
}
