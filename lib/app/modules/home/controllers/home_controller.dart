import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_sound_art_admin/app/data/firebase_provider.dart';
import 'package:urban_sound_art_admin/app/models/ArtistModel.dart';
import 'package:urban_sound_art_admin/app/modules/home/views/pages/artists_view.dart';
import 'package:urban_sound_art_admin/app/modules/home/views/pages/collab_view.dart';
import 'package:urban_sound_art_admin/app/modules/home/views/pages/events_view.dart';
import 'package:urban_sound_art_admin/app/modules/home/views/pages/settings_view.dart';
import 'package:urban_sound_art_admin/app/modules/home/views/widgets/player_widget.dart';

import '../../../models/EventsModel.dart';
import '../../../utils/colors.dart';

class HomeController extends GetxController {
  FirebaseProvider _provider = FirebaseProvider();
  final selectedPageIndex = 0.obs;
  final isLoading = false.obs;
  final artistFormKey = GlobalKey<FormState>();
  TextEditingController artistPreviousIamgeCotroelelr = TextEditingController();
  TextEditingController artistNameController = TextEditingController();
  TextEditingController artistAddressController = TextEditingController();
  TextEditingController artistBioController = TextEditingController();
  TextEditingController artistDescriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  //event
  final eventFormKey = GlobalKey<FormState>();
  TextEditingController eventImageController = TextEditingController();
  TextEditingController eventBuyLinkController = TextEditingController();
  TextEditingController eventTittleController = TextEditingController();
  TextEditingController eventAddressController = TextEditingController();
  TextEditingController eventCostController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  TextEditingController eventStatusController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();

  TextEditingController announcementController = TextEditingController();

  XFile? pickedImage;
  List<Widget> pages = [CollabView(), ArtistsView(), EventsView(), SettingsView()];

  List<DataRow2> artistRows = [];
  List<DataColumn2> artistColumns = [
    DataColumn2(label: Text(""), fixedWidth: 100),
    DataColumn2(
        label: Text(
          "Artist Name",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 140),
    DataColumn2(
        label: Text(
          "Origin",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 140),
    DataColumn2(
        label: Text(
          "Bio",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 140),
    DataColumn2(
        label: Text(
          "Date & Time",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 130),
    DataColumn2(
        label: Text(
      "Performance Link",
      style: Theme.of(Get.context!).textTheme.titleMedium,
    )),
    DataColumn2(
        fixedWidth: 80,
        label: Text(
          "Action",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        )),
  ];

  List<DataRow2> eventRows = [];
  List<DataColumn2> eventColumns = [
    DataColumn2(label: Text(""), fixedWidth: 100),
    DataColumn2(
        label: Text(
          "Title",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 200),
    DataColumn2(
        label: Text(
          "Address",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 200),
    DataColumn2(
        label: Text(
          "Buy Link",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 200),
    DataColumn2(
        label: Text(
          "Cost",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 100),
    DataColumn2(
        label: Text(
          "Date",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 120),
    DataColumn2(
        label: Text(
          "Time",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 120),
    DataColumn2(label: Text("Status", style: Theme.of(Get.context!).textTheme.titleMedium), fixedWidth: 150),
    DataColumn2(label: Text("Venue", style: Theme.of(Get.context!).textTheme.titleMedium)),
    DataColumn2(
        fixedWidth: 100,
        label: Text(
          "Action",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        )),
  ];

  List<DataRow2> collabRows = [];
  List<DataColumn2> collabColumns = [
    // DataColumn2(label: Text(""), fixedWidth: 100),
    DataColumn2(
        label: Text(
          "File Name",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 240),
    DataColumn2(
        label: Text(
          "Duration",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 140),
    DataColumn2(
        label: Text(
          "Date & Time",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 250),
    DataColumn2(
        label: Text(
      "Status",
      style: Theme.of(Get.context!).textTheme.titleMedium,
    )),
    DataColumn2(
        label: Text(
      "Action",
      style: Theme.of(Get.context!).textTheme.titleMedium,
    )),
  ];
  @override
  void onInit() async {
    super.onInit();
    dateController.text = '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
    timeController.text = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';
    loadArtists();

    loadCollab();
    loadAnnouncement();
  }

  loadAnnouncement() async {
    await _provider.getAnnouncement().then((value) => announcementController.text = value);
  }

  loadArtists() async {
    isLoading.value = true;
    await _provider.getArtists().then(
          (value) => artistRows = value
              .map<DataRow2>(
                (e) => DataRow2(
                  cells: [
                    DataCell(Image.network('${e.imageLink}')),
                    DataCell(
                      Text(
                        '${e.name}',
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${e.address}',
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${e.bio ?? ''}',
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
                        '${e.description}',
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              artistPreviousIamgeCotroelelr.text = e.imageLink ?? '';
                              artistNameController.text = e.name ?? '';
                              artistAddressController.text = e.address ?? '';
                              artistBioController.text = e.bio ?? '';
                              artistDescriptionController.text = e.description ?? '';
                              dateController.text = e.date ?? '';
                              showAddArtistDialog(navigator!.context, true, e.id);
                            },
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance.collection('artists').doc(e.id).delete();
                              loadArtists();
                            },
                            child: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        );
    isLoading.value = false;
  }

  loadCollab() async {
    isLoading.value = true;
    await _provider.getCollab().then(
          (value) => collabRows = value
              .map<DataRow2>(
                (e) => DataRow2(
                  cells: [
                    DataCell(
                        /* Text(
                        '${e.fileLink}',
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),*/
                        //PlayerWidget( url: 'https://firebasestorage.googleapis.com/v0/b/codelab-assets.appspot.com/o/firebase-song.mp3?alt=media&token=44d4fc4f-20f6-40e0-998b-f9cf033a7d07', color: Colors.white,)
                        PlayerWidget(
                      url: '${e.fileLink}',
                      color: Colors.white,
                    )
                        //   FullAudioPlayer(autoPlay: false, playlist: ConcatenatingAudioSource(children:[AudioSource.uri(Uri.parse(e.fileLink!),tag: MediaItem(
                        //       id: '1', artUri: Uri.parse('https://picsum.photos/300/300'), title: 'Audio Title ', album: 'amazing album'))]))
                        ),
                    DataCell(
                      Text(
                        '${e.duration}',
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    ),
                    DataCell(
                      Text(
                        '${e.createdOn?.toDate().toString()}',
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
                      e.status == "PENDING"
                          ? Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      e.status = "APPROVED";
                                      _provider.updateCollab(e).then((value) => loadCollab());
                                    },
                                    child: Text(
                                      'Approve',
                                      style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green, fontSize: 12),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      print("collab we are in reject");
                                      FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).update({
                                        "status": "REJECTED",
                                      }).then((value) {
                                        print("Coloab is here");
                                        loadCollab();
                                      }).catchError((onError) {
                                        print("collab $onError");
                                      });
                                    },
                                    child: Text(
                                      'Reject',
                                      style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: 12),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).delete().then((value) {
                                      print("Coloab is here");
                                      loadCollab();
                                    }).catchError((onError) {
                                      print("collab $onError");
                                    });
                                  },
                                ),
                              ],
                            )
                          : e.status == "REJECTED"
                              ? Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          // e.status = "APPROVED";
                                          // _provider.updateCollab(e).then((value) => loadCollab());
                                        },
                                        child: Text(
                                          'Rejected',
                                          style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green, fontSize: 12),
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          print("collab we are in reject");
                                          FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).update({
                                            "status": "PENDING",
                                          }).then((value) {
                                            print("Coloab is here");
                                            loadCollab();
                                          }).catchError((onError) {
                                            print("collab $onError");
                                          });
                                        },
                                        child: Text(
                                          'Reset',
                                          style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: 12),
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).delete().then((value) {
                                          print("Coloab is here");
                                          loadCollab();
                                        }).catchError((onError) {
                                          print("collab $onError");
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : e.status == "APPROVED"
                                  ? Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              // e.status = "APPROVED";
                                              // _provider.updateCollab(e).then((value) => loadCollab());
                                            },
                                            child: Text(
                                              'Approved',
                                              style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green, fontSize: 12),
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              print("collab we are in reject");
                                              FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).update({
                                                "status": "PENDING",
                                              }).then((value) {
                                                print("Coloab is here");
                                                loadCollab();
                                              }).catchError((onError) {
                                                print("collab $onError");
                                              });
                                            },
                                            child: Text(
                                              'Reset',
                                              style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: 12),
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            FirebaseFirestore.instance.collection("collab").doc(e.id.toString()).delete().then((value) {
                                              print("Coloab is here");
                                              loadCollab();
                                            }).catchError((onError) {
                                              print("collab $onError");
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : Container(),
                    ),
                  ],
                ),
              )
              .toList(),
        );
    isLoading.value = false;
  }

  showUpdatAnnouncementDialog(context) {
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Announcement",
            style: Theme.of(context).textTheme.headline6?.copyWith(color: AppColors.primary),
          ),
          SizedBox(
            height: 10,
          ),
          IconButton(
              onPressed: () {
                yyDialog?.dismiss();
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ))
        ],
      ),
    );

    Widget _body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        maxLines: 3,
        controller: announcementController,
        decoration: InputDecoration(labelText: "Announcement"),
        validator: (value) => value!.isEmpty ? "Announcement should not be empty" : null,
      ),
    );

    Widget _actions = Container(
      padding: EdgeInsets.only(top: 50, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              yyDialog?.dismiss();
            },
            child: Text("Cancel"),
          ),
          SizedBox(
            width: sizedBoxSize,
          ),
          ElevatedButton(
            onPressed: () async {
              if (announcementController.text.isNotEmpty) {
                _provider.updateAnnouncement(announcementController.text);
                yyDialog?.dismiss();
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
    yyDialog = YYDialog().build(Get.context!)
      ..width = 400
      ..borderRadius = 10
      ..backgroundColor = Colors.grey.shade800
      ..widget(_header)
      ..widget(_body)
      ..widget(_actions).show();
  }

  showAddArtistDialog(context, [update, id]) {
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Artist",
            style: Theme.of(context).textTheme.headline6?.copyWith(color: AppColors.primary),
          ),
          SizedBox(
            height: 10,
          ),
          IconButton(
              onPressed: () {
                yyDialog?.dismiss();
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ))
        ],
      ),
    );
    Widget _body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: artistFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: artistNameController,
              decoration: InputDecoration(labelText: "Artist Name"),
              validator: (value) => value!.isEmpty ? "Please enter Artist Name" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: artistAddressController,
              decoration: InputDecoration(labelText: "Address/Venue/Origin"),
              validator: (value) => value!.isEmpty ? "Address/Venue/Origin should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: artistBioController,
              decoration: InputDecoration(labelText: "Bio"),
              validator: (value) => value!.isEmpty ? "Bio should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            Row(
              children: [
                Flexible(
                  flex: 60,
                  child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 365),
                        ),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.black26,
                              colorScheme: ColorScheme.light(primary: Colors.black26, secondary: Colors.black26),
                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null ? dateController.text = '${value.month}/${value.day}/${value.year}' : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}');
                    },
                    controller: dateController,
                    decoration: InputDecoration(labelText: "Date"),
                  ),
                ),
                SizedBox(
                  width: sizedBoxSize,
                ),
                Flexible(
                  flex: 40,
                  child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.black26,
                              colorScheme: ColorScheme.light(primary: Colors.black26, secondary: Colors.black26),
                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null ? timeController.text = '${value.hour}:${value.minute}' : '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}');
                    },
                    controller: timeController,
                    decoration: InputDecoration(labelText: "Time"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: artistDescriptionController,
              decoration: InputDecoration(labelText: "Performance Link"),
              validator: (value) => value!.isEmpty ? "Description should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            Container(
                width: 200,
                height: 80,
                child: ElevatedButton(
                    onPressed: () {
                      chooseImage().then((value) => pickedImage = value);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Icon(Icons.image), Text("Pick Image")],
                    )))
          ],
        ),
      ),
    );

    Widget _actions = Container(
      padding: EdgeInsets.only(top: 50, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              yyDialog?.dismiss();
            },
            child: Text("Cancel"),
          ),
          SizedBox(
            width: sizedBoxSize,
          ),
          ElevatedButton(
            onPressed: () async {
              if (update ?? false) {
                await updateArtist(id);
                yyDialog?.dismiss();
                return;
              }
              if (artistFormKey.currentState!.validate()) {
                addArtist();
                yyDialog?.dismiss();
              }
            },
            child: Text(update ?? false ? "Update" : "Add"),
          ),
        ],
      ),
    );
    yyDialog = YYDialog().build(Get.context!)
      ..width = 400
      ..borderRadius = 10
      ..backgroundColor = Colors.grey.shade800
      ..widget(_header)
      ..widget(_body)
      ..widget(_actions).show();
  }

  showAddEventDialog(context, [update, id]) {
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Event",
            style: Theme.of(context).textTheme.headline6?.copyWith(color: AppColors.primary),
          ),
          SizedBox(
            height: 10,
          ),
          IconButton(
              onPressed: () {
                yyDialog?.dismiss();
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12,
                ),
              ))
        ],
      ),
    );
    Widget _body = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: eventFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: eventTittleController,
              decoration: InputDecoration(labelText: "Title"),
              validator: (value) => value!.isEmpty ? "Please enter Title" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventAddressController,
              decoration: InputDecoration(labelText: "Address"),
              validator: (value) => value!.isEmpty ? "Please enter Address" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventBuyLinkController,
              decoration: InputDecoration(labelText: "Buy Link"),
              validator: (value) => value!.isEmpty ? "Buy Link should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventCostController,
              decoration: InputDecoration(labelText: "Cost"),
              validator: (value) => value!.isEmpty ? "Cost should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            Row(
              children: [
                Flexible(
                  flex: 60,
                  child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          Duration(days: 365),
                        ),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.black26,
                              colorScheme: ColorScheme.light(primary: Colors.black26, secondary: Colors.black26),
                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null ? eventDateController.text = '${value.month}/${value.day}/${value.year}' : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}');
                    },
                    controller: eventDateController,
                    decoration: InputDecoration(labelText: "Date"),
                  ),
                ),
                SizedBox(
                  width: sizedBoxSize,
                ),
                Flexible(
                  flex: 40,
                  child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.black26,
                              colorScheme: ColorScheme.light(primary: Colors.black26, secondary: Colors.black26),
                              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null ? eventTimeController.text = '${value.hour}:${value.minute}' : '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}');
                    },
                    controller: eventTimeController,
                    decoration: InputDecoration(labelText: "Time"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventStatusController,
              decoration: InputDecoration(labelText: "Status"),
              validator: (value) => value!.isEmpty ? "Status should not be empty" : null,
            ),
            TextFormField(
              controller: eventVenueController,
              decoration: InputDecoration(labelText: "Venue"),
              validator: (value) => value!.isEmpty ? "Venue should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            Container(
                width: 200,
                height: 80,
                child: ElevatedButton(
                    onPressed: () {
                      chooseImage().then((value) => pickedImage = value);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Icon(Icons.image), Text("Pick Image")],
                    )))
          ],
        ),
      ),
    );

    Widget _actions = Container(
      padding: EdgeInsets.only(top: 50, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              yyDialog?.dismiss();
            },
            child: Text("Cancel"),
          ),
          SizedBox(
            width: sizedBoxSize,
          ),
          ElevatedButton(
            onPressed: () async {
              if (update ?? false) {
                updateEvent(id);
                yyDialog?.dismiss();

                return;
              }
              if (eventFormKey.currentState!.validate()) {
                addEvent();
                yyDialog?.dismiss();
              }
            },
            child: Text(update ?? false ? "Update" : "Add"),
          ),
        ],
      ),
    );
    yyDialog = YYDialog().build(Get.context!)
      ..width = 400
      ..borderRadius = 10
      ..backgroundColor = Colors.grey.shade800
      ..widget(_header)
      ..widget(_body)
      ..widget(_actions).show();
  }

  Future<XFile?> chooseImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  updateArtist(id) async {
    isLoading.value = true;
    if (pickedImage != null) {
      _provider
          .uploadArtistImage(pickedImage!)
          .then((value) => _provider
                  .updateArtist(ArtistModel(
                      id: id, imageLink: value, bio: artistBioController.text, name: artistNameController.text, address: artistAddressController.text, date: dateController.text, performanceLink: artistDescriptionController.text))
                  .then((value) {
                loadArtists();
              }).catchError((error) => print("addArtist Exception : $error")))
          .catchError((onError) => print("Exception $onError"));
    } else {
      await _provider
          .updateArtist(ArtistModel(
              id: id,
              imageLink: artistPreviousIamgeCotroelelr.text,
              bio: artistBioController.text,
              name: artistNameController.text,
              address: artistAddressController.text,
              date: dateController.text,
              performanceLink: artistDescriptionController.text))
          .then((value) {
        loadArtists();
      }).catchError((error) => print("addArtist Exception : $error"));
    }
  }

  addArtist() async {
    isLoading.value = true;
    _provider
        .uploadArtistImage(pickedImage!)
        .then((value) => _provider
                .addArtist(ArtistModel(imageLink: value, bio: artistBioController.text, name: artistNameController.text, address: artistAddressController.text, date: dateController.text, performanceLink: artistDescriptionController.text))
                .then((value) {
              loadArtists();
            }).catchError((error) => print("addArtist Exception : $error")))
        .catchError((onError) => print("Exception $onError"));
  }

  addEvent() async {
    EasyLoading.show(status: 'Uploading Event ...');
    _provider
        .uploadEventImage(pickedImage!)
        .then((value) => _provider
                .addEvent(
              EventsModel(
                  imageLink: value,
                  title: eventTittleController.text,
                  buyLink: eventBuyLinkController.text,
                  address: eventAddressController.text,
                  date: dateController.text,
                  cost: eventCostController.text,
                  status: eventStatusController.text,
                  time: timeController.text,
                  venue: eventVenueController.text),
            )
                .then((value) {
              EasyLoading.dismiss();
            }).catchError((error) => print("addEvent Exception : $error")))
        .catchError((onError) => print("Exception $onError"));
  }

  updateEvent(id) async {
    EasyLoading.show(status: 'Updateing Event ...');
    if (pickedImage != null) {
      _provider
          .uploadEventImage(pickedImage!)
          .then((value) => _provider
                  .updateEvent(
                EventsModel(
                    id: id,
                    imageLink: value,
                    title: eventTittleController.text,
                    buyLink: eventBuyLinkController.text,
                    address: eventAddressController.text,
                    date: dateController.text,
                    cost: eventCostController.text,
                    status: eventStatusController.text,
                    time: timeController.text,
                    venue: eventVenueController.text),
              )
                  .then((value) {
                EasyLoading.dismiss();
              }).catchError((error) => print("addEvent Exception : $error")))
          .catchError((onError) => print("Exception $onError"));
    } else {
      _provider
          .updateEvent(
        EventsModel(
            id: id,
            imageLink: eventImageController.text,
            title: eventTittleController.text,
            buyLink: eventBuyLinkController.text,
            address: eventAddressController.text,
            date: dateController.text,
            cost: eventCostController.text,
            status: eventStatusController.text,
            time: timeController.text,
            venue: eventVenueController.text),
      )
          .then((value) {
        EasyLoading.dismiss();
      }).catchError((error) => print("addEvent Exception : $error"));
    }
  }
}
