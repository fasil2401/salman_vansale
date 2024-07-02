
import 'package:axoproject/utils/constants/api_constatnts.dart';
import 'package:axoproject/model/login%20model/login_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';

final loginController = Get.put(LoginController());

class RemoteServicesLogin {

  Future<Login?> getLogin(String data) async {
   
    print(data);
    String baseUrl = ApiConstants.getBaseUrl();
    final response = await http.post(
      Uri.parse('${baseUrl}Gettoken'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );

    if (response.statusCode == 200) {
      final String responseString = response.body;
      print(responseString);
// loginController.refresh();
      return loginFromJson(responseString);
    } else {
      return null;
    }
  }
}
