import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_pinput/app_pinput.dart';
import 'package:flutter/services.dart';

import 'forgot_pass_vm/forgot_pass_cubit.dart';
import 'forgot_pass_vm/forgot_pass_state.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.email});
  final String email;

  @override
  State<VerifyOtpPage> createState() => VerifyOtpPageState();
}

class VerifyOtpPageState extends State<VerifyOtpPage> {
  final otpCtrl = TextEditingController();

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPassCubit>(
      create: (_) {
        return ForgotPassCubit.forVerifyWithRepo(
          repo: getIt<AuthRepository>(),
          initialEmail: widget.email,
        );
      },
      child: BlocConsumer<ForgotPassCubit, ForgotPassState>(
        listenWhen: (p, c) => p.verified != c.verified || p.errorMessage != c.errorMessage,
        listener: (context, state) async {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            print(state.errorMessage);
            print('sdfsdfsdfsdff=============================');
            return;
          }
          if (state.verified) {
            Navigator.pushNamed(context, AppRouterPaths.forgotPassPage);
          }
        },
        builder: (context, state) {
          final vm = context.read<ForgotPassCubit>();
          return Scaffold(
            backgroundColor: AppColor.white,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            return Navigator.of(context).pop(false);
                          },
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(Icons.arrow_back, size: 24),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: AppDimens.getWidth(context),
                            height: AppDimens.getHeight(context),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Image.asset(
                                    AppImages.img_splash,
                                    height: 120,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Xác thực OTP',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Nhập mã gồm 6 số đã gửi tới email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  Container(
                                    height: 70,
                                    child: AppInputOtp(
                                      controller: otpCtrl,
                                      length: 6,
                                      onChanged: (v) => vm.onOtpChanged(v),
                                      onCompleted: (code) {
                                        vm.onOtpChanged(code);
                                        vm.verify();
                                      },
                                      validator: (v) {
                                        if (v == null || v.length != 6) return 'Nhập đủ 6 số';
                                        return null;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Email: ${widget.email}',
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ),

                                  const SizedBox(height: 24),
                                  AppButtonCommon(
                                    text: 'Xác nhận',
                                    isLoading: state.loading,
                                    onPressed: () async {
                                      vm.onOtpChanged(otpCtrl.text);
                                      await vm.verify();
                                      return;
                                    },
                                    type: AppButtonType.primary,
                                    size: AppButtonSize.large,
                                  ),

                                  const SizedBox(height: 16),
                                  AppButton(
                                    onTap: () {
                                      return Navigator.of(context).pop(false);
                                    },
                                    child: const Text(
                                      'Quay lại',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
