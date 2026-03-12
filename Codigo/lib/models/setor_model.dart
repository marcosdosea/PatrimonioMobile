class Setor {
  final int? id;
  final String nome;
  final int idInstituicao;

  Setor({
    this.id,
    required this.nome,
    required this.idInstituicao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idInstituicao': idInstituicao,
    };
  }

  factory Setor.fromMap(Map<String, dynamic> map) {
    return Setor(
      id: map['id'],
      nome: map['nome'],
      idInstituicao: map['idInstituicao'],
    );
  }
}