import 'package:flutter/material.dart';
import 'package:bikestore/app/model/product.dart';
import 'package:bikestore/constants.dart';
import 'package:intl/intl.dart';
import 'package:bikestore/app/model/product.dart';

class ItemCard extends StatelessWidget {
  ItemCard({super.key, required this.product, required this.press});

  final ProductModel product;
  final VoidCallback press;
  List<String> images = [
    'assets/images/bag_1.png',
    'assets/images/bag_2.png',
    'assets/images/bag_3.png',
    'assets/images/bag_4.png',
    'assets/images/bag_5.png',
    'assets/images/bag_6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2), // Use kPrimaryLightColor here
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                /*  child: product.imageUrl.startsWith('http')
                    ? Image.network(product.imageUrl)
                    : Image.asset("assets/images/bag_1.png"),*/
                child: Image.asset(product.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              product.name,
              style: TextStyle(color: kTextColor),
            ),
          ),
          Text(
            '${NumberFormat('#,##0').format(product.price)} VNĐ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF98392), // You might want to use kPrimaryColor here
            ),
          )
        ],
      ),
    );
  }
}