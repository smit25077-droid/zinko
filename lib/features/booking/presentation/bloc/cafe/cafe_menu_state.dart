import 'package:equatable/equatable.dart';

class CafeMenuState extends Equatable {
  final List<Map<String, dynamic>> menuItems;
  final bool isSuccess;

  const CafeMenuState({required this.menuItems, this.isSuccess = false});

  factory CafeMenuState.initial() {
    return const CafeMenuState(menuItems: [
      {
        'name': 'Cappuccino',
        'price': 4,
        'image':
            'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=400&q=80',
        'quantity': 0,
      },
      {
        'name': 'Club Sandwich',
        'price': 6,
        'image':
            'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?auto=format&fit=crop&w=400&q=80',
        'quantity': 0,
      },
      {
        'name': 'Green Tea',
        'price': 3,
        'image':
            'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?auto=format&fit=crop&w=400&q=80',
        'quantity': 0,
      },
    ]);
  }

  double get totalOrder => menuItems.fold(
      0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  List<Object?> get props => [menuItems, isSuccess];

  CafeMenuState copyWith({
    List<Map<String, dynamic>>? menuItems,
    bool? isSuccess,
  }) {
    return CafeMenuState(
      menuItems: menuItems ?? this.menuItems,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
