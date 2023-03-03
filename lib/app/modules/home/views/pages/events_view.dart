import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/firebase_provider.dart';
import '../../controllers/home_controller.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  List<DataRow> eventRows = [];
  @override
  void initState() {
    FirebaseProvider().getEvents().listen(
      (value) {
        eventRows = value
            .map<DataRow2>(
              (e) => DataRow2(
                cells: [
                  DataCell(Image.network('${e.imageLink}')),
                  DataCell(
                    Text(
                      '${e.address}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.buyLink}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.cost}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.date}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.time}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.status}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                    Text(
                      '${e.venue}',
                      style: Theme.of(Get.context!).textTheme.bodySmall,
                    ),
                  ),
                  DataCell(
                      Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ), onTap: () async {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(e.id)
                        .delete();
                  }),
                ],
              ),
            )
            .toList();
        setState(() {});
      },
    );

    super.initState();
  }

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
              rows: eventRows,
              dataRowHeight: 100,
            )),
          ),
        ],
      ),
    );
  }
}
