class UserData {
  UserData({
    this.id,
    this.userId,
    this.fieldKey,
    this.valueKey,
  });

  int id;
  int userId;
  String fieldKey;
  String valueKey;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json.containsKey("id_field") ? json["id_field"] : json["id"],
        userId: json["user_id"] != null ? json["user_id"] : null,
        fieldKey: json["field_key"],
        valueKey: json["value_key"] != null ? json["value_key"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_field": id,
        "user_id": userId,
        "field_key": fieldKey,
        "value_key": valueKey ?? '',
      };
}
