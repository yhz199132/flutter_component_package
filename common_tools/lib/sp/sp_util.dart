import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 作者：袁汉章 on 2022年09月06日 12:12
/// 邮箱：yhz199132@163.com
/// SharedPreferences工具类

class SpUtil {
  static final SpUtil _instance = SpUtil._internal();

  SpUtil._internal();

  // 工厂构造函数
  factory SpUtil() {
    return _instance;
  }

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// put object.
  Future<bool>? setObject(String key, Object value) {
    return _prefs?.setString(key, json.encode(value));
  }

  /// get obj.
  T? getObj<T>(String key, T Function(Map v) f, {T? defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  Map? getObject(String key) {
    String? data = _prefs?.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  /// get obj list.
  List<T>? getTList<T>(String key, T Function(Map v) f,
      {List<T>? defValue = const []}) {
    List? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  ///获取对象数组
  List? getObjectList(String key) {
    return getStringList(key)?.map((value) => json.decode(value)).toList();
  }

  ///保存对象数组
  Future<bool>? setObjectList(String key, List<Object>? list) {
    List<String>? dataList = list?.map((value) => json.encode(value)).toList();
    return setStringList(key, dataList ?? []);
  }

  ///获取字符串
  String? getString(String key, {String? defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  ///保存字符串
  Future<bool>? setString(String key, String value) {
    return _prefs?.setString(key, value);
  }

  ///获取布尔值
  bool? getBool(String key, {bool? defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  ///保存布尔值
  Future<bool>? setBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  /// 获取整数.
  int? getInt(String key, {int? defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  /// 保存整数
  Future<bool>? setInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  ///获取double.
  double? getDouble(String key, {double? defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  ///保存Double
  Future<bool>? setDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  ///获取字符串数组
  List<String>? getStringList(String key,
      {List<String>? defaultValue = const []}) {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  ///保存字符串数组
  Future<bool>? setStringList(String key, List<String> value) {
    return _prefs?.setStringList(key, value);
  }

  ///获取数据
  ///
  dynamic getValue(String key, {dynamic defaultValue}) {
    switch (defaultValue.runtimeType.toString()) {
      case 'String':
        return getString(key, defaultValue: defaultValue);
      case 'int':
        return getInt(key, defaultValue: defaultValue);
      case 'double':
        return getDouble(key, defaultValue: defaultValue);
      case 'bool':
        return getBool(key, defaultValue: defaultValue);
      case 'List<String>':
        return getStringList(key, defaultValue: defaultValue);
      default:
        return _prefs?.get(key) ?? defaultValue;
    }
  }

  ///保存数据
  ///
  Future<bool>? setValue(String key, dynamic value) {
    switch (value.runtimeType.toString()) {
      case 'String':
        return setString(key, value);
      case 'int':
        return setInt(key, value);
      case 'double':
        return setDouble(key, value);
      case 'bool':
        return setBool(key, value);
      case 'List<String>':
        return setStringList(key, value);
      default:
        return _prefs?.setString(key, jsonEncode(value));
    }
  }

  /// 根据key判断元素是否存在
  bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  /// 获取所有存储key
  Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  /// 根据key删除储存元素
  Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  /// 清空sp
  Future<bool>? clear() {
    return _prefs?.clear();
  }

  /// 重新加载
  Future<void>? reload() {
    return _prefs?.reload();
  }

  /// 获取sp是否初始化
  bool isInitialized() {
    return _prefs != null;
  }

  /// 获取sp对象
  SharedPreferences? getSp() {
    return _prefs;
  }
}
