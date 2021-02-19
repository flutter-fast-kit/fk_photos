part of fk_photos;

/// 显示图片弹窗
///
/// [imageProvider] 图片 （AssetImage(fs.path)）
void showPhotoViewerDialog(BuildContext context,
    {@required ImageProvider imageProvider}) {
  showDialog<void>(
      useSafeArea: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            child: GestureDetector(
              onTapDown: (_) {
                Navigator.pop(context);
              },
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained * 0.5,
                maxScale: PhotoViewComputedScale.contained * 3,
                // tightMode: false,
                imageProvider: imageProvider,
                // heroAttributes: const PhotoViewHeroAttributes(tag: 'someTag'),
              ),
            ),
          ),
        );
      });
}

/// 快速选择
///
/// 参数请参考 [FKPhotos.cameraPicker] 与 [FKPhotos.cameraPicker]
void showSelectPhotoPicker(
  BuildContext context, {
  bool isAllowRecording = false,
  bool isOnlyAllowRecording = false,
  bool enableAudio = false,
  Duration maximumRecordingDuration = const Duration(seconds: 15),
  ResolutionPreset resolutionPreset = ResolutionPreset.high,
  List<AssetEntity> selectedAssets,
  RequestType requestType = RequestType.image,
  int maxAssets = 1,
  ValueChanged<AssetEntity> onCameraCallback,
  ValueChanged<List<AssetEntity>> onAlbumCallback,
}) {
  showActionSheet<void>(
      context: context,
      actions: [
        ActionItem(
            title: Langs.getLang(context, 'take_pic'),
            onPressed: () async {
              Navigator.pop(context);
              final AssetEntity asset = await FKPhotos.cameraPicker(context,
                  isAllowRecording: isAllowRecording,
                  isOnlyAllowRecording: isOnlyAllowRecording,
                  enableAudio: enableAudio,
                  maximumRecordingDuration: maximumRecordingDuration,
                  resolutionPreset: resolutionPreset);
              if (onCameraCallback != null) {
                onCameraCallback(asset);
              }
            }),
        ActionItem(
            title: Langs.getLang(context, 'choose_album'),
            onPressed: () async {
              Navigator.pop(
                context,
              );
              final List<AssetEntity> assets = await FKPhotos.albumPicker(
                  context,
                  selectedAssets: selectedAssets,
                  requestType: requestType,
                  maxAssets: maxAssets);
              if (onAlbumCallback != null) {
                onAlbumCallback(assets);
              }
            })
      ],
      bottomActionItem: BottomActionItem(title: Langs.getLang(context, 'cancel')));
}

/// 图片操作工具类
/// 拍照/录像/媒体选择/图片压缩
///
class FKPhotos {
  /// 拍照/视频
  ///
  /// [isAllowRecording] 选择器是否可以录像
  /// [isOnlyAllowRecording] 选择器是否可以录像
  /// [enableAudio] 选择器录像时是否需要录制声音
  /// [maximumRecordingDuration] 录制视频最长时长
  /// [resolutionPreset] 相机的分辨率预设
  static Future<AssetEntity> cameraPicker(BuildContext context,
      {bool isAllowRecording = false,
      bool isOnlyAllowRecording = false,
      bool enableAudio = false,
      Duration maximumRecordingDuration = const Duration(seconds: 15),
      ResolutionPreset resolutionPreset = ResolutionPreset.high}) async {
    /// 拉起相机
    final AssetEntity entity = await CameraPicker.pickFromCamera(context,
        isAllowRecording: isAllowRecording,
        isOnlyAllowRecording: isOnlyAllowRecording,
        enableAudio: enableAudio,
        maximumRecordingDuration: maximumRecordingDuration,
        resolutionPreset: resolutionPreset);
    return entity;
  }

  /// 删除资源文件
  ///
  /// [id] assetEntity id
  static Future<bool> deleteAsset(String id) async {
    final List<String> result = await PhotoManager.editor.deleteWithIds([id]);
    return result.isNotEmpty;
  }

  /// 资源选择器(图片/视频)
  ///
  /// [selectedAssets] 默认选中的资源
  /// [requestType] 选择器选择资源的类型
  /// [maxAssets] 最多选择的图片数量
  static Future<List<AssetEntity>> albumPicker(
    BuildContext context, {
    List<AssetEntity> selectedAssets,
    RequestType requestType = RequestType.image,
    int maxAssets = 1,
  }) async {
    final List<AssetEntity> assets = await AssetPicker.pickAssets(context,
        selectedAssets: selectedAssets,
        requestType: requestType,
        maxAssets: maxAssets);
    return assets;
  }

  /// 保存图片到相册
  ///
  /// [url] 网络图片
  /// [asset] AssetEntity 资源文件
  /// [base64Img] Base64 图片
  /// [uint8list] then [Uint8List] type
  /// [path] 本地文件路径
  static Future<AssetEntity> saveToAlbum(
      {String url, AssetEntity asset, String base64Img, Uint8List uint8list, String path}) async {
    if (uint8list != null) {
      return await PhotoManager.editor.saveImage(uint8list);
    } else if (base64Img != null) {
      final Uint8List bytes = base64.decode(base64Img);
      return await PhotoManager.editor.saveImage(bytes);
    } else if (asset != null) {
      return asset.saveToAlbum();
    } else if (path != null) {
      final File file = File(path);
      final Uint8List byteData = await file.readAsBytes();
      return await PhotoManager.editor.saveImage(byteData);
    } else if (url != null) {
      final Uint8List data = await getNetworkImageData(url, useCache: false);
      return await PhotoManager.editor.saveImage(data);
    }
    return Future.value(null);
  }

  /// 压缩图片
  ///
  /// [file] 文件
  /// [minWidth] 宽度
  /// [minHeight] 高度
  /// [quality] 质量
  static Future<Uint8List> compressFile(File file,
      {int minWidth = 1920, int minHeight = 1080, int quality = 85}) async {
    final Uint8List result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    return result;
  }

  /// 压缩图片
  ///
  /// [file] 文件
  /// [targetPath] 保存路径
  /// [minWidth] 宽度
  /// [minHeight] 高度
  /// [quality] 质量
  static Future<File> compressAndGetFile(File file, String targetPath,
      {int minWidth = 1920, int minHeight = 1080, int quality = 85}) async {
    final File result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    return result;
  }

  /// 压缩图片
  ///
  /// [assetName] 资源文件名称
  /// [minWidth] 宽度
  /// [minHeight] 高度
  /// [quality] 质量
  static Future<Uint8List> compressAsset(String assetName,
      {int minWidth = 1920, int minHeight = 1080, int quality = 85}) async {
    final Uint8List result = await FlutterImageCompress.compressAssetImage(
      assetName,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );

    return result;
  }

  /// 压缩图片
  ///
  /// [list] the [Uint8List]
  /// [minWidth] 宽度
  /// [minHeight] 高度
  /// [quality] 质量
  static Future<Uint8List> compressList(Uint8List list,
      {int minWidth = 1920, int minHeight = 1080, int quality = 85}) async {
    final Uint8List result = await FlutterImageCompress.compressWithList(
      list,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    return result;
  }
}

/// 扩展 AssetEntity
///
extension AssetEntityExtension on AssetEntity {
  /// 保存到相册
  Future<AssetEntity> saveToAlbum() async {
    return await PhotoManager.editor.saveImage(await originBytes);
  }

  /// 转为base64
  Future<String> toBase64() async {
    final Uint8List u8l = await originBytes;
    return base64.encode(u8l.toList());
  }

  /// 压缩文件
  ///
  /// 压缩参数请参考 [FKPhotos.compressAndGetFile]
  Future<File> compress(
      {int minWidth = 1920, int minHeight = 1080, int quality = 85}) async {
    final String tempFilePath = await _generateTempFilePath();
    return FKPhotos.compressAndGetFile(await originFile, tempFilePath,
        minWidth: minWidth, minHeight: minHeight, quality: quality);
  }
}

/// 扩展 uint8List
extension Uint8ListExtension on Uint8List {
  /// 转为base64
  String toBase64() {
    return base64.encode(toList());
  }
}

/// 扩展File
extension FileExtension on File {
  /// 转为base64
  Future<String> toBase64() async {
    return (await readAsBytes()).toBase64();
  }
}

/// 生成临时文件
Future<String> _generateTempFilePath() async {
  final Directory tempDir = await getTemporaryDirectory();
  final Directory imgTempDir = Directory('${tempDir.path}/IMG_TEMP');
  if (!imgTempDir.existsSync()) {
    await imgTempDir.create();
  }
  final String fileName = Uuid().v4() + '.jpg';
  return '${imgTempDir.path}/$fileName';
}
