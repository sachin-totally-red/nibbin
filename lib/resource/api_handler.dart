import 'dart:convert';
import 'dart:io';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';

class APIHandler {
  HttpClient client = HttpClient();

  static String clientAuth;
  final String bearerLogin = 'Bearer';

  Future<void> createBearerHeader() async {
    String jwtToken = await getStringValuesSF("JWTToken");
    clientAuth = (jwtToken == null) ? "" : bearerLogin + ' ' + jwtToken;
  }

  Future postAPICall({apiInputParameters, endPointURL}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.postUrl(Uri.parse(Constants.apiUrl + endPointURL));
      await createBearerHeader();
      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      if (apiInputParameters != null) {
        print(json.encode(apiInputParameters));
        request.add(utf8.encode(json.encode(apiInputParameters)));
      }
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> map = json.decode(reply);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getAPICall(endPointURL) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.getUrl(Uri.parse(Constants.apiUrl + endPointURL));
      await createBearerHeader();

      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();
      if (endPointURL == "report/types" || endPointURL == "user/profile")
        return json.decode(reply);
      Map<String, dynamic> map = json.decode(reply);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteAPICall(endPointURL, {apiInputParameters}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.deleteUrl(Uri.parse(Constants.apiUrl + endPointURL));
      await createBearerHeader();

      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      if (apiInputParameters != null) {
        print(json.encode(apiInputParameters));
        request.add(utf8.encode(json.encode(apiInputParameters)));
      }
      HttpClientResponse response = await request.close();
      var reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> map = json.decode(reply);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future putAPICall({endPointURL, apiInputParameters}) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request =
          await client.putUrl(Uri.parse(Constants.apiUrl + endPointURL));
      await createBearerHeader();
      request.headers.set('Authorization', clientAuth);
      request.headers.set('content-type', 'application/json');
      request.headers.set('accept', 'application/json');
      request.add(utf8.encode(json.encode(apiInputParameters)));
      print(json.encode(apiInputParameters));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      Map<String, dynamic> map = json.decode(reply);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
