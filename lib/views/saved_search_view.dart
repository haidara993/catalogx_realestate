import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/saved_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class SavedSearchView extends GetWidget<SavedSearchViewModel> {
  SavedSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.delete<SavedSearchViewModel>();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("عمليات البحث المحفوظة"),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<SavedSearchViewModel>(builder: (context) {
            return controller.savedSearchs.isEmpty
                ? const Center(
                    child: Text("لا يوجد لديك أية عمليات بحث محفوظة"))
                : LiquidPullToRefresh(
                    onRefresh: () async {
                      controller.getAllSavedSearchs();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.savedSearchs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : AppColor.GreyIcons,
                                width: 1.0,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            onTap: () {
                              var savedController =
                                  Get.put(SavedSearchViewModel());
                              savedController.filterProperty(
                                  controller.savedSearchs[index].stateId,
                                  controller.savedSearchs[index].typeId,
                                  controller.savedSearchs[index].categoryId,
                                  controller.savedSearchs[index].natureId,
                                  controller.savedSearchs[index].propreId,
                                  controller.savedSearchs[index].licenseId,
                                  controller.savedSearchs[index].minarea,
                                  controller.savedSearchs[index].maxarea,
                                  controller.savedSearchs[index].minprice,
                                  controller.savedSearchs[index].maxprice,
                                  controller.savedSearchs[index].bedroomNum,
                                  controller.savedSearchs[index].bathroomNum,
                                  controller.savedSearchs[index].floorHeight,
                                  controller.savedSearchs[index].waterwell,
                                  controller.savedSearchs[index].chimney,
                                  controller.savedSearchs[index].pool,
                                  controller.savedSearchs[index].elevator,
                                  controller.savedSearchs[index].altenergy,
                                  controller.savedSearchs[index].rocks,
                                  controller.savedSearchs[index].stairs,
                                  controller.savedSearchs[index].waterwell,
                                  controller.savedSearchs[index].hanger,
                                  controller.savedSearchs[index].lat1,
                                  controller.savedSearchs[index].long1,
                                  controller.savedSearchs[index].lat2,
                                  controller.savedSearchs[index].long2);
                              Get.to(SavedSearchResult(
                                initlat: double.parse(
                                    controller.savedSearchs[index].initlat),
                                initlong: double.parse(
                                    controller.savedSearchs[index].initlong),
                                initzoom: double.parse(
                                    controller.savedSearchs[index].zoom),
                              ));
                            },
                            title: Text(
                              controller.savedSearchs[index].searchName,
                            ),
                            leading: Icon(Icons.map),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () {
                                  controller.deleteSearch(
                                      controller.savedSearchs[index].saveid);
                                }),
                          ),
                        );
                      },
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
