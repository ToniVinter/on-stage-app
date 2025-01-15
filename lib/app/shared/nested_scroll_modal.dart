import 'package:flutter/material.dart';

typedef WidgetCallback = Widget Function();
typedef ContentCallback = Widget Function();
typedef SizeCallback = double Function();

class NestedScrollModal extends StatefulWidget {
  const NestedScrollModal({
    required this.buildContent,
    super.key,
    this.backgroundColor,
    this.buildHeader,
    this.headerHeight,
    this.buildFooter,
    this.footerHeight,
  });

  final Color? backgroundColor;
  final WidgetCallback? buildHeader;
  final SizeCallback? headerHeight;
  final WidgetCallback? buildFooter;
  final SizeCallback? footerHeight;
  final ContentCallback buildContent;

  @override
  State<NestedScrollModal> createState() => _NestedScrollModalState();
}

class _NestedScrollModalState extends State<NestedScrollModal> {
  final ScrollPhysics _physics = const BouncingScrollPhysics();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.buildHeader?.call();
    final headerHeight = widget.headerHeight?.call();
    final footer = widget.buildFooter?.call();
    final footerSize = widget.footerHeight?.call();

    final hasHeader = header != null && headerHeight != null;
    final hasFooter = footer != null && footerSize != null;
    final itemsCount = 1 + (hasHeader ? 1 : 0) + (hasFooter ? 1 : 0);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NotificationListener<ScrollStartNotification>(
            onNotification: (_) {
              return true;
            },
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                itemCount: itemsCount,
                physics: _physics,
                itemBuilder: (context, index) {
                  if (hasHeader && index == 0) {
                    return Container(
                      color: Colors.transparent,
                      height: headerHeight,
                    );
                  }

                  if (hasFooter && index == itemsCount - 1) {
                    return Container(
                      color: Colors.transparent,
                      height: footerSize,
                    );
                  }

                  return widget.buildContent();
                },
              ),
            ),
          ),
        ),
        if (hasHeader)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: header,
          ),
        if (hasFooter)
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: footer,
          ),
      ],
    );
  }
}
