import 'package:cached_network_image/cached_network_image.dart';
import 'package:realise/core/utils/images.dart';
import 'package:realise/core/utils/local_strings.dart';
import 'package:realise/core/utils/url_container.dart';
import 'package:realise/data/controller/auth/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/style.dart';
import 'package:realise/data/repo/auth/forgot_password_repo.dart';
import 'package:realise/data/services/api_service.dart';
import 'package:realise/view/components/buttons/rounded_button.dart';
import 'package:realise/view/components/buttons/rounded_loading_button.dart';
import 'package:realise/view/components/text-form-field/custom_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ForgotPasswordRepo(apiClient: Get.find()));
    Get.put(ForgetPasswordController(forgotPasswordRepo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ForgetPasswordController>().initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GetBuilder<ForgetPasswordController>(
            builder: (controller) => SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
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
                                horizontal: 10.0, vertical: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocalStrings.forgotPasswordTitle.tr,
                                  style: mediumOverLarge.copyWith(
                                      fontSize: Dimensions.fontMegaLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  LocalStrings.forgotPasswordDesc.tr,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 25.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                      animatedLabel: true,
                                      needOutlineBorder: true,
                                      labelText: LocalStrings.emailAddress.tr,
                                      hintText:
                                          LocalStrings.emailAddressHint.tr,
                                      textInputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.done,
                                      controller: controller.emailController,
                                      onSuffixTap: () {},
                                      onChanged: (value) {
                                        return;
                                      },
                                      validator: (value) {
                                        if (controller
                                            .emailController.text.isEmpty) {
                                          return LocalStrings.enterEmail.tr;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  const SizedBox(height: Dimensions.space25),
                                  controller.submitLoading
                                      ? const RoundedLoadingBtn()
                                      : RoundedButton(
                                          press: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              controller.submitForgetPassword();
                                            }
                                          },
                                          text: LocalStrings.submit.tr,
                                        ),
                                  const SizedBox(height: Dimensions.space40)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0, //No shadow
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
