part of 'favorite_cubit.dart';

class FavoriteState extends Equatable {
  final List<ListingItem> listings;
  final bool isLoading;
  final bool isLoadMore;
  final int page;
  final int size;
  final int total;
  final bool isLastPage;
  final Map<int, bool>? isFavorite;
  FavoriteState({
    required this.listings,
    required this.isLoading,
    required this.isLoadMore,
    required this.page,
    required this.size,
    required this.total,
    required this.isLastPage,
    this.isFavorite,
  });

  FavoriteState copyWith({
    List<ListingItem>? listings,
    bool? isLoading,
    bool? isLoadMore,
    int? page,
    int? size,
    int? total,
    bool? isLastPage,
    Map<int, bool>? isFavorite,
  }) {
    return FavoriteState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      isLastPage: isLastPage ?? this.isLastPage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [listings, isLoading, isLoadMore, page, size, total, isLastPage, isFavorite];
}
