import '../../data/models/models.dart';
import 'data_repository.dart';

class FakeDataRepository implements DataRepository {
  static final List<DataModel> _fakeDatos = [];
  static int _nextId = 1;

  FakeDataRepository() {
    if (_fakeDatos.isEmpty) {
      _fakeDatos.addAll([
        DataModel(
          id: _nextId++,
          titulo: 'Realizar crud',
          descripcion: 'Realizar crud en flutter',
          prioridad: 'Alta',
          fechaDeVencimiento: '2025-05-21',
          completada: true,
        ),
        DataModel(
          id: _nextId++,
          titulo: 'Gestor de animaciones',
          descripcion: 'Realizar animaciones.',
          prioridad: 'Media',
          fechaDeVencimiento: '2025-02-20',
          completada: true,
        ),
        DataModel(
          id: _nextId++,
          titulo: 'Documentacion',
          descripcion: 'Realizar documentacion de aplicaciones creadas.',
          prioridad: 'Baja',
          fechaDeVencimiento: '2025-03-01',
          completada: false,
        ),
      ]);
    }
  }

  @override
  Future<List<DataModel>> getAllDatos() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.from(_fakeDatos);
  }

  @override
  Future<DataModel> addDato(DataModel dato) async {
    await Future.delayed(const Duration(seconds: 2));
    final newData = dato.copyWith(id: _nextId++);
    _fakeDatos.add(newData);
    return newData;
  }

  @override
  Future<void> updateDato(DataModel dato) async {
    await Future.delayed(const Duration(seconds: 2));
    final index = _fakeDatos.indexWhere((d) => d.id == dato.id);
    if (index != -1) {
      _fakeDatos[index] = dato;
    } else {
      throw Exception('Dato con ID ${dato.id} no encontrado para actualizar.');
    }
  }

  @override
  Future<void> deleteDato(int id) async {
    await Future.delayed(const Duration(seconds: 2));
    _fakeDatos.removeWhere((dato) => dato.id == id);
  }
}
