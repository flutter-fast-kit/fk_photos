# fk_photos

[![Pub](https://img.shields.io/pub/v/fk_photos.svg)](https://pub.dartlang.org/packages/fk_photos)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)]()
[![Awesome Flutter](https://img.shields.io/badge/Platform-Android_iOS-blue.svg?longCache=true&style=flat-square)]()
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](/LICENSE)

基于 `loggy` 的二次封装

## 使用

🔩 安装

在 `pubspec.yaml` 添加依赖

```
dependencies:
  fk_photos: <last_version>
```

🔨 使用

## 1. `cameraPicker` 拍照/拍摄视频 <- Future<AssetEntity>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| isAllowRecording | 选择器是否可以录像 | bool | false | 
| isOnlyAllowRecording | 选择器是否可以录像 | bool | false | 
| enableAudio | 证件背面信息 | 选择器录像时是否需要录制声音 | false | 
| maximumRecordingDuration | 录制视频最长时长 | Duration | 15s | 
| resolutionPreset | 相机的分辨率预设 | ResolutionPreset | high | 

## 2. `albumPicker` 资源选择器(图片/视频) <- Future<List<AssetEntity>>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| selectedAssets | 默认选中的资源 | List<AssetEntity> | null | 
| requestType | 选择器选择资源的类型 | RequestType | image | 
| maxAssets | 最多选择的图片数量 | int | 1 | 

## 3. `deleteAsset` 删除资源文件 <- Future<bool>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| id | 资源id | String | null | 

## 4. `saveToAlbum` 保存图片到相册 <- Future<AssetEntity>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| url | 网络图片 | String | null | 
| asset | 资源文件 | AssetEntity | null | 
| base64Img | Base64 图片 | String | null | 
| uint8list | Uint8List | Uint8List | null | 
| path | 本地文件路径 | String | null | 

### 5. 压缩图片

### 5.1 `compressFile` 压缩图片 <- Future<Uint8List>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| file | 图片文件 | File | null | 
| minWidth | 最小宽度 | int | 1920 | 
| minHeight | 最小高度 图片 | int | 1080 | 
| quality | 质量 | int | 85 | 

### 5.2 `compressAndGetFile` 压缩图片 <- Future<File>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| file | 图片文件 | File | null | 
| targetPath | 保存路径 | String | null | 
| minWidth | 最小宽度 | int | 1920 | 
| minHeight | 最小高度 图片 | int | 1080 | 
| quality | 质量 | int | 85 | 

### 5.3 `compressAsset` 压缩图片 <- Future<Uint8List>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| assetName | 资源文件名称 | String | null | 
| minWidth | 最小宽度 | int | 1920 | 
| minHeight | 最小高度 图片 | int | 1080 | 
| quality | 质量 | int | 85 | 

### 5.4 `compressList` 压缩图片 <- Future<Uint8List>

| 参数     | 描述              | 类型  | 默认值 |
| -------- | ----------------- | ----- | ------ |
| list | Uint8List | Uint8List | null | 
| minWidth | 最小宽度 | int | 1920 | 
| minHeight | 最小高度 图片 | int | 1080 | 
| quality | 质量 | int | 85 | 

## 6. Extension

### 6.1 `AssetEntityExtension on AssetEntity`

- saveToAlbum: 保存到相册
- toBase64: 转为base64
- compress: 压缩文件, 压缩参数请参考 [FKPhotos.compressAndGetFile]

### 6.2 `Uint8ListExtension on Uint8List`

- toBase64: 转为base64

### 6.3 FileExtension on File

- toBase64: 转为base64

## 7. 快捷方法

### 7.1 showPhotoViewerDialog 显示图片弹窗

`showPhotoViewerDialog();`

### 7.2 showSelectPhotoPicker 拍照/相册弹窗

参数请参考 [FKPhotos.cameraPicker] 与 [FKPhotos.cameraPicker]

## Changelog

Refer to the [Changelog](CHANGELOG.md) to get all release notes.