import 'package:axoproject/model/Account%20Model/account_model.dart';
import 'package:axoproject/model/Bank%20Model/bank_model.dart';
import 'package:axoproject/model/Company%20Model/company_model.dart';
import 'package:axoproject/model/Customer%20Balance%20Model/customer_balance_model.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Customer%20Visit%20Log%20Model/customer_visit_log_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/PaymentCollectionModel/payment_collection_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/OutStanding%20Invoice%20Model/outstanding_invoice_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Pos%20Cash%20Register%20Model/pos_cash_register_model.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Route%20Customer%20Model/route_customer_model.dart';
import 'package:axoproject/model/Route%20Model/route_model.dart';
import 'package:axoproject/model/Security%20Model/security_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';

import '../../model/Local Db Model/Expense Transaction Model/expense_transaction_model.dart';
import '../../model/Local Db Model/user_log_model.dart';
import '../../model/Route Price Model/route_price_model.dart';

class QuerryTable {
  static var dbUpgradeQueryTable = [
    '''ALTER TABLE ${UserActivityLogImportantNames.tableName} ADD COLUMN ${UserActivityLogImportantNames.isError} INTEGER, ADD COLUMN ${UserActivityLogImportantNames.error} TEXT''',
    '''ALTER TABLE ${SalesInvoiceDetailApiModelNames.tableName} ADD COLUMN ${SalesInvoiceDetailApiModelNames.customerProductId} TEXT''',
    '''
CREATE TABLE ${SalesPOSTaxGroupDetailApiModelNames.tablename}(
      ${SalesPOSTaxGroupDetailApiModelNames.sysDocId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.voucherId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxGroupId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxCode} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.items} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxRate} REAL,
      ${SalesPOSTaxGroupDetailApiModelNames.calculationMethod} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxAmount} REAL,
      ${SalesPOSTaxGroupDetailApiModelNames.currencyID} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.rowIndex} INTEGER,
      ${SalesPOSTaxGroupDetailApiModelNames.orderIndex} INTEGER
)
''',
    '''
CREATE TABLE ${ExpenseTransactionDetailModelNames.tablename}(
      ${SalesPOSTaxGroupDetailApiModelNames.voucherId} TEXT,
      ${ExpenseTransactionDetailModelNames.accountID} TEXT,
      ${ExpenseTransactionDetailModelNames.description} TEXT,
      ${ExpenseTransactionDetailModelNames.amount} REAL,
      ${ExpenseTransactionDetailModelNames.amountFC} REAL,
      ${ExpenseTransactionDetailModelNames.taxGroupId} TEXT,
      ${ExpenseTransactionDetailModelNames.taxAmount} REAL,
      ${ExpenseTransactionDetailModelNames.rowIndex} INTEGER
)
''',
    '''
CREATE TABLE ${ExpenseTransactionApiModelNames.tablename}(
      ${ExpenseTransactionApiModelNames.sysDocID} TEXT,
      ${ExpenseTransactionApiModelNames.voucherID} TEXT,
      ${ExpenseTransactionApiModelNames.reference} TEXT,
      ${ExpenseTransactionApiModelNames.transactionDate} TEXT,
      ${ExpenseTransactionApiModelNames.divisionID} TEXT,
      ${ExpenseTransactionApiModelNames.companyID} TEXT,
      ${ExpenseTransactionApiModelNames.amount} REAL,
      ${ExpenseTransactionApiModelNames.taxGroupId} TEXT,
      ${ExpenseTransactionApiModelNames.taxAmount} REAL,
      ${ExpenseTransactionApiModelNames.registerID} TEXT,
      ${ExpenseTransactionApiModelNames.headerImage} TEXT,
      ${ExpenseTransactionApiModelNames.footerImage} TEXT,
      ${ExpenseTransactionApiModelNames.isSynced} INTEGER,
      ${ExpenseTransactionApiModelNames.isError} INTEGER,
      ${ExpenseTransactionApiModelNames.error} TEXT
)
''',
    '''ALTER TABLE ${TaxGroupDetailNames.tableName} ADD COLUMN ${TaxGroupDetailNames.taxExcludeDiscount} REAL''',
    '''
CREATE TABLE ${CreateTransferHeaderModelNames.tableName}(
  ${CreateTransferHeaderModelNames.sysDocType} INTEGER,
      ${CreateTransferHeaderModelNames.sysDocId} TEXT,
      ${CreateTransferHeaderModelNames.voucherId} TEXT,
      ${CreateTransferHeaderModelNames.reference} TEXT,
      ${CreateTransferHeaderModelNames.description} TEXT,
      ${CreateTransferHeaderModelNames.customerName} TEXT,
      ${CreateTransferHeaderModelNames.transactionDate} TEXT,
      ${CreateTransferHeaderModelNames.dueDate} TEXT,
      ${CreateTransferHeaderModelNames.registerId} TEXT,
      ${CreateTransferHeaderModelNames.divisionId} TEXT,
      ${CreateTransferHeaderModelNames.companyId} TEXT,
      ${CreateTransferHeaderModelNames.payeeId} TEXT,
      ${CreateTransferHeaderModelNames.payeeType} TEXT,
      ${CreateTransferHeaderModelNames.currencyId} TEXT,
      ${CreateTransferHeaderModelNames.currencyRate} REAL,
      ${CreateTransferHeaderModelNames.amount} REAL,
      ${CreateTransferHeaderModelNames.headerImage} TEXT,
      ${CreateTransferHeaderModelNames.footerImage} TEXT,
      ${CreateTransferHeaderModelNames.isPos} INTEGER,
      ${CreateTransferHeaderModelNames.isCheque} INTEGER,
      ${CreateTransferHeaderModelNames.posShiftId} INTEGER,
      ${CreateTransferHeaderModelNames.posBatchId} INTEGER,
      ${CreateTransferHeaderModelNames.isSynced} INTEGER,
      ${CreateTransferHeaderModelNames.isError} INTEGER,
      ${CreateTransferHeaderModelNames.error} TEXT
)
''',
    '''
CREATE TABLE ${TransactionAllocationDetailModelNames.tableName}(
  ${TransactionAllocationDetailModelNames.invoiceSysDocId} TEXT,
  ${TransactionAllocationDetailModelNames.invoiceVoucherId} TEXT,
  ${TransactionAllocationDetailModelNames.paymentSysDocId} TEXT,
  ${TransactionAllocationDetailModelNames.customerId} TEXT,
  ${TransactionAllocationDetailModelNames.paymentVoucherId} TEXT,
  ${TransactionAllocationDetailModelNames.arJournalId} INTEGER,
  ${TransactionAllocationDetailModelNames.paymentArid} INTEGER,
  ${TransactionAllocationDetailModelNames.allocationDate} TEXT,
  ${TransactionAllocationDetailModelNames.paymentAmount} REAL,
  ${TransactionAllocationDetailModelNames.dueAmount} REAL,
  ${TransactionAllocationDetailModelNames.isSynced} INTEGER,
  ${TransactionAllocationDetailModelNames.isChecked} INTEGER
)
''',
    '''
CREATE TABLE ${TransactionDetailModelNames.tableName}(
  ${TransactionDetailModelNames.voucherId} TEXT,
   ${TransactionDetailModelNames.paymentMethodId} TEXT,
   ${TransactionDetailModelNames.paymentMethodType} INTEGER,
      ${TransactionDetailModelNames.bankId} TEXT,
      ${TransactionDetailModelNames.description} TEXT,
      ${TransactionDetailModelNames.amount} REAL,
      ${TransactionDetailModelNames.amountFc} REAL,
      ${TransactionDetailModelNames.chequeDate} TEXT,
      ${TransactionDetailModelNames.chequeNumber} TEXT,
  ${TransactionAllocationDetailModelNames.isSynced} INTEGER
)
''',
    '''
CREATE TABLE ${UserActivityLogImportantNames.tableName}(
  ${UserActivityLogImportantNames.sysDocId} TEXT,
  ${UserActivityLogImportantNames.voucherId} TEXT,
  ${UserActivityLogImportantNames.activityType} INTEGER,
  ${UserActivityLogImportantNames.date} TEXT,
  ${UserActivityLogImportantNames.userId} TEXT,
  ${UserActivityLogImportantNames.machine} TEXT,
  ${UserActivityLogImportantNames.description} TEXT,
  ${UserActivityLogImportantNames.isSynced} INTEGER,
  ${UserActivityLogImportantNames.isError} INTEGER,
  ${UserActivityLogImportantNames.error} TEXT
)
''',
    '''
CREATE TABLE ${TaxGroupDetailNames.tableName}(
  ${TaxGroupDetailNames.sysDocId} TEXT,
  ${TaxGroupDetailNames.voucherId} TEXT,
  ${TaxGroupDetailNames.taxGroupId} TEXT,
  ${TaxGroupDetailNames.taxCode} TEXT,
  ${TaxGroupDetailNames.items} TEXT,
  ${TaxGroupDetailNames.taxRate} REAL,
  ${TaxGroupDetailNames.calculationMethod} TEXT,
  ${TaxGroupDetailNames.taxAmount} REAL,
  ${TaxGroupDetailNames.currencyId} TEXT,
  ${TaxGroupDetailNames.rowIndex} INTEGER,
  ${TaxGroupDetailNames.orderIndex} INTEGER
)
''',
    '''
CREATE TABLE ${SalesInvoiceLotApiModelNames.tableName}(
  ${SalesInvoiceLotApiModelNames.productId} TEXT,
  ${SalesInvoiceLotApiModelNames.locationId} TEXT,
  ${SalesInvoiceLotApiModelNames.lotNumber} TEXT,
  ${SalesInvoiceLotApiModelNames.reference} TEXT,
  ${SalesInvoiceLotApiModelNames.sourceLotNumber} TEXT,
  ${SalesInvoiceLotApiModelNames.quantity} REAL,
  ${SalesInvoiceLotApiModelNames.binID} TEXT,
  ${SalesInvoiceLotApiModelNames.reference2} TEXT,
  ${SalesInvoiceLotApiModelNames.sysDocId} TEXT,
  ${SalesInvoiceLotApiModelNames.voucherId} TEXT,
  ${SalesInvoiceLotApiModelNames.unitPrice} REAL,
  ${SalesInvoiceLotApiModelNames.rowIndex} INTEGER,
  ${SalesInvoiceLotApiModelNames.unitId} TEXT,
)
''',
    '''
CREATE TABLE ${SalesInvoiceDetailApiModelNames.tableName}(
  ${SalesInvoiceDetailApiModelNames.rowIndex} INTEGER,
  ${SalesInvoiceDetailApiModelNames.productID} TEXT,
  ${SalesInvoiceDetailApiModelNames.quantity} REAL,
  ${SalesInvoiceDetailApiModelNames.unitPrice} REAL,
  ${SalesInvoiceDetailApiModelNames.locationId} TEXT,
  ${SalesInvoiceDetailApiModelNames.listedPrice} REAL,
  ${SalesInvoiceDetailApiModelNames.amount} REAL,
  ${SalesInvoiceDetailApiModelNames.description} TEXT,
  ${SalesInvoiceDetailApiModelNames.discount} REAL,
  ${SalesInvoiceDetailApiModelNames.taxAmount} REAL,
  ${SalesInvoiceDetailApiModelNames.taxGroupId} TEXT,
  ${SalesInvoiceDetailApiModelNames.barcode} TEXT,
  ${SalesInvoiceDetailApiModelNames.taxOption} TEXT,
  ${SalesInvoiceDetailApiModelNames.unitId} TEXT,
  ${SalesInvoiceDetailApiModelNames.itemType} INTEGER,
  ${SalesInvoiceDetailApiModelNames.productCategory} TEXT,
  ${SalesInvoiceDetailApiModelNames.voucherId} TEXT,
  ${SalesInvoiceDetailApiModelNames.onHand} REAL,
  ${SalesInvoiceDetailApiModelNames.isDamaged} INTEGER,
  ${SalesInvoiceDetailApiModelNames.customerProductId} TEXT
)
''',
    '''
CREATE TABLE ${SalesInvoiceApiModelNames.tableName}(
  ${SalesInvoiceApiModelNames.vANSalesPOS} TEXT,
  ${SalesInvoiceApiModelNames.sysdocid} TEXT,
  ${SalesInvoiceApiModelNames.voucherid} TEXT,
  ${SalesInvoiceApiModelNames.divisionID} TEXT,
  ${SalesInvoiceApiModelNames.companyID} INTEGER,
  ${SalesInvoiceApiModelNames.shiftID} INTEGER,
  ${SalesInvoiceApiModelNames.batchID} INTEGER,
  ${SalesInvoiceApiModelNames.customerID} TEXT,
  ${SalesInvoiceApiModelNames.customerName} TEXT,
  ${SalesInvoiceApiModelNames.transactionDate} TEXT,
  ${SalesInvoiceApiModelNames.registerId} TEXT,
  ${SalesInvoiceApiModelNames.paymentType} INTEGER,
  ${SalesInvoiceApiModelNames.salespersonId} TEXT,
  ${SalesInvoiceApiModelNames.address} TEXT,
  ${SalesInvoiceApiModelNames.phone} TEXT,
  ${SalesInvoiceApiModelNames.note} TEXT,
  ${SalesInvoiceApiModelNames.total} REAL, 
  ${SalesInvoiceApiModelNames.taxAmount} REAL,
  ${SalesInvoiceApiModelNames.discount} REAL,
  ${SalesInvoiceApiModelNames.taxGroupId} TEXT,
  ${SalesInvoiceApiModelNames.reference} TEXT,
  ${SalesInvoiceApiModelNames.reference1} TEXT,
  ${SalesInvoiceApiModelNames.taxOption} INTEGER,
  ${SalesInvoiceApiModelNames.dateCreated} TEXT,
  ${SalesInvoiceApiModelNames.accountID} TEXT,
  ${SalesInvoiceApiModelNames.paymentMethodID} TEXT,
  ${SalesInvoiceApiModelNames.headerImage} TEXT,
  ${SalesInvoiceApiModelNames.footerImage} TEXT,
  ${SalesInvoiceApiModelNames.isReturn} INTEGER,
  ${SalesInvoiceApiModelNames.isSynced} INTEGER,
  ${SalesInvoiceApiModelNames.isError} INTEGER,
  ${SalesInvoiceApiModelNames.error} TEXT,
  ${SalesInvoiceApiModelNames.quantity} REAL
)
''',
    '''
CREATE TABLE ${TaxDetailNames.tableName}(
  ${TaxDetailNames.sysDocId} TEXT,
  ${TaxDetailNames.voucherId} TEXT,
  ${TaxDetailNames.taxLevel} INTEGER,
  ${TaxDetailNames.taxGroupId} TEXT,
  ${TaxDetailNames.taxItemId} TEXT,
  ${TaxDetailNames.taxItemName} TEXT,
  ${TaxDetailNames.taxRate} REAL,
  ${TaxDetailNames.calculationMethod} TEXT,
  ${TaxDetailNames.taxAmount} REAL,
  ${TaxDetailNames.orderIndex} INTEGER,
  ${TaxDetailNames.rowIndex} INTEGER,
  ${TaxDetailNames.accountId} TEXT,
  ${TaxDetailNames.currencyId} TEXT,
  ${TaxDetailNames.currencyRate} REAL
)
''',
    '''
CREATE TABLE ${NewOrderApiMOdelNames.tableName}(
  ${NewOrderApiMOdelNames.salesOrderId} TEXT,
  ${NewOrderApiMOdelNames.sysdocid} TEXT,
  ${NewOrderApiMOdelNames.voucherid} TEXT,
  ${NewOrderApiMOdelNames.customerid} TEXT,
  ${NewOrderApiMOdelNames.customerName} TEXT,
  ${NewOrderApiMOdelNames.address} TEXT,
  ${NewOrderApiMOdelNames.phone} TEXT,
  ${NewOrderApiMOdelNames.shiftId} INTEGER,
  ${NewOrderApiMOdelNames.batchId} INTEGER,
  ${NewOrderApiMOdelNames.companyid} TEXT,
  ${NewOrderApiMOdelNames.transactiondate} TEXT,
  ${NewOrderApiMOdelNames.isCash} INTEGER,
  ${NewOrderApiMOdelNames.registerId} TEXT,
  ${NewOrderApiMOdelNames.salespersonid} TEXT,
  ${NewOrderApiMOdelNames.shippingAddressId} TEXT,
  ${NewOrderApiMOdelNames.customeraddress} TEXT,
  ${NewOrderApiMOdelNames.payeetaxgroupid} TEXT,
  ${NewOrderApiMOdelNames.taxGroupId} TEXT,
  ${NewOrderApiMOdelNames.taxoption} INTEGER,
  ${NewOrderApiMOdelNames.priceincludetax} INTEGER,
  ${NewOrderApiMOdelNames.discount} REAL,
  ${NewOrderApiMOdelNames.discountPercentage} REAL,
  ${NewOrderApiMOdelNames.taxamount} REAL,
  ${NewOrderApiMOdelNames.total} REAL, 
  ${NewOrderApiMOdelNames.note} TEXT,
  ${NewOrderApiMOdelNames.paymentMethodType} INTEGER,
  ${NewOrderApiMOdelNames.isSynced} INTEGER,
  ${NewOrderApiMOdelNames.isError} INTEGER,
  ${NewOrderApiMOdelNames.error} TEXT,
  ${NewOrderApiMOdelNames.routeId} TEXT,
  ${NewOrderApiMOdelNames.headerImage} TEXT,
  ${NewOrderApiMOdelNames.footerImage} TEXT,
  ${NewOrderApiMOdelNames.quantity} REAL
)
''',
    '''
CREATE TABLE ${NewOrderDetailApiModelNames.tableName}(
  ${NewOrderDetailApiModelNames.detailId} TEXT,
  ${NewOrderDetailApiModelNames.sysDocId} TEXT,
  ${NewOrderDetailApiModelNames.voucherId} TEXT,
  ${NewOrderDetailApiModelNames.productId} TEXT,
  ${NewOrderDetailApiModelNames.salesOrderId} TEXT,
  ${NewOrderDetailApiModelNames.quantity} REAL,
  ${NewOrderDetailApiModelNames.barcode} TEXT,
  ${NewOrderDetailApiModelNames.unitprice} REAL,
  ${NewOrderDetailApiModelNames.amount} REAL,
  ${NewOrderDetailApiModelNames.description} TEXT,
  ${NewOrderDetailApiModelNames.unitid} TEXT,
  ${NewOrderDetailApiModelNames.taxoption} INTEGER,
  ${NewOrderDetailApiModelNames.taxgroupid} TEXT,
  ${NewOrderDetailApiModelNames.taxamount} REAL,
  ${NewOrderDetailApiModelNames.rowindex} INTEGER,
  ${NewOrderDetailApiModelNames.locationid} TEXT,
  ${NewOrderDetailApiModelNames.factor} REAL,
  ${NewOrderDetailApiModelNames.factorType} TEXT,
  ${NewOrderDetailApiModelNames.isManinUnit} INTEGER
)
''',
    '''
CREATE TABLE ${NewOrderLotApiModelNames.tableName}(
  ${NewOrderLotApiModelNames.salesLotId} TEXT,
  ${NewOrderLotApiModelNames.productId} TEXT,
  ${NewOrderLotApiModelNames.sysDocId} TEXT,
  ${NewOrderLotApiModelNames.voucherId} TEXT,
  ${NewOrderLotApiModelNames.locationId} TEXT,
  ${NewOrderLotApiModelNames.reference2} TEXT,
  ${NewOrderLotApiModelNames.reference} TEXT,
  ${NewOrderLotApiModelNames.cost} REAL,
  ${NewOrderLotApiModelNames.unitPrice} REAL,
  ${NewOrderLotApiModelNames.rowIndex} INTEGER,
  ${NewOrderLotApiModelNames.unitId} TEXT,
  ${NewOrderLotApiModelNames.lotNumber} TEXT,
  ${NewOrderLotApiModelNames.quantity} REAL
)
''',
    '''
    CREATE TABLE ${ConnectionModelImpNames.tableName}(
       ${ConnectionModelImpNames.connectionName} TEXT,
       ${ConnectionModelImpNames.serverIp} TEXT,
        ${ConnectionModelImpNames.port} TEXT,
        ${ConnectionModelImpNames.databaseName} TEXT,
        ${ConnectionModelImpNames.userName} TEXT,
        ${ConnectionModelImpNames.password} TEXT
    )
    ''',
    '''
    CREATE TABLE ${PosCashRegisterListLocalImportantNames.tableName}(
      ${PosCashRegisterListLocalImportantNames.cashRegisterID} TEXT,
      ${PosCashRegisterListLocalImportantNames.cashRegisterName} TEXT,
      ${PosCashRegisterListLocalImportantNames.locationID} TEXT,
      ${PosCashRegisterListLocalImportantNames.registerType} INTEGER,
      ${PosCashRegisterListLocalImportantNames.computerName} TEXT,
      ${PosCashRegisterListLocalImportantNames.receiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.returnDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.defaultCustomerID} TEXT,
      ${PosCashRegisterListLocalImportantNames.discountAccountID} TEXT,
      ${PosCashRegisterListLocalImportantNames.expenseDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.pettyCashAccountID} TEXT,
      ${PosCashRegisterListLocalImportantNames.cashReceiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.chequeReceiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.salesOrderDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.inventoryTransferDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.salesPersonID} TEXT,
      ${PosCashRegisterListLocalImportantNames.note} TEXT,
      ${PosCashRegisterListLocalImportantNames.isUseLastPrice} INTEGER,
      ${PosCashRegisterListLocalImportantNames.dateUpdated} TEXT,
      ${PosCashRegisterListLocalImportantNames.dateCreated} TEXT,
      ${PosCashRegisterListLocalImportantNames.createdBy} TEXT,
      ${PosCashRegisterListLocalImportantNames.updatedBy} TEXT
    )
    ''',
    '''
CREATE TABLE ${CompanyListLocalImportantNames.tableName} (
  ${CompanyListLocalImportantNames.companyName} TEXT,
  ${CompanyListLocalImportantNames.notes} TEXT,
  ${CompanyListLocalImportantNames.baseCurrencyID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerListLocalImportantNames.tableName} (
  ${CustomerListLocalImportantNames.routeID} TEXT,
  ${CustomerListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerListLocalImportantNames.customerID} TEXT,
  ${CustomerListLocalImportantNames.customerName} TEXT,
  ${CustomerListLocalImportantNames.shortName} TEXT,
  ${CustomerListLocalImportantNames.companyName} TEXT,
  ${CustomerListLocalImportantNames.addressPrintFormat} TEXT,
  ${CustomerListLocalImportantNames.city} TEXT,
  ${CustomerListLocalImportantNames.contactName} TEXT,
  ${CustomerListLocalImportantNames.phone1} TEXT,
  ${CustomerListLocalImportantNames.email} TEXT,
  ${CustomerListLocalImportantNames.phone2} TEXT,
  ${CustomerListLocalImportantNames.address1} TEXT,
  ${CustomerListLocalImportantNames.address2} TEXT,
  ${CustomerListLocalImportantNames.address3} TEXT,
  ${CustomerListLocalImportantNames.taxGroupID} TEXT,
  ${CustomerListLocalImportantNames.taxOption} INTEGER,
  ${CustomerListLocalImportantNames.dateCreated} TEXT,
  ${CustomerListLocalImportantNames.taxIDNumber} TEXT,
  ${CustomerListLocalImportantNames.latitude} TEXT,
  ${CustomerListLocalImportantNames.longitude} TEXT,
  ${CustomerListLocalImportantNames.customerClassID} TEXT,
  ${CustomerListLocalImportantNames.parentCustomerID} TEXT
)
''',
    '''
CREATE TABLE ${RouteCustomerListLocalImportantNames.tableName}(
  ${RouteCustomerListLocalImportantNames.routeCustomerID} TEXT,
  ${RouteCustomerListLocalImportantNames.routeID} TEXT,
  ${RouteCustomerListLocalImportantNames.customerID} TEXT,
  ${RouteCustomerListLocalImportantNames.customerName} TEXT,
  ${RouteCustomerListLocalImportantNames.shortName} TEXT,
  ${RouteCustomerListLocalImportantNames.dateCreated} TEXT,
  ${RouteCustomerListLocalImportantNames.dateUpdated} TEXT,
  ${RouteCustomerListLocalImportantNames.latitude} TEXT,
  ${RouteCustomerListLocalImportantNames.longitude} TEXT,
  ${RouteCustomerListLocalImportantNames.address1} TEXT,
  ${RouteCustomerListLocalImportantNames.status} TEXT,
  ${RouteCustomerListLocalImportantNames.inActive} INTEGER,
  ${RouteCustomerListLocalImportantNames.creditLimitType} INTEGER,
  ${RouteCustomerListLocalImportantNames.noCredit} INTEGER,
  ${RouteCustomerListLocalImportantNames.creditAvailable} REAL,
  ${RouteCustomerListLocalImportantNames.isHold} INTEGER
)
''',
    '''
CREATE TABLE ${RouteListLocalImportantNames.tableName}(
  ${RouteListLocalImportantNames.routeID} TEXT,
  ${RouteListLocalImportantNames.routeName} TEXT,
  ${RouteListLocalImportantNames.locationID} TEXT,
  ${RouteListLocalImportantNames.isEnableAllocation} INTEGER,
  ${RouteListLocalImportantNames.damageLocationID} TEXT
)
''',
    '''
CREATE TABLE ${SysDocDetailListLocalImportantNames.tableName}(
  ${SysDocDetailListLocalImportantNames.sysDocID} TEXT,
  ${SysDocDetailListLocalImportantNames.numberPrefix} TEXT,
  ${SysDocDetailListLocalImportantNames.nextNumber} INTEGER,
  ${SysDocDetailListLocalImportantNames.lastNumber} TEXT,
  ${SysDocDetailListLocalImportantNames.headerImage} TEXT,
  ${SysDocDetailListLocalImportantNames.footerImage} TEXT,
  ${SysDocDetailListLocalImportantNames.inventoryTransferLocationID} TEXT,
  ${SysDocDetailListLocalImportantNames.defaultCustomerID} TEXT,
  ${SysDocDetailListLocalImportantNames.priceIncludeTax} INTEGER
)
''',
    '''
CREATE TABLE ${AccountListLocalImportantNames.tableName}(
  ${AccountListLocalImportantNames.cashRegisterID} TEXT,
  ${AccountListLocalImportantNames.displayName} TEXT,
  ${AccountListLocalImportantNames.accountID} TEXT,
  ${AccountListLocalImportantNames.accountName} TEXT
)
''',
    '''
CREATE TABLE ${SecurityListLocalImportantNames.tableName}(
  ${SecurityListLocalImportantNames.securityRoleID} TEXT,
  ${SecurityListLocalImportantNames.securityRoleName} TEXT,
  ${SecurityListLocalImportantNames.isAllowed} INTEGER,
  ${SecurityListLocalImportantNames.userID} TEXT,
  ${SecurityListLocalImportantNames.groupID} TEXT,
  ${SecurityListLocalImportantNames.intValue} INTEGER
)
''',
    '''
CREATE TABLE ${TaxListLocalImportantNames.tableName}(
  ${TaxListLocalImportantNames.taxCode} TEXT,
  ${TaxListLocalImportantNames.taxGroupID} TEXT,
  ${TaxListLocalImportantNames.rowIndex} INTEGER,
  ${TaxListLocalImportantNames.taxItemName} TEXT,
  ${TaxListLocalImportantNames.taxType} TEXT,
  ${TaxListLocalImportantNames.calculationMethod} INTEGER,
  ${TaxListLocalImportantNames.taxRate} REAL
)

''',
    '''
CREATE TABLE ${BankListLocalImportantNames.tableName}(
  ${BankListLocalImportantNames.bankCode} TEXT,
  ${BankListLocalImportantNames.bankName} TEXT,
  ${BankListLocalImportantNames.contactName} TEXT,
  ${BankListLocalImportantNames.phone} TEXT,
  ${BankListLocalImportantNames.fax} TEXT,
  ${BankListLocalImportantNames.inactive} INTEGER
)
''',
    '''
CREATE TABLE ${PaymentMethodLocalImportantNames.tableName}(
  ${PaymentMethodLocalImportantNames.cashRegisterID} TEXT,
  ${PaymentMethodLocalImportantNames.inactive} INTEGER,
  ${PaymentMethodLocalImportantNames.paymentMethodID} TEXT,
  ${PaymentMethodLocalImportantNames.displayName} TEXT,
  ${PaymentMethodLocalImportantNames.accountID} TEXT,
  ${PaymentMethodLocalImportantNames.accountName} TEXT,
  ${PaymentMethodLocalImportantNames.methodType} INTEGER
)
''',
    '''
CREATE TABLE ${ProductLotListLocalImportantNames.tableName}(
  ${ProductLotListLocalImportantNames.productID} TEXT,
  ${ProductLotListLocalImportantNames.locationID} TEXT,
  ${ProductLotListLocalImportantNames.lotNumber} TEXT,
  ${ProductLotListLocalImportantNames.reference} TEXT,
  ${ProductLotListLocalImportantNames.reference2} TEXT,
  ${ProductLotListLocalImportantNames.itemType} INTEGER,
  ${ProductLotListLocalImportantNames.sourceLotNumber} TEXT,
  ${ProductLotListLocalImportantNames.lotQty} REAL,
  ${ProductLotListLocalImportantNames.cost} REAL,
  ${ProductLotListLocalImportantNames.consignNumber} TEXT,
  ${ProductLotListLocalImportantNames.availableQty} REAL
)
''',
    '''
CREATE TABLE ${ProductListLocalImportantNames.tableName}(
  ${ProductListLocalImportantNames.productID} TEXT,
  ${ProductListLocalImportantNames.description} TEXT,
  ${ProductListLocalImportantNames.isTrackLot} INTEGER,
  ${ProductListLocalImportantNames.upc} TEXT,
  ${ProductListLocalImportantNames.quantity} REAL,
  ${ProductListLocalImportantNames.unitID} TEXT,
  ${ProductListLocalImportantNames.taxGroupID} TEXT,
  ${ProductListLocalImportantNames.taxOption} INTEGER,
  ${ProductListLocalImportantNames.price} REAL,
  ${ProductListLocalImportantNames.standardPrice} REAL,
  ${ProductListLocalImportantNames.wholeSalePrice} REAL,
  ${ProductListLocalImportantNames.specialPrice} REAL,
  ${ProductListLocalImportantNames.minPrice} REAL,
  ${ProductListLocalImportantNames.description2} TEXT,
  ${ProductListLocalImportantNames.itemType} INTEGER,
  ${ProductListLocalImportantNames.openingStock} REAL,
  ${ProductListLocalImportantNames.saleQuantity} REAL,
  ${ProductListLocalImportantNames.returnQuantity} REAL
)
''',
    '''
CREATE TABLE ${UnitListLocalImportantNames.tableName}(
  ${UnitListLocalImportantNames.code} TEXT,
  ${UnitListLocalImportantNames.name} TEXT,
  ${UnitListLocalImportantNames.productID} TEXT,
  ${UnitListLocalImportantNames.factorType} TEXT,
  ${UnitListLocalImportantNames.factor} REAL,
  ${UnitListLocalImportantNames.isMainUnit} INTEGER
)
''',
    '''
CREATE TABLE ${LocationPriceListLocalImportantNames.tableName}(
  ${LocationPriceListLocalImportantNames.sysDocID} TEXT,
  ${LocationPriceListLocalImportantNames.voucherID} TEXT,
  ${LocationPriceListLocalImportantNames.productID} TEXT,
  ${LocationPriceListLocalImportantNames.customerProductID} TEXT,
  ${LocationPriceListLocalImportantNames.unitPrice} REAL,
  ${LocationPriceListLocalImportantNames.description} TEXT,
  ${LocationPriceListLocalImportantNames.remarks} TEXT,
  ${LocationPriceListLocalImportantNames.unitID} TEXT,
  ${LocationPriceListLocalImportantNames.unitQuantity} REAL,
  ${LocationPriceListLocalImportantNames.unitFactor} REAL,
  ${LocationPriceListLocalImportantNames.factorType} TEXT,
  ${LocationPriceListLocalImportantNames.subunitPrice} REAL,
  ${LocationPriceListLocalImportantNames.rowIndex} INTEGER,
  ${LocationPriceListLocalImportantNames.locationID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerClassPriceListLocalImportantNames.tableName}(
  ${CustomerClassPriceListLocalImportantNames.sysDocID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.voucherID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.productID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.customerProductID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitPrice} REAL,
  ${CustomerClassPriceListLocalImportantNames.description} TEXT,
  ${CustomerClassPriceListLocalImportantNames.remarks} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitQuantity} REAL,
  ${CustomerClassPriceListLocalImportantNames.unitFactor} REAL,
  ${CustomerClassPriceListLocalImportantNames.factorType} TEXT,
  ${CustomerClassPriceListLocalImportantNames.subunitPrice} REAL,
  ${CustomerClassPriceListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerClassPriceListLocalImportantNames.customerClassID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerPriceListLocalImportantNames.tableName}(
  ${CustomerPriceListLocalImportantNames.sysDocID} TEXT,
  ${CustomerPriceListLocalImportantNames.voucherID} TEXT,
  ${CustomerPriceListLocalImportantNames.productID} TEXT,
  ${CustomerPriceListLocalImportantNames.customerProductID} TEXT,
  ${CustomerPriceListLocalImportantNames.unitPrice} REAL,
  ${CustomerPriceListLocalImportantNames.description} TEXT,
  ${CustomerPriceListLocalImportantNames.remarks} TEXT,
  ${CustomerPriceListLocalImportantNames.unitID} TEXT,
  ${CustomerPriceListLocalImportantNames.unitQuantity} REAL,
  ${CustomerPriceListLocalImportantNames.unitFactor} REAL,
  ${CustomerPriceListLocalImportantNames.factorType} TEXT,
  ${CustomerPriceListLocalImportantNames.subunitPrice} REAL,
  ${CustomerPriceListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerPriceListLocalImportantNames.customerID} TEXT,
  ${CustomerPriceListLocalImportantNames.routeID} TEXT,
  ${CustomerPriceListLocalImportantNames.vanID} TEXT,
  ${CustomerPriceListLocalImportantNames.applicableToChild} INTEGER
)
''',
    '''
CREATE TABLE ${VanPriceListLocalImportantNames.tableName}(
  ${VanPriceListLocalImportantNames.sysDocID} TEXT,
  ${VanPriceListLocalImportantNames.voucherID} TEXT,
  ${VanPriceListLocalImportantNames.productID} TEXT,
  ${VanPriceListLocalImportantNames.customerProductID} TEXT,
  ${VanPriceListLocalImportantNames.unitPrice} REAL,
  ${VanPriceListLocalImportantNames.description} TEXT,
  ${VanPriceListLocalImportantNames.remarks} TEXT,
  ${VanPriceListLocalImportantNames.unitID} TEXT,
  ${VanPriceListLocalImportantNames.unitQuantity} REAL,
  ${VanPriceListLocalImportantNames.unitFactor} REAL,
  ${VanPriceListLocalImportantNames.factorType} TEXT,
  ${VanPriceListLocalImportantNames.subunitPrice} REAL,
  ${VanPriceListLocalImportantNames.rowIndex} INTEGER,
  ${VanPriceListLocalImportantNames.routeID} TEXT,
  ${VanPriceListLocalImportantNames.vanID} TEXT
)
''',
    '''
CREATE TABLE ${RoutePriceListLocalImportantNames.tableName}(
  ${RoutePriceListLocalImportantNames.sysDocID} TEXT,
  ${RoutePriceListLocalImportantNames.voucherID} TEXT,
  ${RoutePriceListLocalImportantNames.productID} TEXT,
  ${RoutePriceListLocalImportantNames.customerProductID} TEXT,
  ${RoutePriceListLocalImportantNames.unitPrice} REAL,
  ${RoutePriceListLocalImportantNames.description} TEXT,
  ${RoutePriceListLocalImportantNames.remarks} TEXT,
  ${RoutePriceListLocalImportantNames.unitID} TEXT,
  ${RoutePriceListLocalImportantNames.unitQuantity} REAL,
  ${RoutePriceListLocalImportantNames.unitFactor} REAL,
  ${RoutePriceListLocalImportantNames.factorType} TEXT,
  ${RoutePriceListLocalImportantNames.subunitPrice} REAL,
  ${RoutePriceListLocalImportantNames.rowIndex} INTEGER,
  ${RoutePriceListLocalImportantNames.routeID} TEXT,
  ${RoutePriceListLocalImportantNames.posRegisterID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerBalanceListLocalImportantNames.tableName}(
  ${CustomerBalanceListLocalImportantNames.customerID} TEXT,
  ${CustomerBalanceListLocalImportantNames.customerName} TEXT,
  ${CustomerBalanceListLocalImportantNames.creditAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.isInactive} INTEGER,
  ${CustomerBalanceListLocalImportantNames.isHold} INTEGER,
  ${CustomerBalanceListLocalImportantNames.clValidity} TEXT,
  ${CustomerBalanceListLocalImportantNames.creditLimitType} TEXT,
  ${CustomerBalanceListLocalImportantNames.parentCustomerID} TEXT,
  ${CustomerBalanceListLocalImportantNames.limitPDCUnsecured} INTEGER,
  ${CustomerBalanceListLocalImportantNames.pdcUnsecuredLimitAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.insApprovedAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.openDNAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.tempCL} REAL,
  ${CustomerBalanceListLocalImportantNames.balance} REAL,
  ${CustomerBalanceListLocalImportantNames.pdcAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.acceptCheckPayment} INTEGER,
  ${CustomerBalanceListLocalImportantNames.acceptPDC} INTEGER,
  ${CustomerBalanceListLocalImportantNames.currencyID} TEXT,
  ${CustomerBalanceListLocalImportantNames.securityCheque} INTEGER
)
''',
    '''
CREATE TABLE ${OutstandingInvoiceListLocalImportantNames.tableName}(
  ${OutstandingInvoiceListLocalImportantNames.journalID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.sysDocID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.voucherID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.customerID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.description} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.reference} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.arDate} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.dueDate} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.originalAmount} REAL,
  ${OutstandingInvoiceListLocalImportantNames.job} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.currencyID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.currencyRate} REAL,
  ${OutstandingInvoiceListLocalImportantNames.amountDue} REAL,
  ${OutstandingInvoiceListLocalImportantNames.overdueDays} INTEGER
)
''',
    '''
CREATE TABLE ${CustomerVisitLogModelNames.tableName}(
  ${CustomerVisitLogModelNames.visitLogId} TEXT,
  ${CustomerVisitLogModelNames.customerId} TEXT,
  ${CustomerVisitLogModelNames.salesPersonId} TEXT,
  ${CustomerVisitLogModelNames.shiftId} TEXT,
  ${CustomerVisitLogModelNames.batchId} TEXT,
  ${CustomerVisitLogModelNames.startTime} TEXT,
  ${CustomerVisitLogModelNames.endTime} TEXT,
  ${CustomerVisitLogModelNames.startLatitude} TEXT,
  ${CustomerVisitLogModelNames.startLongitude} TEXT,
  ${CustomerVisitLogModelNames.closeLatitude} TEXT,
  ${CustomerVisitLogModelNames.closeLongitude} TEXT,
  ${CustomerVisitLogModelNames.isSynced} INTEGER,
  ${CustomerVisitLogModelNames.routeID} TEXT,
  ${CustomerVisitLogModelNames.vanID} TEXT,
  ${CustomerVisitLogModelNames.isSkipped} INTEGER,
  ${CustomerVisitLogModelNames.reasonForSkipping} TEXT,
  ${CustomerVisitLogModelNames.isError} INTEGER,
  ${CustomerVisitLogModelNames.error} TEXT
)
'''
  ];
  static var dbQueryTable = [
    '''
    CREATE TABLE ${ConnectionModelImpNames.tableName}(
       ${ConnectionModelImpNames.connectionName} TEXT,
       ${ConnectionModelImpNames.serverIp} TEXT,
        ${ConnectionModelImpNames.port} TEXT,
        ${ConnectionModelImpNames.databaseName} TEXT,
        ${ConnectionModelImpNames.userName} TEXT,
        ${ConnectionModelImpNames.password} TEXT
    )
    ''',
    '''
    CREATE TABLE ${PosCashRegisterListLocalImportantNames.tableName}(
      ${PosCashRegisterListLocalImportantNames.cashRegisterID} TEXT,
      ${PosCashRegisterListLocalImportantNames.cashRegisterName} TEXT,
      ${PosCashRegisterListLocalImportantNames.locationID} TEXT,
      ${PosCashRegisterListLocalImportantNames.registerType} INTEGER,
      ${PosCashRegisterListLocalImportantNames.computerName} TEXT,
      ${PosCashRegisterListLocalImportantNames.receiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.returnDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.defaultCustomerID} TEXT,
      ${PosCashRegisterListLocalImportantNames.discountAccountID} TEXT,
      ${PosCashRegisterListLocalImportantNames.expenseDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.pettyCashAccountID} TEXT,
      ${PosCashRegisterListLocalImportantNames.cashReceiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.chequeReceiptDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.salesOrderDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.inventoryTransferDocID} TEXT,
      ${PosCashRegisterListLocalImportantNames.salesPersonID} TEXT,
      ${PosCashRegisterListLocalImportantNames.note} TEXT,
      ${PosCashRegisterListLocalImportantNames.isUseLastPrice} INTEGER,
      ${PosCashRegisterListLocalImportantNames.dateUpdated} TEXT,
      ${PosCashRegisterListLocalImportantNames.dateCreated} TEXT,
      ${PosCashRegisterListLocalImportantNames.createdBy} TEXT,
      ${PosCashRegisterListLocalImportantNames.updatedBy} TEXT
    )
    ''',
    '''
CREATE TABLE ${CompanyListLocalImportantNames.tableName} (
  ${CompanyListLocalImportantNames.companyName} TEXT,
  ${CompanyListLocalImportantNames.notes} TEXT,
  ${CompanyListLocalImportantNames.baseCurrencyID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerListLocalImportantNames.tableName} (
  ${CustomerListLocalImportantNames.routeID} TEXT,
  ${CustomerListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerListLocalImportantNames.customerID} TEXT,
  ${CustomerListLocalImportantNames.customerName} TEXT,
  ${CustomerListLocalImportantNames.shortName} TEXT,
  ${CustomerListLocalImportantNames.companyName} TEXT,
  ${CustomerListLocalImportantNames.addressPrintFormat} TEXT,
  ${CustomerListLocalImportantNames.city} TEXT,
  ${CustomerListLocalImportantNames.contactName} TEXT,
  ${CustomerListLocalImportantNames.phone1} TEXT,
  ${CustomerListLocalImportantNames.email} TEXT,
  ${CustomerListLocalImportantNames.phone2} TEXT,
  ${CustomerListLocalImportantNames.address1} TEXT,
  ${CustomerListLocalImportantNames.address2} TEXT,
  ${CustomerListLocalImportantNames.address3} TEXT,
  ${CustomerListLocalImportantNames.taxGroupID} TEXT,
  ${CustomerListLocalImportantNames.taxOption} INTEGER,
  ${CustomerListLocalImportantNames.dateCreated} TEXT,
  ${CustomerListLocalImportantNames.taxIDNumber} TEXT,
  ${CustomerListLocalImportantNames.latitude} TEXT,
  ${CustomerListLocalImportantNames.longitude} TEXT,
  ${CustomerListLocalImportantNames.customerClassID} TEXT,
  ${CustomerListLocalImportantNames.parentCustomerID} TEXT
)
''',
    '''
CREATE TABLE ${RouteCustomerListLocalImportantNames.tableName}(
  ${RouteCustomerListLocalImportantNames.routeCustomerID} TEXT,
  ${RouteCustomerListLocalImportantNames.routeID} TEXT,
  ${RouteCustomerListLocalImportantNames.customerID} TEXT,
  ${RouteCustomerListLocalImportantNames.customerName} TEXT,
  ${RouteCustomerListLocalImportantNames.shortName} TEXT,
  ${RouteCustomerListLocalImportantNames.dateCreated} TEXT,
  ${RouteCustomerListLocalImportantNames.dateUpdated} TEXT,
  ${RouteCustomerListLocalImportantNames.latitude} TEXT,
  ${RouteCustomerListLocalImportantNames.longitude} TEXT,
  ${RouteCustomerListLocalImportantNames.address1} TEXT,
  ${RouteCustomerListLocalImportantNames.status} TEXT,
  ${RouteCustomerListLocalImportantNames.inActive} INTEGER,
  ${RouteCustomerListLocalImportantNames.creditLimitType} INTEGER,
  ${RouteCustomerListLocalImportantNames.noCredit} INTEGER,
  ${RouteCustomerListLocalImportantNames.creditAvailable} REAL,
  ${RouteCustomerListLocalImportantNames.isHold} INTEGER
)
''',
    '''
CREATE TABLE ${RouteListLocalImportantNames.tableName}(
  ${RouteListLocalImportantNames.routeID} TEXT,
  ${RouteListLocalImportantNames.routeName} TEXT,
  ${RouteListLocalImportantNames.locationID} TEXT,
  ${RouteListLocalImportantNames.isEnableAllocation} INTEGER,
  ${RouteListLocalImportantNames.damageLocationID} TEXT
)
''',
    '''
CREATE TABLE ${SysDocDetailListLocalImportantNames.tableName}(
  ${SysDocDetailListLocalImportantNames.sysDocID} TEXT,
  ${SysDocDetailListLocalImportantNames.numberPrefix} TEXT,
  ${SysDocDetailListLocalImportantNames.nextNumber} INTEGER,
  ${SysDocDetailListLocalImportantNames.lastNumber} TEXT,
  ${SysDocDetailListLocalImportantNames.headerImage} TEXT,
  ${SysDocDetailListLocalImportantNames.footerImage} TEXT,
  ${SysDocDetailListLocalImportantNames.inventoryTransferLocationID} TEXT,
  ${SysDocDetailListLocalImportantNames.defaultCustomerID} TEXT,
  ${SysDocDetailListLocalImportantNames.priceIncludeTax} INTEGER
)
''',
    '''
CREATE TABLE ${AccountListLocalImportantNames.tableName}(
  ${AccountListLocalImportantNames.cashRegisterID} TEXT,
  ${AccountListLocalImportantNames.displayName} TEXT,
  ${AccountListLocalImportantNames.accountID} TEXT,
  ${AccountListLocalImportantNames.accountName} TEXT
)
''',
    '''
CREATE TABLE ${SecurityListLocalImportantNames.tableName}(
  ${SecurityListLocalImportantNames.securityRoleID} TEXT,
  ${SecurityListLocalImportantNames.securityRoleName} TEXT,
  ${SecurityListLocalImportantNames.isAllowed} INTEGER,
  ${SecurityListLocalImportantNames.userID} TEXT,
  ${SecurityListLocalImportantNames.groupID} TEXT,
  ${SecurityListLocalImportantNames.intValue} INTEGER
)
''',
    '''
CREATE TABLE ${TaxListLocalImportantNames.tableName}(
  ${TaxListLocalImportantNames.taxCode} TEXT,
  ${TaxListLocalImportantNames.taxGroupID} TEXT,
  ${TaxListLocalImportantNames.rowIndex} INTEGER,
  ${TaxListLocalImportantNames.taxItemName} TEXT,
  ${TaxListLocalImportantNames.taxType} TEXT,
  ${TaxListLocalImportantNames.calculationMethod} INTEGER,
  ${TaxListLocalImportantNames.taxRate} REAL
)

''',
    '''
CREATE TABLE ${PaymentMethodLocalImportantNames.tableName}(
  ${PaymentMethodLocalImportantNames.cashRegisterID} TEXT,
  ${PaymentMethodLocalImportantNames.inactive} INTEGER,
  ${PaymentMethodLocalImportantNames.paymentMethodID} TEXT,
  ${PaymentMethodLocalImportantNames.displayName} TEXT,
  ${PaymentMethodLocalImportantNames.accountID} TEXT,
  ${PaymentMethodLocalImportantNames.accountName} TEXT,
  ${PaymentMethodLocalImportantNames.methodType} INTEGER
)
''',
    '''
CREATE TABLE ${BankListLocalImportantNames.tableName}(
  ${BankListLocalImportantNames.bankCode} TEXT,
  ${BankListLocalImportantNames.bankName} TEXT,
  ${BankListLocalImportantNames.contactName} TEXT,
  ${BankListLocalImportantNames.phone} TEXT,
  ${BankListLocalImportantNames.fax} TEXT,
  ${BankListLocalImportantNames.inactive} INTEGER
)
''',
    '''
CREATE TABLE ${ProductLotListLocalImportantNames.tableName}(
  ${ProductLotListLocalImportantNames.productID} TEXT,
  ${ProductLotListLocalImportantNames.locationID} TEXT,
  ${ProductLotListLocalImportantNames.lotNumber} TEXT,
  ${ProductLotListLocalImportantNames.reference} TEXT,
  ${ProductLotListLocalImportantNames.reference2} TEXT,
  ${ProductLotListLocalImportantNames.itemType} INTEGER,
  ${ProductLotListLocalImportantNames.sourceLotNumber} TEXT,
  ${ProductLotListLocalImportantNames.lotQty} REAL,
  ${ProductLotListLocalImportantNames.cost} REAL,
  ${ProductLotListLocalImportantNames.consignNumber} TEXT,
  ${ProductLotListLocalImportantNames.availableQty} REAL
)
''',
    '''
CREATE TABLE ${ProductListLocalImportantNames.tableName}(
  ${ProductListLocalImportantNames.productID} TEXT,
  ${ProductListLocalImportantNames.description} TEXT,
  ${ProductListLocalImportantNames.isTrackLot} INTEGER,
  ${ProductListLocalImportantNames.upc} TEXT,
  ${ProductListLocalImportantNames.quantity} REAL,
  ${ProductListLocalImportantNames.unitID} TEXT,
  ${ProductListLocalImportantNames.taxGroupID} TEXT,
  ${ProductListLocalImportantNames.taxOption} INTEGER,
  ${ProductListLocalImportantNames.price} REAL,
  ${ProductListLocalImportantNames.standardPrice} REAL,
  ${ProductListLocalImportantNames.wholeSalePrice} REAL,
  ${ProductListLocalImportantNames.specialPrice} REAL,
  ${ProductListLocalImportantNames.minPrice} REAL,
  ${ProductListLocalImportantNames.description2} TEXT,
  ${ProductListLocalImportantNames.itemType} INTEGER,
  ${ProductListLocalImportantNames.openingStock} REAL,
  ${ProductListLocalImportantNames.saleQuantity} REAL,
  ${ProductListLocalImportantNames.returnQuantity} REAL
)
''',
    '''
CREATE TABLE ${UnitListLocalImportantNames.tableName}(
  ${UnitListLocalImportantNames.code} TEXT,
  ${UnitListLocalImportantNames.name} TEXT,
  ${UnitListLocalImportantNames.productID} TEXT,
  ${UnitListLocalImportantNames.factorType} TEXT,
  ${UnitListLocalImportantNames.factor} REAL,
  ${UnitListLocalImportantNames.isMainUnit} INTEGER
)
''',
    '''
CREATE TABLE ${LocationPriceListLocalImportantNames.tableName}(
  ${LocationPriceListLocalImportantNames.sysDocID} TEXT,
  ${LocationPriceListLocalImportantNames.voucherID} TEXT,
  ${LocationPriceListLocalImportantNames.productID} TEXT,
  ${LocationPriceListLocalImportantNames.customerProductID} TEXT,
  ${LocationPriceListLocalImportantNames.unitPrice} REAL,
  ${LocationPriceListLocalImportantNames.description} TEXT,
  ${LocationPriceListLocalImportantNames.remarks} TEXT,
  ${LocationPriceListLocalImportantNames.unitID} TEXT,
  ${LocationPriceListLocalImportantNames.unitQuantity} REAL,
  ${LocationPriceListLocalImportantNames.unitFactor} REAL,
  ${LocationPriceListLocalImportantNames.factorType} TEXT,
  ${LocationPriceListLocalImportantNames.subunitPrice} REAL,
  ${LocationPriceListLocalImportantNames.rowIndex} INTEGER,
  ${LocationPriceListLocalImportantNames.locationID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerClassPriceListLocalImportantNames.tableName}(
  ${CustomerClassPriceListLocalImportantNames.sysDocID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.voucherID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.productID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.customerProductID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitPrice} REAL,
  ${CustomerClassPriceListLocalImportantNames.description} TEXT,
  ${CustomerClassPriceListLocalImportantNames.remarks} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitID} TEXT,
  ${CustomerClassPriceListLocalImportantNames.unitQuantity} REAL,
  ${CustomerClassPriceListLocalImportantNames.unitFactor} REAL,
  ${CustomerClassPriceListLocalImportantNames.factorType} TEXT,
  ${CustomerClassPriceListLocalImportantNames.subunitPrice} REAL,
  ${CustomerClassPriceListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerClassPriceListLocalImportantNames.customerClassID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerPriceListLocalImportantNames.tableName}(
  ${CustomerPriceListLocalImportantNames.sysDocID} TEXT,
  ${CustomerPriceListLocalImportantNames.voucherID} TEXT,
  ${CustomerPriceListLocalImportantNames.productID} TEXT,
  ${CustomerPriceListLocalImportantNames.customerProductID} TEXT,
  ${CustomerPriceListLocalImportantNames.unitPrice} REAL,
  ${CustomerPriceListLocalImportantNames.description} TEXT,
  ${CustomerPriceListLocalImportantNames.remarks} TEXT,
  ${CustomerPriceListLocalImportantNames.unitID} TEXT,
  ${CustomerPriceListLocalImportantNames.unitQuantity} REAL,
  ${CustomerPriceListLocalImportantNames.unitFactor} REAL,
  ${CustomerPriceListLocalImportantNames.factorType} TEXT,
  ${CustomerPriceListLocalImportantNames.subunitPrice} REAL,
  ${CustomerPriceListLocalImportantNames.rowIndex} INTEGER,
  ${CustomerPriceListLocalImportantNames.customerID} TEXT,
  ${CustomerPriceListLocalImportantNames.routeID} TEXT,
  ${CustomerPriceListLocalImportantNames.vanID} TEXT,
  ${CustomerPriceListLocalImportantNames.applicableToChild} INTEGER
)
''',
    '''
CREATE TABLE ${VanPriceListLocalImportantNames.tableName}(
  ${VanPriceListLocalImportantNames.sysDocID} TEXT,
  ${VanPriceListLocalImportantNames.voucherID} TEXT,
  ${VanPriceListLocalImportantNames.productID} TEXT,
  ${VanPriceListLocalImportantNames.customerProductID} TEXT,
  ${VanPriceListLocalImportantNames.unitPrice} REAL,
  ${VanPriceListLocalImportantNames.description} TEXT,
  ${VanPriceListLocalImportantNames.remarks} TEXT,
  ${VanPriceListLocalImportantNames.unitID} TEXT,
  ${VanPriceListLocalImportantNames.unitQuantity} REAL,
  ${VanPriceListLocalImportantNames.unitFactor} REAL,
  ${VanPriceListLocalImportantNames.factorType} TEXT,
  ${VanPriceListLocalImportantNames.subunitPrice} REAL,
  ${VanPriceListLocalImportantNames.rowIndex} INTEGER,
  ${VanPriceListLocalImportantNames.routeID} TEXT,
  ${VanPriceListLocalImportantNames.vanID} TEXT
)
''',
    '''
CREATE TABLE ${RoutePriceListLocalImportantNames.tableName}(
  ${RoutePriceListLocalImportantNames.sysDocID} TEXT,
  ${RoutePriceListLocalImportantNames.voucherID} TEXT,
  ${RoutePriceListLocalImportantNames.productID} TEXT,
  ${RoutePriceListLocalImportantNames.customerProductID} TEXT,
  ${RoutePriceListLocalImportantNames.unitPrice} REAL,
  ${RoutePriceListLocalImportantNames.description} TEXT,
  ${RoutePriceListLocalImportantNames.remarks} TEXT,
  ${RoutePriceListLocalImportantNames.unitID} TEXT,
  ${RoutePriceListLocalImportantNames.unitQuantity} REAL,
  ${RoutePriceListLocalImportantNames.unitFactor} REAL,
  ${RoutePriceListLocalImportantNames.factorType} TEXT,
  ${RoutePriceListLocalImportantNames.subunitPrice} REAL,
  ${RoutePriceListLocalImportantNames.rowIndex} INTEGER,
  ${RoutePriceListLocalImportantNames.routeID} TEXT,
  ${RoutePriceListLocalImportantNames.posRegisterID} TEXT
)
''',
    '''
CREATE TABLE ${CustomerBalanceListLocalImportantNames.tableName}(
  ${CustomerBalanceListLocalImportantNames.customerID} TEXT,
  ${CustomerBalanceListLocalImportantNames.customerName} TEXT,
  ${CustomerBalanceListLocalImportantNames.creditAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.isInactive} INTEGER,
  ${CustomerBalanceListLocalImportantNames.isHold} INTEGER,
  ${CustomerBalanceListLocalImportantNames.clValidity} TEXT,
  ${CustomerBalanceListLocalImportantNames.creditLimitType} TEXT,
  ${CustomerBalanceListLocalImportantNames.parentCustomerID} TEXT,
  ${CustomerBalanceListLocalImportantNames.limitPDCUnsecured} INTEGER,
  ${CustomerBalanceListLocalImportantNames.pdcUnsecuredLimitAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.insApprovedAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.openDNAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.tempCL} REAL,
  ${CustomerBalanceListLocalImportantNames.balance} REAL,
  ${CustomerBalanceListLocalImportantNames.pdcAmount} REAL,
  ${CustomerBalanceListLocalImportantNames.acceptCheckPayment} INTEGER,
  ${CustomerBalanceListLocalImportantNames.acceptPDC} INTEGER,
  ${CustomerBalanceListLocalImportantNames.currencyID} TEXT,
  ${CustomerBalanceListLocalImportantNames.securityCheque} INTEGER
)
''',
    '''
CREATE TABLE ${OutstandingInvoiceListLocalImportantNames.tableName}(
  ${OutstandingInvoiceListLocalImportantNames.journalID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.sysDocID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.voucherID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.customerID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.description} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.reference} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.arDate} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.dueDate} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.originalAmount} REAL,
  ${OutstandingInvoiceListLocalImportantNames.job} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.currencyID} TEXT,
  ${OutstandingInvoiceListLocalImportantNames.currencyRate} REAL,
  ${OutstandingInvoiceListLocalImportantNames.amountDue} REAL,
  ${OutstandingInvoiceListLocalImportantNames.overdueDays} INTEGER
)
''',
    '''
CREATE TABLE ${NewOrderApiMOdelNames.tableName}(
  ${NewOrderApiMOdelNames.salesOrderId} TEXT,
  ${NewOrderApiMOdelNames.sysdocid} TEXT,
  ${NewOrderApiMOdelNames.voucherid} TEXT,
  ${NewOrderApiMOdelNames.customerid} TEXT,
  ${NewOrderApiMOdelNames.customerName} TEXT,
  ${NewOrderApiMOdelNames.address} TEXT,
  ${NewOrderApiMOdelNames.phone} TEXT,
  ${NewOrderApiMOdelNames.shiftId} INTEGER,
  ${NewOrderApiMOdelNames.batchId} INTEGER,
  ${NewOrderApiMOdelNames.companyid} TEXT,
  ${NewOrderApiMOdelNames.transactiondate} TEXT,
  ${NewOrderApiMOdelNames.isCash} INTEGER,
  ${NewOrderApiMOdelNames.registerId} TEXT,
  ${NewOrderApiMOdelNames.salespersonid} TEXT,
  ${NewOrderApiMOdelNames.shippingAddressId} TEXT,
  ${NewOrderApiMOdelNames.customeraddress} TEXT,
  ${NewOrderApiMOdelNames.payeetaxgroupid} TEXT,
  ${NewOrderApiMOdelNames.taxGroupId} TEXT,
  ${NewOrderApiMOdelNames.taxoption} INTEGER,
  ${NewOrderApiMOdelNames.priceincludetax} INTEGER,
  ${NewOrderApiMOdelNames.discount} REAL,
  ${NewOrderApiMOdelNames.discountPercentage} REAL,
  ${NewOrderApiMOdelNames.taxamount} REAL,
  ${NewOrderApiMOdelNames.total} REAL, 
  ${NewOrderApiMOdelNames.note} TEXT,
  ${NewOrderApiMOdelNames.paymentMethodType} INTEGER,
  ${NewOrderApiMOdelNames.isSynced} INTEGER,
  ${NewOrderApiMOdelNames.isError} INTEGER,
  ${NewOrderApiMOdelNames.error} TEXT,
  ${NewOrderApiMOdelNames.routeId} TEXT,
  ${NewOrderApiMOdelNames.headerImage} TEXT,
  ${NewOrderApiMOdelNames.footerImage} TEXT,
  ${NewOrderApiMOdelNames.quantity} REAL
)
''',
    '''
CREATE TABLE ${NewOrderDetailApiModelNames.tableName}(
  ${NewOrderDetailApiModelNames.detailId} TEXT,
  ${NewOrderDetailApiModelNames.sysDocId} TEXT,
  ${NewOrderDetailApiModelNames.voucherId} TEXT,
  ${NewOrderDetailApiModelNames.productId} TEXT,
  ${NewOrderDetailApiModelNames.salesOrderId} TEXT,
  ${NewOrderDetailApiModelNames.quantity} REAL,
  ${NewOrderDetailApiModelNames.barcode} TEXT,
  ${NewOrderDetailApiModelNames.unitprice} REAL,
  ${NewOrderDetailApiModelNames.amount} REAL,
  ${NewOrderDetailApiModelNames.description} TEXT,
  ${NewOrderDetailApiModelNames.unitid} TEXT,
  ${NewOrderDetailApiModelNames.taxoption} INTEGER,
  ${NewOrderDetailApiModelNames.taxgroupid} TEXT,
  ${NewOrderDetailApiModelNames.taxamount} REAL,
  ${NewOrderDetailApiModelNames.rowindex} INTEGER,
  ${NewOrderDetailApiModelNames.locationid} TEXT,
  ${NewOrderDetailApiModelNames.factor} REAL,
  ${NewOrderDetailApiModelNames.factorType} TEXT,
  ${NewOrderDetailApiModelNames.isManinUnit} INTEGER
)
''',
    '''
CREATE TABLE ${NewOrderLotApiModelNames.tableName}(
  ${NewOrderLotApiModelNames.salesLotId} TEXT,
  ${NewOrderLotApiModelNames.productId} TEXT,
  ${NewOrderLotApiModelNames.sysDocId} TEXT,
  ${NewOrderLotApiModelNames.voucherId} TEXT,
  ${NewOrderLotApiModelNames.locationId} TEXT,
  ${NewOrderLotApiModelNames.reference2} TEXT,
  ${NewOrderLotApiModelNames.reference} TEXT,
  ${NewOrderLotApiModelNames.cost} REAL,
  ${NewOrderLotApiModelNames.unitPrice} REAL,
  ${NewOrderLotApiModelNames.rowIndex} INTEGER,
  ${NewOrderLotApiModelNames.unitId} TEXT,
  ${NewOrderLotApiModelNames.lotNumber} TEXT,
  ${NewOrderLotApiModelNames.quantity} REAL
)
''',
    '''
CREATE TABLE ${TaxDetailNames.tableName}(
  ${TaxDetailNames.sysDocId} TEXT,
  ${TaxDetailNames.voucherId} TEXT,
  ${TaxDetailNames.taxLevel} INTEGER,
  ${TaxDetailNames.taxGroupId} TEXT,
  ${TaxDetailNames.taxItemId} TEXT,
  ${TaxDetailNames.taxItemName} TEXT,
  ${TaxDetailNames.taxRate} REAL,
  ${TaxDetailNames.calculationMethod} TEXT,
  ${TaxDetailNames.taxAmount} REAL,
  ${TaxDetailNames.orderIndex} INTEGER,
  ${TaxDetailNames.rowIndex} INTEGER,
  ${TaxDetailNames.accountId} TEXT,
  ${TaxDetailNames.currencyId} TEXT,
  ${TaxDetailNames.currencyRate} REAL
)
''',
    '''
CREATE TABLE ${SalesInvoiceApiModelNames.tableName}(
  ${SalesInvoiceApiModelNames.vANSalesPOS} TEXT,
  ${SalesInvoiceApiModelNames.sysdocid} TEXT,
  ${SalesInvoiceApiModelNames.voucherid} TEXT,
  ${SalesInvoiceApiModelNames.divisionID} TEXT,
  ${SalesInvoiceApiModelNames.companyID} INTEGER,
  ${SalesInvoiceApiModelNames.shiftID} INTEGER,
  ${SalesInvoiceApiModelNames.batchID} INTEGER,
  ${SalesInvoiceApiModelNames.customerID} TEXT,
  ${SalesInvoiceApiModelNames.customerName} TEXT,
  ${SalesInvoiceApiModelNames.transactionDate} TEXT,
  ${SalesInvoiceApiModelNames.registerId} TEXT,
  ${SalesInvoiceApiModelNames.paymentType} INTEGER,
  ${SalesInvoiceApiModelNames.salespersonId} TEXT,
  ${SalesInvoiceApiModelNames.address} TEXT,
  ${SalesInvoiceApiModelNames.phone} TEXT,
  ${SalesInvoiceApiModelNames.note} TEXT,
  ${SalesInvoiceApiModelNames.total} REAL, 
  ${SalesInvoiceApiModelNames.taxAmount} REAL,
  ${SalesInvoiceApiModelNames.discount} REAL,
  ${SalesInvoiceApiModelNames.taxGroupId} TEXT,
  ${SalesInvoiceApiModelNames.reference} TEXT,
  ${SalesInvoiceApiModelNames.reference1} TEXT,
  ${SalesInvoiceApiModelNames.taxOption} INTEGER,
  ${SalesInvoiceApiModelNames.dateCreated} TEXT,
  ${SalesInvoiceApiModelNames.accountID} TEXT,
  ${SalesInvoiceApiModelNames.paymentMethodID} TEXT,
  ${SalesInvoiceApiModelNames.headerImage} TEXT,
  ${SalesInvoiceApiModelNames.footerImage} TEXT,
  ${SalesInvoiceApiModelNames.isReturn} INTEGER,
  ${SalesInvoiceApiModelNames.isSynced} INTEGER,
  ${SalesInvoiceApiModelNames.isError} INTEGER,
  ${SalesInvoiceApiModelNames.error} TEXT,
  ${SalesInvoiceApiModelNames.quantity} REAL
)
''',
    '''
CREATE TABLE ${SalesInvoiceDetailApiModelNames.tableName}(
  ${SalesInvoiceDetailApiModelNames.rowIndex} INTEGER,
  ${SalesInvoiceDetailApiModelNames.productID} TEXT,
  ${SalesInvoiceDetailApiModelNames.quantity} REAL,
  ${SalesInvoiceDetailApiModelNames.unitPrice} REAL,
  ${SalesInvoiceDetailApiModelNames.locationId} TEXT,
  ${SalesInvoiceDetailApiModelNames.listedPrice} REAL,
  ${SalesInvoiceDetailApiModelNames.amount} REAL,
  ${SalesInvoiceDetailApiModelNames.description} TEXT,
  ${SalesInvoiceDetailApiModelNames.discount} REAL,
  ${SalesInvoiceDetailApiModelNames.taxAmount} REAL,
  ${SalesInvoiceDetailApiModelNames.taxGroupId} TEXT,
  ${SalesInvoiceDetailApiModelNames.barcode} TEXT,
  ${SalesInvoiceDetailApiModelNames.taxOption} TEXT,
  ${SalesInvoiceDetailApiModelNames.unitId} TEXT,
  ${SalesInvoiceDetailApiModelNames.itemType} INTEGER,
  ${SalesInvoiceDetailApiModelNames.productCategory} TEXT,
  ${SalesInvoiceDetailApiModelNames.voucherId} TEXT,
  ${SalesInvoiceDetailApiModelNames.onHand} REAL,
  ${SalesInvoiceDetailApiModelNames.isDamaged} INTEGER,
  ${SalesInvoiceDetailApiModelNames.customerProductId} TEXT

)
''',
    '''
CREATE TABLE ${SalesInvoiceLotApiModelNames.tableName}(
  ${SalesInvoiceLotApiModelNames.productId} TEXT,
  ${SalesInvoiceLotApiModelNames.locationId} TEXT,
  ${SalesInvoiceLotApiModelNames.lotNumber} TEXT,
  ${SalesInvoiceLotApiModelNames.reference} TEXT,
  ${SalesInvoiceLotApiModelNames.sourceLotNumber} TEXT,
  ${SalesInvoiceLotApiModelNames.quantity} REAL,
  ${SalesInvoiceLotApiModelNames.binID} TEXT,
  ${SalesInvoiceLotApiModelNames.reference2} TEXT,
  ${SalesInvoiceLotApiModelNames.sysDocId} TEXT,
  ${SalesInvoiceLotApiModelNames.voucherId} TEXT,
  ${SalesInvoiceLotApiModelNames.unitPrice} REAL,
  ${SalesInvoiceLotApiModelNames.rowIndex} INTEGER,
  ${SalesInvoiceLotApiModelNames.unitId} TEXT
)
''',
    '''
CREATE TABLE ${TaxGroupDetailNames.tableName}(
  ${TaxGroupDetailNames.sysDocId} TEXT,
  ${TaxGroupDetailNames.voucherId} TEXT,
  ${TaxGroupDetailNames.taxGroupId} TEXT,
  ${TaxGroupDetailNames.taxCode} TEXT,
  ${TaxGroupDetailNames.items} TEXT,
  ${TaxGroupDetailNames.taxRate} REAL,
  ${TaxGroupDetailNames.calculationMethod} TEXT,
  ${TaxGroupDetailNames.taxAmount} REAL,
  ${TaxGroupDetailNames.taxExcludeDiscount} REAL,
  ${TaxGroupDetailNames.currencyId} TEXT,
  ${TaxGroupDetailNames.rowIndex} INTEGER,
  ${TaxGroupDetailNames.orderIndex} INTEGER
)''',
    '''CREATE TABLE ${CustomerVisitLogModelNames.tableName}(
  ${CustomerVisitLogModelNames.visitLogId} TEXT,
  ${CustomerVisitLogModelNames.customerId} TEXT,
  ${CustomerVisitLogModelNames.salesPersonId} TEXT,
  ${CustomerVisitLogModelNames.shiftId} TEXT,
  ${CustomerVisitLogModelNames.batchId} TEXT,
  ${CustomerVisitLogModelNames.startTime} TEXT,
  ${CustomerVisitLogModelNames.endTime} TEXT,
  ${CustomerVisitLogModelNames.startLatitude} TEXT,
  ${CustomerVisitLogModelNames.startLongitude} TEXT,
  ${CustomerVisitLogModelNames.closeLatitude} TEXT,
  ${CustomerVisitLogModelNames.closeLongitude} TEXT,
  ${CustomerVisitLogModelNames.isSynced} INTEGER,
  ${CustomerVisitLogModelNames.routeID} TEXT,
  ${CustomerVisitLogModelNames.vanID} TEXT,
  ${CustomerVisitLogModelNames.isSkipped} INTEGER,
  ${CustomerVisitLogModelNames.reasonForSkipping} TEXT,
  ${CustomerVisitLogModelNames.isError} INTEGER,
  ${CustomerVisitLogModelNames.error} TEXT
)
''',
    '''
CREATE TABLE ${UserActivityLogImportantNames.tableName}(
  ${UserActivityLogImportantNames.sysDocId} TEXT,
  ${UserActivityLogImportantNames.voucherId} TEXT,
  ${UserActivityLogImportantNames.activityType} INTEGER,
  ${UserActivityLogImportantNames.date} TEXT,
  ${UserActivityLogImportantNames.userId} TEXT,
  ${UserActivityLogImportantNames.machine} TEXT,
  ${UserActivityLogImportantNames.description} TEXT,
  ${UserActivityLogImportantNames.isSynced} INTEGER,
  ${UserActivityLogImportantNames.isError} INTEGER,
  ${UserActivityLogImportantNames.error} TEXT
)
''',
    '''
CREATE TABLE ${CreateTransferHeaderModelNames.tableName}(
  ${CreateTransferHeaderModelNames.sysDocType} INTEGER,
      ${CreateTransferHeaderModelNames.sysDocId} TEXT,
      ${CreateTransferHeaderModelNames.voucherId} TEXT,
      ${CreateTransferHeaderModelNames.reference} TEXT,
      ${CreateTransferHeaderModelNames.description} TEXT,
      ${CreateTransferHeaderModelNames.customerName} TEXT,
      ${CreateTransferHeaderModelNames.transactionDate} TEXT,
      ${CreateTransferHeaderModelNames.dueDate} TEXT,
      ${CreateTransferHeaderModelNames.registerId} TEXT,
      ${CreateTransferHeaderModelNames.divisionId} TEXT,
      ${CreateTransferHeaderModelNames.companyId} TEXT,
      ${CreateTransferHeaderModelNames.payeeId} TEXT,
      ${CreateTransferHeaderModelNames.payeeType} TEXT,
      ${CreateTransferHeaderModelNames.currencyId} TEXT,
      ${CreateTransferHeaderModelNames.currencyRate} REAL,
      ${CreateTransferHeaderModelNames.amount} REAL,
      ${CreateTransferHeaderModelNames.headerImage} TEXT,
      ${CreateTransferHeaderModelNames.footerImage} TEXT,
      ${CreateTransferHeaderModelNames.isPos} INTEGER,
      ${CreateTransferHeaderModelNames.isCheque} INTEGER,
      ${CreateTransferHeaderModelNames.posShiftId} INTEGER,
      ${CreateTransferHeaderModelNames.posBatchId} INTEGER,
      ${CreateTransferHeaderModelNames.isSynced} INTEGER,
      ${CreateTransferHeaderModelNames.isError} INTEGER,
      ${CreateTransferHeaderModelNames.error} TEXT
)
''',
    '''
CREATE TABLE ${TransactionAllocationDetailModelNames.tableName}(
  ${TransactionAllocationDetailModelNames.invoiceSysDocId} TEXT,
  ${TransactionAllocationDetailModelNames.invoiceVoucherId} TEXT,
  ${TransactionAllocationDetailModelNames.paymentSysDocId} TEXT,
  ${TransactionAllocationDetailModelNames.customerId} TEXT,
  ${TransactionAllocationDetailModelNames.paymentVoucherId} TEXT,
  ${TransactionAllocationDetailModelNames.arJournalId} INTEGER,
  ${TransactionAllocationDetailModelNames.paymentArid} INTEGER,
  ${TransactionAllocationDetailModelNames.allocationDate} TEXT,
  ${TransactionAllocationDetailModelNames.paymentAmount} REAL,
  ${TransactionAllocationDetailModelNames.dueAmount} REAL,
  ${TransactionAllocationDetailModelNames.isSynced} INTEGER,
  ${TransactionAllocationDetailModelNames.isChecked} INTEGER
)
''',
    '''
CREATE TABLE ${TransactionDetailModelNames.tableName}(
  ${TransactionDetailModelNames.voucherId} TEXT,
   ${TransactionDetailModelNames.paymentMethodId} TEXT,
   ${TransactionDetailModelNames.paymentMethodType} INTEGER,
      ${TransactionDetailModelNames.bankId} TEXT,
      ${TransactionDetailModelNames.description} TEXT,
      ${TransactionDetailModelNames.amount} REAL,
      ${TransactionDetailModelNames.amountFc} REAL,
      ${TransactionDetailModelNames.chequeDate} TEXT,
      ${TransactionDetailModelNames.chequeNumber} TEXT,
  ${TransactionAllocationDetailModelNames.isSynced} INTEGER
)
''',
    '''
CREATE TABLE ${ExpenseTransactionApiModelNames.tablename}(
      ${ExpenseTransactionApiModelNames.sysDocID} TEXT,
      ${ExpenseTransactionApiModelNames.voucherID} TEXT,
      ${ExpenseTransactionApiModelNames.reference} TEXT,
      ${ExpenseTransactionApiModelNames.transactionDate} TEXT,
      ${ExpenseTransactionApiModelNames.divisionID} TEXT,
      ${ExpenseTransactionApiModelNames.companyID} TEXT,
      ${ExpenseTransactionApiModelNames.amount} REAL,
      ${ExpenseTransactionApiModelNames.taxGroupId} TEXT,
      ${ExpenseTransactionApiModelNames.taxAmount} REAL,
      ${ExpenseTransactionApiModelNames.registerID} TEXT,
      ${ExpenseTransactionApiModelNames.headerImage} TEXT,
      ${ExpenseTransactionApiModelNames.footerImage} TEXT,
      ${ExpenseTransactionApiModelNames.isSynced} INTEGER,
      ${ExpenseTransactionApiModelNames.isError} INTEGER,
      ${ExpenseTransactionApiModelNames.error} TEXT
)
''',
    '''
CREATE TABLE ${ExpenseTransactionDetailModelNames.tablename}(
      ${ExpenseTransactionDetailModelNames.voucherId} TEXT,
      ${ExpenseTransactionDetailModelNames.accountID} TEXT,
      ${ExpenseTransactionDetailModelNames.description} TEXT,
      ${ExpenseTransactionDetailModelNames.amount} REAL,
      ${ExpenseTransactionDetailModelNames.amountFC} REAL,
      ${ExpenseTransactionDetailModelNames.taxGroupId} TEXT,
      ${ExpenseTransactionDetailModelNames.taxAmount} REAL,
      ${ExpenseTransactionDetailModelNames.rowIndex} INTEGER
)
''',
    '''
CREATE TABLE ${SalesPOSTaxGroupDetailApiModelNames.tablename}(
      ${SalesPOSTaxGroupDetailApiModelNames.sysDocId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.voucherId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxGroupId} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxCode} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.items} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxRate} REAL,
      ${SalesPOSTaxGroupDetailApiModelNames.calculationMethod} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.taxAmount} REAL,
      ${SalesPOSTaxGroupDetailApiModelNames.currencyID} TEXT,
      ${SalesPOSTaxGroupDetailApiModelNames.rowIndex} INTEGER,
      ${SalesPOSTaxGroupDetailApiModelNames.orderIndex} INTEGER
)
''',
  ];
}
