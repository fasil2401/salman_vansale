class CustomerVisitLogModelNames {
  static const String tableName = "customerVisitLog";
  static const String visitLogId = "visitLogId";
  static const String customerId = "customerId";
  static const String salesPersonId = "salesPersonId";
  static const String shiftId = "shiftId";
  static const String batchId = "batchId";
  static const String startTime = "startTime";
  static const String endTime = "endTime";
  static const String startLatitude = "startLatitude";
  static const String startLongitude = "startLongitude";
  static const String closeLatitude = "closeLatitude";
  static const String closeLongitude = "closeLongitude";
  static const String routeID = "routeID";
  static const String vanID = "vanID";
  static const String isSkipped = "isSkipped";
  static const String reasonForSkipping = "reasonForSkipping";
  static const String isSynced = 'isSynced';
  static const String isError = 'isError';
  static const String error = 'error';
}

class CustomerVisitApiModel {
  String? visitLogId;
  String? customerId;
  String? salesPersonId;
  String? shiftId;
  String? batchId;
  String? startTime;
  String? endTime;
  String? startLatitude;
  String? startLongitude;
  String? closeLatitude;
  String? closeLongitude;
  String? routeID;
  String? vanID;
  int? isSkipped;
  String? reasonForSkipping;
  int? isSynced;
  int? isError;
  String? error;

  CustomerVisitApiModel(
      {this.visitLogId,
      this.customerId,
      this.salesPersonId,
      this.shiftId,
      this.batchId,
      this.startTime,
      this.endTime,
      this.startLatitude,
      this.startLongitude,
      this.closeLatitude,
      this.closeLongitude,
      this.routeID,
      this.vanID,
      this.isSkipped,
      this.reasonForSkipping,
      this.isSynced,
      this.isError,
      this.error});

  Map<String, dynamic> toMap() {
    return {
      CustomerVisitLogModelNames.visitLogId: visitLogId,
      CustomerVisitLogModelNames.customerId: customerId,
      CustomerVisitLogModelNames.salesPersonId: salesPersonId,
      CustomerVisitLogModelNames.shiftId: shiftId,
      CustomerVisitLogModelNames.batchId: batchId,
      CustomerVisitLogModelNames.startTime: startTime,
      CustomerVisitLogModelNames.endTime: endTime,
      CustomerVisitLogModelNames.startLatitude: startLatitude,
      CustomerVisitLogModelNames.startLongitude: startLongitude,
      CustomerVisitLogModelNames.closeLatitude: closeLatitude,
      CustomerVisitLogModelNames.closeLongitude: closeLongitude,
      CustomerVisitLogModelNames.routeID: routeID,
      CustomerVisitLogModelNames.vanID: vanID,
      CustomerVisitLogModelNames.isSkipped: isSkipped,
      CustomerVisitLogModelNames.reasonForSkipping: reasonForSkipping,
      CustomerVisitLogModelNames.isSynced: isSynced,
      CustomerVisitLogModelNames.isError: isError,
      CustomerVisitLogModelNames.error: error,
    };
  }

  factory CustomerVisitApiModel.fromMap(Map<String, dynamic> map) {
    return CustomerVisitApiModel(
      visitLogId: map[CustomerVisitLogModelNames.visitLogId],
      customerId: map[CustomerVisitLogModelNames.customerId],
      salesPersonId: map[CustomerVisitLogModelNames.salesPersonId],
      shiftId: map[CustomerVisitLogModelNames.shiftId],
      batchId: map[CustomerVisitLogModelNames.batchId],
      startTime: map[CustomerVisitLogModelNames.startTime],
      endTime: map[CustomerVisitLogModelNames.endTime],
      startLatitude: map[CustomerVisitLogModelNames.startLatitude],
      startLongitude: map[CustomerVisitLogModelNames.startLongitude],
      closeLatitude: map[CustomerVisitLogModelNames.closeLatitude],
      closeLongitude: map[CustomerVisitLogModelNames.closeLongitude],
      routeID: map[CustomerVisitLogModelNames.routeID],
      vanID: map[CustomerVisitLogModelNames.vanID],
      isSkipped: map[CustomerVisitLogModelNames.isSkipped],
      reasonForSkipping: map[CustomerVisitLogModelNames.reasonForSkipping],
      isSynced: map[CustomerVisitLogModelNames.isSynced],
      isError: map[CustomerVisitLogModelNames.isError],
      error: map[CustomerVisitLogModelNames.error],
    );
  }
}
