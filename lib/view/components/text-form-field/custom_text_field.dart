import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/color_resources.dart';
import 'package:realise/core/utils/style.dart';
import 'package:realise/view/components/text/label_text.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color? fillColor;
  final bool isRequired;

  const CustomTextField({
    super.key,
    this.labelText,
    this.readOnly = false,
    this.fillColor,
    required this.onChanged,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.validator,
    this.textInputType,
    this.isEnable = true,
    this.isPassword = false,
    this.isShowSuffixIcon = false,
    this.isIcon = false,
    this.onSuffixTap,
    this.isSearch = false,
    this.isCountryPicker = false,
    this.inputAction = TextInputAction.next,
    this.needOutlineBorder = false,
    this.needRequiredSign = false,
    this.maxLines = 1,
    this.animatedLabel = false,
    this.isRequired = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? widget.animatedLabel
            ? TextFormField(
                maxLines: widget.maxLines,
                readOnly: widget.readOnly,
                style: regularDefault.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color),
                //textAlign: TextAlign.left,
                cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
                controller: widget.controller,
                autofocus: false,
                textInputAction: widget.inputAction,
                enabled: widget.isEnable,
                focusNode: widget.focusNode,
                validator: widget.validator,
                keyboardType: widget.textInputType,
                obscureText: widget.isPassword ? obscureText : false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      top: 5, left: 15, right: 15, bottom: 5),
                  labelText: widget.labelText?.tr ?? '',
                  labelStyle: regularDefault.copyWith(
                      color: Theme.of(context).hintColor),
                  hintText: widget.hintText?.tr ?? '',
                  hintStyle: regularDefault,
                  fillColor: widget.fillColor ?? Theme.of(context).cardColor,
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.5, color: Theme.of(context).hintColor),
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.5, color: Theme.of(context).hintColor),
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.5, color: Theme.of(context).hintColor),
                      borderRadius:
                          BorderRadius.circular(Dimensions.defaultRadius)),
                  suffixIcon: widget.isShowSuffixIcon
                      ? widget.isPassword
                          ? IconButton(
                              icon: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: ColorResources.hintTextColor,
                                  size: 20),
                              onPressed: _toggle)
                          : widget.isIcon
                              ? IconButton(
                                  onPressed: widget.onSuffixTap,
                                  icon: Icon(
                                    widget.isSearch
                                        ? Icons.search_outlined
                                        : widget.isCountryPicker
                                            ? Icons.arrow_drop_down_outlined
                                            : Icons.camera_alt_outlined,
                                    size: 25,
                                    color: ColorResources.getPrimaryColor(),
                                  ),
                                )
                              : null
                      : null,
                ),
                onFieldSubmitted: (text) => widget.nextFocus != null
                    ? FocusScope.of(context).requestFocus(widget.nextFocus)
                    : null,
                onChanged: (text) => widget.onChanged!(text),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                      text: widget.labelText.toString(),
                      isRequired: widget.isRequired),
                  const SizedBox(height: Dimensions.textToTextSpace),
                  TextFormField(
                    maxLines: widget.maxLines,
                    readOnly: widget.readOnly,
                    style: regularDefault.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                    //textAlign: TextAlign.left,
                    cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
                    controller: widget.controller,
                    autofocus: false,
                    textInputAction: widget.inputAction,
                    enabled: widget.isEnable,
                    focusNode: widget.focusNode,
                    validator: widget.validator,
                    keyboardType: widget.textInputType,
                    obscureText: widget.isPassword ? obscureText : false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          top: 5, left: 15, right: 15, bottom: 5),
                      hintText:
                          widget.hintText != null ? widget.hintText!.tr : '',
                      hintStyle: regularSmall.copyWith(
                          color: ColorResources.getHintTextColor()),
                      fillColor: widget.fillColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5,
                              color:
                                  ColorResources.getTextFieldDisableBorder()),
                          borderRadius:
                              BorderRadius.circular(Dimensions.defaultRadius)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5,
                              color: ColorResources.getTextFieldEnableBorder()),
                          borderRadius:
                              BorderRadius.circular(Dimensions.defaultRadius)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5,
                              color:
                                  ColorResources.getTextFieldDisableBorder()),
                          borderRadius:
                              BorderRadius.circular(Dimensions.defaultRadius)),
                      suffixIcon: widget.isShowSuffixIcon
                          ? widget.isPassword
                              ? IconButton(
                                  icon: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: ColorResources.hintTextColor,
                                      size: 20),
                                  onPressed: _toggle)
                              : widget.isIcon
                                  ? IconButton(
                                      onPressed: widget.onSuffixTap,
                                      icon: Icon(
                                        widget.isSearch
                                            ? Icons.search_outlined
                                            : widget.isCountryPicker
                                                ? Icons.arrow_drop_down_outlined
                                                : Icons.camera_alt_outlined,
                                        size: 25,
                                        color: ColorResources.getPrimaryColor(),
                                      ),
                                    )
                                  : null
                          : null,
                    ),
                    onFieldSubmitted: (text) => widget.nextFocus != null
                        ? FocusScope.of(context).requestFocus(widget.nextFocus)
                        : null,
                    onChanged: (text) => widget.onChanged!(text),
                  )
                ],
              )
        : TextFormField(
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            style: regularDefault,
            //textAlign: TextAlign.left,
            cursorColor: ColorResources.getHintTextColor(),
            controller: widget.controller,
            autofocus: false,
            textInputAction: widget.inputAction,
            enabled: widget.isEnable,
            focusNode: widget.focusNode,
            validator: widget.validator,
            keyboardType: widget.textInputType,
            obscureText: widget.isPassword ? obscureText : false,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
              labelText: widget.labelText?.tr,
              labelStyle: regularDefault.copyWith(
                  color: ColorResources.getLabelTextColor()),
              fillColor: ColorResources.transparentColor,
              filled: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5,
                      color: ColorResources.getTextFieldDisableBorder())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5,
                      color: ColorResources.getTextFieldEnableBorder())),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5,
                      color: ColorResources.getTextFieldDisableBorder())),
              suffixIcon: widget.isShowSuffixIcon
                  ? widget.isPassword
                      ? IconButton(
                          icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ColorResources.hintTextColor,
                              size: 20),
                          onPressed: _toggle)
                      : widget.isIcon
                          ? IconButton(
                              onPressed: widget.onSuffixTap,
                              icon: Icon(
                                widget.isSearch
                                    ? Icons.search_outlined
                                    : widget.isCountryPicker
                                        ? Icons.arrow_drop_down_outlined
                                        : Icons.camera_alt_outlined,
                                size: 25,
                                color: ColorResources.getPrimaryColor(),
                              ),
                            )
                          : null
                  : null,
            ),
            onFieldSubmitted: (text) => widget.nextFocus != null
                ? FocusScope.of(context).requestFocus(widget.nextFocus)
                : null,
            onChanged: (text) => widget.onChanged!(text),
          );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
