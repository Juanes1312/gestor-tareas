import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../data/repositories/data_repository.dart';

class DataProvider extends ChangeNotifier {
  final DataRepository _repository;
  List<DataModel> _datos = [];
  bool _isLoading = false;
  String? _errorMessage;

  DataProvider(this._repository);

  List<DataModel> get datos => _datos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _datos = await _repository.getAllDatos();
    } catch (e) {
      _errorMessage = 'Error al cargar datos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDato(DataModel dato) async {
    try {
      final newDato = await _repository.addDato(dato);
      _datos.add(newDato);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al añadir dato: $e';
      notifyListeners();
    }
  }

  Future<void> updateDato(DataModel dato) async {
    try {
      await _repository.updateDato(dato);
      final index = _datos.indexWhere((d) => d.id == dato.id);
      if (index != -1) {
        _datos[index] = dato;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar dato: $e';
      notifyListeners();
    }
  }

  Future<void> deleteDato(int id) async {
    try {
      await _repository.deleteDato(id);
      _datos.removeWhere((dato) => dato.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar dato: $e';
      notifyListeners();
    }
  }
}
