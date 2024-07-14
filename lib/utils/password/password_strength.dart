enum PasswordStrength {
  weak,
  medium,
  strong,
}

PasswordStrength getPasswordStrength(String password) {
  if (password.isEmpty) {
    return PasswordStrength.weak;
  }

  int length = password.length;
  bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
  bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
  bool hasDigit = password.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar = password.contains(RegExp(r'[!@#\$%\^&*\-_]'));

  if (length < 8 ||
      !hasUpperCase ||
      !hasLowerCase ||
      !hasDigit ||
      !hasSpecialChar) {
    return PasswordStrength.weak;
  } else if (length < 12) {
    return PasswordStrength.medium;
  } else {
    return PasswordStrength.strong;
  }
}
