import 'package:pumped_end_device/data/remote/model/request/request.dart';

class GetBackendMetadataRequest extends Request {
  GetBackendMetadataRequest(final String uuid) : super(uuid);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}