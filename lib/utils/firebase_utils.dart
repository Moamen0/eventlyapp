import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/model/myUser.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseUtils {
  static CollectionReference<EventModel> getEventToFirestore(String uid) {
    return getUserCollection().doc(uid)
        .collection("Event")
        .withConverter<EventModel>(
          fromFirestore: (snapshot, options) =>
              EventModel.fromFireStore(snapshot.data()!),
          toFirestore: (event, options) => event.toFireStore(),
        );
  }

  static Future<void> addEventToFireStore(EventModel event, String uid) {
    CollectionReference<EventModel> collectionRef = getEventToFirestore(uid);

    DocumentReference<EventModel> docRef = collectionRef.doc();
    event.id = docRef.id;
    return docRef.set(event);
  }

  static Future<void> updateEventInFireStore(EventModel event,String uid) async {
    CollectionReference<EventModel> collectionRef = getEventToFirestore(uid);

    if (event.id == null || event.id!.isEmpty) {
      throw Exception("Event ID cannot be null or empty for update operation");
    }

    try {
      await collectionRef.doc(event.id).set(event, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteEventFromFireStore(String eventId,String uid) async {
    CollectionReference<EventModel> collectionRef = getEventToFirestore(uid);

    if (eventId.isEmpty) {}

    try {
      await collectionRef.doc(eventId).delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<EventModel?> getEventById(String eventId,String uid) async {
    try {
      DocumentSnapshot<EventModel> doc =
          await getEventToFirestore(uid).doc(eventId).get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<EventModel>> getAllEvents(String uid) async {
    try {
      QuerySnapshot<EventModel> querySnapshot =
          await getEventToFirestore(uid).get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  static CollectionReference<Myuser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(Myuser.collectionName)
        .withConverter<Myuser>(
          fromFirestore: (snapshot, options) =>
              Myuser.fromFirestore(snapshot.data()!),
          toFirestore: (user, options) => user.toFirestore(),
        );
  }

  static Future<void> addUserToFirestore(Myuser user) {
    CollectionReference<Myuser> collectionRef = getUserCollection();

    DocumentReference<Myuser> docRef = collectionRef.doc(user.id);
    return docRef.set(user);
  }

  static Future<Myuser?> readUsersFromFirestore(String id) async{
   var querySnapshot = await getUserCollection().doc(id).get();
   return querySnapshot.data();
  }
}
