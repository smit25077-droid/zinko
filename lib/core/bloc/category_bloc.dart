import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CategoryEvent {}

class SelectCategory extends CategoryEvent {
  final String category;
  SelectCategory(this.category);
}

// State
class CategoryState {
  final String selectedCategory;

  const CategoryState({required this.selectedCategory});

  CategoryState copyWith({String? selectedCategory}) {
    return CategoryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required String initialCategory})
      : super(CategoryState(selectedCategory: initialCategory)) {
    on<SelectCategory>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category));
    });
  }
}
