import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/api.dart';
import '../../model/category.dart';
import '../../model/product.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;

  const ProductAdd({super.key, this.isUpdate = false, this.productModel});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? selectedCate;
  List<CategoryModel> categories = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final img = _imgController.text;
    final catId = int.tryParse(selectedCate ?? '0') ?? 0;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addProduct(
      ProductModel(
        id: 0,
        name: name,
        imageUrl: img,
        categoryId: catId,
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final img = _imgController.text;
    final catId = int.tryParse(selectedCate ?? '0') ?? 0;
    var pref = await SharedPreferences.getInstance();

    await APIRepository().updateProduct(
      ProductModel(
        id: widget.productModel!.id,
        name: name,
        imageUrl: img,
        categoryId: catId,
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('accountID').toString(),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  _getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {
      categories = temp;
      if (categories.isNotEmpty) {
        selectedCate = categories.first.id.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();

    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _desController.text = widget.productModel!.description;
      _priceController.text = widget.productModel!.price.toString();
      _imgController.text = widget.productModel!.imageUrl;
      selectedCate = widget.productModel!.categoryId.toString();
    }
    titleText = widget.isUpdate ? "Cập nhật sản phẩm" : "Thêm sản phẩm mới";
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget1(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            titleText,
            style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 4,
        ),
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color.fromARGB(255, 249, 177, 64),
          //       Color(0xFFFDE1AC),
          //     ],
          //   ),
          // ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        'Tên sản phẩm',
                        _nameController,
                        hintText: 'Nhập tên sản phẩm',
                        icon: Icons.label,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        'Giá tiền',
                        _priceController,
                        hintText: 'Nhập giá tiền',
                        keyboardType: TextInputType.number,
                        icon: Icons.attach_money,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        'Địa chỉ hình ảnh',
                        _imgController,
                        hintText: 'Nhập địa chỉ hình ảnh (URL)',
                        icon: Icons.image,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        'Mô tả',
                        _desController,
                        hintText: 'Nhập mô tả',
                        maxLines: 1,
                        icon: Icons.description,
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Danh mục',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        value: selectedCate,
                        items: categories
                            .map((item) => DropdownMenuItem<String>(
                          value: item.id.toString(),
                          child: Text(item.name),
                        ))
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedCate = item;
                          });
                        },
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () {
                          widget.isUpdate ? _onUpdate() : _onSave();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          backgroundColor: const Color.fromARGB(
                              255, 44, 119, 210), // Sử dụng màu nền của ElevatedButton
                          foregroundColor: Colors.white, // Màu chữ
                          textStyle: GoogleFonts.raleway(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Bo tròn góc
                          ),
                        ),
                        child: Text(
                          widget.isUpdate ? 'Cập nhật' : 'Lưu',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        String? hintText,
        int? maxLines = 1,
        TextInputType? keyboardType,
        IconData? icon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
        ),
      ],
    );
  }
}
