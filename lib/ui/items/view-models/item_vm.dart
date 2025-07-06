import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/FavoritesRepository.dart';
import 'package:my_app/models/favorites.dart';
import '../../../models/items.dart';

class ItemViewModel extends GetxController {
  final FavoritesRepository favoritesRepository = Get.find();
  var favorites = <Favorites>[].obs;
  int get favoritesCount => favorites.length;
  Future<void> getFavoritesByUserId(String userId) async {
    try {
      final result = await favoritesRepository.getFavoritesByUserId(userId);
      favorites.value = result;
    } catch (e) {
      favorites.value = [];
      Get.snackbar('Error', 'Failed to load favorites: $e');
      rethrow;
    }
  }

  // Add item to favorites
  Future<void> addToFavorites(Items item) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final favorite = Favorites(
        "",
        user.uid,
        item.name,
        item.location,
        item.price.toDouble(),
        item.image,
      );

      await favoritesRepository.addToFavorites(favorite);
      favorites.add(favorite);

      Get.snackbar(
        'Added to favorites',
        'Successfully added to favorites',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to favorites: $e');
    }
  }

  // Remove item from favorites
  Future<void> deleteFromFavorites(Favorites favorite) async {
    try {
      await favoritesRepository.deleteFromFavorites(favorite);
      favorites.removeWhere((f) => f.docId == favorite.docId);
      Get.snackbar('Removed', 'Removed from favorites');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from favorites: $e');
      throw e;
    }
  }

  // Toggle favorite: add if not favorite, remove if already favorite
  Future<void> toggleFavorite(Items item) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      final existing = favorites.firstWhereOrNull(
            (fav) =>
        fav.roomName == item.name &&
            fav.roomLocation == item.location &&
            fav.roomImage == item.image &&
            fav.roomPrice == item.price,
      );

      if (existing != null) {
        await deleteFromFavorites(existing);
      } else {
        final newFavorite = Favorites(
          "",
          user.uid,
          item.name,
          item.location,
          item.price.toDouble(),
          item.image,
        );
        await favoritesRepository.addToFavorites(newFavorite);
        favorites.add(newFavorite);

        Get.snackbar('Added', 'Added to favorites');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle favorite: $e');
    }
  }

  // Check if an item is already in favorites
  bool isFavorite(Items item) {
    return favorites.any(
          (fav) =>
      fav.roomName == item.name &&
          fav.roomLocation == item.location &&
          fav.roomImage == item.image &&
          fav.roomPrice == item.price,
    );
  }
}
