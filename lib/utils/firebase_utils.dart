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

  static Future<void> updateEventInFireStore(EventModel event) async {
    print("🔧 FirebaseUtils: Starting update for ID: ${event.id}");
    
    CollectionReference<EventModel> collectionRef = getEventToFirestore();
    
    if (event.id == null || event.id!.isEmpty) {
      throw Exception("Event ID cannot be null or empty for update operation");
    }
    
    print("🔧 FirebaseUtils: Document path: Event/${event.id}");
    
    try {
      // Try using .set() with merge instead of .update()
      // This is more reliable and will create the document if it doesn't exist
      await collectionRef.doc(event.id).set(event, SetOptions(merge: true));
      print("✅ FirebaseUtils: Update completed successfully");
    } catch (e) {
      print("❌ FirebaseUtils: Update failed with error: $e");
      rethrow;
    }
  }

  static Future<void> deleteEventFromFireStore(String eventId) async {
    print("🔧 FirebaseUtils: Starting delete for ID: $eventId");
    
    CollectionReference<EventModel> collectionRef = getEventToFirestore();
    
    if (eventId.isEmpty) {
      throw Exception("Event ID cannot be empty for delete operation");
    }
    
    print("🔧 FirebaseUtils: Document path: Event/$eventId");
    
    try {
      await collectionRef.doc(eventId).delete();
      print("✅ FirebaseUtils: Delete completed successfully");
    } catch (e) {
      print("❌ FirebaseUtils: Delete failed with error: $e");
      rethrow;
    }
  }

  // READ - Get a single event by ID (Optional utility method)
  static Future<EventModel?> getEventById(String eventId) async {
    try {
      DocumentSnapshot<EventModel> doc = 
          await getEventToFirestore().doc(eventId).get();
      
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print("Error getting event: $e");
      return null;
    }
  }

  // READ - Get all events (Optional utility method)
  static Future<List<EventModel>> getAllEvents() async {
    try {
      QuerySnapshot<EventModel> querySnapshot = 
          await getEventToFirestore().get();
      
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting all events: $e");
      return [];
    }
  }
}