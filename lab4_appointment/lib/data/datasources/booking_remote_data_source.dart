import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/booking_model.dart';
import 'parse.dart';

/// Trimite programarea către al doilea serviciu REST.
class BookingRemoteDataSource {
  const BookingRemoteDataSource(
    this._api, {
    this.baseUrl = ApiConfig.bookingBaseUrl,
  });

  final ApiClient _api;
  final String baseUrl;

  Future<BookingResponseModel> send(BookingRequestModel booking) async => parse(
    await _api.postJson(Uri.parse('$baseUrl/posts'), booking.toJson()),
    BookingResponseModel.fromJson,
  );
}
