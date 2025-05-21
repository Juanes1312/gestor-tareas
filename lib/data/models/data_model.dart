class DataModel {
  final int? id;
  final String titulo;
  final String descripcion;
  final String fechaDeVencimiento;
  final String prioridad;
  final bool completada;

  DataModel({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.prioridad,
    required this.fechaDeVencimiento,
    required this.completada,
  });

  DataModel.Empty({
    this.id = null,
    this.titulo = '',
    this.descripcion = '',
    this.prioridad = '',
    this.fechaDeVencimiento = '',
    this.completada = false,
  });

  DataModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        titulo = map['titulo'],
        descripcion = map['descripcion'],
        prioridad = map['prioridad'],
        fechaDeVencimiento = map['fechaDeVencimiento'],
        completada = map['completada'] == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'fechaDeVencimiento': fechaDeVencimiento,
      'completada': completada ? 1 : 0,
    };
  }

  DataModel copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    String? prioridad,
    String? fechaDeVencimiento,
    bool? completada,
  }) {
    return DataModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      prioridad: prioridad ?? this.prioridad,
      fechaDeVencimiento: fechaDeVencimiento ?? this.fechaDeVencimiento,
      completada: completada ?? this.completada,
    );
  }
}
