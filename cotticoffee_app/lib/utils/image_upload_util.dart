import 'dart:io';
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotticommon/cotticommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// ////////////////////////////////////////////
/// @Author: Jianzhong Cai
/// @Date: 2022/3/9 下午5:11
/// @Email: jianzhong.cai@ucarinc.com
/// @Description:
/// /////////////////////////////////////////////

class ImageUploadUtil {
  /// 单图上传
  static Future<String?> upload(AssetEntity entity) async {
    final File? file = await entity.file;
    if (file != null) {
      File? imageFile = await ImageCompressUtil.compressWithFile(file);
      if (imageFile != null) {
        UploadAuthResultModel? result = await UploadAuthAPI.uploadAuth(file);
        if (result != null) {
          return ImageUploadUtil.uploadWithAuthResult(result, imageFile);
        }
      }
    }
    return null;
  }

  /// 批量上传
  static Future<List<String>?> batchUpload(List<AssetEntity> entities) async {
    List<File> fileList = [];
    for (var entity in entities) {
      final File? file = await entity.file;
      if (file != null) {
        fileList.add(file);
      }
    }
    if (fileList.length == entities.length) {
      final List<File>? imageFileList = await ImageCompressUtil.batchCompressWithFiles(fileList);
      if (imageFileList != null && imageFileList.length == fileList.length) {
        final List<UploadAuthResultModel>? authResultModels =
            await UploadAuthAPI.batchUploadAuth(fileList);
        if (authResultModels != null && authResultModels.length == imageFileList.length) {
          List<String> imageUrls = [];
          for (int i = 0; i < imageFileList.length; i++) {
            File imageFile = imageFileList[i];
            UploadAuthResultModel result = authResultModels[i];
            String? url = await ImageUploadUtil.uploadWithAuthResult(result, imageFile);
            if (url != null && url.isNotEmpty) {
              imageUrls.add(url);
            }
          }
          if (imageUrls.isNotEmpty && imageUrls.length == fileList.length) {
            return imageUrls;
          }
        }
      }
    }
    return null;
  }

  /// 上传
  static Future<String?> uploadWithAuthResult(UploadAuthResultModel result, File imageFile) async {
    FormData formData = FormData.fromMap({
      'content': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.substring(
          imageFile.path.lastIndexOf('/') + 1,
          imageFile.path.length,
        ),
      ),
    });
    if (result.formParams != null) {
      formData.fields.addAll(convert(result.formParams!).entries);
    }

    var dio = Dio();
    return await dio.post(result.signUrl ?? '', data: formData).then((response) {
      if (response.statusCode != null && response.statusCode! == 204) {
        return result.filePath;
      }
      return null;
    }).catchError((e) {
      return null;
    });
  }

  /// convert
  static Map<String, String> convert(Map<String, dynamic> data) {
    return Map<String, String>.fromEntries(
        data.entries.map<MapEntry<String, String>>((me) => MapEntry(me.key, me.value)));
  }
}

class UploadAuthAPI {
  /// post方式上传图片授权
  static const uploadAuthURL = "/config/uploadAuth";

  /// (批量)post方式上传图片授权
  // static const batchUploadAuthURL = "/config/batch/uploadAuth";
  static const batchUploadAuthURL = "/common/sys/base/batch/uploadAuth";

  /// 上传图片授权
  static Future<UploadAuthResultModel?> uploadAuth(File file) async {
    return await CottiNetWork().get(
      UploadAuthAPI.uploadAuthURL,
      showToast: false,
      queryParameters: {
        "fileExtension": file.absolute.path
            .substring(file.absolute.path.lastIndexOf('.') + 1, file.absolute.path.length)
      },
    ).then((response) {
      if (response.data != null) {
        return UploadAuthResultModel.fromJson(response.data);
      } else {
        return null;
      }
    }).catchError((e) {
      return null;
    });
  }

  /// 批量上传图片授权
  static Future<List<UploadAuthResultModel>?> batchUploadAuth(List<File> files) async {
    List<String> fileExtensionList = List.generate(files.length, (index) {
      final File file = files[index];
      return file.absolute.path
          .substring(file.absolute.path.lastIndexOf('.') + 1, file.absolute.path.length);
    });
    logI('fileExtensionList === !!!! $fileExtensionList');
    return await CottiNetWork().post(
      UploadAuthAPI.batchUploadAuthURL,
      data: {"fileExtensionList": fileExtensionList},
      queryParameters: {"fileExtensionList": fileExtensionList},
      showToast: false,
    ).then((response) {
      logW('response === $response');
      if (response != null) {
        final List authResultMaps = response;
        return authResultMaps.map((e) => UploadAuthResultModel.fromJson(e)).toList();
      } else {
        return null;
      }
    }).catchError((e) {
      logW('catchError === $e');
      return null;
    });
  }
}

class UploadAuthResultModel {
  UploadAuthResultModel({
    this.signUrl,
    this.filePath,
    this.formParams,
  });

  /// url
  String? signUrl;

  /// 文件地址
  String? filePath;

  /// 表单参数
  Map<String, dynamic>? formParams;

  factory UploadAuthResultModel.fromJson(Map<String, dynamic> json) => UploadAuthResultModel(
        signUrl: json["signUrl"],
        filePath: json["filePath"],
        formParams: json["formParams"],
      );
}

class ImageCompressUtil {
  /// 多图压缩
  static Future<List<File>?> batchCompressWithFiles(List<File> files,
      {int maxLength = 1024 * 1024}) async {
    List<File> imageFileList = [];
    for (File file in files) {
      final File? imageFile = await ImageCompressUtil.compressWithFile(
        file,
        maxLength: maxLength,
      );
      if (imageFile != null) {
        imageFileList.add(imageFile);
      }
    }
    return imageFileList.length == files.length ? imageFileList : null;
  }

  /// 单图压缩
  static Future<File?> compressWithFile(File file, {int maxLength = 1024 * 1024}) async {
    var directory = await getTemporaryDirectory();
    var targetPath = directory.absolute.path +
        "/" +
        "$maxLength" +
        "_" +
        file.absolute.path.substring(
          file.absolute.path.lastIndexOf('/') + 1,
          file.absolute.path.length,
        );
    int quality = 100;
    if (file.lengthSync() > maxLength) {
      quality = (maxLength / file.lengthSync() * 100).truncate();
    }
    File? imageFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      format: _fileFormat(file.path),
    );
    return imageFile;
  }

  static CompressFormat _fileFormat(String path) {
    if (path.endsWith(".png")) {
      return CompressFormat.png;
    } else if (path.endsWith("jpg") || path.endsWith("jpeg")) {
      return CompressFormat.jpeg;
    }
    return CompressFormat.webp;
  }
}
