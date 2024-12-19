import 'package:catchmflixx/api/payments/payments.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/payments/renting_options.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

RentingOptions rt = RentingOptions(success: false);

class RentingScreen extends StatefulWidget {
  final VoidCallback act;
  final String title;
  final String img;
  final String id;

  const RentingScreen(
      {super.key,
      required this.act,
      required this.title,
      required this.img,
      required this.id});

  @override
  State<RentingScreen> createState() => _RentingScreenState();
}

class _RentingScreenState extends State<RentingScreen> {
  getData() async {
    PaymentsManager p = PaymentsManager();
    final data = await p.getMovieRents(widget.id);
    if (data.success!) {
      setState(() {
        rt = data;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
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
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Rent this content",
                  style: TextStyles.headingMobile,
                ),
              ],
            ),
            const Divider(),
            Text(
              widget.title,
              style: TextStyles.headingsSecondaryMobile,
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Available options",
              style: TextStyles.cardHeading,
            ),
            rt.data != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: FlexItems(
                        widgetList: rt.data!
                            .map((ele) => Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.white12)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${ele.price.toString()} USD",
                                            style: TextStyles
                                                .headingsSecondaryMobile,
                                          ),
                                          Text(
                                            "${ele.days.toString()} days",
                                            style: TextStyles.cardHeading,
                                          )
                                        ],
                                      ),
                                      // OffsetFullButton(
                                      //      content: "Buy now (phonepe gateway)",
                                      //     fn: () async {
                                      //       PaymentsManager p =
                                      //           PaymentsManager();
                                      //       final data =
                                      //           await p.phonePeInitMovie(
                                      //               ele.id.toString());

                                      //       final url = data
                                      //           .data
                                      //           .details
                                      //           .transactionData
                                      //           .instrumentResponse
                                      //           .redirectInfo
                                      //           .url;

                                      //       if (data.data.success) {
                                      //         await launchUrl(Uri.parse(
                                      //             "https://www.catchmflixx.com/en/redirect?url=${url.toString()}"),mode: LaunchMode.externalApplication,webViewConfiguration: WebViewConfiguration(enableJavaScript: true, enableDomStorage: true) );
                                      //         navigateToPage(context, "/base");
                                      //       }
                                      //     }),
                                      //    const SizedBox(height: 10,),
                                          OffsetFullButton(
                                          content: "Buy now (razorpay gateway)",
                                          fn: () async {
                                            PaymentsManager p =
                                                PaymentsManager();
                                            final data =
                                                await p.rzPayInitMovie(
                                                    ele.id.toString());

                                            final url = data
                                                .data.shortUrl;

                                            if (data.success) {
                                              await launchUrl(Uri.parse(
                                                  "https://www.catchmflixx.com/en/redirect?url=${url.toString()}"),mode: LaunchMode.externalApplication,webViewConfiguration: WebViewConfiguration(enableJavaScript: true, enableDomStorage: true) );
                                              navigateToPage(context, "/base");
                                            }
                                          })
                                    ],
                                  ),
                                ))
                            .toList(),
                        space: 10),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
