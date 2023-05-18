import 'package:cotti_client/generated/json/base/json_convert_content.dart';
import 'package:cotti_client/pages/tabs/mine/my/entity/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
	final UserInfoEntity userInfoEntity = UserInfoEntity();
	final String? memberNo = jsonConvert.convert<String>(json['memberNo']);
	if (memberNo != null) {
		userInfoEntity.memberNo = memberNo;
	}
	final String? nickname = jsonConvert.convert<String>(json['nickname']);
	if (nickname != null) {
		userInfoEntity.nickname = nickname;
	}
	final int? sex = jsonConvert.convert<int>(json['sex']);
	if (sex != null) {
		userInfoEntity.sex = sex;
	}
	final String? birthday = jsonConvert.convert<String>(json['birthday']);
	if (birthday != null) {
		userInfoEntity.birthday = birthday;
	}
	final dynamic collectionCount = jsonConvert.convert<dynamic>(json['collectionCount']);
	if (collectionCount != null) {
		userInfoEntity.collectionCount = collectionCount;
	}
	final String? headPortrait = jsonConvert.convert<String>(json['headPortrait']);
	if (headPortrait != null) {
		userInfoEntity.headPortrait = headPortrait;
	}
	final int? appMessageSwitch = jsonConvert.convert<int>(json['appMessageSwitch']);
	if (appMessageSwitch != null) {
		userInfoEntity.appMessageSwitch = appMessageSwitch;
	}
	return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['memberNo'] = entity.memberNo;
	data['nickname'] = entity.nickname;
	data['sex'] = entity.sex;
	data['birthday'] = entity.birthday;
	data['collectionCount'] = entity.collectionCount;
	data['headPortrait'] = entity.headPortrait;
	data['appMessageSwitch'] = entity.appMessageSwitch;
	return data;
}