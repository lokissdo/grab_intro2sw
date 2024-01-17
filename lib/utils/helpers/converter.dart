class Converter {
  static double distanceStringToDistance(String distanceStr) {
    RegExp regex = RegExp(r'(\d+\.\d+)');

    // Extract the numeric part
    String result = regex.firstMatch(distanceStr)?.group(1) ?? "";
    return double.parse(result);
  }
}
