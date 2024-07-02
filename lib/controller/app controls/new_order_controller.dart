import 'dart:convert';
import 'dart:developer';
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/new_order_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_lot_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/unit_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/app%20controls/sales_invoice_controller.dart';
import 'package:axoproject/controller/app%20controls/sync_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/New%20Order%20Model/new_order_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/New%20Order%20Model/create_new_order_model.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/Tax%20Model/tax_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Api%20Services/common_api_service.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/Calculations/discount_calculation.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/Calculations/tax_calculation.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/New%20Order/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/Report Type/invoice_preview.dart';

class NewOrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getInitialCombos();
  }

  final customerControler = Get.put(CustomerListController());
  final syncController = Get.put(SyncController());
  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  final newOrderLocalController = Get.put(NewOrderLocalController());
  final productListController = Get.put(ProductListController());
  final productLotListController = Get.put(ProductLotListController());
  final homeController = Get.put(HomeController());
  final unitListController = Get.put(UnitListController());
  var discountPercentage = 0.0.obs;
  var sysDocIdController = TextEditingController().obs;
  var sysDocSuffixLoading = false.obs;
  var sysDoc = SysDocDetail().obs;
  var voucherIdController = TextEditingController().obs;
  var voucherSuffixLoading = false.obs;
  var voucherNumber = ''.obs;
  var availableProductLots = <ProductLotModel>[].obs;
  var productList = <ProductModel>[].obs;
  var productUnitList = <UnitModel>[].obs;
  var productFilterList = <ProductModel>[].obs;
  var selectedItems = <VanSaleDetailModel>[].obs;
  var isProductsLoading = false.obs;
  var selectedUnit = UnitModel().obs;
  var quantityControl = TextEditingController().obs;
  var priceControl = TextEditingController().obs;
  var stockControl = TextEditingController().obs;
  var quantityCombo =
      ProductQuantityCombo(initialQuantity: 0.0, finalQuantity: 0.0).obs;
  var customerList = [].obs;
  var lotQuantityError = false.obs;
  var isEditingQuantity = false.obs;
  var rowIndex = 0.obs;
  var quantity = 1.0.obs;
  var totalTax = 0.0.obs;
  var subTotal = 0.0.obs;
  var total = 0.0.obs;
  var batchId = 0.obs;
  var isSaveSuccess = false.obs;
  var discount = 0.0.obs;
  var customer = CustomerModel().obs;
  var isError = false.obs;
  var error = ''.obs;
  var isUpdating = false.obs;
  var helper = PrintHelper().obs;

  getInitialCombos() async {
    if (homeController.sysDocList.isEmpty) {
      await homeController.getSystemDocList();
    }
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }

    sysDoc.value = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.salesOrderDocID);
    log('new order initial combos ${sysDoc.value}');
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    if (sysDoc.value.nextNumber != null) {
      voucherNumber.value = await homeController.getNextVoucherNewOrder(
          nextNumber: sysDoc.value.nextNumber!,
          numberPrefix: sysDoc.value.numberPrefix!,
          sysDoc: sysDoc.value.sysDocID!);
      voucherIdController.value.text = voucherNumber.value;
      customerList.value = await customerControler.getCustomerList() ?? [];
      String id = await UserSimplePreferences.getSelectedCustomerID() ?? '';
      await Future.delayed(Duration(milliseconds: 2));
      try {
        customer.value = customerList.firstWhere(
          (element) => element.customerID == id,
        );
      } catch (e) {
        print('No customer found with ID: $id');
      }
    }
    log("${voucherIdController.value} voucher ${voucherNumber.value}");
    // paymentMethodList.value = homeController.paymentMethodList;
    // selectedPaymentMethod.value = paymentMethodList.first;

    update();
  }

  lotAllocationQuantityError(bool isError) {
    lotQuantityError.value = isError;
    update();
  }

  getProductUnits(
      {required String productId,
      required String unitId,
      required bool isUpdate,
      var currentUnitList}) {
    var unitList = <UnitModel>[];
    unitList = productUnitList
        .where((element) => element.productID == productId)
        .toList();

    if (unitId.isNotEmpty || unitList.isEmpty) {
      unitList.insert(0,
          UnitModel(code: unitId, factor: 1, factorType: 'M', isMainUnit: 1));
    }
    if (isUpdate == false) {
      selectedUnit.value = unitList[0];
    } else {
      var unit =
          currentUnitList.firstWhere((element) => element.code == unitId);
      selectedUnit.value = unit;
    }
    return unitList;
  }

  getProductList() async {
    // if (productList.isEmpty) {
    isProductsLoading.value = true;
    await productListController.getProductList();
    productList.value = productListController.productList
        .where((element) => element.quantity != null && element.quantity! > 0)
        .toList();
    productFilterList.value = productListController.productList
        .where((element) => element.quantity != null && element.quantity! > 0)
        .toList();
    await unitListController.getUnitList();
    productUnitList = unitListController.unitList;
    isProductsLoading.value = false;
    update();
    // }
  }

  searchItems(String value, list) {
    productFilterList.value = list
        .where((element) =>
            element.productID.toLowerCase().contains(value.toLowerCase()) ||
            element.description.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  editQuantity() {
    isEditingQuantity.value = !isEditingQuantity.value;
  }

  incrementQuantity() {
    isEditingQuantity.value = false;
    quantity.value++;
    update();
  }

  decrementQuantity() {
    isEditingQuantity.value = false;
    if (quantity > 1) {
      quantity.value--;
      update();
    }
  }

  setQuantity(String value) {
    quantity.value = double.parse(value);
  }

  resetQuantity() {
    quantity.value = 1;
    isEditingQuantity.value = false;
    update();
  }

  addItem(ProductModel item, var unitList) async {
    double price = priceControl.value.text.isNotEmpty
        ? double.parse(priceControl.value.text)
        : 0.0;
    double stock = double.parse(stockControl.value.text);
    double quantity = this.quantity.value;
    double amount = quantity * price;
    double taxAmount = 0.0;
    var taxList = await TaxHelper.calculateTax(
        taxGroupId: customer.value.taxGroupID ?? '',
        price: amount,
        isExclusive: true);
    for (var tax in taxList) {
      taxAmount += tax.taxAmount;
    }

    List<VanSaleDetail> detail = [
      VanSaleDetail(
          productId: item.productID,
          barcode: item.upc,
          amount: quantity * price,
          description: item.description,
          itemType: item.itemType,
          quantity: item.quantity,
          taxAmount: taxAmount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          taxGroupId: item.taxGroupID,
          taxOption: item.taxOption.toString(),
          unitId: selectedUnit.value.code,
          unitPrice: price,
          availableQty: stock,
          basePrice: item.price,
          returnQuantity: item.returnQuantity,
          saleQuantity: item.saleQuantity)
    ];
    List<VanSaleProductLotDetail> lot = [];
    if (item.isTrackLot == 1) {
      int index = 0;
      for (var lots in availableProductLots) {
        lot.add(VanSaleProductLotDetail(
          lotNumber: lots.lotNumber,
          locationId: lots.locationID,
          productId: lots.productID,
          quantity: double.parse(lots.controller!.value.text),
          reference2: lots.reference2,
          reference: lots.reference,
          binId: "",
          rowIndex: index,
          unitPrice: 0,
          unitid: "",
          sourceLotNumber: lots.sourceLotNumber,
          voucherId: voucherIdController.value.text,
          sysDocId: sysDocIdController.value.text,
        ));
        index++;
      }
    }
    selectedItems.add(VanSaleDetailModel(
        quantity: quantity,
        price: price,
        amount: quantity * price,
        unitTax: taxAmount,
        updatedUnit: selectedUnit.value,
        unitList: unitList,
        isEdited: true,
        taxGroupDetail: taxList,
        vanSaleDetails: detail,
        isTrackLot: item.isTrackLot,
        vanSaleProductLotDetails: lot));
    update();
    await calculateTotal();
    calculateDiscount(discount.value.toString(), false);
    availableProductLots.clear();
  }

  changeUnit(UnitModel unit,
      {required double priceAvailable, required double stockAvailable}) {
    double stock = InventoryCalculations.getStockPerFactor(
        factorType: unit.factorType ?? '',
        factor: unit.factor.toDouble(),
        stock: stockAvailable.toDouble());
    stockControl.value.text =
        InventoryCalculations.roundHalfAwayFromZeroToDecimal(stock)
            .toStringAsFixed(2);
    double price = InventoryCalculations.getPricePerFactor(
        factorType: unit.factorType ?? '',
        factor: unit.factor.toDouble(),
        price: priceAvailable.toDouble());
    priceControl.value.text =
        InventoryCalculations.roundHalfAwayFromZeroToDecimal(price)
            .toStringAsFixed(2);
    update();
  }

  bool checkIfStockAvailable(
      {required double stock, required double quantity}) {
    if (stock < quantity) {
      return false;
    } else {
      return true;
    }
  }

  deleteSavedRequest(String voucher, String sysDocId, int index) async {
    await newOrderLocalController.deleteNewOrderHeader(voucherId: voucher);
    await newOrderLocalController.deleteNewOrderDetails(voucherId: voucher);
    await newOrderLocalController.deleteNewOrderLotDetails(voucherId: voucher);
    await newOrderLocalController.deleteNewOrderTaxDetails(voucherId: voucher);
    await activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: sysDocId,
            voucherId: voucher,
            activityType: ActivityTypes.delete.value,
            date: DateTime.now().toIso8601String(),
            description: "Deleted New Order in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    update();
  }

  bool isItemAvailable(String productId) {
    return selectedItems
        .any((element) => element.vanSaleDetails![0].productId == productId);
  }

  calculateDiscount(String discountAmount, bool isPercentage) {
    log(discountAmount, name: 'discountAmount');
    double discount = discountAmount.length > 0 && discountAmount != ''
        ? double.parse(discountAmount)
        : 0.0;
    if (isPercentage) {
      this.discount.value = DiscountHelper.calculateDiscount(
          discountAmount: discount,
          totalAmount: subTotal.value,
          isPercent: true);
      discountPercentage.value = discount;
    } else {
      this.discount.value = discount;
      discountPercentage.value = DiscountHelper.calculateDiscount(
          discountAmount: discount,
          totalAmount: subTotal.value,
          isPercent: false);
    }
    update();
    for (var item in selectedItems) {
      for (var element in item.taxGroupDetail!) {
        log(element.taxExcludeDiscount.toString(), name: 'TaxExclude Amount');
        element.taxAmount = DiscountHelper.subtractPercentage(
            element.taxExcludeDiscount, discountPercentage.value);
      }
      if (item.taxGroupDetail!.isNotEmpty) {
        double tax = item.taxGroupDetail!.fold(
            0,
            (double previousValue, TaxGroupDetail tax) =>
                previousValue + tax.taxAmount);
        item.unitTax = tax.toDouble();
      } else {
        item.unitTax = 0.0;
      }

      log(item.taxGroupDetail![0].taxAmount.toString(), name: 'Element Tax');

      update();
    }
    calculateTotal();
  }

  updateItem(var item, int index) async {
    double stock = double.parse(stockControl.value.text);
    double price = priceControl.value.text.isNotEmpty
        ? double.parse(priceControl.value.text)
        : 0.0;
    double quantity = this.quantity.value;
    double taxAmount = 0.0;
    var taxList = await TaxHelper.calculateTax(
        taxGroupId: customer.value.taxGroupID ?? '',
        price: (price * quantity),
        isExclusive: true);
    for (var tax in taxList) {
      taxAmount += tax.taxAmount;
    }
    item.quantity = quantity;
    item.isEdited = true;
    item.price = price;
    item.amount = quantity * price;
    item.unitTax = taxAmount;
    item.taxGroupDetail = taxList;
    item.updatedUnit = selectedUnit.value;
    item.vanSaleDetails[0].amount = quantity * price;
    item.vanSaleDetails[0].unitId = selectedUnit.value.code;
    item.vanSaleDetails[0].unitPrice = price;
    item.vanSaleDetails[0].availableQty = stock;
    quantityCombo.value.finalQuantity = quantity;
    // if (item.isTrackLot == 1) {
    //   for (int i = 0; i < availableProductLots.length; i++) {
    //     item.vanSaleProductLotDetails![i].quantity =
    //         availableProductLots[i].controller!.text;
    //   }
    // }
    selectedItems[index] = item;
    update();
    calculateTotal();
    calculateDiscount(discount.value.toString(), false);
    availableProductLots.clear();
  }

  getAvailableProductLots(String productId,
      {List<VanSaleProductLotDetail>? lots}) async {
    availableProductLots.clear();
    await productLotListController.getAvailableProductLotList(
        productId: productId, voucher: voucherIdController.value.text);

    availableProductLots = productLotListController.productLotList;
    if (lots != null) {
      for (int i = 0; i < availableProductLots.length; i++) {
        availableProductLots[i].controller!.text = lots[i].quantity.toString();
      }
    }
    update();
  }

  removeSelectedItem(int index) {
    selectedItems.removeAt(index);
    update();
    calculateTotal();
  }

  calculateTotal() {
    subTotal.value = selectedItems.fold(
        0,
        (double previousValue, VanSaleDetailModel product) =>
            previousValue + (product.quantity * product.price ?? 0.0));
    totalTax.value = selectedItems.fold(
        0,
        (double previousValue, VanSaleDetailModel product) =>
            previousValue + (product.quantity * product.unitTax ?? 0.0));
    total.value = subTotal.value + totalTax.value - discount.value;
    update();
  }

  clearGrid() {
    selectedItems.clear();
    subTotal.value = 0.0;
    totalTax.value = 0.0;
    total.value = 0.0;
    discount.value = 0.0;
    discountPercentage.value = 0.0;
    update();
  }

  clearDatas() {
    selectedItems.clear();
    isError.value = false;
    error.value = '';
    subTotal.value = 0.0;
    totalTax.value = 0.0;
    discount.value = 0.0;
    discountPercentage.value = 0.0;
    total.value = 0.0;
    update();
  }

  saveNewOrder(BuildContext context) async {
    if (selectedItems.isEmpty) {
      SnackbarServices.errorSnackbar('Please Add items');
      return;
    }
    await newOrderLocalController.deleteNewOrderDetails(
        voucherId: voucherNumber.value);
    await newOrderLocalController.deleteNewOrderLotDetails(
        voucherId: voucherNumber.value);
    await newOrderLocalController.deleteNewOrderTaxDetails(
        voucherId: voucherNumber.value);
    await cashRegisterControler.getCashRegisterList();
    int itemRowIndex = 0;
    int taxRowindex = 0;
    int lotRowindex = 0;
    double quantity = 0;
    List<Map<String, dynamic>> registers =
        await cashRegisterControler.getCashRegisterList();
    Map<String, dynamic>? thisRegister =
        registers.isNotEmpty ? registers.first : null;

    final String user = UserSimplePreferences.getUsername() ?? '';
    int? batchID = UserSimplePreferences.getBatchID();

    List<NewOrderDetailApiModel> detail = [];
    List<NewOrderLotApiModel> lot = [];
    List<TaxDetail> tax = [];
    for (var item in selectedItems) {
      detail.add(NewOrderDetailApiModel(
        description: item.vanSaleDetails?[0].description ?? "",
        rowindex: itemRowIndex,
        quantity: item.quantity,
        amount: double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(item.amount)
                .toStringAsFixed(2)),
        voucherId: voucherIdController.value.text,
        sysDocId: sysDocIdController.value.text,
        productId: item.vanSaleDetails?[0].productId ?? "",
        unitprice: item.vanSaleDetails?[0].unitPrice ?? 0.0,
        taxgroupid: item.vanSaleDetails?[0].taxGroupId ?? "",
        locationid: item.vanSaleDetails?[0].locationId ?? "",
        taxamount: item.vanSaleDetails?[0].taxAmount ?? 0.0,
        barcode: "",
        taxoption: int.parse(item.vanSaleDetails![0].taxOption!),
        unitid: item.vanSaleDetails?[0].unitId ?? "",
      ));
      quantity = quantity + item.quantity;
      log("${item.updatedUnit!.code}       ${item.vanSaleDetails![0].unitId}",
          name: "requested headers");
      if (item.vanSaleProductLotDetails!.isNotEmpty) {
        for (var lots in item.vanSaleProductLotDetails!) {
          double uniprice = double.parse(lots.quantity.toString());
          lot.add(NewOrderLotApiModel(
            rowIndex: lotRowindex,
            sysDocId: sysDocIdController.value.text,
            voucherId: voucherIdController.value.text,
            lotNumber: lots.lotNumber,
            locationId: lots.locationId,
            productId: lots.productId,
            quantity: double.parse(lots.quantity.toString()),
            reference2: lots.reference2,
            reference: lots.reference,
            unitPrice: uniprice,
            unitId: lots.unitid,
          ));
          lotRowindex++;
        }
      }
      if (item.taxGroupDetail!.isNotEmpty) {
        log("${item.taxGroupDetail!.isNotEmpty}");
        for (var taxItem in item.taxGroupDetail!) {
          tax.add(TaxDetail(
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
            calculationMethod: taxItem.calculationMethod,
            currencyId: taxItem.currencyId,
            orderIndex: itemRowIndex,
            rowIndex: taxRowindex,
            taxItemId: taxItem.taxCode,
            taxAmount: taxItem.taxAmount.toDouble(),
            taxGroupId: taxItem.taxGroupId,
            taxRate: taxItem.taxRate.toDouble(),
          ));
          taxRowindex++;
        }
      }
      itemRowIndex++;
    }
    final NewOrderApiModel requestHeader = NewOrderApiModel(
        sysdocid: sysDocIdController.value.text,
        headerImage: sysDoc.value.headerImage,
        footerImage: sysDoc.value.footerImage,
        voucherid: voucherIdController.value.text,
        customerid: customer.value.customerID,
        transactiondate: DateTime.now().toIso8601String(),
        customerName: customer.value.customerName,
        address: customer.value.address1,
        phone: customer.value.phone1,
        companyid: "1",
        isError: isError.value ? 1 : 0,
        registerId:
            cashRegisterControler.posCashRegisterList.first.cashRegisterID,
        total: total.value,
        error: error.value,
        batchId: isUpdating.value ? batchId.value : batchID,
        taxGroupId: customer.value.taxGroupID ?? "",
        isSynced: 0,
        taxamount: totalTax.value,
        quantity: quantity);
    isSaveSuccess.value = true;
    await Future.delayed(const Duration(milliseconds: 1));
    if (isUpdating.value) {
      await newOrderLocalController.updateAsNewNewOrdersHeader(
          voucherId: voucherIdController.value.text, header: requestHeader);
    } else {
      await newOrderLocalController.insertNewOrderHeaders(
          header: requestHeader);
    }
    await newOrderLocalController.insertNewOrderDetails(detail: detail);

    await newOrderLocalController.insertNewOrderLotDetails(lot: lot);

    await newOrderLocalController.insertNewOrderTaxDetails(tax: tax);
    await newOrderLocalController.getNewOrderHeaders();
    await newOrderLocalController.getNewOrderDetails(
        voucher: voucherIdController.value.text);
    await newOrderLocalController.getNewOrderLotDetails(
        voucher: voucherIdController.value.text);
    await newOrderLocalController.getNewOrderTaxDetails(
        voucher: voucherIdController.value.text);
    // log("${newOrderLocalController.newOrderHeaders}", name: "header");
    // log("${newOrderLocalController.newOrderDetail}", name: "detail");
    // log("${newOrderLocalController.newOrderLotDetail}", name: "lot");
    // log("${newOrderLocalController.newOrderTaxDetail}", name: "tax");
    activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: requestHeader.sysdocid,
            voucherId: requestHeader.voucherid,
            activityType: isUpdating.value
                ? ActivityTypes.update.value
                : ActivityTypes.add.value,
            date: DateTime.now().toIso8601String(),
            description:
                "${isUpdating.value ? 'Updated' : 'Saved'} New Order in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    await printNewOrder();
    clearDatas();
    if (isUpdating.value == false) {
      await homeController.updateSysdocNextNumber(
          sysDoc: sysDoc.value.sysDocID ?? "",
          nextNumber: sysDoc.value.nextNumber ?? 0);
    }
    await getInitialCombos();

    SnackbarServices.successSnackbar('Successfully saved in local');
    if (isUpdating.value) {
      isUpdating.value = false;
      Navigator.pop(context);
    }
  }

  editOrderFromReport(NewOrderApiModel header) async {
    clearDatas();
    await newOrderLocalController.getNewOrderDetails(
        voucher: header.voucherid ?? '');
    await newOrderLocalController.getNewOrderLotDetails(
        voucher: header.voucherid ?? "");
    await newOrderLocalController.getNewOrderTaxDetails(
        voucher: header.voucherid ?? "");
    if (newOrderLocalController.newOrderDetail.isEmpty) {
      return;
    }
    if (customerList.isEmpty) {
      customerList.value = (await customerControler.getCustomerList())!;
    }
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerid);

    String parentCustomerId = customers.parentCustomerID ?? "";
    String taxNumber = customers.taxIDNumber ?? "";
    batchId.value = header.batchId ?? 0;
    voucherNumber.value = header.voucherid ?? '';
    sysDoc.value = SysDocDetail(
        sysDocID: header.sysdocid,
        headerImage: header.headerImage,
        footerImage: header.footerImage);
    isError.value = header.isError == 1 ? true : false;
    error.value = header.error ?? '';
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    voucherIdController.value.text = voucherNumber.value;
    total.value = header.total ?? 0.0;
    totalTax.value = header.taxamount ?? 0.0;
    subTotal.value = (total.value - totalTax.value + discount.value);
    discountPercentage.value = DiscountHelper.calculateDiscount(
        discountAmount: header.discount ?? 0.0,
        totalAmount: subTotal.value,
        isPercent: false);
    customer.value = CustomerModel(
        customerName: header.customerName,
        customerID: header.customerid,
        taxGroupID: header.taxGroupId ?? "",
        address1: header.address,
        phone1: header.phone,
        taxIDNumber: taxNumber,
        parentCustomerID: parentCustomerId);
    isUpdating.value = true;
    update();

    for (var item in newOrderLocalController.newOrderDetail) {
      if (productUnitList.isEmpty) {
        await getProductList();
      }
      double price = double.parse("${item.unitprice ?? 0}");
      var xx = newOrderLocalController.newOrderTaxDetail
          .where((x) => x.orderIndex == item.rowindex)
          .toList();
      // double taxAmount = 0.0;
      // var taxList = await TaxHelper.calculateTax(
      //     taxGroupId: item.taxgroupid ?? '', price: price, isExclusive: true);
      // for (var tax in taxList) {
      //   taxAmount += tax.taxamount;
      // }
      List<TaxGroupDetail> taxlist = [];
      if (newOrderLocalController.newOrderTaxDetail.isNotEmpty) {
        for (var tax in xx) {
          taxlist.add(TaxGroupDetail(
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
            calculationMethod: tax.calculationMethod,
            currencyId: tax.currencyId,
            orderIndex: tax.orderIndex ?? 0,
            rowIndex: tax.rowIndex,
            taxAmount: tax.taxAmount?.toDouble() ?? 0.0,
            taxGroupId: tax.taxGroupId,
            taxCode: tax.taxItemId,
            taxRate: tax.taxRate?.toDouble() ?? 0.0,
          ));
        }
      }
      List<UnitModel> unitList = [UnitModel(code: item.unitid)];
      log("${item.unitid}");
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: item.amount,
          description: item.description,
          itemType: 0,
          quantity: item.quantity,
          taxAmount: item.taxamount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowindex,
          taxGroupId: item.taxgroupid,
          taxOption: item.taxoption.toString(),
          unitId: item.unitid,
          unitPrice: item.unitprice,
        )
      ];

      List<VanSaleProductLotDetail> lot = [];
      if (newOrderLocalController.newOrderLotDetail.isNotEmpty) {
        for (var lots in newOrderLocalController.newOrderLotDetail) {
          lot.add(VanSaleProductLotDetail(
            lotNumber: lots.lotNumber,
            locationId: lots.locationId,
            productId: lots.productId,
            quantity: lots.quantity,
            reference2: lots.reference2,
            reference: lots.reference,
            binId: "",
            rowIndex: lots.rowIndex,
            unitPrice: lots.unitPrice,
            unitid: lots.unitId,
            sourceLotNumber: lots.sourceLotNumber ?? '',
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
          ));
        }
      }
      log("${detail}");
      selectedItems.add(VanSaleDetailModel(
          quantity: item.quantity,
          price: item.unitprice,
          amount: item.amount,
          unitTax: item.taxamount,
          updatedUnit: UnitModel(code: item.unitid),
          unitList: unitList,
          taxGroupDetail: taxlist,
          vanSaleDetails: detail,
          isEdited: false,
          isTrackLot: newOrderLocalController.newOrderLotDetail.isEmpty ? 0 : 1,
          vanSaleProductLotDetails: lot));
      update();
    }
  }

  printNewOrder() async {
    await Get.to(() => InvoicePreviewScreen(
          PrintHelper(
              items: selectedItems,
              transactionDate: DateFormatter.invoiceDateFormat.format(
                DateTime.now(),
              ),
              invoiceNo: voucherIdController.value.text,
              salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
              vanName: UserSimplePreferences.getVanName() ?? '',
              customer: customer.value.customerName,
              address: customer.value.address1,
              phone: customer.value.phone1,
              tax: totalTax.value.toString(),
              total: total.value.toString(),
              subTotal: subTotal.value.toString(),
              discount: discount.value.toString(),
              headerImage: sysDoc.value.headerImage,
              footerImage: sysDoc.value.footerImage,
              amountInWords: PrintHelper.convertAmountToWords(total.value)),
          PreviewTemplate.NewOrder,
        ));
  }

  printNewOrderReport(String voucherID) async {
    NewOrderApiModel header = await newOrderLocalController
        .getNewOrderHeaderUsingVoucher(voucher: voucherNumber.value);
    await newOrderLocalController.getNewOrderDetails(voucher: voucherID);
    await newOrderLocalController.getNewOrderDetails(
        voucher: header.voucherid ?? "");
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerid);

    String taxNumber = customers.taxIDNumber ?? "";
    List<VanSaleDetailModel> items = [];
    for (NewOrderDetailApiModel item
        in newOrderLocalController.newOrderDetail) {
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: item.amount,
          description: item.description,
          itemType: 0,
          taxAmount: item.taxamount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowindex,
          taxGroupId: item.taxgroupid,
          taxOption: item.taxoption.toString(),
          unitId: item.unitid,
          unitPrice: item.unitprice,
        )
      ];
      items.add(VanSaleDetailModel(
          amount: item.amount,
          isTrackLot: newOrderLocalController.newOrderLotDetail.isEmpty ? 0 : 1,
          price: item.unitprice,
          quantity: item.quantity,
          taxGroupDetail: [],
          unitList: [],
          unitTax: item.taxamount,
          initialQuantity: item.quantity ?? 0.0,
          isEdited: false,
          updatedUnit: UnitModel(code: item.unitid),
          vanSaleDetails: detail,
          vanSaleProductLotDetails: []));
    }
    var subTotal = (header.total ?? 0.0) -
        (header.taxamount ?? 0.0) +
        (header.discount ?? 0.0);
    PrintHelper helper = PrintHelper(
        items: items,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.now(),
        ),
        invoiceNo: header.voucherid,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        customer: header.customerName,
        address: header.address,
        phone: header.phone,
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        customerTrn: taxNumber,
        tax: header.taxamount?.toStringAsFixed(2),
        total: header.total?.toStringAsFixed(2),
        subTotal: subTotal.toStringAsFixed(2),
        discount: header.discount?.toStringAsFixed(2),
        headerImage: header.headerImage,
        footerImage: header.footerImage,
        companyName: UserSimplePreferences.getCompanyName() ?? '',
        amountInWords: PrintHelper.convertAmountToWords(header.total ?? 0.0));

    this.helper.value = helper;
  }
}
