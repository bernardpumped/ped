enum FuelStationType {
  favourite, nearby
}

extension FuelStationTypeExt on FuelStationType {
  static const _readableName = {
    FuelStationType.favourite : 'favourite',
    FuelStationType.nearby : 'nearby',
  };

  String? get readableName => _readableName[this];
}