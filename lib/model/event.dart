class EventModel {
  String id;
  String eventName;
  String eventTitle;
  String eventDescribtion;
  String eventImage;
  DateTime eventDateTime;
  String eventTime;
  bool isFavorite;

  EventModel(
      {this.id = "",
      required this.eventName,
      required this.eventTitle,
      required this.eventDescribtion,
      required this.eventImage,
      required this.eventDateTime,
      this.isFavorite = false,
      required this.eventTime});

  //todo: object => json

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "eventDescribtion": eventDescribtion,
      "eventTitle": eventTitle,
      "eventDateTime": eventDateTime.millisecondsSinceEpoch,
      "eventImage": eventImage,
      "eventName": eventName,
      "eventTime": eventTime,
      "isFavorite": isFavorite
    };
  }

  // todo: json => object

  EventModel.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"],
          eventTitle: data["eventTitle"],
          eventDescribtion: data["eventDescribtion"],
          eventImage: data["eventImage"],
          eventName: data["eventName"],
          eventDateTime:
              DateTime.fromMillisecondsSinceEpoch(data["eventDateTime"]),
          eventTime: data["eventTime"],
          isFavorite: data["isFavorite"],
        );
}
