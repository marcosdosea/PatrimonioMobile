import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patrimonio_mobile/models/instituicao_model.dart';
import 'package:patrimonio_mobile/services/instituicao_service.dart';

class DeletarInstituicaoView extends StatefulWidget {
  final Instituicao instituicao;

  const DeletarInstituicaoView({
    super.key,
    required this.instituicao,
  });

  @override
  State<DeletarInstituicaoView> createState() => _DeletarInstituicaoViewState();
}

class _DeletarInstituicaoViewState extends State<DeletarInstituicaoView> {
  final _instituicaoService = InstituicaoService();
  bool _excluindo = false;

  Future<void> _excluirInstituicao() async {
    final id = widget.instituicao.id;

    if (id == null || _excluindo) {
      return;
    }

    setState(() => _excluindo = true);

    try {
      await _instituicaoService.deleteInstituicao(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instituição excluída com sucesso.')),
      );
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      setState(() => _excluindo = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir a instituição.'),
        ),
      );
    }
  }

  Widget _buildInfoBox({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF57636C),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF0F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF101213),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F4F8),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF0F6),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 40, 20, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Color(0xFF57636C),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Excluir instituição',
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
                        'Dados da instituição',
                        style: GoogleFonts.interTight(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF57636C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoBox(
                        label: 'Código',
                        value: '${widget.instituicao.id ?? '-'}',
                      ),
                      const SizedBox(height: 20),
                      _buildInfoBox(
                        label: 'Nome da instituição',
                        value: widget.instituicao.nome,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _excluindo ? null : _excluirInstituicao,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            disabledBackgroundColor: const Color(0xFFE57373),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _excluindo
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Excluir',
                                  style: GoogleFonts.interTight(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
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
    );
  }
}
