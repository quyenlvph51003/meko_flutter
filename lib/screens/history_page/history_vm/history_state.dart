part of 'history_cubit.dart';

class HistoryState extends Equatable {
  final List<ListingItem> listings;
  final bool isLoading;
  final bool isLoadMore;
  final int page;
  final int size;
  final int total;
  final bool isLastPage;
  HistoryState({
    required this.listings,
    required this.isLoading,
    required this.isLoadMore,
    required this.page,
    required this.size,
    required this.total,
    required this.isLastPage,
  });

  HistoryState copyWith({List<ListingItem>? listings, bool? isLoading, bool? isLoadMore, int? page, int? size, int? total, bool? isLastPage}) {
    return HistoryState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [listings, isLoading, isLoadMore, page, size, total, isLastPage];
}
