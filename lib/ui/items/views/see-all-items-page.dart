import 'package:flutter/material.dart';
import 'package:my_app/widgets/item-widget.dart';

import '../../../models/items.dart';
import '../../../providers/dummy-item-provider.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  var list=DummyItemProvider.getDummyItem();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0,right: 18,top: 5,bottom: 8),
        child: Center(
          child: Column(
            children: [
              Text("\"Everest Heights\"", style: TextStyle(fontSize: 17)),
              Text(
                'Explore All Our Rooms',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0,left: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (context, index) {
                      return ItemWidget(item: list[index]);
                    },
                    itemCount: list.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
