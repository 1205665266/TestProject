import 'dart:io';

import 'package:cotti_client/global/style.dart';
import 'package:cotti_client/pages/tabs/order/order_evaluate/entity/evaluate_config_entity.dart';
import 'package:cotti_client/sensors/evaluate_sensors_constant.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'asset_picker_view_builder_delegate.dart';

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/3 下午1:57
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// /////////////////////////////////////////////

enum OrderEvaluateEditType {
  order,
  commodity,
}

class EvaluateTextFieldPhoto extends StatefulWidget {
  const EvaluateTextFieldPhoto({
    Key? key,
    this.text = '',
    this.hintText = '',
    this.rating,
    this.itemModel,
    this.controller,
    this.inputCallBack,
    this.textFieldHeight,
    this.selectedAssets,
    this.editAssetsCallBack,
    this.orderEvaluateEditType = OrderEvaluateEditType.order,
  }) : super(key: key);

  final String text;
  final String hintText;
  final int? rating;
  final EvaluateConfigOrderItemList? itemModel;
  final TextEditingController? controller;
  final Function(String value)? inputCallBack;
  final double? textFieldHeight;

  final List<AssetEntity>? selectedAssets;
  final Function(List<AssetEntity>?)? editAssetsCallBack;
  final OrderEvaluateEditType orderEvaluateEditType;

  @override
  _EvaluateTextFieldPhotoState createState() => _EvaluateTextFieldPhotoState();
}

class _EvaluateTextFieldPhotoState extends State<EvaluateTextFieldPhoto> {
  /// controller
  late TextEditingController _textController;

  /// assets
  late List<AssetEntity> _selectedAssets;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _textController = widget.controller ?? TextEditingController();
    _textController.text = widget.text;

    _selectedAssets = widget.selectedAssets ?? [];

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        /// 判断是否是商品评价
        bool isP = widget.hintText.contains('产品');
        if (isP) {
          SensorsAnalyticsFlutterPlugin.track(
              EvaluateSensorsConstant.commodityEvaluateInputClick, {});
        } else {
          SensorsAnalyticsFlutterPlugin.track(EvaluateSensorsConstant.orderEvaluateInputClick, {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14.h, bottom: 1.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: CottiColor.backgroundColor,
        borderRadius: BorderRadius.circular(1.r),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: _buildTextFieldContent(),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              '${_textController.text.characters.length}/300',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xff5E5E5E),
              ),
            ),
          ),
          _buildBottomContent(),
        ],
      ),
    );
  }

  /// 构建TextField视图内容
  Widget _buildTextFieldContent() {
    return SizedBox(
      height: widget.textFieldHeight ?? 60.h,
      child: TextField(
        focusNode: _focusNode,
        controller: _textController,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF111111),
        ),
        strutStyle: const StrutStyle(height: 1.4),
        textAlign: TextAlign.left,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.multiline,
        maxLines: 300,
        inputFormatters: [LengthLimitingTextInputFormatter(300)],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF979797),
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          if (widget.inputCallBack != null) {
            widget.inputCallBack!(_textController.text);
          }
        },
      ),
    );
  }

  /// 构建添加图片视图内容
  Widget _buildBottomContent() {
    return GridView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 12.h),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 5.w,
      ),
      children: List.generate(
        widget.selectedAssets != null
            ? (widget.selectedAssets!.length < 9
                ? widget.selectedAssets!.length + 1
                : widget.selectedAssets!.length)
            : 1,
        (index) => _buildAddPhotoView(
          index,
          widget.selectedAssets != null ? (index >= widget.selectedAssets!.length) : true,
        ),
      ),
    );
  }

  /// 构建添加照片/浏览照片视图
  Widget _buildAddPhotoView(
    int index,
    bool isAddPhoto,
  ) {
    if (isAddPhoto) {
      return _buildAddPhotoContent(index);
    } else {
      return _buildBrowsePhotoContent(index);
    }
  }

  /// 构架添加图片视图样式
  Widget _buildAddPhotoContent(int index) {
    return GestureDetector(
      onTap: () {

        bool isP = widget.hintText.contains('产品');
        String key = isP ? EvaluateSensorsConstant.commodityEvaluateAddPhotoClick:EvaluateSensorsConstant.orderEvaluateAddPhotoClick;
        SensorsAnalyticsFlutterPlugin.track(key, {});
        _closeKeyboard(context);
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) {
            return Material(
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: const Center(
                          child: Text('拍照'),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();

                          /// 获取当前的权限
                          var status = await Permission.camera.status;
                          if (status == PermissionStatus.granted) {
                            /// 已经授权
                            _goPickFromCamera();
                          } else {
                            /// 如果用户拒绝了授权 不去请求权限
                            if (!SpUtil.getBool('camera_permission_denied')) {
                              /// 用户没用拒接，发起一次申请
                              status = await Permission.camera.request();
                              if (status == PermissionStatus.granted) {
                                _goPickFromCamera();
                              } else {
                                _showCameraPermissionDialog();
                              }
                            } else {
                              _showCameraPermissionDialog();
                            }
                          }
                        }),
                    ListTile(
                      title: const Center(
                        child: Text('从手机相册选择'),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();

                        /// 获取当前的权限
                        var status = Platform.isIOS
                            ? await Permission.photos.status
                            : await Permission.storage.status;
                        if (status == PermissionStatus.granted) {
                          /// 已经授权
                          _goPickAssets();
                        } else {
                          /// 如果用户拒绝了授权 不去请求权限
                          if (!SpUtil.getBool('photo_permission_denied')) {
                            /// 用户没用拒接，发起一次申请
                            status = Platform.isIOS
                                ? await Permission.photos.request()
                                : await Permission.storage.request();
                            if (status == PermissionStatus.granted) {
                              _goPickAssets();
                            } else {
                              SpUtil.putBool('photo_permission_denied', true);
                              _showPickAssetsPermissionDialog();
                            }
                          } else {
                            _showPickAssetsPermissionDialog();
                          }
                        }
                      },
                    ),
                    const Divider(height: 0.5),
                    ListTile(
                      title: const Center(
                        child: Text(
                          '取消',
                          style: TextStyle(color: CottiColor.primeColor),
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        color: Colors.transparent,
        height: 70.w,
        width: 70.w,
        child: Container(
          color: Colors.transparent,
          child: SvgPicture.asset(
            'assets/images/order/order_evaluate/ic_add_photo.svg',
            width: 70.w,
            height: 70.w,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  /// 从相机选择
  static Future<AssetEntity?> pickFromCamera(
    BuildContext context,
  ) async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      theme: CameraPicker.themeData(
        CottiColor.primeColor,
      ),
    );
    return entity;
  }

  /// 从相册选择
  static Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    int maxAssets = 9,
    List<AssetEntity>? selectedAssets,
    RequestType requestType = RequestType.image,
  }) async {
    final List<AssetEntity>? entities = await AssetPicker.pickAssets(
      context,
      maxAssets: maxAssets,
      requestType: requestType,
      selectedAssets: selectedAssets,
      themeColor: CottiColor.primeColor,
    );
    return entities;
  }

  /// 去拍照
  void _goPickFromCamera() async {
    final AssetEntity? entity = await pickFromCamera(
      context,
    );
    if (entity != null) {
      _selectedAssets.add(entity);
    }
    if (widget.editAssetsCallBack != null) {
      widget.editAssetsCallBack!(_selectedAssets);
    }
  }

  /// 图片预览
  static Future<List<AssetEntity>?> pushToViewer(
    BuildContext context, {
    required int currentIndex,
    required List<AssetEntity> previewAssets,
    List<AssetEntity>? selectedAssets,
  }) async {
    final List<AssetEntity>? result = await AssetPickerViewer.pushToViewerWithDelegate(
      context,
      delegate: CottiAssetPickerViewerBuilderDelegate(
        currentIndex: currentIndex,
        previewAssets: previewAssets,
        selectedAssets: selectedAssets,
        themeData: CameraPicker.themeData(
          CottiColor.primeColor,
        ),
        provider:
            selectedAssets != null ? AssetPickerViewerProvider<AssetEntity>(selectedAssets) : null,
      ),
    );
    return result;
  }

  /// 展示拍照授权弹窗
  void _showCameraPermissionDialog() {
    _showPermissionDialog(
        '相机权限未开启',
        Platform.isIOS
            ? '请在设置->库迪咖啡->相机服务中打开开关，并允许库迪咖啡使用相机服务'
            : '请在系统设置->隐私->相机服务中打开开关，并允许库迪咖啡使用相机服务');
  }

  /// 去选择图片
  void _goPickAssets() async {
    final List<AssetEntity>? assets = await pickAssets(
      context,
      selectedAssets: _selectedAssets,
    );
    if (assets != null) {
      _selectedAssets = assets;
    }
    if (widget.editAssetsCallBack != null) {
      widget.editAssetsCallBack!(_selectedAssets);
    }
  }

  /// 展示选择图片授权弹窗
  void _showPickAssetsPermissionDialog() {
    _showPermissionDialog(
        '相册权限未开启',
        Platform.isIOS
            ? '请在设置->库迪咖啡->相册服务中打开开关，并允许库迪咖啡使用相册服务'
            : '请在系统设置->隐私->存储服务中打开开关，并允许库迪咖啡使用相册服务');
  }

  /// 构架浏览图片视图样式
  Widget _buildBrowsePhotoContent(
    int index,
  ) {
    AssetEntity entity = widget.selectedAssets![index];
    return GestureDetector(
      onTap: () async {
        _closeKeyboard(context);
        final List<AssetEntity>? result = await pushToViewer(
          context,
          currentIndex: index,
          previewAssets: _selectedAssets,
          selectedAssets: _selectedAssets,
        );
        _selectedAssets = result ?? [];
        if (widget.editAssetsCallBack != null) {
          widget.editAssetsCallBack!(_selectedAssets);
        }
      },
      child: Container(
        // color: Colors.green,
        child: SizedBox(
          width: 70.w,
          height: 70.w,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2.w),
                child: Image(
                  image: AssetEntityImageProvider(
                    entity,
                    scale: 0.8,
                    isOriginal: false,
                    thumbSize: const <int>[
                      170,
                      170,
                    ],
                  ),
                  width: 70.w,
                  height: 70.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _closeKeyboard(context);
                    if (_selectedAssets.length >= index) {
                      _selectedAssets.removeAt(index);
                    }
                    if (widget.editAssetsCallBack != null) {
                      widget.editAssetsCallBack!(_selectedAssets);
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/order/order_evaluate/ic_btn_photo_delete.svg',
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 选择弹窗视图
  void _showPermissionDialog(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('取消'),
              onPressed: () {
                NavigatorUtils.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('去开启'),
              onPressed: () async {
                openAppSettings();
                NavigatorUtils.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 收起键盘
  void _closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    /// 键盘是否是弹起状态
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _textController.removeListener(() {});
    super.dispose();
  }
}
