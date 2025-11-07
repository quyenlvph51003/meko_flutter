import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'search_page_state.dart';

class SearchCubit<T> extends Cubit<SearchPageState<T>> {
  final Future<List<T>> Function(String query) onSearch;
  SearchCubit(this.onSearch) : super(SearchPageState<T>(items: [], isLoading: false, isNoData: false));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(items: [], isLoading: false, isNoData: false));
      return;
    }

    emit(state.copyWith(isLoading: true, isNoData: false));

    try {
      final results = await onSearch(query);
      emit(state.copyWith(isLoading: false, items: results, isNoData: results.isEmpty));
    } catch (e) {
      emit(state.copyWith(isLoading: false, isNoData: true));
    }
  }
}
