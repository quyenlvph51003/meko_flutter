part of 'search_page_cubit.dart';

class SearchPageState<T> extends Equatable {
  final List<T> items;
  final bool isLoading;
  final bool isNoData;

  SearchPageState({required this.items, required this.isLoading, required this.isNoData});

  SearchPageState<T> copyWith({List<T>? items, bool? isLoading, bool? isNoData}) {
    return SearchPageState<T>(items: items ?? this.items, isLoading: isLoading ?? this.isLoading, isNoData: isNoData ?? this.isNoData);
  }

  @override
  List<Object?> get props => [items, isLoading, isNoData];
}
