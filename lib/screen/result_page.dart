
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/diamond_result_bloc.dart';
import '../model/diamond.dart';
import '../model/filter_params.dart';

class ResultPage extends StatefulWidget {
  final FilterParams filterParams;

  const ResultPage({Key? key, required this.filterParams}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String _sortBy = 'finalAmount';
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    // Apply filter when page loads
    context.read<ResultBloc>().add(ApplyFilterEvent(widget.filterParams));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamond Results'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sorting controls
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort by:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _sortButton('Price', 'finalAmount'),
                      _sortButton('Carat', 'carat'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Diamond list
          Expanded(
            child: BlocBuilder<ResultBloc, ResultState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.diamonds.isEmpty) {
                  return Center(
                    child: Text(
                      'No diamonds match your filters',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.diamonds.length,
                  itemBuilder: (context, index) {
                    return _buildDiamondCard(state.diamonds[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortButton(String label, String value) {
    final isSelected = _sortBy == value;

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          if (_sortBy == value) {
            // Toggle direction if already selected
            _ascending = !_ascending;
          } else {
            // New sort, default to ascending
            _sortBy = value;
            _ascending = true;
          }
        });

        // Apply sort
        context.read<ResultBloc>().add(
            SortDiamondsEvent(sortBy: value, ascending: _ascending)
        );
      },
      icon: Icon(
        _ascending
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: isSelected ? Colors.white : Colors.grey,
        size: 16.0,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : null,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
      ),
    );
  }

  Widget _buildDiamondCard(Diamond diamond) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        // Check if this diamond is in cart
        final isInCart = cartState.inCartStatus[diamond.lotId] ?? false;

        // If status is not yet known, check it
        if (!cartState.inCartStatus.containsKey(diamond.lotId)) {
          context.read<CartBloc>().add(CheckCartStatusEvent(diamond.lotId));
        }

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${diamond.lotId}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                        color: isInCart ? Colors.green : null,
                      ),
                      onPressed: () {
                        if (isInCart) {
                          context.read<CartBloc>().add(RemoveFromCartEvent(diamond.lotId));
                        } else {
                          context.read<CartBloc>().add(AddToCartEvent(diamond));
                        }
                      },
                    ),
                  ],
                ),
                Divider(),
                _buildInfoRow('Carat', '${diamond.carat}', 'Shape', '${diamond.shape}'),
                _buildInfoRow('Color', '${diamond.color}', 'Clarity', '${diamond.clarity}'),
                _buildInfoRow('Cut', '${diamond.cut}', 'Polish', '${diamond.polish}'),
                _buildInfoRow('Symmetry', '${diamond.symmetry}', 'Fluorescence', '${diamond.fluorescence}'),
                _buildInfoRow('Lab', '${diamond.lab}', 'Size', '${diamond.size}'),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount: ${diamond.discount}%',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Per Carat: \$${diamond.perCaratRate.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Final Price: \$${diamond.finalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (diamond.keyToSymbol != 'None' || diamond.labComment != 'None')
                  Divider(),
                if (diamond.keyToSymbol != 'None')
                  Text('Key Symbol: ${diamond.keyToSymbol}'),
                if (diamond.labComment != 'None')
                  Text('Lab Comment: ${diamond.labComment}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text('$label1: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(value1),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text('$label2: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(value2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}