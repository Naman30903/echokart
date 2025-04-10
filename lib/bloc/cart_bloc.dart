import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:echokart/data/models/product.dart';
import 'package:echokart/data/models/cart_item.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCart(this.product, {this.quantity = 1});

  @override
  List<Object?> get props => [product.id, quantity];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

// State
class CartState extends Equatable {
  final List<CartItem> items;
  final double totalPrice;
  final int itemCount;

  const CartState({
    this.items = const [],
    this.totalPrice = 0.0,
    this.itemCount = 0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? totalPrice,
    int? itemCount,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  List<Object?> get props => [items, totalPrice, itemCount];
}

// BLoC
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);

    // Check if product already in cart
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      // Add new item
      currentItems.add(
        CartItem(product: event.product, quantity: event.quantity),
      );
    }

    // Calculate new totals
    final totalPrice = currentItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    final itemCount = currentItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    emit(
      state.copyWith(
        items: currentItems,
        totalPrice: totalPrice,
        itemCount: itemCount,
      ),
    );
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items)
      ..removeWhere((item) => item.product.id == event.productId);

    // Calculate new totals
    final totalPrice = currentItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    final itemCount = currentItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    emit(
      state.copyWith(
        items: currentItems,
        totalPrice: totalPrice,
        itemCount: itemCount,
      ),
    );
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);

    final index = currentItems.indexWhere(
      (item) => item.product.id == event.productId,
    );

    if (index >= 0) {
      if (event.quantity <= 0) {
        // Remove item if quantity is 0 or less
        currentItems.removeAt(index);
      } else {
        // Update quantity
        final item = currentItems[index];
        currentItems[index] = item.copyWith(quantity: event.quantity);
      }

      // Calculate new totals
      final totalPrice = currentItems.fold<double>(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

      final itemCount = currentItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      emit(
        state.copyWith(
          items: currentItems,
          totalPrice: totalPrice,
          itemCount: itemCount,
        ),
      );
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
