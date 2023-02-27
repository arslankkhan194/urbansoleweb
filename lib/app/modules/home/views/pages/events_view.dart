import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

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
                "Events",
                style: Theme.of(context).textTheme.headline3,
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.showAddEventDialog(context);
                  },
                  child: Text("Add Events"))
            ],
          ),
          Expanded(
            child: Card(
                child: DataTable2(
                  columns: controller.eventColumns,
                  rows: controller.eventRows,
                  dataRowHeight: 100,
                )),
          ),
        ],
      ),
    );
  }
}
