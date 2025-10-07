import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseUtils {
  static CollectionReference<EventModel> getEventToFirestore() {
    return FirebaseFirestore.instance
        .collection("Event")
        .withConverter<EventModel>(
          fromFirestore: (snapshot, options) =>
              EventModel.fromFireStore(snapshot.data()!),
          toFirestore: (event, options) => event.toFireStore(),
        );
  }

  static Future<void> addEventToFireStore(EventModel event) {
    CollectionReference<EventModel> collectionRef = getEventToFirestore();

    DocumentReference<EventModel> docRef = collectionRef.doc();
    event.id = docRef.id;
    return docRef.set(event);
  }
}
