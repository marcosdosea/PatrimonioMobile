import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patrimonio_mobile/models/instituicao_model.dart';
import 'package:patrimonio_mobile/services/instituicao_service.dart';
import '/widgets/custom_navbar.dart';

class CadastroInstituicaoView extends StatefulWidget {
  const CadastroInstituicaoView({super.key});

  @override
  State<CadastroInstituicaoView> createState() =>
      _CadastroInstituicaoViewState();
}

class _CadastroInstituicaoViewState extends State<CadastroInstituicaoView> {
  final _instituicaoService = InstituicaoService();
  late TextEditingController _textController;
  late FocusNode _textFieldFocusNode;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFieldFocusNode = FocusNode();
  }

  Future<void> _salvarInstituicao() async {
    final nome = _textController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome da instituição.')),
      );
      return;
    }

    await _instituicaoService.insertInstituicao(
      Instituicao(nome: nome),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instituição cadastrada com sucesso.')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
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
                            'Cadastrar instituição',
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
                              'Nova instituição',
                              style: GoogleFonts.interTight(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF57636C),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _textController,
                                focusNode: _textFieldFocusNode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFEFF0F6),
                                  hintText: 'Nome da Instituição',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: GoogleFonts.inter(fontSize: 18),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _salvarInstituicao,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0055FF),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                'Adicionar Instituição',
                                style: GoogleFonts.interTight(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const NavBarWidget(selectedIndex: 1),
          ],
        ),
      ),
    );
  }
}
