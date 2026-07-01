import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cliente.dart';
import 'api_service.dart';

class ClienteService extends ApiService {
  static const String endpoint = "/cliente";

  /// LISTAR

  Future<List<Cliente>> getClientes() async {
    final response = await http
        .get(uri(endpoint), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);

      return dados.map((e) => Cliente.fromMap(e)).toList();
    }

    throw Exception("Erro ao buscar clientes");
  }

  /// BUSCAR POR ID

  Future<Cliente?> getCliente(int id) async {
    final response = await http
        .get(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      return Cliente.fromMap(jsonDecode(response.body));
    }

    return null;
  }

  /// SALVAR

  Future<void> salvarCliente(Cliente cliente) async {
    final response = await http
        .post(
          uri(endpoint),

          headers: await headers,

          body: jsonEncode(cliente.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao salvar cliente");
    }
  }

  /// ATUALIZAR

  Future<void> atualizarCliente(Cliente cliente) async {
    final response = await http
        .put(
          uri("$endpoint/${cliente.id}"),

          headers: await headers,

          body: jsonEncode(cliente.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar cliente");
    }
  }

  /// EXCLUIR

  Future<void> excluirCliente(int id) async {
    final response = await http
        .delete(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode != 204) {
      throw Exception("Erro ao excluir cliente");
    }
  }
}
