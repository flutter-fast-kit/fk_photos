import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Langs {
  static final _langDic = {
    'zh_CN': {'take_pic': '拍照', 'choose_album': '相册中选择', 'cancel': '取消'},
    'zh_TW': {'take_pic': '拍照', 'choose_album': '相冊中選擇', 'cancel': '取消'},
    'en_US': {'take_pic': 'Take pictures', 'choose_album': 'Choose from album', 'cancel': 'Cancel'},
    'ko_KR': {'take_pic': '사진 을 찍다', 'choose_album': '앨범 선택', 'cancel': '취소 하 다'},
    'ja_JP': {'take_pic': 'カメラ', 'choose_album': 'アルバムから選択', 'cancel': 'キャンセル'},
    'fr_FR': {'take_pic': 'Prendre des photos', 'choose_album': 'Sélection dans l\'album', 'cancel': 'Annulation'},
    'es_ES': {'take_pic': 'Tomar fotos', 'choose_album': 'Selección del álbum', 'cancel': 'Cancelar'},
  };

  static String getLang(BuildContext context, String key) {
    final dic = _langDic['${context.locale.languageCode}_${context.locale.countryCode}'];
    return dic?[key] ?? _langDic['zh_TW']![key]!;
  }
}
