import 'package:cached_network_image/cached_network_image.dart';
import 'package:realise/core/helper/shared_preference_helper.dart';
import 'package:realise/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/core/route/route.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/color_resources.dart';
import 'package:realise/core/utils/images.dart';
import 'package:realise/core/utils/style.dart';
import 'package:realise/core/utils/url_container.dart';
import 'package:realise/data/controller/auth/login_controller.dart';
import 'package:realise/data/repo/auth/login_repo.dart';
import 'package:realise/data/services/api_service.dart';
import 'package:realise/view/components/buttons/rounded_button.dart';
import 'package:realise/view/components/buttons/rounded_loading_button.dart';
import 'package:realise/view/components/text-form-field/custom_text_field.dart';
import 'package:realise/view/components/text/default_text.dart';
import 'package:realise/view/components/will_pop_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LoginRepo(apiClient: Get.find()));
    Get.put(LoginController(loginRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LoginController>().initData();
      Get.find<LoginController>().remember = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: '',
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GetBuilder<LoginController>(
            builder: (controller) => SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.appBarColor,
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(MyImages.login),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 140.0, bottom: 30.0),
                          child: Center(
                            child: CachedNetworkImage(
                                imageUrl:
                                    '${UrlContainer.systemImgUrl}${controller.appLogo}',
                                height: 60,
                                fit: BoxFit.fitHeight,
                                color: Colors.white,
                                errorWidget: (ctx, object, trx) {
                                  return Image.asset(
                                    MyImages.appLogoFlat,
                                    height: 60,
                                    color: Colors.white,
                                  );
                                },
                                placeholder: (ctx, trx) {
                                  return Image.asset(
                                    MyImages.appLogo,
                                    height: 60,
                                    color: Colors.white,
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.space20,
                                vertical: Dimensions.space30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocalStrings.login.tr,
                                  style: mediumOverLarge.copyWith(
                                      fontSize: Dimensions.fontMegaLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  LocalStrings.loginDesc.tr,
                                  style: regularDefault.copyWith(
                                      fontSize: Dimensions.fontDefault,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: Dimensions.space20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  controller: controller.emailController,
                                  labelText: LocalStrings.email.tr,
                                  onChanged: (value) {},
                                  focusNode: controller.emailFocusNode,
                                  nextFocus: controller.passwordFocusNode,
                                  textInputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'fieldErrorMsg'.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: Dimensions.space20),
                                CustomTextField(
                                  animatedLabel: true,
                                  needOutlineBorder: true,
                                  labelText: LocalStrings.password.tr,
                                  controller: controller.passwordController,
                                  focusNode: controller.passwordFocusNode,
                                  onChanged: (value) {},
                                  isShowSuffixIcon: true,
                                  isPassword: true,
                                  textInputType: TextInputType.text,
                                  inputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LocalStrings.fieldErrorMsg.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: Dimensions.space20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: Checkbox(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .defaultRadius)),
                                              activeColor:
                                                  ColorResources.primaryColor,
                                              checkColor:
                                                  ColorResources.colorWhite,
                                              value: controller.remember,
                                              side: WidgetStateBorderSide
                                                  .resolveWith(
                                                (states) => BorderSide(
                                                    width: 1.0,
                                                    color: controller.remember
                                                        ? ColorResources
                                                            .getTextFieldEnableBorder()
                                                        : ColorResources
                                                            .getTextFieldDisableBorder()),
                                              ),
                                              onChanged: (value) {
                                                controller.changeRememberMe();
                                              }),
                                        ),
                                        const SizedBox(width: 8),
                                        DefaultText(
                                            text: LocalStrings.rememberMe.tr,
                                            textColor: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withOpacity(0.5))
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.clearTextField();
                                        Get.toNamed(
                                            RouteHelper.forgotPasswordScreen);
                                      },
                                      child: DefaultText(
                                          text: LocalStrings.forgotPassword.tr,
                                          textColor:
                                              ColorResources.secondaryColor),
                                    )
                                  ],
                                ),
                                const SizedBox(height: Dimensions.space20),
                                controller.isSubmitLoading
                                    ? const RoundedLoadingBtn()
                                    : RoundedButton(
                                        text: LocalStrings.signIn.tr,
                                        press: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            controller.loginUser();
                                          }
                                        }),
                                const SizedBox(height: Dimensions.space20),
                                if (controller
                                        .loginRepo.apiClient.sharedPreferences
                                        .getString(SharedPreferenceHelper
                                            .disableRegistration) !=
                                    '1')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(LocalStrings.doNotHaveAccount.tr,
                                          overflow: TextOverflow.ellipsis,
                                          style: regularLarge.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color!
                                                  .withOpacity(0.5),
                                              fontWeight: FontWeight.w400)),
                                      TextButton(
                                        onPressed: () {
                                          Get.offAndToNamed(
                                              RouteHelper.registrationScreen);
                                        },
                                        child: Text(
                                            LocalStrings.createAnAccount.tr,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: regularLarge.copyWith(
                                                color: ColorResources
                                                    .secondaryColor)),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
