import 'package:flutter/material.dart';

/// Allows a pushed route (e.g. JsonViewerScreen in edit mode) or modal to handle
/// Escape before the global handler pops. When set, the global handler calls
/// this first; if it returns true, the pop is skipped.
class EscapeOverride {
  EscapeOverride._();

  /// Called when Escape is pressed and a route can pop. Return true to consume
  /// the event and prevent pop (e.g. cancel edit mode, or close modal only).
  /// Return false to let the normal pop happen.
  static bool Function()? tryHandle;
}

/// Wraps modal bottom sheet content so Escape closes only the modal, not the
/// screen below. Place as the root child of the modal's builder.
class EscapeClosesModal extends StatefulWidget {
  const EscapeClosesModal({super.key, required this.child});

  final Widget child;

  @override
  State<EscapeClosesModal> createState() => _EscapeClosesModalState();
}

class _EscapeClosesModalState extends State<EscapeClosesModal> {
  @override
  void initState() {
    super.initState();
    EscapeOverride.tryHandle = () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        return true;
      }
      return false;
    };
  }

  @override
  void dispose() {
    EscapeOverride.tryHandle = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
