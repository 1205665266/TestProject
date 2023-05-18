/// FileName: search_param
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/17
class SearchParam {
  int? shopMdCode;
  String? itemName;
  num? pageSize;
  num? pageNum;
  int? takeFoodMode;

  SearchParam(
      {this.shopMdCode, this.itemName, this.pageSize, this.pageNum, this.takeFoodMode});

  Map<String, dynamic> toJson() {
    return {
      "shopMdCode": shopMdCode,
      "itemName": itemName,
      "pageSize": pageSize,
      "pageNum": pageNum,
      "takeFoodMode": takeFoodMode,
    };
  }
}
