import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

///use this on simple widgets and the providers on app screens or pages

extension TechnicalAssessmentAppLocalisation on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
