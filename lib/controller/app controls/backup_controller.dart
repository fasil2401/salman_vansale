import 'dart:developer';

import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';

class BackUpController extends GetxController {
  @override
  void onInit() {
    listFilesInBackupFolder();
    super.onInit();
  }

  var backups = <BackUpModel>[];
  Future<void> getBackups() async {
    // Generate a unique file name based on current date and time
    String formattedDateTime =
        DateFormat('yyyy-MM-dd_HH:mm:ss').format(DateTime.now());

    String fileName =
        '${UserSimplePreferences.getDatabase()}_$formattedDateTime.db';

    String dbFilePath = join(await getDatabasesPath(), "axoVan.db");
    final directory = await getApplicationSupportDirectory();
    final filePath = '${directory.path}/$fileName';
    final dbFile = File(filePath);

    // Copy the database file to the specified location
    await dbFile.create(
      recursive: true,
    );
    await dbFile.writeAsBytes(await File(dbFilePath).readAsBytes());

    // Add the backup to the list
    backups
        .add(BackUpModel(date: DateTime.now(), db: filePath, name: fileName));

    // Update the view to reflect the changes
    update();
  }

  Future<void> listFilesInBackupFolder() async {
    backups.clear();
    Directory directory = await getApplicationSupportDirectory();
    List<File> files = [];

    if (await directory.exists()) {
      List<FileSystemEntity> fileSystemEntities = directory.listSync();

      for (FileSystemEntity entity in fileSystemEntities) {
        if (entity is File) {
          files.add(entity);
        }
      }
    }
    // Populate backups list with BackUpModel instances
    for (File file in files) {
      log("${file.path}");
      backups.add(BackUpModel(
        name: file.path.split('/').last, // Extract the file name from the path
        date: file.lastModifiedSync(),
        db: file.path,
      ));
    }

    update();
  }

  Future<void> deleteBackupFile(String path) async {
    try {
      Directory directory = await getApplicationSupportDirectory();
      String folderPath = directory.path;
      File file = File("$folderPath/$path");

      if (await file.exists()) {
        await file.delete();
        print('File deleted: $folderPath');
      } else {
        print('File does not exist: $folderPath');
      }

      // Remove the deleted file from the backups list
      backups.removeWhere((backup) => backup.name == path);

      // Update the view to reflect the changes
      update();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}

class BackUpModel {
  String? name;
  DateTime? date;
  String? db;

  BackUpModel({this.name, this.date, this.db});
}
