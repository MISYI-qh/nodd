import 'package:flutter/material.dart';
import 'theme.dart';

class NButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  const NButton(this.label, {super.key, required this.onTap, this.outlined = false});
  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> {
  bool down = false;
  @override
  Widget build(BuildContext context) {
    final f = fg(context), b = bgc(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => down = true),
      onTapCancel: () => setState(() => down = false),
      onTapUp: (_) {
        setState(() => down = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: down ? .96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.outlined ? Colors.transparent : f,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: f, width: 1.4),
          ),
          child: Text(widget.label,
              style: TextStyle(
                  color: widget.outlined ? f : b,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2)),
        ),
      ),
    );
  }
}

class NField extends StatelessWidget {
  final TextEditingController c;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  const NField(this.c, this.hint, {super.key, this.obscure = false, this.suffix});
  @override
  Widget build(BuildContext context) {
    final f = fg(context);
    OutlineInputBorder bd(double o, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: f.withOpacity(o), width: w));
    return TextField(
      controller: c,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: f,
      style: TextStyle(color: f),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: f.withOpacity(.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: bd(.2, 1),
        focusedBorder: bd(1, 1.4),
        suffixIcon: suffix == null
            ? null
            : Padding(padding: const EdgeInsets.only(right: 14), child: suffix),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
