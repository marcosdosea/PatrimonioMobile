class Instituicao {
  final int? id;
  final String nome;

  Instituicao({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Instituicao.fromMap(Map<String, dynamic> map) {
    return Instituicao(
      id: map['id'],
      nome: map['nome'],
    );
  }
}