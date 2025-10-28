import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meko_project/models/body/category/category_model.dart';

class TabHomeState extends Equatable {
  final String selectedTab;
  final bool isAppBarCollapsed;
  final List<Category> categories;
  final bool categoriesLoading;
  final String? categoriesError;
  final int productCount;

  const TabHomeState({
    required this.selectedTab,
    required this.isAppBarCollapsed,
    required this.categories,
    required this.categoriesLoading,
    this.categoriesError,
    required this.productCount,
  });

  factory TabHomeState.initial() {
    return const TabHomeState(
      selectedTab: 'Dành cho bạn',
      isAppBarCollapsed: false,
      categories: [],
      categoriesLoading: true,
      categoriesError: null,
      productCount: 0,
    );
  }

  TabHomeState copyWith({
    String? selectedTab,
    bool? isAppBarCollapsed,
    List<Category>? categories,
    bool? categoriesLoading,
    String? categoriesError,
    int? productCount,
  }) {
    return TabHomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      isAppBarCollapsed: isAppBarCollapsed ?? this.isAppBarCollapsed,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      categoriesError: categoriesError ?? this.categoriesError,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    isAppBarCollapsed,
    categories,
    categoriesLoading,
    categoriesError,
    productCount,
  ];
}