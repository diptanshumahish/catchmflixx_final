import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/gradient.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';

class SearchTop extends StatelessWidget {
  final String searchText;
  const SearchTop({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height / 3,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        "https://img.playbook.com/ZbPD9M8hctAHzLHxXv37LSL5_et1fgfF8fExiL-EkGU/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzdkZTNjYmRm/LTAyYTMtNDUwNi04/ZjhkLTE2M2NkMGRh/YzZlYQ",
                        scale: 0.5),
                    fit: BoxFit.cover)),
            child: Container(
              decoration:
                  const BoxDecoration(gradient: CFGradient.topToBottomGradient),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.height / 40),
            child: Text(
              searchText,
              style: size.height > 840
                  ? TextStyles.headingMobile
                  : TextStyles.headingMobileSmallScreens,
            ),
          )
        ],
      ),
    );
  }
}
