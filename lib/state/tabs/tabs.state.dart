import 'package:catchmflixx/models/tabs/tabselector.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabNotifier extends StateNotifier<TabSelector> {
  TabNotifier(state) : super(state);
  void updateTab(int tabNo) {
    state = TabSelector(tab: tabNo);
  }
}
