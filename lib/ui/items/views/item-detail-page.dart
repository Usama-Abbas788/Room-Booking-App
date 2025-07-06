import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/FavoritesRepository.dart';
import 'package:my_app/widgets/card-widget.dart';

import '../../../models/items.dart';
import '../view-models/item_vm.dart';
class ItemDetailPage extends StatefulWidget {
  ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late ItemViewModel itemViewModel;
  late final Items item;

  @override
  void initState() {
    super.initState();
    itemViewModel=Get.find();
    item = Get.arguments as Items; // Receive from ItemWidget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 38),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
              ),
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.image, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.23)),
                  Positioned(
                    top: 16,
                    left: 3,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 8,
                    child: Obx(() {
                      final isFav = itemViewModel.isFavorite(item);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,size: 31,
                          color: isFav ? Colors.green : Colors.white,
                        ),
                        onPressed: () => itemViewModel.toggleFavorite(item),
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 6,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        side: BorderSide(color: Colors.green),
                      ),
                      onPressed: () {
                        Get.offNamed('/book_now_page', arguments: item);
                      },
                      child: Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 370,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        Text('Rs. ${(item.price.toString())}/Night',style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 13),),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.green),
                        Text(
                          item.location,
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    SizedBox(height: 17),
                    Text(
                      'Facilities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FacilitiesCard(icon: Icons.wifi, name: 'Wifi'),
                        FacilitiesCard(
                          icon: Icons.restaurant,
                          name: 'Restaurant',
                        ),
                        FacilitiesCard(icon: Icons.wine_bar, name: 'Bar'),
                        FacilitiesCard(icon: Icons.pool, name: 'Pool'),
                        FacilitiesCard(
                          icon: Icons.sports_gymnastics_outlined,
                          name: 'Gym',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ItemDetailPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(FavoritesRepository());
    Get.put(ItemViewModel());
  }
}

