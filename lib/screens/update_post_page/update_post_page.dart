import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/update_post_page/post_update_vm/post_update_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';

class PostUpdateScreen extends StatefulWidget {
  const PostUpdateScreen({super.key, required this.postId});
  final int postId;
  @override
  State<PostUpdateScreen> createState() => _PostUpdateScreenState();
}

class _PostUpdateScreenState extends State<PostUpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String categoriesStr = '';
  String? _selectedCategory;
  List<XFile> _images = [];
  bool _initializedFromDetail = false;
  final List<String> _removedImageUrls = [];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _images.add(file);
      });
    }
  }

  void _showBottomLocation(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostUpdateCubit>(),
          child: BlocBuilder<PostUpdateCubit, PostUpdateState>(
            builder: (context, state) {
              final vm = context.read<PostUpdateCubit>();
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Chọn Khu vực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<PostUpdateCubit>().fetchProvinces();
                              _showBottomFilterLocation(context, isCheckProvince: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.place, color: AppColor.cMain),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${state.provinceSelectedCached?.name ?? 'Chọn tỉnh/thành phố'}',
                                      style: TextStyle(color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              if (state.provinceSelectedCached != null) {
                                _showBottomFilterLocation(context, isCheckProvince: false);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: state.provinceSelectedCached == null ? Colors.grey.shade200 : Colors.white,
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.place, color: AppColor.cMain),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${state.wardSelectedCached?.name ?? 'Chọn xã/phường'}',
                                      style: TextStyle(color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: (state.provinceSelectedCached == null || state.wardSelectedCached == null)
                                    ? Colors.grey.shade100
                                    : AppColor.cMain,
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                    color: (state.provinceSelectedCached == null || state.wardSelectedCached == null) ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              vm.saveLocation(state.provinceSelectedCached, state.wardSelectedCached);
                              Navigator.pop(ctx);
                            },
                          ),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: AppButton(
                          //     child: Text(state.provinceSelected == null ? 'Chọn tỉnh/thành phố' : 'Tiếp tục chọn Phường/Xã'),
                          //     onTap: state.provinceSelected == null
                          //         ? null
                          //         : () {
                          //             Navigator.pop(ctx);
                          //             _showBottomWard(context);
                          //           },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showBottomFilterLocation(BuildContext context, {required bool isCheckProvince}) {
    showModalBottomSheet(
      isDismissible: true, // tap ra ngoài để đóng
      backgroundColor: Colors.white, // màu background của bottom sheet
      barrierColor: Colors.black.withOpacity(0.5), // làm mờ màn hình
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostUpdateCubit>(),
          child: BlocBuilder<PostUpdateCubit, PostUpdateState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          SafeArea(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(isCheckProvince ? 'Tỉnh thành' : 'Xã phường', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1, endIndent: 0),
                    if (state.provinces.isNotEmpty && isCheckProvince)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.provinces.length,
                            itemBuilder: (cont, index) {
                              final item = state.provinces[index];
                              // bản chất 2 obj giống nhau
                              return RadioListTile<ProvinceModel>(
                                value: item,
                                groupValue: state.provinceSelected,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PostUpdateCubit>().selectProvinceCache(value);

                                    // Nếu bạn muốn đóng bottom sheet sau khi chọn thì bật dòng này:
                                    Navigator.pop(ctx);
                                  }
                                },
                                title: Text(item.name ?? ''),
                              );
                            },
                          ),
                        ),
                      ),
                    if (state.wards.isNotEmpty && !isCheckProvince)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.wards.length,
                            itemBuilder: (cont, index) {
                              final item = state.wards[index];
                              // bản chất 2 obj giống nhau
                              return RadioListTile<WardModel>(
                                value: item,
                                groupValue: state.wardSelected,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PostUpdateCubit>().selectWardCache(value);
                                    // Nếu bạn muốn đóng bottom sheet sau khi chọn thì bật dòng này:
                                    Navigator.pop(ctx);
                                  }
                                },
                                title: Text(item.name ?? ''),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _removeImage(XFile file) {
    setState(() {
      _images.remove(file);
    });
  }

  void _onSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bài viết đã được cập nhật!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật bài viết')),
      body: BlocProvider(
        create: (context) =>
            PostUpdateCubit(
                postRepository: getIt<PostRepo>(),
                categoryRepository: getIt<CategoryRepository>(),
                provinceRepository: getIt<ProvinceRepo>(),
                wardRepository: getIt<WardRepo>(),
              )
              ..fetchProvinces()
              ..init(widget.postId),
        child: BlocConsumer<PostUpdateCubit, PostUpdateState>(
          listener: (context, state) {
            if (!_initializedFromDetail && state.listing != null) {
              final item = state.listing!;
              _titleController.text = item.title;
              _descriptionController.text = item.description;
              _priceController.text = item.price;
              _phoneController.text = item.phoneNumber;
              _addressController.text = item.address;
              // pick first category if available
              if (item.categories.isNotEmpty) {
                _selectedCategory = item.categories.first;
              }
              _initializedFromDetail = true;
              print(item.status);
              print('dasdasd');
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state.isLoading == true) {
              return const Center(child: CircularProgressIndicator());
            }
            final existingImages = (state.listing?.images ?? []).where((url) => !_removedImageUrls.contains(url)).toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1️⃣ Ảnh
                  Align(
                    alignment: Alignment.centerRight, // canh phải
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // padding vừa đủ
                          decoration: BoxDecoration(
                            color: postStatusStrColor[state.listing?.status ?? PostStatus.PENDING],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            postStatusStrMapViStr[state.listing?.status ?? PostStatus.PENDING] ?? "",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(visible: state.listing?.isPinned == 1, child: const SizedBox(width: 8)),
                        Visibility(
                          visible: state.listing?.isPinned == 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // padding vừa đủ
                            decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              state.listing?.isPinned == 1 ? "Đã ghim" : "",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text('Ảnh', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.add_a_photo, size: 30, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 8),
                        for (var url in existingImages)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _removedImageUrls.add(url)),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        for (var file in _images)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(file),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // 2️⃣ Title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0), // viền khi focus
                        borderRadius: BorderRadius.circular(15), // bo góc (tùy chọn)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // viền mặc định
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Danh mục', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              context.read<PostUpdateCubit>().fetchCategory();
                              context.read<PostUpdateCubit>().setNullSubCategories();
                              _showBottomCategories(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColor.cGray.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.add, color: AppColor.cMain),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount: (state.selectedCategories?.isEmpty ?? false)
                                  ? state.listing?.categories.length ?? 0
                                  : state.selectedCategories?.length ?? 0,
                              separatorBuilder: (context, index) => const SizedBox(width: 8),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final title = (state.selectedCategories?.isEmpty ?? false)
                                    ? state.listing?.categories[index]
                                    : state.selectedCategories![index].name;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(10)),
                                  child: Text(title ?? '', style: const TextStyle(color: Colors.white)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4️⃣ Description
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0), // viền khi focus
                        borderRadius: BorderRadius.circular(15), // bo góc (tùy chọn)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // viền mặc định
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 5️⃣ Price
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Giá',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0), // viền khi focus
                        borderRadius: BorderRadius.circular(15), // bo góc (tùy chọn)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // viền mặc định
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 6️⃣ Phone
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0), // viền khi focus
                        borderRadius: BorderRadius.circular(15), // bo góc (tùy chọn)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // viền mặc định
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 7️⃣ Khu vực
                  Text('Khu vực', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showBottomLocation(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.place, color: AppColor.cMain),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${state.provinceSelected?.name ?? state.listing?.provinceName} • ${state.wardSelected?.name ?? state.listing?.wardName}',
                              style: TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 8️⃣ Address detail
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ chi tiết',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0), // viền khi focus
                        borderRadius: BorderRadius.circular(15), // bo góc (tùy chọn)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5), // viền mặc định
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Visibility(visible: state.listing?.status != 'VIOLATION' && state.listing?.status != 'REJECTED', child: const SizedBox(height: 24)),
                  Visibility(visible: state.listing?.status == 'VIOLATION', child: const SizedBox(height: 10)),
                  Visibility(
                    visible: state.listing?.status == 'VIOLATION',
                    child: Text('Lí do vi phạm: ${state.listing?.reasonViolation ?? ''}', style: TextStyle(color: Colors.red, fontSize: 15)),
                  ),
                  Visibility(
                    visible: state.listing?.status == 'REJECTED',
                    child: Text(
                      'Lí do từ chối: ${state.listing?.reasonReject ?? ''}. Vui lòng cập nhật lại bài viết',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Visibility(visible: state.listing?.status == 'REJECTED', child: const SizedBox(height: 24)),
                  Text(
                    'Bài viết hết hạn vào ngày: ${FormatUtils.formatDateNoMinitues(state.listing?.expiredAt ?? DateTime.now())}',
                    style: TextStyle(color: state.listing?.status == 'EXPIRED' ? Colors.red : Colors.grey, fontSize: 16),
                  ),
                  if (state.listing?.status == 'EXPIRED') ...[
                    Visibility(visible: state.userPayment != null, child: const SizedBox(height: 8)),
                    Visibility(
                      visible: state.userPayment != null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Gói đăng mới: ${state.userPayment?.packageName}', style: TextStyle(color: AppColor.cMain, fontSize: 16)),
                          ),
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.of(context).pushNamed(AppRouterPaths.createPurcharsePost);
                              if (result != null) {
                                context.read<PostUpdateCubit>().setUserPayment(result as UserPaymentModel);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.edit, color: AppColor.cMain),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Action buttons by status
                  if (state.listing?.status == 'APPROVED')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                              child: Text('Ẩn bài', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          onTap: () {
                            context.read<PostUpdateCubit>().updateStatusPost(status: PostStatus.HIDDEN, context: context);
                          },
                        ),
                      ),
                    ),
                  if (state.listing?.status == 'HIDDEN')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                              child: Text('Hiển thị', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          onTap: () {
                            context.read<PostUpdateCubit>().updateStatusPost(status: PostStatus.APPROVED, context: context);
                          },
                        ),
                      ),
                    ),
                  if (state.listing?.status == 'REJECTED')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                              child: Text('Gửi phê duyệt chỉnh sửa', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                          onTap: () {
                            context.read<PostUpdateCubit>().updateStatusPost(status: PostStatus.PENDING, context: context);
                          },
                        ),
                      ),
                    ),
                  if (state.listing?.status == 'EXPIRED') ...[
                    SizedBox(
                      width: double.infinity,
                      child: AppButtonCommon(
                        text: state.userPayment != null ? 'Xác nhận gia hạn' : 'Gia hạn bài viết',
                        backgroundColor: AppColor.cGray,
                        onPressed: () async {
                          if (state.userPayment != null) {
                            context.read<PostUpdateCubit>().extensionPost(postId: state.listing?.id ?? 0, paymentId: state.userPayment?.id ?? 0);
                          } else {
                            final result = await Navigator.of(context).pushNamed(AppRouterPaths.createPurcharsePost);
                            if (result != null) {
                              context.read<PostUpdateCubit>().setUserPayment(result as UserPaymentModel);
                            }
                          }
                        },
                        isLoading: state.isLoadingExtension ?? false,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  // 9️⃣ Submit button
                  Visibility(
                    visible: state.listing?.status != 'VIOLATION',
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButtonCommon(
                        text: 'Cập nhật bài viết',
                        onPressed: () async {
                          context.read<PostUpdateCubit>().updatePost(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            price: double.parse(_priceController.text),
                            phone: _phoneController.text,
                            address: _addressController.text,
                            images: _images,
                            removedImageUrls: _removedImageUrls,
                            context: context,
                          );
                        },
                        isLoading: state.isLoadingUpdate ?? false,
                        // child: Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        //   decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(15)),
                        //   child: Center(
                        //     child: (state.isLoadingUpdate ?? false)
                        //         ? CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.grey.withValues(alpha: 0.5))
                        //         : Text('Cập nhật bài viết', style: TextStyle(color: Colors.white, fontSize: 16)),
                        //   ),
                        // ),
                        // onTap: () {
                        //   context.read<PostUpdateCubit>().updatePost(
                        //     title: _titleController.text,
                        //     description: _descriptionController.text,
                        //     price: double.parse(_priceController.text),
                        //     phone: _phoneController.text,
                        //     address: _addressController.text,
                        //     images: _images,
                        //     removedImageUrls: _removedImageUrls,
                        //     context: context,
                        //   );
                        // },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBottomCategories(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostUpdateCubit>(),
          child: BlocBuilder<PostUpdateCubit, PostUpdateState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    if (state.categories.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 0),
                            itemBuilder: (cont, index) {
                              final item = state.categories[index];
                              // bản chất 2 obj giống nhau
                              return CheckboxListTile(
                                value: state.subCategories?.any((c) => c.id == item.id),
                                activeColor: AppColor.cMain,
                                checkColor: Colors.white,
                                onChanged: (_) {
                                  context.read<PostUpdateCubit>().toggleCategory(item);
                                  // Nếu bạn muốn đóng BottomSheet sau khi chọn 1 mục:
                                  // Navigator.pop(context);
                                },
                                title: Text(item.name),
                              );
                            },
                          ),
                        ),
                      ),
                    Visibility(
                      visible: state.subCategories.isNotEmpty,
                      child: AppButton(
                        onTap: () {
                          context.read<PostUpdateCubit>().setSelectedCategories(state.subCategories ?? []);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: const Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
