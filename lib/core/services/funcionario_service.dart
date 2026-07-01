import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/funcionario.dart';
import 'api_service.dart';

class FuncionarioService extends ApiService {
  static const String endpoint = "/funcionario";

  /// LISTAR

  Future<List<Funcionario>> getFuncionarios() async {
    final response = await http
        .get(uri(endpoint), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);

      return dados.map((e) => Funcionario.fromMap(e)).toList();
    }

    throw Exception("Erro ao buscar funcionários");
  }

  /// BUSCAR POR ID

  Future<Funcionario?> getFuncionario(int id) async {
    final response = await http
        .get(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      return Funcionario.fromMap(jsonDecode(response.body));
    }

    return null;
  }

  /// SALVAR

  Future<void> salvarFuncionario(Funcionario funcionario) async {
    final response = await http
        .post(
          uri(endpoint),

          headers: await headers,

          body: jsonEncode(funcionario.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao salvar funcionário");
    }
  }

  /// ATUALIZAR

  Future<void> atualizarFuncionario(Funcionario funcionario) async {
    final response = await http
        .put(
          uri("$endpoint/${funcionario.id}"),

          headers: await headers,

          body: jsonEncode(funcionario.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar funcionário");
    }
  }

  /// EXCLUIR

  Future<void> excluirFuncionario(int id) async {
    final response = await http
        .delete(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode != 204) {
      throw Exception("Erro ao excluir funcionário");
    }
  }
}
