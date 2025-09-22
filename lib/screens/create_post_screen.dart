import 'package:flutter/material.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/models/posts.dart';

class CreatePostScreen extends StatefulWidget {
  final String? prefilledTitle;
  const CreatePostScreen({super.key, this.prefilledTitle});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isTextEmpty = true;

  Color _textColor = Colors.black;
  String _fontFamily = "Roboto";

  @override
  void initState() {
    super.initState();
    if (widget.prefilledTitle != null) {
      _controller.text = widget.prefilledTitle!;
      _isTextEmpty = widget.prefilledTitle!.trim().isEmpty;
    }
    _controller.addListener(() {
      setState(() {
        _isTextEmpty = _controller.text.trim().isEmpty;
      });
    });
  }

  void _pickColor() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              _colorOption(Colors.black),
              _colorOption(Colors.blue),
              _colorOption(Colors.red),
              _colorOption(Colors.green),
              _colorOption(Colors.orange),
              _colorOption(Colors.purple),
            ],
          ),
        );
      },
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _textColor = color;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  void _pickFont() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _fontOption("Roboto"),
              _fontOption("Courier New"),
              _fontOption("Times New Roman"),
              _fontOption("Arial"),
            ],
          ),
        );
      },
    );
  }

  Widget _fontOption(String font) {
    return ListTile(
      title: Text(
        font,
        style: TextStyle(fontFamily: font),
      ),
      onTap: () {
        setState(() {
          _fontFamily = font;
        });
        Navigator.pop(context);
      },
    );
  }

  void _addEmoji() {
    final emojis = ["😊", "🔥", "🎉", "👍", "🚀", "❤️"];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: emojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  final text = _controller.text;
                  final selection = _controller.selection;
                  final newText = text.replaceRange(
                    selection.start,
                    selection.end,
                    emoji,
                  );
                  _controller.text = newText;
                  _controller.selection = TextSelection.collapsed(
                    offset: selection.start + emoji.length,
                  );
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(12),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _post() {
    if (_controller.text.trim().isEmpty) return;

    final newPost = Post(
      author: "Você",
      username: "@voce",
      content: _controller.text,
      imagePath: "",
      likes: 0,
      comments: 0,
      shares: 0,
      time: "agora",
    );

    Navigator.pop(context, newPost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text("Nova publicação"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: "Cancelar",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isTextEmpty ? AppColors.darkGray : AppColors.white,
                foregroundColor:
                    _isTextEmpty ? AppColors.white : AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: _isTextEmpty ? null : _post,
              child: const Text(
                "Postar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          autofocus: true,
          style: TextStyle(
            color: _textColor,
            fontFamily: _fontFamily,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            hintText: "O que você está pensando?",
            border: InputBorder.none,
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: "Adicionar imagem",
                icon: const Icon(Icons.image, color: AppColors.blue),
                onPressed: () {
                  // TODO: abrir picker de imagens
                },
              ),
              IconButton(
                tooltip: "Alterar cor",
                icon: const Icon(Icons.color_lens, color: AppColors.blue),
                onPressed: _pickColor,
              ),
              IconButton(
                tooltip: "Alterar fonte",
                icon: const Icon(Icons.format_size, color: AppColors.blue),
                onPressed: _pickFont,
              ),
              IconButton(
                tooltip: "Adicionar emoji",
                icon: const Icon(Icons.emoji_emotions, color: AppColors.blue),
                onPressed: _addEmoji,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
