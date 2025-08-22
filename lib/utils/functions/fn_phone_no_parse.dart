String formatPhoneNumber(String phoneNumber) {
  // Assuming the phone number is in a 10-digit format without country code
  return phoneNumber.replaceRange(3, 3, ' ').replaceRange(7, 7, ' ');
}
