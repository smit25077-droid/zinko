import 'package:equatable/equatable.dart';
import '../../domain/entities/cafe_entities.dart';

abstract class CafeState extends Equatable {
  const CafeState();

  @override
  List<Object?> get props => [];
}

class CafeInitial extends CafeState {}

class CafeLoading extends CafeState {}

class CafeLoaded extends CafeState {
  final List<Cafe> cafes;

  const CafeLoaded({required this.cafes});

  @override
  List<Object?> get props => [cafes];
}

class CafeError extends CafeState {
  final String message;

  const CafeError({required this.message});

  @override
  List<Object?> get props => [message];
}
