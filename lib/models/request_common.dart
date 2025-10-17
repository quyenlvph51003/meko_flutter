import 'package:equatable/equatable.dart';

class RequestCommonAll extends Equatable {
  String? searchText;
  int? tripTypeId;
  int? isActive;
  int? userTripId;

  RequestCommonAll({this.searchText, this.tripTypeId, this.isActive, this.userTripId});

  RequestCommonAll copyWith({
    String? searchText,
    String? selectTime,
    int? tripTypeId,
    int? isActive,
    int? userTripId,
  }) {
    return RequestCommonAll(
      searchText: searchText ?? this.searchText,
      tripTypeId: tripTypeId ?? this.tripTypeId,
      isActive: isActive ?? this.isActive,
    );
  }

  RequestCommonAll.fromJson(Map<String, dynamic> json) {
    searchText = json['searchText'];
    tripTypeId = json['tripTypeId'];
    isActive = json['isActive'];
    userTripId = json['userTripId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (searchText != null) data['searchText'] = searchText;
    if (tripTypeId != null) data['tripTypeId'] = tripTypeId;
    if (isActive != null) data['isActive'] = isActive;
    if (userTripId != null) data['userTripId'] = userTripId;
    return data;
  }

  @override
  List<Object?> get props => [searchText, tripTypeId, isActive, userTripId];
}
