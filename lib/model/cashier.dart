import 'package:sultanpos/model/base.dart';
import 'package:sultanpos/model/user.dart';

part 'cashier.g.dart';

@JsonSerializable(explicitToJson: true)
class CashierSessionModel extends BaseModel {
  final int id;
  final String number;
  @JsonKey(name: 'date_open')
  final DateTime dateOpen;
  @JsonKey(name: 'date_close')
  final DateTime? dateClose;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'open_value')
  final int openValue;
  @JsonKey(name: 'close_value')
  final int closeValue;
  @JsonKey(name: 'calculated_value')
  final int calculatedValue;
  @JsonKey(name: 'machine_id')
  final int machineId;
  final String note;
  final UserModel? user;
  CashierSessionModel(
    this.id,
    this.number,
    this.dateOpen,
    this.dateClose,
    this.userId,
    this.openValue,
    this.closeValue,
    this.calculatedValue,
    this.machineId,
    this.note,
    this.user,
  );
  @override
  factory CashierSessionModel.fromJson(Map<String, dynamic> json) => _$CashierSessionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CashierSessionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CashierSessionInsertModel extends BaseModel {
  @JsonKey(name: 'branch_id')
  final int branchId;
  @JsonKey(name: 'date_open')
  final DateTime dateOpen;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'open_value')
  final int openValue;
  @JsonKey(name: 'machine_id')
  final int machineId;
  final String note;

  CashierSessionInsertModel({
    required this.branchId,
    required this.dateOpen,
    required this.userId,
    required this.openValue,
    required this.machineId,
    required this.note,
  });

  @override
  factory CashierSessionInsertModel.fromJson(Map<String, dynamic> json) => _$CashierSessionInsertModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CashierSessionInsertModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CashierSessionCloseModel extends BaseModel {
  @JsonKey(name: 'date_close')
  final DateTime dateClose;
  @JsonKey(name: 'close_value')
  final int closeValue;

  CashierSessionCloseModel(
    this.dateClose,
    this.closeValue,
  );

  @override
  factory CashierSessionCloseModel.fromJson(Map<String, dynamic> json) => _$CashierSessionCloseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CashierSessionCloseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CashierSessionReportModel extends BaseModel {
  @JsonKey(name: 'sale_count')
  final int saleCount;
  @JsonKey(name: 'payment_in_count')
  final int paymentInCount;
  @JsonKey(name: 'payment_out_count')
  final int paymentOutCount;
  @JsonKey(name: 'payment_in_total')
  final int paymentInTotal;
  @JsonKey(name: 'payment_out_total')
  final int paymentOutTotal;
  CashierSessionReportModel(
    this.saleCount,
    this.paymentInCount,
    this.paymentOutCount,
    this.paymentInTotal,
    this.paymentOutTotal,
  );

  @override
  factory CashierSessionReportModel.fromJson(Map<String, dynamic> json) => _$CashierSessionReportModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CashierSessionReportModelToJson(this);

  int calculated() {
    return paymentInTotal - paymentOutTotal;
  }
}
