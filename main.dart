import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _result = 'Informe seus dados';

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _weightController.clear();
    _heightController.clear();
    setState(() {
      _result = 'Informe seus dados';
    });
  }

  void calculateImc() {
    final double weight = double.parse(_weightController.text);
    final double height = double.parse(_heightController.text) / 100.0;
    final double imc = weight / (height * height);

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
      if (imc < 18.6) {
        _result += "Abaixo do peso";
      } else if (imc < 25.0) {
        _result += "Peso ideal";
      } else if (imc < 30.0) {
        _result += "Levemente acima do peso";
      } else if (imc < 35.0) {
        _result += "Obesidade Grau I";
      } else if (imc < 40.0) {
        _result += "Obesidade Grau II";
      } else {
        _result += "Obesidade Grau III";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextFormField(
                label: "Peso (kg)",
                error: "Insira seu peso!",
                controller: _weightController,
              ),
              buildTextFormField(
                label: "Altura (cm)",
                error: "Insira uma altura!",
                controller: _heightController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      calculateImc();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(16.0),
                  ),
                  child: const Text(
                    'CALCULAR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField({
    required TextEditingController controller,
    required String error,
    required String label,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return (text == null || text.isEmpty) ? error : null;
      },
    );
  }
}
