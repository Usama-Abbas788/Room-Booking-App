import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  String image;
  String name;
  String cityName;
  CardItem({super.key, required this.image, required this.name, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(11),
              ),
              height: 90,
              width: 56,
              child: Image.asset(this.image,fit: BoxFit.cover,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0,right: 4),
              child: Column(
                children: [
                  Text(this.name,style: TextStyle(fontSize: 12,color: Colors.blueGrey),),
                  Text('In',style: TextStyle(fontSize: 12,color: Colors.blueGrey)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Icon(Icons.location_on_outlined,size: 14,color: Colors.green,),
                      ),
                      Text(this.cityName,style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
class FacilitiesCard extends StatelessWidget {
  final IconData icon;
  String name;
  FacilitiesCard({super.key, required this.icon, required this.name});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.black87,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(this.icon,color: Colors.green.withOpacity(0.9),),
          ),
        ),
        Text(this.name)
      ],
    );
  }
}

