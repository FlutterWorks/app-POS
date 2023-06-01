import 'package:reactive_forms/reactive_forms.dart';
import 'package:sultanpos/model/base.dart';
import 'package:sultanpos/model/error.dart';
import 'package:sultanpos/state/base.dart';
import 'package:sultanpos/state/list.dart';

abstract class CrudState<T extends BaseModel> extends BaseState {
  final String path;
  final T Function(Map<String, dynamic> json) creator;

  ListHttpState<T> listData;
  bool loading = false;
  T? current;
  late FormGroup form;

  CrudState(super.httpAPI, {required this.path, required this.creator})
      : listData = ListHttpState<T>(httpAPI, path, creator);

  resetForm() {
    form.reset();
    form.markAllAsTouched();
    current = null;
  }

  editForm(T value) {
    prepareEditForm(value);
    form.markAllAsTouched();
    current = value;
  }

  prepareEditForm(T value);

  save() async {
    if (!form.valid) throw 'form tidak valid';
    loading = true;
    notifyListeners();
    try {
      if (current == null) {
        await httpAPI.insert(prepareInsertModel());
      } else {
        await httpAPI.update(prepareUpdateModel(), (current as BaseModel).getId());
      }
      loading = false;
      notifyListeners();
      listData.load(refresh: true);
    } on ErrorResponse catch (e) {
      loading = false;
      notifyListeners();
      throw e.message;
    } catch (e) {
      loading = false;
      notifyListeners();
      throw e.toString();
    }
  }

  BaseModel prepareInsertModel();
  BaseModel prepareUpdateModel();

  remove(int id) async {
    try {
      await httpAPI.delete('$path/$id');
      listData.load(refresh: true);
    } on ErrorResponse catch (e) {
      throw e.message;
    }
  }
}
