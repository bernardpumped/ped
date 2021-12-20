
/*
 *     Copyright (c) 2021.
 *     This file is part of Pumped End Device.
 *
 *     Pumped End Device is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Pumped End Device is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with Pumped End Device.  If not, see <https://www.gnu.org/licenses/>.
 */

class ZoneConfig {
  /*
    This is trimmed down version of Zone config
    defined in backend. Trimming is done based on data
    required by the pumped_end_device
   */
  String zoneId;
  String marketRegion;
  double maxRadius;
  int configVersion;
  bool inProd;
  String zoneStatus;
  double minDistanceLocationUpdates;
  int minTimeLocationUpdates;
  double topLatitude;
  double leftLongitude;
  double bottomLatitude;
  double rightLongitude;
  String zoneType;

  ZoneConfig ({
    this.zoneId ,
    this.marketRegion ,
    this.maxRadius ,
    this.configVersion ,
    this.inProd ,
    this.zoneStatus ,
    this.minDistanceLocationUpdates ,
    this.minTimeLocationUpdates ,
    this.topLatitude ,
    this.leftLongitude ,
    this.bottomLatitude ,
    this.rightLongitude ,
    this.zoneType ,
  });

  Map<String, dynamic> toJson() => {
    'zone_id' : zoneId,
    'market_region' : marketRegion,
    'max_radius' : maxRadius,
    'config_version' : configVersion,
    'in_prod' : inProd,
    'zone_status' : zoneStatus,
    'min_distance_location_updates' : minDistanceLocationUpdates,
    'min_time_location_updates' : minTimeLocationUpdates,
    'top_latitude' : topLatitude,
    'left_longitude' : leftLongitude,
    'bottom_latitude' : bottomLatitude,
    'right_longitude' : rightLongitude,
    'zone_type' : zoneType
  };

  Map<String, dynamic> toMap() => toJson();

  factory ZoneConfig.fromJson(final Map<String, dynamic> data) => ZoneConfig(
      zoneId: data['zone_id'],
      marketRegion: data['market_region'],
      maxRadius: data['max_radius'],
      configVersion: data['config_version'],
      inProd: data['in_prod'],
      zoneStatus: data['zone_status'],
      minDistanceLocationUpdates: data['min_distance_location_updates'],
      minTimeLocationUpdates: data['min_time_location_updates'],
      topLatitude: data['top_latitude'],
      leftLongitude: data['left_longitude'],
      bottomLatitude: data['bottom_latitude'],
      rightLongitude: data['right_longitude'],
      zoneType: data['zone_type']
  );

  factory ZoneConfig.fromMap(final Map<String, dynamic> data) => ZoneConfig.fromJson(data);
}