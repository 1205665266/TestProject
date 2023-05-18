
import 'package:cotti_client/network/cotti_net_work.dart';
import 'package:cotti_client/pages/tabs/mine/help/entity/last_order_entity.dart';

class HelpApi {

  static const String _getLastOrderUrl = "/order/getLastOrder";

  static Future<LastOrderEntity> getLastOrder(){
    return CottiNetWork().post(_getLastOrderUrl,data: {}).then((value){
      return LastOrderEntity.fromJson(value);
    });
  }

}