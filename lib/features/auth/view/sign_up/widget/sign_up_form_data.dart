import 'package:meet_now_app/server/model/registration/registration.dart';

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

  Registration toRegistration() {
    return Registration(
      username: username.trim(),
      email: email.trim(),
      firstname: firstname.trim(),
      subname: subname.trim(),
      description: description.trim(),
      avatar: avatar.trim(),
      city: city.trim(),
      age: age,
      purposes: purposes,
      interests: interests,
      isSearchable: isSearchable,
      password: password.trim(),
    );
  }
}
