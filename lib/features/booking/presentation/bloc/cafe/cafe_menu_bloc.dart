import 'package:flutter_bloc/flutter_bloc.dart';
import 'cafe_menu_event.dart';
import 'cafe_menu_state.dart';
import '../booking_bloc.dart';
import '../booking_event.dart';

class CafeMenuBloc extends Bloc<CafeMenuEvent, CafeMenuState> {
  final BookingBloc bookingBloc;
  
  CafeMenuBloc({required this.bookingBloc}) : super(CafeMenuState.initial()) {
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ConfirmCheckInEvent>(_onConfirmCheckIn);
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CafeMenuState> emit) {
    final newList = List<Map<String, dynamic>>.from(state.menuItems.map((m) => Map<String, dynamic>.from(m)));
    final item = newList[event.index];
    int newQty = item['quantity'] + event.delta;
    if (newQty >= 0) {
      item['quantity'] = newQty;
      emit(state.copyWith(menuItems: newList));
    }
  }

  Future<void> _onConfirmCheckIn(ConfirmCheckInEvent event, Emitter<CafeMenuState> emit) async {
    bookingBloc.add(CompleteBookingEvent(event.bookingId));
    emit(state.copyWith(isSuccess: true));
  }
}
