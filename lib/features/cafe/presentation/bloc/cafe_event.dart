import 'package:equatable/equatable.dart';

abstract class CafeEvent extends Equatable {
  const CafeEvent();

  @override
  List<Object?> get props => [];
}

class SearchCafesEvent extends CafeEvent {
  final String keyword;

  const SearchCafesEvent({this.keyword = ''});

  @override
  List<Object?> get props => [keyword];
}

class ToggleWishlistEvent extends CafeEvent {
  final int cafeId;
  final int userCode;

  const ToggleWishlistEvent({required this.cafeId, required this.userCode});

  @override
  List<Object?> get props => [cafeId, userCode];
}

class GetWishlistEvent extends CafeEvent {
  final int userCode;

  const GetWishlistEvent({required this.userCode});

  @override
  List<Object?> get props => [userCode];
}

class ResetCafeEvent extends CafeEvent {}
