class EventModel {
  String? id;
  String categoryId;
  String eventTitle;
  String eventDescribtion;
  String eventImage;
  DateTime eventDateTime;
  String eventTime;
  bool isFavorite; // Changed from bool? to bool

  EventModel(
      {this.id,
      required this.categoryId,
      required this.eventTitle,
      required this.eventDescribtion,
      required this.eventImage,
      required this.eventDateTime,
      required this.eventTime,
      this.isFavorite = false}); // Default to false

  EventModel.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data["id"],
            categoryId: data["categoryId"] ?? "sport",
            eventTitle: data["eventTitle"],
            eventDescribtion: data["eventDescribtion"],
            eventImage: data["eventImage"],
            eventDateTime:
                DateTime.fromMillisecondsSinceEpoch(data["eventDateTime"]),
            eventTime: data["eventTime"],
            isFavorite: data["isFavorite"] ?? false); // Default to false if null

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "categoryId": categoryId,
      "eventTitle": eventTitle,
      "eventDescribtion": eventDescribtion,
      "eventImage": eventImage,
      "eventDateTime": eventDateTime.millisecondsSinceEpoch,
      "eventTime": eventTime,
      "isFavorite": isFavorite,
    };
  }
}