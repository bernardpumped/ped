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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pumped_end_device/data/local/dao/update_history_dao.dart';
import 'package:pumped_end_device/user-interface/tabs/update-history/screen/widgets/update_history_item_widget.dart';
import 'package:pumped_end_device/user-interface/utils/widget_utils.dart';
import 'package:pumped_end_device/user-interface/widgets/application_title_text_widget.dart';
import 'package:pumped_end_device/models/update_history.dart';
import 'package:pumped_end_device/util/log_util.dart';

class UpdateHistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateHistoryScreenState();
  }
}

class _UpdateHistoryScreenState extends State<UpdateHistoryScreen> {
  Future<List<UpdateHistory>> updateHistoryFuture;
  @override
  void initState() {
    super.initState();
    updateHistoryFuture = UpdateHistoryDao.instance.getAllUpdateHistory();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(middle: ApplicationTitleTextWidget()),
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(right: 5, bottom: 5, left: 5),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: WidgetUtils.getTabHeaderWidget(context, "Update History")),
              Expanded(
                  child: FutureBuilder<List<UpdateHistory>>(
                      future: updateHistoryFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return RefreshIndicator(
                              color: Colors.blue,
                              child: _getUpdateHistoryItemList(snapshot.data),
                              onRefresh: () async {
                                setState(() {
                                  updateHistoryFuture = UpdateHistoryDao.instance.getAllUpdateHistory();
                                });
                              });
                        } else if (snapshot.hasError) {
                          LogUtil.debug('updateHistory', 'Error happened ${snapshot.error}');
                          return RefreshIndicator(
                              color: Colors.blue,
                              child: Center(child: Text('Error Loading Update History')),
                              onRefresh: () async {
                                setState(() {
                                  updateHistoryFuture = UpdateHistoryDao.instance.getAllUpdateHistory();
                                });
                              });
                        } else {
                          return CircularProgressIndicator();
                        }
                      }))
            ])));
  }

  Widget _getUpdateHistoryItemList(final List<UpdateHistory> updateHistories) {
    if (updateHistories != null && updateHistories.length > 0) {
      return ListView.builder(
          itemCount: updateHistories.length,
          itemBuilder: (context, index) {
            return UpdateHistoryItemWidget(updateHistories[index]);
          });
    } else {
      return Container(
          child: ListView(children: <Widget>[
        Center(child: Text('No Update History Found', style: TextStyle(fontSize: 18, color: Colors.black87)))
      ]));
    }
  }
}
