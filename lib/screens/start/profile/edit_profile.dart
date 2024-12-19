import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/message/message_model.dart';
import 'package:catchmflixx/models/profiles/avatar_list.model.dart';
import 'package:catchmflixx/utils/navigation/navigator.dart';
import 'package:catchmflixx/utils/vibrate/vibrations.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final TextEditingController _editNameController = TextEditingController();
final TextEditingController _editPinController = TextEditingController();
final TextEditingController _avatarIdController = TextEditingController();

String _av = "";
int _avId = 0;
bool _changePass = false;

class EditProfile extends ConsumerStatefulWidget {
  final String profileId;
  final String avatar;
  final int avatarId;
  final String profileName;
  const EditProfile(
      {super.key,
      required this.profileId,
      required this.avatar,
      required this.avatarId,
      required this.profileName});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  ProfileApi p = ProfileApi();
  AvatarList _avatarList = AvatarList(data: [], success: false);
  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  void setInitialData() async {
    _avatarList = await p.getAvatars();
    setState(() {
      _editNameController.text = widget.profileName;
      _avatarIdController.text = widget.avatarId.toString();
      _av = widget.avatar;
      _avId = widget.avatarId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            stretch: true,
            pinned: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Text(
              translation.modifyProfile,
              style: TextStyles.headingsForSections,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translation.selectedAvatar,
                    style: size.height > 840
                        ? TextStyles.headingsForSections
                        : TextStyles.headingsForSectionsForSmallerScreens,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        _av,
                        height: 80,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation.updateAvatar,
                          style: size.height > 840
                              ? TextStyles.headingsForSections
                              : TextStyles.headingsForSectionsForSmallerScreens,
                        ),
                        Text(
                          translation.scrollToSeeMoreAvatars,
                          style: TextStyles.formSubTitle,
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: (_avatarList.data != null)
                            ? _avatarList.data!.map((e) {
                                return GestureDetector(
                                  onTap: () async {
                                    await vibrateTap();
                                    setState(() {
                                      _av = e.avatar!;
                                      _avId = e.id!;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: CachedNetworkImage(
                                        imageUrl: e.avatar!,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : []),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: FlexItems(
                  space: 20,
                  widgetList: [
                    CatchMFLixxInputField(
                        labelText: translation.editUserName,
                        icon: Icons.person,
                        controller: _editNameController,
                        inputFormatters: [LengthLimitingTextInputFormatter(8)],
                        type: TextInputType.text),
                    Row(
                      children: [
                        CupertinoSwitch(
                            trackColor: Colors.white38,
                            value: _changePass,
                            onChanged: (val) {
                              setState(() {
                                _changePass = val;
                              });
                            }),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          translation.changePinCode,
                          style: TextStyles.detailsMobile,
                        ),
                      ],
                    ),
                    _changePass == true
                        ? CatchMFLixxInputField(
                            labelText: translation.editProfilePin,
                            icon: Icons.password,
                            controller: _editPinController,
                            obscureText: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            type: TextInputType.number)
                        : const SizedBox.shrink(),
                    _changePass == true
                        ? Text(
                            translation.removePassword,
                            style: TextStyles.smallSubText,
                          )
                        : const SizedBox.shrink(),
                    OffsetFullButton(
                        content: translation.updateProfileDetails,
                        fn: () async {
                          MessageModel res = await p.editProfile(
                              widget.profileId,
                              _editNameController.text,
                              _avId,
                              _editPinController.text == ""
                                  ? null
                                  : _editPinController.text,
                              _changePass);

                          if (res.success!) {
                            navigateToPage(context, "/base",
                                isReplacement: true);
                          }
                        })
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
