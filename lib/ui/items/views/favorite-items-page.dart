import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/FavoritesRepository.dart';
import '../view-models/item_vm.dart';
class FavoriteItemsPage extends StatefulWidget {
  const FavoriteItemsPage({super.key});

  @override
  State<FavoriteItemsPage> createState() => _FavoriteItemsPageState();
}

class _FavoriteItemsPageState extends State<FavoriteItemsPage> {
  late ItemViewModel itemViewModel;
  @override
  void initState() {
    super.initState();
    itemViewModel=Get.find();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      itemViewModel.getFavoritesByUserId(user.uid);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Obx(() {
        final favorites = itemViewModel.favorites;
        if (favorites.isEmpty) {
          return Center(child: Text("No favorite items yet."));
        }
        return Padding(
          padding: const EdgeInsets.only(left: 18.0,right: 18,top: 10,bottom: 10),
          child: ListView.builder(itemCount: favorites.length,itemBuilder: (context, index) {
            final favorite = favorites[index];
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: Colors.black54)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        height: 100,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.blue,
                        ),
                        child: Image.asset(favorite.roomImage,fit: BoxFit.cover,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(favorite.roomName,style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 5,),
                              Text(favorite.roomLocation,overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                              SizedBox(height: 5,),
                              Text('Rs. ${(favorite.roomPrice.toString())}/Night',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -5,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.green,
                    ),
                    onPressed: () => itemViewModel.deleteFromFavorites(favorite),
                  ),
                ),
              ],
            );
          },),
        );
      },),
    );
  }
}
class FavoriteItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoritesRepository());
    Get.put(ItemViewModel());
  }
}
