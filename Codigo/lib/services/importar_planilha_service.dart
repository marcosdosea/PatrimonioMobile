import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'database_helper.dart';

class ImportarPlanilhaService {
  final dbHelper = DatabaseHelper.instance;

  Future<void> consumirRelatorio(String caminhoArquivo) async {
    var bytes = File(caminhoArquivo).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet == null) continue;

      // Primeira linha (0) é o cabeçalho, então, pulamos ela
      for (int i = 1; i < sheet.maxRows; i++) {
        var row = sheet.rows[i];

        final instituicaoNome = row[0]?.value?.toString();
        final setorNome = row[1]?.value?.toString();
        final inventarioNome = row[2]?.value?.toString();
        final patrimonioNumero = row[3]?.value?.toString();

        if (patrimonioNumero != null) {
          // Aqui você deve implementar a lógica para:
          // 1. Verificar se a instituição/setor/inventário já existem
          // 2. Ou simplesmente inserir o patrimônio vinculado aos IDs corretos
        }
          await _salvarNoBanco(patrimonioNumero, inventarioNome);
      }
    }
  }

  Future<void> _salvarNoBanco(String numero, String? inventarioNome) async {
    // Exemplo simplificado de inserção usando seu DatabaseHelper
    await dbHelper.insertPatrimonio({
      'numero': numero,
      'idInventario': 1, // Você precisará buscar o ID real baseado no nome
      'idSetor': 1,      // Você precisará buscar o ID real baseado no nome
    });
  }
  
}