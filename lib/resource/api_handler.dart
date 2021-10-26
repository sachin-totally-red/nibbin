import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:package_info/package_info.dart';

class APIHandler {
  HttpClient client = HttpClient();

  static String clientAuth;
  final String bearerLogin = 'Bearer';

  Future<void> createBearerHeader() async {
    String jwtToken = await getStringValuesSF("JWTToken");
    clientAuth = (jwtToken == null) ? "" : bearerLogin + ' ' + jwtToken;
  }

  Future fetchUserDeviceInfo(HttpClientRequest request) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        if (iosInfo != null) {
          Map _deviceInformation = {
            "device_info": {
              "platform": "ios",
              "deviceName": iosInfo.name ?? "",
              "deviceVersion": iosInfo.systemVersion ?? "",
              "deviceModel": iosInfo.model ?? "",
            }
          };
          request.headers.set("device_info", _deviceInformation);
        }
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo != null) {
          Map _deviceInformation = {
            "device_info": {
              "platform": "android",
              "deviceName": androidInfo.device ?? "",
              "deviceVersion": (androidInfo.version == null)
                  ? ""
                  : (androidInfo.version.release ?? ""),
              "deviceModel": androidInfo.model ?? "",
            }
          };
          request.headers.set("device_info", _deviceInformation);
        }
      }
      return request;
    } catch (e) {
      print(e.toString());
      return request;
    }
  }

  Future fetchCurrentAppVersion(HttpClientRequest request) async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      String currentVersion = info.version.trim().toString();

      request.headers.set("app_version", currentVersion);
      return request;
    } catch (e) {
      print(e.toString());
      return request;
    }
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
      request = await fetchUserDeviceInfo(request);
      request = await fetchCurrentAppVersion(request);
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
      request = await fetchUserDeviceInfo(request);
      request = await fetchCurrentAppVersion(request);
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
      request = await fetchUserDeviceInfo(request);
      request = await fetchCurrentAppVersion(request);
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
      request = await fetchUserDeviceInfo(request);
      request = await fetchCurrentAppVersion(request);
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
