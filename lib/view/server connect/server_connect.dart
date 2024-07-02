import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/connection%20controller/connection_setting_controller.dart';
import 'package:axoproject/model/Local%20DB%20model/connection_setting_model.dart';
import 'package:axoproject/model/connection_qr_model.dart';
import 'package:axoproject/services/date_formatter.dart';
import 'package:axoproject/utils/Encryption/encryptor.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/package_info/package_info.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/components/border_radius.dart';
import 'package:axoproject/view/components/paddings.dart';
import 'package:axoproject/view/components/placeholder_style.dart';
import 'package:axoproject/view/server%20connect/components/qr_scanner.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode;
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:share_plus/share_plus.dart';

class ServerConnectScreen extends StatefulWidget {
  ServerConnectScreen({Key? key, this.jsonData = '', this.connectionModel})
      : super(key: key);
  ConnectionModel? connectionModel;
  final String? jsonData;

  @override
  State<ServerConnectScreen> createState() => _ServerConnectScreenState();
}

class _ServerConnectScreenState extends State<ServerConnectScreen> {
  final loginController = Get.put(LoginController());
  final connectionSettingController = Get.put(ConnectionSettingController());

  Map<String, dynamic> packageInfo = {};

  @override
  void initState() {
    super.initState();
    getLocalSettings();
    prefilData();
    init();
  }

  var settingsList = <ConnectionModel>[];
  fillDataOnScan() async {
    var jsonData = connectionQrModelFromJson(widget.jsonData!);
    var connectionName = EncryptData.decryptAES(jsonData.connectionName);
    var serverIp = EncryptData.decryptAES(jsonData.serverIp);
    var serverPort = EncryptData.decryptAES(jsonData.port);
    var database = EncryptData.decryptAES(jsonData.databaseName);

    setState(() {
      _connectiionNameController.text = connectionName;
      _ipController.text = serverIp;
      _portController.text = serverPort;
      _dbController.text = database;
    });
    await connectionSettingController
        .setConnectionName(_connectiionNameController.text);
    await connectionSettingController.setServerIp(_ipController.text);
    await connectionSettingController.setPort(_portController.text);
    await connectionSettingController.setDatabase(_dbController.text);
  }

  prefilData() async {
    if (widget.jsonData != '') {
      fillDataOnScan();
    } else if (widget.connectionModel != null) {
      setState(() {
        _connectiionNameController.text =
            widget.connectionModel!.connectionName ?? '';
        _ipController.text = widget.connectionModel!.serverIp ?? '';
        _portController.text = widget.connectionModel!.port ?? '';
        _dbController.text = widget.connectionModel!.databaseName ?? '';
      });
    } else {
      String connectionName =
          await UserSimplePreferences.getConnectionName() ?? '';
      String serverIp = await UserSimplePreferences.getServerIp() ?? '';
      String port = await UserSimplePreferences.getPort() ?? '';
      String databaseName = await UserSimplePreferences.getDatabase() ?? '';
      setState(() {
        _connectiionNameController.text = connectionName;
        _ipController.text = serverIp;
        _portController.text = port;
        _dbController.text = databaseName;
      });
    }
  }

  getLocalSettings() async {
    await connectionSettingController.getLocalSettings();
    List<dynamic> settings = connectionSettingController.connectionSettings;
    settings.forEach((element) {
      setState(() {
        settingsList.add(element);
      });
    });

    // print(settings);
  }

  final qrKey = GlobalKey();

  void takeScreenShot() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      log("mmmm");
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();

        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${dateFormat.format(DateTime.now()).toString()}axolonInventory.png',
        );
        imgFile.writeAsBytes(pngBytes);

        GallerySaver.saveImage(imgFile.path).then((success) async {
          //In here you can show snackbar or do something in the backend at successfull download
          Share.shareXFiles([XFile('${imgFile.path}')]);
          // Get.snackbar(
          //   'QR Code',
          //   'QR Code saved to gallery as ${dateFormat.format(DateTime.now()).toString()}axolonInventory.png',
          //   duration: Duration(seconds: 2),
          // );
        });
      }
    }
  }

  Future init() async {
    final packageInfo = await PackageInfoApi.getInfo();

    final newPackageInfo = {
      ...packageInfo,
    };

    if (!mounted) return;

    setState(() => this.packageInfo = newPackageInfo);
    // versionControl.updateVersion(packageInfo['version']);
  }

  String serverIp = '';
  String port = '';
  String database = '';
  String connectionName = '';
  TextEditingController _connectiionNameController = TextEditingController();
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _dbController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              commonBlueColor,
              secondary,
              // commonBlueColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          children: [
            /// Login & Welcome back
            Container(
              height: height * 0.2,
              padding: const EdgeInsets.only(left: 10, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  /// LOGIN TEXT
                  Text('Connection',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 3.5),

                  /// WELCOME
                  Text('Set your connection settings',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.03),

                                Center(
                                  child: SizedBox(
                                    width: width * 0.35,
                                    child: Image.asset(
                                        'assets/images/axolon_logo.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                // SizedBox(height: height * 0.035),

                                /// Text Fields
                                Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 30),
                                      child: Obx(
                                        () => RepaintBoundary(
                                          key: qrKey,
                                          child: barcode.BarcodeWidget(
                                            backgroundColor: Colors.white,
                                            barcode: barcode.Barcode.qrCode(),
                                            data: connectionSettingController
                                                .qrData.value,
                                            width: width * 0.3,
                                            height: width * 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 20),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      // height: height * 0.5,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                blurRadius: 20,
                                                spreadRadius: 10,
                                                offset: const Offset(0, 10)),
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Visibility(
                                            visible: settingsList.isNotEmpty,
                                            child: DropdownButtonFormField2(
                                              isDense: true,
                                              dropdownFullScreen: true,
                                              // value: settingsList[0],

                                              style: TextStyle(
                                                color: commonBlueColor,
                                                fontSize: 18,
                                              ),
                                              decoration: InputDecoration(
                                                isCollapsed: true,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                              ),
                                              hint: const Text(
                                                'Select Company',
                                                style: TextStyle(
                                                  color: commonBlueColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              isExpanded: true,
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: commonBlueColor,
                                              ),
                                              iconSize: 20,
                                              // buttonHeight: 37,
                                              buttonPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              items: settingsList
                                                  .map(
                                                    (item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(
                                                        item.connectionName!,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) async {
                                                var settings =
                                                    value as ConnectionModel;
                                                selectSettings(settings);
                                              },
                                              onSaved: (value) {},
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          Stack(
                                            children: [
                                              buildTextField(
                                                textInputType:
                                                    TextInputType.text,
                                                controller:
                                                    _connectiionNameController,
                                                label: 'Connection Name',
                                                onChanged: (connectionName) {
                                                  setState(() =>
                                                      this.connectionName =
                                                          connectionName);
                                                  connectionSettingController
                                                      .getConnectionName(
                                                          connectionName);
                                                  connectionSettingController
                                                      .setConnectionName(
                                                          connectionName);
                                                },
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10, top: 10),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => QRScanner());
                                                  },
                                                  child: const Icon(
                                                    Icons.qr_code_rounded,
                                                    color: commonBlueColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black54,
                                            height: 1,
                                          ),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .nameWarning.value,
                                                text:
                                                    'Enter the connection name or scan the QR code'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _ipController,
                                            label: 'Server IP',
                                            onChanged: (serverIp) {
                                              setState(() =>
                                                  this.serverIp = serverIp);
                                              connectionSettingController
                                                  .getServerIp(serverIp);
                                              connectionSettingController
                                                  .setServerIp(serverIp);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .ipWarning.value,
                                                text: 'Enter the server IP'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _portController,
                                            label: 'Port',
                                            onChanged: (port) {
                                              setState(() => this.port = port);
                                              connectionSettingController
                                                  .getPort(port);
                                              connectionSettingController
                                                  .setPort(port);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .portWarning.value,
                                                text:
                                                    'Enter the  service port ex:- 0000'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          buildTextField(
                                            textInputType: TextInputType.text,
                                            controller: _dbController,
                                            label: 'Database Name',
                                            onChanged: (database) {
                                              setState(() =>
                                                  this.database = database);
                                              connectionSettingController
                                                  .getDatabaseName(database);
                                              connectionSettingController
                                                  .setDatabase(database);
                                            },
                                          ),
                                          Divider(
                                              color: Colors.black54, height: 1),
                                          Obx(
                                            () => _buildWarning(
                                                isVisible:
                                                    connectionSettingController
                                                        .databaseNameWarning
                                                        .value,
                                                text:
                                                    'Enter the database name'),
                                          ),
                                          SizedBox(height: height * 0.01),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          height: 40,
                                          // width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: buildElevatedButtonCancel(
                                              text: 'Cancel',
                                              onPressed: () {
                                                // Get.back();
                                                // Get.offAll(() =>
                                                //     ConnectionScreen());
                                                getLocalSettings();
                                              },
                                              color: mutedBlueColor,
                                              textColor: commonBlueColor)),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        height: 40,
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: buildElevatedButton(
                                            text: 'Continue',
                                            onPressed: () async {
                                              await connectionSettingController
                                                  .validateForm(
                                                connectionName:
                                                    _connectiionNameController
                                                        .text,
                                                serverIp: _ipController.text,
                                                port: _portController.text,
                                                databaseName:
                                                    _dbController.text,
                                              );
                                              log("${_connectiionNameController.text}");
                                              await UserSimplePreferences
                                                  .setConnectionName(
                                                      _connectiionNameController
                                                          .text);
                                              await UserSimplePreferences
                                                  .setServerIp(
                                                      _ipController.text);
                                              await UserSimplePreferences
                                                  .setPort(
                                                      _portController.text);
                                              await UserSimplePreferences
                                                  .setDatabase(
                                                      _dbController.text);
                                              await UserSimplePreferences
                                                  .setConnection('true');
                                              log("${_connectiionNameController.text}");
                                              loginController.setConnectionName(
                                                  _connectiionNameController
                                                      .text);
                                              loginController.setDatabase(
                                                  _dbController.text);
                                              loginController.setPort(
                                                  _portController.text);
                                              loginController.setServerIp(
                                                  _ipController.text);
                                              await setData();
                                              log("value${connectionSettingController.connectionName.value}");
                                              await getLocalSettings();
                                              connectionSettingController
                                                  .saveSettings(settingsList);
                                            },
                                            color: commonBlueColor,
                                            textColor: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      child: CircleAvatar(
                                        backgroundColor: commonRedColor,
                                        radius: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 18,
                                          child: Icon(
                                            Icons.delete_outline_outlined,
                                            color: commonRedColor,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        deleteConnection();
                                      },
                                    ),
                                    GFButton(
                                      onPressed: () {
                                        settingsList.clear();
                                        createNew();
                                      },
                                      text: "Add New",
                                      buttonBoxShadow: true,
                                      color: commonBlueColor,
                                      icon: Icon(
                                        Icons.add,
                                        color: commonBlueColor,
                                        size: 20,
                                      ),
                                      type: GFButtonType.outline,
                                      shape: GFButtonShape.pills,
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        backgroundColor: success,
                                        radius: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 18,
                                          child: Icon(
                                            Icons.share_outlined,
                                            color: success,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        // await assignControllers();
                                        await setData();
                                        takeScreenShot();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AutoSizeText(
                                          'version : ${UserSimplePreferences.getVersion() ?? ''}',
                                          minFontSize: 12,
                                          maxFontSize: 16,
                                          style: TextStyle(
                                            color: mutedColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        AutoSizeText(
                                          'License : Evaluation',
                                          minFontSize: 12,
                                          maxFontSize: 16,
                                          style: TextStyle(
                                            color: mutedColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //  SafeArea(
      //   child: Stack(
      //     children: [
      // Obx(() => Container(
      //       height: 200,
      //       child: RepaintBoundary(
      //         key: qrKey,
      //         child: SfBarcodeGenerator(
      //           barColor: Theme.of(context).primaryColor,
      //           backgroundColor: Colors.white,
      //           value: connectionSettingController.qrCode.value,
      //           symbology: QRCode(),
      //           // showValue: true,
      //         ),
      //       ),
      //     )),
      //       Container(
      //         color: Colors.white,
      //         height: height,
      //         width: width,
      //         child: Padding(
      //           // padding: commonHorizontalPadding,
      //           padding: const EdgeInsets.symmetric(horizontal: 10),
      //           child: SingleChildScrollView(
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 SizedBox(
      //                   height: height * 0.13,
      //                 ),
      //                 SizedBox(
      //                   width: 600,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         width: width < 450 ? width * 0.5 : 250,
      //                         child: Image.asset('assets/images/axolon_logo.png',
      //                             fit: BoxFit.contain),
      //                       ),
      //                       SizedBox(
      //                         height: height * 0.05,
      //                       ),
      //                       Visibility(
      //                         visible: settingsList.isNotEmpty,
      //                         child: DropdownButtonFormField2(
      //                           isDense: true,
      //                           dropdownFullScreen: true,
      //                           // value: settingsList[0],

      //                           style: TextStyle(
      //                             color: Colors.black,
      //                             fontSize: 18,
      //                           ),
      //                           decoration: InputDecoration(
      //                             isCollapsed: true,
      //                             contentPadding:
      //                                 const EdgeInsets.symmetric(vertical: 15),
      //                           ),
      //                           hint: const Text(
      //                             'Select Company',
      //                             style: TextStyle(
      //                               color: commonBlueColor,
      //                               fontSize: 16,
      //                             ),
      //                           ),
      //                           isExpanded: true,
      //                           icon: const Icon(
      //                             Icons.arrow_drop_down,
      //                             color: commonBlueColor,
      //                           ),
      //                           iconSize: 20,
      //                           // buttonHeight: 37,
      //                           buttonPadding: const EdgeInsets.symmetric(
      //                             horizontal: 10,
      //                           ),
      //                           dropdownDecoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(15),
      //                           ),
      //                           items: settingsList
      //                               .map(
      //                                 (item) => DropdownMenuItem(
      //                                   value: item,
      //                                   child: Text(
      //                                     item.connectionName!,
      //                                     style: const TextStyle(
      //                                       fontSize: 16,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               )
      //                               .toList(),
      //                           onChanged: (value) async {
      //                             var settings = value as ConnectionModel;
      //                             selectSettings(settings);
      //                           },
      //                           onSaved: (value) {},
      //                         ),
      //                       ),
      //                       _buildTextField(
      //                         controller: _connectiionNameController,
      //                         type: TextInputType.text,
      //                         hintText: 'Enter Connection Name',
      //                         onChanged: (connectionName) {
      //                           setState(
      //                               () => this.connectionName = connectionName);
      //                           connectionSettingController
      //                               .setConnectionName(connectionName);
      //                         },
      //                       ),
      //                       SizedBox(
      //                         height: height * 0.03,
      //                       ),
      //                       _buildIpTextField(),
      //                       SizedBox(
      //                         height: height * 0.03,
      //                       ),
      //                       _buildTextField(
      //                         controller: _portController,
      //                         type: TextInputType.number,
      //                         hintText: 'Enter Port',
      //                         onChanged: (port) {
      //                           setState(() => this.port = port);
      //                           connectionSettingController.setPort(port);
      //                         },
      //                       ),
      //                       SizedBox(
      //                         height: height * 0.03,
      //                       ),
      //                       _buildTextField(
      //                         controller: _dbController,
      //                         type: TextInputType.text,
      //                         hintText: 'Enter Database',
      //                         onChanged: (database) {
      //                           setState(() => this.database = database);
      //                           connectionSettingController
      //                               .setDatabase(database);
      //                         },
      //                       ),
      //                       SizedBox(
      //                         height: height * 0.03,
      //                       ),
      //                       InkWell(
      //                         onTap: () {},
      //                         child: const InkText(
      //                           title: 'Policy',
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: height * 0.03,
      //                       ),
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Expanded(
      //                             child: SizedBox(
      //                               height: 50,
      //                               child: CommonButtonWidget(
      //                                 backgroundColor:
      //                                     Theme.of(context).backgroundColor,
      //                                 textColor: Theme.of(context).primaryColor,
      //                                 title: 'Encrypt',
      //                                 onPressed: () async {
      //                                   // await assignControllers();
      //                                   takeScreenShot();
      //                                 },
      //                               ),
      //                             ),
      //                           ),
      //                           SizedBox(
      //                             width: 3.w,
      //                           ),
      //                           Expanded(
      //                             child: SizedBox(
      //                               height: 50,
      //                               // width: double.infinity,
      //                               child: CommonButtonWidget(
      //                                 backgroundColor:
      //                                     Theme.of(context).primaryColor,
      //                                 textColor: textFieldColor,
      //                                 title: 'Connect',
      // onPressed: () async {
      //   await connectionSettingController
      //       .validateForm(
      //     connectionName:
      //         _connectiionNameController.text,
      //     serverIp: _ipController.text,
      //     port: _portController.text,
      //     databaseName: _dbController.text,
      //   );
      //   log("${_connectiionNameController.text}");
      //   await UserSimplePreferences
      //       .setConnectionName(
      //           _connectiionNameController
      //               .text);
      //   await UserSimplePreferences.setServerIp(
      //       _ipController.text);
      //   await UserSimplePreferences.setPort(
      //       _portController.text);
      //   await UserSimplePreferences.setDatabase(
      //       _dbController.text);
      //   await UserSimplePreferences
      //       .setConnection('connected');
      //   log("ssss${_connectiionNameController.text}");
      //   loginController.setConnectionName(
      //       _connectiionNameController.text);
      //   loginController
      //       .setDatabase(_dbController.text);
      //   loginController
      //       .setPort(_portController.text);
      //   loginController
      //       .setServerIp(_ipController.text);
      //   log("value${connectionSettingController.connectionName.value}");
      //   connectionSettingController
      //       .saveSettings(settingsList);
      // },
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  CupertinoTextField _buildTextField({
    required String hintText,
    required TextEditingController controller,
    required TextInputType type,
    required Function(String) onChanged,
  }) {
    return CupertinoTextField(
        placeholder: hintText,
        controller: controller,
        keyboardType: type,
        decoration: BoxDecoration(
          color: textFieldColor,
          borderRadius: textFieldRadius,
        ),
        style: const TextStyle(fontSize: 16),
        placeholderStyle: placeholderStyle,
        padding: textFieldPadding,
        onChanged: onChanged);
  }

  CupertinoTextField _buildIpTextField() {
    return CupertinoTextField(
      placeholder: 'Enter Server IP',
      controller: _ipController,
      decoration: BoxDecoration(
        color: textFieldColor,
        borderRadius: textFieldRadius,
      ),
      style: const TextStyle(fontSize: 16),
      placeholderStyle: placeholderStyle,
      padding: textFieldPadding,
      onChanged: (serverIp) {
        setState(() => this.serverIp = serverIp);
        connectionSettingController.setServerIp(serverIp);
      },
      suffix: InkWell(
        onTap: () {
          Get.to(() => const QRScanner());
        },
        child: Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: SvgPicture.asset(
            'assets/icons/qr_code.svg',
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
    );
  }

  selectSettings(ConnectionModel settings) async {
    setState(() {
      _connectiionNameController.text = settings.connectionName!;
      _ipController.text = settings.serverIp!;
      _portController.text = settings.port!;
      _dbController.text = settings.databaseName!;
    });
    await UserSimplePreferences.setUsername(settings.userName ?? '');
    await UserSimplePreferences.setUserPassword(settings.password ?? '');
    await connectionSettingController
        .getConnectionName(settings.connectionName!);
    await connectionSettingController.getServerIp(settings.serverIp!);
    await connectionSettingController.getPort(settings.port!);
    await connectionSettingController.getDatabaseName(settings.databaseName!);
    print(connectionSettingController.serverIp.value);
  }

  ElevatedButton buildElevatedButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Obx(() => connectionSettingController.isLoading.value
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(text, style: TextStyle(color: textColor))),
    );
  }

  ElevatedButton buildElevatedButtonCancel({
    required String text,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // <-- Radius
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  TextField buildTextField({
    required TextEditingController controller,
    required String label,
    required Function(String value) onChanged,
    required TextInputType textInputType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: InputBorder.none,
        label: Text(
          label,
          style: TextStyle(
            color: commonBlueColor,
          ),
        ),
        isCollapsed: false,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildWarning({
    required String text,
    required bool isVisible,
  }) {
    return Visibility(
      visible: isVisible,
      child: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 10, top: 5),
        child: Text(
          text,
          style: TextStyle(
            color: commonRedColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  createNew() async {
    setState(() {
      _connectiionNameController.text = '';
      _ipController.text = '';
      _portController.text = '';
      _dbController.text = '';
    });
  }

  deleteConnection() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Are you Sure, You want to delete this?',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Wait',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await connectionSettingController
                  .deleteConnectionSettings(_connectiionNameController.text);
              await setPrefereces();
              createNew();
              Get.offAll(() => ServerConnectScreen());
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: commonRedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  setPrefereces() async {
    await UserSimplePreferences.setUsername('');
    await UserSimplePreferences.setUserPassword('');
    await UserSimplePreferences.setConnectionName('');
    await UserSimplePreferences.setServerIp('');
    await UserSimplePreferences.setPort('');
    await UserSimplePreferences.setDatabase('');
  }

  setData() async {
    // await connectionSettingController.validateForm();
    await connectionSettingController
        .getConnectionName(_connectiionNameController.text);
    await connectionSettingController.getServerIp(_ipController.text);
    await connectionSettingController.getPort(_portController.text);
    await connectionSettingController.getDatabaseName(_dbController.text);
  }
}
