import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String? authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-3f6c4-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);
    print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // final extractedData = json.decode(response.body);
    print(extractedData);
    // if (extractedData == null) {
    //   return;
    // }
    print('1');
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'] as double,
          datetime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id']! as String,
                  title: item['title']! as String,
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    print('2');
    _orders = loadedOrders;
    print(_orders);
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-3f6c4-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dataTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        // id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        datetime: timestamp,
      ),
    );
    print(json.decode(response.body)['name']);
    print(_orders);
    print(cartProducts);
    print(cartProducts[0].id);
    print(cartProducts[0].price);
    print(cartProducts[0].quantity);
    print(cartProducts[0].title);
    print(total);
    print(timestamp);
    notifyListeners();
  }
}
