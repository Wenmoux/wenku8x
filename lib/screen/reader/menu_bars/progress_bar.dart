import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wenku8x/screen/reader/menu_bars/progress_bar_provider.dart';

import '../reader_provider.dart';

class ProgressBar extends StatefulHookConsumerWidget {
  const ProgressBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bottomPos = useState(-height);
    final state = ref.watch(
        readerMenuStateProvider.select((value) => value.progressVisible));
    final bottomHeight = ref.watch(
        readerMenuStateProvider.select((value) => value.bottomBarHeight));
    final progress = ref.watch(progressProvider);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        bottomPos.value = -context.findRenderObject()!.paintBounds.size.height;
      });
      return null;
    }, []);

    return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        left: 0,
        bottom: state ? bottomHeight : bottomPos.value,
        child: Container(
            color: Theme.of(context).colorScheme.surface,
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "上一章",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    )),
                Expanded(
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor:
                              Theme.of(context).colorScheme.outline,
                          inactiveTrackColor:
                              Theme.of(context).colorScheme.background,
                          trackHeight: 16,
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbColor: Theme.of(context).colorScheme.surface,
                          thumbShape: const RoundSliderThumbShape(
                            disabledThumbRadius: 8, //禁用时滑块大小
                            enabledThumbRadius: 8, //滑块大小
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Slider(
                            max: progress.totalPages.toDouble(),
                            value: progress.currentIndex.toDouble(),
                            divisions: progress.totalPages,
                            onChanged: (value) {
                              ref
                                  .read(progressProvider.notifier)
                                  .updateProgress(value.round());
                            },
                          ),
                        ))),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "下一章",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ))
              ],
            )));
  }
}