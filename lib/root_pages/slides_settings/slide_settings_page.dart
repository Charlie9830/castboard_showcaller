import 'package:castboard_core/widgets/slide_enable_selector/slide_enable_selector.dart';
import 'package:castboard_showcaller/view_models/slide_settings_page_view_model.dart';
import 'package:flutter/material.dart';

class SlideSettingsPage extends StatefulWidget {
  final SlideSettingsPageViewModel viewModel;

  const SlideSettingsPage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  SlideSettingsPageState createState() => SlideSettingsPageState();
}

class SlideSettingsPageState extends State<SlideSettingsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.slides.isEmpty) {
      return Center(
          child:
              Text('No Slides', style: Theme.of(context).textTheme.bodySmall));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enable/Disable Slides',
                style: Theme.of(context).textTheme.bodySmall),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SlideEnableSelector(
                    disabledSlideIds: widget.viewModel.disabledSlideIds,
                    slides: widget.viewModel.slides,
                    onDisabledSlideIdsChanged:
                        widget.viewModel.onDisabledSlideIdsChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
