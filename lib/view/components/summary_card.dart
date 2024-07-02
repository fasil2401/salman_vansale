import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({
    required this.onTap,
    required this.onSave,
    required this.onClear,
    required this.isLoading,
    this.onCreditToggle,
    this.onReturnToggle,
    required this.subTotal,
    this.creditToggle,
    this.returnToggle,
    required this.tax,
    required this.total,
    required this.discount,
    this.isSalesInvoice = false,
    this.isDiscount = true,
    this.onSync,
    this.isSyncAvailable = false,
    // required this.onVoid,
    required this.isSaveActive,
    // required this.isVoidActive,
    Key? key,
  }) : super(key: key);

  Function() onTap;
  Function() onSave;
  Function() onClear;
  Function()? onSync;
  Function(dynamic)? onCreditToggle;
  Function(dynamic)? onReturnToggle;
  bool isLoading;
  bool isSalesInvoice;
  bool? creditToggle;
  bool? returnToggle;
  bool? isSyncAvailable;
  bool? isDiscount;
  String subTotal;
  String discount;
  String tax;
  String total;
  bool isSaveActive;
  // bool isVoidActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (isSalesInvoice)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Credit :',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              activeColor: Theme.of(context).primaryColor,
                              value: creditToggle!,
                              onChanged: onCreditToggle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Return :',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.6,
                            child: CupertinoSwitch(
                              activeColor: Theme.of(context).primaryColor,
                              value: returnToggle!,
                              onChanged: onReturnToggle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildDetailTextHead('Sub Total'),
                      const SizedBox(
                        height: 8,
                      ),
                      if (isDiscount == true) _buildDetailTextHead('Discount'),
                      if (isDiscount == true)
                        const SizedBox(
                          height: 8,
                        ),
                      _buildDetailTextHead('Tax'),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildDetailTextHead('Total'),
                    ],
                  )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildDetailTextContent(
                          subTotal,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (isDiscount == true)
                          _buildDetailTextContent(
                            discount,
                          ),
                        if (isDiscount == true)
                          const SizedBox(
                            height: 8,
                          ),
                        _buildDetailTextContent(
                          tax,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildDetailTextContent(
                          total,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 1,
                color: AppColors.lightGrey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: onClear,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mutedBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // isVoidEnable == true
                  // ? Flexible(
                  //     child: ElevatedButton(
                  //       onPressed:isVoidActive
                  //             ? onVoid : (){},
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: isVoidActive
                  //             ? AppColors.primary
                  //             : AppColors.mutedColor,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       child: Padding(
                  //           padding:
                  //               const EdgeInsets.symmetric(horizontal: 10),
                  //           child: isDeleting
                  //               ? SizedBox(
                  //                   width: 20,
                  //                   height: 20,
                  //                   child: CircularProgressIndicator(
                  //                     strokeWidth: 2,
                  //                     color: Colors.white,
                  //                   ))
                  //               : Text(
                  //                   'Void',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 14,
                  //                   ),
                  //                 )),
                  //     ),
                  //   )
                  //     : Container(),
                  Visibility(
                    visible: isSyncAvailable!,
                    child: Flexible(
                      child: ElevatedButton(
                        onPressed: onSync,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Sync',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: isSaveActive ? onSave : () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSaveActive
                            ? AppColors.primary
                            : AppColors.mutedColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ))
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildDetailTextContent(String text) {
    return Text(
      ' $text',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.primary,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Row _buildDetailTextHead(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
