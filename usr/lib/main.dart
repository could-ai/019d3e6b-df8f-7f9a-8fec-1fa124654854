import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oracle Template Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC74634), // Oracle-like red
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TemplateGeneratorScreen(),
      },
    );
  }
}

class TemplateGeneratorScreen extends StatefulWidget {
  const TemplateGeneratorScreen({super.key});

  @override
  State<TemplateGeneratorScreen> createState() =>
      _TemplateGeneratorScreenState();
}

class _TemplateGeneratorScreenState extends State<TemplateGeneratorScreen> {
  // Controllers for all template fields
  final _recipientCtrl = TextEditingController(text: 'Carolyn');
  final _oblpnCtrl = TextEditingController(text: 'XPOBC085420');
  final _orderNumCtrl = TextEditingController(text: 'VOM1HP-572101005869');
  final _oblpnStatusCtrl = TextEditingController(text: 'Loaded');
  final _orderStatusCtrl = TextEditingController(text: 'Loaded');
  final _loadNumCtrl = TextEditingController(text: 'Not generated / blank');
  final _updateCtrl = TextEditingController(
      text:
          'Update the OBLPN and Order to the correct downstream status with a valid Load Number association so the order can proceed through outbound processing.');
  final _approverNameCtrl = TextEditingController(text: '');
  final _jobTitleCtrl = TextEditingController(text: '');
  final _roleCtrl = TextEditingController(
      text: 'Signing Authority (Manager / Supervisor)');
  final _orgCtrl = TextEditingController(text: '');
  final _senderCtrl = TextEditingController(text: 'Md Afsar');

  @override
  void initState() {
    super.initState();
    // Add listeners to update the preview automatically when text changes
    final controllers = [
      _recipientCtrl,
      _oblpnCtrl,
      _orderNumCtrl,
      _oblpnStatusCtrl,
      _orderStatusCtrl,
      _loadNumCtrl,
      _updateCtrl,
      _approverNameCtrl,
      _jobTitleCtrl,
      _roleCtrl,
      _orgCtrl,
      _senderCtrl,
    ];
    for (var ctrl in controllers) {
      ctrl.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _oblpnCtrl.dispose();
    _orderNumCtrl.dispose();
    _oblpnStatusCtrl.dispose();
    _orderStatusCtrl.dispose();
    _loadNumCtrl.dispose();
    _updateCtrl.dispose();
    _approverNameCtrl.dispose();
    _jobTitleCtrl.dispose();
    _roleCtrl.dispose();
    _orgCtrl.dispose();
    _senderCtrl.dispose();
    super.dispose();
  }

  String get _generatedText {
    return '''Data Fix Confirmation & Signing Authority Approval

Hi ${_recipientCtrl.text},

Please find the required details below:

A. Data Fix Confirmation
We are requesting a data fix for the following records:
- OBLPN: ${_oblpnCtrl.text}
- Order Number: ${_orderNumCtrl.text}

Current Status:
- OBLPN Status: ${_oblpnStatusCtrl.text}
- Order Status: ${_orderStatusCtrl.text}
- Load Number: ${_loadNumCtrl.text}

Requested Update:
${_updateCtrl.text}

B. Signing Authority Approval for Data Fix
I approve Oracle to create and run the required data fix on the customer system for the above issue.

Approval Details:
Name: ${_approverNameCtrl.text}
Job Title: ${_jobTitleCtrl.text.isEmpty ? '<Job Title>' : _jobTitleCtrl.text}
Role: ${_roleCtrl.text}
Organization: ${_orgCtrl.text.isEmpty ? '<Customer Organization Name>' : _orgCtrl.text}

This approval is provided to allow Oracle to proceed with the backend data correction as requested in this Service Request.

Regards,
${_senderCtrl.text}''';
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedText)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Template copied to clipboard! You can now paste it into Word.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oracle Data Fix Template Generator'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Wide screen layout (Web/Desktop)
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildFormSection(),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  flex: 1,
                  child: _buildPreviewSection(),
                ),
              ],
            );
          } else {
            // Narrow screen layout (Mobile)
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildPreviewSection(),
                  const Divider(height: 1, thickness: 1),
                  _buildFormSection(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Fill Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'General',
            children: [
              _buildTextField(_recipientCtrl, 'Recipient Name'),
              _buildTextField(_senderCtrl, 'Sender Name'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'A. Data Fix Confirmation',
            children: [
              _buildTextField(_oblpnCtrl, 'OBLPN'),
              _buildTextField(_orderNumCtrl, 'Order Number'),
              _buildTextField(_oblpnStatusCtrl, 'OBLPN Status'),
              _buildTextField(_orderStatusCtrl, 'Order Status'),
              _buildTextField(_loadNumCtrl, 'Load Number'),
              _buildTextField(_updateCtrl, 'Requested Update', maxLines: 3),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'B. Approval Details',
            children: [
              _buildTextField(_approverNameCtrl, 'Approver Name'),
              _buildTextField(_jobTitleCtrl, 'Job Title'),
              _buildTextField(_roleCtrl, 'Role'),
              _buildTextField(_orgCtrl, 'Organization'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Document Preview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy),
                label: const Text('Copy for Word'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _generatedText,
                    style: const TextStyle(
                      fontFamily: 'Arial', // Standard Word-like font
                      fontSize: 14.0,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
