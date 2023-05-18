import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:extended_image/extended_image.dart';
import 'package:wechat_assets_picker/src/widget/custom_checkbox.dart';

import 'package:wechat_assets_picker/src/widget/scale_text.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:wechat_assets_picker/src/widget/builder/audio_page_builder.dart';
import 'package:wechat_assets_picker/src/widget/builder/image_page_builder.dart';
import 'package:wechat_assets_picker/src/widget/builder/video_page_builder.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/src/widget/scale_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/src/constants/custom_scroll_physics.dart';
import 'package:wechat_assets_picker/src/constants/extensions.dart';
import 'package:wechat_assets_picker/src/widget/builder/value_listenable_builder_2.dart';
import 'package:provider/provider.dart';


class CottiAssetPickerViewerBuilderDelegate
    extends AssetPickerViewerBuilderDelegate<AssetEntity, AssetPathEntity> {
  CottiAssetPickerViewerBuilderDelegate({
    required int currentIndex,
    required List<AssetEntity> previewAssets,
    AssetPickerProvider<AssetEntity, AssetPathEntity>? selectorProvider,
    required ThemeData themeData,
    AssetPickerViewerProvider<AssetEntity>? provider,
    List<AssetEntity>? selectedAssets,
    this.previewThumbSize,
    this.specialPickerType,
    int? maxAssets,
    bool shouldReversePreview = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
  }) : super(
    currentIndex: currentIndex,
    previewAssets: previewAssets,
    provider: provider,
    themeData: themeData,
    selectedAssets: selectedAssets,
    selectorProvider: selectorProvider,
    maxAssets: maxAssets,
    shouldReversePreview: shouldReversePreview,
    selectPredicate: selectPredicate,
  );

  /// Thumb size for the preview of images in the viewer.
  /// 预览时图片的缩略图大小
  final List<int>? previewThumbSize;

  /// The current special picker type for the viewer.
  /// 当前特殊选择类型
  ///
  /// If the type is not null, the title of the viewer will not display.
  /// 如果类型不为空，则标题将不会显示。
  final SpecialPickerType? specialPickerType;

  /// Whether the [SpecialPickerType.wechatMoment] is enabled.
  /// 当前是否为微信朋友圈选择模式
  bool get isWeChatMoment =>
      specialPickerType == SpecialPickerType.wechatMoment;

  /// Whether there are videos in preview/selected assets.
  /// 当前正在预览或已选的资源是否有视频
  bool get hasVideo =>
      previewAssets.any((AssetEntity e) => e.type == AssetType.video) ||
          (selectedAssets?.any((AssetEntity e) => e.type == AssetType.video) ??
              false);

  /// Sync selected assets currently with asset picker provider.
  /// 在预览中当前已选的图片同步到选择器的状态
  @override
  Future<bool> syncSelectedAssetsWhenPop() async {
    if (provider?.currentlySelectedAssets != null) {
      selectorProvider?.selectedAssets = provider!.currentlySelectedAssets;
    }
    return false;
  }

  @override
  Widget assetPageBuilder(BuildContext context, int index) {
    final AssetEntity asset = previewAssets.elementAt(index);
    Widget _builder;
    switch (asset.type) {
      case AssetType.audio:
        _builder = AudioPageBuilder(asset: asset);
        break;
      case AssetType.image:
        _builder = ImagePageBuilder(
          asset: asset,
          delegate: this,
          previewThumbSize: previewThumbSize,
        );
        break;
      case AssetType.video:
        _builder = VideoPageBuilder(
          asset: asset,
          delegate: this,
          hasOnlyOneVideoAndMoment: isWeChatMoment && hasVideo,
        );
        break;
      case AssetType.other:
        _builder = Center(
          child: ScaleText(Constants.textDelegate.unSupportedAssetType),
        );
        break;
    }
    return _builder;
  }

  /// Preview item widgets for audios.
  /// 音频的底部预览部件
  Widget _audioPreviewItem(AssetEntity asset) {
    return ColoredBox(
      color: viewerState.context.themeData.dividerColor,
      child: const Center(child: Icon(Icons.audiotrack)),
    );
  }

  /// Preview item widgets for images.
  /// 图片的底部预览部件
  Widget _imagePreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: ExtendedImage(
          image: AssetEntityImageProvider(asset, isOriginal: false),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Preview item widgets for video.
  /// 视频的底部预览部件
  Widget _videoPreviewItem(AssetEntity asset) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          _imagePreviewItem(asset),
          Center(
            child: Icon(
              Icons.video_library,
              color: themeData.iconTheme.color?.withOpacity(0.54),
            ),
          ),
        ],
      ),
    );
  }

  /// The back button when previewing video in [SpecialPickerType.wechatMoment].
  /// 使用 [SpecialPickerType.wechatMoment] 预览视频时的返回按钮
  Widget momentVideoBackButton(BuildContext context) {
    return PositionedDirectional(
      start: 16,
      top: context.topPadding + 16,
      child: GestureDetector(
        onTap: Navigator.of(context).maybePop,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: themeData.iconTheme.color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_return_rounded,
            color: themeData.canvasColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget bottomDetailBuilder(BuildContext context) {
    final Color _backgroundColor = themeData.primaryColor.withOpacity(.9);
    return ValueListenableBuilder2<bool, int>(
      firstNotifier: isDisplayingDetail,
      secondNotifier: selectedNotifier,
      builder: (_, bool v, __, Widget? child) => AnimatedPositionedDirectional(
        duration: kThemeAnimationDuration,
        curve: Curves.easeInOut,
        bottom: v ? 0 : -(context.bottomPadding + bottomDetailHeight),
        start: 0,
        end: 0,
        height: context.bottomPadding + bottomDetailHeight,
        child: child!,
      ),
      child:
      ChangeNotifierProvider<AssetPickerViewerProvider<AssetEntity>?>.value(
        value: provider,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (provider != null)
              ValueListenableBuilder<int>(
                valueListenable: selectedNotifier,
                builder: (_, int count, __) => Container(
                  width: count > 0 ? double.maxFinite : 0,
                  height: bottomPreviewHeight,
                  color: _backgroundColor,
                  child: ListView.builder(
                    controller: previewingListController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    physics: const ClampingScrollPhysics(),
                    itemCount: count,
                    itemBuilder: bottomDetailItemBuilder,
                  ),
                ),
              ),
            Container(
              height: bottomBarHeight + context.bottomPadding,
              padding: const EdgeInsets.symmetric(horizontal: 20.0)
                  .copyWith(bottom: context.bottomPadding),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: themeData.canvasColor,
                  ),
                ),
                color: _backgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Spacer(),
                  if (isAppleOS && (provider != null || isWeChatMoment))
                    confirmButton(context)
                  else
                    selectButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget bottomDetailItemBuilder(BuildContext context, int index) {
    const double padding = 8.0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 2,
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: StreamBuilder<int>(
          initialData: currentIndex,
          stream: pageStreamController.stream,
          builder: (_, AsyncSnapshot<int> snapshot) {
            final AssetEntity asset = selectedAssets!.elementAt(index);
            final bool isViewing = previewAssets[snapshot.data!] == asset;
            final Widget _item = () {
              switch (asset.type) {
                case AssetType.image:
                  return _imagePreviewItem(asset);
                case AssetType.video:
                  return _videoPreviewItem(asset);
                case AssetType.audio:
                  return _audioPreviewItem(asset);
                default:
                  return const SizedBox.shrink();
              }
            }();
            return GestureDetector(
              onTap: () {
                if (pageController.page == index.toDouble()) {
                  return;
                }
                final int page;
                if (previewAssets != selectedAssets) {
                  page = previewAssets.indexOf(asset);
                } else {
                  page = index;
                }
                pageController.jumpToPage(page);
                final double offset =
                    (index - 0.5) * (bottomPreviewHeight - padding * 3) -
                        context.mediaQuery.size.width / 4;
                previewingListController.animateTo(
                  math.max(0, offset),
                  curve: Curves.ease,
                  duration: kThemeChangeDuration,
                );
              },
              child: Selector<AssetPickerViewerProvider<AssetEntity>?,
                  List<AssetEntity>?>(
                selector: (_, AssetPickerViewerProvider<AssetEntity>? p) =>
                p?.currentlySelectedAssets,
                child: _item,
                builder: (
                    _,
                    List<AssetEntity>? currentlySelectedAssets,
                    Widget? w,
                    ) {
                  final bool isSelected =
                      currentlySelectedAssets?.contains(asset) ?? false;
                  return Stack(
                    children: <Widget>[
                      w!,
                      AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          border: isViewing
                              ? Border.all(
                            color: themeData.colorScheme.secondary,
                            width: 3,
                          )
                              : null,
                          color: isSelected
                              ? null
                              : themeData.colorScheme.surface.withOpacity(0.54),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// AppBar widget.
  /// 顶栏部件
  Widget appBar(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, Widget? child) => AnimatedPositionedDirectional(
        duration: kThemeAnimationDuration,
        curve: Curves.easeInOut,
        top: value ? 0.0 : -(context.topPadding + kToolbarHeight),
        start: 0.0,
        end: 0.0,
        height: context.topPadding + kToolbarHeight,
        child: child!,
      ),
      child: Container(
        padding: EdgeInsetsDirectional.only(top: context.topPadding),
        color: themeData.canvasColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(selectedAssets ?? <AssetEntity>[currentAsset]);
                    }),
                const Spacer(),
                if (isAppleOS && provider != null) selectButton(context),
                if (!isAppleOS && (provider != null || isWeChatMoment))
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 14),
                    child: confirmButton(context),
                  ),
              ],
            ),
            if (!isAppleOS && specialPickerType == null)
              StreamBuilder<int>(
                initialData: currentIndex,
                stream: pageStreamController.stream,
                builder: (_, AsyncSnapshot<int> snapshot) => Center(
                  child: ScaleText(
                    '${snapshot.data! + 1}/${previewAssets.length}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// It'll pop with [AssetPickerProvider.selectedAssets] when there are
  /// any assets were chosen. Then, the assets picker will pop too.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  /// 资源选择器将识别并一同返回。
  @override
  Widget confirmButton(BuildContext context) {
    return ChangeNotifierProvider<
        AssetPickerViewerProvider<AssetEntity>?>.value(
      value: provider,
      child: Consumer<AssetPickerViewerProvider<AssetEntity>?>(
        builder: (_, AssetPickerViewerProvider<AssetEntity>? provider, __) {
          assert(
          isWeChatMoment || provider != null,
          'Viewer provider must not be null'
              'when the special type is not WeChat moment.',
          );
          return MaterialButton(
            minWidth: () {
              if (isWeChatMoment && hasVideo) {
                return 48.0;
              }
              return provider!.isSelectedNotEmpty ? 48.0 : 20.0;
            }(),
            height: 32.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: themeData.colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: ScaleText(
                  () {
                if (isWeChatMoment && hasVideo) {
                  return Constants.textDelegate.confirm;
                }
                if (provider!.isSelectedNotEmpty) {
                  return '${Constants.textDelegate.confirm}'
                      ' (${provider.currentlySelectedAssets.length}'
                      '/'
                      '${previewAssets.length})';
                }
                return Constants.textDelegate.confirm;
              }(),
              style: TextStyle(
                color: themeData.textTheme.bodyText1?.color,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              if (isWeChatMoment && hasVideo) {
                Navigator.of(context).pop(<AssetEntity>[currentAsset]);
                return;
              }
              if (provider!.currentlySelectedAssets.isEmpty) {
                Navigator.of(context).pop(provider.currentlySelectedAssets);
                return;
              }
              if (provider.isSelectedNotEmpty) {
                Navigator.of(context).pop(provider.currentlySelectedAssets);
                return;
              }
              selectAsset(currentAsset);
              Navigator.of(context).pop(
                selectedAssets ?? <AssetEntity>[currentAsset],
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  /// Select button for apple OS.
  /// 苹果系列系统的选择按钮
  Widget _appleOSSelectButton(
      BuildContext context,
      bool isSelected,
      AssetEntity asset,
      ) {
    if (!isSelected && selectedMaximumAssets) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChangingSelected(context, asset, isSelected),
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          width: 28.0,
          decoration: BoxDecoration(
            border: !isSelected
                ? Border.all(color: themeData.iconTheme.color!)
                : null,
            color: isSelected ? themeData.colorScheme.secondary : null,
            shape: BoxShape.circle,
          ),
          child: const Center(child: Icon(Icons.check, size: 20.0)),
        ),
      ),
    );
  }

  /// Select button for Android.
  /// 安卓系统的选择按钮
  Widget _androidSelectButton(
      BuildContext context,
      bool isSelected,
      AssetEntity asset,
      ) {
    return CustomCheckbox(
      value: isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999999),
      ),
      onChanged: (_) => onChangingSelected(context, asset, isSelected),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget selectButton(BuildContext context) {
    return Row(
      children: <Widget>[
        StreamBuilder<int>(
          initialData: currentIndex,
          stream: pageStreamController.stream,
          builder: (BuildContext _, AsyncSnapshot<int> snapshot) {
            return ChangeNotifierProvider<
                AssetPickerViewerProvider<AssetEntity>>.value(
              value: provider!,
              child: Selector<AssetPickerViewerProvider<AssetEntity>,
                  List<AssetEntity>>(
                selector: (
                    _,
                    AssetPickerViewerProvider<AssetEntity> p,
                    ) =>
                p.currentlySelectedAssets,
                builder: (
                    BuildContext c,
                    List<AssetEntity> currentlySelectedAssets,
                    __,
                    ) {
                  final AssetEntity asset = previewAssets.elementAt(
                    snapshot.data!,
                  );
                  final bool isSelected = currentlySelectedAssets.contains(
                    asset,
                  );
                  if (isAppleOS) {
                    return _appleOSSelectButton(c, isSelected, asset);
                  }
                  return _androidSelectButton(c, isSelected, asset);
                },
              ),
            );
          },
        ),
        if (!isAppleOS)
          ScaleText(
            Constants.textDelegate.select,
            style: const TextStyle(fontSize: 17, height: 1),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: syncSelectedAssetsWhenPop,
      child: Theme(
        data: themeData,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeData.appBarTheme.systemOverlayStyle ??
              (themeData.effectiveBrightness.isDark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark),
          child: Material(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ExtendedImageGesturePageView.builder(
                    physics: previewAssets.length == 1
                        ? const CustomClampingScrollPhysics()
                        : const CustomBouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: previewAssets.length,
                    itemBuilder: assetPageBuilder,
                    reverse: shouldReversePreview,
                    onPageChanged: (int index) {
                      currentIndex = index;
                      pageStreamController.add(index);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                if (isWeChatMoment && hasVideo) ...<Widget>[
                  momentVideoBackButton(context),
                  PositionedDirectional(
                    end: 16,
                    bottom: context.bottomPadding + 16,
                    child: confirmButton(context),
                  ),
                ] else ...<Widget>[
                  appBar(context),
                  if (selectedAssets != null ||
                      (isWeChatMoment && hasVideo && isAppleOS))
                    bottomDetailBuilder(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}