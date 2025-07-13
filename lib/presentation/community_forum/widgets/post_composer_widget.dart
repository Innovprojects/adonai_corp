import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PostComposerWidget extends StatefulWidget {
  final Function(String content, List<String> tags) onPost;

  const PostComposerWidget({
    Key? key,
    required this.onPost,
  }) : super(key: key);

  @override
  State<PostComposerWidget> createState() => _PostComposerWidgetState();
}

class _PostComposerWidgetState extends State<PostComposerWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Leadership',
    'Management',
    'Construction',
    'Innovation',
    'Agriculture',
    'Immobilier',
    'Technologie',
    'Durabilité',
    'Équipe',
    'Stratégie',
  ];

  bool _isPosting = false;
  bool _hasAttachment = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty &&
        !_selectedTags.contains(tag) &&
        _selectedTags.length < 5) {
      setState(() {
        _selectedTags.add(tag);
      });
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  void _attachPhoto() {
    setState(() {
      _hasAttachment = !_hasAttachment;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_hasAttachment ? 'Photo ajoutée' : 'Photo supprimée'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir le titre et le contenu'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isPosting = true);

    // Simulate posting delay
    await Future.delayed(Duration(seconds: 2));

    final content =
        '${_titleController.text.trim()}\n\n${_contentController.text.trim()}';
    widget.onPost(content, _selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleField(),
                  SizedBox(height: 3.h),
                  _buildContentField(),
                  SizedBox(height: 3.h),
                  _buildTagSection(),
                  SizedBox(height: 3.h),
                  _buildAttachmentSection(),
                  SizedBox(height: 3.h),
                  _buildFormattingOptions(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              'Nouvelle publication',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: _isPosting ? null : _submitPost,
            child: _isPosting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : Text(
                    'Publier',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Titre de la discussion',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _titleController,
          style: AppTheme.lightTheme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Saisissez un titre accrocheur...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
          maxLines: 2,
          maxLength: 100,
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contenu',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _contentController,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Partagez vos idées, expériences ou questions...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
          maxLines: 8,
          maxLength: 1000,
        ),
      ],
    );
  }

  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (max 5)',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _tagController,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Ajouter un tag...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            suffixIcon: IconButton(
              onPressed: () => _addTag(_tagController.text.trim()),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          onSubmitted: _addTag,
        ),
        SizedBox(height: 2.h),
        if (_selectedTags.isNotEmpty) _buildSelectedTags(),
        SizedBox(height: 2.h),
        _buildSuggestedTags(),
      ],
    );
  }

  Widget _buildSelectedTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags sélectionnés:',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _selectedTags
              .map((tag) => Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                    deleteIcon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 16,
                    ),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    labelStyle:
                        AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestedTags() {
    final availableTags =
        _availableTags.where((tag) => !_selectedTags.contains(tag)).toList();

    if (availableTags.isEmpty || _selectedTags.length >= 5) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags suggérés:',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: availableTags
              .take(6)
              .map((tag) => GestureDetector(
                    onTap: () => _addTag(tag),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pièces jointes',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _attachPhoto,
                icon: CustomIconWidget(
                  iconName: _hasAttachment ? 'photo' : 'add_photo_alternate',
                  color: _hasAttachment
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
                label: Text(_hasAttachment ? 'Photo ajoutée' : 'Ajouter photo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _hasAttachment
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  side: BorderSide(
                    color: _hasAttachment
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormattingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formatage',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            _buildFormatButton('format_bold', 'Gras'),
            SizedBox(width: 2.w),
            _buildFormatButton('format_italic', 'Italique'),
            SizedBox(width: 2.w),
            _buildFormatButton('format_list_bulleted', 'Liste'),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatButton(String icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: () {
          // Implement formatting logic
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$tooltip appliqué'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        icon: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isPosting ? null : _submitPost,
              child: _isPosting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text('Publication...'),
                      ],
                    )
                  : Text('Publier la discussion'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
