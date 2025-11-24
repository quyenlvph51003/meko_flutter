import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/user/user_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  UserModel? _user;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SqliteHelper.getUserSql();
    setState(() {
      _user = user;
      _nameCtrl.text = user?.username ?? '';
      _emailCtrl.text = user?.email ?? '';
      _addressCtrl.text = user?.addressName ?? '';
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;
      setState(() => _saving = true);
      final updated = await getIt<UserRepo>().updateAvatar(picked.path);
      if (updated != null) {
        setState(() => _user = updated);
        Fluttertoast.showToast(msg: 'Cập nhật ảnh đại diện thành công', backgroundColor: AppColor.cMain, textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Cập nhật ảnh thất bại', backgroundColor: Colors.red, textColor: Colors.white);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final updated = await getIt<UserRepo>().updateProfile(
      username: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      addressName: _addressCtrl.text.trim(),
    );
    setState(() => _saving = false);
    if (updated != null && mounted) {
      Fluttertoast.showToast(msg: 'Cập nhật thông tin thành công', backgroundColor: AppColor.cMain, textColor: Colors.white);
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: _pickAndUploadAvatar,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: (_user?.avatar?.isNotEmpty ?? false) ? NetworkImage(_user!.avatar!) : null,
                            child: (_user?.avatar?.isNotEmpty ?? false)
                                ? null
                                : const Icon(Icons.person, size: 48, color: Colors.grey),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: _pickAndUploadAvatar,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(color: AppColor.cMain, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Tên hiển thị', border: OutlineInputBorder()),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Không được để trống' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressCtrl,
                          decoration: const InputDecoration(labelText: 'Địa chỉ', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain),
                            child: _saving
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Lưu thay đổi', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
