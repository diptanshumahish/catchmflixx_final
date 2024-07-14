// ✅ translated

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catchmflixx/api/user/profile/profile_api.dart';
import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/models/profiles/profile.model.dart';
import 'package:catchmflixx/models/profiles/profile_creation_sucess.model.dart';
import 'package:catchmflixx/utils/toast.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_secondary_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/common/inputs/input_field.dart';
import 'package:catchmflixx/screens/start/profile/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final TextEditingController _profileNameController = TextEditingController();
final TextEditingController _profilePinController = TextEditingController();

bool _isKids = false;

class ProfileManagement extends ConsumerStatefulWidget {
  const ProfileManagement({super.key});

  @override
  ConsumerState<ProfileManagement> createState() => _ProfileManagementState();
}

class _ProfileManagementState extends ConsumerState<ProfileManagement> {
  ProfileApi p = ProfileApi();
  ProfilesList _profilesList = ProfilesList(data: []);
  bool _isLoading = true;

  @override
  void initState() {
    getData();
    isKid();
    super.initState();
  }

  void getData() async {
    _profilesList = await p.fetchProfiles();
    setState(() {
      _isLoading = false;
    });
  }

  void isKid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var kid = prefs.getString("is_kids");
    setState(() {
      _isKids = kid == "Kids" ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final translation = AppLocalizations.of(context)!;
    return (_isKids == false)
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      onStretchTrigger: () async {
                        getData();
                      },
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      backgroundColor: Colors.black,
                      title: Text(
                        translation.profilemanagement,
                        style: TextStyles.headingsForSections,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          translation.avlProfiles,
                          style: TextStyles.formSubTitle,
                        ),
                      ),
                    ),
                    _isLoading
                        ? const SliverToBoxAdapter(
                            child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: CupertinoActivityIndicator(
                                  color: Colors.white,
                                )))
                        : SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: (_profilesList.data != null)
                                    ? _profilesList.data!.map((e) {
                                        return Slidable(
                                          enabled: true,
                                          endActionPane: ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) async {
                                                    await p
                                                        .deleteProfile(e.uuid!);
                                                    getData();
                                                  },
                                                  icon: PhosphorIconsRegular
                                                      .trashSimple,
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                )
                                              ]),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white10,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    imageUrl: e.avatar!,
                                                    height: 50,
                                                    width: 50,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const PhosphorIcon(
                                                            PhosphorIconsBold
                                                                .warning),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.name!,
                                                      style: TextStyles
                                                          .formSubTitle,
                                                    ),
                                                    Text(
                                                      e.profile_type!,
                                                      style: TextStyles
                                                          .smallSubText,
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    e.is_protected!
                                                        ? IconButton(
                                                            onPressed: () {
                                                              ToastShow.returnToast(
                                                                  translation
                                                                      .locksignify);
                                                            },
                                                            icon:
                                                                const PhosphorIcon(
                                                              PhosphorIconsDuotone
                                                                  .lock,
                                                              duotoneSecondaryColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : IconButton(
                                                            onPressed: () {
                                                              ToastShow.returnToast(
                                                                  translation
                                                                      .unlocksignify);
                                                            },
                                                            icon:
                                                                const PhosphorIcon(
                                                              PhosphorIconsDuotone
                                                                  .lockOpen,
                                                              duotoneSecondaryColor:
                                                                  Colors.white,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                    IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child: EditProfile(
                                                                      profileId:
                                                                          e.uuid ??
                                                                              "",
                                                                      avatar:
                                                                          e.avatar ??
                                                                              "",
                                                                      avatarId:
                                                                          e.avatar_id ??
                                                                              0,
                                                                      profileName:
                                                                          e.name ??
                                                                              ""),
                                                                  type: PageTransitionType
                                                                      .rightToLeft));
                                                        },
                                                        icon:
                                                            const PhosphorIcon(
                                                          PhosphorIconsDuotone
                                                              .pen,
                                                          duotoneSecondaryColor:
                                                              Colors.white,
                                                          color: Colors.white,
                                                        )),
                                                    IconButton(
                                                        onPressed: () async {
                                                          var res = await p
                                                              .deleteProfile(
                                                                  e.uuid!);
                                                          ToastShow.returnToast(
                                                              res.data?.message ??
                                                                  "");
                                                          getData();
                                                        },
                                                        icon:
                                                            const PhosphorIcon(
                                                          PhosphorIconsDuotone
                                                              .trashSimple,
                                                          duotoneSecondaryColor:
                                                              Colors.redAccent,
                                                          color: Colors.red,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList()
                                    : [],
                              ),
                            ),
                          ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OffsetFullButton(
                          content: translation.addnewProfile,
                          fn: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                useSafeArea: true,
                                showDragHandle: true,
                                backgroundColor: Colors.black,
                                context: context,
                                builder: (context) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width >
                                                    540
                                                ? 400
                                                : double.infinity,
                                        width:
                                            MediaQuery.of(context).size.width >
                                                    540
                                                ? 500
                                                : double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.add,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  translation.addnewProfile,
                                                  style: TextStyles
                                                      .headingsForSections,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              child: FlexItems(widgetList: [
                                                CatchMFLixxInputField(
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          8)
                                                    ],
                                                    labelText:
                                                        translation.profilename,
                                                    icon: Icons.person_add,
                                                    controller:
                                                        _profileNameController,
                                                    type: TextInputType.text),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                CatchMFLixxInputField(
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          4),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    labelText:
                                                        translation.profilepin,
                                                    icon:
                                                        Icons.password_rounded,
                                                    controller:
                                                        _profilePinController,
                                                    type: TextInputType.number),
                                                Text(
                                                  translation.leaveEmpty,
                                                  style:
                                                      TextStyles.smallSubText,
                                                ),
                                                OffsetFullButton(
                                                    icon: Icons.verified,
                                                    content: translation
                                                        .addnewProfile,
                                                    fn: () async {
                                                      ProfileCreationResponse
                                                          res =
                                                          await p.addProfile(
                                                              _profileNameController
                                                                  .text,
                                                              _profilePinController
                                                                  .text,
                                                              ProfileType.Adult,
                                                              null);

                                                      if (res.name != null) {
                                                        ToastShow.returnToast(
                                                            "created profile ${res.name}");
                                                        _profileNameController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        _profileNameController
                                                            .clear();
                                                        ToastShow.returnToast(
                                                            translation
                                                                .maxProfilesCreated);

                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                      getData();
                                                    }),
                                                SecondaryFullButton(
                                                    icon: const Icon(Icons
                                                        .child_friendly_sharp),
                                                    content: translation
                                                        .addKidsProfile,
                                                    fn: () async {
                                                      var res = await p.addProfile(
                                                          _profileNameController
                                                              .text,
                                                          _profilePinController
                                                              .text,
                                                          ProfileType.Kids,
                                                          null);
                                                      if (res.name != null) {
                                                        ToastShow.returnToast(
                                                            "created profile ${res.name}");
                                                        _profileNameController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else {
                                                        _profileNameController
                                                            .clear();
                                                        ToastShow.returnToast(
                                                            translation
                                                                .maxProfilesCreated);
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                      getData();
                                                    }),
                                                Text(
                                                  translation.profileTwoMax,
                                                  style:
                                                      TextStyles.detailsMobile,
                                                )
                                              ], space: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          icon: PhosphorIconsFill.userPlus,
                        ),
                      ),
                    ),
                  ],
                )))
        : Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.supervised_user_circle,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      translation.contactParental,
                      style: TextStyles.headingsForSections,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      translation.profileWeDetected,
                      style: TextStyles.smallSubText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OffsetSecondaryFullButton(
                        content: translation.goBack,
                        fn: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
