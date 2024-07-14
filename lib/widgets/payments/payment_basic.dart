import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/material.dart';

class PaymentBasic extends StatelessWidget {
  final String firstAmt;
  final String planName;
  final String firstDet;
  final String? secAmt;
  final String? secDet;
  final Color color;
  final IconData styleIcon;
  final String imageUrl;
  const PaymentBasic(
      {super.key,
      required this.firstAmt,
      required this.imageUrl,
      required this.styleIcon,
      required this.planName,
      required this.firstDet,
      this.secAmt,
      this.secDet,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(imageUrl),
                    fit: BoxFit.cover,
                    opacity: 0.2),
                color: Colors.black.withOpacity(0.7),
                border:
                    Border.all(color: const Color.fromARGB(73, 255, 255, 255)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white30)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              planName,
                              style: TextStyles.headingsForSections,
                            ),
                            Icon(
                              styleIcon,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      firstAmt,
                      style: TextStyles.headingMobile,
                    ),
                    Text(
                      firstDet,
                      style: TextStyles.smallSubTextActive,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    secAmt != null ? const Divider() : const SizedBox.shrink(),
                    secAmt != null
                        ? Text(
                            secAmt!,
                            style: TextStyles.headingMobile,
                          )
                        : const SizedBox.shrink(),
                    secDet != null
                        ? Text(
                            secDet!,
                            style: TextStyles.formSubTitle,
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
