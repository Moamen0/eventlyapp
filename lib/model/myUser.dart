import 'package:cloud_firestore/cloud_firestore.dart';

class Myuser {
  static const String collectionName = "users";
  String? id;
  String? name;
  String? email;
  Myuser({required this.id,required this.name,required this.email});

Myuser.fromFirestore( Map <String , dynamic> data ): this(
        id: data['id'],
        name: data['name'],
        email: data['email'],
      );
      
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}