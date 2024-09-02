/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsColorsGen {
  const $AssetsColorsGen();

  /// File path: assets/colors/color_pallet.xml
  String get colorPallet => 'assets/colors/color_pallet.xml';

  /// List of all assets
  List<String> get values => [colorPallet];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Caret Icon.png
  AssetGenImage get caretIcon =>
      const AssetGenImage('assets/images/Caret Icon.png');

  /// File path: assets/images/back_blinko.png
  AssetGenImage get backBlinko =>
      const AssetGenImage('assets/images/back_blinko.png');

  /// File path: assets/images/background_image.png
  AssetGenImage get backgroundImage =>
      const AssetGenImage('assets/images/background_image.png');

  /// File path: assets/images/bitcoin_logo.png
  AssetGenImage get bitcoinLogo =>
      const AssetGenImage('assets/images/bitcoin_logo.png');

  /// File path: assets/images/check_icon.png
  AssetGenImage get checkIcon =>
      const AssetGenImage('assets/images/check_icon.png');

  /// File path: assets/images/ethereum_logo.png
  AssetGenImage get ethereumLogo =>
      const AssetGenImage('assets/images/ethereum_logo.png');

  /// File path: assets/images/home_icon.png
  AssetGenImage get homeIcon =>
      const AssetGenImage('assets/images/home_icon.png');

  /// File path: assets/images/solana_logo.png
  AssetGenImage get solanaLogo =>
      const AssetGenImage('assets/images/solana_logo.png');

  /// File path: assets/images/soloana_icon.png
  AssetGenImage get soloanaIcon =>
      const AssetGenImage('assets/images/soloana_icon.png');

  /// File path: assets/images/tether_logo.png
  AssetGenImage get tetherLogo =>
      const AssetGenImage('assets/images/tether_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        caretIcon,
        backBlinko,
        backgroundImage,
        bitcoinLogo,
        checkIcon,
        ethereumLogo,
        homeIcon,
        solanaLogo,
        soloanaIcon,
        tetherLogo
      ];
}

class Assets {
  Assets._();

  static const $AssetsColorsGen colors = $AssetsColorsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
