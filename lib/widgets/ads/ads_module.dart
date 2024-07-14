import 'package:catchmflixx/api/ads/ads_manager.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/ads/ads.response.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

AdsResponse _adsResponse = AdsResponse(data: [], success: false);

class AdsModule extends StatefulWidget {
  const AdsModule({super.key});

  @override
  State<AdsModule> createState() => _AdsModuleState();
}

class _AdsModuleState extends State<AdsModule> {
  getData() async {
    AdsManager a = AdsManager();
    final data = await a.getAds();
    if (data.success!) {
      setState(() {
        _adsResponse = data;
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
    final size = MediaQuery.of(context).size;

    if (_adsResponse.success == true) {
      return Animate(
        effects: const [FlipEffect()],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 20),
          child: GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse(
                  _adsResponse.data?[0].link ?? "https://catchmflixx.com"));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              width: size.width,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _adsResponse.data?[0].banner ?? "",
                      width: size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Promoted",
                          style: TextStyles.smallSubText,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _adsResponse.data?[0].callToAction ?? "",
                              style: TextStyles.headingsForSections,
                            ),
                            PhosphorIcon(
                              PhosphorIconsRegular.arrowUpRight,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
