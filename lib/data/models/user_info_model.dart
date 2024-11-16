class SignUpRequestBody {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String mobile;

  SignUpRequestBody({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.mobile,
  });
}

class UserProfileRequestBody {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  // late final String? password;
  // late final String? photo;

  UserProfileRequestBody({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    // this.password,
    // this.photo,
  });
}
