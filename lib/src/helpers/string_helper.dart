class StringHelper {
  static String getUpperCaseString(String str) {
    str = str.toLowerCase();
    List<String> strList = str.split(' ');
    for (var i = 0; i < strList.length; i++) {
      String tmp = strList[i];
      tmp = tmp.substring(0, 1).toUpperCase() + tmp.substring(1).toLowerCase();
      strList[i] = tmp;
    }

    return strList.join(' ');
  }
}
