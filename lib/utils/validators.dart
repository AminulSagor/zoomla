class Validators {
  static String? validateUsername(String value) {
    if (value.trim().isEmpty) return "Username is required";
    return null;
  }

  static String? validatePassword(String value) {
    if (value.trim().isEmpty) return "Password is required";
    if (value.length < 4) return "Password must be at least 6 characters";
    return null;
  }

  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.trim().isEmpty) return "Confirm your password";
    if (password != confirmPassword) return "Passwords do not match";
    return null;
  }

  static String? validatePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return "Phone number is required";

    final bdPhoneRegex = RegExp(r'^(\+8801|01)[0-9]{9}$');
    if (!bdPhoneRegex.hasMatch(trimmed)) return "Invalid phone number";

    return null;
  }

}
