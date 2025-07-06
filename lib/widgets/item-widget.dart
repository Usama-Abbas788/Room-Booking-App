import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/models/items.dart';

class ItemWidget extends StatefulWidget {
  late Items item;
  ItemWidget({super.key,required this.item});
  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTap: () {
        Get.toNamed("/item_detail_page",arguments: item);
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          margin: EdgeInsets.only(right: 18),
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 6,
          child: Container(
            width: 185,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    height: 85,
                    width: 185,
                    child: Image.asset(item.image,fit: BoxFit.cover,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(item.name,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Align(alignment: Alignment.centerRight,child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text('Rs. ${(item.price.toString())}/Night',style: TextStyle(fontSize: 12,color: Colors.black),),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
