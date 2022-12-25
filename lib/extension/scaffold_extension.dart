import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receivesharing/constants/color_constants.dart';
import 'package:receivesharing/constants/dimens_constants.dart';
import 'package:receivesharing/constants/file_constants.dart';
import 'package:receivesharing/constants/font_size_constants.dart';
import 'package:receivesharing/ui/download_quality_choose/pages/download_quality_choose.dart';
import 'package:receivesharing/ui/home/model/user_detail_model.dart';

extension ScaffoldExtension on Widget {
  //General Scaffold For All Screens
  Scaffold generalScaffold({
    required BuildContext context,
    String? appTitle,
    bool isBack = true,
    bool isShowFab = true,
    List<UserDetailModel>? userList,
    List<File>? files,
    String? sharedText,
  }) {
    return Scaffold(
        appBar: _generalAppBar(context, appTitle, isBack),
        body: SafeArea(
          child: this,
        ),
        bottomSheet: isShowFab
            ? _fabButton(userList, sharedText, context, files)
            : SizedBox());
  }

  AppBar _generalAppBar(BuildContext context, String? appTitle, bool isBack) =>
      AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(DimensionConstants.circular20),
                  bottomRight: Radius.circular(DimensionConstants.circular20))),
          shadowColor: ColorConstants.appBarShadowColor,
          backgroundColor: ColorConstants.primaryColor,
          elevation: 4,
          title: Text(appTitle!,
              style: TextStyle(
                  color: ColorConstants.whiteColor,
                  fontSize: FontSizeWeightConstants.fontSize24,
                  fontWeight: FontSizeWeightConstants.fontWeightBold)),
          leading: (isBack)
              ? IconButton(
                  icon: Image.asset(FileConstants.icBack, scale: 3.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : SizedBox(),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light);

  Widget _fabButton(
    List<UserDetailModel>? userList,
    String? sharedText,
    BuildContext context,
    List<File>? files,
  ) =>
      InkWell(
        onTap: () {
          List<UserDetailModel> selectedUsers = [];
          for (var user in userList!) {
            if (user.isSelected) {
              selectedUsers.add(user);
            }
          }
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                //  SharingMediaPreviewScreen(
                //     files: files,
                //     userList: selectedUsers,
                //     text: sharedText ?? "")
                YoutubeDownloaderPage(),
          ));
        },
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'Download more',
                style: TextStyle(
                  color: ColorConstants.offWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                // height: DimensionConstants.containerHeight50,
                // width: DimensionConstants.containerHeight100,
                // color: ColorConstants.whiteColor,
              ),
            )),
      );
}
