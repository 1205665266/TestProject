import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/vocher_template_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class VocherTemplateInfoEntity {

	String? templateTypeNo;
	String? no;
	int? voucherType;
	String? useType;
	String? title;
	String? voucherDesc;
	String? voucherName;
	String? voucherSubtitle;
	String? voucherImage;
  
  VocherTemplateInfoEntity();

  factory VocherTemplateInfoEntity.fromJson(Map<String, dynamic> json) => $VocherTemplateInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $VocherTemplateInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}