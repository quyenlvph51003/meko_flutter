import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';


import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_text_field/app_text_field.dart';
import 'package:flutter/services.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';

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
      create: (_) => ForgotPassCubit.forVerify(
        verifyOtpFn: (email, otp) async {
          final repo = GetIt.instance<AuthRepository>();
          final res = await repo.verifyOtp(email: email, otp: otp);
        },
        initialEmail: widget.email,
      ),
      child: BlocConsumer<ForgotPassCubit, ForgotPassState>(
        listenWhen: (p, c) => p.verified != c.verified || p.errorMessage != c.errorMessage,
        listener: (context, state) async {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
            return;
          }
          if (state.verified) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Xác thực OTP thành công'), backgroundColor: Colors.green),
            );
            Navigator.of(context).maybePop(true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF2F6FF),
            body: GestureDetector(
              onTap: () { FocusScope.of(context).unfocus(); },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () { return Navigator.of(context).pop(false); },
                          child: const SizedBox(width: 24, height: 24, child: Icon(Icons.arrow_back, size: 24)),
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
                                  Image.asset(AppImages.img_splash, height: 120, fit: BoxFit.fitHeight),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Xác thực OTP',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Nhập mã gồm 6 số đã gửi tới email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 32),

                                  Row(
                                    children: [
                                      Text('Mã OTP', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColor.cGray)),
                                      const SizedBox(width: 2),
                                      Text('*', style: TextStyle(color: AppColor.cError)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  AppEditText(
                                    controller: otpCtrl,
                                    hintText: '______',
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                                    prefixIcon: const Icon(Icons.password_outlined, size: 20),
                                    focusedBorderColor: AppColor.color8,
                                    onChanged: (v) {
                                      context.read<ForgotPassCubit>().onOtpChanged(v);
                                      return;
                                    },
                                    onSubmitted: (_) async {
                                      await context.read<ForgotPassCubit>().verify();
                                      return;
                                    },
                                  ),

                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Email: ${widget.email}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ),

                                  const SizedBox(height: 24),
                                  AppButtonCommon(
                                    text: 'Xác nhận',
                                    isLoading: state.loading,
                                    onPressed: () async {
                                      await context.read<ForgotPassCubit>().verify();
                                      return;
                                    },
                                    type: AppButtonType.primary,
                                    size: AppButtonSize.large,
                                  ),

                                  const SizedBox(height: 16),
                                  AppButton(
                                    onTap: () { return Navigator.of(context).pop(false); },
                                    child: const Text(
                                      'Quay lại',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
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
