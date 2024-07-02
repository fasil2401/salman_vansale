import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/Api%20Controllers/login_controller.dart';
import 'package:axoproject/controller/ui%20controls/password_controller.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/default_settings.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:axoproject/view/Payment%20Collection/payment_collection_screen.dart';
import 'package:axoproject/view/Reports/reports_screen.dart';
import 'package:axoproject/view/Sales%20Invoice%20Screen/sales_invoice_screen.dart';
import 'package:axoproject/view/server%20connect/server_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  prefilData() async {
    final bool isRemembered =
        UserSimplePreferences.getRememberPassword() ?? false;
    _userNameController.text = await UserSimplePreferences.getUsername() ?? '';
    _passwordController.text =
        isRemembered ? await UserSimplePreferences.getUserPassword() ?? '' : '';
    loginController.setUsername(_userNameController.text);
    loginController.setPassword(_passwordController.text);
  }

  final passwordController = Get.put(PasswordController());

  final loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefilData();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              commonBlueColor,
              secondary,
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
                  Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(height: 3.5),

                  /// WELCOME
                  Text('Welcome Back',
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
                    child: ListView(
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: height * 0.02),

                        Center(
                          child: SizedBox(
                            width: width * 0.35,
                            child: Image.asset('assets/images/axolon_logo.png',
                                fit: BoxFit.contain),
                          ),
                        ),
                        SizedBox(height: height * 0.05),

                        /// Text Fields
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          // height: 120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 10,
                                    offset: const Offset(0, 10)),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: height * 0.01),
                              TextField(
                                controller: _userNameController,
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  label: Text(
                                    'User Name',
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
                                onChanged: (value) {
                                  loginController.setUsername(value);
                                },
                              ),
                              Divider(color: Colors.black54, height: 1),
                              SizedBox(height: height * 0.01),

                              /// PASSWORD
                              Obx(
                                () => TextField(
                                  controller: _passwordController,
                                  obscureText: passwordController.status.value,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    label: Text(
                                      'Password',
                                      style: TextStyle(
                                        color: commonBlueColor,
                                      ),
                                    ),
                                    isCollapsed: false,
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    suffix: InkWell(
                                      onTap: () {
                                        passwordController.check();
                                      },
                                      child: Container(
                                        width: 50,
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: SvgPicture.asset(
                                            passwordController.icon.value,
                                            height: passwordController
                                                        .status.value ==
                                                    true
                                                ? 10
                                                : 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    loginController.setPassword(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            loginController.rememberPassword();
                          },
                          splashColor: lightGrey,
                          splashFactory: InkRipple.splashFactory,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: mutedColor,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Obx(() => Icon(
                                        Icons.check,
                                        size: 15,
                                        color: loginController.isRemember.value
                                            ? commonBlueColor
                                            : Colors.transparent,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                'Remember me',
                                minFontSize: 16,
                                maxFontSize: 20,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: mutedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: () async {
                                loginController.isLoading.value = true;
                                loginController.saveCredentials();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: commonBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // <-- Radius
                                ),
                              ),
                              child: loginController.isLoading.value == true
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : Text('Login',
                                      style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       Get.to(() => PaymentCollectionScreen());
                        //     },
                        //     child: Text('Payment Collection')),
                        // SizedBox(
                        //   height: 40,
                        // )
                      ],
                    ),
                  ),
                  if (!DefaultSettings.isConnectionDisabled)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Connection Settings',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, color: mutedColor),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Get.to(() => ServerConnectScreen());
                            },
                            elevation: 2,
                            backgroundColor: commonBlueColor,
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
      // SafeArea(
      //   child: Padding(
      //     // padding: commonHorizontalPadding,
      //     padding: EdgeInsets.symmetric(horizontal: 20),
      //     child: CustomScrollView(
      //       scrollDirection: Axis.vertical,
      //       slivers: [
      //         SliverFillRemaining(
      //           hasScrollBody: false,
      //           child: Column(
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: InkWell(
      //                   onTap: () {
      //                     Get.to(() => ServerConnectScreen());
      //                   },
      //                   child: Align(
      //                       alignment: Alignment.topRight,
      //                       child: FittedBox(
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                             color: Colors.white,
      //                             borderRadius: textFieldRadius,
      //                           ),
      //                           child: Padding(
      //                             padding: const EdgeInsets.symmetric(
      //                                 horizontal: 8, vertical: 10),
      //                             child: Row(
      //                               children: [
      //                                 const Text("Connection Settings",
      //                                     style: TextStyle(
      //                                       fontFamily: 'Rubik',
      //                                       fontSize: 12,
      //                                     )),
      //                                 Padding(
      //                                   padding: EdgeInsets.symmetric(
      //                                       horizontal: 2.w),
      //                                   child: SvgPicture.asset(
      //                                     'assets/icons/cloud.svg',
      //                                     color:
      //                                         Theme.of(context).highlightColor,
      //                                   ),
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                         ),
      //                       )),
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       width: 600,
      //                       decoration: BoxDecoration(
      //                         color: Colors.white,
      //                         borderRadius: commonRadius,
      //                       ),
      //                       child: Padding(
      //                         padding: EdgeInsets.symmetric(
      //                             horizontal: 20, vertical: 50),
      //                         child: Column(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           // crossAxisAlignment: CrossAxisAlignment.center,
      //                           children: [
      //                             Center(
      //                               child: SizedBox(
      //                                 width: width < 450 ? width * 0.5 : 250,
      //                                 child: Image.asset(
      //                                     'assets/images/axolon_logo.png',
      //                                     fit: BoxFit.contain),
      //                               ),
      //                             ),
      //                             SizedBox(
      //                               height: height * 0.03,
      //                             ),
      //                             // const WelcomeText(
      //                             //   title: 'Welcome back',
      //                             // ),

      //                             CupertinoTextField(
      //                               controller: _userNameController,
      //                               placeholder: 'Enter Your Username',
      //                               prefix: Padding(
      //                                 padding: const EdgeInsets.only(left: 5),
      //                                 child: SvgPicture.asset(
      //                                   'assets/icons/user.svg',
      //                                   color: Theme.of(context).highlightColor,
      //                                   height: 25,
      //                                 ),
      //                               ),
      //                               decoration: BoxDecoration(
      //                                 color: textFieldColor,
      //                                 borderRadius: textFieldRadius,
      //                               ),
      //                               style: const TextStyle(fontSize: 16),
      //                               placeholderStyle: placeholderStyle,
      //                               padding: textFieldPadding,
      //                               onChanged: (value) {
      //                                 loginController.setUsername(value);
      //                               },
      //                             ),
      //                             SizedBox(
      //                               height: height * 0.03,
      //                             ),
      //                             Obx(
      //                               () => CupertinoTextField(
      //                                 controller: _passwordController,
      //                                 placeholder: 'Enter Your Password',
      //                                 obscureText:
      //                                     passwordController.status.value,
      //                                 prefix: Padding(
      //                                   padding: const EdgeInsets.only(left: 5),
      //                                   child: SvgPicture.asset(
      //                                     'assets/icons/password.svg',
      //                                     color:
      //                                         Theme.of(context).highlightColor,
      //                                     height: 25,
      //                                   ),
      //                                 ),
      //                                 decoration: BoxDecoration(
      //                                   color: textFieldColor,
      //                                   borderRadius: textFieldRadius,
      //                                 ),
      //                                 style: TextStyle(fontSize: 16),
      //                                 placeholderStyle: placeholderStyle,
      //                                 padding: textFieldPadding,
      //                                 onChanged: (value) {
      //                                   loginController.setPassword(value);
      //                                 },
      //                                 suffix: InkWell(
      //                                   onTap: () {
      //                                     passwordController.check();
      //                                   },
      //                                   child: Padding(
      //                                     padding: EdgeInsets.only(right: 4.w),
      //                                     child: SvgPicture.asset(
      //                                       passwordController.icon.value,
      //                                       color: Theme.of(context)
      //                                           .highlightColor,
      //                                       height: passwordController
      //                                                   .status.value ==
      //                                               true
      //                                           ? 7
      //                                           : 10,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                             SizedBox(
      //                               height: height * 0.03,
      //                             ),
      //                             Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 InkWell(
      //                                   onTap: () =>
      //                                       loginController.rememberPassword(),
      //                                   splashColor: lightGrey,
      //                                   splashFactory: InkRipple.splashFactory,
      //                                   child: Row(
      //                                     mainAxisAlignment:
      //                                         MainAxisAlignment.center,
      //                                     children: [
      //                                       Container(
      //                                         width: 20,
      //                                         height: 20,
      //                                         decoration: BoxDecoration(
      //                                           shape: BoxShape.circle,
      //                                           color: Colors.white,
      //                                           border: Border.all(
      //                                             color: mutedColor,
      //                                             width: 1,
      //                                           ),
      //                                         ),
      //                                         child: Center(
      //                                           child: Obx(() => Icon(
      //                                                 Icons.check,
      //                                                 size: 15,
      //                                                 color: loginController
      //                                                         .isRemember.value
      //                                                     ? commonBlueColor
      //                                                     : Colors.transparent,
      //                                               )),
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         width: 10,
      //                                       ),
      //                                       InkText(
      //                                         title: 'Remember me',
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 InkWell(
      //                                   onTap: () {},
      //                                   child: const Align(
      //                                       alignment: Alignment.centerRight,
      //                                       child: InkText(
      //                                           title: 'Reset Password?')),
      //                                 ),
      //                               ],
      //                             ),
      //                             SizedBox(
      //                               height: height * 0.03,
      //                             ),
      //                             CommonButton(
      //                               title: 'login',
      //                               callback: 'sync',
      //                               onPressed: () async {
      //                                 bool hasInternet =
      //                                     await InternetConnectionChecker()
      //                                         .hasConnection;
      //                                 if (hasInternet) {
      //                                   loginController.saveCredentials();
      //                                 } else {
      //                                   SnackbarServices.internetSnackbar();
      //                                 }
      //                               },
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
