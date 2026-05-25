part of 'generated.dart';

class GetDeviceRegistrationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetDeviceRegistrationVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<GetDeviceRegistrationData> dataDeserializer = (dynamic json) => GetDeviceRegistrationData.fromJson(jsonDecode(json));
  Serializer<GetDeviceRegistrationVariables> varsSerializer = (GetDeviceRegistrationVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetDeviceRegistrationData, GetDeviceRegistrationVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetDeviceRegistrationData, GetDeviceRegistrationVariables> ref() {
    GetDeviceRegistrationVariables vars = GetDeviceRegistrationVariables(id: id);
    return _dataConnect.query("GetDeviceRegistration", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetDeviceRegistrationDeviceRegistrations {
  final String id;
  final String branchCode;
  final String? deviceLabel;
  final double updatedAt;
  GetDeviceRegistrationDeviceRegistrations.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']),
        branchCode = nativeFromJson<String>(json['branchCode']),
        deviceLabel = json['deviceLabel'] == null ? null : nativeFromJson<String>(json['deviceLabel']),
        updatedAt = nativeFromJson<double>(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetDeviceRegistrationDeviceRegistrations otherTyped = other as GetDeviceRegistrationDeviceRegistrations;
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

  GetDeviceRegistrationDeviceRegistrations({required this.id, required this.branchCode, this.deviceLabel, required this.updatedAt});
}

@immutable
class GetDeviceRegistrationData {
  final List<GetDeviceRegistrationDeviceRegistrations> deviceRegistrations;
  GetDeviceRegistrationData.fromJson(dynamic json)
      : deviceRegistrations = (json['deviceRegistrations'] as List<dynamic>)
            .map((e) => GetDeviceRegistrationDeviceRegistrations.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetDeviceRegistrationData otherTyped = other as GetDeviceRegistrationData;
    return deviceRegistrations == otherTyped.deviceRegistrations;
  }
  @override
  int get hashCode => deviceRegistrations.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['deviceRegistrations'] = deviceRegistrations.map((e) => e.toJson()).toList();
    return json;
  }

  GetDeviceRegistrationData({required this.deviceRegistrations});
}

@immutable
class GetDeviceRegistrationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetDeviceRegistrationVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GetDeviceRegistrationVariables otherTyped = other as GetDeviceRegistrationVariables;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetDeviceRegistrationVariables({required this.id});
}
