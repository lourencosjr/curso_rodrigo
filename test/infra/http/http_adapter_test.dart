import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(
    this.client,
  );

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application;json',
      'accept': 'application;json',
    };
    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    sut = HttpAdapter(client);
    client = ClientSpy();
    url = faker.internet.httpUrl();
  });
  group('POST GROUP => ', () {
    test('Deve chamar o POST com os valores corretor', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(
        client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application;json',
            'accept': 'application;json',
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });
  });
}
