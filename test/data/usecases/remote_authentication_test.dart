import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:curso_rodrigo/domain/usecases/usecases.dart';

import 'package:curso_rodrigo/data/http/http.dart';
import 'package:curso_rodrigo/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() async {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
  });

  test('Chamando o httpCliente com valores corretos', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);

    verify(
      httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}),
    );
  });
}
