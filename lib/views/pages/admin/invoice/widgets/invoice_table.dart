import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'invoice_detail_dialog.dart';

class InvoiceTable extends StatelessWidget {
  final List<Map<String, dynamic>> invoices;

  const InvoiceTable({super.key, required this.invoices});

  TableRow buildHeaderRow(List<String> headers, List<double> colWidths) {
    return TableRow(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
      children: List.generate(headers.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          width: colWidths[index],
          child: Text(
            headers[index],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  TableRow buildInvoiceRow(BuildContext context, Map<String, dynamic> invoice, List<double> colWidths) {
    final isMobile = Responsive.isMobile(context);

    return TableRow(
      children: isMobile
          ? [
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText(invoice['id'], colWidths[0]),
        ),
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText(
              DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['orderDate'])),
              colWidths[1]),
        ),
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText('${(invoice['totalAmount'] as double).toStringAsFixed(0)}đ', colWidths[2]),
        ),
      ]
          : [
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText(invoice['id'], colWidths[0]),
        ),
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText(invoice['customerName'], colWidths[1]),
        ),
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText(
              DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice['orderDate'])),
              colWidths[2]),
        ),
        InkWell(
          onTap: () => _showInvoiceDetail(context, invoice),
          child: cellText('${(invoice['totalAmount'] as double).toStringAsFixed(0)}đ', colWidths[3]),
        ),
      ],
    );
  }

  Widget cellText(String text, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }

  void _showInvoiceDetail(BuildContext context, Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return InvoiceDetailDialog(invoice: invoice);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final double tableWidth = constraints.maxWidth;

        final List<double> colWidths = isMobile
            ? [tableWidth * 0.3, tableWidth * 0.3, tableWidth * 0.3]
            : List.generate(4, (index) => tableWidth / 4);

        final headers = isMobile
            ? ["Invoice ID", "Date", "Total Amount"]
            : ["Invoice ID", "Customer", "Date", "Total Amount"];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Invoice List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (int i = 0; i < colWidths.length; i++) i: FixedColumnWidth(colWidths[i]),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  buildHeaderRow(headers, colWidths),
                  ...invoices.map((invoice) => buildInvoiceRow(context, invoice, colWidths)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}