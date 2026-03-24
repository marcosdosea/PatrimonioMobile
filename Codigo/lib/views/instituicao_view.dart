import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patrimonio_mobile/models/instituicao_model.dart';
import 'package:patrimonio_mobile/services/instituicao_service.dart';
import 'package:patrimonio_mobile/views/cadastro_instituicao_view.dart';
import 'package:patrimonio_mobile/widgets/custom_navbar.dart';

class InstituicaoView extends StatefulWidget {
  const InstituicaoView({super.key});

  @override
  State<InstituicaoView> createState() => _InstituicaoViewState();
}

class _InstituicaoViewState extends State<InstituicaoView> {
  final InstituicaoService _instituicaoService = InstituicaoService();

  List<Instituicao> _instituicoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarInstituicoes();
  }

  Future<void> _carregarInstituicoes() async {
    setState(() => _carregando = true);

    try {
      final instituicoes = await _instituicaoService.queryAllInstituicoes();
      if (!mounted) return;

      setState(() {
        _instituicoes = instituicoes;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar instituições: $e')),
      );
    }
  }

  Future<void> _abrirCadastroInstituicao() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroInstituicaoView(),
      ),
    );

    if (!mounted) return;
    await _carregarInstituicoes();
  }

  Future<void> _deleteInstituicao(int id) async {
    await _instituicaoService.deleteInstituicao(id);
    await _carregarInstituicoes();
  }

  Future<void> _showDeleteDialog(Instituicao instituicao) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir instituição'),
        content: Text(
            'Tem certeza que deseja excluir a instituição "${instituicao.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteInstituicao(instituicao.id!);
    }
  }

  Future<void> _showEditDialog(Instituicao instituicao) async {
    final nomeController = TextEditingController(text: instituicao.nome);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar instituição'),
        content: TextField(
          controller: nomeController,
          decoration: const InputDecoration(labelText: 'Nome da instituição'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeController.text.trim().isEmpty) {
                return;
              }

              await _instituicaoService.updateInstituicao(
                instituicao.id!,
                Instituicao(
                  id: instituicao.id,
                  nome: nomeController.text.trim(),
                ),
              );

              Navigator.pop(context);
              await _carregarInstituicoes();
            },
            child: const Text('Salvar'),
          ),
        ],
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
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _instituicoes.isEmpty
              ? const Center(
                  child: Text('Nenhuma instituição cadastrada.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _instituicoes.length,
                  itemBuilder: (context, index) {
                    return _buildInstituicaoItem(_instituicoes[index]);
                  },
                ),
      bottomNavigationBar: const NavBarWidget(selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastroInstituicao,
        backgroundColor: const Color(0xFF0055FF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInstituicaoItem(Instituicao instituicao) {
    return Container(
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
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0055FF)),
            onPressed: () => _showEditDialog(instituicao),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(instituicao),
          ),
        ],
      ),
    );
  }
}
