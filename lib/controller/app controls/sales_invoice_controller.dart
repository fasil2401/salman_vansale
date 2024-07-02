import 'dart:developer' as dev;
import 'dart:developer';

import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/customer_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/pos_cash_register_list_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/product_lot_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/route_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/sales_invoice_controller_local.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/unit_controller.dart';
import 'package:axoproject/controller/Local%20Db%20Controller/user_activity_log_local_controller.dart';
import 'package:axoproject/controller/App%20Controls/home_controller.dart';
import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/Sales%20Invoice%20Model/sales_invoice_local_model.dart';
import 'package:axoproject/model/Local%20Db%20Model/user_log_model.dart';
import 'package:axoproject/model/Payment%20Method%20Model/payment_method_moedl.dart';
import 'package:axoproject/model/Product%20Lot%20Model/product_lot_model.dart';
import 'package:axoproject/model/Product%20Model/product_model.dart';
import 'package:axoproject/model/Sys%20Doc%20Detail%20Model/sys_doc_detail_model.dart';
import 'package:axoproject/model/VanSaleProductDetailModel/vansale_product_detail_model.dart';
import 'package:axoproject/services/Db%20Helper/db_helper.dart';
import 'package:axoproject/services/Enums/enums.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/services/print_helper.dart';
import 'package:axoproject/utils/Calculations/discount_calculation.dart';
import 'package:axoproject/utils/Calculations/inventory_calculations.dart';
import 'package:axoproject/utils/Calculations/tax_calculation.dart';
import 'package:axoproject/utils/constants/snackbar.dart';
import 'package:axoproject/utils/date_formatter.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Report%20Type/invoice_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesInvoiceController extends GetxController {
  @override
  void onInit() {
    getInitialCombos();
    super.onInit();
  }

  final activityLogLocalController = Get.put(UserActivityLogLocalController());
  final customerControler = Get.put(CustomerListController());
  final productListController = Get.put(ProductListController());
  final unitListController = Get.put(UnitListController());
  final productLotListController = Get.put(ProductLotListController());
  final salesInvoiceLocalController = Get.put(SalesInvoiceLocalController());
  final loginController = Get.put(LoginController());
  final routeControler = Get.put(RouteListController());
  final cashRegisterControler = Get.put(PosCashRegisterListController());
  var referenceNoController = TextEditingController().obs;
  var remarksController = TextEditingController().obs;
  var descriptionController = TextEditingController().obs;
  var customer = CustomerModel().obs;
  var sysDocIdController = TextEditingController().obs;
  var sysDocSuffixLoading = false.obs;
  var sysDoc = SysDocDetail().obs;
  var voucherIdController = TextEditingController().obs;
  var voucherSuffixLoading = false.obs;
  var voucherNumber = ''.obs;
  var returnToggle = false.obs;
  var creditToggle = false.obs;
  var productList = <ProductModel>[].obs;
  var productFilterList = <ProductModel>[].obs;
  var selectedItems = <VanSaleDetailModel>[].obs;
  var productUnitList = <UnitModel>[].obs;
  var isProductsLoading = false.obs;
  var selectedUnit = UnitModel().obs;
  var quantityControl = TextEditingController().obs;
  var priceControl = TextEditingController().obs;
  var stockControl = TextEditingController().obs;
  var isEditingQuantity = false.obs;
  var lotQuantityError = false.obs;
  var rowIndex = 0.obs;
  var quantity = 1.0.obs;
  var subTotal = 0.0.obs;
  var total = 0.0.obs;
  var totalTax = 0.0.obs;
  var discount = 0.0.obs;
  var discountPercentage = 0.0.obs;
  var availableProductLots = <ProductLotModel>[].obs;
  var paymentMethodList = <PaymentMethodModel>[].obs;
  var selectedPaymentMethod = PaymentMethodModel().obs;
  var helper = PrintHelper().obs;
  var isSaveSuccess = false.obs;
  var isConnected = false.obs;
  var quantityCombo =
      ProductQuantityCombo(initialQuantity: 0.0, finalQuantity: 0.0).obs;
  var customerList = [].obs;
  var isDamagedToggle = false.obs;
  var isUpdating = false.obs;
  var batchId = 0.obs;
  var isError = false.obs;
  var error = ''.obs;
  var transactionDate = ''.obs;
  var customerProductId = ''.obs;

  toggleCredit(bool value) {
    creditToggle.value = value;
    if (creditToggle.value == true) {
      selectedPaymentMethod.value =
          paymentMethodList.firstWhere((element) => element.methodType == 5);
    }
    update();
  }

  toggleDamaged(bool value) {
    isDamagedToggle.value = value;
    update();
  }

  getInitialCombos() async {
    if (homeController.sysDocList.isEmpty) {
      await homeController.getSystemDocList();
    }
    if (homeController.cashRegisterList.isEmpty) {
      await homeController.getCashRegisterList();
    }
    if (homeController.paymentMethodList.isEmpty) {
      await homeController.getPaymentMethodList();
    }
    dev.log(homeController.paymentMethodList.value.toString(),
        name: 'payment list');
    sysDoc.value = await homeController.getFirstSysDoc(
        sysDocId: homeController.cashRegisterList.first.receiptDocID);
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    if (sysDoc.value.nextNumber != null) {
      voucherNumber.value = await homeController.getNextVoucher(
          nextNumber: sysDoc.value.nextNumber!,
          numberPrefix: sysDoc.value.numberPrefix!,
          sysDoc: sysDoc.value.sysDocID!);
      voucherIdController.value.text = voucherNumber.value;
      customerList.value = await customerControler.getCustomerList() ?? [];
      String id = await UserSimplePreferences.getSelectedCustomerID() ?? '';
      // dev.log(id);
      // for (var element in customerList) {
      //   dev.log(element.customerID.toString());
      // }
      await Future.delayed(Duration(milliseconds: 2));
      try {
        customer.value = customerList.firstWhere(
          (element) => element.customerID == id,
        );
      } catch (e) {
        print('No customer found with ID: $id');
      }
      // customer.value = homeController.customer.value;
    }

    paymentMethodList.value = homeController.paymentMethodList;
    selectedPaymentMethod.value = paymentMethodList.first;
    //Modification for specific customer as requested bu Athul Axolon
    // creditToggle.value = true;
    // selectedPaymentMethod.value =
    //     paymentMethodList.firstWhere((element) => element.methodType == 5);

    update();
  }

  toggleReturn(bool value) {
    if (selectedItems.isNotEmpty) {
      SnackbarServices.errorSnackbar(
          'Please Empty the cart for changing transaction!');
      return;
    }
    returnToggle.value = value;
    productList.clear();
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
    if (returnToggle.value) {
      productList.value = productListController.productList;
      productFilterList.value = productListController.productList;
    } else {
      productList.value = productListController.productList
          .where((element) => element.quantity != null && element.quantity! > 0)
          .toList();
      productFilterList.value = productListController.productList
          .where((element) => element.quantity != null && element.quantity! > 0)
          .toList();
    }
    productFilterList.sort((a, b) => a.description!.compareTo(b.description!));
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
    productFilterList.sort((a, b) => a.description!.compareTo(b.description!));
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
  // double getProductStockById(String productId, double productQuantity) {
  //   List<VanSaleDetailModel> productList = selectedItems
  //       .where((element) => element.vanSaleDetails![0].productId == productId)
  //       .toList();
  //   double usedStock = productList.fold(
  //       0,
  //       (double previousValue, VanSaleDetailModel product) =>
  //           previousValue + product.quantity);
  //   return (productQuantity - usedStock);
  // }

  bool checkIfStockAvailable(
      {required double stock, required double quantity}) {
    if (stock < quantity) {
      return false;
    } else {
      return true;
    }
  }

  bool isItemAvailable(String productId) {
    return selectedItems
        .any((element) => element.vanSaleDetails![0].productId == productId);
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
        // isDiscountAdded: discount.value > 0.0,
        // discountPercentage: discountPercentage.value,
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
          taxGroupId: item.taxGroupID,
          taxOption: item.taxOption.toString(),
          unitId: selectedUnit.value.code,
          unitPrice: price,
          saleQuantity: item.saleQuantity,
          returnQuantity: item.returnQuantity,
          basePrice: item.price,
          availableQty: stock)
    ];
    List<VanSaleProductLotDetail> lot = [];
    if (item.isTrackLot == 1 && returnToggle.value == false) {
      int index = 0;
      for (var lots in availableProductLots) {
        log(lots.lotQty.toString(), name: 'lot Quantity');
        lot.add(VanSaleProductLotDetail(
          lotNumber: lots.lotNumber,
          locationId: lots.locationID,
          productId: lots.productID,
          quantity: lots.lotQty,
          reference2: lots.reference2,
          reference: lots.reference,
          binId: "",
          rowIndex: index,
          unitPrice: lots.cost,
          unitid: "",
          sourceLotNumber: lots.sourceLotNumber ?? "",
          voucherId: voucherIdController.value.text,
          sysDocId: sysDocIdController.value.text,
        ));
        index++;
      }
    }
    // int productIndex = await getProductById(item.productID ?? '');
    // productFilterList[productIndex].quantity =
    //     ((productFilterList[productIndex].quantity ?? 0.0) - quantity);
    // productListController.updateProductListWithStock(
    //     productId: item.productID!,
    //     isDamage: isDamagedToggle.value,
    //     quantity:
    //         ProductQuantityCombo(initialQuantity: 0.0, finalQuantity: quantity),
    // isReturn: returnToggle.value);
    selectedItems.add(VanSaleDetailModel(
      quantity: quantity,
      price: price,
      amount: quantity * price,
      unitTax: taxAmount,
      updatedUnit: selectedUnit.value,
      isDamaged: isDamagedToggle.value == true ? 1 : 0,
      isEdited: true,
      customerProductId: customerProductId.value,
      unitList: unitList,
      taxGroupDetail: taxList,
      vanSaleDetails: detail,
      isTrackLot: item.isTrackLot,
      vanSaleProductLotDetails: lot,
    ));
    update();
    await calculateTotal();
    calculateDiscount(discount.value.toString(), false);
    availableProductLots.clear();
  }

  lotAllocationQuantityError(bool isError) {
    lotQuantityError.value = isError;
    update();
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
        // isDiscountAdded: discount.value > 0.0,
        // discountPercentage: discountPercentage.value,
        isExclusive: true);
    for (var tax in taxList) {
      taxAmount += tax.taxAmount;
    }
    List<VanSaleProductLotDetail> lot = [];
    if (item.isTrackLot == 1 && returnToggle.value == false) {
      int index = 0;
      for (var lots in availableProductLots) {
        log(lots.lotQty.toString(), name: 'lot Quantity');
        lot.add(VanSaleProductLotDetail(
          lotNumber: lots.lotNumber,
          locationId: lots.locationID,
          productId: lots.productID,
          quantity: lots.lotQty,
          reference2: lots.reference2,
          reference: lots.reference,
          binId: "",
          rowIndex: index,
          unitPrice: lots.cost,
          unitid: "",
          sourceLotNumber: lots.sourceLotNumber ?? "",
          voucherId: voucherIdController.value.text,
          sysDocId: sysDocIdController.value.text,
        ));
        index++;
      }
    }
    item.quantity = quantity;
    item.isEdited = true;
    item.price = price;
    item.amount = quantity * price;
    item.unitTax = taxAmount;
    item.taxGroupDetail = taxList;
    item.vanSaleProductLotDetails = lot;
    item.updatedUnit = selectedUnit.value;
    item.isDamaged = isDamagedToggle.value == true ? 1 : 0;
    item.vanSaleDetails[0].amount = quantity * price;
    item.vanSaleDetails[0].unitId = selectedUnit.value.code;
    item.vanSaleDetails[0].unitPrice = price;
    item.vanSaleDetails[0].availableQty = stock;
    quantityCombo.value.finalQuantity = quantity;
    // productListController.updateProductListWithStock(
    //     productId: item.vanSaleDetails[0].productId,
    //     isDamage: isDamagedToggle.value,
    //     quantity: quantityCombo.value,
    //     isReturn: returnToggle.value);
    // int productIndex =
    //     await getProductById(item.vanSaleDetails[0].productId ?? '');
    // productFilterList[productIndex].quantity =
    //     ((productFilterList[productIndex].quantity ?? 0.0) - item.quantity);
    selectedItems[index] = item;
    update();
    calculateTotal();
    calculateDiscount(discount.value.toString(), false);
    availableProductLots.clear();
  }

  getAvailableProductLots(String productId,
      {List<VanSaleProductLotDetail>? lots, required bool isUpdate}) async {
    availableProductLots.clear();
    await productLotListController.getAvailableProductLotList(
        productId: productId, voucher: voucherIdController.value.text);

    if (isUpdate && lots != null) {
      availableProductLots.value = lots
          .map(
            (e) => ProductLotModel(
              productID: e.productId,
              availableQty: productLotListController.productLotList
                  .firstWhere((element) => element.lotNumber == e.lotNumber)
                  .availableQty,
              locationID: e.locationId,
              lotNumber: e.lotNumber,
              reference: e.reference,
              sourceLotNumber: e.sourceLotNumber,
              lotQty: e.quantity,
              reference2: e.reference2,
              controller: TextEditingController(text: e.quantity.toString()),
              isError: false,
            ),
          )
          .toList();
    } else {
      availableProductLots = productLotListController.productLotList;
    }

    // if (lots != null) {
    //   for (int i = 0; i < availableProductLots.length; i++) {
    //     availableProductLots[i].controller!.text = lots[i].quantity.toString();
    //   }
    // }
    update();
  }

  updateLotQuantity({required double qty, required int index}) {
    availableProductLots[index].lotQty = qty;
    update();
  }

  distributeProductLots() {
    if (isUpdating.value) {}
    double initialQuantity = quantity.value;

    for (var lot in availableProductLots) {
      if (lot.availableQty.toDouble() >= initialQuantity) {
        lot.lotQty = initialQuantity > 0 ? initialQuantity : 0.0;
        lot.controller!.text = lot.lotQty.toString();
        if (initialQuantity > 0) {
          initialQuantity -= lot.availableQty.toDouble();
        }
      } else {
        lot.lotQty = lot.availableQty.toDouble();
        lot.controller!.text = lot.availableQty.toString();
        initialQuantity -= lot.availableQty.toDouble();
      }
    }
    update();
  }

  removeSelectedItem(int index) {
    // productListController.updateProductListWithStock(
    //     productId: selectedItems[index].vanSaleDetails![0].productId!,
    //     isDamage: selectedItems[index].isDamaged == 1 ? true : false,
    //     quantity: ProductQuantityCombo(
    //         initialQuantity: selectedItems[index].quantity, finalQuantity: 0.0),
    //     isReturn: returnToggle.value);
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
            previousValue + (product.unitTax ?? 0.0));

    total.value = subTotal.value + totalTax.value - discount.value;
    if (returnToggle.value) {
      subTotal.value = -1 * subTotal.value;
      totalTax.value = -1 * totalTax.value;
      total.value = -1 * total.value;
    }
    update();
  }

  calculateDiscount(String discountAmount, bool isPercentage) {
    log(discountAmount, name: 'discountAmount');
    double discount = discountAmount.length > 0 && discountAmount != ''
        ? double.parse(discountAmount)
        : 0.0;
    if (isPercentage) {
      // this.discount.value = (subTotal.value * discount) / 100;
      this.discount.value = DiscountHelper.calculateDiscount(
          discountAmount: discount,
          totalAmount: subTotal.value,
          isPercent: true);
      discountPercentage.value = discount;
    } else {
      this.discount.value = discount;
      // discountPercentage.value = (discount * 100) / subTotal.value;
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
    // total.value = subTotal.value + totalTax.value - this.discount.value;
  }

  clearGrid() {
    for (var element in selectedItems) {
      if (element.isEdited == true) {
        // productListController.updateProductListWithStock(
        //     productId: element.vanSaleDetails![0].productId!,
        //     isDamage: element.isDamaged == 1 ? true : false,
        //     isClearing: true,
        //     quantity: ProductQuantityCombo(
        //         initialQuantity: element.quantity.toDouble(),
        //         finalQuantity: 0.0),
        //     isReturn: returnToggle.value);
      }
    }
    selectedItems.clear();
    subTotal.value = 0.0;
    totalTax.value = 0.0;
    total.value = 0.0;
    discount.value = 0.0;
    discountPercentage.value = 0.0;
    referenceNoController.value.clear();
    update();
  }

  deleteSavedRequest(String voucher, String sysdocid, int index) async {
    // await salesInvoiceLocalController.getsalesInvoiceDetails(
    //     voucher: header.voucherid ?? '');
    // for (var item in salesInvoiceLocalController.salesInvoiceDetail) {
    //   // await productListController.updateProductListWithStock(
    //   //     productId: item.productId,
    //   //     isDamage: item.isDamaged == 1 ? true : false,
    //   //     quantity: ProductQuantityCombo(
    //   //         initialQuantity: item.quantity, finalQuantity: 0.0),
    //   //     isReturn: header.isReturn == 1 ? true : false);
    // }
    await salesInvoiceLocalController.deletesalesInvoiceHeader(
        voucherId: voucher);
    await salesInvoiceLocalController.deletesalesInvoiceDetails(
        voucherId: voucher);
    await salesInvoiceLocalController.deletesalesInvoiceLotDetails(
        voucherId: voucher);
    await salesInvoiceLocalController.deletesalesInvoiceTaxDetails(
        voucherId: voucher);
    await activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: sysdocid,
            voucherId: voucher,
            activityType: ActivityTypes.delete.value,
            date: DateTime.now().toIso8601String(),
            description: "Deleted Sales Invoice in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    update();
  }

  saveNewInvoice(BuildContext context) async {
    if (selectedItems.isEmpty) {
      SnackbarServices.errorSnackbar('Please Add items');
      return;
    }
    double taxAmount = 0.0;
    double totals = 0.0;
    if (isUpdating.value == false) {
      bool isVoucherAlreadyIn = await salesInvoiceLocalController
          .isVoucherAlreadyPresent(voucher: voucherNumber.value);
      if (isVoucherAlreadyIn) {
        await homeController.updateSysdocNextNumber(
            sysDoc: sysDoc.value.sysDocID ?? "",
            nextNumber: sysDoc.value.nextNumber ?? 0);
        sysDoc.value = await homeController.getFirstSysDoc(
            sysDocId: homeController.cashRegisterList.first.receiptDocID);
        sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
        if (sysDoc.value.nextNumber != null) {
          voucherNumber.value = await homeController.getNextVoucher(
              nextNumber: sysDoc.value.nextNumber!,
              numberPrefix: sysDoc.value.numberPrefix!,
              sysDoc: sysDoc.value.sysDocID!);
          voucherIdController.value.text = voucherNumber.value;
        }
      }
    }
     else {
      await salesInvoiceLocalController.getsalesInvoiceDetails(
          voucher: voucherNumber.value);
      SalesInvoiceApiModel header = await salesInvoiceLocalController
          .getsalesInvoiceHeaderUsingVoucher(voucher: voucherNumber.value);
      if (paymentMethodList.isEmpty) {
        paymentMethodList.value = await homeController.getPaymentMethodList();
      }
      if (selectedPaymentMethod.value.methodType != header.paymentType) {
        activityLogLocalController.insertactivityLogList(
            activityLog: UserActivityLogModel(
                sysDocId: sysDocIdController.value.text,
                voucherId: voucherNumber.value,
                activityType: isUpdating.value
                    ? ActivityTypes.update.value
                    : ActivityTypes.add.value,
                date: DateTime.now().toIso8601String(),
                description:
                    "Payment mode changed from ${selectedPaymentMethod.value.displayName} to ${paymentMethodList.firstWhere((element) => element.paymentMethodID == header.paymentMethodID).displayName}",
                machine: UserSimplePreferences.getDeviceInfo(),
                userId: UserSimplePreferences.getUsername(),
                isSynced: 0));
      }
      var details = salesInvoiceLocalController.salesInvoiceDetail;
      for (int i = 0; i < details.length; i++) {
        if (details[i].quantity != selectedItems[i].quantity) {
          activityLogLocalController.insertactivityLogList(
              activityLog: UserActivityLogModel(
                  sysDocId: sysDocIdController.value.text,
                  voucherId: voucherNumber.value,
                  activityType: isUpdating.value
                      ? ActivityTypes.update.value
                      : ActivityTypes.add.value,
                  date: DateTime.now().toIso8601String(),
                  description:
                      "Changed Item ${selectedItems[i].vanSaleDetails?[0].productId ?? ""} Quantity from ${details[i].quantity} to ${selectedItems[i].quantity}",
                  machine: UserSimplePreferences.getDeviceInfo(),
                  userId: UserSimplePreferences.getUsername(),
                  isSynced: 0));
        } else if (details[i].unitPrice !=
            selectedItems[i].vanSaleDetails?[0].unitPrice) {
          activityLogLocalController.insertactivityLogList(
              activityLog: UserActivityLogModel(
                  sysDocId: sysDocIdController.value.text,
                  voucherId: voucherNumber.value,
                  activityType: isUpdating.value
                      ? ActivityTypes.update.value
                      : ActivityTypes.add.value,
                  date: DateTime.now().toIso8601String(),
                  description:
                      "Changed Item ${selectedItems[i].vanSaleDetails?[0].productId ?? ""} Amount from ${details[i].unitPrice} to ${selectedItems[i].vanSaleDetails?[0].unitPrice}",
                  machine: UserSimplePreferences.getDeviceInfo(),
                  userId: UserSimplePreferences.getUsername(),
                  isSynced: 0));
        }
      }
    }

    // await salesInvoiceLocalController.deletesalesInvoiceHeader(
    //     voucherId: voucherNumber.value);
    await salesInvoiceLocalController.deletesalesInvoiceDetails(
        voucherId: voucherNumber.value);
    await salesInvoiceLocalController.deletesalesInvoiceLotDetails(
        voucherId: voucherNumber.value);
    await salesInvoiceLocalController.deletesalesInvoiceTaxDetails(
        voucherId: voucherNumber.value);

    await cashRegisterControler.getCashRegisterList();
    await routeControler.getRouteList();
    totals = 0.0;
    taxAmount = 0.0;
    int itemRowIndex = 0;
    int taxRowindex = 0;
    int lotRowindex = 0;
    double quantity = 0.0;
    List<Map<String, dynamic>> registers =
        await cashRegisterControler.getCashRegisterList();
    Map<String, dynamic>? thisRegister =
        registers.isNotEmpty ? registers.first : null;

    final String user = UserSimplePreferences.getUsername() ?? '';
    int? batchID = UserSimplePreferences.getBatchID();

    List<SalesInvoiceDetailApiModel> detail = [];
    List<SalesInvoiceLotApiModel> lot = [];
    List<TaxGroupDetail> tax = [];
    for (var item in selectedItems) {
      detail.add(SalesInvoiceDetailApiModel(
        description: item.vanSaleDetails?[0].description ?? "",
        rowIndex: itemRowIndex,
        quantity: returnToggle.value == true
            ? (-1 * item.quantity)
            : item.quantity ?? 0.0,
        onHand: item.vanSaleDetails?[0].availableQty ?? 0.0,
        amount: double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                    returnToggle.value == true
                        ? (-1 * item.amount)
                        : item.amount ?? 0.0)
                .toStringAsFixed(2)),
        voucherId: voucherIdController.value.text,
        productId: item.vanSaleDetails?[0].productId ?? "",
        unitPrice: item.vanSaleDetails?[0].unitPrice ?? 0.0,
        taxGroupId: item.vanSaleDetails?[0].taxGroupId ?? "",
        locationId: item.isDamaged == 1
            ? routeControler.routeList[0].damageLocationID ?? ''
            : thisRegister!['LocationID'] ?? '',
        // taxAmount: item.unitTax != null
        //     ? double.parse(InventoryCalculations.roundHalfAwayFromZeroToDecimal(
        //             item.unitTax)
        //         .toStringAsFixed(2))
        //     : 0.0,
        taxAmount: double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                    returnToggle.value == true
                        ? (-1 * item.unitTax)
                        : (item.unitTax ?? 0.0))
                .toStringAsFixed(2)),
        barcode: item.vanSaleDetails?[0].barcode ?? '',
        discount: 0.0,
        itemType: 0,
        listedPrice: 0,
        isDamaged: item.isDamaged,
        productCategory: "",
        taxOption: item.vanSaleDetails![0].taxOption ?? '',
        unitId: item.vanSaleDetails?[0].unitId ?? "",
        customerProductId: item.customerProductId,
        // isMainUnit: isMainUnit ? 1 : 0,
        // factor: isMainUnit ? 1 : 0,
        // factorType: 'M'
      ));

      totals += (double.parse(
              InventoryCalculations.roundHalfAwayFromZeroToDecimal(item.unitTax)
                  .toStringAsFixed(2)) +
          double.parse(
              InventoryCalculations.roundHalfAwayFromZeroToDecimal(item.amount)
                  .toStringAsFixed(2)));
      quantity = quantity + item.quantity;
      if (item.vanSaleProductLotDetails!.isNotEmpty) {
        for (var lots in item.vanSaleProductLotDetails!) {
          log(lots.quantity.toString(), name: 'Saving Lot');
          lot.add(SalesInvoiceLotApiModel(
            rowIndex: lotRowindex,
            sysDocId: sysDocIdController.value.text,
            voucherId: voucherIdController.value.text,
            lotNumber: lots.lotNumber ?? "",
            locationId: lots.locationId ?? "",
            productId: lots.productId ?? "",
            quantity: lots.quantity,
            reference2: lots.reference2 ?? "",
            reference: lots.reference ?? "",
            unitPrice: lots.unitPrice,
            sourceLotNumber: lots.sourceLotNumber ?? '',
            binId: lots.binId ?? "",
            unitid: lots.unitid ?? '',
          ));
          lotRowindex++;
        }
      }
      // item.taxGroupDetail = item.taxGroupDetail!.toSet().toList();
      if (item.taxGroupDetail!.isNotEmpty) {
        for (var taxItem in item.taxGroupDetail!) {
          // log(taxItem.taxExcludeDiscount.toString(),
          //     name: 'Save item Exclude amount');
          tax.add(TaxGroupDetail(
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
            calculationMethod: taxItem.calculationMethod.toString(),
            currencyId: taxItem.currencyId ?? '',
            orderIndex: itemRowIndex,
            rowIndex: taxRowindex,
            taxAmount: taxItem.taxAmount != null
                ? double.parse(
                    InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                            returnToggle.value == true
                                ? (-1 * taxItem.taxAmount)
                                : taxItem.taxAmount)
                        .toStringAsFixed(2))
                : 0.0,
            taxExcludeDiscount: taxItem.taxExcludeDiscount,
            taxGroupId: taxItem.taxGroupId ?? "",
            items: taxItem.items ?? "",
            taxRate: taxItem.taxRate ?? 0.0,
            taxCode: taxItem.taxCode ?? '',
          ));
          taxRowindex++;
        }
      }
      itemRowIndex++;
      // await productListController.updateProductListWithStock(
      //     productId: item.vanSaleDetails?[0].productId ?? "",
      //     quantity: ProductQuantityCombo(
      //         initialQuantity: item.initialQuantity,
      //         finalQuantity: item.quantity.toDouble()),
      //     isReturn: returnToggle.value,
      //     isDamage: item.isDamaged == 1 ? true : false);
    }
    Map<String, Map<String, dynamic>> groupedTaxDetails = {};
    tax.forEach((taxDetail) {
      if (!groupedTaxDetails.containsKey(taxDetail.taxCode)) {
        groupedTaxDetails[taxDetail.taxCode!] = {
          // 'taxRateSum': 0.0,
          'taxAmountSum': 0.0,
        };
      }
      SalesInvoiceDetailApiModel item = salesInvoiceLocalController
          .salesInvoiceDetail
          .firstWhere((element) => element.rowIndex == taxDetail.orderIndex,
              orElse: () => SalesInvoiceDetailApiModel());
      groupedTaxDetails[taxDetail.taxCode]?['taxRate'] = taxDetail.taxRate;
      groupedTaxDetails[taxDetail.taxCode]?['taxAmountSum'] +=
          (taxDetail.taxAmount);
    });
    groupedTaxDetails.forEach((taxCode, values) {
      // print('Tax Code: $taxCode');
      // print('Total Tax Rate: ${values['taxRate']}');
      // print('Total Tax Amount: ${values['taxAmountSum']}');
      // print('---');
      // var taxAmountSum = values['taxAmountSum'];
      // if (header.isReturn == 1) {
      //   taxAmountSum = 0 - values['taxAmountSum'];
      // }
      tax.insert(
          0,
          TaxGroupDetail(
              calculationMethod: "1",
              taxCode: taxCode,
              taxRate: values['taxRate'],
              taxGroupId: customer.value.taxGroupID ?? "",
              currencyId: "",
              items: "",
              orderIndex: 0,
              rowIndex: -1,
              sysDocId: sysDocIdController.value.text,
              taxAmount: double.parse(
                  InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                          values['taxAmountSum'])
                      .toStringAsFixed(2)),
              voucherId: voucherIdController.value.text));
      taxAmount += double.parse(
          InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                  values['taxAmountSum'])
              .toStringAsFixed(2));
    });
    totals = (totals - (discount.value));
    final SalesInvoiceApiModel requestHeader = SalesInvoiceApiModel(
        sysdocid: sysDocIdController.value.text,
        headerImage: sysDoc.value.headerImage,
        footerImage: sysDoc.value.footerImage,
        voucherid: voucherIdController.value.text,
        transactionDate: isUpdating.value
            ? transactionDate.value
            : DateTime.now().toIso8601String(),
        customerId: customer.value.customerID,
        total: double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(
                    returnToggle.value == true ? (-1 * totals) : totals)
                .toStringAsFixed(2)),
        paymentType: selectedPaymentMethod.value.methodType,
        isSynced: 0,
        accountID: selectedPaymentMethod.value.accountID,
        taxOption: 0,
        customerName: customer.value.customerName,
        note: "",
        registerId:
            cashRegisterControler.posCashRegisterList.first.cashRegisterID,
        reference1: "",
        reference: referenceNoController.value.text,
        salespersonId: UserSimplePreferences.getSalesPersonID(),
        taxGroupId: customer.value.taxGroupID ?? "",
        vanSalesPos: "",
        shiftId: 1,
        address: customer.value.address1,
        phone: customer.value.phone1,
        batchId: isUpdating.value ? batchId.value : batchID,
        isReturn: returnToggle.value == true ? 1 : 0,
        companyId: 0,
        discount: discount.value,
        divisionId: "",
        isnewRecord: 1,
        paymentMethodID: selectedPaymentMethod.value.paymentMethodID,
        taxAmount: double.parse(
            InventoryCalculations.roundHalfAwayFromZeroToDecimal(taxAmount)
                .toStringAsFixed(2)),
        quantity: quantity,
        isError: isError.value ? 1 : 0,
        error: error.value,
        dateCreated: DateTime.now().toIso8601String());
    isSaveSuccess.value = true;
    // update();
    await Future.delayed(const Duration(milliseconds: 1));

    if (isUpdating.value) {
      await salesInvoiceLocalController.updateAsNewSalesInvoiceHeader(
          voucherId: voucherIdController.value.text, header: requestHeader);
    } else {
      await salesInvoiceLocalController.insertsalesInvoiceHeaders(
          header: requestHeader);
    }

    await salesInvoiceLocalController.insertsalesInvoiceDetails(detail: detail);

    await salesInvoiceLocalController.insertsalesInvoiceLotDetails(lot: lot);
    await salesInvoiceLocalController.deletesalesInvoiceTaxDetails(
        voucherId: voucherIdController.value.text);

    await salesInvoiceLocalController.insertsalesInvoiceTaxDetails(tax: tax);
    await salesInvoiceLocalController.getsalesInvoiceHeaders();
    await salesInvoiceLocalController.getsalesInvoiceDetails(
        voucher: voucherIdController.value.text);
    await salesInvoiceLocalController.getsalesInvoiceLotDetails(
        voucher: voucherIdController.value.text);
    await salesInvoiceLocalController.getsalesInvoiceTaxDetails(
        voucher: voucherIdController.value.text);
    activityLogLocalController.insertactivityLogList(
        activityLog: UserActivityLogModel(
            sysDocId: requestHeader.sysdocid,
            voucherId: voucherIdController.value.text,
            activityType: isUpdating.value
                ? ActivityTypes.update.value
                : ActivityTypes.add.value,
            date: DateTime.now().toIso8601String(),
            description:
                "${isUpdating.value ? 'Updated' : 'Saved'} Sales Invoice in Local",
            machine: UserSimplePreferences.getDeviceInfo(),
            userId: UserSimplePreferences.getUsername(),
            isSynced: 0));
    int templateIndex = UserSimplePreferences.getPrintTemplate() ?? 1;
    await printSalesReport(voucherIdController.value.text);

    clearDatas();
    if (isUpdating.value == false) {
      log('updating sysdoc');
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

  clearDatas() {
    selectedItems.clear();
    isError.value = false;
    error.value = '';
    subTotal.value = 0.0;
    totalTax.value = 0.0;
    discount.value = 0.0;
    discountPercentage.value = 0.0;
    total.value = 0.0;
    remarksController.value.clear();
    descriptionController.value.clear();
    referenceNoController.value.clear();
    returnToggle.value = false;
    creditToggle.value = false;
    // isSaveSuccess.value = false;
    update();
  }

  editInvoiceFromReport(SalesInvoiceApiModel header) async {
    clearDatas();
    await salesInvoiceLocalController.getsalesInvoiceDetails(
        voucher: header.voucherid ?? '');
    await salesInvoiceLocalController.getsalesInvoiceLotDetails(
        voucher: header.voucherid ?? "");
    await salesInvoiceLocalController.getsalesInvoiceTaxDetails(
        voucher: header.voucherid ?? "");
    if (salesInvoiceLocalController.salesInvoiceDetail.isEmpty) {
      return;
    }
    if (customerList.isEmpty) {
      customerList.value = (await customerControler.getCustomerList())!;
    }
    if (paymentMethodList.isEmpty) {
      paymentMethodList.value = await homeController.getPaymentMethodList();
    }
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerId);

    String parentCustomerId = customers.parentCustomerID ?? "";
    String taxNumber = customers.taxIDNumber ?? "";
    voucherNumber.value = header.voucherid ?? '';
    batchId.value = header.batchId ?? 0;
    transactionDate.value = header.transactionDate ?? '';
    sysDoc.value =
        await homeController.getFirstSysDoc(sysDocId: header.sysdocid!);
    sysDoc.value.headerImage = header.headerImage;
    sysDoc.value.footerImage = header.footerImage;
    isError.value = header.isError == 1 ? true : false;
    error.value = header.error ?? '';
    sysDocIdController.value.text = '${sysDoc.value.sysDocID}';
    voucherIdController.value.text = voucherNumber.value;
    total.value = header.total ?? 0.0;
    totalTax.value = header.taxAmount ?? 0.0;
    discount.value = header.discount ?? 0.0;
    subTotal.value = (total.value - totalTax.value + discount.value);
    discountPercentage.value = DiscountHelper.calculateDiscount(
        discountAmount: header.discount ?? 0.0,
        totalAmount: subTotal.value,
        isPercent: false);
    customer.value = CustomerModel(
        customerName: header.customerName,
        customerID: header.customerId,
        address1: header.address,
        parentCustomerID: parentCustomerId,
        phone1: header.phone,
        taxIDNumber: taxNumber,
        taxGroupID: header.taxGroupId);
    creditToggle.value = header.paymentType == 5 ? true : false;
    returnToggle.value = header.isReturn == 0 ? false : true;
    referenceNoController.value.text = header.reference ?? "";
    isUpdating.value = true;

    selectedPaymentMethod.value = paymentMethodList.firstWhere(
        (element) => element.paymentMethodID == header.paymentMethodID);
    update();
    for (var item in salesInvoiceLocalController.salesInvoiceDetail) {
      //if (productUnitList.isEmpty) {
      await getProductList();
      //  }
      double price = double.parse("${item.unitPrice ?? 0}");
      var xx = salesInvoiceLocalController.salesInvoiceTaxDetail
          .where((x) => x.orderIndex == item.rowIndex && x.rowIndex != -1)
          .toList();
      List<TaxGroupDetail> taxlist = [];
      if (salesInvoiceLocalController.salesInvoiceTaxDetail.isNotEmpty) {
        log(salesInvoiceLocalController.salesInvoiceTaxDetail.toString(),
            name: '');

        for (var tax in xx) {
          taxlist.add(TaxGroupDetail(
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
            calculationMethod: tax.calculationMethod,
            currencyId: tax.currencyId,
            orderIndex: tax.orderIndex ?? 0,
            rowIndex: tax.rowIndex,
            taxAmount: header.isReturn == 1
                ? (-1 * tax.taxAmount).toDouble()
                : tax.taxAmount?.toDouble() ?? 0.0,
            taxExcludeDiscount: tax.taxExcludeDiscount?.toDouble() ?? 0.0,
            taxGroupId: tax.taxGroupId,
            items: tax.items,
            taxCode: tax.taxCode,
            taxRate: tax.taxRate?.toDouble() ?? 0.0,
          ));
        }
      }
      List<UnitModel> unitList = [UnitModel(code: item.unitId)];
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: header.isReturn == 1 ? (-1 * item.amount) : item.amount,
          description: item.description,
          itemType: 0,
          quantity: item.onHand,
          taxAmount:
              header.isReturn == 1 ? (-1 * item.taxAmount) : item.taxAmount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowIndex,
          taxGroupId: item.taxGroupId,
          taxOption: item.taxOption.toString(),
          unitId: item.unitId,
          unitPrice: item.unitPrice,
          availableQty: item.onHand,
        )
      ];
      List<VanSaleProductLotDetail> lot = [];
      if (salesInvoiceLocalController.salesInvoiceLotDetail.isNotEmpty) {
        for (var lots in salesInvoiceLocalController.salesInvoiceLotDetail) {
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
            unitid: lots.unitid,
            sourceLotNumber: lots.sourceLotNumber ?? '',
            voucherId: voucherIdController.value.text,
            sysDocId: sysDocIdController.value.text,
          ));
        }
      }
      // await productListController.updateProductListWithStock(
      //   productId: item.productId ?? '',
      //   quantity: ProductQuantityCombo(
      //       initialQuantity: item.quantity.toDouble(),
      //       finalQuantity: 0.0),
      //   isReturn: header.isReturn == 1 ? true : false,
      //   isDamage: item.isDamaged == 1 ? true : false,
      // );
      selectedItems.add(VanSaleDetailModel(
          quantity: header.isReturn == 1 ? (-1 * item.quantity) : item.quantity,
          initialQuantity:
              header.isReturn == 1 ? (-1 * item.quantity) : item.quantity,
          price: item.unitPrice,
          amount: header.isReturn == 1 ? (-1 * item.amount) : item.amount,
          unitTax:
              header.isReturn == 1 ? (-1 * item.taxAmount) : item.taxAmount,
          updatedUnit: UnitModel(code: item.unitId),
          unitList: unitList,
          taxGroupDetail: taxlist,
          vanSaleDetails: detail,
          isDamaged: item.isDamaged,
          customerProductId: item.customerProductId,
          isEdited: false,
          isTrackLot:
              salesInvoiceLocalController.salesInvoiceLotDetail.isEmpty ? 0 : 1,
          vanSaleProductLotDetails: lot));
      update();
    }
  }

  printSalesReport(String voucherID) async {
    int templateIndex = UserSimplePreferences.getPrintTemplate() ?? 1;
    SalesInvoiceApiModel header = await salesInvoiceLocalController
        .getsalesInvoiceHeaderUsingVoucher(voucher: voucherID);

    await salesInvoiceLocalController.getsalesInvoiceDetails(
        voucher: header.voucherid ?? "");
    var customerList = (await customerControler.getCustomerList())!;
    CustomerModel customers = customerList
        .firstWhere((customer) => customer.customerID == header.customerId);

    String taxNumber = customers.taxIDNumber ?? "";
    List<VanSaleDetailModel> items = [];
    for (SalesInvoiceDetailApiModel item
        in salesInvoiceLocalController.salesInvoiceDetail) {
      List<VanSaleDetail> detail = [
        VanSaleDetail(
          productId: item.productId,
          barcode: item.barcode,
          amount: item.amount,
          description: item.description,
          itemType: 0,
          quantity: item.onHand,
          taxAmount: item.taxAmount,
          discount: 0,
          listedPrice: 0,
          locationId: "",
          productCategory: "",
          rowIndex: item.rowIndex,
          taxGroupId: item.taxGroupId,
          taxOption: item.taxOption.toString(),
          unitId: item.unitId,
          unitPrice: item.unitPrice,
          availableQty: item.onHand,
        )
      ];
      items.add(VanSaleDetailModel(
          amount: item.amount,
          isTrackLot:
              salesInvoiceLocalController.salesInvoiceLotDetail.isEmpty ? 0 : 1,
          price: item.unitPrice,
          quantity: item.quantity,
          taxGroupDetail: [],
          unitList: [],
          unitTax: item.taxAmount,
          initialQuantity: item.quantity ?? 0.0,
          isDamaged: item.isDamaged,
          isEdited: false,
          updatedUnit: UnitModel(code: item.unitId),
          customerProductId: item.customerProductId,
          vanSaleDetails: detail,
          vanSaleProductLotDetails: []));
    }
    var subTotal = (header.total ?? 0.0) -
        (header.taxAmount ?? 0.0) +
        (header.discount ?? 0.0);
    PrintHelper helper = PrintHelper(
        items: items,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.now(),
        ),
        isReturn: header.isReturn == 1 ? true : false,
        invoiceNo: header.voucherid,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        customer: header.customerName,
        address: header.address,
        phone: header.phone,
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        customerTrn: taxNumber,
        paymentMode: header.paymentMethodID,
        tax: header.taxAmount?.toStringAsFixed(2),
        total: header.total?.toStringAsFixed(2),
        subTotal: subTotal.toStringAsFixed(2),
        discount: header.discount?.toStringAsFixed(2),
        // Modification for Spring onion

        // tax: header.isReturn == 1
        //     ? (-1 * (header.taxAmount!)).toStringAsFixed(2)
        //     : header.taxAmount!.toStringAsFixed(2),
        // total: header.isReturn == 1
        //     ? (-1 * (header.total!)).toStringAsFixed(2)
        //     : header.total!.toStringAsFixed(2),
        // subTotal: header.isReturn == 1
        //     ? (-1 * (subTotal)).toStringAsFixed(2)
        //     : subTotal.toStringAsFixed(2),
        // discount: header.isReturn == 1
        //     ? (-1 * (header.discount!)).toStringAsFixed(2)
        //     : header.discount!.toStringAsFixed(2),
        headerImage: header.headerImage,
        footerImage: header.footerImage,
        companyName: UserSimplePreferences.getCompanyName() ?? '',
        refNo: header.reference,
        isMultiPrint: true,
        parentCustomer:
            await DBHelper().getParentCustomerName(header.customerId ?? ''),
        amountInWords: PrintHelper.convertAmountToWords(header.total ?? 0.0));
    // Modification for Spring onion

    // amountInWords: PrintHelper.convertAmountToWords(
    //   header.isReturn == 1 ? (-1 * (header.total!)) : header.total!,
    // ));
    this.helper.value = helper;
    // Mpdification for Spring onion
    int printPreference = UserSimplePreferences.getPrintPreference() ?? 1;
    if (printPreference == 2) {
      await Get.to(() => InvoicePreviewScreen(
            helper,
            PreviewTemplate.values
                .firstWhere((element) => element.value == templateIndex),
          ));
    }
  }

  printInvoice(BuildContext context, {required String paymentMethod}) async {
    int templateIndex = UserSimplePreferences.getPrintTemplate() ?? 1;
    // dev.log(selectedPaymentMethod.value.displayName.toString(),
    // name: 'Selected paument type');
    List<VanSaleDetailModel> items = [];
    for (var item in selectedItems) {
      items.add(VanSaleDetailModel(
          amount: item.amount,
          isTrackLot: item.isTrackLot,
          price: item.price,
          quantity: item.quantity,
          taxGroupDetail: item.taxGroupDetail,
          unitList: item.unitList,
          unitTax: item.unitTax,
          updatedUnit: item.updatedUnit,
          vanSaleDetails: item.vanSaleDetails,
          vanSaleProductLotDetails: item.vanSaleProductLotDetails));
    }
    PrintHelper helper = PrintHelper(
        items: items,
        transactionDate: DateFormatter.invoiceDateFormat.format(
          DateTime.now(),
        ),
        isReturn: returnToggle.value,
        invoiceNo: voucherIdController.value.text,
        salesPerson: UserSimplePreferences.getSalesPersonID() ?? '',
        vanName: UserSimplePreferences.getVanName() ?? '',
        customer: customer.value.customerName,
        address: customer.value.address1,
        phone: customer.value.phone1,
        trn: UserSimplePreferences.getCompanyTRN() ?? '',
        customerTrn: customer.value.taxIDNumber,
        paymentMode: paymentMethod,
        tax: totalTax.value.toStringAsFixed(2),
        total: total.value.toStringAsFixed(2),
        subTotal: subTotal.value.toStringAsFixed(2),
        discount: discount.value.toStringAsFixed(2),
        headerImage: sysDoc.value.headerImage,
        footerImage: sysDoc.value.footerImage,
        companyName: UserSimplePreferences.getCompanyName() ?? '',
        refNo: referenceNoController.value.text,
        amountInWords: PrintHelper.convertAmountToWords(total.value));
    this.helper.value = helper;
    // Get.to(() => ThermalPrintingScreen(
    //       PrintHelper(
    //           items: items,
    //           transactionDate: DateFormatter.invoiceDateFormat.format(
    //             DateTime.now(),
    //           ),
    //           invoiceNo: voucherIdController.value.text,
    //           salesPerson: 'Sales person',
    //           vanName: 'Alqouz',
    //           customer: customer.value.customerName,
    //           address: customer.value.address1,
    //           phone: customer.value.phone1,
    //           paymentMode: selectedPaymentMethod.value.displayName,
    //           tax: totalTax.value.toString(),
    //           total: total.value.toString(),
    //           subTotal: subTotal.value.toString(),
    //           discount: discount.value.toString(),
    //           headerImage: sysDoc.value.headerImage,
    //           footerImage: sysDoc.value.footerImage,
    //           amountInWords: PrintHelper.convertAmountToWords(total.value)),
    //     ));

    // await Get.to(() => InvoicePreviewScreen(
    //       PrintHelper(
    //           items: selectedItems,
    //           transactionDate: DateFormatter.invoiceDateFormat.format(
    //             DateTime.now(),
    //           ),
    //           invoiceNo: voucherIdController.value.text,
    //           salesPerson: 'Sales person',
    //           vanName: 'Alqouz',
    //           customer: customer.value.customerName,
    //           address: customer.value.address1,
    //           phone: customer.value.phone1,
    //           paymentMode: selectedPaymentMethod.value.displayName,
    //           tax: totalTax.value.toString(),
    //           total: total.value.toString(),
    //           subTotal: subTotal.value.toString(),
    //           discount: discount.value.toString(),
    //           headerImage: sysDoc.value.headerImage,
    //           footerImage: sysDoc.value.footerImage,
    //           amountInWords: PrintHelper.convertAmountToWords(total.value)),
    //       PreviewTemplate.values
    //           .firstWhere((element) => element.value == templateIndex),
    //     ));
  }

  // Print Start --------------------------------??//

  var availableBluetoothDevices = [].obs;

  // Print End ------------??//
}

class ProductQuantityCombo {
  double initialQuantity;
  double finalQuantity;

  ProductQuantityCombo(
      {required this.initialQuantity, required this.finalQuantity});
}
