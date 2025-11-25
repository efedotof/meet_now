import 'package:meet_now_app_server/model/auth/registration/registration.dart';

class SignUpFormData {
  String username = '';
  String email = '';
  String firstname = '';
  String subname = '';
  String description = '';
  String city = '';
  String avatar = '';
  String password = '';
  int age = 0;
  List<String> purposes = [];
  List<String> interests = [];
  bool isSearchable = false;
  String gender = "";

  Registration toRegistration() {
    return Registration(
      username: username.trim(),
      email: email.trim(),
      firstname: firstname.trim(),
      subname: subname.trim(),
      description: description.trim(),
      city: city.trim(),
      age: age,
      purposes: purposes,
      interests: interests,
      isSearchable: isSearchable,
      password: password.trim(),
      floor: gender,
    );
  }
}
