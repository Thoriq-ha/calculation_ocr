String addBase64Padding(String base64String) {
  while (base64String.length % 4 != 0) {
    base64String += '=';
  }
  return base64String;
}
