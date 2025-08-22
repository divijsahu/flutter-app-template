// Function to validate email and password
String? validateEmailPassword(String email, String password) {
  // Check valid email format
  final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (email.isEmpty || !emailPattern.hasMatch(email)) {
    return 'Please enter a valid email address';
  }
  // password length check
  if (password.length < 8) {
    return 'Password Too Short\nMinimum 8 Characters';
  }
  // Check password pattern
  final passwordPattern = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );
  if (!passwordPattern.hasMatch(password)) {
    return 'Password should contain\n[ a-z, A-Z, 0-9, Special Character ]';
  }
  return null;
}
