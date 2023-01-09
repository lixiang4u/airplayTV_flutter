import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:airplay/components/common/app_bar_component.dart';
import 'package:airplay/config/widget_configs.dart';
import 'package:airplay/main.dart';

class AboutComponent extends StatefulWidget {
  const AboutComponent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutComponentState();
}

class _AboutComponentState extends State<AboutComponent> {
  Map<String, String> sourceList = <String, String>{
    "cz": "源1(cz)",
    "nn": "源2(nn)",
    "my": "源3(my)",
    "lv": "源4(lv)",
    "five": "源5(five)",
  };

  Map<String, String> cacheList = <String, String>{
    "open": "开启缓存（默认开启，每天更新一次，开启后可能导致部分视频无法观看/更新不及时）",
    "close": "关闭缓存（默认开启，每天更新一次，开启后可能导致部分视频无法观看/更新不及时）",
  };

  late Map<String, bool> sourceListCheckValues;
  late Map<String, bool> cacheListCheckValues;

  @override
  void initState() {
    super.initState();
    sourceListCheckValues = sourceList.map((key, value) {
      if (key == gApp.sourceName) {
        return MapEntry(key, true);
      }
      return MapEntry(key, false);
    });
    cacheListCheckValues = cacheList.map((key, value) {
      if (key == gApp.isCache) {
        return MapEntry(key, true);
      }
      return MapEntry(key, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: '关于', showAbout: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitleLine("视频源（默认由后台接口随机分配）"),
            getVideoSourceList(),
            getTitleLine("数据缓存（加速访问）"),
            getVideoCacheList(),
            getFooter(),
          ],
        ),
      ),
    );
  }

  Widget getTitleLine(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget getVideoSourceList() {
    // ListView单独在Column报错问题：https://stackoverflow.com/questions/51681763/listview-inside-column-causes-vertical-viewport-was-given-unbounded-height
    return ListView(
      itemExtent: 40,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: sourceList.keys.map((k) {
        return ListTile(
          title: Text('${sourceList[k]}'),
          leading: Checkbox(
            value: sourceListCheckValues[k],
            onChanged: (value) {
              updateSourceCheck(k, value);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget getVideoCacheList() {
    return ListView(
      itemExtent: 45,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cacheList.keys.map((k) {
        return ListTile(
          title: Text(k),
          leading: Checkbox(
            value: cacheListCheckValues[k],
            onChanged: (value) {
              updateCacheCheck(k);
            },
          ),
        );
      }).toList(),
    );
  }

  void updateSourceCheck(sourceKey, newValue) {
    setState(() {
      sourceListCheckValues.forEach((key, value) {
        if (key == sourceKey) {
          sourceListCheckValues[key] = true;
          gApp.setSourceName(key);
        } else {
          sourceListCheckValues[key] = false;
        }
      });
    });
  }

  void updateCacheCheck(sourceKey) {
    setState(() {
      cacheListCheckValues.forEach((key, value) {
        if (key == sourceKey) {
          cacheListCheckValues[key] = true;
          gApp.setIsCache(key);
        } else {
          cacheListCheckValues[key] = false;
        }
      });
    });
  }
}
