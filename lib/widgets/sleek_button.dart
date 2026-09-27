import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum SleekButtonVariant {
  primary,
  secondary,
  outline,
  danger,
}

class SleekButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SleekButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const SleekButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = SleekButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border;
    List<BoxShadow> shadows = [];

    switch (variant) {
      case SleekButtonVariant.primary:
        bg = AppTheme.accentGreen;
        fg = const Color(0xFF000000);
        border = BorderSide.none;
        shadows = [
          BoxShadow(
            color: AppTheme.accentGreen.withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ];
        break;
      case SleekButtonVariant.secondary:
        bg = AppTheme.surfaceElevated;
        fg = AppTheme.textPrimary;
        border = const BorderSide(color: AppTheme.border);
        break;
      case SleekButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppTheme.accentGreen;
        border = const BorderSide(color: AppTheme.accentGreen, width: 1.2);
        break;
      case SleekButtonVariant.danger:
        bg = AppTheme.accentRed.withValues(alpha: 0.12);
        fg = AppTheme.accentRed;
        border = BorderSide(color: AppTheme.accentRed.withValues(alpha: 0.4));
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: border != BorderSide.none
            ? Border.all(color: border.color, width: border.width)
            : null,
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 18, color: fg),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: fg,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
