import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/appointment_details_model.dart';
import '../models/home_feed_model.dart';
import 'parse.dart';

/// Citește datele din serviciul REST (varianta 2).
class AppointmentRemoteDataSource {
  const AppointmentRemoteDataSource(
    this._api, {
    this.baseUrl = ApiConfig.baseUrl,
  });

  final ApiClient _api;
  final String baseUrl;

  Future<HomeFeedModel> fetchHomeFeed() async => parse(
    await _api.getJson(Uri.parse('$baseUrl/feed')),
    HomeFeedModel.fromJson,
  );

  Future<AppointmentDetailsModel> fetchAppointmentDetails() async => parse(
    await _api.getJson(Uri.parse('$baseUrl/feed/details')),
    AppointmentDetailsModel.fromJson,
  );
}
