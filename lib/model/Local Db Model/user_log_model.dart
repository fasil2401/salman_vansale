class UserActivityLogImportantNames {
  static const String tableName = "user_activity_log";
  static const String sysDocId = "sysDocId";
  static const String voucherId = "voucherId";
  static const String description = "description";
  static const String machine = "machine";
  static const String activityType = "activityType";
  static const String userId = "userId";
  static const String date = "date";
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
}

class UserActivityLogModel {
  String? sysDocId;
  String? voucherId;
  int? activityType;
  String? date;
  String? userId;
  String? machine;
  String? description;
  int? isSynced;
  int? isError;
  String? error;

  UserActivityLogModel(
      {this.sysDocId,
      this.voucherId,
      this.activityType,
      this.date,
      this.userId,
      this.machine,
      this.description,
      this.isSynced,
      this.isError,
      this.error});
  Map<String, dynamic> toMap() {
    return {
      UserActivityLogImportantNames.sysDocId: sysDocId,
      UserActivityLogImportantNames.voucherId: voucherId,
      UserActivityLogImportantNames.activityType: activityType,
      UserActivityLogImportantNames.date: date,
      UserActivityLogImportantNames.userId: userId,
      UserActivityLogImportantNames.machine: machine,
      UserActivityLogImportantNames.description: description,
      UserActivityLogImportantNames.isSynced: isSynced,
      UserActivityLogImportantNames.isError: isError,
      UserActivityLogImportantNames.error: error
    };
  }

  UserActivityLogModel.fromMap(Map<String, dynamic> log) {
    sysDocId = log[UserActivityLogImportantNames.sysDocId];
    voucherId = log[UserActivityLogImportantNames.voucherId];
    activityType = log[UserActivityLogImportantNames.activityType];
    date = log[UserActivityLogImportantNames.date];
    userId = log[UserActivityLogImportantNames.userId];
    machine = log[UserActivityLogImportantNames.machine];
    description = log[UserActivityLogImportantNames.description];
    isSynced = log[UserActivityLogImportantNames.isSynced];
    isError = log[UserActivityLogImportantNames.isError];
    error = log[UserActivityLogImportantNames.error];
  }
}
