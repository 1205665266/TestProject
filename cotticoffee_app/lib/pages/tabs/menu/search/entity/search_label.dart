import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/search_label.g.dart';


/// FileName: search_lable
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/16
@JsonSerializable()
class SearchLabel {

	SearchLabel();

	factory SearchLabel.fromJson(Map<String, dynamic> json) => $SearchLabelFromJson(json);

	Map<String, dynamic> toJson() => $SearchLabelToJson(this);

  ///商品ID
  String? itemId;

  ///标签
  String? labelText;

  ///商品编号
  String? itemNo;

  ///标签
  String? type;

  ///是否属于菜系
  bool? isCuisines;
}
