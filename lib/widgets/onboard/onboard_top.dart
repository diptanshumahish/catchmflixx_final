import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardTopBar extends ConsumerWidget {
  final String type;
  final String description;
  const OnboardTopBar(
      {super.key, required this.type, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    const String url =
        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ";
    return FlexibleSpaceBar(
        background: Stack(
      children: [
        CachedNetworkImage(
          width: size.width,
          height: double.infinity,
          imageUrl: url,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54, Colors.black])),
        ),
        Padding(
          padding: EdgeInsets.all(size.height / 40),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  CatchMFlixxImages.logo,
                  height: 40,
                ),
                SvgPicture.asset(
                  CatchMFlixxImages.textLogo,
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
