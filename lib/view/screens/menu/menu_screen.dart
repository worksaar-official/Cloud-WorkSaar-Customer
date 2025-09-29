import 'package:realise/core/helper/shared_preference_helper.dart';
import 'package:realise/core/utils/local_strings.dart';
import 'package:realise/data/controller/common/theme_controller.dart';
import 'package:realise/data/controller/dashboard/dashboard_controller.dart';
import 'package:realise/view/components/app-bar/custom_appbar.dart';
import 'package:realise/view/components/bottom-sheet/custom_bottom_sheet.dart';
import 'package:realise/view/components/dialog/warning_dialog.dart';
import 'package:realise/view/components/image/custom_svg_picture.dart';
import 'package:realise/view/screens/menu/widget/language_bottom_sheet_screen.dart';
import 'package:realise/view/screens/menu/widget/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/core/route/route.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/color_resources.dart';
import 'package:realise/core/utils/images.dart';
import 'package:realise/core/utils/style.dart';
import 'package:realise/core/utils/util.dart';
import 'package:realise/data/services/api_service.dart';
import 'package:realise/view/components/divider/custom_divider.dart';
import 'package:realise/view/components/will_pop_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (theme) {
      return WillPopWidget(
        nextRoute: RouteHelper.dashboardScreen,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: LocalStrings.settings.tr,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.space10),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space15),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.space15,
                        horizontal: Dimensions.space15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.defaultRadius),
                        boxShadow: MyUtils.getCardShadow(context)),
                    child: Column(
                      children: [
                        MenuItems(
                            imageSrc: MyImages.user,
                            label: LocalStrings.profile.tr,
                            onPressed: () =>
                                Get.toNamed(RouteHelper.profileScreen)),
                        const CustomDivider(space: Dimensions.space10),
                        MenuItems(
                          imageSrc: MyImages.language,
                          label: LocalStrings.language.tr,
                          onPressed: () {
                            final apiClient = Get.put(
                                ApiClient(sharedPreferences: Get.find()));
                            SharedPreferences pref =
                                apiClient.sharedPreferences;
                            String language = pref.getString(
                                    SharedPreferenceHelper.languageListKey) ??
                                '';
                            String countryCode = pref.getString(
                                    SharedPreferenceHelper.countryCode) ??
                                'US';
                            String languageCode = pref.getString(
                                    SharedPreferenceHelper.languageCode) ??
                                'en';
                            Locale local = Locale(languageCode, countryCode);
                            CustomBottomSheet(
                                    child: LanguageBottomSheetScreen(
                                        languageList: language,
                                        selectedLocal: local))
                                .customBottomSheet(context);
                          },
                        ),
                        const CustomDivider(space: Dimensions.space10),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space10),
                          title: Text(
                            LocalStrings.darkmode.tr,
                            style: regularLarge.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color),
                          ),
                          secondary: Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            child: CustomSvgPicture(
                                image: MyImages.night,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!,
                                height: 17.5,
                                width: 17.5),
                          ),
                          activeColor: ColorResources.colorBlack,
                          activeTrackColor:
                              Theme.of(context).textTheme.bodyMedium!.color,
                          value: theme.darkTheme,
                          onChanged: (bool val) {
                            theme.changeTheme();
                            ThemeController themeController = Get.put(
                                ThemeController(sharedPreferences: Get.find()));
                            MyUtils.allScreensUtils(themeController.darkTheme);
                          },
                        ),
                        const CustomDivider(space: Dimensions.space10),
                        MenuItems(
                            imageSrc: MyImages.policy,
                            label: LocalStrings.privacyPolicy.tr,
                            onPressed: () {
                              Get.toNamed(RouteHelper.privacyScreen);
                            }),
                        const CustomDivider(space: Dimensions.space10),
                        Get.find<DashboardController>().logoutLoading
                            ? const Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: ColorResources.primaryColor,
                                      strokeWidth: 2.00),
                                ),
                              )
                            : MenuItems(
                                imageSrc: MyImages.logout,
                                label: LocalStrings.logout.tr,
                                onPressed: () {
                                  const WarningAlertDialog().warningAlertDialog(
                                      context, () {
                                    Get.back();
                                    Get.find<DashboardController>().logout();
                                  },
                                      title: LocalStrings.logoutTitle.tr,
                                      subTitle:
                                          LocalStrings.logoutSureWarningMSg.tr);
                                }),
                      ],
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
