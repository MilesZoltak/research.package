part of research_package_ui;

class RPUIDoubleQuestionBody extends StatefulWidget {
  final RPDoubleAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;

  const RPUIDoubleQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIDoubleQuestionBodyState createState() => RPUIDoubleQuestionBodyState();
}

class RPUIDoubleQuestionBodyState extends State<RPUIDoubleQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIDoubleQuestionBody> {
  late TextEditingController _textEditingController;
  String? _errorMessage;
  late bool _valid;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _valid = true;
    super.initState();
  }

  void _validate(String text, RPLocalizations? locale) {
    double value;
    try {
      value = double.parse(text);
    } catch (error) {
      setState(() {
        _valid = false;
        _errorMessage = locale?.translate('input_number') ?? "Input a number";
      });
      widget.onResultChange(null);
      return;
    }

    if (value >= widget.answerFormat.minValue &&
        value <= widget.answerFormat.maxValue) {
      setState(() {
        _valid = true;
      });
    } else {
      setState(() {
        _valid = false;
        _errorMessage =
            "${locale?.translate('between') ?? 'Should be between'} ${widget.answerFormat.minValue} ${locale?.translate('and') ?? 'and'} ${widget.answerFormat.maxValue}";
      });
      widget.onResultChange(null);
      return;
    }
    widget.onResultChange(text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          filled: true,
          hintText: locale?.translate('tap_to_answer') ?? "Tap to answer",
          helperStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          suffix: widget.answerFormat.suffix != null
              ? Text(locale?.translate(widget.answerFormat.suffix!) ??
                  widget.answerFormat.suffix!)
              : null,
          errorText: _valid ? null : _errorMessage,
        ),
        onChanged: (text) => _validate(text, locale),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
