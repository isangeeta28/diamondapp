import 'package:diamondapp/screen/cart_page.dart';
import 'package:diamondapp/screen/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';
import 'bloc/diamond_filter_bloc.dart';
import 'bloc/diamond_result_bloc.dart';
import 'repositories/diamond_repository.dart';
import 'repositories/cart_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Repositories
    final diamondRepository = DiamondRepository();
    final cartRepository = CartRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<FilterBloc>(
          create: (context) => FilterBloc(diamondRepository),
        ),
        BlocProvider<ResultBloc>(
          create: (context) => ResultBloc(diamondRepository),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(cartRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Diamond Marketplace',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FilterPage(),
          '/cart': (context) => CartPage(),
        },
      ),
    );
  }
}

