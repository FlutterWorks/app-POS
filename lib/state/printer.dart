import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:sultanpos/preference.dart';
import 'package:sultanpos/repository/repository.dart';
import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:sultanpos/util/escp.dart';
import 'package:sultanpos/util/format.dart';

class PrinterState extends ChangeNotifier {
  final SaleRepository saleRepo;
  final UnitRepository unitRepo;
  final Preference preference;
  StreamSubscription? _discoverStream;
  List<PrinterDevice> printers = [];

  PrinterState({
    required this.preference,
    required this.saleRepo,
    required this.unitRepo,
  });

  discover() {
    printers = [];
    notifyListeners();
    _discoverStream = PrinterManager.instance.discovery(type: PrinterType.usb).listen((event) {
      printers.add(event);
      notifyListeners();
    });
  }

  stopDiscover() {
    _discoverStream?.cancel();
    _discoverStream = null;
  }

  printSale(int id) async {
    final printer = preference.getDefaultPrinter();
    if (printer == null) {
      throw 'no printer found';
    }
    try {
      final sale = await saleRepo.get(id);
      final items = await saleRepo.items(id);
      final payments = await saleRepo.payments(id);
      final profile = await CapabilityProfile.load();
      final Escp escp = Escp(PaperSize.mm58, profile);

      escp
          .text("Sultan POS", style: const PosStyles(height: PosTextSize.size2, align: PosAlign.center))
          .text("Jln. Surabaya Cepu", style: const PosStyles(align: PosAlign.center))
          .hr()
          .style(const PosStyles())
          .leftRight("Tanggal", formatDateTimeWithMonthName(sale.date.toLocal()))
          .leftRight("Kasir", sale.user!.name)
          .leftRight("No.", sale.id.toRadixString(36).toUpperCase())
          .hr();

      for (int i = 0; i < items.data.length; i++) {
        final data = items.data[i];
        final unit = await unitRepo.get(data.product!.unitId);
        escp.text("${data.product!.barcode} ${data.product!.name}").leftRight(
            "${formatStock(data.amount)} ${unit.name} x ${formatMoney(data.price)}", formatMoney(data.total));
      }
      escp.hr().leftRight("Total", formatMoney(sale.total));
      if (payments.data.length == 1) {
        final payment = payments.data[0];
        escp
            .leftRight("Pembayaran", formatMoney(payment.payment))
            .leftRight("Kembali", formatMoney(sale.total - payment.payment));
      } else {
        for (int i = 0; i < payments.data.length; i++) {
          final payment = payments.data[i];
          escp
              .hr()
              .leftRight("Metode", payment.paymentMethod.name)
              .leftRight("Pembayaran", formatMoney(payment.amount));
        }
      }
      if (sale.paymentResidual == 0) {
        escp
            .hr()
            .text("*** LUNAS ***", style: const PosStyles(bold: true, align: PosAlign.center))
            .style(const PosStyles());
      }
      escp.hr().text("Terima kasih sudah berbelanja", style: const PosStyles(align: PosAlign.center)).feed(2);

      final connect = await PrinterManager.instance.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
            name: printer.name,
            productId: printer.productId,
            vendorId: printer.vendorId,
          ));
      if (connect) {
        await PrinterManager.instance.send(type: PrinterType.usb, bytes: escp.data);
        await PrinterManager.instance.disconnect(type: PrinterType.usb);
      } else {
        throw 'unable to connect printer';
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
