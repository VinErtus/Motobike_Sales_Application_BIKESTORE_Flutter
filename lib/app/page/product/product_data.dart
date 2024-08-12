import 'dart:io';
import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/api.dart';
import '../../model/product.dart';
import 'product_add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBuilder extends StatefulWidget {
  const ProductBuilder({Key? key}) : super(key: key);

  @override
  State<ProductBuilder> createState() => _ProductBuilderState();
}

class _ProductBuilderState extends State<ProductBuilder> {
  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
  }

  Future<void> _deleteProduct(ProductModel product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await APIRepository().removeProduct(
      product.id,
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget1(
      child: FutureBuilder<List<ProductModel>>(
        future: _getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào'),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemProduct = snapshot.data![index];
                return Dismissible(
                  key: Key(itemProduct.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteProduct(itemProduct);
                  },
                  background: Container(
                    color: const Color.fromARGB(
                        255, 44, 119, 210), // Set background color to blue
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.black, // Set icon color to white
                    ),
                  ),
                  child: _buildProduct(itemProduct, context),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildProductImage(pro),
            const SizedBox(width: 16.0),
            Expanded(
              child: _buildProductInfo(pro, context),
            ),
            _buildActionButtons(pro, context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel pro) {
    // Extract the first letter of the product's name, or use a placeholder letter
    String firstLetter = pro.name.isNotEmpty ? pro.name[0].toUpperCase() : '?';

    return Container(
      // width: 100.0,
      // height: 100.0,
      // alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   color: const Color.fromARGB(255, 249, 177, 64), // Background color
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      // child: Text(
      //   firstLetter,
      //   style: TextStyle(
      //     fontSize: 50.0, // Adjust the font size as needed
      //     fontWeight: FontWeight.bold,
      //     color: Colors.white, // Text color
      //   ),
      // ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 2),
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: pro.imageUrl == null ||
                    pro.imageUrl == '' ||
                    pro.imageUrl == 'Null'
                    ? Image.asset('assets/images/placeholder.png')
                    : Image.network(pro.imageUrl),
              ),
           ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductModel pro, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
         'Xe: ' + pro.name,
          style: GoogleFonts.rowdies(
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(

          'Giá: ' + '${NumberFormat('#,##0').format(pro.price)} VNĐ',
          style: GoogleFonts.rowdies(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Mô tả: ${pro.description}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ProductModel pro, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => ProductAdd(
                  isUpdate: true,
                  productModel: pro,
                ),
                fullscreenDialog: true,
              ),
            )
                .then((_) => setState(() {}));
          },
          icon: const Icon(Icons.edit, color: Color.fromARGB(
              255, 44, 119, 210)),
        ),
      ],
    );
  }
}
