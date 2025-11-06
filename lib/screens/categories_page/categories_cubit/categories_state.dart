part of 'categories_vm.dart';

class CategoriesState extends Equatable {
  final List<ListingItem> listings;
  final bool isLoading;
  final int rebuild;
  CategoriesState({required this.listings, required this.isLoading, required this.rebuild});

  CategoriesState copyWith({List<ListingItem>? listings, bool? isLoading, int? rebuild}) {
    return CategoriesState(listings: listings ?? this.listings, isLoading: isLoading ?? this.isLoading, rebuild: rebuild ?? this.rebuild);
  }

  @override
  List<Object?> get props => [listings, isLoading, rebuild];
}
