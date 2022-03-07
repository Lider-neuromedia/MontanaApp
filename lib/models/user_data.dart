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
        id: json["id"],
        userId: json["user_id"],
        fieldKey: json["field_key"],
        valueKey: json["value_key"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "field_key": fieldKey,
        "value_key": valueKey,
      };
}
