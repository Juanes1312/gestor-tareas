import 'package:data_management/config/themes/app_themes.dart';
import 'package:data_management/data/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

const List<String> opciones = [
  "Alta",
  "Media",
  "Baja",
];

class FormScreen extends StatefulWidget {
  final DataModel? initialData;

  const FormScreen({super.key, this.initialData});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaDeVencimientoController = TextEditingController();

  String opcion = opciones.first;
  bool suiche = false;

  late DataModel _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData ?? DataModel.Empty();

    tituloController.text = _currentData.titulo;
    descripcionController.text = _currentData.descripcion;

    if (_currentData.id != null) {
      fechaDeVencimientoController.text = _currentData.fechaDeVencimiento;
      opcion = _currentData.prioridad;
      suiche = _currentData.completada;
    } else {
      fechaDeVencimientoController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Tarea'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 8),
              CustomText(
                labelText: "Titulo de la tarea",
                controller: tituloController,
                validator: validarText,
              ),
              const SizedBox(height: 8),
              CustomText(
                labelText: "Descripcion",
                controller: descripcionController,
                validator: validarText,
              ),
              const SizedBox(height: 8),
              dropdownOpcionesPrioridad(),
              const SizedBox(height: 8),
              fecha(),
              const SizedBox(height: 8),
              campoSuiche(),
              const SizedBox(height: 8),
              customButton(dataProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropdownOpcionesPrioridad() {
    return DropdownButtonFormField(
      value: opcion,
      items: opciones.map((op) {
        return DropdownMenuItem(value: op, child: Text(op));
      }).toList(),
      onChanged: (value) {
        setState(() {
          opcion = value as String;
        });
      },
      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2), labelText: "Prioridad", border: OutlineInputBorder()),
      validator: (value) => value == null ? "debe seleccionar una opcion." : null,
    );
  }

  Widget fecha() {
    return TextFormField(
      controller: fechaDeVencimientoController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        labelText: 'Fecha vencimiento',
      ),
      readOnly: true,
      onTap: () async {
        DateTime? fechaPicker = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100), initialDate: DateTime.now());
        if (fechaPicker != null) {
          String fecha = DateFormat('yyyy-MM-dd').format(fechaPicker);
          setState(() {
            fechaDeVencimientoController.text = fecha;
          });
        } else {
          print('No se ha seleccionado ninguna fecha');
        }
      },
    );
  }

  Widget campoSuiche() {
    return InputDecorator(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          labelText: "Estado de la tarea",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          )),
      child: SwitchListTile(
        activeColor: AppThemes.primary,
        value: suiche,
        title: const Text("Completada"),
        onChanged: (value) {
          setState(() {
            suiche = value;
          });
        },
      ),
    );
  }

  String? validarText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debe digitar un texto';
    } else if (value.length < 3) {
      return 'El texto debe tener más de 5 caracteres';
    } else {
      return null;
    }
  }

  FractionallySizedBox customButton(DataProvider dataProvider) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: ElevatedButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) {
            return;
          }
          DataModel dataModel = desdeFormulario();
          try {
            if (_currentData.id != null) {
              await dataProvider.updateDato(dataModel);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dato actualizado!')),
              );
            } else {
              await dataProvider.addDato(dataModel);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dato creado!')),
              );
            }
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.pop(context);
          } catch (e) {
            print('Error al guardar datos: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar datos: $e')),
            );
          }
        },
        child: const Text(
          'Guardar',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  DataModel desdeFormulario() {
    return DataModel(
      id: _currentData.id,
      titulo: tituloController.text,
      descripcion: descripcionController.text,
      prioridad: opcion,
      fechaDeVencimiento: fechaDeVencimientoController.text,
      completada: suiche,
    );
  }
}
