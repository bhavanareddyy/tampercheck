
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'selectable_cubit.freezed.dart';

@freezed
class SelectableState<T> with _$SelectableState<T> {
  const factory SelectableState.initial() = SelectableStateInitial;

  const factory SelectableState.noSelection() = SelectableStateNoSelection;

  const factory SelectableState.selected(
    Set<T> items,
  ) = SelectableStateSelected;
}

abstract class SelectableCubit<T> extends Cubit<SelectableState<T>> {
  SelectableCubit() : super(SelectableState<T>.initial());

  void select(T item) {
    state.maybeWhen(
      selected: (items) {
        emit(SelectableState<T>.selected({...items, item}));
      },
      orElse: () {
        emit(SelectableState<T>.selected({item}));
      },
    );
  }

  void selectSet(Set<T> items) {
    state.maybeWhen(
      selected: (currentItems) {
        emit(SelectableState<T>.selected({...currentItems, ...items}));
      },
      orElse: () {
        emit(SelectableState<T>.selected(items));
      },
    );
  }

  void unselect(T item) {
    state.maybeWhen(
      selected: (items) {
        final newItems = items.where((i) => i != item).toSet();
        if (newItems.isNotEmpty) {
          emit(SelectableState<T>.selected(newItems));
        } else {
          emit(SelectableState<T>.noSelection());
        }
      },
      orElse: () {
        // Nothing
      },
    );
  }

  void clearSelection() {
    emit(SelectableState<T>.noSelection());
  }

  void replaceSet(Set<T> items) {
    emit(SelectableState<T>.selected(items));
  }
}
