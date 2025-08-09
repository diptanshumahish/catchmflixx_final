import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/profiles/avatar_list.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:catchmflixx/state/provider.dart';

class EditProfile extends ConsumerStatefulWidget {
  final String profileId;
  final String avatar;
  final int avatarId;
  final String profileName;
  
  const EditProfile({
    super.key,
    required this.profileId,
    required this.avatar,
    required this.avatarId,
    required this.profileName,
  });

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final ProfileApi _profileApi = ProfileApi();
  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editPinController = TextEditingController();
  
  AvatarList _avatarList = AvatarList(data: [], success: false);
  String _selectedAvatar = "";
  int _selectedAvatarId = 0;
  bool _changePass = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setInitialData();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editPinController.dispose();
    super.dispose();
  }

  Future<void> _setInitialData() async {
    try {
      final avatars = await _profileApi.getAvatars();
      
      if (mounted) {
        setState(() {
          _avatarList = avatars ?? AvatarList(data: [], success: false);
          _editNameController.text = widget.profileName;
          _selectedAvatar = widget.avatar;
          _selectedAvatarId = widget.avatarId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _avatarList = AvatarList(data: [], success: false);
          _editNameController.text = widget.profileName;
          _selectedAvatar = widget.avatar;
          _selectedAvatarId = widget.avatarId;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernAppBar(translation),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildContent(translation),
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
        color: Colors.black,
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              translation.modifyProfile,
              style: TextStyles.headingsForSections.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
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
          Text(
            'Loading avatars...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations translation) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentAvatarSection(translation),
          const SizedBox(height: 32),
          _buildAvatarSelectionSection(translation),
          const SizedBox(height: 32),
          _buildProfileDetailsSection(translation),
        ],
      ),
    );
  }

  Widget _buildCurrentAvatarSection(AppLocalizations translation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.selectedAvatar,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: _selectedAvatar,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const Center(
                    child: CupertinoActivityIndicator(color: Colors.white),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.white.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarSelectionSection(AppLocalizations translation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translation.updateAvatar,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          translation.scrollToSeeMoreAvatars,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _avatarList.data?.length ?? 0,
            itemBuilder: (context, index) {
              final avatar = _avatarList.data![index];
              final isSelected = avatar.avatar == _selectedAvatar;
              
              return GestureDetector(
                onTap: () async {
                  await vibrateTap();
                  setState(() {
                    _selectedAvatar = avatar.avatar!;
                    _selectedAvatarId = avatar.id!;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(37),
                          child: CachedNetworkImage(
                            imageUrl: avatar.avatar!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.white.withOpacity(0.1),
                              child: const Center(
                                child: CupertinoActivityIndicator(color: Colors.white),
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
                      if (isSelected)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsSection(AppLocalizations translation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildModernInputField(
          controller: _editNameController,
          label: translation.editUserName,
          icon: Icons.person,
          maxLength: 8,
        ),
        const SizedBox(height: 20),
        _buildPinToggleSection(translation),
        if (_changePass) ...[
          const SizedBox(height: 16),
          _buildModernInputField(
            controller: _editPinController,
            label: translation.editProfilePin,
            icon: Icons.lock_outline,
            maxLength: 4,
            isNumeric: true,
            isPassword: true,
          ),
          const SizedBox(height: 8),
          Text(
            translation.removePassword,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
        const SizedBox(height: 32),
        _buildUpdateButton(translation),
      ],
    );
  }

  Widget _buildPinToggleSection(AppLocalizations translation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CupertinoSwitch(
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            activeTrackColor: Colors.blue,
            value: _changePass,
            onChanged: (value) {
              setState(() {
                _changePass = value;
                if (!value) {
                  _editPinController.clear();
                }
              });
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              translation.changePinCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required int maxLength,
    bool isNumeric = false,
    bool isPassword = false,
  }) {
    return Container(
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
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        obscureText: isPassword,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
          if (isNumeric) FilteringTextInputFormatter.digitsOnly,
        ],
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

  Widget _buildUpdateButton(AppLocalizations translation) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _updateProfile(translation),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, size: 20),
            const SizedBox(width: 8),
            Text(
              translation.updateProfileDetails,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile(AppLocalizations translation) async {
    try {
      final res = await _profileApi.editProfile(
        widget.profileId,
        _editNameController.text,
        _selectedAvatarId,
        _editPinController.text.isEmpty ? "" : _editPinController.text,
        _changePass,
      );

      if (res != null && res.success == true) {
        await ref.read(currentProfileProvider.notifier).refresh();
        navigateToPage(context, "/base", isReplacement: true);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
