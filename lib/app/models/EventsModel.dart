class EventsModel {
  String? id;
  String? address;
  String? buyLink;
  String? cost;
  String? date;
  String? imageLink;
  String? status;
  String? time;
  String? venue;

  EventsModel(
      {this.id,
      this.address,
      this.buyLink,
      this.cost,
      this.date,
      this.imageLink,
      this.status,
      this.time,
      this.venue});

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    buyLink = json['buyLink'];
    cost = json['cost'];
    date = json['date'];
    imageLink = json['imageLink'];
    status = json['status'];
    time = json['time'];
    venue = json['venue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['buyLink'] = this.buyLink;
    data['cost'] = this.cost;
    data['date'] = this.date;
    data['imageLink'] = this.imageLink;
    data['status'] = this.status;
    data['time'] = this.time;
    data['venue'] = this.venue;
    return data;
  }
}
