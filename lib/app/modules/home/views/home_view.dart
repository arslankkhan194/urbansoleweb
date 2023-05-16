import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 15,
              child: sideNav(context),
            ),
            Expanded(flex: 85, child: page())
          ],
        ),
      ),
    );
  }

  sideNav(context) {
    return Container(
      color: AppColors.blackForeground,
      child: Column(
        children: [
          Container(width: MediaQuery.of(context).size.width * .15, color: Colors.black, height: 100, child: logo()),
          Divider(),
          Obx(() => navItems()),
        ],
      ),
    );
  }

  logo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Image.asset('assets/logo.jpeg'),
    );
  }

  navItems() {
    print("navItems called");
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          children: [
            ListTile(
              title: Text("Sharesound"),
              onTap: () {
                controller.selectedPageIndex.value = 0;
              },
              selected: controller.selectedPageIndex.value == 0,
            ),
            ListTile(
              title: Text("Artists"),
              onTap: () {
                controller.selectedPageIndex.value = 1;
              },
              selected: controller.selectedPageIndex.value == 1,
            ),
            ListTile(
              title: Text("Events"),
              onTap: () {
                controller.selectedPageIndex.value = 2;
              },
              selected: controller.selectedPageIndex.value == 2,
            ),
            ListTile(
              title: Text("Setting"),
              onTap: () {
                controller.selectedPageIndex.value = 3;
              },
              selected: controller.selectedPageIndex.value == 3,
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                controller.selectedPageIndex.value = 4;
              },
              tileColor: controller.selectedPageIndex.value == 4 ? Colors.white54 : null,
            )
          ],
        ),
      ),
    );
  }

  page() {
    return Obx(() => controller.isLoading.value
        ? Center(
            child: CircularProgressIndicator(),
          )
        : controller.pages[controller.selectedPageIndex.value]);
  }
}
