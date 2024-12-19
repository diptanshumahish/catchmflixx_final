import 'package:catchmflixx/api/content/common.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/cast/cast.model.dart';
import 'package:catchmflixx/widgets/cast/cast_card.dart';
import 'package:flutter/material.dart';

CastResponse _castResponse = CastResponse(data: [], success: false);

class CastRender extends StatefulWidget {
  final String uuid;
  const CastRender({super.key, required this.uuid});

  @override
  State<CastRender> createState() => _CastRenderState();
}

class _CastRenderState extends State<CastRender> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ContentManager c = ContentManager();
    final data = await c.getCast(widget.uuid);
    setState(() {
      _castResponse = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(size.height / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text("Cast", style: TextStyles.headingsForSections),
                ),
              ],
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _castResponse.success != false
                    ? Row(
                        children: _castResponse.data!.map((e) {
                          return CastCard(
                              name: e.actor?.name ?? "",
                              role: e.movieRole ?? "actor",
                              image: e.actor?.image ?? "");
                        }).toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
