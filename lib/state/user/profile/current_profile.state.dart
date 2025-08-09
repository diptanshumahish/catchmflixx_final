import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/models/profiles/logged_in_current_profile.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentProfileNotifier extends StateNotifier<LoggedInCurrentProfile?> {
  CurrentProfileNotifier() : super(null) {
    load();
  }

  final ProfileApi _profileApi = ProfileApi();

  Future<void> load() async {
    try {
      final profile = await _profileApi.getCurrentProfile();
      state = profile ?? LoggedInCurrentProfile();
    } catch (_) {
      state = LoggedInCurrentProfile();
    }
  }

  Future<void> refresh() async {
    await load();
  }
}


