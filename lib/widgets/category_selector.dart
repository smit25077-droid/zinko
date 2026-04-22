import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/category_bloc.dart';

class CategorySelector extends StatelessWidget implements PreferredSizeWidget {
  final List<String> categories;
  final String initialSelected;
  final Function(String)? onSelect;

  const CategorySelector({
    super.key,
    required this.categories,
    this.initialSelected = 'ALL',
    this.onSelect,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(initialCategory: initialSelected),
      child: _CategorySelectorContent(
        categories: categories,
        onSelect: onSelect,
      ),
    );
  }
}

class _CategorySelectorContent extends StatelessWidget {
  final List<String> categories;
  final Function(String)? onSelect;

  const _CategorySelectorContent({
    required this.categories,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final selected = state.selectedCategory;
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selected == cat;
              return GestureDetector(
                onTap: () {
                  context.read<CategoryBloc>().add(SelectCategory(cat));
                  if (onSelect != null) onSelect!(cat);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : GlassTheme.glassColor(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : GlassTheme.glassBorder(context),
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : GlassTheme.secondaryTextColor(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ).animate(target: isSelected ? 1 : 0).scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: 200.ms),
              );
            },
          ),
        );
      },
    );
  }
}
