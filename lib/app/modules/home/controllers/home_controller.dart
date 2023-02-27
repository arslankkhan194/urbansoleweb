import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_audio_player/widgets/players/full_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
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

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class HomeController extends GetxController {
  FirebaseProvider _provider = FirebaseProvider();
  final selectedPageIndex = 0.obs;
  final isLoading = false.obs;
  final artistFormKey = GlobalKey<FormState>();
  TextEditingController artistNameController = TextEditingController();
  TextEditingController artistAddressController = TextEditingController();
  TextEditingController artistDescriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  //event
  final eventFormKey = GlobalKey<FormState>();
  TextEditingController eventBuyLinkController = TextEditingController();
  TextEditingController eventAddressController = TextEditingController();
  TextEditingController eventCostController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventTimeController = TextEditingController();
  TextEditingController eventStatusController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();


  TextEditingController announcementController = TextEditingController();

  XFile? pickedImage;
  List<Widget> pages = [
    CollabView(),
    ArtistsView(),
    EventsView(),
    SettingsView()
  ];

  List<DataRow2> artistRows = [];
  List<DataColumn2> artistColumns = [
    DataColumn2(label: Text(""), fixedWidth: 100),
    DataColumn2(
        label: Text(
          "Artist Name",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 150),
    DataColumn2(
        label: Text(
          "Origin",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 150),
    DataColumn2(
        label: Text(
          "Date & Time",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 150),
    DataColumn2(
        label: Text(
      "Performance Link",
      style: Theme.of(Get.context!).textTheme.titleMedium,
    )),
  ];

  List<DataRow2> eventRows = [];
  List<DataColumn2> eventColumns = [
    DataColumn2(label: Text(""), fixedWidth: 100),
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
        fixedWidth: 150),
    DataColumn2(
        label: Text(
          "Time",
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        fixedWidth: 150),
    DataColumn2(
        label:
            Text("Status", style: Theme.of(Get.context!).textTheme.titleMedium),
        fixedWidth: 150),
    DataColumn2(
        label:
            Text("Venue", style: Theme.of(Get.context!).textTheme.titleMedium)),
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
    dateController.text =
        '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
    timeController.text = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';
    loadArtists();
    loadEvents();
    loadCollab();
    loadAnnouncement();
  }

  loadAnnouncement()async{
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
                      PlayerWidget( url: '${e.fileLink}', color: Colors.white,)
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
                      e.status == "PENDING"?Row(
                        children: [
                          ElevatedButton(
                            onPressed: () { 
                              e.status = "APPROVED";
                              _provider.updateCollab(e).then((value) => loadCollab());
                            },
                            child:Text('Approve',
                            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green,fontSize: 12),
                          )),
                          SizedBox(width: 5,),
                          ElevatedButton(
                              onPressed: () async {
                                print("collab we are in reject");
                                FirebaseFirestore.instance
                                    .collection("collab")
                                    .doc(e.id.toString())
                                    .update({
                                  "status": "REJECTED",
                                })
                                    .then((value) {
                                      print("Coloab is here");
                                  loadCollab();
                                })
                                    .catchError((onError) {
                                      print("collab $onError");
                                });

                              },
                              child:Text('Reject',
                                style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.red,fontSize: 12),
                              )),
                        ],
                      ):
                      e.status == "REJECTED"?Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // e.status = "APPROVED";
                              // _provider.updateCollab(e).then((value) => loadCollab());
                            },
                            child:Text('Rejected',
                            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green,fontSize: 12),
                          )),
                        ],
                      ):
                      e.status == "APPROVED"?Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // e.status = "APPROVED";
                              // _provider.updateCollab(e).then((value) => loadCollab());
                            },
                            child:Text('Approved',
                            style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(color: Colors.green,fontSize: 12),
                          )),
                        ],
                      ):

                      Container(),
                    ),
                  ],
                ),
              )
              .toList(),
        );
    isLoading.value = false;
  }

  loadEvents() {
    _provider.getEvents().then(
          (value) => eventRows = value
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
                  ],
                ),
              )
              .toList(),
        );
    isLoading.value = false;
  }

  showUpdatAnnouncementDialog(context){
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Announcement",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: AppColors.primary),
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
        validator: (value) =>
        value!.isEmpty ? "Announcement should not be empty" : null,
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

  showAddArtistDialog(context) {
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Artist",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: AppColors.primary),
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
              validator: (value) =>
                  value!.isEmpty ? "Please enter Artist Name" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: artistAddressController,
              decoration: InputDecoration(labelText: "Address/Venue/Origin"),
              validator: (value) =>
                  value!.isEmpty ? "Address/Venue/Origin should not be empty" : null,
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
                              accentColor: Colors.black26,
                              colorScheme:
                                  ColorScheme.light(primary: Colors.black26),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null
                          ? dateController.text =
                              '${value.month}/${value.day}/${value.year}'
                          : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}');
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
                              accentColor: Colors.black26,
                              colorScheme:
                                  ColorScheme.light(primary: Colors.black26),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null
                          ? timeController.text =
                              '${value.hour}:${value.minute}'
                          : '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}');
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
              validator: (value) =>
                  value!.isEmpty ? "Description should not be empty" : null,
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
              if (artistFormKey.currentState!.validate()) {
                addArtist();
                yyDialog?.dismiss();
              }
            },
            child: Text("Add"),
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

  showAddEventDialog(context) {
    YYDialog? yyDialog;
    double sizedBoxSize = 16;
    Widget _header = Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Event",
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: AppColors.primary),
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
              controller: eventAddressController,
              decoration: InputDecoration(labelText: "Address"),
              validator: (value) =>
                  value!.isEmpty ? "Please enter Address" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventBuyLinkController,
              decoration: InputDecoration(labelText: "Buy Link"),
              validator: (value) =>
                  value!.isEmpty ? "Buy Link should not be empty" : null,
            ),
            SizedBox(
              height: sizedBoxSize,
            ),
            TextFormField(
              controller: eventCostController,
              decoration: InputDecoration(labelText: "Cost"),
              validator: (value) =>
                  value!.isEmpty ? "Cost should not be empty" : null,
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
                              accentColor: Colors.black26,
                              colorScheme:
                                  ColorScheme.light(primary: Colors.black26),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null
                          ? dateController.text =
                              '${value.month}/${value.day}/${value.year}'
                          : '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}');
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
                              accentColor: Colors.black26,
                              colorScheme:
                                  ColorScheme.light(primary: Colors.black26),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => value != null
                          ? timeController.text =
                              '${value.hour}:${value.minute}'
                          : '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}');
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
              controller: eventStatusController,
              decoration: InputDecoration(labelText: "Status"),
              validator: (value) =>
                  value!.isEmpty ? "Status should not be empty" : null,
            ),
            TextFormField(
              controller: eventVenueController,
              decoration: InputDecoration(labelText: "Venue"),
              validator: (value) =>
                  value!.isEmpty ? "Venue should not be empty" : null,
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
              if (eventFormKey.currentState!.validate()) {
                addEvent();
                yyDialog?.dismiss();
              }
            },
            child: Text("Add"),
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
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  addArtist() async {
    isLoading.value = true;
    _provider
        .uploadArtistImage(pickedImage!)
        .then((value) => _provider
                .addArtist(ArtistModel(
                    imageLink: value,
                    name: artistNameController.text,
                    address: artistAddressController.text,
                    date: "",
                    performanceLink: artistDescriptionController.text))
                .then((value) {
              loadArtists();
            }).catchError((error) => print("addArtist Exception : $error")))
        .catchError((onError) => print("Exception $onError"));
  }

  addEvent() async {
    isLoading.value = true;
    _provider
        .uploadEventImage(pickedImage!)
        .then((value) => _provider
                .addEvent(
              EventsModel(
                  imageLink: value,
                  buyLink: eventBuyLinkController.text,
                  address: eventAddressController.text,
                  date: "",
                  cost: eventCostController.text,
                  status: eventStatusController.text,
                  time: "",
                  venue: eventVenueController.text),
            )
                .then((value) {
              loadEvents();
            }).catchError((error) => print("addEvent Exception : $error")))
        .catchError((onError) => print("Exception $onError"));
  }
}
