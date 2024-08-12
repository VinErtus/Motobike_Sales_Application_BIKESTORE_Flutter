import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:bikestore/app/model/cart.dart';

class CheckoutPage extends StatefulWidget {
  final List<Cart> selectedProducts;
  final double totalAmount;

  const CheckoutPage({
    Key? key,
    required this.selectedProducts,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const double exchangeRate = 25000; // 1 USD = 25,000 VND

  void _handlePayment() {
    // Implement payment handling logic here if needed
    print("Handling payment");
  }

  @override
  Widget build(BuildContext context) {
    double usdAmount = widget.totalAmount / exchangeRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thanh toán Paypal",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId: "AS19hZt7yDt6AxN-8ACS7RLAnfNIYg1_YXyHjh2pXgWWFBD9SXw8Wg5UQX0ymSLmEe17s6CDKlNHhkyU",
                secretKey: "ENSvwb0nKmXxosUGuG6RNsDhk4FprIkypMjt24-fF_CcMxWcE4UUFT3I1cBNJD5ADUrbv9GPGYEbwgzd",
                returnURL: "https://example.com/success", // Replace with actual success URL
                cancelURL: "https://example.com/cancel", // Replace with actual cancel URL
                transactions: [
                  {
                    "amount": {
                      "total": usdAmount.toStringAsFixed(2),
                      "currency": "USD",
                      "details": {
                        "subtotal": usdAmount.toStringAsFixed(2),
                        "shipping": '0',
                        "shipping_discount": 0,
                      }
                    },
                    "description": "The payment transaction description.",
                    "item_list": {
                      "items": widget.selectedProducts.map((product) {
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
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}

// Assuming you have these SuccessPage and FailurePage widgets implemented elsewhere
class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán thành công'),
      ),
      body: Center(
        child: Text(
          'Bạn đã thanh toán thành công',
          style: TextStyle(fontSize: 20.0, color: Colors.green),
        ),
      ),
    );
  }
}

class FailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Failed'),
      ),
      body: Center(
        child: Text(
          'There was an issue with your payment. Please try again.',
          style: TextStyle(fontSize: 20.0, color: Colors.red),
        ),
      ),
    );
  }
}
