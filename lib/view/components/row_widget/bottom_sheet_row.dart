import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/color_resources.dart';
import 'package:realise/core/utils/style.dart';

class BottomSheetRow extends StatelessWidget {
  final String header;
  final String body;
  final String? currencySymbol;
  final bool showSymbol;
  final Color curBgColor;

  const BottomSheetRow(
      {super.key,
      required this.header,
      required this.body,
      this.showSymbol = false,
      this.curBgColor = ColorResources.primaryColor,
      this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return showSymbol
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: curBgColor, shape: BoxShape.circle),
                    child: Text(currencySymbol!,
                        textAlign: TextAlign.center,
                        style: regularDefault.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color)),
                  ),
                  const SizedBox(width: Dimensions.space10),
                  Text(
                    header.tr,
                    style: regularDefault.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.6)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(body.tr,
                  style: regularDefault.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis)
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    header.tr,
                    style: regularDefault.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.6)),
                    overflow: TextOverflow.ellipsis,
                  )),
              Expanded(
                  flex: 4,
                  child: Text(body.tr,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: regularDefault.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis))
            ],
          );
  }
}
