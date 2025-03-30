
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/filter_params.dart';
import '../model/diamond.dart';
import '../repositories/diamond_repository.dart';

// Events
abstract class FilterEvent {}

class UpdateFilterEvent extends FilterEvent {
  final FilterParams params;
  UpdateFilterEvent(this.params);
}

class ResetFilterEvent extends FilterEvent {}

class InitFilterOptionsEvent extends FilterEvent {}

class FetchDiamondsEvent extends FilterEvent {
  final FilterParams params;
  FetchDiamondsEvent(this.params);
}

// States
class FilterState {
  final FilterParams filterParams;
  final Map<String, List<String>> filterOptions;
  final List<Diamond> diamonds;
  final bool isLoading;
  final String? errorMessage;

  FilterState({
    required this.filterParams,
    required this.filterOptions,
    this.diamonds = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FilterState copyWith({
    FilterParams? filterParams,
    Map<String, List<String>>? filterOptions,
    List<Diamond>? diamonds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FilterState(
      filterParams: filterParams ?? this.filterParams,
      filterOptions: filterOptions ?? this.filterOptions,
      diamonds: diamonds ?? this.diamonds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  FilterState loading() {
    return copyWith(isLoading: true, errorMessage: null);
  }

  FilterState error(String message) {
    return copyWith(isLoading: false, errorMessage: message);
  }

  FilterState success({
    FilterParams? filterParams,
    Map<String, List<String>>? filterOptions,
    List<Diamond>? diamonds,
  }) {
    return copyWith(
      filterParams: filterParams,
      filterOptions: filterOptions,
      diamonds: diamonds,
      isLoading: false,
      errorMessage: null,
    );
  }
}

// BLoC
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final DiamondRepository _repository;

  FilterBloc(this._repository) : super(FilterState(
    filterParams: FilterParams(),
    filterOptions: {},
    isLoading: true,
  )) {
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<ResetFilterEvent>(_onResetFilter);
    on<InitFilterOptionsEvent>(_onInitFilterOptions);
    on<FetchDiamondsEvent>(_onFetchDiamonds);

    // Initialize filter options
    add(InitFilterOptionsEvent());
  }

  void _onUpdateFilter(UpdateFilterEvent event, Emitter<FilterState> emit) {
    emit(state.success(filterParams: event.params));
    // Automatically fetch diamonds with new filters
    add(FetchDiamondsEvent(event.params));
  }

  void _onResetFilter(ResetFilterEvent event, Emitter<FilterState> emit) {
    final emptyParams = FilterParams();
    emit(state.success(filterParams: emptyParams));
    // Fetch diamonds with reset filters
    add(FetchDiamondsEvent(emptyParams));
  }

  void _onInitFilterOptions(InitFilterOptionsEvent event, Emitter<FilterState> emit) {
    try {
      // Show loading state
      emit(state.loading());

      // Get filter options from repository
      final filterOptions = _repository.getFilterOptions();

      // Check if options are empty
      if (filterOptions.isEmpty || filterOptions.values.any((list) => list.isEmpty)) {
        emit(state.error('Failed to load filter options'));
        return;
      }

      // Emit success state with filter options
      emit(state.success(filterOptions: filterOptions));

      // Fetch initial diamonds
      add(FetchDiamondsEvent(state.filterParams));
    } catch (e) {
      print('Error initializing filter options: $e');
      emit(state.error('Failed to load filter options: $e'));
    }
  }

  void _onFetchDiamonds(FetchDiamondsEvent event, Emitter<FilterState> emit) {
    try {
      // Show loading state for diamonds
      emit(state.loading());

      // Get diamonds from repository
      final diamonds = _repository.getDiamonds(event.params);

      // Emit success state with diamonds
      emit(state.success(diamonds: diamonds));
    } catch (e) {
      print('Error fetching diamonds: $e');
      emit(state.error('Failed to fetch diamonds: $e'));
    }
  }
}