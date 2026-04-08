import 'package:flutter/material.dart';
import 'vote_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

// import des widgets
import '../../../../shared/widgets/app_header.dart';
import '../../../../shared/widgets/swap_indicator.dart';
import '../../data/scan_provider.dart';

class ScannerView extends ConsumerWidget {
  final Function(String) onValidCode;

  const ScannerView({super.key, required this.onValidCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(scanProvider);
    final notifier = ref.read(scanProvider.notifier);

    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) async {
            if (isProcessing) return;

            final barcode = capture.barcodes.first.rawValue;

            if (barcode != null) {
              final isValid = await notifier.validateCode(barcode);

              if (isValid) {
                onValidCode(barcode);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code invalide')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class CodeInputView extends ConsumerStatefulWidget {
  final Function(String) onValidCode;

  const CodeInputView({super.key, required this.onValidCode});

  @override
  ConsumerState<CodeInputView> createState() => _CodeInputViewState();
}

class _CodeInputViewState extends ConsumerState<CodeInputView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(scanProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Entrer le code"),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters, 
          
            keyboardType: TextInputType.text, 
            
            //Force la transformation en majuscules
            inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(6), //limite à 6 caractères direct ici
            ],
            decoration: const InputDecoration(
              hintText: "EXEMPLE123",
              border: OutlineInputBorder(),
              helperText: "Le code est composé de 6 caractères",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = _controller.text.trim();

              if (code.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code invalide')),
                );
                return;
              }

              final isValid = await notifier.validateCode(code);

              if (isValid) {
                widget.onValidCode(code);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code invalide')),
                );
              }
            },
            child: const Text("Valider"),
          ),
        ],
      ),
    );
  }
}

class ScanOrCodePage extends StatefulWidget {
  const ScanOrCodePage({super.key});

  @override
  State<ScanOrCodePage> createState() => _ScanOrCodePageState();
}

class _ScanOrCodePageState extends State<ScanOrCodePage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() => currentIndex = index);
  }

  void _goToVote(BuildContext context, String code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotePage(distribId: code),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(title: "Selection"),

          SwapIndicator(currentIndex: currentIndex),

          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                ScannerView(onValidCode: (code) => _goToVote(context, code)),
                CodeInputView(onValidCode: (code) => _goToVote(context, code)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}