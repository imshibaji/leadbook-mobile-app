import 'dart:async';
import 'dart:typed_data';

import 'package:clean_architecture/features/lead_mod/lead_app.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../../../core/core.dart';
import '../../../dbobj/dbobjs.dart';
import '../../../providers/providers.dart';
import '../../../services/services.dart';

class PrintDeal extends StatefulWidget {
  const PrintDeal({Key? key}) : super(key: key);

  @override
  State<PrintDeal> createState() => _PrintDealState();
}

class _PrintDealState extends State<PrintDeal> with AfterLayoutMixin {
  Business? business;
  Profile? profile;
  Deal? deal;
  Lead? lead;

  BusinessService? bs;
  ProfileService? ps;

  LeadService? ls;

  bool useDigiSign = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      dataInit();
    });
  }

  void dataInit() {
    fillupBusinessData();
    fillupProfleData();
  }

  void fillupBusinessData() {
    if (business == null) {
      bs = BusinessService();
      if (bs != null && bs!.box != null && bs!.box!.isNotEmpty) {
        business = bs!.get(0);
      } else {
        showMessage(context, 'Please Setup Your Business details first');
        Nav.toReplace(context, LeadApp.listDeal);
      }
    }
    if ((business!.name == null || business!.name!.isEmpty)) {
      showMessage(context, 'Please Fill-up Your Business Details');
      Nav.toReplace(context, LeadApp.businessPage);
    }
  }

  void fillupProfleData() {
    if (profile == null) {
      ps = ProfileService();
      if (ps != null && ps!.box != null && ps!.box!.isNotEmpty) {
        profile = ps!.get(0);
      } else {
        showMessage(context, 'Please Setup Your Profile Information');
        Nav.toReplace(context, LeadApp.listDeal);
      }
    }
    if ((profile!.name == null || profile!.name!.isEmpty)) {
      showMessage(context, 'Please Fill-up Your Profile Details');
      Nav.toReplace(context, LeadApp.profile);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    dealData(context);
  }

  void dealData(BuildContext context) {
    setState(() {
      deal = Nav.routeData(context) == null
          ? Deal()
          : Nav.routeData(context) as Deal;
      // log(deal.toString());

      final sp = context.read<ServiceProvider>();
      lead = sp.leads!.firstWhere(
        (element) => element.uid == deal!.leadUid,
      );
      // log(lead.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((deal != null) ? 'Invoice#${deal!.key + 1}' : 'Invoice'),
        actions: actionsMenu(context),
      ),
      body: deal != null
          ? PdfPreview(
              pdfFileName: (deal != null)
                  ? 'Invoice-${deal!.key + 1}.pdf'
                  : 'Invoice.pdf',
              build: (format) => _generatePdf(format, 'Test Invoive PDF'),
              dynamicLayout: false,
              canChangeOrientation: false,
              initialPageFormat: PdfPageFormat.a4,
              canDebug: false,
              previewPageMargin: const EdgeInsets.all(20),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      useDigiSign = !useDigiSign;
                    });
                  },
                  child: const Text('Digital Sign'),
                )
              ],
            )
          : const Center(
              child: Text('Invoice Generating...'),
            ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
      title: (deal != null) ? 'Invoice#${deal!.key + 1}' : 'Invoice',
      creator: 'LeadsBook',
      author: 'Shibaji Debnath',
    );
    final font = await PdfGoogleFonts.nunitoExtraLight();
    final signFont = await PdfGoogleFonts.dancingScriptRegular();

    pdf.addPage(
      pw.Page(
        clip: true,
        margin: const pw.EdgeInsets.all(20),
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pageHeader(font),
              pw.Divider(),
              pageBody(font, signFont),
              pw.Divider(),
              pageFooter(font),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Expanded pageBody(pw.Font font, [pw.Font? signFont]) {
    return pw.Expanded(
      child: pw.Container(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Invoice',
                style: const pw.TextStyle(fontSize: 24),
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            billingInfo(font),
            pw.SizedBox(
              height: 6,
            ),
            invoiceTable(),
            pw.SizedBox(height: 5),
            paidAndPending(),
            pw.SizedBox(height: 10),
            signtureArea(signFont),
            pw.Divider(height: 25),
            paymentDetails(font),
            // toc(font),
          ],
        ),
      ),
    );
  }

  pw.Row paidAndPending() {
    return pw.Row(
      children: [
        if (deal!.paidAmt != null)
          pw.Row(
            children: [
              pw.Text("Paid Amount: "),
              pw.Text(
                (deal!.currencySymbol ?? '\u{20B9}') +
                    deal!.paidAmt!.toStringAsFixed(2) +
                    " " +
                    (deal!.currencyCode ?? 'inr').toUpperCase(),
              ),
            ],
          ),
        pw.SizedBox(
          width: 8,
        ),
        if (deal!.pendingAmt != null)
          pw.Row(
            children: [
              pw.Text("Pending Amount: "),
              pw.Text(
                (deal!.currencySymbol ?? '\u{20B9}') +
                    deal!.pendingAmt!.toStringAsFixed(2) +
                    " " +
                    (deal!.currencyCode ?? 'inr').toUpperCase(),
              ),
            ],
          )
      ],
    );
  }

  pw.Column toc(pw.Font font) {
    return pw.Column(children: [
      pw.Text(
        'Terms and Conditions',
      ),
      pw.Text(
        'This is application Test. This is the note data.',
        style: pw.TextStyle(font: font),
      ),
    ]);
  }

  pw.Row billingInfo(pw.Font font) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            ...clientInfo(font).toList(),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text(
              'Bill NO: 000' + (deal!.key + 1).toString(),
              style: pw.TextStyle(font: font),
            ),
            pw.Text(
              'Jnl ID: ' + deal!.name!,
              style: pw.TextStyle(font: font),
            ),
            // pw.Text(
            // 'Date: ' +
            // deal!.createdAt!.day.toString() +
            // "-" +
            // deal!.createdAt!.month.toString() +
            // "-" +
            // deal!.createdAt!.year.toString() +
            // " " +
            // deal!.createdAt!.hour.toString() +
            // ":" +
            // deal!.createdAt!.minute.toString(),
            // style: pw.TextStyle(font: font),
            // ),
          ]),
        ]);
  }

  pw.Padding paymentDetails(pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 0),
      child: pw
          .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        if (profile != null && profile!.bankAccountNumber != null)
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(
              'Bank Pay Details:',
              style: const pw.TextStyle(fontSize: 18),
            ),
            pw.SizedBox(height: 5),
            if (profile != null && profile!.bankAccountHolder != null)
              pw.Text(
                profile!.bankAccountHolder ?? 'No Name',
                style: pw.TextStyle(fontSize: 20, font: font),
              ),
            if (profile != null && profile!.bankIfsc != null)
              pw.Text(
                'IFSC / RTGS CODE: ' + (profile!.bankIfsc ?? 'No IFSC / RTGS'),
                style: pw.TextStyle(fontSize: 14, font: font),
              ),
            if (profile != null && profile!.bankAccountNumber != null)
              pw.Text(
                'A/C Number: ' +
                    (profile!.bankAccountNumber ?? 'No A/C Number'),
                style: pw.TextStyle(fontSize: 14, font: font),
              ),
          ]),
        if (profile != null &&
            profile!.upiCode != null &&
            deal!.status!.toLowerCase() != 'paid')
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('UPI Payment Code'),
                pw.Text(profile!.upiCode!),
                pw.Padding(
                  padding:
                      const pw.EdgeInsets.only(right: 20, left: 20, top: 5),
                  child: pw.BarcodeWidget(
                    data: UPIDetails(
                      payeeName: profile!.name!,
                      upiID: profile!.upiCode!,
                      transactionNote: deal!.details!,
                      currencyCode: (deal!.currencyCode ?? 'inr').toUpperCase(),
                      amount: (deal!.status!.toLowerCase() != 'paid')
                          ? (deal!.price! - (deal!.discount ?? 0))
                          : 0,
                    ).qrCodeValue,
                    barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode),
                    color: PdfColors.black,
                    width: 90,
                    height: 90,
                  ),
                ),
              ]),
      ]),
    );
  }

  List<pw.Widget> clientInfo(pw.Font font) {
    return [
      pw.Text(
        'To',
        style: const pw.TextStyle(fontSize: 24),
      ),
      if (lead != null)
        pw.Text(
          lead!.name ?? 'No Name',
          style: const pw.TextStyle(fontSize: 16),
        ),
      if (lead != null && lead!.address != null)
        pw.Text(
          'Address: ' + (lead!.address ?? 'No Address'),
          style: pw.TextStyle(fontSize: 14, font: font),
        ),
      if (lead != null && lead!.mobile != null)
        pw.Text(
          'Mobile: ' + lead!.mobile! + ', ' + (lead!.altMobile ?? ''),
          style: pw.TextStyle(fontSize: 14, font: font),
        ),
      if (lead != null && lead!.email != null)
        pw.Text(
          'Email: ' + (lead!.email ?? 'No Email'),
          style: pw.TextStyle(fontSize: 16, font: font),
        ),
    ];
  }

  pw.Row signtureArea(pw.Font? signFont) {
    var date = '${deal!.createdAt!.day}/'
        '${deal!.createdAt!.month}/'
        '${deal!.createdAt!.year} ';
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Payment Status: ' + deal!.status!,
              style: const pw.TextStyle(fontSize: 18),
            ),
            pw.Text(
              'Date: ' + date,
              style: const pw.TextStyle(fontSize: 18),
            ),
          ],
        ),
        (useDigiSign == true)
            ? pw.Column(children: [
                pw.Text(
                  'Digital Signature for Online Invoice',
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.black.shade(0.4),
                  ),
                ),
                if (profile != null && profile!.name != null)
                  pw.Text(
                    profile!.name ?? 'No Name',
                    style: pw.TextStyle(fontSize: 28, font: signFont),
                  ),
                pw.Text(
                  'Signature',
                  style: const pw.TextStyle(fontSize: 18),
                ),
              ])
            : pw.Container(
                child: pw.Column(children: [
                  pw.SizedBox(height: 45, width: 165),
                  pw.Text(
                    'Signature',
                    style: const pw.TextStyle(fontSize: 18),
                  ),
                ]),
              ),
      ],
    );
  }

  pw.Table invoiceTable() {
    return pw.Table(border: pw.TableBorder.all(), columnWidths: {
      0: const pw.FixedColumnWidth(100),
      1: const pw.FixedColumnWidth(20)
    }, children: [
      // Table Header
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text('Description', textAlign: pw.TextAlign.center),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text('Amount', textAlign: pw.TextAlign.center),
          ),
        ],
      ),

      // Body Padding
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          if (deal != null)
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: pw.Text(deal!.details ?? 'No Description'),
            ),
          if (deal != null)
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                deal!.currencySymbol! + deal!.price!.toStringAsFixed(2),
                textAlign: pw.TextAlign.right,
              ),
            ),
        ],
      ),

      // Table Footer
      if (deal!.discount != null)
        pw.TableRow(
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Discount ', textAlign: pw.TextAlign.right),
            ),
            if (deal != null)
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  deal!.currencySymbol! + deal!.discount!.toStringAsFixed(2),
                  textAlign: pw.TextAlign.right,
                ),
              ),
          ],
        ),
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text('Total ', textAlign: pw.TextAlign.right),
          ),
          if (deal != null)
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                deal!.currencySymbol! +
                    ((deal!.price ?? 0) - (deal!.discount ?? 0))
                        .toStringAsFixed(2) +
                    ' ' +
                    deal!.currencyCode!,
                textAlign: pw.TextAlign.right,
              ),
            ),
        ],
      ),
    ]);
  }

  pw.SizedBox pageFooter(pw.Font font) {
    return pw.SizedBox(
      width: double.infinity,
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Page 1',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
            pw.Text(
              'Created By: LeadBook',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
          ]),
    );
  }

  pw.SizedBox pageHeader(pw.Font font) {
    return pw.SizedBox(
      width: double.infinity,
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  if (business != null && business!.name != null)
                    pw.Text(
                      business!.name ?? 'No Name',
                      style: pw.TextStyle(font: font, fontSize: 26),
                    ),
                  if (business != null)
                    pw.Text(
                      (business!.address ?? '') +
                          ', ' +
                          (business!.city ?? '') +
                          ', ' +
                          (business!.state ?? '') +
                          ', ' +
                          (business!.country ?? '') +
                          ', ' +
                          (business!.pincode ?? '').toString(),
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                  if (business != null)
                    pw.Text(
                      '(M): ' +
                          (business!.phone ?? '') +
                          ', ' +
                          (business!.altPhone ?? ''),
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                  if (business != null)
                    pw.Text(
                      'Email: ' + (business!.email ?? ''),
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                  if (business != null && business!.website != null)
                    pw.Text(
                      'Website: ' + (business!.website ?? ''),
                      style: pw.TextStyle(font: font, fontSize: 12),
                    ),
                ],
              ),
            ),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
              pw.Text(
                'Contact Information',
                style: pw.TextStyle(font: font, fontSize: 16),
              ),
              if (business != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 20),
                  child: pw.BarcodeWidget(
                    data: 'Name: ' +
                        (business!.name ?? '') +
                        '; Address: ' +
                        (business!.address ?? '') +
                        ', ' +
                        (business!.city ?? '') +
                        ', ' +
                        (business!.state ?? '') +
                        ', ' +
                        (business!.country ?? '') +
                        ', ' +
                        (business!.pincode ?? '').toString() +
                        '; Phone: ' +
                        (business!.phone ?? '') +
                        ', ' +
                        (business!.altPhone ?? '') +
                        '; Email: ' +
                        (business!.email ?? '') +
                        '; Website: ' +
                        (business!.website ?? ''),
                    barcode: pw.Barcode.fromType(pw.BarcodeType.QrCode),
                    color: PdfColors.black,
                    width: 90,
                    height: 90,
                  ),
                ),
            ]),
          ]),
    );
  }
}
