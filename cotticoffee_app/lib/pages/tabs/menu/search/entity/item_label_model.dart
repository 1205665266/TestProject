import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/item_label_model.g.dart';

/// FileName: ItemLableModel
///
/// Description:
/// Author: xingguo.lei@abite.com
/// Date: 2021/12/16
@JsonSerializable()
class ItemLabelModel {

	ItemLabelModel();

	factory ItemLabelModel.fromJson(Map<String, dynamic> json) => $ItemLabelModelFromJson(json);

	Map<String, dynamic> toJson() => $ItemLabelModelToJson(this);

  @JSONField(name: "itemLabelDTOs")
  List<SearchItemLabel>? itemLabelList;
  @JSONField(name: "productParamValueDTOs")
  List<SearchProductParam>? productParamList;
}

@JsonSerializable()
class SearchItemLabel {

	SearchItemLabel();

	factory SearchItemLabel.fromJson(Map<String, dynamic> json) => $SearchItemLabelFromJson(json);

	Map<String, dynamic> toJson() => $SearchItemLabelToJson(this);

  String? itemLabel;
  num? itemId;
  String? itemNo;
  String? itemName;
}

@JsonSerializable()
class SearchProductParam {

	SearchProductParam();

	factory SearchProductParam.fromJson(Map<String, dynamic> json) => $SearchProductParamFromJson(json);

	Map<String, dynamic> toJson() => $SearchProductParamToJson(this);

  String? code;
  String? name;
}
