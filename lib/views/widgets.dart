import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarHeader({
    super.key,
    this.title = 'Sandwich Counter',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const OrderScreen(),
              ),
            );
          },
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
      title: Text(
        title,
        style: heading1,
      ),
      actions: [
        Consumer<Cart>(
          builder: (context, cart, child) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                );
              },
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 4),
                  Text('${cart.countOfItems}'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
