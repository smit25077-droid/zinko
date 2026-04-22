import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/cafe/domain/entities/cafe_entities.dart';

abstract class CafeState extends Equatable {
  const CafeState();

  @override
  List<Object?> get props => [];
}

class CafeInitial extends CafeState {}

class CafeLoading extends CafeState {}

class CafeLoaded extends CafeState {
  final List<Cafe> cafes;
  final List<String> categories;

  const CafeLoaded({required this.cafes, this.categories = const ['All']});

  @override
  List<Object?> get props => [cafes, categories];
}

class CafeWishlistLoaded extends CafeState {
  final List<Cafe> wishlist;

  const CafeWishlistLoaded({required this.wishlist});

  @override
  List<Object?> get props => [wishlist];
}

class CafeError extends CafeState {
  final String message;

  const CafeError({required this.message});

  @override
  List<Object?> get props => [message];
}
