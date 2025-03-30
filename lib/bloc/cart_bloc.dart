
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/diamond.dart';
import '../repositories/cart_repository.dart';

//Event
abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Diamond diamond;

  AddToCartEvent(this.diamond);
}

class RemoveFromCartEvent extends CartEvent {
  final String lotId;

  RemoveFromCartEvent(this.lotId);
}

class CheckCartStatusEvent extends CartEvent {
  final String lotId;

  CheckCartStatusEvent(this.lotId);
}

// States
class CartState {
  final List<Diamond> cartItems;
  final bool isLoading;
  final Map<String, bool> inCartStatus;
  final double totalCarat;
  final double totalPrice;
  final double averagePrice;
  final double averageDiscount;

  CartState({
    required this.cartItems,
    this.isLoading = false,
    this.inCartStatus = const {},
    this.totalCarat = 0.0,
    this.totalPrice = 0.0,
    this.averagePrice = 0.0,
    this.averageDiscount = 0.0,
  });

  CartState copyWith({
    List<Diamond>? cartItems,
    bool? isLoading,
    Map<String, bool>? inCartStatus,
    double? totalCarat,
    double? totalPrice,
    double? averagePrice,
    double? averageDiscount,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      isLoading: isLoading ?? this.isLoading,
      inCartStatus: inCartStatus ?? this.inCartStatus,
      totalCarat: totalCarat ?? this.totalCarat,
      totalPrice: totalPrice ?? this.totalPrice,
      averagePrice: averagePrice ?? this.averagePrice,
      averageDiscount: averageDiscount ?? this.averageDiscount,
    );
  }

  static CartState calculateSummary(List<Diamond> cartItems, CartState state) {
    if (cartItems.isEmpty) {
      return state.copyWith(
        cartItems: cartItems,
        totalCarat: 0.0,
        totalPrice: 0.0,
        averagePrice: 0.0,
        averageDiscount: 0.0,
      );
    }

    double totalCarat = 0.0;
    double totalPrice = 0.0;
    double totalDiscount = 0.0;

    for (var item in cartItems) {
      totalCarat += item.carat;
      totalPrice += item.finalAmount;
      totalDiscount += item.discount;
    }

    double averagePrice = totalPrice / cartItems.length;
    double averageDiscount = totalDiscount / cartItems.length;

    return state.copyWith(
      cartItems: cartItems,
      totalCarat: totalCarat,
      totalPrice: totalPrice,
      averagePrice: averagePrice,
      averageDiscount: averageDiscount,
    );
  }
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(CartState(
    cartItems: [],
    isLoading: false,
  )) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<CheckCartStatusEvent>(_onCheckCartStatus);

    add(LoadCartEvent());
  }

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));

    final cartItems = await _repository.getCartItems();
    emit(CartState.calculateSummary(cartItems, state.copyWith(isLoading: false)));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));

    await _repository.addToCart(event.diamond);

    // Update in-cart status for this item
    final newStatus = Map<String, bool>.from(state.inCartStatus);
    newStatus[event.diamond.lotId] = true;

    // Reload cart to update summary
    final cartItems = await _repository.getCartItems();
    emit(CartState.calculateSummary(
        cartItems,
        state.copyWith(
          isLoading: false,
          inCartStatus: newStatus,
        )
    ));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));

    await _repository.removeFromCart(event.lotId);

    // Update in-cart status for this item
    final newStatus = Map<String, bool>.from(state.inCartStatus);
    newStatus[event.lotId] = false;

    // Reload cart to update summary
    final cartItems = await _repository.getCartItems();
    emit(CartState.calculateSummary(
        cartItems,
        state.copyWith(
          isLoading: false,
          inCartStatus: newStatus,
        )
    ));
  }

  void _onCheckCartStatus(CheckCartStatusEvent event, Emitter<CartState> emit) async {
    final isInCart = await _repository.isInCart(event.lotId);

    final newStatus = Map<String, bool>.from(state.inCartStatus);
    newStatus[event.lotId] = isInCart;

    emit(state.copyWith(inCartStatus: newStatus));
  }
}