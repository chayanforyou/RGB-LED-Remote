import '../data/models/pronto_command.dart';
import 'pronto_data_type1.dart';
import 'pronto_data_type2.dart';

enum ProntoDataType { type1, type2 }

List<ProntoCommand> getProntoData(ProntoDataType type) {
  switch (type) {
    case ProntoDataType.type1:
      return prontoDataType1;
    case ProntoDataType.type2:
      return prontoDataType2;
  }
}
