import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class CollabView extends StatelessWidget {
  const CollabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sharesound",
                style: Theme.of(context).textTheme.headline3,
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.showUpdatAnnouncementDialog(context);
                  },
                  child: Text("Update Announcement"))
            ],
          ),
          Expanded(
            child: Card(
                child: DataTable2(
              columns: controller.collabColumns,
              rows: controller.collabRows,
              dataRowHeight: 200,
            )),
          ),
        ],
      ),
    );
  }
}
