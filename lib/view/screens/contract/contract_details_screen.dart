import 'package:realise/core/utils/color_resources.dart';
import 'package:realise/core/utils/dimensions.dart';
import 'package:realise/core/utils/local_strings.dart';
import 'package:realise/core/utils/style.dart';
import 'package:realise/data/controller/contract/contract_controller.dart';
import 'package:realise/data/repo/contract/contract_repo.dart';
import 'package:realise/data/services/api_service.dart';
import 'package:realise/view/components/app-bar/custom_appbar.dart';
import 'package:realise/view/components/custom_loader/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ContractDetailsScreen extends StatefulWidget {
  const ContractDetailsScreen({super.key, required this.id});
  final String id;

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ContractRepo(apiClient: Get.find()));
    final controller = Get.put(ContractController(contractRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadContractDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.contractDetails.tr,
      ),
      body: GetBuilder<ContractController>(
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.space12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.contractDetailsModel.data!.title ?? '',
                              style: regularLarge,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.all(Dimensions.space10),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.cardRadius),
                                    side: BorderSide(
                                        color:
                                            ColorResources.contractStatusColor(
                                                controller.contractDetailsModel
                                                        .data!.status ??
                                                    '')),
                                  ),
                                ),
                                child: Text(
                                  controller.contractDetailsModel.data!.status
                                          ?.tr.capitalize ??
                                      '',
                                  style: regularDefault.copyWith(
                                      color: ColorResources.contractStatusColor(
                                          controller.contractDetailsModel.data!
                                                  .status ??
                                              '')),
                                ))
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                          endIndent: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.space10,
                              horizontal: Dimensions.space5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${LocalStrings.contractValue.tr}: ${controller.currency ?? ''}${controller.contractDetailsModel.data!.contractValue ?? ''}',
                                style: const TextStyle(
                                    fontSize: Dimensions.fontSmall,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: Dimensions.fontSmall),
                              Text(
                                '${LocalStrings.startDate.tr}: ${controller.contractDetailsModel.data!.contractDate ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: Dimensions.fontSmall),
                              Text(
                                '${LocalStrings.endDate.tr}: ${controller.contractDetailsModel.data!.validUntil ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: Dimensions.fontSmall),
                              Text(
                                '${LocalStrings.note.tr}: ${controller.contractDetailsModel.data!.note ?? ''}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(Dimensions.space10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.cardRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Html(
                              data: controller
                                      .contractDetailsModel.data!.content ??
                                  ''),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
