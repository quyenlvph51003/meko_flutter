import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/forgot_pass_page/verify_otp_page.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_text_field/app_text_field.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:meko_project/repository/auth/auth_repo.dart';

import 'forgot_pass_vm/forgot_pass_cubit.dart';
import 'forgot_pass_vm/forgot_pass_state.dart';

class RequestOtpPage extends StatefulWidget {
  const RequestOtpPage({super.key});
  @override
  State<RequestOtpPage> createState() => RequestOtpPageState();
}

class RequestOtpPageState extends State<RequestOtpPage> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPassCubit>(
      create: (_) => ForgotPassCubit.forRequest(
        sendResetEmail: (email) async {
          final repo = GetIt.instance<AuthRepository>();
          final res = await repo.requestOtp(email: email);
          if (res == null || res.statusCode == null || res.statusCode! >= 400) { throw Exception('requestOtp failed'); }
        },
      ),
      child: BlocConsumer<ForgotPassCubit, ForgotPassState>(
        listenWhen: (p, c) => p.sent != c.sent || p.errorMessage != c.errorMessage,
        listener: (context, state) async {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
            return;
          }
          if (state.sent) {
            final email = (state.email.isNotEmpty ? state.email : emailCtrl.text.trim());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã gửi mã OTP. Vui lòng kiểm tra email.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return VerifyOtpPage(email: email);
                },
              ),
            );
          }
        },

        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF2F6FF),
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
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AppImages.img_splash,
                                      height: 120,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Quên mật khẩu',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Nhập email để nhận liên kết đặt lại mật khẩu.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    Row(
                                      children: [
                                        Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.cGray,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text('*', style: TextStyle(color: AppColor.cError)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    AppEditText(
                                      controller: emailCtrl,
                                      hintText: 'Nhập email của bạn',
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                                      validator: AppValidators.email,
                                      focusedBorderColor: AppColor.color8,
                                      onChanged: (v) {
                                        context.read<ForgotPassCubit>().onEmailChanged(v);
                                        return;
                                      },
                                      onSubmitted: (_) async {
                                        if (!(formKey.currentState?.validate() ?? false)) {
                                          return;
                                        }
                                        await context.read<ForgotPassCubit>().submit();
                                        return;
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    if (state.errorMessage != null &&
                                        state.errorMessage!.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          state.errorMessage!,
                                          style: const TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    const SizedBox(height: 24),
                                    AppButtonCommon(
                                      text: 'Gửi email',
                                      isLoading: state.loading,
                                      onPressed: () async {
                                        if (!(formKey.currentState?.validate() ?? false)) {
                                          return;
                                        }
                                        await context.read<ForgotPassCubit>().submit();
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
                                        'Quay lại đăng nhập',
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
