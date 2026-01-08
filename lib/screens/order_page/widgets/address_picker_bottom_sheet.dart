import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/ghn/ghn_province.dart';
import 'package:meko_project/models/body/ghn/ghn_district.dart';
import 'package:meko_project/models/body/ghn/ghn_ward.dart';
import 'package:meko_project/repository/ghn/ghn_address_repo.dart';

/// Kết quả trả về sau khi chọn địa chỉ
class AddressPickerResult {
  final GHNProvince province;
  final GHNDistrict district;
  final GHNWard ward;
  final String fullAddress;

  AddressPickerResult({
    required this.province,
    required this.district,
    required this.ward,
    required this.fullAddress,
  });
}

/// Bottom sheet chọn địa chỉ tỉnh/huyện/xã
class AddressPickerBottomSheet extends StatefulWidget {
  const AddressPickerBottomSheet({super.key});

  static Future<AddressPickerResult?> show(BuildContext context) {
    return showModalBottomSheet<AddressPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddressPickerBottomSheet(),
    );
  }

  @override
  State<AddressPickerBottomSheet> createState() => _AddressPickerBottomSheetState();
}

class _AddressPickerBottomSheetState extends State<AddressPickerBottomSheet> {
  final GHNAddressRepo _addressRepo = getIt<GHNAddressRepo>();
  final TextEditingController _searchController = TextEditingController();

  // Data
  List<GHNProvince> _provinces = [];
  List<GHNDistrict> _districts = [];
  List<GHNWard> _wards = [];

  // Filtered data
  List<GHNProvince> _filteredProvinces = [];
  List<GHNDistrict> _filteredDistricts = [];
  List<GHNWard> _filteredWards = [];

  // Selected
  GHNProvince? _selectedProvince;
  GHNDistrict? _selectedDistrict;
  GHNWard? _selectedWard;

  // Loading states
  bool _isLoadingProvinces = true;
  bool _isLoadingDistricts = false;
  bool _isLoadingWards = false;

  // Current step: 0 = province, 1 = district, 2 = ward
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProvinces() async {
    setState(() => _isLoadingProvinces = true);
    final provinces = await _addressRepo.getProvinces();
    setState(() {
      _provinces = provinces;
      _filteredProvinces = provinces;
      _isLoadingProvinces = false;
    });
  }

  Future<void> _loadDistricts(int provinceId) async {
    setState(() => _isLoadingDistricts = true);
    final districts = await _addressRepo.getDistricts(provinceId);
    setState(() {
      _districts = districts;
      _filteredDistricts = districts;
      _isLoadingDistricts = false;
    });
  }

  Future<void> _loadWards(int districtId) async {
    setState(() => _isLoadingWards = true);
    final wards = await _addressRepo.getWards(districtId);
    setState(() {
      _wards = wards;
      _filteredWards = wards;
      _isLoadingWards = false;
    });
  }

  void _onSearch(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      switch (_currentStep) {
        case 0:
          _filteredProvinces = _provinces
              .where((p) => p.provinceName.toLowerCase().contains(lowerQuery))
              .toList();
          break;
        case 1:
          _filteredDistricts = _districts
              .where((d) => d.districtName.toLowerCase().contains(lowerQuery))
              .toList();
          break;
        case 2:
          _filteredWards = _wards
              .where((w) => w.wardName.toLowerCase().contains(lowerQuery))
              .toList();
          break;
      }
    });
  }

  void _selectProvince(GHNProvince province) {
    setState(() {
      _selectedProvince = province;
      _selectedDistrict = null;
      _selectedWard = null;
      _districts = [];
      _wards = [];
      _currentStep = 1;
      _searchController.clear();
    });
    _loadDistricts(province.provinceId);
  }

  void _selectDistrict(GHNDistrict district) {
    setState(() {
      _selectedDistrict = district;
      _selectedWard = null;
      _wards = [];
      _currentStep = 2;
      _searchController.clear();
    });
    _loadWards(district.districtId);
  }

  void _selectWard(GHNWard ward) {
    setState(() {
      _selectedWard = ward;
    });
    _confirmSelection();
  }

  void _confirmSelection() {
    if (_selectedProvince != null && _selectedDistrict != null && _selectedWard != null) {
      final fullAddress = '${_selectedWard!.wardName}, ${_selectedDistrict!.districtName}, ${_selectedProvince!.provinceName}';
      Navigator.pop(
        context,
        AddressPickerResult(
          province: _selectedProvince!,
          district: _selectedDistrict!,
          ward: _selectedWard!,
          fullAddress: fullAddress,
        ),
      );
    }
  }

  void _goBack() {
    setState(() {
      _searchController.clear();
      if (_currentStep == 2) {
        _currentStep = 1;
        _selectedWard = null;
        _filteredDistricts = _districts;
      } else if (_currentStep == 1) {
        _currentStep = 0;
        _selectedDistrict = null;
        _filteredProvinces = _provinces;
      } else {
        Navigator.pop(context);
      }
    });
  }

  String get _title {
    switch (_currentStep) {
      case 0:
        return 'Chọn Tỉnh/Thành phố';
      case 1:
        return 'Chọn Quận/Huyện';
      case 2:
        return 'Chọn Phường/Xã';
      default:
        return 'Chọn địa chỉ';
    }
  }

  String get _searchHint {
    switch (_currentStep) {
      case 0:
        return 'Tìm tỉnh/thành phố...';
      case 1:
        return 'Tìm quận/huyện...';
      case 2:
        return 'Tìm phường/xã...';
      default:
        return 'Tìm kiếm...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSelectedAddress(),
          _buildSearchBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _currentStep == 0 ? Icons.close : Icons.arrow_back,
                size: 20,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddress() {
    if (_selectedProvince == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.cMain.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.cMain.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColor.cMain, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildCurrentAddress(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildCurrentAddress() {
    final parts = <String>[];
    if (_selectedWard != null) parts.add(_selectedWard!.wardName);
    if (_selectedDistrict != null) parts.add(_selectedDistrict!.districtName);
    if (_selectedProvince != null) parts.add(_selectedProvince!.provinceName);
    return parts.join(', ');
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: _searchHint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildProvinceList();
      case 1:
        return _buildDistrictList();
      case 2:
        return _buildWardList();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProvinceList() {
    if (_isLoadingProvinces) {
      return const Center(child: CircularProgressIndicator(color: AppColor.cMain));
    }

    if (_filteredProvinces.isEmpty) {
      return _buildEmptyState('Không tìm thấy tỉnh/thành phố');
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredProvinces.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final province = _filteredProvinces[index];
        return _buildListItem(
          title: province.provinceName,
          isSelected: _selectedProvince?.provinceId == province.provinceId,
          onTap: () => _selectProvince(province),
        );
      },
    );
  }

  Widget _buildDistrictList() {
    if (_isLoadingDistricts) {
      return const Center(child: CircularProgressIndicator(color: AppColor.cMain));
    }

    if (_filteredDistricts.isEmpty) {
      return _buildEmptyState('Không tìm thấy quận/huyện');
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredDistricts.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final district = _filteredDistricts[index];
        return _buildListItem(
          title: district.districtName,
          isSelected: _selectedDistrict?.districtId == district.districtId,
          onTap: () => _selectDistrict(district),
        );
      },
    );
  }

  Widget _buildWardList() {
    if (_isLoadingWards) {
      return const Center(child: CircularProgressIndicator(color: AppColor.cMain));
    }

    if (_filteredWards.isEmpty) {
      return _buildEmptyState('Không tìm thấy phường/xã');
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredWards.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final ward = _filteredWards[index];
        return _buildListItem(
          title: ward.wardName,
          isSelected: _selectedWard?.wardCode == ward.wardCode,
          onTap: () => _selectWard(ward),
        );
      },
    );
  }

  Widget _buildListItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColor.cMain : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColor.cMain, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
