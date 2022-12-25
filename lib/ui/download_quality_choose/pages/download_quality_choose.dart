import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receivesharing/constants/Constants.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/GetDataYoutubeByDataType.dart';
import '../../../repository/GetYoutubeMedaData.dart';
import '../../../util/Injector.dart';
import '../../../util/download_helper.dart';
import 'my_bottom_sheet.dart';

class YoutubeDownloaderPage extends StatefulWidget {
  final String? url;
  YoutubeDownloaderPage({this.url});
  @override
  State<YoutubeDownloaderPage> createState() => _YoutubeDownloaderPageState();
}

class _YoutubeDownloaderPageState extends State<YoutubeDownloaderPage> {
  final Dio dio = locator<Dio>();
  DownloaderHelper downloaderHelper = DownloaderHelper();

  TextEditingController _controller = TextEditingController();
  GetYoutubeMedaData getYoutubeMedaData = GetYoutubeMedaData();
  String thumbb = "";
  String title = "";
  String resultInMp3 = "";
  String resultInMp4 = "";
  String qualityInMp3 = "";
  String qualityInMp4 = "";
  String sizeInMp3 = "";
  String sizeInMp4 = "";
  String progress = "";
  bool isLoading = false;
  bool isError = false;
  bool isDownloadingMp3 = false;
  int downloadingMp4Idx = -1;
  List<String> availableQuality = [];
  List<GetDataYoutubeByDataType> infoByQuality = [];
  void searchData(String url) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    await getYoutubeMedaData.getData(url, '144').then((response) {
      // infoByQuality.add(response);
      availableQuality = response.pilihan_type.split(',');

      setState(() {
        title = response.title;
        resultInMp3 = response.audioData.audio;
        resultInMp4 = response.mp4Data.download;
        // qualityInMp3 = response.mp4Data.type_download;
        qualityInMp4 = response.mp4Data.type_download;
        sizeInMp3 = response.audioData.size;
        sizeInMp4 = response.mp4Data.size;
        thumbb = response.thumbnail;
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }).whenComplete(() async {
      for (final q in availableQuality) {
        await getYoutubeMedaData.getData(url, q).then((response) {
          infoByQuality.add(response);
        });
        setState(() {});
      }

      //
    });
  }

  Future<void> downloadVideo(
      String trackURL, String trackName, String format, int index) async {
    double sizeOfDownloadInKb = -1;
    trackName = trackName + " - " + Constants.appName;
    setState(() {
      if (format.contains('mp3')) {
        isDownloadingMp3 = true;
        sizeOfDownloadInKb = sizeInKb(sizeInMp3);
      } else {
        downloadingMp4Idx = index;
        sizeOfDownloadInKb = sizeInKb(infoByQuality[index].mp4Data.size);
      }
    });

    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      Directory directory =
          await DownloadsPath.downloadsDirectory() ?? Directory('');
      print("${directory.path}/" +
          trackName
              .replaceAll(new RegExp(r'[^\w\s]+'), '')
              .split(" ")
              .join("") +
          format);
      await dio.download(trackURL, "${directory.path}/" + trackName + format,
          onReceiveProgress: (rec, total) {
        setState(() {
          // if (total != -1) {
          print('${rec / 1024} : $sizeOfDownloadInKb');
          progress =
              (rec / 1024 / sizeOfDownloadInKb * 100).toStringAsFixed(0) + "%";
          // }
        });
      }).whenComplete(() {
        setState(() {
          progress = '100 %';
        });
      });
      setState(() {
        if (progress.contains('100')) {
          if (format.contains('mp3')) {
            isDownloadingMp3 = false;
          } else {
            downloadingMp4Idx = -1;
          }
          progress = "Download Successful";
        }
      });
    } catch (e) {
      setState(() {
        if (format.contains('mp3')) {
          isDownloadingMp3 = false;
        } else {
          downloadingMp4Idx = -1;
        }
        progress = "Download Failed";
      });
    }
  }

  double sizeInKb(String size) {
    final idx = size.indexOf(' ');
    if (size.contains('KB')) {
      return double.parse(size.substring(0, idx).trim());
    } else if (size.contains('MB')) {
      return double.parse(size.substring(0, idx).trim()) * 1024;
    } else if (size.contains('GB')) {
      return double.parse(size.substring(0, idx).trim()) * 1048576;
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      // searchData(widget.url!);
      _validate(widget.url!);
    }
    print('url' + widget.url.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: ColorConstants.offWhiteColor, fontSize: 16),
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter your Youtube Video link here...',
              hintStyle: TextStyle(color: ColorConstants.offWhiteColor),
              // sty: TextStyle(color: ColorConstants.offWhiteColor),
              suffixIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  // searchData(_controller.text);
                  // _validate();
                },
                icon: Icon(Icons.search),
              ),
            ),
            onSubmitted: _validate,
            textInputAction: TextInputAction.search,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : isError
                    ? Center(
                        child: Text(
                          'Something wrong...',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder.png',
                              image: thumbb,
                              height: 150,
                              width: 350,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(color: Colors.white);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              title.isEmpty
                                  ? 'Nothing\'s here,\n\nAdd Link above'
                                  : 'Title: $title',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: sizeInMp3 == "" ? false : true,
                              child: TextButton(
                                child: Text(
                                  isDownloadingMp3
                                      ? 'Downloading...'
                                      : "Download MP3 ($sizeInMp3)"
                                          .toUpperCase(),
                                  style: TextStyle(fontSize: 14),
                                ),
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15),
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                                onPressed:
                                    isDownloadingMp3 || downloadingMp4Idx != -1
                                        ? null
                                        : () {
                                            downloadVideo(
                                                resultInMp3, title, '.mp3', -1);
                                          },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...List.generate(infoByQuality.length, (index) {
                              return downloadVideoByQuality(index);
                            }),
                            infoByQuality.length != availableQuality.length
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Visibility(
                              visible: progress == "" ? false : true,
                              child: Text(
                                'Download Progress: $progress',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget downloadVideoByQuality(
    int index,
  ) {
    return Column(
      children: [
        Visibility(
          visible: infoByQuality[index].mp4Data.size == "" ? false : true,
          child: TextButton(
            child: Text(
              downloadingMp4Idx == index
                  ? 'Downloading...'
                  : "Download MP4 (${infoByQuality[index].mp4Data.type_download}, ${infoByQuality[index].mp4Data.size})"
                      .toUpperCase(),
              style: TextStyle(fontSize: 14),
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(15),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
            onPressed: isDownloadingMp3 || downloadingMp4Idx != -1
                ? null
                : () {
                    downloadVideo(infoByQuality[index].mp4Data.download,
                        infoByQuality[index].title, '.mp4', index);
                  },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void _validate(String url) async {
    bool isDownloading = isDownloadingMp3 || downloadingMp4Idx != -1;

    setState(() {
      isLoading = true;
    });
    var data = await downloaderHelper.getVideoInfo(Uri.parse(url));
    setState(() {
      isLoading = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) => MyBottomSheet(
              imageUrl: data['image'].toString(),
              title: data['title'],
              author: data["author"],
              duration: data['duration'].toString(),
              mp3Size: data['mp3'],
              mp4Size: data['mp4'],
              mp3Method: () async {
                setState(() {
                  isDownloading = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Audio Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp3(data['id'], data['title']);
                setState(() {
                  isDownloading = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Audio Downloaded')
                        ],
                      )));
                });
              },
              isDownloading: isDownloading,
              mp4Method: () async {
                setState(() {
                  isDownloading = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Video Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp4(data['id'], data['title']);
                setState(() {
                  isDownloading = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Video Downloaded')
                        ],
                      )));
                });
              },
            ));
  }
}
