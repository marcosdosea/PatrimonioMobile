import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patrimonio_mobile/models/instituicao_model.dart';
import 'package:patrimonio_mobile/services/instituicao_service.dart';
import 'package:patrimonio_mobile/views/cadastro_instituicao_view.dart';
import 'package:patrimonio_mobile/views/deletar_instituicao_view.dart';

class InstituicaoView extends StatefulWidget {
  const InstituicaoView({super.key});

  @override
  State<InstituicaoView> createState() => _InstituicaoViewState();
}

class _InstituicaoViewState extends State<InstituicaoView> {
  final _instituicaoService = InstituicaoService();

  List<Instituicao> _instituicoes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInstituicoes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadInstituicoes() async {
    setState(() => _loading = true);

    final instituicoes = await _instituicaoService.queryAllInstituicoes();

    setState(() {
      _instituicoes = instituicoes;
      _loading = false;
    });
  }

  Future<void> _abrirCadastroInstituicao() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroInstituicaoView(),
      ),
    );

    await _loadInstituicoes();
  }

  Future<void> _abrirExclusaoInstituicao(Instituicao instituicao) async {
    final excluiu = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DeletarInstituicaoView(
          instituicao: instituicao,
        ),
      ),
    );

    if (excluiu == true) {
      await _loadInstituicoes();
    }
  }

  Widget _buildInstituicaoItem(Instituicao instituicao) {
    return InkWell(
      onTap: () => _abrirExclusaoInstituicao(instituicao),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Text(
              '${instituicao.id}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                instituicao.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF57636C),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF0F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF57636C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Instituições',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF57636C),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _instituicoes.isEmpty
              ? const Center(
                  child: Text('Nenhuma instituição cadastrada.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _instituicoes.length,
                  itemBuilder: (context, index) {
                    final instituicao = _instituicoes[index];
                    return _buildInstituicaoItem(instituicao);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastroInstituicao,
        backgroundColor: const Color(0xFF0055FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Adicionar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
