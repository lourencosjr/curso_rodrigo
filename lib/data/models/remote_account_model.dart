import '../../domain/entities/entities.dart';
import '../http/http.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken') || json['accessToken'] == null) {
      throw HttpError.unauthorized;
    }
    return RemoteAccountModel(json['accessToken']);
  }

  AccountEntity toAccountEntity() => AccountEntity(accessToken);
}
