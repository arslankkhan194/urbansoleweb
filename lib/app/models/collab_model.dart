import 'package:cloud_firestore/cloud_firestore.dart';

class CollabModel {
  String? fileName;
  String? filePath;
  double? duration;
  String? fileLink;
  String? name;
  String? emailAddress;
  String? trackName;
  Timestamp? createdOn;
  String? id;
  String? user;
  String? codec;
  String? status;

  CollabModel(
      {this.fileName,
        this.filePath,
        this.duration,
        this.fileLink,
        this.createdOn,
        this.id,
        this.user,
        this.codec,
        this.status,
        this.name,
        this.emailAddress,
        this.trackName,
      });

  CollabModel.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    duration = json['duration'];
    fileLink = json['fileLink'];
    createdOn = json['createdOn'];
    id = json['id'];
    user = json['user'];
    codec = json['codec'];
    status = json['status'];
    name = json['name'];
    emailAddress = json['emailAddress'];
    trackName = json['trackName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['duration'] = this.duration;
    data['fileLink'] = this.fileLink;
    data['createdOn'] = this.createdOn;
    data['id'] = this.id;
    data['user'] = this.user;
    data['codec'] = this.codec;
    data['status'] = this.status;
    data['name'] = this.name;
    data['emailAddress'] = this.emailAddress;
    data['trackName'] = this.trackName;
    return data;
  }
}
