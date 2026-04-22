import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_request_entity.dart';
import 'package:zinko_app/features/booking/domain/usecases/create_booking.dart';

// Events
abstract class CreateBookingEvent extends Equatable {
  const CreateBookingEvent();
  @override
  List<Object?> get props => [];
}

class CreateBookingSubmittedEvent extends CreateBookingEvent {
  final BookingRequestEntity request;
  const CreateBookingSubmittedEvent(this.request);
  @override
  List<Object?> get props => [request];
}

// States
abstract class CreateBookingState extends Equatable {
  const CreateBookingState();
  @override
  List<Object?> get props => [];
}

class CreateBookingInitial extends CreateBookingState {}

class CreateBookingLoading extends CreateBookingState {}

class CreateBookingSuccess extends CreateBookingState {
  final BookingResponseEntity response;
  const CreateBookingSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class CreateBookingError extends CreateBookingState {
  final String message;
  const CreateBookingError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  final CreateBookingUseCase createBookingUseCase;

  CreateBookingBloc({required this.createBookingUseCase})
      : super(CreateBookingInitial()) {
    on<CreateBookingSubmittedEvent>((event, emit) async {
      emit(CreateBookingLoading());
      try {
        final result = await createBookingUseCase(event.request);
        emit(CreateBookingSuccess(result));
      } catch (e) {
        emit(CreateBookingError(e.toString()));
      }
    });
  }
}
