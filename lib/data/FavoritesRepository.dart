import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/favorites.dart';

class FavoritesRepository{
  late CollectionReference favoritesCollection;
  FavoritesRepository(){
    favoritesCollection=FirebaseFirestore.instance.collection('favorites');
  }

  Future<String> addToFavorites(Favorites favorites) async {
    var doc=favoritesCollection.doc();
    favorites.docId=doc.id;
    await doc.set(favorites.toMap());
    return doc.id;
  }

  Future<List<Favorites>> getFavoritesByUserId(String userId) async {
    try {
      final querySnapshot = await favoritesCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) {
        final favoritesData = doc.data() as Map<String, dynamic>;
        favoritesData['docId'] = doc.id;
        return Favorites.fromMap(favoritesData);
      }).toList();
    } catch (e) {
      print('Error getting Favorites data: $e');
      return [];
    }
  }

  Future<void> deleteFromFavorites(Favorites favorites) async {
    await favoritesCollection.doc(favorites.docId).delete();
  }

}