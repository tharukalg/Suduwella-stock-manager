part of 'generated.dart';

class UpsertDeviceRegistrationVariablesBuilder {
  String id;
  String branchCode;
  Optional<String> _deviceLabel = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;
  UpsertDeviceRegistrationVariablesBuilder deviceLabel(String? t) {
    _deviceLabel.value = t;
    return this;
  }

  UpsertDeviceRegistrationVariablesBuilder(this._dataConnect, {required this.id, required this.branchCode, required this.createdAt, required this.updatedAt});
  Deserializer<UpsertDeviceRegistrationData> dataDeserializer = (dynamic json) => UpsertDeviceRegistrationData.fromJson(jsonDecode(json));
  Serializer<UpsertDeviceRegistrationVariables> varsSerializer = (UpsertDeviceRegistrationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertDeviceRegistrationData, UpsertDeviceRegistrationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertDeviceRegistrationData, UpsertDeviceRegistrationVariables> ref() {
    UpsertDeviceRegistrationVariables vars = UpsertDeviceRegistrationVariables(id: id, branchCode: branchCode, deviceLabel: _deviceLabel, createdAt: createdAt, updatedAt: updatedAt);
    return _dataConnect.mutation("UpsertDeviceRegistration", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertDeviceRegistrationDeviceRegistrationUpsert {
  final String id;
  UpsertDeviceRegistrationDeviceRegistrationUpsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertDeviceRegistrationDeviceRegistrationUpsert otherTyped = other as UpsertDeviceRegistrationDeviceRegistrationUpsert;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertDeviceRegistrationDeviceRegistrationUpsert({required this.id});
}

@immutable
class UpsertDeviceRegistrationData {
  final UpsertDeviceRegistrationDeviceRegistrationUpsert deviceRegistration_upsert;
  UpsertDeviceRegistrationData.fromJson(dynamic json)
      : deviceRegistration_upsert = UpsertDeviceRegistrationDeviceRegistrationUpsert.fromJson(json['deviceRegistration_upsert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertDeviceRegistrationData otherTyped = other as UpsertDeviceRegistrationData;
    return deviceRegistration_upsert == otherTyped.deviceRegistration_upsert;
  }
  @override
  int get hashCode => deviceRegistration_upsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['deviceRegistration_upsert'] = deviceRegistration_upsert.toJson();
    return json;
  }

  UpsertDeviceRegistrationData({required this.deviceRegistration_upsert});
}

@immutable
class UpsertDeviceRegistrationVariables {
  final String id;
  final String branchCode;
  late final Optional<String> deviceLabel;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertDeviceRegistrationVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']),
        branchCode = nativeFromJson<String>(json['branchCode']),
        createdAt = nativeFromJson<double>(json['createdAt']),
        updatedAt = nativeFromJson<double>(json['updatedAt']) {
    deviceLabel = Optional.optional(nativeFromJson, nativeToJson);
    deviceLabel.value = json['deviceLabel'] == null ? null : nativeFromJson<String>(json['deviceLabel']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final UpsertDeviceRegistrationVariables otherTyped = other as UpsertDeviceRegistrationVariables;
    return id == otherTyped.id && branchCode == otherTyped.branchCode && deviceLabel == otherTyped.deviceLabel && createdAt == otherTyped.createdAt && updatedAt == otherTyped.updatedAt;
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, branchCode.hashCode, deviceLabel.hashCode, createdAt.hashCode, updatedAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['branchCode'] = nativeToJson<String>(branchCode);
    if (deviceLabel.state == OptionalState.set) {
      json['deviceLabel'] = deviceLabel.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertDeviceRegistrationVariables({required this.id, required this.branchCode, required this.deviceLabel, required this.createdAt, required this.updatedAt});
}
