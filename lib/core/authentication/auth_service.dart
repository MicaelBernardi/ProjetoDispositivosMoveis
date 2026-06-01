import '../dao/funcionario_dao.dart';
import '../models/funcionario.dart';

class AuthService {
  Future<Funcionario?> login(String email, String senha) async {
    return await FuncionarioDAO().getFuncionario(email, senha);
  }
}
