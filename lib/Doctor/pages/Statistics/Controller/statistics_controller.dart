import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Doctor/pages/Statistics/Model/statistics_model.dart';

class StatisticsController {
  static Future<StatisticsModel> handleStatistics() async {
    Map<String, dynamic> result = await getStatistics();
    StatisticsModel statistics = StatisticsModel.fromJson(result);
    return statistics;
  }

  static getStatistics() async {
    final result = await HttpUtil().get("api/getstatistics");
    return result;
  }
}
