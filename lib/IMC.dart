import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: IMC(),
      ),
    );

class IMC extends StatefulWidget {
  const IMC({Key? key}) : super(key: key);

  @override
  _calculoIMC createState() => _calculoIMC();
}

class _calculoIMC extends State<IMC> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _pesoController = TextEditingController();
  TextEditingController _alturaController = TextEditingController();
  late String _result;

  @override
  void initState() {
    super.initState();
    resetFields();
  }

  void resetFields() {
    _pesoController.text = '';
    _alturaController.text = '';
  }

  void calcularImc() {
    double peso = double.parse(_pesoController.text);
    double altura = double.parse(_alturaController.text);
    double imc = peso / (altura * altura);

    setState(() {
      if (imc < 18.6) {
        this._result = "situação: Abaixo do peso";
      } else if (imc < 25.0) {
        this._result = "Situação: Peso Normal";
      } else if (imc < 30.0) {
        this._result = "Situação: Sobre Peso";
      } else if (imc < 35.0) {
        this._result = "Situação: Obeso";
      } else if (imc < 40.0) {
        this._result = "Situação: Obeso Mórbido";
      }
    });
    this.resultado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0), child: buildForm()));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calculadora de IMC'),
      backgroundColor: Colors.blue,
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildTextFormField(
              label: "Peso",
              error: "Insira seu peso",
              controller: _pesoController),
          buildTextFormField(
              label: "Altura",
              error: "Insira uma altura",
              controller: _alturaController),
          buildCalculateButton(),
        ],
      ),
    );
  }

  Padding buildCalculateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            calcularImc();
          }
        },
        child: Text('Calcular IMC'),
      ),
    );
  }

  void resultado() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Resultado"),
        content: Text(_result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Sair'),
            child: const Text('Sair'),
          )
        ],
      ),
    );
  }

  TextFormField buildTextFormField(
      {TextEditingController? controller,
      String? error,
      required String label}) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (text) {
        return text!.isEmpty ? error : null;
      },
    );
  }
}
