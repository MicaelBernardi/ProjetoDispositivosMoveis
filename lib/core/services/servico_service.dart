import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/servico.dart';
import 'api_service.dart';

class ServicoService extends ApiService {
  static const String endpoint = "/servico";

  /// LISTAR

  Future<List<Servico>> getServicos() async {
    final response = await http
        .get(uri(endpoint), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);

      return dados.map((e) => Servico.fromMap(e)).toList();
    }

    throw Exception("Erro ao buscar serviços");
  }

  /// BUSCAR POR ID

  Future<Servico?> getServico(int id) async {
    final response = await http
        .get(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      return Servico.fromMap(jsonDecode(response.body));
    }

    return null;
  }

  /// SALVAR

  Future<void> salvarServico(Servico servico) async {
    final response = await http
        .post(
          uri(endpoint),

          headers: await headers,

          body: jsonEncode(servico.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao salvar serviço");
    }
  }

  /// ATUALIZAR

  Future<void> atualizarServico(Servico servico) async {
    final response = await http
        .put(
          uri("$endpoint/${servico.id}"),

          headers: await headers,

          body: jsonEncode(servico.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar serviço");
    }
  }

  /// EXCLUIR

  Future<void> excluirServico(int id) async {
    final response = await http
        .delete(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode != 204) {
      throw Exception("Erro ao excluir serviço");
    }
  }
}
