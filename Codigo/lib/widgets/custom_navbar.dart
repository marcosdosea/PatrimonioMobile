import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final corFundo = const Color(0xFFEFF0F5);
    final corIconeTexto = Colors.grey[700];
    final corSombra = Colors.black.withOpacity(0.1);

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: corFundo,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: corSombra,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10), // Substitui o fromSTEB
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Item 1: Início
            Column(
              mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_outlined,
                  color: corIconeTexto,
                  size: 40,
                ),
                Text(
                  'Início',
                  style: GoogleFonts.inter(
                    color: corIconeTexto,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            
            // Item 2: Cadastrar
            Column(
              mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_sharp,
                  color: corIconeTexto,
                  size: 40,
                ),
                Text(
                  'Cadastrar',
                  style: GoogleFonts.inter(
                    color: corIconeTexto,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            
            // Item 3: Arquivos
            Column(
              mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  color: corIconeTexto,
                  size: 40,
                ),
                Text(
                  'Arquivos',
                  style: GoogleFonts.inter(
                    color: corIconeTexto,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}