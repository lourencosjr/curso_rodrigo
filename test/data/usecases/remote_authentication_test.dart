import 'package:curso_rodrigo/data/http/http.dart';
import 'package:curso_rodrigo/data/usecases/usecases.dart';
import 'package:curso_rodrigo/domain/helpers/helpers.dart';
import 'package:curso_rodrigo/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() async {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Chamando o httpCliente com valores corretos', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut.auth(params);
    verify(
      httpClient.request(
          url: url,
          method: 'post',
          body: {'email': params.email, 'password': params.secret}),
    );
  });

  test('Deve jogar UnexpectedError se o HttpClient retornar erro 400',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final Future future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve jogar UnexpectedError se o HttpClient retornar erro 404',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final Future future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve jogar UnexpectedError se o HttpClient retornar erro 500',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final Future future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Deve jogar InvalidCredentialsError se o HttpClient retornar erro 401',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final Future future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Deve retonar um Account se o HttpClient retornar 200', () async {
    final accessToken = faker.guid.guid();

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test(
      'Deve jogar um UnexpectedError se o HttpClient retornar 200 com um dado inv??lido',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {'invalidToken': 'invalidToken'});

    final Future future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
