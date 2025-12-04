import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GameState extends ChangeNotifier {
  // --- VARIABLES ---
  int _unlockedLevels = 1;
  int _coins = 2000;
  User? _user;
  DateTime? _lastFreeClaim;

  // INVENTARIO: Inicia con 5 de cada uno por compatibilidad
  final Map<String, int> _inventory = {
    'oil': 5,       
    'repair_kit': 5,
    'rayo': 5
  };

  // --- LISTA DE ÍTEMS DESBLOQUEADOS (IDs únicos) ---
  // CAMBIO AQUÍ: Agregamos 'oil' y 'rayo' para que ya vengan comprados
  final Set<String> _unlockedItems = {'oil', 'rayo'}; 

  // --- GETTERS ---
  int get unlockedLevels => _unlockedLevels;
  int get coins => _coins;
  User? get user => _user;
  String? get userEmail => _user?.email;
  String? get userPhotoUrl => _user?.photoURL;
  bool get isLoggedIn => _user != null;

  // Obtener cantidad de un ítem
  int getItemQuantity(String itemId) {
    return _inventory[itemId] ?? 0;
  }

  // VERIFICAR SI YA TIENES UN ÍTEM
  bool isItemUnlocked(String itemId) {
    return _unlockedItems.contains(itemId);
  }

  // --- MÉTODOS DE USUARIO Y NIVELES ---
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setUnlockedLevels(int levels) {
    if (_unlockedLevels < levels) {
      _unlockedLevels = levels;
      notifyListeners();
    }
  }

  // --- MÉTODOS DE ECONOMÍA ---
  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  void spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
    }
  }

  // COMPRAR / DESBLOQUEAR ÍTEM PERMANENTE
  bool unlockItem(String itemId, int price) {
    // 1. Si ya lo tiene, no hace nada
    if (isItemUnlocked(itemId)) return false;

    // 2. Si le alcanza el dinero
    if (_coins >= price) {
      _coins -= price; 
      _unlockedItems.add(itemId); 
      notifyListeners();
      return true;
    }
    return false;
  }

  // --- LÓGICA DE MONEDAS GRATIS (10 MINUTOS) ---
  bool get canClaimFreeCoins {
    if (_lastFreeClaim == null) return true;
    final difference = DateTime.now().difference(_lastFreeClaim!);
    return difference.inMinutes >= 10;
  }

  String get timeUntilNextFreeClaim {
    if (_lastFreeClaim == null) return "00:00";
    final nextClaimTime = _lastFreeClaim!.add(const Duration(minutes: 10));
    final difference = nextClaimTime.difference(DateTime.now());
    
    if (difference.isNegative) return "00:00";

    final minutes = difference.inMinutes.toString().padLeft(2, '0');
    final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  bool claimFreeCoins(int amount) {
    if (canClaimFreeCoins) {
      _coins += amount;
      _lastFreeClaim = DateTime.now(); 
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // --- GUARDADO Y CARGA ---
  void fromJson(Map<String, dynamic> json) {
    _unlockedLevels = json['unlockedLevels'] ?? 1;
    _coins = json['coins'] ?? 2000;
    
    if (json['lastFreeClaim'] != null) {
      _lastFreeClaim = DateTime.parse(json['lastFreeClaim']);
    }

    if (json['unlockedItems'] != null) {
      _unlockedItems.clear();
      _unlockedItems.addAll(List<String>.from(json['unlockedItems']));
      
      // ASEGURAR QUE LOS DEFAULTS SIEMPRE ESTÉN (Por si acaso)
      _unlockedItems.add('oil');
      _unlockedItems.add('rayo');
    }
    
    if (json['inventory'] != null) {
      _inventory.addAll(Map<String, int>.from(json['inventory']));
    }
    
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'unlockedLevels': _unlockedLevels,
      'coins': _coins,
      'lastFreeClaim': _lastFreeClaim?.toIso8601String(),
      'unlockedItems': _unlockedItems.toList(),
      'inventory': _inventory,
    };
  }

  // RESET
  void reset() {
    _user = null;
    _unlockedLevels = 1;
    _coins = 2000;
    _lastFreeClaim = null;
    
    // RESTAURAR DEFAULTS AL REINICIAR
    _unlockedItems.clear();
    _unlockedItems.addAll({'oil', 'rayo'}); 
    
    _inventory['oil'] = 5;
    _inventory['repair_kit'] = 5;
    _inventory['rayo'] = 5;
    notifyListeners();
  }
}