import 'package:axoproject/controller/app%20controls/backup_controller.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/view/components/common_button_widget.dart';
import 'package:axoproject/view/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class BackUpScreen extends StatefulWidget {
  BackUpScreen({super.key});

  @override
  State<BackUpScreen> createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  final backUpController = Get.put(BackUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CommonButtonWidget(
              onPressed: () {
                backUpController.getBackups();
              },
              title: "Add backup",
              backgroundColor: AppColors.primary,
              textColor: AppColors.white,
              icon: Center(child: Icon(Icons.add)),
              isLoading: false,
            ),
            Expanded(
              child: GetBuilder<BackUpController>(
                init: BackUpController(),
                initState: (_) {},
                builder: (_) {
                  return ListView.builder(
                    itemCount: _.backups.length,
                    itemBuilder: (context, index) {
                      var item = _.backups[index];
                      return ListTile(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                  'Are you sure you want to restore this backup? all unsaved data will be lost'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await backUpController
                                        .deleteBackupFile("${item.name}");
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        title: Text("${item.name}"),
                        subtitle: Text(
                            "${DateFormatter.reportDateFormat.format(item.date!)}"),
                        trailing: IconButton(
                            onPressed: () {
                              shareDBFile("${item.db}");
                            },
                            icon: Icon(Icons.share),
                            color: AppColors.primary),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void shareDBFile(String filePath) {
    File file = File(filePath);
    if (file.existsSync()) {
      Share.shareFiles([filePath], text: 'Sharing .db3 file');
    } else {
      // Handle file not found error
      print('File not found');
    }
  }
}
