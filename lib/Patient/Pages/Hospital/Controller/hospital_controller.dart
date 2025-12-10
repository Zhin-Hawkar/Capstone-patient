import 'package:capstone/Backend/Util/http_util.dart';
import 'package:capstone/Patient/Pages/Hospital/Model/hospital.dart';

class HospitalController {
 static Future<dynamic> getAllHospitals() async {
    List<dynamic> result = await _fetchHospitals();
    List<Hospital> hospitals = result.map((e) => Hospital.fromJson(e)).toList();
    return hospitals;
  }

 static Future<dynamic> _fetchHospitals() async {
    final result = await HttpUtil().get("api/getallhospitals");
    return result['hospitals'];
  }
}
