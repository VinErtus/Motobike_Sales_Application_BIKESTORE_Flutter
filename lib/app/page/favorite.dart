import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bikestore/app/data/sqlite.dart';
import 'package:bikestore/app/model/fav.dart';
import 'package:intl/intl.dart';

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
    return bgWidget1(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Yêu thích"),
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
                      fontSize: 16,
                      color: Colors.white,
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: Image.network(
                pro.img,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xe: ' + pro.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Text(
                    'Giá: ' + NumberFormat('#,##0').format(pro.price) + ' VND',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 18.0),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
