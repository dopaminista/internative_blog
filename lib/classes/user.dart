import 'package:hive/hive.dart';

class User {
  User({this.mail, this.password, this.passwordRetry});
  @HiveField(1)
  String? mail;
  @HiveField(2)
  String? password;

  String? passwordRetry;

  Map get signInCred => {'Email': mail?.trim(), 'Password': password?.trim()};
  Map get signUpCred => {
        'Email': mail?.trim(),
        'Password': password?.trim(),
        'PasswordRetry': passwordRetry?.trim()
      };
}
