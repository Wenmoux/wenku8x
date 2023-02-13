import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wenku8x/utils/log.dart';

class PreferenceView extends StatefulHookConsumerWidget {
  const PreferenceView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreferenceViewState();
}

class _PreferenceViewState extends ConsumerState<PreferenceView> {
  var top = 0.0;
  final titleStyle = const TextStyle(
    fontSize: 20,
  );
  final subTitleStyle = const TextStyle(fontSize: 14);
  @override
  Widget build(BuildContext context) {
    final dynamicColor = useState(false);
    final highRefreshRate = useState(false);
    final autoSign = useState(false);
    final traditionalChinese = useState(false);
    final getSpInstance = useMemoized(() => SharedPreferences.getInstance());
    final spInstance = useFuture(getSpInstance, initialData: null);

    setSpBool(String key, bool value, ValueNotifier<bool> state) {
      final sp = spInstance.data;
      if (sp != null) {
        state.value = value;
        sp.setBool(key, value);
      }
    }

    useEffect(() {
      final sp = spInstance.data;
      Log.d(sp, "??");
      if (sp != null) {
        dynamicColor.value = sp.getBool("dynamicColor") ?? true;
        highRefreshRate.value = sp.getBool("highRefreshRate") ?? false;
        autoSign.value = sp.getBool("autoSign") ?? false;
        traditionalChinese.value = sp.getBool("traditionalChinese") ?? false;
      }
      return () {};
    }, [spInstance.data]);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(slivers: [
        SliverAppBar.large(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              top = constraints.biggest.height;
              return FlexibleSpaceBar(
                title: Text(
                  '设置',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color),
                ),
                centerTitle: false,
                titlePadding: EdgeInsetsDirectional.only(
                  start: top > 140 ? 16.0 : 56,
                  bottom: 16.0,
                ),
              );
            })),
        SliverList(
            delegate: SliverChildListDelegate([
          ListTile(
            subtitle: Text(
              "平台特性",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("动态取色", style: titleStyle),
            onTap: () =>
                setSpBool("dynamicColor", !dynamicColor.value, dynamicColor),
            subtitle: Text(
              "跟随系统桌面自动获取主题色",
              style: subTitleStyle,
            ),
            trailing: Transform.scale(
              scaleX: 0.8,
              scaleY: 0.8,
              child: Switch(
                value: dynamicColor.value,
                onChanged: (value) =>
                    setSpBool("dynamicColor", !value, dynamicColor),
              ),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("强制高刷", style: titleStyle),
            onTap: () => setSpBool(
                "highRefreshRate", !highRefreshRate.value, highRefreshRate),
            subtitle: Text(
              "一加的部分机型可能需要",
              style: subTitleStyle,
            ),
            trailing: Transform.scale(
              scaleX: 0.8,
              scaleY: 0.8,
              child: Switch(
                value: highRefreshRate.value,
                onChanged: (value) =>
                    setSpBool("highRefreshRate", value, highRefreshRate),
              ),
            ),
          ),
          ListTile(
            subtitle: Text(
              "应用特性",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("自动签到", style: titleStyle),
            onTap: () => setSpBool("autoSign", !autoSign.value, autoSign),
            subtitle: Text(
              "启动 App 时尝试自动签到",
              style: subTitleStyle,
            ),
            trailing: Transform.scale(
              scaleX: 0.8,
              scaleY: 0.8,
              child: Switch(
                value: autoSign.value,
                onChanged: (value) => setSpBool("autoSign", value, autoSign),
              ),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("简繁转换", style: titleStyle),
            onTap: () => setSpBool("traditionalChinese",
                !traditionalChinese.value, traditionalChinese),
            subtitle: Text(
              "当前显示为简体中文",
              style: subTitleStyle,
            ),
            trailing: Transform.scale(
              scaleX: 0.8,
              scaleY: 0.8,
              child: Switch(
                value: traditionalChinese.value,
                onChanged: (value) =>
                    setSpBool("traditionalChinese", value, traditionalChinese),
              ),
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("清除缓存", style: titleStyle),
            onTap: () {},
            subtitle: Text(
              "当前缓存占用 100MB",
              style: subTitleStyle,
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: Text("退出登录",
                style: titleStyle.copyWith(
                    color: Theme.of(context).colorScheme.error)),
            onTap: () {},
            subtitle: Text(
              "这不会移除你的本地数据",
              style: subTitleStyle,
            ),
          )
        ]))
      ]),
    );
  }
}
