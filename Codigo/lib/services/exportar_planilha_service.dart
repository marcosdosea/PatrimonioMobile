import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'database_helper.dart';

class ExportarPlanilhaService {
  Future<String> exportarPlanilha(String nomeArquivo) async {
    final excel = Excel.createExcel();
    final sheet = excel['Dados'];

    // 🔹 Busca dados do banco (SQLite)
    final dadosBanco = await DatabaseHelper.instance.getRelatorioExcel();

    // 🔹 Cabeçalho
    sheet.appendRow([
      TextCellValue('Instituição'),
      TextCellValue('Setor'),
      TextCellValue('Inventário'),
      TextCellValue('Patrimônio'),
    ]);

    // 🔹 Dados
    for (var row in dadosBanco) {
      sheet.appendRow([
        TextCellValue(row['instituicao']),
        TextCellValue(row['setor']),
        TextCellValue(row['inventario']),
        TextCellValue(row['patrimonio']),
      ]);
    }

    final fileBytes = excel.encode();
    if (fileBytes == null) {
      throw Exception('Erro ao gerar a planilha');
    }

    final directory = await getApplicationDocumentsDirectory();

    final path =
        '${directory.path}/${nomeArquivo}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    final file = await File(path).writeAsBytes(fileBytes);

    return file.path;
  }
}
