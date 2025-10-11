// Update your EventModel class

class EventModel {
  String? id;
  String categoryId; // Changed from categoryIndex
  String eventTitle;
  String eventDescribtion;
  String eventImage;
  DateTime eventDateTime;
  String eventTime;

  EventModel({
    this.id,
    required this.categoryId, // Changed from categoryIndex
    required this.eventTitle,
    required this.eventDescribtion,
    required this.eventImage,
    required this.eventDateTime,
    required this.eventTime,
  });

  EventModel.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"],
          categoryId: data["categoryId"] ?? "sport", // Changed with default
          eventTitle: data["eventTitle"],
          eventDescribtion: data["eventDescribtion"],
          eventImage: data["eventImage"],
          eventDateTime: DateTime.fromMillisecondsSinceEpoch(data["eventDateTime"]),
          eventTime: data["eventTime"],
        );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "categoryId": categoryId, // Changed from categoryIndex
      "eventTitle": eventTitle,
      "eventDescribtion": eventDescribtion,
      "eventImage": eventImage,
      "eventDateTime": eventDateTime.millisecondsSinceEpoch,
      "eventTime": eventTime,
    };
  }
}