import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class EditProfileFormEvent {}

class SetImagePath extends EditProfileFormEvent {
  final String path;
  SetImagePath(this.path);
}

class SetGender extends EditProfileFormEvent {
  final String gender;
  SetGender(this.gender);
}

class SetBirthdate extends EditProfileFormEvent {
  final String birthdate;
  SetBirthdate(this.birthdate);
}

// State
class EditProfileFormState {
  final String? pickedImagePath;
  final String gender;
  final String birthdate;

  const EditProfileFormState({
    this.pickedImagePath,
    this.gender = '',
    this.birthdate = '',
  });

  EditProfileFormState copyWith({
    String? pickedImagePath,
    String? gender,
    String? birthdate,
  }) {
    return EditProfileFormState(
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
    );
  }
}

// Bloc
class EditProfileFormBloc
    extends Bloc<EditProfileFormEvent, EditProfileFormState> {
  EditProfileFormBloc({
    String initialGender = '',
    String initialBirthdate = '',
    String? initialImagePath,
  }) : super(EditProfileFormState(
          gender: initialGender,
          birthdate: initialBirthdate,
          pickedImagePath: initialImagePath,
        )) {
    on<SetImagePath>((event, emit) {
      emit(state.copyWith(pickedImagePath: event.path));
    });
    on<SetGender>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });
    on<SetBirthdate>((event, emit) {
      emit(state.copyWith(birthdate: event.birthdate));
    });
  }
}
