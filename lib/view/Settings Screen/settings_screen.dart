import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:axoproject/controller/app%20controls/settings_controller.dart';
import 'package:axoproject/services/enums.dart';
import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final settingsController = Get.put(SettingsScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text(
              'Print Settings',
              style: TextStyle(
                  color: AppColors.mutedColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Connection :',
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                const Spacer(),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField2(
                      isDense: true,
                      value: ConnectionOptions
                          .values[settingsController.printConnection.value],
                      alignment: Alignment.centerLeft,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        isCollapsed: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: mutedColor, width: 0.1),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 15,
                      ),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: ConnectionOptions.values
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: AutoSizeText(
                                item.name,
                                minFontSize: 10,
                                maxFontSize: 14,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: mutedColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        UserSimplePreferences.setPrintPaperSize(
                            ConnectionOptions.values.indexOf(value!));
                        settingsController.printConnection.value =
                            ConnectionOptions.values.indexOf(value);
                      },
                      onSaved: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Paper Size :',
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                const Spacer(),
                Expanded(
                  child: Obx(() => DropdownButtonFormField2(
                        isDense: true,
                        value: PaperOptions
                            .values[settingsController.printPaper.value],
                        alignment: Alignment.centerLeft,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: mutedColor, width: 0.1),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: PaperOptions.values
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: AutoSizeText(
                                  item.name,
                                  minFontSize: 10,
                                  maxFontSize: 14,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: mutedColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Rubik',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          UserSimplePreferences.setPrintPaperSize(value!.value);
                          settingsController.printPaper.value =
                              PaperOptions.values.indexOf(value);
                        },
                        onSaved: (value) {},
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Print preference :',
                    style: TextStyle(
                        color: AppColors.mutedColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                // const Spacer(),
                Expanded(
                  child: Obx(() => DropdownButtonFormField2(
                        isDense: true,
                        value: PrintPreference
                            .values[settingsController.printPreference.value],
                        alignment: Alignment.centerLeft,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isCollapsed: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: mutedColor, width: 0.1),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: PrintPreference.values
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: AutoSizeText(
                                  item.name,
                                  minFontSize: 10,
                                  maxFontSize: 14,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: mutedColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Rubik',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          UserSimplePreferences.setPrintPreference(
                              value!.value);
                          settingsController.printPreference.value =
                              PrintPreference.values.indexOf(value);
                        },
                        onSaved: (value) {},
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  'Print Count :',
                  style: TextStyle(
                      color: AppColors.mutedColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          settingsController.decrementCount();
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 15,
                          child: const Center(child: Icon(Icons.remove)),
                        ),
                      ),
                      Flexible(
                          child: Obx(() => Text(
                              '${settingsController.printCount.value}'
                                  .toString()))),
                      InkWell(
                        onTap: () {
                          settingsController.incrementCount();
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 15,
                          child: const Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
