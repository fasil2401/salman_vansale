import 'dart:developer';
import 'dart:io';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/model/Account%20Model/account_model.dart';
import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/model/Company%20Model/company_model.dart';
import 'package:axoproject/model/Customer%20Balance%20Model/customer_balance_model.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Customer%20Visit%20Log%20Model/customer_visit_log_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/model/Route%20Model/route_model.dart';
import 'package:axoproject/model/Route%20Price%20Model/route_price_model.dart';
import 'package:axoproject/model/Security%20Model/security_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Db%20Helper/query_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../model/Local Db Model/Expense Transaction Model/expense_transaction_model.dart';

class DBHelper {
  final _databaseName = 'axoVan.db';
  final _databaseVersion = 3;
  final _newVersion = 4;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    // final applicationPath = await getDatabaseApplicationPath();
    // final folderPath = await getDatabaseExternalPath();
    final path = join(await getDatabasesPath(), _databaseName);
    // final path = join(applicationPath, _databaseName);
    // final path = join(folderPath, _databaseName);
    return await openDatabase(path,
        version: _newVersion,
        onCreate: (db, version) => _onCreate(db),
        onUpgrade: _onUpgrade);
  }

  getDatabaseApplicationPath() async {
    Directory? applicationPath = await getApplicationDocumentsDirectory();
    return applicationPath.path;
  }

  getDatabaseExternalPath() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status1 = await Permission.storage.status;
    if (!status1.isGranted) {
      await Permission.storage.request();
    }
    try {
      Directory? folderToCreate = Directory('/storage/emulated/0/Inventory/');
      await folderToCreate.create(recursive: true);
      // print(
      //     'newly created folderpath ================> ${folderToCreate.path}');
      return folderToCreate.path;
      // String databasePath = await getDatabasesPath();
      // print('path =========================$databasePath');
      // Directory? externalStoragePath = await getExternalStorageDirectory();
      // print(
      //     'externalStoragePath =========================${externalStoragePath!.path}');
    } catch (e) {
      log('error =========================${e.toString()}');
    }
  }

  // var dbUpgradeQueryTable = [
  //   '''
  //   CREATE TABLE ${ConnectionModelImpNames.tableName}(
  //      ${ConnectionModelImpNames.connectionName} TEXT,
  //      ${ConnectionModelImpNames.serverIp} TEXT,
  //       ${ConnectionModelImpNames.port} TEXT,
  //       ${ConnectionModelImpNames.databaseName} TEXT,
  //       ${ConnectionModelImpNames.userName} TEXT,
  //       ${ConnectionModelImpNames.password} TEXT
  //   )
  //   ''',
  // ];

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (_newVersion > _databaseVersion) {
      for (int i = 0; i < (newVersion - oldVersion); i++) {
        try {
          await db.execute(QuerryTable.dbUpgradeQueryTable[i]);
        } catch (e) {
          continue;
        }
      }
    }
  }

  _onCreate(Database db) async {
    // db.execute('''
    // CREATE TABLE ${UserActivityLogImportantNames.tableName}(
    //   ${UserActivityLogImportantNames.activityType} TEXT,
    //   ${UserActivityLogImportantNames.date} TEXT,
    //   ${UserActivityLogImportantNames.userId} TEXT,
    //   ${UserActivityLogImportantNames.machine} TEXT,
    //   ${UserActivityLogImportantNames.description} TEXT
    // )
    // ''');
    // db.execute('''
    // CREATE TABLE ${ConnectionModelImpNames.tableName}(
    //    ${ConnectionModelImpNames.connectionName} TEXT,
    //    ${ConnectionModelImpNames.serverIp} TEXT,
    //     ${ConnectionModelImpNames.port} TEXT,
    //     ${ConnectionModelImpNames.databaseName} TEXT,
    //     ${ConnectionModelImpNames.userName} TEXT,
    //     ${ConnectionModelImpNames.password} TEXT
    // )
    // ''');
    // db.execute('''
    // CREATE TABLE ${SysDocIdLocalImportantNames.tableName}(
    //   ${SysDocIdLocalImportantNames.code} TEXT,
    //   ${SysDocIdLocalImportantNames.name} TEXT,
    //   ${SysDocIdLocalImportantNames.sysDocType} INTEGER,
    //   ${SysDocIdLocalImportantNames.locationId} TEXT,
    //   ${SysDocIdLocalImportantNames.printAfterSave} INTEGER,
    //   ${SysDocIdLocalImportantNames.doPrint} INTEGER,
    //   ${SysDocIdLocalImportantNames.printTemplateName} TEXT,
    //   ${SysDocIdLocalImportantNames.priceIncludeTax} INTEGER,
    //   ${SysDocIdLocalImportantNames.divisionId} TEXT,
    //   ${SysDocIdLocalImportantNames.nextNumber} INTEGER,
    //   ${SysDocIdLocalImportantNames.lastNumber} TEXT,
    //   ${SysDocIdLocalImportantNames.numberPrefix} TEXT
    // )
    // ''');
    for (int i = 0; i < QuerryTable.dbQueryTable.length; i++) {
      try {
        await db.execute(QuerryTable.dbQueryTable[i]);
      } catch (e) {
        continue;
      }
    }
  }

  Future<int> insertCreateTransferHeader(CreateTransferHeaderModel data) async {
    Database? db = await DBHelper._database;
    return await db!.insert(CreateTransferHeaderModelNames.tableName, {
      CreateTransferHeaderModelNames.sysDocType: data.sysDocType,
      CreateTransferHeaderModelNames.sysDocId: data.sysDocId,
      CreateTransferHeaderModelNames.voucherId: data.voucherId,
      CreateTransferHeaderModelNames.reference: data.reference,
      CreateTransferHeaderModelNames.description: data.description,
      CreateTransferHeaderModelNames.customerName: data.customerName,
      CreateTransferHeaderModelNames.transactionDate:
          data.transactionDate?.toIso8601String(),
      CreateTransferHeaderModelNames.dueDate: data.dueDate?.toIso8601String(),
      CreateTransferHeaderModelNames.registerId: data.registerId,
      CreateTransferHeaderModelNames.divisionId: data.divisionId,
      CreateTransferHeaderModelNames.companyId: data.companyId,
      CreateTransferHeaderModelNames.payeeId: data.payeeId,
      CreateTransferHeaderModelNames.payeeType: data.payeeType,
      CreateTransferHeaderModelNames.currencyId: data.currencyId,
      CreateTransferHeaderModelNames.currencyRate: data.currencyRate,
      CreateTransferHeaderModelNames.amount: data.amount,
      CreateTransferHeaderModelNames.headerImage: data.headerImage,
      CreateTransferHeaderModelNames.footerImage: data.footerImage,
      CreateTransferHeaderModelNames.isPos: data.isPos != null
          ? data.isPos!
              ? 1
              : 0
          : null,
      CreateTransferHeaderModelNames.isCheque: data.isCheque != null
          ? data.isCheque!
              ? 1
              : 0
          : null,
      CreateTransferHeaderModelNames.posShiftId: data.posShiftId,
      CreateTransferHeaderModelNames.posBatchId: data.posBatchId,
      CreateTransferHeaderModelNames.isSynced:
          data.isSynced != null ? data.isSynced : null,
      CreateTransferHeaderModelNames.isError:
          data.isError != null ? data.isError! : null,
      CreateTransferHeaderModelNames.error: data.error,
    });
  }

  insertTransactionAllocationDetail(
      List<TransactionAllocationDetailModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(TransactionAllocationDetailModelNames.tableName, {
          TransactionAllocationDetailModelNames.invoiceSysDocId:
              data.invoiceSysDocId,
          TransactionAllocationDetailModelNames.invoiceVoucherId:
              data.invoiceVoucherId,
          TransactionAllocationDetailModelNames.paymentSysDocId:
              data.paymentSysDocId,
          TransactionAllocationDetailModelNames.customerId: data.customerId,
          TransactionAllocationDetailModelNames.paymentVoucherId:
              data.paymentVoucherId,
          TransactionAllocationDetailModelNames.arJournalId: data.arJournalId,
          TransactionAllocationDetailModelNames.paymentArid: data.paymentArid,
          TransactionAllocationDetailModelNames.allocationDate:
              data.allocationDate?.toIso8601String(),
          TransactionAllocationDetailModelNames.paymentAmount:
              data.paymentAmount,
          TransactionAllocationDetailModelNames.isSynced: data.isSynced != null
              ? data.isSynced!
                  ? 1
                  : 0
              : null,
          TransactionAllocationDetailModelNames.dueAmount: data.dueAmount,
          TransactionAllocationDetailModelNames.isChecked: data.isChecked
        });
      }
      await batch.commit();
    });
  }

  insertTransactionDetail(List<TransactionDetailModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(TransactionDetailModelNames.tableName, {
          TransactionDetailModelNames.voucherId: data.voucherId,
          TransactionDetailModelNames.paymentMethodId: data.paymentMethodId,
          TransactionDetailModelNames.paymentMethodType: data.paymentMethodtype,
          TransactionDetailModelNames.bankId: data.bankId,
          TransactionDetailModelNames.description: data.description,
          TransactionDetailModelNames.amount: data.amount,
          TransactionDetailModelNames.amountFc: data.amountFc,
          TransactionDetailModelNames.chequeDate:
              data.chequeDate?.toIso8601String(),
          TransactionDetailModelNames.chequeNumber: data.chequeNumber,
          TransactionDetailModelNames.isSynced: data.isSynced != null
              ? data.isSynced!
                  ? 1
                  : 0
              : null,
        });
      }
      await batch.commit();
    });
  }

  Future<int> insertUserActivityLog(UserActivityLogModel log) async {
    Database? db = await DBHelper._database;
    return await db!.insert(UserActivityLogImportantNames.tableName, {
      UserActivityLogImportantNames.sysDocId: log.sysDocId,
      UserActivityLogImportantNames.voucherId: log.voucherId,
      UserActivityLogImportantNames.activityType: log.activityType,
      UserActivityLogImportantNames.date: log.date,
      UserActivityLogImportantNames.userId: log.userId,
      UserActivityLogImportantNames.machine: log.machine,
      UserActivityLogImportantNames.description: log.description,
      UserActivityLogImportantNames.isSynced: log.isSynced
    });
  }

  Future<int> insertSettings(ConnectionModel setting) async {
    Database? db = await DBHelper._database;
    return await db!.insert(ConnectionModelImpNames.tableName, {
      ConnectionModelImpNames.connectionName: setting.connectionName,
      ConnectionModelImpNames.serverIp: setting.serverIp,
      ConnectionModelImpNames.port: setting.port,
      ConnectionModelImpNames.databaseName: setting.databaseName,
      ConnectionModelImpNames.userName: setting.userName,
      ConnectionModelImpNames.password: setting.password
    });
  }

  Future<int> insertNewOrderHeader(NewOrderApiModel data) async {
    Database? db = await DBHelper._database;
    return await db!.insert(NewOrderApiMOdelNames.tableName, {
      NewOrderApiMOdelNames.salesOrderId: data.salesOrderId,
      NewOrderApiMOdelNames.sysdocid: data.sysdocid,
      NewOrderApiMOdelNames.voucherid: data.voucherid,
      NewOrderApiMOdelNames.customerid: data.customerid,
      NewOrderApiMOdelNames.customerName: data.customerName,
      NewOrderApiMOdelNames.address: data.address,
      NewOrderApiMOdelNames.phone: data.phone,
      NewOrderApiMOdelNames.shiftId: data.shiftId,
      NewOrderApiMOdelNames.batchId: data.batchId,
      NewOrderApiMOdelNames.companyid: data.companyid,
      NewOrderApiMOdelNames.transactiondate: data.transactiondate,
      NewOrderApiMOdelNames.isCash: data.isCash,
      NewOrderApiMOdelNames.registerId: data.registerId,
      NewOrderApiMOdelNames.salespersonid: data.salespersonid,
      NewOrderApiMOdelNames.shippingAddressId: data.shippingAddressId,
      NewOrderApiMOdelNames.customeraddress: data.customeraddress,
      NewOrderApiMOdelNames.payeetaxgroupid: data.payeetaxgroupid,
      NewOrderApiMOdelNames.taxoption: data.taxoption,
      NewOrderApiMOdelNames.priceincludetax: data.priceincludetax,
      NewOrderApiMOdelNames.discount: data.discount,
      NewOrderApiMOdelNames.discountPercentage: data.discountPercentage,
      NewOrderApiMOdelNames.taxamount: data.taxamount,
      NewOrderApiMOdelNames.total: data.total,
      NewOrderApiMOdelNames.note: data.note,
      NewOrderApiMOdelNames.taxGroupId: data.taxGroupId,
      NewOrderApiMOdelNames.paymentMethodType: data.paymentMethodType,
      NewOrderApiMOdelNames.isSynced: data.isSynced,
      NewOrderApiMOdelNames.isError: data.isError,
      NewOrderApiMOdelNames.error: data.error,
      NewOrderApiMOdelNames.routeId: data.routeId,
      NewOrderApiMOdelNames.headerImage: data.headerImage,
      NewOrderApiMOdelNames.footerImage: data.footerImage,
      NewOrderApiMOdelNames.quantity: data.quantity,
    });
  }

  insertNewOrderDetail(List<NewOrderDetailApiModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(NewOrderDetailApiModelNames.tableName, {
          NewOrderDetailApiModelNames.detailId: data.detailId,
          NewOrderDetailApiModelNames.sysDocId: data.sysDocId,
          NewOrderDetailApiModelNames.voucherId: data.voucherId,
          NewOrderDetailApiModelNames.productId: data.productId,
          NewOrderDetailApiModelNames.salesOrderId: data.salesOrderId,
          NewOrderDetailApiModelNames.quantity: data.quantity,
          NewOrderDetailApiModelNames.barcode: data.barcode,
          NewOrderDetailApiModelNames.unitprice: data.unitprice,
          NewOrderDetailApiModelNames.amount: data.amount,
          NewOrderDetailApiModelNames.description: data.description,
          NewOrderDetailApiModelNames.unitid: data.unitid,
          NewOrderDetailApiModelNames.taxoption: data.taxoption,
          NewOrderDetailApiModelNames.taxgroupid: data.taxgroupid,
          NewOrderDetailApiModelNames.taxamount: data.taxamount,
          NewOrderDetailApiModelNames.rowindex: data.rowindex,
          NewOrderDetailApiModelNames.locationid: data.locationid,
          NewOrderDetailApiModelNames.factor: data.factor,
          NewOrderDetailApiModelNames.factorType: data.factorType,
          NewOrderDetailApiModelNames.isManinUnit: data.isManinUnit,
        });
      }
      await batch.commit();
    });
  }

  insertNewOrderLotDetail(List<NewOrderLotApiModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(NewOrderLotApiModelNames.tableName, {
          NewOrderLotApiModelNames.salesLotId: data.salesLotId,
          NewOrderLotApiModelNames.productId: data.productId,
          NewOrderLotApiModelNames.sysDocId: data.sysDocId,
          NewOrderLotApiModelNames.voucherId: data.voucherId,
          NewOrderLotApiModelNames.locationId: data.locationId,
          NewOrderLotApiModelNames.reference2: data.reference2,
          NewOrderLotApiModelNames.reference: data.reference,
          NewOrderLotApiModelNames.cost: data.cost,
          NewOrderLotApiModelNames.unitPrice: data.unitPrice,
          NewOrderLotApiModelNames.rowIndex: data.rowIndex,
          NewOrderLotApiModelNames.unitId: data.unitId,
          NewOrderLotApiModelNames.lotNumber: data.lotNumber,
          NewOrderLotApiModelNames.quantity: data.quantity,
        });
      }
      await batch.commit();
    });
  }

  insertNewOrderTaxDetail(List<TaxDetail> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(TaxDetailNames.tableName, {
          TaxDetailNames.sysDocId: data.sysDocId,
          TaxDetailNames.voucherId: data.voucherId,
          TaxDetailNames.taxLevel: data.taxLevel,
          TaxDetailNames.taxGroupId: data.taxGroupId,
          TaxDetailNames.taxItemId: data.taxItemId,
          TaxDetailNames.taxItemName: data.taxItemName,
          TaxDetailNames.taxRate: data.taxRate,
          TaxDetailNames.calculationMethod: data.calculationMethod,
          TaxDetailNames.taxAmount: data.taxAmount,
          TaxDetailNames.orderIndex: data.orderIndex,
          TaxDetailNames.rowIndex: data.rowIndex,
          TaxDetailNames.accountId: data.accountId,
          TaxDetailNames.currencyId: data.currencyId,
          TaxDetailNames.currencyRate: data.currencyRate
        });
      }
      await batch.commit();
    });
  }

  Future<int> insertSalesInvoiceHeader(SalesInvoiceApiModel data) async {
    Database? db = await DBHelper._database;
    return await db!.insert(SalesInvoiceApiModelNames.tableName, {
      SalesInvoiceApiModelNames.vANSalesPOS: data.vanSalesPos,
      SalesInvoiceApiModelNames.sysdocid: data.sysdocid,
      SalesInvoiceApiModelNames.voucherid: data.voucherid,
      SalesInvoiceApiModelNames.divisionID: data.divisionId,
      SalesInvoiceApiModelNames.companyID: data.companyId,
      SalesInvoiceApiModelNames.shiftID: data.shiftId,
      SalesInvoiceApiModelNames.batchID: data.batchId,
      SalesInvoiceApiModelNames.customerID: data.customerId,
      SalesInvoiceApiModelNames.customerName: data.customerName,
      SalesInvoiceApiModelNames.transactionDate: data.transactionDate,
      SalesInvoiceApiModelNames.registerId: data.registerId,
      SalesInvoiceApiModelNames.paymentType: data.paymentType,
      SalesInvoiceApiModelNames.salespersonId: data.salespersonId,
      SalesInvoiceApiModelNames.address: data.address,
      SalesInvoiceApiModelNames.phone: data.phone,
      SalesInvoiceApiModelNames.note: data.note,
      SalesInvoiceApiModelNames.total: data.total,
      SalesInvoiceApiModelNames.taxAmount: data.taxAmount,
      SalesInvoiceApiModelNames.discount: data.discount,
      SalesInvoiceApiModelNames.taxGroupId: data.taxGroupId,
      SalesInvoiceApiModelNames.reference: data.reference,
      SalesInvoiceApiModelNames.reference1: data.reference1,
      SalesInvoiceApiModelNames.taxOption: data.taxOption,
      SalesInvoiceApiModelNames.dateCreated: data.dateCreated,
      SalesInvoiceApiModelNames.accountID: data.accountID,
      SalesInvoiceApiModelNames.paymentMethodID: data.paymentMethodID,
      SalesInvoiceApiModelNames.headerImage: data.headerImage,
      SalesInvoiceApiModelNames.footerImage: data.footerImage,
      SalesInvoiceApiModelNames.isReturn: data.isReturn,
      SalesInvoiceApiModelNames.isSynced: data.isSynced,
      SalesInvoiceApiModelNames.isError: data.isError,
      SalesInvoiceApiModelNames.error: data.error,
      SalesInvoiceApiModelNames.quantity: data.quantity,
    });
  }

  insertSalesInvoiceDetail(List<SalesInvoiceDetailApiModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(SalesInvoiceDetailApiModelNames.tableName, {
          SalesInvoiceDetailApiModelNames.rowIndex: data.rowIndex,
          SalesInvoiceDetailApiModelNames.productID: data.productId,
          SalesInvoiceDetailApiModelNames.quantity: data.quantity,
          SalesInvoiceDetailApiModelNames.unitPrice: data.unitPrice,
          SalesInvoiceDetailApiModelNames.locationId: data.locationId,
          SalesInvoiceDetailApiModelNames.listedPrice: data.listedPrice,
          SalesInvoiceDetailApiModelNames.amount: data.amount,
          SalesInvoiceDetailApiModelNames.description: data.description,
          SalesInvoiceDetailApiModelNames.discount: data.discount,
          SalesInvoiceDetailApiModelNames.taxAmount: data.taxAmount,
          SalesInvoiceDetailApiModelNames.taxGroupId: data.taxGroupId,
          SalesInvoiceDetailApiModelNames.barcode: data.barcode,
          SalesInvoiceDetailApiModelNames.taxOption: data.taxOption,
          SalesInvoiceDetailApiModelNames.unitId: data.unitId,
          SalesInvoiceDetailApiModelNames.itemType: data.itemType,
          SalesInvoiceDetailApiModelNames.productCategory: data.productCategory,
          SalesInvoiceDetailApiModelNames.voucherId: data.voucherId,
          SalesInvoiceDetailApiModelNames.onHand: data.onHand,
          SalesInvoiceDetailApiModelNames.isDamaged: data.isDamaged,
          SalesInvoiceDetailApiModelNames.customerProductId:
              data.customerProductId,
          // SalesInvoiceDetailApiModelNames.isMainUnit: data.isMainUnit,
          // SalesInvoiceDetailApiModelNames.factor: data.factor,
          // SalesInvoiceDetailApiModelNames.factorType: data.factorType,
        });
      }
      await batch.commit();
    });
  }

  insertSalesInvoiceLotDetail(List<SalesInvoiceLotApiModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(SalesInvoiceLotApiModelNames.tableName, {
          SalesInvoiceLotApiModelNames.productId: data.productId,
          SalesInvoiceLotApiModelNames.locationId: data.locationId,
          SalesInvoiceLotApiModelNames.lotNumber: data.lotNumber,
          SalesInvoiceLotApiModelNames.reference: data.reference,
          SalesInvoiceLotApiModelNames.sourceLotNumber: data.sourceLotNumber,
          SalesInvoiceLotApiModelNames.quantity: data.quantity,
          SalesInvoiceLotApiModelNames.binID: data.binId,
          SalesInvoiceLotApiModelNames.reference2: data.reference2,
          SalesInvoiceLotApiModelNames.sysDocId: data.sysDocId,
          SalesInvoiceLotApiModelNames.voucherId: data.voucherId,
          SalesInvoiceLotApiModelNames.unitPrice: data.unitPrice,
          SalesInvoiceLotApiModelNames.rowIndex: data.rowIndex,
          SalesInvoiceLotApiModelNames.unitId: data.unitid,
        });
      }
      await batch.commit();
    });
  }

  insertSalesInvoiceTaxDetail(List<TaxGroupDetail> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(TaxGroupDetailNames.tableName, {
          TaxGroupDetailNames.sysDocId: data.sysDocId,
          TaxGroupDetailNames.voucherId: data.voucherId,
          TaxGroupDetailNames.taxGroupId: data.taxGroupId,
          TaxGroupDetailNames.taxCode: data.taxCode,
          TaxGroupDetailNames.items: data.items,
          TaxGroupDetailNames.taxRate: data.taxRate,
          TaxGroupDetailNames.calculationMethod: data.calculationMethod,
          TaxGroupDetailNames.taxAmount: data.taxAmount,
          TaxGroupDetailNames.taxExcludeDiscount: data.taxExcludeDiscount,
          TaxGroupDetailNames.currencyId: data.currencyId,
          TaxGroupDetailNames.rowIndex: data.rowIndex,
          TaxGroupDetailNames.orderIndex: data.orderIndex,
        });
      }
      await batch.commit();
    });
  }

  Future<int> insertExpenseHeader(ExpenseTransactionApiModel data) async {
    Database? db = await DBHelper._database;
    return await db!.insert(ExpenseTransactionApiModelNames.tablename, {
      ExpenseTransactionApiModelNames.sysDocID: data.sysDocID,
      ExpenseTransactionApiModelNames.voucherID: data.voucherID,
      ExpenseTransactionApiModelNames.reference: data.reference,
      ExpenseTransactionApiModelNames.transactionDate: data.transactionDate,
      ExpenseTransactionApiModelNames.divisionID: data.divisionID,
      ExpenseTransactionApiModelNames.companyID: data.companyID,
      ExpenseTransactionApiModelNames.amount: data.amount,
      ExpenseTransactionApiModelNames.taxGroupId: data.taxGroupId,
      ExpenseTransactionApiModelNames.taxAmount: data.taxAmount,
      ExpenseTransactionApiModelNames.registerID: data.registerID,
      ExpenseTransactionApiModelNames.headerImage: data.headerImage,
      ExpenseTransactionApiModelNames.footerImage: data.footerImage,
      ExpenseTransactionApiModelNames.isSynced: data.isSynced,
      ExpenseTransactionApiModelNames.isError: data.isError,
      ExpenseTransactionApiModelNames.error: data.error,
    });
  }

  insertExpenseDetail(List<ExpenseTransactionDetailsAPIModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(ExpenseTransactionDetailModelNames.tablename, {
          ExpenseTransactionDetailModelNames.voucherId: data.voucherId,
          ExpenseTransactionDetailModelNames.accountID: data.accountID,
          ExpenseTransactionDetailModelNames.description: data.description,
          ExpenseTransactionDetailModelNames.amount: data.amount,
          ExpenseTransactionDetailModelNames.amountFC: data.amountFC,
          ExpenseTransactionDetailModelNames.taxGroupId: data.taxGroupId,
          ExpenseTransactionDetailModelNames.taxAmount: data.taxAmount,
          ExpenseTransactionDetailModelNames.rowIndex: data.rowIndex,
        });
      }
      await batch.commit();
    });
  }

  insertExpenseTaxDetail(List<SalesPOSTaxGroupDetailApiModel> datas) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var data in datas) {
        batch.insert(SalesPOSTaxGroupDetailApiModelNames.tablename, {
          SalesPOSTaxGroupDetailApiModelNames.sysDocId: data.sysDocId,
          SalesPOSTaxGroupDetailApiModelNames.voucherId: data.voucherId,
          SalesPOSTaxGroupDetailApiModelNames.taxGroupId: data.taxGroupId,
          SalesPOSTaxGroupDetailApiModelNames.taxCode: data.taxCode,
          SalesPOSTaxGroupDetailApiModelNames.items: data.items,
          SalesPOSTaxGroupDetailApiModelNames.taxRate: data.taxRate,
          SalesPOSTaxGroupDetailApiModelNames.calculationMethod:
              data.calculationMethod,
          SalesPOSTaxGroupDetailApiModelNames.taxAmount: data.taxAmount,
          SalesPOSTaxGroupDetailApiModelNames.currencyID: data.currencyID,
          SalesPOSTaxGroupDetailApiModelNames.rowIndex: data.rowIndex,
          SalesPOSTaxGroupDetailApiModelNames.orderIndex: data.orderIndex,
        });
      }
      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    Database? db = await DBHelper._database;
    return await db!.query(CreateTransferHeaderModelNames.tableName);
  }

  Future<List<Map<String, dynamic>>> queryAllTransactionAllocationDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString =
        '${TransactionAllocationDetailModelNames.paymentVoucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(TransactionAllocationDetailModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryAllTransactionDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${TransactionDetailModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(TransactionDetailModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryAllActivities() async {
    Database? db = await DBHelper._database;
    return await db!.query(UserActivityLogImportantNames.tableName);
  }

  Future<List<Map<String, dynamic>>> queryAllSettings() async {
    Database? db = await DBHelper._database;
    return await db!.query(ConnectionModelImpNames.tableName);
  }

  Future<List<Map<String, dynamic>>> queryAllNewOrderHeaders() async {
    Database? db = await DBHelper._database;
    return await db!.query(
      NewOrderApiMOdelNames.tableName,
    );
  }

  Future<List<Map<String, dynamic>>> queryNewOrderDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${NewOrderDetailApiModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(NewOrderDetailApiModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryNewOrderLotDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${NewOrderLotApiModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(NewOrderLotApiModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryNewOrderTaxDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${TaxDetailNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(TaxDetailNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryAllSalesInvoiceHeaders() async {
    Database? db = await DBHelper._database;
    return await db!.query(
      SalesInvoiceApiModelNames.tableName,
    );
  }

  Future<Map<String, dynamic>?> querySalesInvoiceHeaderUsingVoucher(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${SalesInvoiceApiModelNames.voucherid} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      SalesInvoiceApiModelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> queryNewOrderHeaderUsingVoucher(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${NewOrderApiMOdelNames.voucherid} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      NewOrderApiMOdelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllExpenseHeaders() async {
    Database? db = await DBHelper._database;
    return await db!.query(
      ExpenseTransactionApiModelNames.tablename,
    );
  }

  Future<Map<String, dynamic>?> queryExpenseHeaderUsingVoucher(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${ExpenseTransactionApiModelNames.voucherID} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      ExpenseTransactionApiModelNames.tablename,
      where: whereString,
      whereArgs: whereArguments,
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> queryPaymenteHeaderUsingVoucher(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${CreateTransferHeaderModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      CreateTransferHeaderModelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<int?> getLastVoucher(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> rows = await db!.query(
      SalesInvoiceApiModelNames.tableName,
      orderBy: '${SalesInvoiceApiModelNames.voucherid} DESC',
      limit: 1,
    );
    int lastNumber = nextNumber;
    if (rows.isNotEmpty) {
      int number = int.parse(
          rows.first[SalesInvoiceApiModelNames.voucherid].split(prefix).last);
      lastNumber = number + 1;
      await updateSysDocNextNumber(nextNumber: lastNumber, sysDoc: sysDoc);
    }
    return lastNumber;
  }

  Future<bool> isVoucherPresentInTable(String voucher) async {
    log(voucher, name: 'VoucherId Checking');
    Database? db = await DBHelper._database;
    String whereString = '${SalesInvoiceApiModelNames.voucherid} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      SalesInvoiceApiModelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );
    return results.isNotEmpty;
  }

  Future<int?> getLastVoucherPaymentCollection(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    Database? db = await DBHelper._database;
    String whereString = '${CreateTransferHeaderModelNames.sysDocId} = ?';
    List<dynamic> whereArguments = [sysDoc];

    List<Map<String, dynamic>> rows = await db!.query(
      CreateTransferHeaderModelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
      orderBy: '${CreateTransferHeaderModelNames.voucherId} DESC',
      limit: 1,
    );
    int lastNumber = nextNumber;
    if (rows.isNotEmpty) {
      int number = int.parse(rows
          .first[CreateTransferHeaderModelNames.voucherId]
          .split(prefix)
          .last);
      lastNumber = number + 1;
      await updateSysDocNextNumber(nextNumber: lastNumber, sysDoc: sysDoc);
    }
    return lastNumber;
  }

  Future<bool> isVoucherPresentInTablePaymentCollection(String voucher) async {
    log(voucher, name: 'VoucherId Checking');
    Database? db = await DBHelper._database;
    String whereString = '${CreateTransferHeaderModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      CreateTransferHeaderModelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );
    return results.isNotEmpty;
  }

  Future<int?> getLastVoucherNewOrder(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> rows = await db!.query(
      NewOrderApiMOdelNames.tableName,
      orderBy: '${NewOrderApiMOdelNames.voucherid} DESC',
      limit: 1,
    );
    int lastNumber = nextNumber;
    if (rows.isNotEmpty) {
      int number = int.parse(rows.first[NewOrderApiMOdelNames.voucherid]);
      lastNumber = number + 1;
      await updateSysDocNextNumber(nextNumber: lastNumber, sysDoc: sysDoc);
    }
    return lastNumber;
  }

  Future<bool> isVoucherPresentInTableNewOrder(String voucher) async {
    log(voucher, name: 'Voucherid Checking');
    Database? db = await DBHelper._database;
    String whereString = '${NewOrderApiMOdelNames.voucherid} = ?';
    List<dynamic> whereArguments = [voucher];
    List<Map<String, dynamic>> results = await db!.query(
      NewOrderApiMOdelNames.tableName,
      where: whereString,
      whereArgs: whereArguments,
    );
    return results.isNotEmpty;
  }

  Future<int?> getLastVoucherExpense(
      {required String prefix,
      required String sysDoc,
      required int nextNumber}) async {
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> rows = await db!.query(
      ExpenseTransactionApiModelNames.tablename,
      orderBy: '${ExpenseTransactionApiModelNames.voucherID} DESC',
      limit: 1,
    );
    int lastNumber = nextNumber;
    if (rows.isNotEmpty) {
      int number = int.parse(rows
          .first[ExpenseTransactionApiModelNames.voucherID]
          .split(prefix)
          .last);
      lastNumber = number + 1;
      await updateSysDocNextNumber(nextNumber: lastNumber, sysDoc: sysDoc);
    }
    return lastNumber;
  }

  Future<List<Map<String, dynamic>>> querySalesInvoiceDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${SalesInvoiceDetailApiModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(SalesInvoiceDetailApiModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> querySalesInvoiceLotDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${SalesInvoiceLotApiModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(SalesInvoiceLotApiModelNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> querySalesInvoiceTaxDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${TaxGroupDetailNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(TaxGroupDetailNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryExpenseDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${ExpenseTransactionDetailModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(ExpenseTransactionDetailModelNames.tablename,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryExpenseTaxDetails(
      {required String voucher}) async {
    Database? db = await DBHelper._database;
    String whereString = '${SalesPOSTaxGroupDetailApiModelNames.voucherId} = ?';
    List<dynamic> whereArguments = [voucher];
    return await db!.query(SalesPOSTaxGroupDetailApiModelNames.tablename,
        where: whereString, whereArgs: whereArguments);
  }

  Future<int> updateConnectionSettings(
      String connectionName, String userName, String password) async {
    log("${connectionName}", name: "connection name test");
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ConnectionModelImpNames.tableName}
    SET ${ConnectionModelImpNames.userName} = ?, ${ConnectionModelImpNames.password} = ?
    WHERE ${ConnectionModelImpNames.connectionName} = ?
    ''', [userName, password, connectionName]);
  }

  Future<int> updateFields({
    required String connectionName,
    required String serverIp,
    required String port,
    required String databaseName,
  }) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ConnectionModelImpNames.tableName}
    SET ${ConnectionModelImpNames.serverIp} = ?, 
    ${ConnectionModelImpNames.port} = ?,
    ${ConnectionModelImpNames.databaseName} = ?
    WHERE ${ConnectionModelImpNames.connectionName} = ?
    ''', [serverIp, port, databaseName, connectionName]);
  }

  Future<int> updateNewOrderHeader(String voucherId, int isSynced, int isError,
      String error, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${NewOrderApiMOdelNames.tableName}
    SET ${NewOrderApiMOdelNames.isSynced} = ?, ${NewOrderApiMOdelNames.isError} = ?, ${NewOrderApiMOdelNames.error} = ?, ${NewOrderApiMOdelNames.voucherid} = ?
    WHERE ${NewOrderApiMOdelNames.voucherid} = ?
    ''', [isSynced, isError, error, docNo, voucherId]);
  }

  Future<int> updateNewOrderDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${NewOrderDetailApiModelNames.tableName}
    SET ${NewOrderDetailApiModelNames.voucherId} = ?
    WHERE ${NewOrderDetailApiModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateNewOrderLotDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${NewOrderLotApiModelNames.tableName}
    SET ${NewOrderLotApiModelNames.voucherId} = ?
    WHERE ${NewOrderLotApiModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateNewOrderTaxDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${TaxDetailNames.tableName}
    SET ${TaxDetailNames.voucherId} = ?
    WHERE ${TaxDetailNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateSalesInvoiceHeader(String voucherId, int isSynced,
      int isError, String error, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SalesInvoiceApiModelNames.tableName}
    SET ${SalesInvoiceApiModelNames.isSynced} = ?, ${SalesInvoiceApiModelNames.isError} = ?, ${SalesInvoiceApiModelNames.error} = ?, ${SalesInvoiceApiModelNames.voucherid} = ?
    WHERE ${SalesInvoiceApiModelNames.voucherid} = ?
    ''', [isSynced, isError, error, docNo, voucherId]);
  }

  Future<int> updateCustomerVisit(
      String startVisit, int isSynced, int isError, String error) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${CustomerVisitLogModelNames.tableName}
    SET ${CustomerVisitLogModelNames.isSynced} = ?, ${CustomerVisitLogModelNames.isError} = ?, ${CustomerVisitLogModelNames.error} = ?, ${CustomerVisitLogModelNames.startTime} = ?
    WHERE ${CustomerVisitLogModelNames.startTime} = ?
    ''', [isSynced, isError, error, startVisit]);
  }

  Future<int> updateAsNewSalesInvoiceHeader(
      String voucherId, SalesInvoiceApiModel header) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SalesInvoiceApiModelNames.tableName}
    SET ${SalesInvoiceApiModelNames.vANSalesPOS} =?,
  ${SalesInvoiceApiModelNames.sysdocid} =?,
  ${SalesInvoiceApiModelNames.divisionID} =?,
  ${SalesInvoiceApiModelNames.companyID} =?,
  ${SalesInvoiceApiModelNames.shiftID} =?,
  ${SalesInvoiceApiModelNames.batchID} =?,
  ${SalesInvoiceApiModelNames.customerID} =?,
  ${SalesInvoiceApiModelNames.customerName} =?,
  ${SalesInvoiceApiModelNames.transactionDate} =?,
  ${SalesInvoiceApiModelNames.registerId} =?,
  ${SalesInvoiceApiModelNames.paymentType} =?,
  ${SalesInvoiceApiModelNames.salespersonId} =?,
  ${SalesInvoiceApiModelNames.address} =?,
  ${SalesInvoiceApiModelNames.phone} =?,
  ${SalesInvoiceApiModelNames.note} =?,
  ${SalesInvoiceApiModelNames.total} =?, 
  ${SalesInvoiceApiModelNames.taxAmount} =?,
  ${SalesInvoiceApiModelNames.discount} =?,
  ${SalesInvoiceApiModelNames.taxGroupId} =?,
  ${SalesInvoiceApiModelNames.reference} =?,
  ${SalesInvoiceApiModelNames.reference1} =?,
  ${SalesInvoiceApiModelNames.taxOption} =?,
  ${SalesInvoiceApiModelNames.dateCreated} =?,
  ${SalesInvoiceApiModelNames.accountID} =?,
  ${SalesInvoiceApiModelNames.paymentMethodID} =?,
  ${SalesInvoiceApiModelNames.headerImage} =?,
  ${SalesInvoiceApiModelNames.footerImage} =?,
  ${SalesInvoiceApiModelNames.isReturn} =?,
  ${SalesInvoiceApiModelNames.isSynced} =?,
  ${SalesInvoiceApiModelNames.isError} =?,
  ${SalesInvoiceApiModelNames.error} =?,
  ${SalesInvoiceApiModelNames.quantity} =?
    WHERE ${SalesInvoiceApiModelNames.voucherid} = ?
    ''', [
      header.vanSalesPos ?? '',
      header.sysdocid,
      header.divisionId,
      header.companyId,
      header.shiftId,
      header.batchId,
      header.customerId,
      header.customerName,
      header.transactionDate,
      header.registerId,
      header.paymentType,
      header.salespersonId,
      header.address,
      header.phone,
      header.note,
      header.total,
      header.taxAmount,
      header.discount,
      header.taxGroupId,
      header.reference,
      header.reference1,
      header.taxOption,
      header.dateCreated,
      header.accountID,
      header.paymentMethodID,
      header.headerImage,
      header.footerImage,
      header.isReturn,
      header.isSynced,
      header.isError,
      header.error,
      header.quantity,
      voucherId
    ]);
  }

  Future<int> updateAsNewPaymentTransactionHeader(String voucherId,
      CreateTransferHeaderModel header, String sysDocId) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${CreateTransferHeaderModelNames.tableName}
    SET
      ${CreateTransferHeaderModelNames.sysDocType} =?,
      ${CreateTransferHeaderModelNames.reference} =?,
      ${CreateTransferHeaderModelNames.description} =?,
      ${CreateTransferHeaderModelNames.customerName} =?,
      ${CreateTransferHeaderModelNames.transactionDate} =?,
      ${CreateTransferHeaderModelNames.dueDate} =?,
      ${CreateTransferHeaderModelNames.registerId} =?,
      ${CreateTransferHeaderModelNames.divisionId} =?,
      ${CreateTransferHeaderModelNames.companyId} =?,
      ${CreateTransferHeaderModelNames.payeeId} =?,
      ${CreateTransferHeaderModelNames.payeeType} =?,
      ${CreateTransferHeaderModelNames.currencyId} =?,
      ${CreateTransferHeaderModelNames.currencyRate} =?,
      ${CreateTransferHeaderModelNames.amount} =?,
      ${CreateTransferHeaderModelNames.headerImage} =?,
      ${CreateTransferHeaderModelNames.isPos} =?,
      ${CreateTransferHeaderModelNames.isCheque} =?,
      ${CreateTransferHeaderModelNames.posShiftId} =?,
      ${CreateTransferHeaderModelNames.posBatchId} =?,
      ${CreateTransferHeaderModelNames.isSynced} =?,
      ${CreateTransferHeaderModelNames.isError} =?,
      ${CreateTransferHeaderModelNames.error} =?
    WHERE ${CreateTransferHeaderModelNames.sysDocId} =? AND
          ${CreateTransferHeaderModelNames.voucherId} =?
    ''', [
      header.sysDocType ?? '',
      header.reference,
      header.description,
      header.customerName,
      header.transactionDate!.toIso8601String(),
      header.dueDate!.toIso8601String(),
      header.registerId,
      header.divisionId,
      header.companyId,
      header.payeeId,
      header.payeeType,
      header.currencyId,
      header.currencyRate,
      header.amount,
      header.headerImage,
      header.isPos,
      header.isCheque,
      header.posShiftId,
      header.posBatchId,
      header.isSynced,
      header.isError,
      header.error,
      sysDocId, // Bind sysDocId for the WHERE clause
      voucherId, // Bind voucherId for the WHERE clause
    ]);
  }

  Future<int> updateAsNewNewOrderHeader(
      String voucherId, NewOrderApiModel header) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${NewOrderApiMOdelNames.tableName}
    SET ${NewOrderApiMOdelNames.salesOrderId} =?,
  ${NewOrderApiMOdelNames.sysdocid}=?,
  ${NewOrderApiMOdelNames.customerid} =?,
  ${NewOrderApiMOdelNames.customerName} =?,
  ${NewOrderApiMOdelNames.address} =?,
  ${NewOrderApiMOdelNames.phone} =?,
  ${NewOrderApiMOdelNames.shiftId} =?,
  ${NewOrderApiMOdelNames.batchId} =?,
  ${NewOrderApiMOdelNames.companyid} =?,
  ${NewOrderApiMOdelNames.transactiondate} =?,
  ${NewOrderApiMOdelNames.isCash} =?,
  ${NewOrderApiMOdelNames.registerId} =?,
  ${NewOrderApiMOdelNames.salespersonid} =?,
  ${NewOrderApiMOdelNames.shippingAddressId} =?,
  ${NewOrderApiMOdelNames.customeraddress} =?,
  ${NewOrderApiMOdelNames.payeetaxgroupid} =?,
  ${NewOrderApiMOdelNames.taxoption} =?,
  ${NewOrderApiMOdelNames.priceincludetax} =?,
  ${NewOrderApiMOdelNames.discount} =?,
  ${NewOrderApiMOdelNames.discountPercentage} =?,
  ${NewOrderApiMOdelNames.taxamount} =?,
  ${NewOrderApiMOdelNames.total} =?,
  ${NewOrderApiMOdelNames.note} =?,
  ${NewOrderApiMOdelNames.paymentMethodType} =?,
  ${NewOrderApiMOdelNames.isSynced} =?,
  ${NewOrderApiMOdelNames.isError} =?,
  ${NewOrderApiMOdelNames.error} =?,
  ${NewOrderApiMOdelNames.routeId} =?,
  ${NewOrderApiMOdelNames.taxGroupId} =?,
  ${NewOrderApiMOdelNames.headerImage} =?,
  ${NewOrderApiMOdelNames.footerImage} =?,
  ${NewOrderApiMOdelNames.quantity}  =?
    WHERE ${NewOrderApiMOdelNames.voucherid} = ?
    ''', [
      header.salesOrderId,
      header.sysdocid,
      header.customerid,
      header.customerName,
      header.address,
      header.phone,
      header.shiftId,
      header.batchId,
      header.companyid,
      header.transactiondate,
      header.isCash,
      header.registerId,
      header.salespersonid,
      header.shippingAddressId,
      header.customeraddress,
      header.payeetaxgroupid,
      header.taxoption,
      header.priceincludetax,
      header.discount,
      header.discountPercentage,
      header.taxamount,
      header.total,
      header.note,
      header.paymentMethodType,
      header.isSynced,
      header.isError,
      header.error,
      header.routeId,
      header.taxGroupId,
      header.headerImage,
      header.footerImage,
      header.quantity,
      voucherId
    ]);
  }

  Future<int> updateSalesInvoiceDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SalesInvoiceDetailApiModelNames.tableName}
    SET ${SalesInvoiceDetailApiModelNames.voucherId} = ?
    WHERE ${SalesInvoiceDetailApiModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateSalesInvoiceLotDetail(
      String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SalesInvoiceLotApiModelNames.tableName}
    SET ${SalesInvoiceLotApiModelNames.voucherId} = ?
    WHERE ${SalesInvoiceLotApiModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateSalesInvoiceTaxDetail(
      String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${TaxDetailNames.tableName}
    SET ${TaxDetailNames.voucherId} = ?
    WHERE ${TaxDetailNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateCreateTransferHeader(String voucherId, int isSynced,
      int isError, String error, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${CreateTransferHeaderModelNames.tableName}
    SET ${CreateTransferHeaderModelNames.isSynced} = ?, ${CreateTransferHeaderModelNames.isError} = ?, ${CreateTransferHeaderModelNames.error} = ?, ${CreateTransferHeaderModelNames.voucherId} = ?
    WHERE ${CreateTransferHeaderModelNames.voucherId} = ?
    ''', [isSynced, isError, error, docNo, voucherId]);
  }

  Future<int> updateTransactionAllocationDetails(
      String voucherId, String docNo, int isSynced) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${TransactionAllocationDetailModelNames.tableName}
    SET ${TransactionAllocationDetailModelNames.invoiceVoucherId} = ?, ${TransactionAllocationDetailModelNames.isSynced} = ?
    WHERE ${TransactionAllocationDetailModelNames.invoiceVoucherId} = ?
    ''', [docNo, voucherId, isSynced]);
  }

  Future<int> updateTransactionDetails(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${TransactionDetailModelNames.tableName}
    SET ${TransactionDetailModelNames.voucherId} = ?
    WHERE ${TransactionDetailModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateExpensesHeader(String voucherId, int isSynced, int isError,
      String error, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ExpenseTransactionApiModelNames.tablename}
    SET ${ExpenseTransactionApiModelNames.isSynced} = ?, ${ExpenseTransactionApiModelNames.isError} = ?, ${ExpenseTransactionApiModelNames.error} = ?, ${ExpenseTransactionApiModelNames.voucherID} = ?
    WHERE ${ExpenseTransactionApiModelNames.voucherID} = ?
    ''', [isSynced, isError, error, docNo, voucherId]);
  }

  Future<int> updateAsNewExpensesHeader(
      String voucherId, ExpenseTransactionApiModel header) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ExpenseTransactionApiModelNames.tablename}
    SET ${ExpenseTransactionApiModelNames.sysDocID} =?,
  ${ExpenseTransactionApiModelNames.voucherID} =?,
  ${ExpenseTransactionApiModelNames.reference} =?,
  ${ExpenseTransactionApiModelNames.transactionDate} =?,
  ${ExpenseTransactionApiModelNames.divisionID} =?,
  ${ExpenseTransactionApiModelNames.companyID} =?,
  ${ExpenseTransactionApiModelNames.amount} =?,
  ${ExpenseTransactionApiModelNames.taxGroupId} =?, 
  ${ExpenseTransactionApiModelNames.taxAmount} =?,
  ${ExpenseTransactionApiModelNames.isSynced} =?,
  ${ExpenseTransactionApiModelNames.isError} =?,
  ${ExpenseTransactionApiModelNames.error} =?
    WHERE ${ExpenseTransactionApiModelNames.voucherID} = ?
    ''', [
      header.sysDocID,
      header.voucherID,
      header.reference,
      header.transactionDate,
      header.divisionID,
      header.companyID,
      header.amount,
      header.taxGroupId,
      header.taxAmount,
      header.isSynced,
      header.isError,
      header.error,
      voucherId
    ]);
  }

  Future<int> updateExpensesDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${ExpenseTransactionDetailModelNames.tablename}
    SET ${ExpenseTransactionDetailModelNames.voucherId} = ?
    WHERE ${ExpenseTransactionDetailModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<int> updateExpensesTaxDetail(String voucherId, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SalesPOSTaxGroupDetailApiModelNames.tablename}
    SET ${SalesPOSTaxGroupDetailApiModelNames.voucherId} = ?
    WHERE ${SalesPOSTaxGroupDetailApiModelNames.voucherId} = ?
    ''', [docNo, voucherId]);
  }

  Future<double> getUrrentStock({
    required String productId,
  }) async {
    double stock = 0.0;
    List<SalesInvoiceApiModel> headersList = [];
    List<SalesInvoiceDetailApiModel> detailList = [];
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> result = await db!.query(
      ProductListLocalImportantNames.tableName,
      where: '${ProductListLocalImportantNames.productID} = ?',
      whereArgs: [productId],
    );
    double openingStock =
        result[0][ProductListLocalImportantNames.openingStock];
    String whereString = '${SalesInvoiceLotApiModelNames.productId} = ?';
    List<dynamic> whereArguments = [productId];
    List<Map<String, dynamic>> details = await db.query(
        SalesInvoiceLotApiModelNames.tableName,
        where: whereString,
        whereArgs: whereArguments);
    detailList.addAll(details
        .map((data) => SalesInvoiceDetailApiModel.fromMap(data))
        .toList());
    List<Map<String, dynamic>> headers = await db.query(
      SalesInvoiceApiModelNames.tableName,
    );
    headersList.addAll(
        headers.map((data) => SalesInvoiceApiModel.fromMap(data)).toList());
    for (var item in detailList) {}

    return stock;
  }

  Future<int> updateProductStockDetails(
      {required String productId,
      required ProductQuantityCombo quantity,
      required bool isReturn,
      required bool isClearing,
      required bool isUpdating,
      required bool isDamage}) async {
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> result = await db!.query(
      ProductListLocalImportantNames.tableName,
      where: '${ProductListLocalImportantNames.productID} = ?',
      whereArgs: [productId],
    );
    double onHand = result[0][ProductListLocalImportantNames.quantity];
    log('onHand : $result' +
        'value ${((onHand + quantity.initialQuantity) - quantity.finalQuantity)}');
    double saleQuantity =
        result[0][ProductListLocalImportantNames.saleQuantity];
    double returnQuantity =
        result[0][ProductListLocalImportantNames.returnQuantity];
    return await db.rawUpdate('''
    UPDATE ${ProductListLocalImportantNames.tableName}
    SET ${ProductListLocalImportantNames.quantity} = ?,${ProductListLocalImportantNames.saleQuantity} = ?,${ProductListLocalImportantNames.returnQuantity} = ?
    WHERE ${ProductListLocalImportantNames.productID} = ?
    ''', [
      isReturn
          ? isDamage
              ? (((onHand + quantity.initialQuantity) - quantity.finalQuantity))
              : ((onHand - quantity.initialQuantity) + quantity.finalQuantity)
          : (((onHand + quantity.initialQuantity) - quantity.finalQuantity)),
      isReturn
          ? saleQuantity
          : ((saleQuantity - (quantity.initialQuantity)) +
              (quantity.finalQuantity)),
      isReturn
          ? ((returnQuantity - (isDamage ? 0.0 : quantity.initialQuantity)) +
              (isDamage ? 0.0 : quantity.finalQuantity))
          : returnQuantity,
      productId
      // isReturn
      //     ? isDamage
      //         ? ((onHand - (isClearing ? 0.0 : quantity.initialQuantity)) -
      //             (isClearing ? 0.0 : quantity.finalQuantity) +
      //             (isClearing ? quantity.initialQuantity : 0.0))
      //         : ((onHand - quantity.initialQuantity) + (quantity.finalQuantity))
      //     : ((onHand + quantity.initialQuantity) - quantity.finalQuantity),
      // isReturn
      //     ? saleQuantity
      //     : ((saleQuantity - quantity.initialQuantity) +
      //         (quantity.finalQuantity)),
      // isReturn
      //     ? ((returnQuantity -
      //             (isDamage && isClearing ? 0.0 : quantity.initialQuantity)) +
      //         (isDamage ? 0.0 : quantity.finalQuantity))
      //     : returnQuantity,
      // productId
    ]);
  }

  Future<int> updateActivityLog(String voucherId, int isSynced, int isError,
      String error, String docNo) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${UserActivityLogImportantNames.tableName}
    SET ${UserActivityLogImportantNames.isSynced} = ?, ${UserActivityLogImportantNames.isError} = ?, ${UserActivityLogImportantNames.error} = ?, ${UserActivityLogImportantNames.voucherId} = ?
    WHERE ${UserActivityLogImportantNames.voucherId} = ?
    ''', [isSynced, isError, error, docNo, voucherId]);
  }

  Future<int> deleteCreateTransferHeader(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(CreateTransferHeaderModelNames.tableName,
        where: '${CreateTransferHeaderModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteTransactionAllocationDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(TransactionAllocationDetailModelNames.tableName,
        where: '${TransactionAllocationDetailModelNames.paymentVoucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteTransactionDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(TransactionDetailModelNames.tableName,
        where: '${TransactionDetailModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteNewOrderHeader(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(NewOrderApiMOdelNames.tableName,
        where: '${NewOrderApiMOdelNames.voucherid} = ?', whereArgs: [voucher]);
  }

  Future<int> deleteNewOrderDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(NewOrderDetailApiModelNames.tableName,
        where: '${NewOrderDetailApiModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteNewOrderLotDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(NewOrderLotApiModelNames.tableName,
        where: '${NewOrderLotApiModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteNewOrderTaxDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(TaxDetailNames.tableName,
        where: '${TaxDetailNames.voucherId} = ?', whereArgs: [voucher]);
  }

  Future<int> deleteSalesInvoiceHeader(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(SalesInvoiceApiModelNames.tableName,
        where: '${SalesInvoiceApiModelNames.voucherid} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteSalesInvoiceDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(SalesInvoiceDetailApiModelNames.tableName,
        where: '${SalesInvoiceDetailApiModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteSalesInvoiceLotDetails(String voucher) async {
    Database? db = await DBHelper._database;
    int status = await db!.delete(SalesInvoiceLotApiModelNames.tableName,
        where: '${SalesInvoiceLotApiModelNames.voucherId} = ?',
        whereArgs: [voucher]);
    log(status.toString(), name: 'lot details deleting');
    return status;
  }

  Future<int> deleteSalesInvoiceTaxDetails(String voucher) async {
    log(voucher, name: 'tax details deleting');
    Database? db = await DBHelper._database;
    int status = await db!.delete(TaxGroupDetailNames.tableName,
        where: '${TaxGroupDetailNames.voucherId} = ?', whereArgs: [voucher]);
    log(status.toString(), name: 'tax details deleting');
    return status;
  }

  Future<int> deleteExpensesHeader(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(ExpenseTransactionApiModelNames.tablename,
        where: '${ExpenseTransactionApiModelNames.voucherID} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteExpensesDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(ExpenseTransactionDetailModelNames.tablename,
        where: '${ExpenseTransactionDetailModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteExpensesTaxDetails(String voucher) async {
    Database? db = await DBHelper._database;
    return await db!.delete(SalesPOSTaxGroupDetailApiModelNames.tablename,
        where: '${SalesPOSTaxGroupDetailApiModelNames.voucherId} = ?',
        whereArgs: [voucher]);
  }

  Future<int> deleteConnectionSettings(String name) async {
    Database? db = await DBHelper._database;
    return await db!.delete(ConnectionModelImpNames.tableName,
        where: '${ConnectionModelImpNames.connectionName} = ?',
        whereArgs: [name]);
  }

  deleteSettingsTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(ConnectionModelImpNames.tableName);
  }

  deleteUserActivityLogTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(UserActivityLogImportantNames.tableName);
  }

// pos cash register start
  insertCashRegisterList(List<PosCashRegisterModel> cashRegisterList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var cashRegister in cashRegisterList) {
        batch.insert(PosCashRegisterListLocalImportantNames.tableName, {
          PosCashRegisterListLocalImportantNames.cashRegisterID:
              cashRegister.cashRegisterID,
          PosCashRegisterListLocalImportantNames.cashRegisterName:
              cashRegister.cashRegisterName,
          PosCashRegisterListLocalImportantNames.locationID:
              cashRegister.locationID,
          PosCashRegisterListLocalImportantNames.registerType:
              cashRegister.registerType,
          PosCashRegisterListLocalImportantNames.computerName:
              cashRegister.computerName,
          PosCashRegisterListLocalImportantNames.receiptDocID:
              cashRegister.receiptDocID,
          PosCashRegisterListLocalImportantNames.returnDocID:
              cashRegister.returnDocID,
          PosCashRegisterListLocalImportantNames.defaultCustomerID:
              cashRegister.defaultCustomerID,
          PosCashRegisterListLocalImportantNames.discountAccountID:
              cashRegister.discountAccountID,
          PosCashRegisterListLocalImportantNames.expenseDocID:
              cashRegister.expenseDocID,
          PosCashRegisterListLocalImportantNames.pettyCashAccountID:
              cashRegister.pettyCashAccountID,
          PosCashRegisterListLocalImportantNames.cashReceiptDocID:
              cashRegister.cashReceiptDocID,
          PosCashRegisterListLocalImportantNames.chequeReceiptDocID:
              cashRegister.chequeReceiptDocID,
          PosCashRegisterListLocalImportantNames.salesOrderDocID:
              cashRegister.salesOrderDocID,
          PosCashRegisterListLocalImportantNames.inventoryTransferDocID:
              cashRegister.inventoryTransferDocID,
          PosCashRegisterListLocalImportantNames.salesPersonID:
              cashRegister.salesPersonID,
          PosCashRegisterListLocalImportantNames.note: cashRegister.note,
          PosCashRegisterListLocalImportantNames.isUseLastPrice:
              cashRegister.isUseLastPrice,
          PosCashRegisterListLocalImportantNames.dateUpdated:
              cashRegister.dateUpdated,
          PosCashRegisterListLocalImportantNames.dateCreated:
              cashRegister.dateCreated,
          PosCashRegisterListLocalImportantNames.createdBy:
              cashRegister.createdBy,
          PosCashRegisterListLocalImportantNames.updatedBy:
              cashRegister.updatedBy,
        });
      }
      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCashRegister() async {
    Database? db = await DBHelper._database;
    return await db!.query(PosCashRegisterListLocalImportantNames.tableName);
  }

  deleteCashRegisterTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(PosCashRegisterListLocalImportantNames.tableName);
  }

//pos cash register end

// Company start
  insertCompanyList(List<CompanyModel> companyList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var company in companyList) {
        batch.insert(CompanyListLocalImportantNames.tableName, {
          CompanyListLocalImportantNames.companyName: company.companyName,
          CompanyListLocalImportantNames.notes: company.notes,
          CompanyListLocalImportantNames.baseCurrencyID: company.baseCurrencyID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCompany() async {
    Database? db = await DBHelper._database;
    return await db!.query(CompanyListLocalImportantNames.tableName);
  }

  deleteCompanyTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CompanyListLocalImportantNames.tableName);
  }

//Company end

// Customer start
  insertCustomerList(List<CustomerModel> customerList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var customer in customerList) {
        batch.insert(CustomerListLocalImportantNames.tableName, {
          CustomerListLocalImportantNames.routeID: customer.routeID,
          CustomerListLocalImportantNames.rowIndex: customer.rowIndex,
          CustomerListLocalImportantNames.customerID: customer.customerID,
          CustomerListLocalImportantNames.customerName: customer.customerName,
          CustomerListLocalImportantNames.shortName: customer.shortName,
          CustomerListLocalImportantNames.companyName: customer.companyName,
          CustomerListLocalImportantNames.addressPrintFormat:
              customer.addressPrintFormat,
          CustomerListLocalImportantNames.city: customer.city,
          CustomerListLocalImportantNames.contactName: customer.contactName,
          CustomerListLocalImportantNames.phone1: customer.phone1,
          CustomerListLocalImportantNames.email: customer.email,
          CustomerListLocalImportantNames.phone2: customer.phone2,
          CustomerListLocalImportantNames.address1: customer.address1,
          CustomerListLocalImportantNames.address2: customer.address2,
          CustomerListLocalImportantNames.address3: customer.address3,
          CustomerListLocalImportantNames.taxGroupID: customer.taxGroupID,
          CustomerListLocalImportantNames.taxOption: customer.taxOption,
          CustomerListLocalImportantNames.dateCreated: customer.dateCreated,
          CustomerListLocalImportantNames.taxIDNumber: customer.taxIDNumber,
          CustomerListLocalImportantNames.latitude: customer.latitude,
          CustomerListLocalImportantNames.longitude: customer.longitude,
          CustomerListLocalImportantNames.customerClassID:
              customer.customerClassID,
          CustomerListLocalImportantNames.parentCustomerID:
              customer.parentCustomerID,
        });
      }

      await batch.commit();
    });
    final List<Map<String, dynamic>> customers =
        await DBHelper().queryAllCustomer();
  }

  Future<List<Map<String, dynamic>>> queryAllCustomer() async {
    Database? db = await DBHelper._database;
    return await db!.query(CustomerListLocalImportantNames.tableName);
  }

  deleteCustomerTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CustomerListLocalImportantNames.tableName);
  }

  Future<String> getParentCustomerName(String customerId) async {
    Database? db = await DBHelper._database;
    List<Map<String, dynamic>> result = await db!
        .rawQuery('''SELECT c2.${CustomerListLocalImportantNames.customerName}
FROM ${CustomerListLocalImportantNames.tableName} c1
JOIN ${CustomerListLocalImportantNames.tableName} c2 ON c1.${CustomerListLocalImportantNames.parentCustomerID} = c2.${CustomerListLocalImportantNames.customerID}
WHERE c1.${CustomerListLocalImportantNames.customerID} = '$customerId';''');

    if (result.isNotEmpty) {
      return result.first[CustomerListLocalImportantNames.customerName];
    } else {
      return '';
    }
  }

//Customer end

// Route Customer start
  insertRouteCustomerList(List<RouteCustomerModel> routeCustomerList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var routeCustomer in routeCustomerList) {
        batch.insert(RouteCustomerListLocalImportantNames.tableName, {
          RouteCustomerListLocalImportantNames.routeCustomerID:
              routeCustomer.routeCustomerID,
          RouteCustomerListLocalImportantNames.routeID: routeCustomer.routeID,
          RouteCustomerListLocalImportantNames.customerID:
              routeCustomer.customerID,
          RouteCustomerListLocalImportantNames.customerName:
              routeCustomer.customerName,
          RouteCustomerListLocalImportantNames.shortName:
              routeCustomer.shortName,
          RouteCustomerListLocalImportantNames.dateCreated:
              routeCustomer.dateCreated,
          RouteCustomerListLocalImportantNames.dateUpdated:
              routeCustomer.dateUpdated,
          RouteCustomerListLocalImportantNames.latitude: routeCustomer.latitude,
          RouteCustomerListLocalImportantNames.longitude:
              routeCustomer.longitude,
          RouteCustomerListLocalImportantNames.address1: routeCustomer.address1,
          RouteCustomerListLocalImportantNames.status: routeCustomer.status,
          RouteCustomerListLocalImportantNames.isHold: routeCustomer.isHold,
          RouteCustomerListLocalImportantNames.inActive: routeCustomer.inActive,
          RouteCustomerListLocalImportantNames.creditLimitType:
              routeCustomer.creditLimitType,
          RouteCustomerListLocalImportantNames.noCredit: routeCustomer.noCredit,
          RouteCustomerListLocalImportantNames.creditAvailable:
              routeCustomer.creditAvailable,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRouteCustomer() async {
    Database? db = await DBHelper._database;
    return await db!.query(RouteCustomerListLocalImportantNames.tableName);
  }

  deleteRouteCustomerTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(RouteCustomerListLocalImportantNames.tableName);
  }

//Route Customer end

// Route start
  insertRouteList(List<RouteModel> routesList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var route in routesList) {
        batch.insert(RouteListLocalImportantNames.tableName, {
          RouteListLocalImportantNames.routeID: route.routeID,
          RouteListLocalImportantNames.routeName: route.routeName,
          RouteListLocalImportantNames.locationID: route.locationID,
          RouteListLocalImportantNames.isEnableAllocation:
              route.isEnableAllocation,
          RouteListLocalImportantNames.damageLocationID: route.damageLocationID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRoute() async {
    Database? db = await DBHelper._database;
    return await db!.query(RouteListLocalImportantNames.tableName);
  }

  deleteRouteTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(RouteListLocalImportantNames.tableName);
  }

//Route end

// SysDoc start
  insertSysDocList(List<SysDocDetail> sysDocDetailList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var sysDocDetail in sysDocDetailList) {
        batch.insert(SysDocDetailListLocalImportantNames.tableName, {
          SysDocDetailListLocalImportantNames.sysDocID: sysDocDetail.sysDocID,
          SysDocDetailListLocalImportantNames.numberPrefix:
              sysDocDetail.numberPrefix,
          SysDocDetailListLocalImportantNames.nextNumber:
              sysDocDetail.nextNumber,
          SysDocDetailListLocalImportantNames.lastNumber:
              sysDocDetail.lastNumber,
          SysDocDetailListLocalImportantNames.headerImage:
              sysDocDetail.headerImage,
          SysDocDetailListLocalImportantNames.footerImage:
              sysDocDetail.footerImage,
          SysDocDetailListLocalImportantNames.inventoryTransferLocationID:
              sysDocDetail.inventoryTransferLocationID,
          SysDocDetailListLocalImportantNames.defaultCustomerID:
              sysDocDetail.defaultCustomerID,
          SysDocDetailListLocalImportantNames.priceIncludeTax:
              sysDocDetail.priceIncludeTax,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllSysDoc() async {
    Database? db = await DBHelper._database;
    return await db!.query(SysDocDetailListLocalImportantNames.tableName);
  }

  deleteSysDocTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(SysDocDetailListLocalImportantNames.tableName);
  }

  Future<int> updateSysDocNextNumber(
      {required int nextNumber, required String sysDoc}) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${SysDocDetailListLocalImportantNames.tableName}
    SET ${SysDocDetailListLocalImportantNames.nextNumber} = ?
    WHERE ${SysDocDetailListLocalImportantNames.sysDocID} = ?
    ''', [nextNumber, sysDoc]);
  }
//SysDoc end

// Account start
  insertAccountList(List<AccountModel> accountList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var account in accountList) {
        batch.insert(AccountListLocalImportantNames.tableName, {
          AccountListLocalImportantNames.cashRegisterID: account.cashRegisterID,
          AccountListLocalImportantNames.displayName: account.displayName,
          AccountListLocalImportantNames.accountID: account.accountID,
          AccountListLocalImportantNames.accountName: account.accountName,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllAccount() async {
    Database? db = await DBHelper._database;
    return await db!.query(AccountListLocalImportantNames.tableName);
  }

  deleteAccountTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(AccountListLocalImportantNames.tableName);
  }

//Account end

// Company start
  insertSecurityList(List<SecurityModel> securityList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var security in securityList) {
        batch.insert(SecurityListLocalImportantNames.tableName, {
          SecurityListLocalImportantNames.securityRoleID:
              security.securityRoleID,
          SecurityListLocalImportantNames.securityRoleName:
              security.securityRoleName,
          SecurityListLocalImportantNames.isAllowed: security.isAllowed,
          SecurityListLocalImportantNames.userID: security.userID,
          SecurityListLocalImportantNames.groupID: security.groupID,
          SecurityListLocalImportantNames.intValue: security.intValue,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllSecurity() async {
    Database? db = await DBHelper._database;
    return await db!.query(SecurityListLocalImportantNames.tableName);
  }

  deleteSecurityTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(SecurityListLocalImportantNames.tableName);
  }

//Company end

// Tax start
  insertTaxList(List<TaxModel> taxList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var tax in taxList) {
        batch.insert(TaxListLocalImportantNames.tableName, {
          TaxListLocalImportantNames.taxCode: tax.taxCode,
          TaxListLocalImportantNames.taxGroupID: tax.taxGroupID,
          TaxListLocalImportantNames.rowIndex: tax.rowIndex,
          TaxListLocalImportantNames.taxItemName: tax.taxItemName,
          TaxListLocalImportantNames.taxType: tax.taxType,
          TaxListLocalImportantNames.calculationMethod: tax.calculationMethod,
          TaxListLocalImportantNames.taxRate: tax.taxRate,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllTax() async {
    Database? db = await DBHelper._database;
    return await db!.query(TaxListLocalImportantNames.tableName);
  }

  deleteTaxTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(TaxListLocalImportantNames.tableName);
  }

//Tax end

// PaymentMethod start
  insertPaymentMethodList(List<PaymentMethodModel> paymentMethodList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var paymentMethod in paymentMethodList) {
        batch.insert(PaymentMethodLocalImportantNames.tableName, {
          PaymentMethodLocalImportantNames.cashRegisterID:
              paymentMethod.cashRegisterID,
          PaymentMethodLocalImportantNames.inactive:
              paymentMethod.inactive == true ? 1 : 0,
          PaymentMethodLocalImportantNames.paymentMethodID:
              paymentMethod.paymentMethodID,
          PaymentMethodLocalImportantNames.displayName:
              paymentMethod.displayName,
          PaymentMethodLocalImportantNames.accountID: paymentMethod.accountID,
          PaymentMethodLocalImportantNames.accountName:
              paymentMethod.accountName,
          PaymentMethodLocalImportantNames.methodType: paymentMethod.methodType,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllPaymentMethod() async {
    Database? db = await DBHelper._database;
    return await db!.query(PaymentMethodLocalImportantNames.tableName);
  }

  deletePaymentMethodTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(PaymentMethodLocalImportantNames.tableName);
  }

//PaymentMethod end

// Bank start
  insertBankList(List<BankModel> bankList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var bank in bankList) {
        batch.insert(BankListLocalImportantNames.tableName, {
          BankListLocalImportantNames.bankCode: bank.bankCode,
          BankListLocalImportantNames.bankName: bank.bankName,
          BankListLocalImportantNames.contactName: bank.contactName,
          BankListLocalImportantNames.phone: bank.phone,
          BankListLocalImportantNames.fax: bank.fax,
          BankListLocalImportantNames.inactive: bank.inactive,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllBank() async {
    Database? db = await DBHelper._database;
    return await db!.query(BankListLocalImportantNames.tableName);
  }

  deleteBankTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(BankListLocalImportantNames.tableName);
  }

//Bank end

// Product Lot start
  insertProductLotList(List<ProductLotModel> productLotList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var productLot in productLotList) {
        batch.insert(ProductLotListLocalImportantNames.tableName, {
          ProductLotListLocalImportantNames.productID: productLot.productID,
          ProductLotListLocalImportantNames.locationID: productLot.locationID,
          ProductLotListLocalImportantNames.lotNumber: productLot.lotNumber,
          ProductLotListLocalImportantNames.reference: productLot.reference,
          ProductLotListLocalImportantNames.reference2: productLot.reference2,
          ProductLotListLocalImportantNames.itemType: productLot.itemType,
          ProductLotListLocalImportantNames.sourceLotNumber:
              productLot.sourceLotNumber,
          ProductLotListLocalImportantNames.lotQty: productLot.lotQty,
          ProductLotListLocalImportantNames.cost: productLot.cost,
          ProductLotListLocalImportantNames.consignNumber:
              productLot.consignNumber,
          ProductLotListLocalImportantNames.availableQty:
              productLot.availableQty,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAvailableProductLots(
      {required String productId, required String voucher}) async {
    Database? db = await DBHelper._database;
    return await db!.rawQuery('''SELECT
    PL.*,
    PL.AvailableQty - IFNULL(
        (
            SELECT SUM(
                SD.quantity
            )
            FROM salesInvoiceLot SD
			LEFT JOIN salesInvoiceHeader SH ON SH.voucherid=SD.voucherid
            WHERE PL.productId = SD.productId AND SD.lotNumber = PL.lotNumber AND SH.isSynced=0 AND SD.voucherid != '$voucher'
			
        ),
        0
    ) AS LotAvailable
FROM ProductLot PL
WHERE PL.productId = '$productId';''');
    // String whereString = '${ProductLotListLocalImportantNames.productID} = ?';

    // List<dynamic> whereArguments = [productId];
    // return await db!.query(ProductLotListLocalImportantNames.tableName,
    //     where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryCustomerBalance(
      String customerID) async {
    Database? db = await DBHelper._database;
    String whereString =
        '${CustomerBalanceListLocalImportantNames.customerID} = ?';

    List<dynamic> whereArguments = [customerID];
    return await db!.query(CustomerBalanceListLocalImportantNames.tableName,
        where: whereString, whereArgs: whereArguments);
  }

  Future<List<Map<String, dynamic>>> queryCustomerOutStanding(
      String customerID) async {
    Database? db = await DBHelper._database;
    // String whereString =
    //     '${OutstandingInvoiceListLocalImportantNames.customerID} = ?';

    List<dynamic> whereArguments = [customerID];
    // return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName,
    //     where: whereString, whereArgs: whereArguments);
    return await db!.rawQuery('''SELECT
    O.*,
	O.AmountDue - IFNULL (
	(
	SELECT SUM(
                TA.paymentAmount
            )
			FROM TransactionAllocationDetail TA
			WHERE TA.customerid = '$customerID' AND O.voucherid = TA.invoiceVoucherId AND TA.isSynced != 1
	),
	0
	) As DueAmount
FROM OutStandingInvoice O
WHERE O.customerid = '$customerID' AND DueAmount > 0;''');
  }

//   Future<List<Map<String, dynamic>>>
//       queryTransactionAllocationDetailFromOutstanding(
//           String customerID, String paymentVoucherId) async {
//     Database? db = await DBHelper._database;
//     // String whereString =
//     //     '${OutstandingInvoiceListLocalImportantNames.customerID} = ?';

//     List<dynamic> whereArguments = [customerID];
//     // return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName,
//     //     where: whereString, whereArgs: whereArguments);
//     return await db!.rawQuery('''SELECT
//     O.*,

//   O.AmountDue - IFNULL (
//   (
//   SELECT SUM(
//                 TA.paymentAmount
//             )
//       FROM TransactionAllocationDetail TA
//       WHERE TA.customerid = '$customerID' AND O.voucherid = TA.invoiceVoucherId AND TA.isSynced != 1 AND TA.paymentVoucherId != '$paymentVoucherId'
//   ),
//   0
//   ) As DueAmount
// FROM OutStandingInvoice O
// WHERE O.customerid = '$customerID' AND DueAmount > 0''');
//   }

  Future<List<Map<String, dynamic>>> queryTransactionAllocationDetail(
      String customerID, String paymentVoucherId) async {
    Database? db = await DBHelper._database;
    // String whereString =
    //     '${OutstandingInvoiceListLocalImportantNames.customerID} = ?';

    List<dynamic> whereArguments = [customerID];
    // return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName,
    //     where: whereString, whereArgs: whereArguments);
    return await db!.rawQuery('''SELECT
    TA.*,

   COALESCE(O.AmountDue, SH.total) - IFNULL (
  (
  SELECT SUM(
                TA.paymentAmount
            )
      FROM TransactionAllocationDetail TA
      WHERE TA.customerid = '$customerID' AND COALESCE(O.voucherid, SH.voucherid) = TA.invoiceVoucherId AND TA.isSynced != 1 AND TA.paymentVoucherId != '$paymentVoucherId'
  ),
  0
  ) As DueAmount
FROM TransactionAllocationDetail TA
LEFT JOIN OutStandingInvoice O ON TA.invoiceVoucherId = O.voucherid
LEFT JOIN salesInvoiceHeader SH ON TA.invoiceVoucherId = SH.voucherid
WHERE TA.customerid = '${customerID}' AND TA.paymentVoucherId = '$paymentVoucherId';''');
  }

//   Future<List<Map<String, dynamic>>> queryTransactionAllocationDetailFromCredit(
//       String customerID, String paymentVoucherId) async {
//     Database? db = await DBHelper._database;
//     // String whereString =
//     //     '${OutstandingInvoiceListLocalImportantNames.customerID} = ?';

//     List<dynamic> whereArguments = [customerID];
//     // return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName,
//     //     where: whereString, whereArgs: whereArguments);
//     return await db!.rawQuery('''SELECT
//     O.*,

//   O.total - IFNULL (
//   (
//   SELECT SUM(
//                 TA.paymentAmount
//             )
//       FROM TransactionAllocationDetail TA
//       WHERE TA.customerid = '$customerID' AND O.voucherid = TA.invoiceVoucherId AND TA.isSynced != 1 AND TA.paymentVoucherId != '$paymentVoucherId'
//   ),
//   0
//   ) As DueAmount
// FROM salesInvoiceHeader O
// WHERE O.customerID = '$customerID' AND DueAmount > 0''');
//   }

  Future<List<Map<String, dynamic>>> queryAllocationFromSalesInvoiceCredit(
      String customerID) async {
    Database? db = await DBHelper._database;
    // String whereString =
    //     '${OutstandingInvoiceListLocalImportantNames.customerID} = ?';

    List<dynamic> whereArguments = [customerID];
    // return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName,
    //     where: whereString, whereArgs: whereArguments);
    return await db!.rawQuery('''SELECT
    SH.*,
  SH.total - IFNULL (
  (
  SELECT SUM(
                TA.paymentAmount
            )
      FROM TransactionAllocationDetail TA
      WHERE TA.customerid = '${customerID}' AND SH.voucherid = TA.invoiceVoucherId AND TA.isSynced != 1
  ),
  0
  ) As DueAmount
FROM salesInvoiceHeader SH
WHERE SH.customerID = '${customerID}' AND SH.paymentType == 5 AND DueAmount > 0;''');
  }

  Future<List<Map<String, dynamic>>> queryAllProductLot() async {
    Database? db = await DBHelper._database;
    return await db!.query(ProductLotListLocalImportantNames.tableName);
  }

  deleteProductLotTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(ProductLotListLocalImportantNames.tableName);
  }

//Product Lot end

// Product start
  insertProductList(List<ProductModel> productList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var product in productList) {
        batch.insert(ProductListLocalImportantNames.tableName, {
          ProductListLocalImportantNames.productID: product.productID,
          ProductListLocalImportantNames.description: product.description,
          ProductListLocalImportantNames.isTrackLot: product.isTrackLot,
          ProductListLocalImportantNames.upc: product.upc,
          ProductListLocalImportantNames.quantity: product.quantity,
          ProductListLocalImportantNames.unitID: product.unitID,
          ProductListLocalImportantNames.taxGroupID: product.taxGroupID,
          ProductListLocalImportantNames.taxOption: product.taxOption,
          ProductListLocalImportantNames.price: product.price,
          ProductListLocalImportantNames.standardPrice: product.standardPrice,
          ProductListLocalImportantNames.wholeSalePrice: product.wholeSalePrice,
          ProductListLocalImportantNames.specialPrice: product.specialPrice,
          ProductListLocalImportantNames.minPrice: product.minPrice,
          ProductListLocalImportantNames.description2: product.description2,
          ProductListLocalImportantNames.itemType: product.itemType,
          ProductListLocalImportantNames.openingStock: product.quantity != null
              ? product.quantity! < 0
                  ? 0.0
                  : product.quantity
              : 0.0,
          ProductListLocalImportantNames.saleQuantity:
              product.saleQuantity ?? 0.0,
          ProductListLocalImportantNames.returnQuantity:
              product.returnQuantity ?? 0.0,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllProduct() async {
    Database? db = await DBHelper._database;
    return await db!.query(ProductListLocalImportantNames.tableName);
  }

  Future<List<Map<String, dynamic>>> queryProductBasedOnStock(
      {required double quantity, required String productId}) async {
    Database? db = await DBHelper._database;
    return await db!.rawQuery('''SELECT
    P.*,
    (P.OpeningStock + $quantity) - IFNULL(
        (
            SELECT SUM(
                CASE
				    WHEN SD.unitid=P.unitid THEN (CASE WHEN SH.isReturn=1 THEN -1*SD.quantity ELSE SD.quantity END) --if sold in main unit
                    WHEN U1.FactorType = 'M' THEN (CASE WHEN SH.isReturn=1 THEN -1*SD.quantity ELSE SD.quantity  END) / U1.Factor --if sold multi unit
                    WHEN U1.FactorType = 'D' THEN (CASE WHEN SH.isReturn=1 THEN -1*SD.quantity ELSE SD.quantity  END) * U1.Factor --if sold multi unit
                    ELSE (CASE WHEN SH.isReturn=1 THEN -1*SD.quantity ELSE SD.quantity END) --else 
                END
            )
            FROM salesInvoiceDetail SD
			LEFT JOIN salesInvoiceHeader SH ON SH.voucherid=SD.voucherid
      LEFT JOIN Units U1 ON SD.productId = U1.productId  AND U1.Code=SD.unitid
            WHERE P.productId = SD.productId AND SD.isDamaged=0 AND SH.isSynced=0 -- You might need this condition BOTIM
        ),
        0
    ) AS Stock
	
FROM Product P
WHERE P.productId = '$productId';''');
  }

  Future<List<Map<String, dynamic>>> queryAllProductBasedOnStock() async {
    log('Executing Query');
    Database? db = await DBHelper._database;
    return await db!.rawQuery('''SELECT
    P.*,
    P.OpeningStock - IFNULL(
        (
            SELECT SUM(
                CASE
				    WHEN SD.unitid=P.unitid THEN (CASE WHEN SH.isReturn=1 THEN SD.quantity ELSE SD.quantity END) --if sold in main unit
                    WHEN U1.FactorType = 'M' THEN (CASE WHEN SH.isReturn=1 THEN SD.quantity ELSE SD.quantity  END) / U1.Factor --if sold multi unit
                    WHEN U1.FactorType = 'D' THEN (CASE WHEN SH.isReturn=1 THEN SD.quantity ELSE SD.quantity  END) * U1.Factor --if sold multi unit
                    ELSE (CASE WHEN SH.isReturn=1 THEN SD.quantity ELSE SD.quantity END) --else 
                END
            )
            FROM salesInvoiceDetail SD
			LEFT JOIN salesInvoiceHeader SH ON SH.voucherid=SD.voucherid
      LEFT JOIN Units U1 ON SD.productId = U1.productId  AND U1.Code=SD.unitid
            WHERE P.productId = SD.productId AND SD.isDamaged=0 AND SH.isSynced=0 -- You might need this condition BOTIM
        ),
        0
    ) AS Stock,
	ifnull((
            SELECT SUM(
                CASE
                    WHEN SH.isReturn = 0 AND SD.isDamaged = 0 THEN
					CASE 
                            WHEN P.unitid = SD.unitid THEN SD.quantity
                            WHEN U1.FactorType = 'M' THEN SD.quantity / U1.Factor
                            WHEN U1.FactorType = 'D' THEN SD.quantity * U1.Factor
                            ELSE SD.quantity
                        END
                    ELSE 0
                END
            )
            FROM salesInvoiceDetail SD
            LEFT JOIN salesInvoiceHeader SH ON SH.voucherid = SD.voucherid
			LEFT JOIN Units U1 ON SD.productId = U1.productId AND U1.Code=SD.unitid
            WHERE P.productId = SD.productId AND SH.isSynced=0 
        ),0) AS SaleQuantity,
		ifnull((
            SELECT SUM(
                CASE
                    WHEN SH.isReturn = 1 AND SD.isDamaged = 0 THEN
					CASE 
                            WHEN P.unitid = SD.unitid THEN SD.quantity
                            WHEN U1.FactorType = 'M' THEN SD.quantity / U1.Factor
                            WHEN U1.FactorType = 'D' THEN SD.quantity * U1.Factor
                            ELSE SD.quantity
                        END
                    ELSE 0
                END
            )
            FROM salesInvoiceDetail SD
            LEFT JOIN salesInvoiceHeader SH ON SH.voucherid = SD.voucherid
			LEFT JOIN Units U1 ON SD.productId = U1.productId  AND U1.Code=SD.unitid
            WHERE P.productId = SD.productId AND SH.isSynced=0 
        ),0) * -1 AS ReturnQuantity,
		ifnull((
            SELECT SUM(
                CASE
                    WHEN SD.isDamaged = 1 THEN
					CASE 
                            WHEN P.unitid = SD.unitid THEN SD.quantity
                            WHEN U1.FactorType = 'M' THEN SD.quantity / U1.Factor
                            WHEN U1.FactorType = 'D' THEN SD.quantity * U1.Factor
                            ELSE SD.quantity
                        END
                    ELSE 0
                END
            )
            FROM salesInvoiceDetail SD
            LEFT JOIN salesInvoiceHeader SH ON SH.voucherid = SD.voucherid
			LEFT JOIN Units U1 ON SD.productId = U1.productId  AND U1.Code=SD.unitid
            WHERE P.productId = SD.productId AND SH.isSynced=0 
        ),0) AS DamageQuantity
FROM Product P;''');
  }

  deleteProductTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(ProductListLocalImportantNames.tableName);
  }

//Product end

// Unit start
  insertUnitList(List<UnitModel> unitList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var unit in unitList) {
        batch.insert(UnitListLocalImportantNames.tableName, {
          UnitListLocalImportantNames.code: unit.code,
          UnitListLocalImportantNames.name: unit.name,
          UnitListLocalImportantNames.productID: unit.productID,
          UnitListLocalImportantNames.factorType: unit.factorType,
          UnitListLocalImportantNames.factor: unit.factor,
          UnitListLocalImportantNames.isMainUnit: unit.isMainUnit,
        });
      }
      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllUnit() async {
    Database? db = await DBHelper._database;
    return await db!.query(UnitListLocalImportantNames.tableName);
  }

  deleteUnitTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(UnitListLocalImportantNames.tableName);
  }

//Unit end

// Route Price start
  insertRoutePriceList(List<RoutePriceModel> routePriceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var routePrice in routePriceList) {
        batch.insert(RoutePriceListLocalImportantNames.tableName, {
          RoutePriceListLocalImportantNames.sysDocID: routePrice.sysDocID,
          RoutePriceListLocalImportantNames.voucherID: routePrice.voucherID,
          RoutePriceListLocalImportantNames.productID: routePrice.productID,
          RoutePriceListLocalImportantNames.customerProductID:
              routePrice.customerProductID,
          RoutePriceListLocalImportantNames.unitPrice: routePrice.unitPrice,
          RoutePriceListLocalImportantNames.description: routePrice.description,
          RoutePriceListLocalImportantNames.remarks: routePrice.remarks,
          RoutePriceListLocalImportantNames.unitID: routePrice.unitID,
          RoutePriceListLocalImportantNames.unitQuantity:
              routePrice.unitQuantity,
          RoutePriceListLocalImportantNames.unitFactor: routePrice.unitFactor,
          RoutePriceListLocalImportantNames.factorType: routePrice.factorType,
          RoutePriceListLocalImportantNames.subunitPrice:
              routePrice.subunitPrice,
          RoutePriceListLocalImportantNames.rowIndex: routePrice.rowIndex,
          RoutePriceListLocalImportantNames.routeID: routePrice.routeID,
          RoutePriceListLocalImportantNames.posRegisterID:
              routePrice.posRegisterID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRoutePrice() async {
    Database? db = await DBHelper._database;
    return await db!.query(RoutePriceListLocalImportantNames.tableName);
  }

  deleteRoutePriceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(RoutePriceListLocalImportantNames.tableName);
  }

//Route Price end

// Van Price start
  insertVanPriceList(List<VanPriceModel> vanPriceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var vanPrice in vanPriceList) {
        batch.insert(VanPriceListLocalImportantNames.tableName, {
          VanPriceListLocalImportantNames.sysDocID: vanPrice.sysDocID,
          VanPriceListLocalImportantNames.voucherID: vanPrice.voucherID,
          VanPriceListLocalImportantNames.productID: vanPrice.productID,
          VanPriceListLocalImportantNames.customerProductID:
              vanPrice.customerProductID,
          VanPriceListLocalImportantNames.unitPrice: vanPrice.unitPrice,
          VanPriceListLocalImportantNames.description: vanPrice.description,
          VanPriceListLocalImportantNames.remarks: vanPrice.remarks,
          VanPriceListLocalImportantNames.unitID: vanPrice.unitID,
          VanPriceListLocalImportantNames.unitQuantity: vanPrice.unitQuantity,
          VanPriceListLocalImportantNames.unitFactor: vanPrice.unitFactor,
          VanPriceListLocalImportantNames.factorType: vanPrice.factorType,
          VanPriceListLocalImportantNames.subunitPrice: vanPrice.subunitPrice,
          VanPriceListLocalImportantNames.rowIndex: vanPrice.rowIndex,
          VanPriceListLocalImportantNames.routeID: vanPrice.routeID,
          VanPriceListLocalImportantNames.vanID: vanPrice.vanID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllVanPrice() async {
    Database? db = await DBHelper._database;
    return await db!.query(VanPriceListLocalImportantNames.tableName);
  }

  deleteVanPriceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(VanPriceListLocalImportantNames.tableName);
  }

//Van Price end

// Customer Price start
  insertCustomerPriceList(List<CustomerPriceModel> customerPriceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var customerPrice in customerPriceList) {
        batch.insert(CustomerPriceListLocalImportantNames.tableName, {
          CustomerPriceListLocalImportantNames.sysDocID: customerPrice.sysDocID,
          CustomerPriceListLocalImportantNames.voucherID:
              customerPrice.voucherID,
          CustomerPriceListLocalImportantNames.productID:
              customerPrice.productID,
          CustomerPriceListLocalImportantNames.customerProductID:
              customerPrice.customerProductID,
          CustomerPriceListLocalImportantNames.unitPrice:
              customerPrice.unitPrice,
          CustomerPriceListLocalImportantNames.description:
              customerPrice.description,
          CustomerPriceListLocalImportantNames.remarks: customerPrice.remarks,
          CustomerPriceListLocalImportantNames.unitID: customerPrice.unitID,
          CustomerPriceListLocalImportantNames.unitQuantity:
              customerPrice.unitQuantity,
          CustomerPriceListLocalImportantNames.unitFactor:
              customerPrice.unitFactor,
          CustomerPriceListLocalImportantNames.factorType:
              customerPrice.factorType,
          CustomerPriceListLocalImportantNames.subunitPrice:
              customerPrice.subunitPrice,
          CustomerPriceListLocalImportantNames.rowIndex: customerPrice.rowIndex,
          CustomerPriceListLocalImportantNames.customerID:
              customerPrice.customerID,
          CustomerPriceListLocalImportantNames.routeID: customerPrice.routeID,
          CustomerPriceListLocalImportantNames.vanID: customerPrice.vanID,
          CustomerPriceListLocalImportantNames.applicableToChild:
              customerPrice.applicableToChild! ? 1 : 0,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCustomerPrice() async {
    Database? db = await DBHelper._database;
    return await db!.query(CustomerPriceListLocalImportantNames.tableName);
  }

  deleteCustomerPriceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CustomerPriceListLocalImportantNames.tableName);
  }

//Customer Price end

// Customer Class Price start
  insertCustomerClassPriceList(
      List<CustomerClassPriceModel> customerClassPriceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var customerClassPrice in customerClassPriceList) {
        batch.insert(CustomerClassPriceListLocalImportantNames.tableName, {
          CustomerClassPriceListLocalImportantNames.sysDocID:
              customerClassPrice.sysDocID,
          CustomerClassPriceListLocalImportantNames.voucherID:
              customerClassPrice.voucherID,
          CustomerClassPriceListLocalImportantNames.productID:
              customerClassPrice.productID,
          CustomerClassPriceListLocalImportantNames.customerProductID:
              customerClassPrice.customerProductID,
          CustomerClassPriceListLocalImportantNames.unitPrice:
              customerClassPrice.unitPrice,
          CustomerClassPriceListLocalImportantNames.description:
              customerClassPrice.description,
          CustomerClassPriceListLocalImportantNames.remarks:
              customerClassPrice.remarks,
          CustomerClassPriceListLocalImportantNames.unitID:
              customerClassPrice.unitID,
          CustomerClassPriceListLocalImportantNames.unitQuantity:
              customerClassPrice.unitQuantity,
          CustomerClassPriceListLocalImportantNames.unitFactor:
              customerClassPrice.unitFactor,
          CustomerClassPriceListLocalImportantNames.factorType:
              customerClassPrice.factorType,
          CustomerClassPriceListLocalImportantNames.subunitPrice:
              customerClassPrice.subunitPrice,
          CustomerClassPriceListLocalImportantNames.rowIndex:
              customerClassPrice.rowIndex,
          CustomerClassPriceListLocalImportantNames.customerClassID:
              customerClassPrice.customerClassID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCustomerClassPrice() async {
    Database? db = await DBHelper._database;
    return await db!.query(CustomerClassPriceListLocalImportantNames.tableName);
  }

  deleteCustomerClassPriceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CustomerClassPriceListLocalImportantNames.tableName);
  }

//Customer Class Price end

// Location Price start
  insertLocationPriceList(List<LocationPriceModel> locationPriceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var locationPrice in locationPriceList) {
        batch.insert(LocationPriceListLocalImportantNames.tableName, {
          LocationPriceListLocalImportantNames.sysDocID: locationPrice.sysDocID,
          LocationPriceListLocalImportantNames.voucherID:
              locationPrice.voucherID,
          LocationPriceListLocalImportantNames.productID:
              locationPrice.productID,
          LocationPriceListLocalImportantNames.customerProductID:
              locationPrice.customerProductID,
          LocationPriceListLocalImportantNames.unitPrice:
              locationPrice.unitPrice,
          LocationPriceListLocalImportantNames.description:
              locationPrice.description,
          LocationPriceListLocalImportantNames.remarks: locationPrice.remarks,
          LocationPriceListLocalImportantNames.unitID: locationPrice.unitID,
          LocationPriceListLocalImportantNames.unitQuantity:
              locationPrice.unitQuantity,
          LocationPriceListLocalImportantNames.unitFactor:
              locationPrice.unitFactor,
          LocationPriceListLocalImportantNames.factorType:
              locationPrice.factorType,
          LocationPriceListLocalImportantNames.subunitPrice:
              locationPrice.subunitPrice,
          LocationPriceListLocalImportantNames.rowIndex: locationPrice.rowIndex,
          LocationPriceListLocalImportantNames.locationID:
              locationPrice.locationID,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllLocationPrice() async {
    Database? db = await DBHelper._database;
    return await db!.query(LocationPriceListLocalImportantNames.tableName);
  }

  deleteLocationPriceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(LocationPriceListLocalImportantNames.tableName);
  }

//Location Price end

// Customer Balance start
  insertCustomerBalanceList(
      List<CustomerBalanceModel> customerBalanceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var customerBalance in customerBalanceList) {
        batch.insert(CustomerBalanceListLocalImportantNames.tableName, {
          CustomerBalanceListLocalImportantNames.customerID:
              customerBalance.customerID,
          CustomerBalanceListLocalImportantNames.customerName:
              customerBalance.customerName,
          CustomerBalanceListLocalImportantNames.creditAmount:
              customerBalance.creditAmount,
          CustomerBalanceListLocalImportantNames.isInactive:
              customerBalance.isInactive,
          CustomerBalanceListLocalImportantNames.isHold: customerBalance.isHold,
          CustomerBalanceListLocalImportantNames.clValidity:
              customerBalance.clValidity,
          CustomerBalanceListLocalImportantNames.creditLimitType:
              customerBalance.creditLimitType,
          CustomerBalanceListLocalImportantNames.parentCustomerID:
              customerBalance.parentCustomerID,
          CustomerBalanceListLocalImportantNames.limitPDCUnsecured:
              customerBalance.limitPDCUnsecured,
          CustomerBalanceListLocalImportantNames.pdcUnsecuredLimitAmount:
              customerBalance.pdcUnsecuredLimitAmount,
          CustomerBalanceListLocalImportantNames.insApprovedAmount:
              customerBalance.insApprovedAmount,
          CustomerBalanceListLocalImportantNames.openDNAmount:
              customerBalance.openDNAmount,
          CustomerBalanceListLocalImportantNames.tempCL: customerBalance.tempCL,
          CustomerBalanceListLocalImportantNames.balance:
              customerBalance.balance,
          CustomerBalanceListLocalImportantNames.pdcAmount:
              customerBalance.pdcAmount,
          CustomerBalanceListLocalImportantNames.acceptCheckPayment:
              customerBalance.acceptCheckPayment,
          CustomerBalanceListLocalImportantNames.acceptPDC:
              customerBalance.acceptPDC,
          CustomerBalanceListLocalImportantNames.currencyID:
              customerBalance.currencyID,
          CustomerBalanceListLocalImportantNames.securityCheque:
              customerBalance.securityCheque,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCustomerBalance() async {
    Database? db = await DBHelper._database;
    return await db!.query(CustomerBalanceListLocalImportantNames.tableName);
  }

  deleteCustomerBalanceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CustomerBalanceListLocalImportantNames.tableName);
  }

//Customer Balance end

// OutStanding Invoice start
  insertOutStandingInvoiceList(
      List<OutstandingInvoiceModel> outstandingInvoiceList) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      for (var invoice in outstandingInvoiceList) {
        batch.insert(OutstandingInvoiceListLocalImportantNames.tableName, {
          OutstandingInvoiceListLocalImportantNames.journalID:
              invoice.journalID,
          OutstandingInvoiceListLocalImportantNames.sysDocID: invoice.sysDocID,
          OutstandingInvoiceListLocalImportantNames.voucherID:
              invoice.voucherID,
          OutstandingInvoiceListLocalImportantNames.customerID:
              invoice.customerID,
          OutstandingInvoiceListLocalImportantNames.description:
              invoice.description,
          OutstandingInvoiceListLocalImportantNames.reference:
              invoice.reference,
          OutstandingInvoiceListLocalImportantNames.arDate: invoice.arDate,
          OutstandingInvoiceListLocalImportantNames.dueDate: invoice.dueDate,
          OutstandingInvoiceListLocalImportantNames.originalAmount:
              invoice.originalAmount,
          OutstandingInvoiceListLocalImportantNames.job: invoice.job,
          OutstandingInvoiceListLocalImportantNames.currencyID:
              invoice.currencyID,
          OutstandingInvoiceListLocalImportantNames.currencyRate:
              invoice.currencyRate,
          OutstandingInvoiceListLocalImportantNames.amountDue:
              invoice.amountDue,
          OutstandingInvoiceListLocalImportantNames.overdueDays:
              invoice.overdueDays,
        });
      }

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllOutStandingInvoice() async {
    Database? db = await DBHelper._database;
    return await db!.query(OutstandingInvoiceListLocalImportantNames.tableName);
  }

  deleteOutStandingInvoiceTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(OutstandingInvoiceListLocalImportantNames.tableName);
  }

//OutStanding Invoice end

// CustomerVisit Log start
  insertCustomerVisit(CustomerVisitApiModel customerVisit) async {
    Database? db = await DBHelper._database;
    final batch = db!.batch();
    await db.transaction((txn) async {
      var batch = txn.batch();

      batch.insert(CustomerVisitLogModelNames.tableName, customerVisit.toMap());

      await batch.commit();
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCustomerVisits() async {
    Database? db = await DBHelper._database;
    return await db!.query(CustomerVisitLogModelNames.tableName);
  }

  deleteCustomerVisitTable() async {
    Database? db = await DBHelper._database;
    await db!.delete(CustomerVisitLogModelNames.tableName);
  }

  Future<int> updateVisitLog(
      String endTime, String closeLat, String closeLong, String visitID) async {
    Database? db = await DBHelper._database;
    return await db!.rawUpdate('''
    UPDATE ${CustomerVisitLogModelNames.tableName}
    SET ${CustomerVisitLogModelNames.endTime} = ?, ${CustomerVisitLogModelNames.closeLatitude} = ?, ${CustomerVisitLogModelNames.closeLongitude} = ?
    WHERE ${CustomerVisitLogModelNames.visitLogId} = ?
    ''', [endTime, closeLat, closeLong, visitID]);
  }

//CustomerVisit Log end

  Future<List<Map<String, dynamic>>> queryBaseCurrencyId() async {
    Database? db = await DBHelper._database;
    return await db!
        .rawQuery('''SELECT ${CompanyListLocalImportantNames.baseCurrencyID}
FROM ${CompanyListLocalImportantNames.tableName};''');
  }
}
