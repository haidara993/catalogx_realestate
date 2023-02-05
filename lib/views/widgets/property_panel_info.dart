import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class PropertyPanelInfo extends StatelessWidget {
  final price, addresstitle, bednum, bathnum, area, totalarea;

  final Future<bool> Function(bool)? onPressed;
  final bool? isliked;
  PropertyPanelInfo(
      {Key? key,
      this.price,
      this.addresstitle,
      this.bednum,
      this.bathnum,
      this.area,
      this.totalarea,
      this.isliked,
      this.onPressed})
      : super(key: key);

  var f = NumberFormat("#,###", "en_US");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  f.format(int.parse(price)),
                  style: TextStyle(
                    fontSize: 21.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: LikeButton(
                    onTap: onPressed,
                    isLiked: isliked,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked ? Icons.star : Icons.star_border_outlined,
                        color: isLiked ? Colors.yellow[700] : Colors.black,
                        size: 35,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(addresstitle, style: const TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.hotel),
                        Text("  " + bednum + " " + 'bed_room'.tr),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.bathtub),
                        Text("  " + bathnum + " " + 'bath_room'.tr),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.house),
                        Text("  " + area + " " + 'meter'.tr),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.zoom_out_map),
                        Text("  " +
                            totalarea +
                            " " +
                            'meter'.tr +
                            " " +
                            'overal'.tr),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
