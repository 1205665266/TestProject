import 'dart:convert';

import 'package:cotti_client/generated/json/base/json_field.dart';
import 'package:cotti_client/generated/json/static_text_entity.g.dart';

@JsonSerializable()
class StaticTextEntity {
  CommonContext? commonContext;
  ConfirmOrderPage? confirmOrderPage;

  StaticTextEntity();

  factory StaticTextEntity.fromJson(Map<String, dynamic> json) => $StaticTextEntityFromJson(json);

  Map<String, dynamic> toJson() => $StaticTextEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class CommonContext {
  String? specialActivityLabelForOrder;
  String? specialActivityLabel;
  String? buyNow;
  String? guidanceToBeOpened;

  CommonContext();

  factory CommonContext.fromJson(Map<String, dynamic> json) => $CommonContextFromJson(json);

  Map<String, dynamic> toJson() => $CommonContextToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ConfirmOrderPage {
  String? firstOrderFreeDispatchRuleTitle;

  ConfirmOrderPage();

  factory ConfirmOrderPage.fromJson(Map<String, dynamic> json) => $ConfirmOrderPageFromJson(json);

  Map<String, dynamic> toJson() => $ConfirmOrderPageToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
