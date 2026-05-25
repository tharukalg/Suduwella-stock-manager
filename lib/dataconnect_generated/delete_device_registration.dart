part of 'generated.dart';

class DeleteDeviceRegistrationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteDeviceRegistrationVariablesBuilder(this._dataConnect, {required this.id});
  Deserializer<DeleteDeviceRegistrationData> dataDeserializer = (dynamic json) => DeleteDeviceRegistrationData.fromJson(jsonDecode(json));
  Serializer<DeleteDeviceRegistrationVariables> varsSerializer = (DeleteDeviceRegistrationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteDeviceRegistrationData, DeleteDeviceRegistrationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteDeviceRegistrationData, DeleteDeviceRegistrationVariables> ref() {
    DeleteDeviceRegistrationVariables vars = DeleteDeviceRegistrationVariables(id: id);
    return _dataConnect.mutation("DeleteDeviceRegistration", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteDeviceRegistrationDeviceRegistrationDelete {
  final String id;
  DeleteDeviceRegistrationDeviceRegistrationDelete.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final DeleteDeviceRegistrationDeviceRegistrationDelete otherTyped = other as DeleteDeviceRegistrationDeviceRegistrationDelete;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteDeviceRegistrationDeviceRegistrationDelete({required this.id});
}

@immutable
class DeleteDeviceRegistrationData {
  final DeleteDeviceRegistrationDeviceRegistrationDelete? deviceRegistration_delete;
  DeleteDeviceRegistrationData.fromJson(dynamic json)
      : deviceRegistration_delete = json['deviceRegistration_delete'] == null
            ? null
            : DeleteDeviceRegistrationDeviceRegistrationDelete.fromJson(json['deviceRegistration_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final DeleteDeviceRegistrationData otherTyped = other as DeleteDeviceRegistrationData;
    return deviceRegistration_delete == otherTyped.deviceRegistration_delete;
  }
  @override
  int get hashCode => deviceRegistration_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (deviceRegistration_delete != null) {
      json['deviceRegistration_delete'] = deviceRegistration_delete!.toJson();
    }
    return json;
  }

  DeleteDeviceRegistrationData({this.deviceRegistration_delete});
}

@immutable
class DeleteDeviceRegistrationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteDeviceRegistrationVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final DeleteDeviceRegistrationVariables otherTyped = other as DeleteDeviceRegistrationVariables;
    return id == otherTyped.id;
  }
  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteDeviceRegistrationVariables({required this.id});
}
