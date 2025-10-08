import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:flutter/material.dart';

class EventListProvider extends ChangeNotifier {
  List<EventModel> eventList = [];
  void getEventCollections() async {
    QuerySnapshot<EventModel> querySnapShot =
        await FirebaseUtils.getEventToFirestore().get();
    eventList = querySnapShot.docs.map((doc) {
      return doc.data();
    }).toList();

    notifyListeners();
  }
}
