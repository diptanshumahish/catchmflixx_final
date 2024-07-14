import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/state/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vibration/vibration.dart';

class NavbarContent extends ConsumerWidget {
  final IconData icon;
  final String name;
  final int idx;
  final String? image;
  const NavbarContent({
    super.key,
    this.image,
    required this.icon,
    required this.name,
    required this.idx,
  });

  void onLanguageChange(WidgetRef ref, int idx) {
    ref.read(tabsProvider.notifier).updateTab(idx);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(tabsProvider);
    return GestureDetector(
      onTap: () {
        Vibration.vibrate(duration: 40, amplitude: 20);
        onLanguageChange(ref, idx);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (idx == 2)
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedTab.tab == 2
                              ? Colors.white
                              : Colors.white54),
                      borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Opacity(
                      opacity: selectedTab.tab == 2 ? 1 : 0.7,
                      child: CachedNetworkImage(
                        imageUrl: image ??
                            "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                        fit: BoxFit.contain,
                        height: 26,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                )
              : PhosphorIcon(
                  icon,
                  duotoneSecondaryColor: Colors.white60,
                  color: selectedTab.tab != idx ? Colors.white54 : Colors.white,
                ),
          Text(
            name,
            style: selectedTab.tab == idx
                ? TextStyles.smallSubTextActive
                : TextStyles.smallSubText,
          )
        ],
      ),
    );
  }
}
