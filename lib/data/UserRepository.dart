import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserRepository{
  late CollectionReference newUserCollection;
  UserRepository(){
    newUserCollection=FirebaseFirestore.instance.collection('users');
  }

  Future<void> addUser(NewUser newUser){
    var doc=newUserCollection.doc();
    newUser.docId=doc.id;
    return doc.set(newUser.toMap());
  }

  Future<NewUser?> getUser(String userId) async {
    try {
      final querySnapshot = await newUserCollection
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final userData = doc.data() as Map<String, dynamic>;
        userData['docId'] = doc.id; // Include the document ID
        return NewUser.fromMap(userData);
      }
      return null; // User not found
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
  Future<void> updateUser(NewUser newUser) {
    return newUserCollection.doc(newUser.docId).set(newUser.toMap());
  }

  Future<void> deleteUser(NewUser newUser) {
     return newUserCollection.doc(newUser.docId).delete();
  }

}