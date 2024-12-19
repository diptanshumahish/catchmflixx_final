import 'package:catchmflixx/api/payments/payments.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/payments/episode_rent_options.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

EpisodeRentModel rt = EpisodeRentModel(success: false);

class EpisodeRentingScreen extends StatefulWidget {
  final VoidCallback act;
  final String title;
  final String episodeNumber;
  final String img;
  final String id;

  const EpisodeRentingScreen({
    super.key,
    required this.act,
    required this.episodeNumber,
    required this.title,
    required this.img,
    required this.id,
  });

  @override
  State<EpisodeRentingScreen> createState() => _EpisodeRentingScreenState();
}

class _EpisodeRentingScreenState extends State<EpisodeRentingScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    PaymentsManager p = PaymentsManager();
    final data = await p.getEpisodeRents(widget.id);
    if (data.success!) {
      setState(() {
        rt = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const CupertinoNavigationBarBackButton(
          color: Colors.white,
        ),
        title: Text(
          'Episode ${widget.episodeNumber}',
          style: TextStyles.headingsForSections,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const Row(
              children: [
                PhosphorIcon(
                  PhosphorIconsLight.currencyInr,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  "Rent this Episode",
                  style: TextStyles.headingMobile,
                ),
              ],
            ),
            const Divider(
              color: Colors.white24,
              thickness: 1,
              height: 30,
            ),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.img,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Episode ${widget.episodeNumber}',
                        style: TextStyles.smallSubText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyles.headingsSecondaryMobile,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Available Options",
              style: TextStyles.cardHeading,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "you can use the phonepe or razorpay gateway for making payments securely, in case you face issues in any of the gateways, use the other",
              style: TextStyles.formSubTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
                "In case of any issues, please contact us at contact@catchmflix.com , we will be happy to help you out. If any payment has been made then make sure to attach the payment success mail, or your bank receipt for",
                style: TextStyles.formSubTitle),
            rt.data != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: FlexItems(
                      widgetList: rt.data!.map((ele) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${ele.price.toString()} USD",
                                    style: TextStyles.headingsSecondaryMobile,
                                  ),
                                  Text(
                                    "${ele.days.toString()} days",
                                    style: TextStyles.cardHeading,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              OffsetFullButton(
                                icon: PhosphorIconsLight.currencyInr,
                                content: "Rent now (Razorpay)",
                                fn: () async {
                                  PaymentsManager p = PaymentsManager();
                                  final data = await p
                                      .razorPeInitEpisode(ele.id.toString());

                                  final url = data.data.shortUrl;

                                  if (data.success) {
                                    await launchUrl(
                                        Uri.parse(
                                            "https://www.catchmflixx.com/en/redirect?url=${url.toString()}"),
                                        mode: LaunchMode.externalApplication,
                                        webViewConfiguration:
                                            const WebViewConfiguration(
                                                enableJavaScript: true,
                                                enableDomStorage: true));
                                    navigateToPage(context, "/base");
                                  }
                                },
                              ),
                              // const SizedBox(height: 10),
                              // OffsetFullButton(
                              //   icon: PhosphorIconsLight.currencyInr,
                              //   content: "Rent Now (Phonepe)",
                              //   fn: () async {
                              //     PaymentsManager p = PaymentsManager();
                              //     final data = await p
                              //         .phonePeInitEpisode(ele.id.toString());

                              //     final url = data.data.data.instrumentResponse
                              //         .redirectInfo.url;

                              //     if (data.data.success) {
                              //       await launchUrl(
                              //           Uri.parse(
                              //               "https://www.catchmflixx.com/en/redirect?url=${url.toString()}"),
                              //           mode: LaunchMode.externalApplication,
                              //           webViewConfiguration:
                              //               const WebViewConfiguration(
                              //                   enableJavaScript: true,
                              //                   enableDomStorage: true));
                              //       navigateToPage(context, "/base");
                              //     }
                              //   },
                              // ),
                            ],
                          ),
                        );
                      }).toList(),
                      space: 10,
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
