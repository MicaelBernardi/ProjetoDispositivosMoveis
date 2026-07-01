import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/agendamento.dart';
import 'api_service.dart';

class AgendamentoService extends ApiService {
  static const String endpoint = "/agendamento";

  /// LISTAR

  Future<List<Agendamento>> getAgendamentos() async {
    final response = await http
        .get(uri(endpoint), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);

      return dados.map((e) => Agendamento.fromMap(e)).toList();
    }

    throw Exception("Erro ao listar agendamentos");
  }

  /// BUSCAR POR ID

  Future<Agendamento?> getAgendamento(int id) async {
    final response = await http
        .get(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode == 200) {
      return Agendamento.fromMap(jsonDecode(response.body));
    }

    return null;
  }

  /// SALVAR

  Future<void> salvarAgendamento(Agendamento agendamento) async {
    final response = await http
        .post(
          uri(endpoint),

          headers: await headers,

          body: jsonEncode(agendamento.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao salvar agendamento");
    }
  }

  /// ATUALIZAR

  Future<void> atualizarAgendamento(Agendamento agendamento) async {
    final response = await http
        .put(
          uri("$endpoint/${agendamento.id}"),

          headers: await headers,

          body: jsonEncode(agendamento.toMap()),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar agendamento");
    }
  }

  /// EXCLUIR

  Future<void> excluirAgendamento(int id) async {
    final response = await http
        .delete(uri("$endpoint/$id"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode != 204) {
      throw Exception("Erro ao excluir agendamento");
    }
  }

  /// FINALIZAR

  Future<void> finalizarAgendamento(int id) async {
    final response = await http
        .patch(uri("$endpoint/$id/finalizar"), headers: await headers)
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw Exception("Erro ao finalizar agendamento");
    }
  }
}
