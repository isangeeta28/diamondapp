
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/diamond.dart';
import '../model/filter_params.dart';
import '../repositories/diamond_repository.dart';

// Events
abstract class ResultEvent {}

class ApplyFilterEvent extends ResultEvent {
  final FilterParams params;

  ApplyFilterEvent(this.params);
}

class SortDiamondsEvent extends ResultEvent {
  final String sortBy;
  final bool ascending;

  SortDiamondsEvent({required this.sortBy, required this.ascending});
}

// States
class ResultState {
  final List<Diamond> diamonds;
  final String? sortBy;
  final bool ascending;
  final bool isLoading;

  ResultState({
    required this.diamonds,
    this.sortBy,
    this.ascending = true,
    this.isLoading = false,
  });

  ResultState copyWith({
    List<Diamond>? diamonds,
    String? sortBy,
    bool? ascending,
    bool? isLoading,
  }) {
    return ResultState(
      diamonds: diamonds ?? this.diamonds,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// BLoC
class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final DiamondRepository _repository;

  ResultBloc(this._repository) : super(ResultState(
    diamonds: [],
    isLoading: false,
  )) {
    on<ApplyFilterEvent>(_onApplyFilter);
    on<SortDiamondsEvent>(_onSortDiamonds);
  }

  void _onApplyFilter(ApplyFilterEvent event, Emitter<ResultState> emit) {
    emit(state.copyWith(isLoading: true));

    final filteredDiamonds = _repository.getFilteredDiamonds(event.params);

    // If we already have a sort order, apply it to the filtered diamonds
    List<Diamond> sortedDiamonds = List.from(filteredDiamonds);
    if (state.sortBy != null) {
      _sortDiamonds(sortedDiamonds, state.sortBy!, state.ascending);
    }

    emit(state.copyWith(
      diamonds: sortedDiamonds,
      isLoading: false,
    ));
  }

  void _onSortDiamonds(SortDiamondsEvent event, Emitter<ResultState> emit) {
    final diamonds = List<Diamond>.from(state.diamonds);

    _sortDiamonds(diamonds, event.sortBy, event.ascending);

    emit(state.copyWith(
      diamonds: diamonds,
      sortBy: event.sortBy,
      ascending: event.ascending,
    ));
  }

  void _sortDiamonds(List<Diamond> diamonds, String sortBy, bool ascending) {
    diamonds.sort((a, b) {
      dynamic aValue, bValue;

      switch (sortBy) {
        case 'finalAmount':
          aValue = a.finalAmount;
          bValue = b.finalAmount;
          break;
        case 'carat':
          aValue = a.carat;
          bValue = b.carat;
          break;
        default:
          return 0;
      }

      int result = aValue.compareTo(bValue);
      return ascending ? result : -result;
    });
  }
}