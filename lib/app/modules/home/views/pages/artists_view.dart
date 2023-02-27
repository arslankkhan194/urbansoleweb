import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class ArtistsView extends StatelessWidget {
  const ArtistsView({Key? key}) : super(key: key);

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
                "Artists",
                style: Theme.of(context).textTheme.headline3,
              ),
              ElevatedButton(
                  onPressed: () {
                    controller.showAddArtistDialog(context);
                  },
                  child: Text("Add Artist"))
            ],
          ),
          Expanded(
            child: Card(
                child: DataTable2(
              columns: controller.artistColumns,
              rows: controller.artistRows,
              dataRowHeight: 100,
            )),
          ),
        ],
      ),
    );
  }
}
