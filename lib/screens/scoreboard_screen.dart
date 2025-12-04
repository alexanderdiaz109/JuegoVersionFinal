import 'package:flutter/material.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DATOS ACTUALIZADOS: Solo los dos campeones
    final List<Map<String, dynamic>> fakeScores = [
      {'name': 'Alexander Diaz', 'score': 1500},
      {'name': 'Daniela Flota', 'score': 1200},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF121212),
      
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFC9A348)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "SALÓN DE LA FAMA",
          style: TextStyle(
            fontFamily: 'Medieval',
            color: Color(0xFFC9A348), // Dorado
            fontSize: 28,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Castillo1.jpg'), // Fondo del castillo azul
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.deepPurple.withOpacity(0.6), // Filtro Púrpura Real
              BlendMode.darken,
            ),
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80, left: 16, right: 16, bottom: 20),
          itemCount: fakeScores.length,
          itemBuilder: (context, index) {
            final player = fakeScores[index];
            return _buildScoreItem(index + 1, player['name'], player['score']);
          },
        ),
      ),
    );
  }

  Widget _buildScoreItem(int rank, String name, int score) {
    Color rankColor;
    IconData rankIcon;
    double iconSize;

    // Asignamos colores (Oro para Alexander, Plata para Daniela)
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700); // Oro
      rankIcon = Icons.emoji_events;
      iconSize = 32;
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Plata
      rankIcon = Icons.emoji_events;
      iconSize = 28;
    } else {
      rankColor = const Color(0xFFCD7F32); // Bronce (por si agregas un tercero luego)
      rankIcon = Icons.emoji_events;
      iconSize = 26;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank == 1 ? rankColor : const Color(0xFF5D4037), 
          width: rank == 1 ? 3 : 1,
        ),
      ),
      child: Row(
        children: [
          // RANGO
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Icon(rankIcon, color: rankColor, size: iconSize),
                Text(
                  "#$rank",
                  style: TextStyle(
                    fontFamily: 'Medieval',
                    color: rankColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // NOMBRE
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Medieval',
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          
          // PUNTUACIÓN
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: rankColor.withOpacity(0.5)),
            ),
            child: Text(
              "$score",
              style: TextStyle(
                fontFamily: 'Medieval',
                color: rankColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}