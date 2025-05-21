import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/data_model.dart';

class ViewScreen extends StatefulWidget {
  final DataModel dato;

  const ViewScreen({super.key, required this.dato});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final NumberFormat numberFormat = NumberFormat('#,##0', 'es_CO');

  @override
  Widget build(BuildContext context) {
    final DataModel dato = widget.dato;
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalles de ${dato.titulo}'),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Título de la tarea',
                        style: TextStyle(fontSize: 25, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 20, thickness: 1),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildInfoRow('ID:', dato.id?.toString() ?? 'N/A'),
                      _buildInfoRow('Titulo:', dato.titulo),
                      _buildInfoRow('Descripción:', dato.descripcion),
                      _buildInfoRow('Prioridad:', dato.prioridad),
                      _buildInfoRow('Fecha de Vencimiento:', dato.fechaDeVencimiento),
                      _buildInfoRow('Completada:', dato.completada ? 'Sí' : 'No'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ));
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 17.5, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
