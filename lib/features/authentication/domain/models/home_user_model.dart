class UserModel {
  String phoneNumber;
  String otp;
  bool isChecked;

  UserModel({
    required this.phoneNumber,
    required this.otp,
    this.isChecked = false,
  });
}
