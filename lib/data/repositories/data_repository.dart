import '../../data/models/data_model.dart';

abstract class DataRepository {
  Future<List<DataModel>> getAllDatos();
  Future<DataModel> addDato(DataModel dato);
  Future<void> updateDato(DataModel dato);
  Future<void> deleteDato(int id);
}
