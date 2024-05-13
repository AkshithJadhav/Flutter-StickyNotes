import 'dart:collection';

import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "sticky-notes-423219",
  "private_key_id": "27bfda79320e899e6d34ceafc2ebe9e4af4b0096",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCd/WF6rzre4LMI\nyoPJJfT9bxTKS54wP5fqoI2m4I5IyQbsANx427BnAB14d6Z1Wje9KGC8/7BpuJ96\nsfB6nbGZndBX0OCqrof5PXn0LRUGFjtY6ncUEipje1zMsk3rMeiuMver4zXGhxhC\nmoHZulCKqAnA9olXMW2IOOReod9xNcFOyYBuragaY7xmVUQyU2Z9ulJY5epj9K5U\n97gwrmYTxHbNCblIjvx5VdjSphCkNvLYhk50xfMUJkxogE4B+q7xoXIm9PYDkfXi\nsJof/jQzVIi2qj5nwGjXXgTr7WFizWVu8Ob5yDInPnxipxbfyQ0BC+DMNtXFVp5z\nO2xmxqA7AgMBAAECggEACcu9oQ0/YbVd9HQWEsFDPPmHuPlSUByJT1dwIQI4YEPy\npWxyPx4kBGbp7N/CVvFmllhsExvpdMypOsLQrdGcQvGZivBdFcgnjykkKCMpdAyp\n1lwHURvFPBDYkqqVkTkxe6eWWraGTY5vzyVkWrsmJkq//BJtNpZOe81HP6TaxVqe\nZ7Mx+FaNj+5e0Rx/DY+ZCheXGwyS2MYPpKAu3T5McujNypUUC5ncYUlOdLgpq72h\niwuO3GC70S/TnlQKOfnDjSbVo9+jQcpn3VejA44EgVfLTGl1Hb9untHSWwtwuv/M\nYsz/bQLJfHPRAw6/i8B7xnYnnZJnD+tGQIIKenAjVQKBgQDXbH+BGIE87tboioNI\nUxd/AsZ0MQHxt/5hZBYM/lre/i8cAGcsV5hedfQvdUx7kO7bujPRVLx2BP4IanCW\nZkCIlJDJy0qdVgt6qMBDVRfDM+6QsPb8CnydmNwikVbwgKq5XLELBCiJGN+y11YR\nZ/mDLelyg827m/MprVNP2xxoNQKBgQC7v3mtd1dsHbnTSva75Fvm3qxZuKcmzBkM\n27l5tv5nGUjUJPAAOEDtQf3awUKgM2yMojTCPXO5u6xje4wTVcxCuAM4ZOitMlmt\nvJGoxly4SnGdaluf5/zNJlm+AueZVUQRvzECKxjfUMDJLJRsuYyZa7Fvh1CWODw6\nWrm2hMJUrwKBgCHYyTvGVt/1As0sni3p6EIrdHTjElQhPZWdvR0zhaGNvGcg5RUB\nek41KDWgr3Cmt/DME8IrFyVP6X33A1OOI0uSVCFwkHuh/lG6W+L4ZrBj43LWayf0\nmdnFH6lKvqcxACH5n1OExr2rq9IUpVA8zuY+e3Rjoxp8CTueIP3mBlOVAoGAXZ4Z\np1S14/Rin6hmpcQ1y0ZHfKmlt6PX7eB2eOm1q2UhOp98iS+DuIrKcVUiys05mFqd\noimQVhHt4OFPNKj4pGArQuiWWR6dNxOrMhRPUZnVU2Agdfjwxr8TyrqaD4xD1/GV\nF3az/U7AAtBW5mwTXsEjhfBcT7uU1Kg+qHNEj4MCgYEAxJ+1D3Grc+Pcdef8g1Tw\npWOc76jRGtraIJxfznsom337fIUryNKTX2CRJLIarhBFGqjU76z4bC9kgojV8mIm\nTXegQ/3UASXhxokR1pgfcqvvXrIkkquWiv3syy7fHjNsl1NnmxfNO7SeWnIVQDB5\nKQeFYLN6j1Ojj3hfQwFGOWo=\n-----END PRIVATE KEY-----\n",
  "client_email": "sticky-notes@sticky-notes-423219.iam.gserviceaccount.com",
  "client_id": "115551934334999998978",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sticky-notes%40sticky-notes-423219.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  //setup and connect the spreadsheet
  static final _spreadsheetId = '1GkC8yT4lOuQ9dv27o2zc8ZQLIFi8EbblV2wWvTWvPEs';
  static final gsheet = GSheets(_credentials);
  static Worksheet? _worksheet;

  //some variables
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

  //init the spreadsheet
  Future init() async {
    final ss = await gsheet.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  //count the number of Rows
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    loadNotes();
  }

  //load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNode =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNode);
      }
    }
    loading = false;
  }

  //insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }
}
