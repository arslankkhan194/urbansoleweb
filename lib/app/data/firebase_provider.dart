import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_sound_art_admin/app/models/ArtistModel.dart';
import 'package:urban_sound_art_admin/app/models/EventsModel.dart';
import 'package:urban_sound_art_admin/app/models/collab_model.dart';

class FirebaseProvider {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<ArtistModel>> getArtists() async {
    List<ArtistModel> response = [];
    await _firestore
        .collection("artists")
        .get()
        .then((value) => response = value.docs
            .map<ArtistModel>(
                (e) => ArtistModel.fromJson(e.data() as Map<String, dynamic>))
            .toList())
        .catchError((error) => print("Exception $error"));
    return response;
  }

  Future<bool> addArtist(ArtistModel artistModel) async {
    bool response = false;
    DocumentReference docRef = _firestore.collection("artists").doc();
    artistModel.id = docRef.id;
    await docRef
        .set(artistModel.toJson())
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<String> uploadArtistImage(XFile image) async {
    String downloadingUrl = "";
    await _storage
        .ref()
        .child("artists/${image.name}")
        .putData(
          await image.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        )
        .then((p0) =>
            p0.ref.getDownloadURL().then((value) => downloadingUrl = value));
    return downloadingUrl;
  }

  Future<bool> updateArtist(ArtistModel artistModel) async {
    bool response = false;
    await _firestore
        .collection("artists")
        .doc(artistModel.id)
        .update(artistModel.toJson())
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<bool> deleteArtist(int id) async {
    bool response = false;
    await _firestore
        .collection("artists")
        .doc()
        .delete()
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<List<EventsModel>> getEvents() async {
    List<EventsModel> response = [];
    await _firestore
        .collection("events")
        .get()
        .then((value) => response = value.docs
            .map<EventsModel>(
                (e) => EventsModel.fromJson(e.data() as Map<String, dynamic>))
            .toList())
        .catchError((error) => print("Exception $error"));
    return response;
  }

  Future<bool> addEvent(EventsModel eventsModel) async {
    bool response = false;
    DocumentReference docRef = _firestore.collection("events").doc();
    eventsModel.id = docRef.id;
    await docRef
        .set(eventsModel.toJson())
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<String> uploadEventImage(XFile image) async {
    String downloadingUrl = "";
    await _storage
        .ref()
        .child("event/${image.name}")
        .putData(
          await image.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        )
        .then((p0) =>
            p0.ref.getDownloadURL().then((value) => downloadingUrl = value));
    return downloadingUrl;
  }

  Future<bool> updateEvent(EventsModel eventsModel) async {
    bool response = false;
    await _firestore
        .collection("events")
        .doc(eventsModel.id)
        .update(eventsModel.toJson())
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<bool> deleteEvent(int id) async {
    bool response = false;
    await _firestore
        .collection("events")
        .doc()
        .delete()
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<List<CollabModel>> getCollab() async {
    List<CollabModel> response = [];
    await _firestore
        .collection("collab")
        .get()
        .then((value) => response = value.docs
            .map<CollabModel>(
                (e) => CollabModel.fromJson(e.data() as Map<String, dynamic>))
            .toList())
        .catchError((error) => print("Exception $error"));
    return response;
  }

  Future<bool> updateCollab(CollabModel eventsModel) async {
    bool response = false;
    await _firestore
        .collection("collab")
        .doc(eventsModel.id)
        .update(eventsModel.toJson())
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<bool> updateAnnouncement(String announcement) async {
    bool response = false;
    await _firestore
        .collection("announcements")
        .doc("MeuBqbR49QE5lka4cl5Y")
        .update({"announcement": announcement})
        .then((value) => response = true)
        .catchError((onError) => response = false);
    return response;
  }

  Future<String> getAnnouncement() async {
    String response = "";
    await _firestore
        .collection("announcements")
        .doc("MeuBqbR49QE5lka4cl5Y")
        .get()
        // .update({"announcement": announcement})
        .then((value) => response = value.get("announcement"))
        .catchError((onError) => response = "");
    return response;
  }
}
