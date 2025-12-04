import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/game_state.dart';
import 'dart:async';
import 'package:flutter_paypal/flutter_paypal.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  Timer? _visualTimer;

  @override
  void initState() {
    super.initState();
    _visualTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _visualTimer?.cancel();
    super.dispose();
  }

  // --- FUNCIÓN DE PAGO REAL CON PAYPAL ---
  void _payWithPayPal(BuildContext context, int coinsAmount, String price, String currency) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            // TUS LLAVES
            clientId: "AYdoDe8_bGM3VQRMSRxCwatN-KtKTKi7395x9CST8yBGQ6lqNqsxTyTcatMHocz9feWjb2Aln3vvkcVD",
            secretKey: "EGMjRksMKAa3b7eUv3TTVQ5GyZm9Yi5jvBd694UbuyXoHW27wqgzFTRlkaXMGCIpKL5hsqTa6YSchYqA",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": price,
                  "currency": currency,
                  "details": {
                    "subtotal": price,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "Compra de $coinsAmount Monedas de Oro",
                "item_list": {
                  "items": [
                    {
                      "name": "$coinsAmount Monedas de Oro",
                      "quantity": 1,
                      "price": price,
                      "currency": currency
                    }
                  ],
                }
              }
            ],
            note: "Gracias por apoyar Defensa del Muro.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
              Provider.of<GameState>(context, listen: false).addCoins(coinsAmount);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("¡Pago exitoso! +$coinsAmount monedas."),
                ),
              );
            },
            onError: (error) {
              print("onError: $error");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error al conectar con PayPal.")),
              );
            },
            onCancel: (params) {
              print('cancelled: $params');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Compra cancelada.")),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF1a120b),
        
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFC9A348)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "MERCADO",
            style: TextStyle(
              fontFamily: 'Medieval',
              color: Color(0xFFC9A348),
              fontSize: 32,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // CONTADOR DE MONEDAS
            Consumer<GameState>(
              builder: (context, gameState, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFC9A348)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Color(0xFFC9A348), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${gameState.coins}',
                        style: const TextStyle(
                          fontFamily: 'Medieval',
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFFC9A348),
            labelColor: Color(0xFFC9A348),
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 4.0,
            labelStyle: TextStyle(fontFamily: 'Medieval', fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontFamily: 'Medieval', fontSize: 16),
            tabs: [
              Tab(icon: Icon(Icons.security), text: "Armería"),
              Tab(icon: Icon(Icons.savings), text: "Bóveda"),
            ],
          ),
        ),
        
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/111.jpg'), 
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
            ),
          ),
          child: TabBarView(
            children: [
              _buildArmoryTab(context),
              _buildVaultTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArmoryTab(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 140, left: 16, right: 16),
      children: [
        // ÍTEM 1: ACEITE
        _buildShopItem(
          context,
          itemId: 'oil', 
          name: "Aceite Hirviendo",
          description: "Quema a los enemigos que atacan la puerta.",
          price: 500, // <--- PRECIO AUMENTADO
          imagePath: 'assets/images/caldero.jpg', 
        ),
        const SizedBox(height: 16),
        
        // ÍTEM 2: RAYO
        _buildShopItem(
          context,
          itemId: 'rayo',
          name: "Rayo Purificador",
          description: "Electrocuta a los enemigos cercanos.",
          price: 1200, // <--- PRECIO AUMENTADO (Item Épico)
          imagePath: 'assets/images/rayo.jpg', 
        ),
        const SizedBox(height: 16),

        // ÍTEM 3: KIT
        _buildShopItem(
          context,
          itemId: 'repair_kit',
          name: "Kit de Reparación",
          description: "Recupera 20% de salud del muro.",
          price: 750, // <--- PRECIO AUMENTADO
          iconData: Icons.build,
          iconColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildVaultTab(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 140, left: 16, right: 16),
      children: [
        _buildFreeCoinPack(context),
        const SizedBox(height: 16),
        _buildPaidCoinPack(context, amount: 500, price: "0.99", color: Colors.amber),
        const SizedBox(height: 16),
        _buildPaidCoinPack(context, amount: 1000, price: "1.99", color: Colors.orange),
      ],
    );
  }

  Widget _buildShopItem(BuildContext context, {
    required String itemId,
    required String name,
    required String description,
    required int price,
    IconData? iconData,
    Color? iconColor,
    String? imagePath, 
  }) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final bool canAfford = gameState.coins >= price;
        // VERIFICAMOS SI YA LO COMPRÓ (Ya no importa la cantidad, solo si lo tiene)
        final bool isUnlocked = gameState.isItemUnlocked(itemId);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6), 
            borderRadius: BorderRadius.circular(12),
            // Borde verde si ya lo tienes
            border: Border.all(
              color: isUnlocked ? Colors.greenAccent : const Color(0xFFC9A348), 
              width: isUnlocked ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(4, 4), blurRadius: 0)
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: imagePath != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset(imagePath, fit: BoxFit.cover))
                    : Icon(iconData, size: 40, color: iconColor ?? Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Medieval', 
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontFamily: 'Medieval',
                        color: Colors.white70, 
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    if (!isUnlocked) 
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, size: 16, color: Color(0xFFC9A348)),
                          const SizedBox(width: 4),
                          Text("$price", style: const TextStyle(fontFamily: 'Medieval', fontSize: 18, color: Color(0xFFC9A348))),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: const Text(
                          "POTENCIADOR ADQUIRIDO",
                          style: TextStyle(
                            fontFamily: 'Medieval',
                            color: Colors.greenAccent, 
                            fontSize: 12
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              ElevatedButton(
                onPressed: (!isUnlocked && canAfford)
                    ? () {
                        bool success = gameState.unlockItem(itemId, price);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("¡$name desbloqueado permanentemente!")),
                          );
                        }
                      }
                    : null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUnlocked 
                      ? const Color(0xFF1B5E20) 
                      : (canAfford ? const Color(0xFF2E7D32) : Colors.grey),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isUnlocked ? "ADQUIRIDO" : (canAfford ? "COMPRAR" : "FALTA ORO"), 
                  style: const TextStyle(fontFamily: 'Medieval', fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFreeCoinPack(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        bool isAvailable = gameState.canClaimFreeCoins;

        return GestureDetector(
          onTap: isAvailable 
            ? () {
                bool success = gameState.claimFreeCoins(100);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text("¡Has recibido tu regalo diario!")),
                  );
                }
              } 
            : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isAvailable 
                  ? [Colors.brown.withOpacity(0.6), Colors.brown.withOpacity(0.3)]
                  : [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isAvailable ? Colors.brown : Colors.grey, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.card_giftcard, size: 40, color: isAvailable ? Colors.brown : Colors.grey),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("+ 100 ORO", style: TextStyle(fontFamily: 'Medieval', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        if (!isAvailable)
                          Text("Espera: ${gameState.timeUntilNextFreeClaim}", style: const TextStyle(fontFamily: 'Medieval', color: Colors.orange, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: isAvailable ? Colors.white : Colors.grey[400], borderRadius: BorderRadius.circular(20)),
                  child: Text("GRATIS", style: TextStyle(fontFamily: 'Medieval', color: isAvailable ? Colors.black : Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaidCoinPack(BuildContext context, {required int amount, required String price, required Color color}) {
    return GestureDetector(
      onTap: () {
        _payWithPayPal(context, amount, price, "USD");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withOpacity(0.6), color.withOpacity(0.3)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.savings, size: 40, color: color),
                const SizedBox(width: 16),
                Text("+ $amount ORO", style: const TextStyle(fontFamily: 'Medieval', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(
                "\$$price", 
                style: const TextStyle(fontFamily: 'Medieval', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}