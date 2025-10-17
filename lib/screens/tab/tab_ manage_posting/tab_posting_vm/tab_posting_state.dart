import 'package:equatable/equatable.dart';


enum PostTab { dangHienThi, hetHan, biTuChoi, canBoSung }


class PostManagerState extends Equatable {
  final int notificationCount;
  final int chatCount;
  final int voucherCount;
  final int dtPoint;
  final PostTab currentTab;


  const PostManagerState({
    this.notificationCount = 11,
    this.chatCount = 0,
    this.voucherCount = 1,
    this.dtPoint = 0,
    this.currentTab = PostTab.dangHienThi,
  });


  PostManagerState copyWith({
    int? notificationCount,
    int? chatCount,
    int? voucherCount,
    int? dtPoint,
    PostTab? currentTab,
  }) {
    return PostManagerState(
      notificationCount: notificationCount ?? this.notificationCount,
      chatCount: chatCount ?? this.chatCount,
      voucherCount: voucherCount ?? this.voucherCount,
      dtPoint: dtPoint ?? this.dtPoint,
      currentTab: currentTab ?? this.currentTab,
    );
  }


  @override
  List<Object?> get props {
    return [notificationCount, chatCount, voucherCount, dtPoint, currentTab];
  }
}