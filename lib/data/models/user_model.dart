class UserModel {
  String? sId;
  String? email;
  String? mobile;
  String? createdDate;
  String? firstName;
  String? lastName;

  UserModel(
      {this.sId,
      this.email,
      this.mobile,
      this.createdDate,
      this.firstName,
      this.lastName});

  String get fullName => '${firstName ?? 'Not'} ${lastName ?? 'Set'}';

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    mobile = json['mobile'];
    createdDate = json['createdDate'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['createdDate'] = this.createdDate;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
