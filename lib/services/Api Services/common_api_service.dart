import 'dart:convert';
import 'dart:developer';
import 'package:axoproject/utils/constants/api_constatnts.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApiManager {
  static final client = http.Client();
  static isConnected() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    return hasInternet;
  }

  // static Future fetchData({String? api, var params}) async {
  //   String baseUrl = ApiConstants.getInventoryBaseUrl();
  //   print(baseUrl + api!);
  //   var responses = await client
  //       .post(Uri.parse('${baseUrl}$api'), body: json.encode(params), headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   });
  //   if (responses.statusCode == 200) {
  //     var jsonResponse = jsonDecode(responses.body);
  //     print(jsonResponse);
  //     return jsonResponse;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  static Future fetchData({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getInventoryBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBody({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        print(data);
        String baseUrl = ApiConstants.getInventoryBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataQc({
    String? api,
  }) async {
    String baseUrl = ApiConstants.getQCBaseUrl();
    print(baseUrl + api!);
    var responses = await client.post(
      Uri.parse('${baseUrl}$api'),
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future fetchDataRawBodyQc({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getQCBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataVendor({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getVendorBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBodyvendor({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getVendorBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataCRM({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getCRMBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataCommon({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataRawBodyCRM({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getCRMBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchCommonDataRawBody({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        print(data);
        String baseUrl = ApiConstants.getBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

  static Future fetchDataVAN({
    String? api,
  }) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getVANBaseUrl();
        print(baseUrl + api!);
        var responses = await client.post(
          Uri.parse('${baseUrl}$api'),
        );
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }

   static Future fetchDataRawBodyVAN({String? api, String? data}) async {
    try {
      bool isConnected = await ApiManager.isConnected();
      if (isConnected) {
        String baseUrl = ApiConstants.getVANBaseUrl();
        var responses = await client.post(
          Uri.parse('$baseUrl$api'),
          headers: {"Content-Type": "application/json"},
          body: data,
        );
        var jsonResponse = jsonDecode(responses.body);
        log(jsonResponse.toString());
        if (responses.statusCode == 200) {
          var jsonResponse = jsonDecode(responses.body);
          print(jsonResponse);
          return jsonResponse;
        } else {
          throw Exception('Please check your connection settings');
        }
      } else {
        SnackbarServices.errorSnackbar(
            'No Internet. Please verify your connection');
        return null;
      }
    } catch (e) {
      // SnackbarServices.errorSnackbar(e.toString());
      return null;
    }
  }



}
