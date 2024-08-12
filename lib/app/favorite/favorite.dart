import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import '../data/sqlite.dart';
import '../model/fav.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => FavScreenState();
}

class FavScreenState extends State<FavScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Fav>> _getProducts() async {
    return await _databaseHelper.productsFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm yêu thích"),
      ),
      body: Container(
        child: FutureBuilder<List<Fav>>(
          future: _getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Không có sản phẩm...',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final itemProduct = snapshot.data![index];
                return Dismissible(
                  key: ValueKey(itemProduct.productID),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _databaseHelper.deleteProductFav(itemProduct.productID);
                      snapshot.data!.removeAt(index); // Remove from snapshot
                    });
                  },
                  background: Container(
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.black,
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: _buildProduct(itemProduct, context),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProduct(Fav pro, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Image.network(
                pro.img,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    NumberFormat('#,##0').format(pro.price) + ' VND',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Quantity: ${pro.count}',
                    style: GoogleFonts.pacifico(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
