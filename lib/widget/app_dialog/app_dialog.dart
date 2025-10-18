import 'dart:async';

import 'package:flutter/material.dart';
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
class AppDialog {
  static bool loadingVisible = false;

  static Future<void> showWidget({
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { return; }
    await showDialog<void>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return child;
      },
    );
  }

  static Future<void> alert({
    required String title,
    required String message,
    String okText = 'OK',
  }) async {
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { return; }
    await showDialog<void>(
      context: ctx,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx, rootNavigator: true).pop();
              },
              child: Text(okText),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirm({
    required String title,
    required String message,
    String cancelText = 'Cancel',
    String okText = 'OK',
    FutureOr<void> Function()? onOk,
    FutureOr<void> Function()? onCancel,
    bool autoPopAfterOk = true,
    bool barrierDismissible = true,
  }) async {
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { return null; }
    bool loading = false;

    final bool? result = await showDialog<bool>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: loading ? null : () async {
                    if (onCancel != null) { await onCancel(); }
                    Navigator.of(ctx, rootNavigator: true).pop(false);
                  },
                  child: Text(cancelText),
                ),
                ElevatedButton(
                  onPressed: loading ? null : () async {
                    if (onOk != null) {
                      setState(() { loading = true; });
                      await onOk();
                      if (autoPopAfterOk) {
                        Navigator.of(ctx, rootNavigator: true).pop(true);
                      } else {
                        setState(() { loading = false; });
                      }
                    } else {
                      Navigator.of(ctx, rootNavigator: true).pop(true);
                    }
                  },
                  child: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text(okText),
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  }

  static Future<void> showLoading({String? message}) async {
    if (loadingVisible) { return; }
    loadingVisible = true;
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { loadingVisible = false; return; }
    showGeneralDialog(
      context: ctx,
      barrierLabel: 'loading',
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (context, a1, a2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(),
                    ),
                    if (message != null) const SizedBox(height: 12),
                    if (message != null) Text(message, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoading() {
    if (!loadingVisible) { return; }
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { loadingVisible = false; return; }
    Navigator.of(ctx, rootNavigator: true).pop();
    loadingVisible = false;
  }

  static void toast(String message, {Duration duration = const Duration(seconds: 2)}) {
    final BuildContext? ctx = appNavigatorKey.currentState?.overlay?.context ?? appNavigatorKey.currentContext;
    if (ctx == null) { return; }
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(ctx);
    if (messenger == null) { return; }
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message), duration: duration));
  }
}
