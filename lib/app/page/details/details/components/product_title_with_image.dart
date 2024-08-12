import 'package:flutter/material.dart';
import 'package:bikestore/app/model/product.dart';

import '../../../../../constants.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Tên sản phẩm",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            product.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              const SizedBox(width: 0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0), // 2pt bottom padding
                  child: Hero(
                    tag: "${product.id}",
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 100.0, // Adjust the max width as needed
                        maxHeight: 220.0, // Adjust the max height as needed
                      ),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.fill, // Adjust as needed
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
