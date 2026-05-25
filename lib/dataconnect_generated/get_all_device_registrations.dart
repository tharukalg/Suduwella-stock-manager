part of 'generated.dart';

class GetAllDeviceRegistrationsVariablesBuilder {

  final FirebaseDataConnect _dataConnect;
  GetAllDeviceRegistrationsVariablesBuilder(this._dataConnect);
  Deserializer<GetAllDeviceRegistrationsData> dataDeserializer = (dynamic json) => GetAllDeviceRegistrationsData.fromJson(jsonDecode(json));

  Future<QueryResult<GetAllDeviceRegistrationsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAllDeviceRegistrationsData, void> ref() {
    return _dataConnect.query("GetAllDeviceRegistrations", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllDeviceRegistrationsDeviceRegistrations {
  final String id;
  final String branchCode;
  final String? deviceLabel;
  final double updatedAt;
  GetAllDeviceRegistrationsDeviceRegistrations.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']),
        branchCode = nativeFromJson<String>(json['branchCode']),
        deviceLabel = json['deviceLabel'] == null ? null : nativeFromJson<String>(json['deviceLabel']),
        updatedAt = nativeFromJson<double>(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetAllDeviceRegistrationsDeviceRegistrations otherTyped = other as GetAllDeviceRegistrationsDeviceRegistrations;
    return id == otherTyped.id && branchCode == otherTyped.branchCode && deviceLabel == otherTyped.deviceLabel && updatedAt == otherTyped.updatedAt;
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, branchCode.hashCode, deviceLabel.hashCode, updatedAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['branchCode'] = nativeToJson<String>(branchCode);
    if (deviceLabel != null) {
      json['deviceLabel'] = nativeToJson<String?>(deviceLabel);
    }
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  GetAllDeviceRegistrationsDeviceRegistrations({required this.id, required this.branchCode, this.deviceLabel, required this.updatedAt});
}

@immutable
class GetAllDeviceRegistrationsData {
  final List<GetAllDeviceRegistrationsDeviceRegistrations> deviceRegistrations;
  GetAllDeviceRegistrationsData.fromJson(dynamic json)
      : deviceRegistrations = (json['deviceRegistrations'] as List<dynamic>)
            .map((e) => GetAllDeviceRegistrationsDeviceRegistrations.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetAllDeviceRegistrationsData otherTyped = other as GetAllDeviceRegistrationsData;
    return deviceRegistrations == otherTyped.deviceRegistrations;
  }
  @override
  int get hashCode => deviceRegistrations.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['deviceRegistrations'] = deviceRegistrations.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllDeviceRegistrationsData({required this.deviceRegistrations});
}
