import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(CartItemEntity item);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeFromCart(int productId);
  Future<void> clearCart();
}
