import 'dart:math';

import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/content/search.list.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

bool _isReady = false;
ContentList _cList = ContentList();

class PickedForYou extends StatefulWidget {
  const PickedForYou({super.key});

  @override
  State<PickedForYou> createState() => _PickedForYouState();
}

class _PickedForYouState extends State<PickedForYou> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager ct = ContentManager();
    ContentList data = await ct.searchContent("");
    if (data.results!.success!) {
      setState(() {
        _cList = data;
        _isReady = true;
      });
    }
  }

  int randomNo(int maxLength) {
    Random random = Random();
    return random.nextInt(maxLength);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_isReady) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      );
    }
    final int nu = randomNo(_cList.results?.data?.length ?? 1);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(size.width / 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white10),
            width: size.width,
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 12 / 16,
                  child: Image.network(
                      fit: BoxFit.cover,
                      _cList.results?.data?[nu].thumbnail ?? ""),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pick of the day",
                      style: TextStyles.smallSubTextActive,
                    ),
                    SizedBox(
                      width: size.width / 2.5,
                      child: Text(
                        _cList.results?.data?[nu].metaData?.title ?? "",
                        style: TextStyles.cardHeading,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2.5,
                      child: Text(
                        _cList.results?.data?[nu].metaData?.description ?? "",
                        style: TextStyles.smallSubText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateToPage(
                          context,
                          _cList.results?.data![nu].type == "movie"
                              ? "/movie/${_cList.results?.data![nu].uuid ?? ""}"
                              : "/series/${_cList.results?.data![nu].uuid ?? ""}",
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Watch now",
                              style: TextStyles.formSubTitle,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            PhosphorIcon(
                              PhosphorIconsRegular.arrowUpRight,
                              color: Colors.white,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
