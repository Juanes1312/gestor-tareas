import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/models.dart';
import '../../domain/providers/providers.dart';
import '../../config/routes/app_routes.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final NumberFormat numberFormat = NumberFormat('#,##0', 'es_CO');

  List<DataModel> datos = [];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoute.loginRoute);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          const textStyle = TextStyle(fontSize: 18);
          if (dataProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataProvider.hasError) {
            return Center(
              child: Text(
                'Error al cargar datos: \nError: ${dataProvider.errorMessage}',
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            );
          } else if (dataProvider.datos.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos disponibles',
                style: textStyle,
              ),
            );
          }

          final datos = dataProvider.datos;
          return Container(
            margin: const EdgeInsets.all(10),
            child: RefreshIndicator(
              onRefresh: () async {
                await dataProvider.loadData();
              },
              child: ListView.builder(
                itemCount: datos.length,
                itemBuilder: (context, index) {
                  DataModel dato = datos[index];
                  return Dismissible(
                    key: ValueKey(dato.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) async {
                      await dataProvider.deleteDato(dato.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dato ${dato.titulo} eliminado!')),
                      );
                    },
                    background: Container(
                      padding: const EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Eliminando',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      bool? resp = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Seguro de eliminar el dato'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  return Navigator.pop(context, false);
                                },
                                child: const Text('NO'),
                              ),
                              TextButton(
                                onPressed: () {
                                  return Navigator.pop(context, true);
                                },
                                child: const Text('Si'),
                              )
                            ],
                          );
                        },
                      );
                      return resp ?? false;
                    },
                    child: Card(
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: dato.completada ? Colors.green[100] : Colors.blue[100],
                          child: Icon(
                            dato.completada ? Icons.check_circle : Icons.task_alt,
                            color: dato.completada ? Colors.green[700] : Colors.blue[700],
                          ),
                        ),
                        title: Text(
                          'Titulo: ${dato.titulo}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Descripción: ${dato.descripcion}'),
                            Text(
                              'Estado: ${dato.completada ? 'Completada' : 'Pendiente'}',
                              style: TextStyle(
                                fontWeight: dato.completada ? FontWeight.bold : FontWeight.normal,
                                color: dato.completada ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoute.viewRoute, arguments: dato).then(
                                  (value) => dataProvider.loadData(),
                                );
                              },
                              icon: const Icon(Icons.remove_red_eye),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoute.formRoute, arguments: dato).then(
                                  (value) => dataProvider.loadData(),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppRoute.formRoute,
              arguments: DataModel.Empty(),
            ).then((value) => Provider.of<DataProvider>(context, listen: false).loadData());
          },
          child: const Icon(Icons.add)),
    );
  }
}
