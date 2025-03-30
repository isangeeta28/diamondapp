
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../model/diamond.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Browse Diamonds'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Summary card
              Card(
                margin: EdgeInsets.all(16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cart Summary',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16.0),
                      _buildSummaryRow('Total Items', '${state.cartItems.length}'),
                      _buildSummaryRow('Total Carat', state.totalCarat.toStringAsFixed(2)),
                      _buildSummaryRow('Total Price', '\$${state.totalPrice.toStringAsFixed(2)}'),
                      _buildSummaryRow('Average Price', '\$${state.averagePrice.toStringAsFixed(2)}'),
                      _buildSummaryRow('Average Discount', '${state.averageDiscount.toStringAsFixed(2)}%'),
                    ],
                  ),
                ),
              ),

              // Cart items list
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, state.cartItems[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Diamond diamond) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${diamond.carat} ct ${diamond.shape}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_shopping_cart, color: Colors.red),
                  onPressed: () {
                    context.read<CartBloc>().add(RemoveFromCartEvent(diamond.lotId));
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text('ID: ${diamond.lotId}'),
            Text('Color: ${diamond.color}, Clarity: ${diamond.clarity}'),
            Text('Cut: ${diamond.cut}, Polish: ${diamond.polish}, Symmetry: ${diamond.symmetry}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lab: ${diamond.lab}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$${diamond.finalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}