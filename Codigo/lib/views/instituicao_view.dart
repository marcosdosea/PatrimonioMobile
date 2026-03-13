import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/instituicao_model.dart';
import '../services/instituicao_service.dart';
import '../views/cadastro_instituicao_view.dart';
import '../widgets/custom_navbar.dart';

class InstituicaoView extends StatefulWidget {
  const InstituicaoView({super.key});

  @override
  State<InstituicaoView> createState() => _InstituicaoViewState();
}

class _InstituicaoViewState extends State<InstituicaoView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final InstituicaoService _instituicaoService = InstituicaoService();

  List<Instituicao> _instituicoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarInstituicoes();
  }

  @override
  void dispose() {
    super.dispose();
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

  Future<void> _removerInstituicao(int id) async {
    try {
      await _instituicaoService.deleteInstituicao(id);
      await _carregarInstituicoes();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover instituição: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF1F4F8),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF0F6),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 40, 20, 20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                size: 40, color: Color(0xFF57636C)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Instituições',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF57636C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lista de instituições',
                              style: GoogleFonts.interTight(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF57636C),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _carregando
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : _instituicoes.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Nenhuma instituição cadastrada.',
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              color: const Color(0xFF57636C),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount: _instituicoes.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) {
                                            final instituicao =
                                                _instituicoes[index];
                                            return _buildInstituicaoItem(
                                              instituicao: instituicao,
                                              posicao: index + 1,
                                            );
                                          },
                                        ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CadastroInstituicaoView(),
                                  ),
                                );
                                await _carregarInstituicoes();
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Cadastrar instituição',
                                style: GoogleFonts.interTight(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0055FF),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const NavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstituicaoItem(
      {required Instituicao instituicao, required int posicao}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              blurRadius: 3,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Text(
            posicao.toString(),
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              instituicao.nome,
              style: GoogleFonts.inter(fontSize: 16),
            ),
          ),
          IconButton(
            icon:
                const Icon(Icons.cancel_outlined, color: Colors.red, size: 24),
            onPressed: instituicao.id == null
                ? null
                : () => _removerInstituicao(instituicao.id!),
          ),
        ],
      ),
    );
  }
}
