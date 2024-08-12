import 'dart:io';
import 'package:bikestore/app/page/category/category_list.dart';
import 'package:bikestore/app/page/category/category_lists.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../../data/api.dart';
import '../../data/sqlite.dart';
import '../../model/cart.dart';
import '../../model/fav.dart';
import '../../model/product.dart';
import '../category/category_data.dart';
import '../../page/details/details/details_screen.dart'; // Đảm bảo import trang chi tiết sản phẩm

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({Key? key}) : super(key: key);

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final DatabaseHelper _databaseService = DatabaseHelper();
  final Set<int> _favoriteProducts = Set<int>(); // Để theo dõi sản phẩm yêu thích

  Future<List<ProductModel>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID') ?? '',
      prefs.getString('token') ?? '',
    );
  }

  Future<void> _onSave1(ProductModel pro) async {
    _databaseService.insertProductFav(Fav(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  Future<void> _onSave(ProductModel pro) async {
    _databaseService.insertProduct(Cart(
      productID: pro.id,
      name: pro.name,
      des: pro.description,
      price: pro.price,
      img: pro.imageUrl,
      count: 1,
    ));
    setState(() {});
  }

  void _toggleFavorite(ProductModel pro) {
    setState(() {
      if (_favoriteProducts.contains(pro.id)) {
        _favoriteProducts.remove(pro.id);
      } else {
        _favoriteProducts.add(pro.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgBackground),
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: whiteColor,
                        hintText: searchanything,
                        hintStyle: TextStyle(color: textfieldGrey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 140,
                      enlargeCenterPage: true,
                      itemCount: sliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          sliderList[index],
                          fit: BoxFit.fill,
                        ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 4)).make();
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Các thương hiệu",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        148.widthBox,
                        TextButton(
                          onPressed: () {
                            Get.to(() => const CategoryLists());
                          },
                          child: "Xem thêm >>".text.size(13).color(redColor).make(),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.95,
                      color: Colors.black.withOpacity(1),
                      margin: const EdgeInsets.symmetric(vertical: 1),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesImage.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 60,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Image.asset(
                                categoriesImage[index],
                                height: 60,
                              )
                            ],
                          ).box.white.rounded.clip(Clip.antiAlias).shadowSm.make().onTap(() {
                            Get.to(() => const CategoryLists());
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Tất cả sản phẩm",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.95,
                      color: Colors.black.withOpacity(1),
                      margin: const EdgeInsets.symmetric(vertical: 1),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<ProductModel>>(
                      future: _getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Không có sản phẩm nào'),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final itemProduct = snapshot.data![index];
                              return _buildProduct(itemProduct, context);
                            },
                          ),
                        );
                      },
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

  Widget _buildProduct(ProductModel pro, BuildContext context) {
    final bool isFavorite = _favoriteProducts.contains(pro.id);
    return Dismissible(
      key: Key(pro.id.toString()),
      background: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.greenAccent, Colors.green],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await _onSave(pro);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pro.name} đã thêm vào giỏ hàng'),
              duration: const Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(product: pro),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: Colors.white,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: pro.imageUrl == null || pro.imageUrl == '' || pro.imageUrl == 'Null'
                              ? Image.asset('assets/images/placeholder.png')
                              : Image.network(pro.imageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Mã: ${pro.id}',
                            style: GoogleFonts.abel(
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Xe: ' + pro.name,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Giá: ' + '${NumberFormat('#,##0').format(pro.price)} VNĐ',
                            style: GoogleFonts.roboto(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 248, 67, 67),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mô tả: ' + pro.description,
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        _toggleFavorite(pro);
                        _onSave1(pro);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
