import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaler.dart';
import 'package:pumped_end_device/user-interface/utils/textscaling/text_scaling_factor.dart';

class SaFuelStationSourceCitation extends StatelessWidget {
  static const _subTitle = 'SA - Fuel Price Data License Obligation';

  static const _saLicensePara1 = '© State of South Australia (Office of Consumer and Business Services 2021-2023. '
      'Copyright of the State of South Australia';
  static const _saLicensePara2 = 'Based on or contains data provided by the State of South Australia '
      '(Office of Consumer and Business Services 2021-2023). In consideration of the State permitting use of this '
      'data you acknowledge and agree that the State gives no warranty in relation to the data (including accuracy, '
      'reliability, completeness, currency or suitability) and accepts no liability (including without limitation, '
      'liability in negligence) for any loss, damage or costs (including consequential damage) relating to any use '
      'of the data. Data must not be used for direct marketing or be used in breach of the privacy laws.';

  static const _pumpedMessage = 'If fuel price is incorrect please let us know';

  const SaFuelStationSourceCitation({super.key});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(15), child: _getSaFuelAuthorityMessage(context));
  }

  _getSaFuelAuthorityMessage(final BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(_subTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_saLicensePara1, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(_saLicensePara2, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyMedium,
              textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)),
      Padding(padding: const EdgeInsets.only(bottom: 6), child: _getAdminContactMessage(context)),
      const Divider(height: 1),
      const SizedBox(height: 6),
      _getOkActionButton(context)
    ]);
  }

  Text _getAdminContactMessage(final BuildContext context) {
    return Text(_pumpedMessage,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
        textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor);
  }

  Row _getOkActionButton(final BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child:
                  Row(children: [const Icon(Icons.cancel_outlined, size: 24), const SizedBox(width: 10),
                    Text('Cancel', textScaleFactor: PedTextScaler.of<TextScalingFactor>(context)?.scaleFactor)]))),
      const SizedBox(width: 10),
    ]);
  }
}
