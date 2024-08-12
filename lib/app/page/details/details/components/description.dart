import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:bikestore/app/model/product.dart';

import '../../../../../constants.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0'); // Create a NumberFormat instance

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              'Mô tả: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            product.description,
            style: TextStyle(height: 1.5, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(height: 40),
          Text(
            'Giá: ${numberFormat.format(product.price)} VNĐ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }
}
