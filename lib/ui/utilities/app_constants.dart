class AppConstants {
  static RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp mobileRegExp = RegExp(r"^\s*(?:\+?88)?01[13-9]\d{8}\s*$");
}
