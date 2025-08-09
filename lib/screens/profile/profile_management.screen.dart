
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/screens/start/profile/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catchmflixx/theme/typography.dart';

class ProfileManagement extends ConsumerStatefulWidget {
  const ProfileManagement({super.key});

  @override
  ConsumerState<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends ConsumerState<ProfileManagement> {
  final ProfileApi _profileApi = ProfileApi();
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _profilePinController = TextEditingController();
  final FocusNode _profileNameFocusNode = FocusNode();
  final FocusNode _profilePinFocusNode = FocusNode();

  ProfilesList _profilesList = ProfilesList(data: []);
  bool _isLoading = true;
  bool _isKids = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupFocusListeners();
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _profilePinController.dispose();
    _profileNameFocusNode.dispose();
    _profilePinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _loadProfiles(),
      _checkKidsMode(),
    ]);
  }

  Future<void> _loadProfiles() async {
    try {
      final profiles = await _profileApi.fetchProfiles();
      if (mounted) {
        setState(() {
          _profilesList = profiles ?? ProfilesList(data: []);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkKidsMode() async {
    final prefs = await SharedPreferences.getInstance();
    final kid = prefs.getString("is_kids");
    if (mounted) {
      setState(() {
        _isKids = kid == "Kids";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;

    if (_isKids) {
      return _buildKidsRestrictedScreen(translation);
    }

    return _buildMainScreen(translation);
  }

  Widget _buildKidsRestrictedScreen(AppLocalizations translation) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 4),
                AppText(
                  translation.contactParental,
                  variant: AppTextVariant.headline,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                AppText(
                  translation.profileWeDetected,
                  variant: AppTextVariant.body,
                  color: Colors.white.withOpacity(0.7),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: AppText(
                      translation.goBack,
                      variant: AppTextVariant.subtitle,
                      color: Colors.black,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen(AppLocalizations translation) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernAppBar(translation),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildProfilesContent(translation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernAppBar(AppLocalizations translation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 20),
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 16),
          const SizedBox(width: 2),
          Expanded(
            child: AppText(
              translation.profilemanagement,
              variant: AppTextVariant.headline,
              weight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _loadProfiles(),
              icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(color: Colors.white, radius: 20),
          SizedBox(height: 16),
          AppText('Loading profiles...', variant: AppTextVariant.body, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildProfilesContent(AppLocalizations translation) {
    final profiles = _profilesList.data ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  '${profiles.length} ${translation.avlProfiles}',
                  variant: AppTextVariant.body,
                  color: Colors.white.withOpacity(0.8),
                  weight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _buildAddProfileButton(translation),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.black,
            onRefresh: _loadProfiles,
            child: profiles.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      _buildEmptyState(translation),
                    ],
                  )
                : _buildProfilesList(profiles, translation),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations translation) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_add_outlined,
              color: Colors.white54,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          AppText('No profiles yet',
              variant: AppTextVariant.title,
              color: Colors.white.withOpacity(0.85),
              weight: FontWeight.w600),
          const SizedBox(height: 8),
          AppText('Create your first profile to get started',
              variant: AppTextVariant.body,
              color: Colors.white.withOpacity(0.7),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildProfilesList(List<Data> profiles, AppLocalizations translation) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return _buildModernProfileCard(profiles[index], translation);
      },
    );
  }

  Widget _buildModernProfileCard(Data profile, AppLocalizations translation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _confirmAndDeleteProfile(profile.uuid!, translation),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: PhosphorIconsRegular.trashSimple,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToEditProfile(profile),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isCompact = constraints.maxWidth < 400;
                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildModernProfileAvatar(profile.avatar!, profile.is_protected == true),
                            const SizedBox(width: 16),
                            Expanded(child: _buildModernProfileInfo(profile)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildModernProfileActions(profile, translation, isCompact),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      _buildModernProfileAvatar(profile.avatar!, profile.is_protected == true),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModernProfileInfo(profile),
                      ),
                      _buildModernProfileActions(profile, translation, isCompact),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernProfileAvatar(String avatarUrl, bool isProtected) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                color: Colors.white.withOpacity(0.1),
                child: Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.white.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: Colors.white54,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Icon(
              isProtected ? PhosphorIconsFill.lockSimple : PhosphorIconsRegular.lockSimpleOpen,
              size: 12,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernProfileInfo(Data profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(profile.name!, variant: AppTextVariant.subtitle, weight: FontWeight.w700),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: profile.profile_type == "Adult"
                ? Colors.blue.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppText(
            profile.profile_type!,
            variant: AppTextVariant.caption,
            color: profile.profile_type == "Adult"
                ? Colors.blue[300]
                : Colors.orange[300],
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildModernProfileActions(
      Data profile, AppLocalizations translation, bool isCompact) {
    final buttons = [
      _buildModernActionButtonWithLabel(
        icon: PhosphorIconsDuotone.pen,
        color: Colors.blue,
        onPressed: () => _navigateToEditProfile(profile),
        label: 'Edit',
      ),
      _buildModernActionButtonWithLabel(
        icon: PhosphorIconsDuotone.trashSimple,
        color: Colors.red,
        onPressed: () => _confirmAndDeleteProfile(profile.uuid!, translation),
        label: 'Delete',
      ),
    ];

    if (isCompact) {
      return Row(
        children: [
          Expanded(child: buttons[0]),
          const SizedBox(width: 8),
          Expanded(child: buttons[1]),
        ],
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: buttons,
      ),
    );
  }


  Widget _buildAddProfileButton(AppLocalizations translation) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showModernAddProfileModal(translation),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 8),
                AppText(translation.addnewProfile,
                    variant: AppTextVariant.body,
                    color: Colors.black,
                    weight: FontWeight.w700),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile(Data profile) {
    navigateToPage(
      context,
      "/user/profile/edit",
      data: EditProfile(
        profileId: profile.uuid ?? "",
        avatar: profile.avatar ?? "",
        avatarId: profile.avatar_id ?? 0,
        profileName: profile.name ?? "",
      ),
    );
  }

  Future<void> _deleteProfile(String uuid) async {
    try {
      final res = await _profileApi.deleteProfile(uuid);
      ToastShow.returnToast(res?.data?.message ?? "");
      await _loadProfiles();
    } catch (e) {
      ToastShow.returnToast("Failed to delete profile");
    }
  }

  Future<void> _confirmAndDeleteProfile(
      String uuid, AppLocalizations translation) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const AppText(
            'Are you sure?',
            variant: AppTextVariant.title,
            weight: FontWeight.w700,
          ),
          content: const AppText(
            'This will delete the profile. You can create it again later.',
            variant: AppTextVariant.body,
            color: Colors.white70,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const AppText('Cancel', variant: AppTextVariant.subtitle, color: Colors.white70),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const AppText('Delete', variant: AppTextVariant.subtitle, color: Colors.red),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _deleteProfile(uuid);
    }
  }

  void _showModernAddProfileModal(AppLocalizations translation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildModernAddProfileModalContent(translation),
    ).then((_) {
      // Clear focus when modal is closed
      _profileNameFocusNode.unfocus();
      _profilePinFocusNode.unfocus();
    });
  }

  Widget _buildModernAddProfileModalContent(AppLocalizations translation) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    AppText(
                      translation.addnewProfile,
                      variant: AppTextVariant.headline,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildModernInputField(
                  controller: _profileNameController,
                  focusNode: _profileNameFocusNode,
                  label: translation.profilename,
                  icon: Icons.person_add,
                  maxLength: 8,
                ),
                const SizedBox(height: 16),
                _buildModernInputField(
                  controller: _profilePinController,
                  focusNode: _profilePinFocusNode,
                  label: translation.profilepin,
                  icon: Icons.lock_outline,
                  maxLength: 4,
                  isNumeric: true,
                ),
                const SizedBox(height: 8),
                AppText(
                  translation.leaveEmpty,
                  variant: AppTextVariant.caption,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernActionButtonWithLabel(
                        icon: Icons.verified,
                        color: Colors.blue,
                        onPressed: () =>
                            _addProfile(ProfileType.Adult, translation),
                        label: translation.addnewProfile,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernActionButtonWithLabel(
                        icon: Icons.child_friendly,
                        color: Colors.orange,
                        onPressed: () =>
                            _addProfile(ProfileType.Kids, translation),
                        label: translation.addKidsProfile,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText(
                          translation.profileTwoMax,
                          variant: AppTextVariant.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String label,
    required IconData icon,
    required int maxLength,
    bool isNumeric = false,
  }) {
    return Container(
      key: focusNode != null ? ValueKey(focusNode.hashCode) : null,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
          if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        ],
        onTap: () {
          // No longer needed for centered dialog
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildModernActionButtonWithLabel({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String label,
  }) {
    return SizedBox(
      height: 40,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.06),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.5)),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.circle, size: 0), // placeholder to keep spacing consistent
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            AppText(
              label,
              variant: AppTextVariant.body,
              color: Colors.white,
              weight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProfile(
      ProfileType type, AppLocalizations translation) async {
    try {
      final name = _profileNameController.text.trim();
      final pin = _profilePinController.text.trim();

      if (name.isEmpty) {
        ToastShow.returnToast(translation.chk);
        return;
      }
      if (name.length > 8) {
        ToastShow.returnToast('Name must be at most 8 characters');
        return;
      }
      if (pin.isNotEmpty && pin.length != 4) {
        ToastShow.returnToast(translation.pinVal);
        return;
      }

      final res = await _profileApi.addProfile(
        name,
        pin,
        type,
        null,
      );

      if (!mounted) return;

      if (res?.name != null) {
        ToastShow.returnToast("Created profile ${res?.name}");
        _clearControllers();
        Navigator.of(context).pop();
      } else {
        _clearControllers();
        ToastShow.returnToast(translation.maxProfilesCreated);
        Navigator.of(context).pop();
      }

      await _loadProfiles();
    } catch (e) {
      if (mounted) {
        ToastShow.returnToast("Failed to create profile");
      }
    }
  }

  void _clearControllers() {
    _profileNameController.clear();
    _profilePinController.clear();
  }

  void _setupFocusListeners() {
    // No longer needed for centered dialog
  }
}
