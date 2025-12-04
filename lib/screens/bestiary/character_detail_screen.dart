import 'package:flutter/material.dart';
import '../../models/bestiary_item.dart';

class CharacterDetailScreen extends StatelessWidget {
  final BestiaryItem item;

  const CharacterDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Seleccionamos el fondo según el bando
    final String bgImage = item.type == BestiaryType.hero 
        ? 'assets/images/Castillo1.jpg' 
        : 'assets/images/Castillo.jpg';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFC9A348)), // Flecha dorada
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // --- FONDO (Castillo) ---
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8), // Oscuro para resaltar el texto
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          
          // --- CONTENIDO ---
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Column(
                children: [
                  // IMAGEN (Animación Hero)
                  Hero(
                    tag: item.name, 
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC9A348), width: 4),
                        boxShadow: [
                           BoxShadow(color: const Color(0xFFC9A348).withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
                        ],
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // CAJA DE TEXTO (Estilo Tienda)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7), // Fondo negro semitransparente
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC9A348), width: 2), // Borde dorado simple
                    ),
                    child: Column(
                      children: [
                        // NOMBRE DEL PERSONAJE
                        Text(
                          item.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Medieval', // <--- TIPOGRAFÍA DE LA TIENDA
                            color: Color(0xFFC9A348), // Dorado
                            fontSize: 32, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),

                        // HISTORIA (LORE)
                        Text(
                          item.lore,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontFamily: 'Medieval', // <--- TIPOGRAFÍA DE LA TIENDA
                            color: Colors.white, // Blanco limpio
                            fontSize: 22, // Tamaño grande para leer fácil
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}