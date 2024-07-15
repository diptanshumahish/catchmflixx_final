//✅ translated

import 'dart:ui';

import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/models/profiles/logged_in_current_profile.model.dart';
import 'package:catchmflixx/widgets/navigation/navbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

LoggedInCurrentProfile _currentProfile = LoggedInCurrentProfile();

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  getData() async {
    ProfileApi p = ProfileApi();
    final data = await p.getCurrentProfile();
    setState(() {
      _currentProfile = data;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
              color: const Color.fromARGB(108, 40, 41, 43),
              border: Border.all(color: Color.fromARGB(52, 255, 255, 255)),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavbarContent(
                  icon: PhosphorIconsDuotone.house,
                  name: translation.navHome,
                  idx: 0,
                ),
                NavbarContent(
                    icon: PhosphorIconsDuotone.magnifyingGlass,
                    name: translation.navDiscover,
                    idx: 1),
                NavbarContent(
                    icon: PhosphorIconsDuotone.userCircle,
                    image: _currentProfile.avatar ??
                        "https://img.playbook.com/Axh_gEkgZbsvB1VDuXm4GNvbjXXu2RUUqwToXJEJ8ZQ/Z3M6Ly9wbGF5Ym9v/ay1hc3NldHMtcHVi/bGljLzM5NTk3ODYx/LWQ1MzItNDZmMC1i/ZDhmLTQ2NjRiYjcz/NjZmMQ",
                    name: _currentProfile.name ?? "user",
                    idx: 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
