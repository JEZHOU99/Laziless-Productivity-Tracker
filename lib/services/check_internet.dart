import 'dart:io';

haveInternet() {
  Future<dynamic> test = checkInternet();
  test.then((result) {
    print(result);
    return result;
  });
}

checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
