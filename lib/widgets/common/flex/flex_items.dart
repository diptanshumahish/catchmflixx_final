import 'package:flutter/cupertino.dart';

class FlexItems extends StatelessWidget {
  final List<Widget> widgetList;
  final bool? horizontal;
  final double space;
  const FlexItems(
      {super.key,
      required this.widgetList,
      required this.space,
      this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final spacerList = <Widget>[];
    for (int i = 0; i < widgetList.length - 1; i++) {
      spacerList.add(widgetList[i]);
      horizontal == false
          ? spacerList.add(SizedBox(height: space))
          : spacerList.add(SizedBox(
              width: space,
            ));
    }
    spacerList.add(widgetList.last);

    if (horizontal == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: spacerList,
      );
    } else {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: spacerList);
    }
  }
}
