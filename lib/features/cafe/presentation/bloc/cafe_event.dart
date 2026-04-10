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
