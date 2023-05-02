class ArtistModel {
  String? id;
  String? imageLink;
  String? name;
  String? address;
  String? date;
  String? description;
  String? bio;
  String? performanceLink;

  ArtistModel({this.id, this.imageLink, this.name, this.bio, this.address, this.date, this.description, this.performanceLink});

  ArtistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageLink = json['imageLink'];
    name = json['name'];
    bio = json['bio'];
    address = json['address'];
    date = json['date'];
    description = json['description'];
    performanceLink = json['performanceLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageLink'] = this.imageLink;
    data['name'] = this.name;
    data['address'] = this.address;
    data['date'] = this.date;
    data['bio'] = this.bio;
    data['description'] = this.description;
    data['performanceLink'] = this.performanceLink;
    return data;
  }
}
