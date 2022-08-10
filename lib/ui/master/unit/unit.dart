import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sultanpos/model/unit.dart';
import 'package:sultanpos/state/app.dart';
import 'package:sultanpos/state/unit.dart';
import 'package:sultanpos/ui/master/unit/add.dart';
import 'package:sultanpos/ui/widget/confirmation.dart';
import 'package:sultanpos/ui/widget/datatable.dart';
import 'package:sultanpos/ui/widget/showerror.dart';

class UnitWidget extends StatelessWidget {
  const UnitWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UnitState>.value(
      value: AppState().unitState!,
      child: Builder(
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Daftar Unit',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {
                        AppState().unitState!.resetForm();
                        showDialog(
                          context: ctx,
                          useRootNavigator: false,
                          builder: (c) {
                            return const UnitAddWidget(
                              title: "Tambah Unit Baru",
                            );
                          },
                        );
                      },
                      child: const Text('Tambah Unit'),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                    child: SDataTable<UnitModel>(
                  state: AppState().unitState!.listData,
                  columns: [
                    SDataColumn(
                      width: 100,
                      id: 'action',
                      title: 'Action',
                      getWidget: (v) => Row(children: [
                        IconButton(
                          iconSize: 16,
                          splashRadius: 16,
                          onPressed: () {
                            AppState().unitState!.editForm(v);
                            showDialog(
                              context: ctx,
                              useRootNavigator: false,
                              builder: (c) {
                                return const UnitAddWidget(title: "Edit Unit");
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          iconSize: 16,
                          splashRadius: 16,
                          onPressed: () async {
                            final result = await showConfirmation(ctx, title: 'Yakin hapus', message: 'Yakin untuk menghapus "${v.name}"');
                            if (result) {
                              try {
                                await AppState().unitState!.remove(v.publicId);
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                showError(ctx, title: 'Error menghapus', message: e.toString());
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                        ),
                      ]),
                    ),
                    SDataColumn(
                      id: 'publicId',
                      title: 'ID',
                      get: (v) => v.publicId,
                    ),
                    SDataColumn(
                      id: 'name',
                      title: 'Nama',
                      get: (v) => v.name,
                    ),
                    SDataColumn(
                      id: 'description',
                      title: 'Keterangan',
                      get: (v) => v.description,
                    ),
                  ],
                )),
                /*Expanded(
                  child: ListWidget<UnitModel>(
                    AppState().unitState!.listData,
                    builder: (BuildContext ctx, UnitModel value) {
                      return ListTile(
                        title: Text(value.name),
                        onTap: () {
                          AppState().unitState!.editForm(value);
                          showDialog(
                            context: ctx,
                            useRootNavigator: false,
                            builder: (c) {
                              return const UnitAddWidget(title: "Edit Unit");
                            },
                          );
                        },
                        trailing: IconButton(
                            onPressed: () async {
                              final result = await showConfirmation(ctx, title: 'Yakin hapus', message: 'Yakin untuk menghapus "${value.name}"');
                              if (result) {
                                try {
                                  await AppState().unitState!.remove(value.publicId);
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  showError(ctx, title: 'Error menghapus', message: e.toString());
                                }
                              }
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    },
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
