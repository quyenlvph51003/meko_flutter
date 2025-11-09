part of 'categories_vm.dart';

class CategoriesState extends Equatable {
  final List<ListingItem> listings;
  final bool isLoading;
  final int rebuild;
  final List<ProvinceModel> provinces;
  final List<WardModel> wards;
  final List<Category> categories;
  Category? selectedCategory;
  ProvinceModel? selectedProvince;
  WardModel? selectedWard;
  String? addressFilter;
  final int page;
  final bool isLastPage;
  final bool isFilter; //khi chọn nút tìm thì mới tìm theo condition đó
  Map<int, bool>? isFavorite;
  CategoriesState({
    required this.listings,
    required this.isLoading,
    required this.rebuild,
    required this.provinces,
    required this.wards,
    required this.categories,
    this.selectedCategory,
    this.selectedProvince,
    this.selectedWard,
    this.addressFilter,
    required this.page,
    required this.isLastPage,
    required this.isFilter,
    this.isFavorite,
  });

  CategoriesState copyWith({
    List<ListingItem>? listings,
    bool? isLoading,
    int? rebuild,
    List<ProvinceModel>? provinces,
    List<WardModel>? wards,
    List<Category>? categories,
    Category? selectedCategory,
    ProvinceModel? selectedProvince,
    WardModel? selectedWard,
    String? addressFilter,
    int? page,
    bool? isLastPage,
    bool? isFilter,
    Map<int, bool>? isFavorite,
  }) {
    return CategoriesState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      rebuild: rebuild ?? this.rebuild,
      provinces: provinces ?? this.provinces,
      wards: wards ?? this.wards,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedWard: selectedWard ?? this.selectedWard,
      addressFilter: addressFilter ?? this.addressFilter,
      page: page ?? this.page,
      isLastPage: isLastPage ?? this.isLastPage,
      isFilter: isFilter ?? this.isFilter,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  CategoriesState copyWithNullable({
    List<ListingItem>? listings,
    bool? isLoading,
    int? rebuild,
    List<ProvinceModel>? provinces,
    List<WardModel>? wards,
    List<Category>? categories,
    Category? selectedCategory,
    ProvinceModel? selectedProvince, // trực tiếp gán, có thể null
    WardModel? selectedWard, // trực tiếp gán, có thể null
    String? addressFilter, // trực tiếp gán, có thể null
    int? page,
    bool? isLastPage,
    bool? isFilter,
  }) {
    return CategoriesState(
      page: page ?? this.page,
      isLastPage: isLastPage ?? this.isLastPage,
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      rebuild: rebuild ?? this.rebuild,
      provinces: provinces ?? this.provinces,
      wards: wards ?? this.wards,
      categories: categories ?? this.categories,
      isFilter: isFilter ?? this.isFilter,
      isFavorite: isFavorite ?? this.isFavorite,
      selectedCategory: selectedCategory,
      selectedProvince: selectedProvince, // nếu muốn reset thì truyền null
      selectedWard: selectedWard, // nếu muốn reset thì truyền null
      addressFilter: addressFilter, // nếu muốn reset thì truyền null
    );
  }

  @override
  List<Object?> get props => [
    listings,
    isLoading,
    rebuild,
    provinces,
    wards,
    categories,
    selectedCategory,
    selectedProvince,
    selectedWard,
    addressFilter,
    page,
    isLastPage,
    isFilter,
    isFavorite,
  ];
}
