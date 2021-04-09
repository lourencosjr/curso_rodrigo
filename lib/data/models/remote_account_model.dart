import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.toJson(Map json) =>
      RemoteAccountModel(json['accessToken']);

  AccountEntity toAccountEntity() => AccountEntity(accessToken);
}
