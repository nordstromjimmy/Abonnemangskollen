import 'package:intl/intl.dart';

class MoneyFmt {
  static final NumberFormat sek = NumberFormat.currency(
    locale: 'sv_SE',
    symbol: 'kr',
  );
  static String sekText(num value) => sek.format(value);
}
