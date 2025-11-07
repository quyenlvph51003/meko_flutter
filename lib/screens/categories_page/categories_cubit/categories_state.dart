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
  }) {
    return CategoriesState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      rebuild: rebuild ?? this.rebuild,
      provinces: provinces ?? this.provinces,
      wards: wards ?? this.wards,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
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
  ];
}
