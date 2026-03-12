class Inventario {
  final int? id;
  final String nome;
  final String dataInicio;
  final String dataFim;
  final int idInstituicao;

  Inventario({
    this.id,
    required this.nome,
    required this.dataInicio,
    required this.dataFim,
    required this.idInstituicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'idInstituicao': idInstituicao,
    };
  }

  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map['id'],
      nome: map['nome'],
      dataInicio: map['dataInicio'],
      dataFim: map['dataFim'],
      idInstituicao: map['idInstituicao'],
    );
  }
}