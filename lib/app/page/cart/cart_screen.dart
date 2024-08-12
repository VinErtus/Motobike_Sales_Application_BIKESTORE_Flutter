import 'package:bikestore/app/widget_common/bg1_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bikestore/app/data/sqlite.dart';
import 'package:bikestore/app/model/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bikestore/app/data/api.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:bikestore/app/page/home/home_screen.dart';

import '../../../main.dart';
import '../../../mainpage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Cart> cartProducts = [];
  Set<int> selectedIndices = {};
  bool editMode = false;
  static const double exchangeRate = 25000; // 1 USD = 25,000 VND


  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void _getProducts() async {
    List<Cart> products = await _databaseHelper.products();
    setState(() {
      cartProducts = products;
    });
  }

  double calculateTotalPayment() {
    double total = 0.0;
    for (int index in selectedIndices) {
      Cart product = cartProducts[index];
      total += product.price * product.count;
    }
    return total;
  }

  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  void deleteSelectedProducts() async {
    List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();

    for (Cart product in selectedProducts) {
      await _databaseHelper.deleteProduct(product.productID);
    }

    setState(() {
      _getProducts();
      selectedIndices.clear();
      editMode = false;
    });
  }

  void selectAll() {
    setState(() {
      if (selectedIndices.length == cartProducts.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set<int>.from(cartProducts.asMap().keys);
      }
    });
  }

  void _handlePayment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();

    await APIRepository().addBill(
      selectedProducts,
      pref.getString('token').toString(),
    );

    _databaseHelper.clear();
    setState(() {
      selectedIndices.clear();
    });
  }

  void showPaymentOptions(BuildContext context) {
    double totalAmountVND = calculateTotalPayment();
    double usdAmount = totalAmountVND / exchangeRate;
    List<Cart> selectedProducts = selectedIndices.map((index) => cartProducts[index]).toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.money),
                title: Text('Thanh toán bằng tiền mặt'),
                onTap: () {
                  Navigator.pop(context);
                  _handlePayment();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuccessPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Thanh toán bằng PayPal'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PaypalCheckout(
                      sandboxMode: true,
                      clientId: "AS19hZt7yDt6AxN-8ACS7RLAnfNIYg1_YXyHjh2pXgWWFBD9SXw8Wg5UQX0ymSLmEe17s6CDKlNHhkyU",
                      secretKey: "ENSvwb0nKmXxosUGuG6RNsDhk4FprIkypMjt24-fF_CcMxWcE4UUFT3I1cBNJD5ADUrbv9GPGYEbwgzd",
                      returnURL: "success.snippetcoder.com",
                      cancelURL: "cancel.snippetcoder.com",
                      transactions: [
                        {
                          "amount": {
                            "total": usdAmount.toStringAsFixed(2),
                            "currency": "USD",
                            "details": {
                              "subtotal": usdAmount.toStringAsFixed(2),
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          "item_list": {
                            "items": selectedProducts.map((product) {
                              return {
                                "name": product.name,
                                "quantity": product.count,
                                "price": (product.price / exchangeRate).toStringAsFixed(2),
                                "currency": "USD",
                              };
                            }).toList(),
                          }
                        }
                      ],
                      note: "Contact us for any questions on your order.",
                      onSuccess: (Map params) async {
                        print("onSuccess: $params");
                        _handlePayment();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SuccessPage()),
                        );

                      },
                      onError: (error) {
                        print("onError: $error");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FailurePage()),
                        );
                      },
                      onCancel: () {
                        print('cancelled:');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FailurePage()),
                        );
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return bgWidget1(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Text(
              'Chọn tất cả',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),

            IconButton(
              onPressed: selectAll,
              icon: Icon(
                selectedIndices.length == cartProducts.length
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: selectedIndices.length == cartProducts.length
                    ? Colors.blue
                    : Colors.grey[500],
              ),
            ),


            IconButton(
              onPressed: deleteSelectedProducts,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
              flex: 11,
              child: cartProducts.isEmpty
                  ? Center(
                child: Text('Không có sản phẩm trong giỏ hàng.'),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    final itemProduct = cartProducts[index];
                    return _buildProduct(itemProduct, index, context);
                  },
                ),
              ),
            ),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct(Cart pro, int index, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [

            ClipRRect(
              // borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 160,
                height: 100,
                child: Hero(
                  tag: "${pro.name}",
                  child: Image.network(
                    pro.img,
                    fit: BoxFit.fill, // Adjust as needed
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 175,),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(index)) {
                              selectedIndices.remove(index);
                            } else {
                              selectedIndices.add(index);
                            }
                          });
                        },
                        child: Icon(
                          selectedIndices.contains(index)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_rounded,
                          color: selectedIndices.contains(index)
                              ? Colors.blue // Change to desired selected color
                              : Colors.grey[500], // Change to desired unselected color
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Xe: ' + pro.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    child: Text(
                      'Giá: ' +
                          NumberFormat('#,##0').format(pro.price) + ' VNĐ',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Số lượng: ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _databaseHelper.minus(pro);
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                            Text(
                              '${pro.count}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _databaseHelper.add(pro);
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tổng tiền: ${NumberFormat('#,##0').format(calculateTotalPayment())}' + ' VNĐ',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextButton(
            onPressed: () => showPaymentOptions(context),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 44, 119, 210),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1),
                
              ),
              child: Row(
                children: [
                  Text('Thanh toán', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SuccessPage widget
class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán thành công'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Thanh toán của bạn đã thành công!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeBuilder screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Mainpage()),
                );
              },
              child: Text('Quay lại Trang Chính'),
            ),
          ],
        ),
      ),
    );
  }
}

// FailurePage widget
class FailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán thất bại'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Thanh toán của bạn đã thất bại!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Mainpage()),
                );
              },
              child: const Text('Quay lại Trang Chính'),
            ),
          ],
        ),
      ),
    );
  }
}
