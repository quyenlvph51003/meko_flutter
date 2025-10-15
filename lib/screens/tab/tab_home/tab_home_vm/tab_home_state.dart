import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TabHomeState extends Equatable {
  final String selectedTab;
  final bool isAppBarCollapsed;
  final List<CategoryItem> categories;
  final int productCount;

  const TabHomeState({
    required this.selectedTab,
    required this.isAppBarCollapsed,
    required this.categories,
    required this.productCount,
  });

  factory TabHomeState.initial() {
    return TabHomeState(
      selectedTab: 'Dành cho bạn',
      isAppBarCollapsed: false,
      categories: [
        CategoryItem(
          icon: '🏠',
          title: 'Bất động sản',
          subtitle: 'NHẤT TỐT',
          color: const Color(0xFFFF6B35),
        ),
        CategoryItem(
          icon: '🚗',
          title: 'Xe cộ',
          subtitle: 'chợ TỐT XE',
          color: const Color(0xFF4ECDC4),
        ),
        CategoryItem(
          icon: '🐕',
          title: 'Thú cưng',
          subtitle: '',
          color: const Color(0xFFFFB84D),
        ),
        CategoryItem(
          icon: '🛋️',
          title: 'Đồ gia dụng, nội thất, cá...',
          subtitle: '',
          color: const Color(0xFFFF8C42),
        ),
        CategoryItem(
          icon: '🎮',
          title: 'Giải trí, Thể thao,...',
          subtitle: '',
          color: const Color(0xFF95E1D3),
        ),
        CategoryItem(
          icon: '👔',
          title: 'Việc làm',
          subtitle: 'VIỆC TỐT',
          color: const Color(0xFFFECA57),
        ),
        CategoryItem(
          icon: '📱',
          title: 'Đồ điện tử',
          subtitle: '',
          color: const Color(0xFF9B59B6),
        ),
        CategoryItem(
          icon: '❄️',
          title: 'Tủ lạnh, máy lạnh, máy giặt',
          subtitle: '',
          color: const Color(0xFF3498DB),
        ),
        CategoryItem(
          icon: '🖨️',
          title: 'Đồ dùng văn phòng, côn...',
          subtitle: '',
          color: const Color(0xFF95A5A6),
        ),
        CategoryItem(
          icon: '👗',
          title: 'Thời trang, Đồ dù...',
          subtitle: '',
          color: const Color(0xFFE74C3C),
        ),
      ],
      productCount: 20,
    );
  }

  TabHomeState copyWith({
    String? selectedTab,
    bool? isAppBarCollapsed,
    List<CategoryItem>? categories,
    int? productCount,
  }) {
    return TabHomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      isAppBarCollapsed: isAppBarCollapsed ?? this.isAppBarCollapsed,
      categories: categories ?? this.categories,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    isAppBarCollapsed,
    categories,
    productCount,
  ];
}

class CategoryItem extends Equatable {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const CategoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  List<Object?> get props => [icon, title, subtitle, color];
}