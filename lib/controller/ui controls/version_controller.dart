
import 'package:get/get.dart';


class VersionController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Get.defaultDialog(
    //       title: '',
    //       content: Container(
    //         width: Get.width * 0.8,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             InkWell(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(10),
    //                 child: Row(
    //                   children: [
    //                     LargeText(
    //                       title: 'Search location',
    //                       color: mutedColor,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Divider(),
    //             SizedBox(
    //               height: 2.w,
    //             ),
    //             CommonButton(title: 'CONTINUE', callback: 'search')
    //           ],
    //         ),
    //       ),
    //     );
  }
  var version = '1.0.0'.obs;


updateVersion(String versionNumber){
  print(versionNumber);
  version.value = versionNumber;
   print(version.value);
  update();
}


  
}