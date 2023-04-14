/*
 *     Copyright (c) 2022.
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

class TextScalingFactor {
  const TextScalingFactor({
    this.scaleFactor = 1.0,
  });

  final double scaleFactor;

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final TextScalingFactor otherModel = other as TextScalingFactor;
    return otherModel.scaleFactor == scaleFactor;
  }

  @override
  int get hashCode => scaleFactor.hashCode;
}