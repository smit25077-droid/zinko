import 'package:equatable/equatable.dart';

abstract class CafeMenuEvent extends Equatable {
  const CafeMenuEvent();
  @override
  List<Object?> get props => [];
}

class UpdateQuantityEvent extends CafeMenuEvent {
  final int index;
  final int delta;
  const UpdateQuantityEvent(this.index, this.delta);
  @override
  List<Object?> get props => [index, delta];
}

class ConfirmCheckInEvent extends CafeMenuEvent {
  final String bookingId;
  const ConfirmCheckInEvent(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}
