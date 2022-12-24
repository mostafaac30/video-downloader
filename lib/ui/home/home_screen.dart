import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:receivesharing/constants/Constants.dart';
import 'package:receivesharing/constants/app_constants.dart';
import 'package:receivesharing/constants/color_constants.dart';
import 'package:receivesharing/constants/dimens_constants.dart';
import 'package:receivesharing/constants/font_size_constants.dart';
import 'package:receivesharing/extension/scaffold_extension.dart';
import 'package:receivesharing/ui/home/user_listing_screen.dart';
import 'package:refresh/refresh.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../download_quality_choose/pages/download_quality_choose.dart';
import 'package:open_file/open_file.dart';

import 'model/video.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Directory directory;
  List<OfflineVideo> videos = [];
  void getDownloadDirFiles() async {
    directory = await DownloadsPath.downloadsDirectory() ?? Directory('');
    directory.listSync().map((e) async {
      if (e.path.contains(Constants.appName)) {
        videos.add(OfflineVideo(
            path: e.path, thumbnailPath: await buildThumbnail(e.path)));
      }
    }).toList();
    setState(() {});
  }

  Future<String> buildThumbnail(String path) async {
    return await VideoThumbnail.thumbnailFile(
            video: path,
            imageFormat: ImageFormat.PNG,
            timeMs: 1,
            quality: 50) ??
        '';
  }

  @override
  void initState() {
    getDownloadDirFiles();
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      listenShareMediaFiles(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: RefreshController(initialRefresh: false),
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () => getDownloadDirFiles(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: DimensionConstants.topPadding10,
              horizontal: DimensionConstants.horizontalPadding10),
          child: videos.isEmpty
              ? Text("downloaded Content...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FontSizeWeightConstants.fontSize20,
                      color: ColorConstants.greyColor))
              : ListView.separated(
                  itemCount: videos.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        OpenFile.open(videos[index].path);
                      },
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black12,
                        ),
                        child: Row(
                          children: [
                            Image.file(
                              File(
                                videos[index].thumbnailPath,
                              ),
                              height: 70,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Text(
                                videos[index].path.split('/').last,
                                overflow: TextOverflow.ellipsis,
                                locale: Locale('ar', 'AE'),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) {
                    return Divider();
                  }),
                ),
        ),
      ).generalScaffold(
          context: context,
          appTitle: Constants.appName,
          isBack: false,
          files: videos.map((e) => File(e.path)).toList(),
          userList: []),
    );
  }

  //All listeners to listen Sharing media files & text
  void listenShareMediaFiles(BuildContext context) {
    // For sharing images coming from outside the app
    // while the app is in the memory
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      navigateToShareMedia(context, value);
    }, onError: (err) {
      debugPrint("$err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      navigateToShareMedia(context, value);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    ReceiveSharingIntent.getTextStream().listen((String value) {
      navigateToShareText(context, value);
    }, onError: (err) {
      debugPrint("$err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      navigateToShareText(context, value);
    });
  }

  void navigateToShareMedia(BuildContext context, List<SharedMediaFile> value) {
    if (value.isNotEmpty) {
      var newFiles = <File>[];
      value.forEach((element) {
        newFiles.add(File(
          Platform.isIOS
              ? element.type == SharedMediaType.FILE
                  ? element.path
                      .toString()
                      .replaceAll(AppConstants.replaceableText, "")
                  : element.path
              : element.path,
        ));
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserListingScreen(
                files: newFiles,
                text: "",
              )));
    }
  }

  void navigateToShareText(BuildContext context, String? value) {
    if (value != null && value.toString().isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              // SharingMediaPreviewScreen(files: [], userList: [], text: value)
              YoutubeDownloaderPage(url: value)
          //  UserListingScreen(
          //       files: [],
          //       text: value,
          //     )
          ));
    }
  }
}
