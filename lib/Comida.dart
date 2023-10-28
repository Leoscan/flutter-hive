import 'package:flutter/material.dart';

void main() => runApp(
      const MaterialApp(
        home: CalcularCaloriaComida(),
      ),
    );

class CalcularCaloriaComida extends StatefulWidget {
  const CalcularCaloriaComida({Key? key}) : super(key: key);

  @override
  _CaloriaComida createState() => _CaloriaComida();
}

class _CaloriaComida extends State<CalcularCaloriaComida> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> valoresSalvos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: this.corpo(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Calorias - Comidas & Bebidas'),
      backgroundColor: Color.fromARGB(255, 9, 98, 167),
    );
  }

  // Corpo do aplicativo, onde é adicionado o campo e o botão
  Widget corpo() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            this.campoLista(),
            this.botaoCalculo(),
          ],
        ),
      ),
    );
  }

  //Onde é montado o campo, adicionando as listas prato, sobremesa e bebida
  Widget campoLista() {
    return Column(
      children: [
        montaCampoLista(this.getItensPrato()),
        SizedBox(height: 20),
        montaCampoLista(this.getItensSobremesa()),
        SizedBox(height: 20),
        montaCampoLista(this.getItensBebida()),
      ],
    );
  }

  Widget botaoCalculo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: ElevatedButton(
        onPressed: this.executaAcao,
        child: Text('Enviar'),
      ),
    );
  }

  //
  void executaAcao() {
    if (_formKey.currentState!.validate()) {
      this._formKey.currentState!.save();
      this.calculaResultado();
    }
  }

  void calculaResultado() {
    // percorremos a lista de dados salvos
    // para cada id salvo encontramos o map correspondente na lista global
    // atraves de uma funcao que encontra esse map.
    // armazenamos numa lista de map somnente os map que foram selecionados
    // realizo o tratamento  e exibo a mensagem
    //resultado final [{'id': 'cha', 'nome' : 'Chá', 'cal' : 20}, {'id': 'vegetariano', 'nome' : 'Vegetariano', 'cal' : 180}, {'id': 'sorvete_diet', 'nome' : 'Sorvete Diet', 'cal' : 110},]
    // ['cha', 'vegetariano', sorvete_diet']
    List<Map<String, dynamic>> listcompleta = [];
    this.valoresSalvos.forEach((chave) {
      //chamar a funcao para pegar os maps de alimentos
      //a dicionar o map encontrado em outra lista
      listcompleta.add(this.valorAlimentobyNome(chave));
    });

    double soma = 0;
    listcompleta.forEach((element) {
      soma = soma + element['cal'];
    });

    String nome = "alimentos";
    listcompleta.forEach((element) {
      nome = nome + element['nome'];
    });

    this.resultado(
        'O total de calorias é: ' + soma.toString() + ' dos seguintes ' + nome);
    //print(listcompleta);
  }

  ///Retona um map de alimento a partir do valor passado
  ///
  ///A `valor` corresponde a chave que será buscada no map.
  Map<String, dynamic> valorAlimentobyNome(String valor) {
    Map<String, dynamic> encontrado = {};
    // Percorremos a lista de alimentos completa e rertornamos o map correspondente ao valor
    this.listaCompleta().forEach((alimento) {
      if (alimento['id'] == valor) {
        encontrado = alimento;
      }
    });
    return encontrado;
  }

  List<Map<String, dynamic>> getItensPrato() {
    return [
      {'id': 'vegetariano', 'nome': ' Vegetariano', 'cal': 180},
      {'id': 'peixe', 'nome': ' Peixe ', 'cal': 230},
      {'id': 'frango', 'nome': ' Frango ', 'cal': 250},
      {'id': 'carne', 'nome': ' Carne ', 'cal': 350},
    ];
  }

  List<Map<String, dynamic>> getItensSobremesa() {
    return [
      {'id': 'abacaxi', 'nome': ' Abacaxi ', 'cal': 75},
      {'id': 'sorvete_diet', 'nome': ' Sorvete Diet ', 'cal': 110},
      {'id': 'mouse_diet', 'nome': ' Mouse Diet ', 'cal': 170},
      {'id': 'mouse_chocolate', 'nome': ' Mouse Chocolate ', 'cal': 200},
    ];
  }

  List<Map<String, dynamic>> getItensBebida() {
    return [
      {'id': 'cha', 'nome': 'Chá ', 'cal': 20},
      {'id': 'suco_de_laranja', 'nome': ' Suco de Laranja ', 'cal': 70},
      {'id': 'suco_de_melao', 'nome': ' Suco de Melão ', 'cal': 100},
      {'id': 'refrigerante_diet', 'nome': ' Refrigerante Diet ', 'cal': 65},
    ];
  }

  List<Map<String, dynamic>> listaCompleta() {
    List<Map<String, dynamic>> listaAlimentos = [];
    listaAlimentos.addAll(this.getItensPrato());
    listaAlimentos.addAll(this.getItensSobremesa());
    listaAlimentos.addAll(this.getItensBebida());
    return listaAlimentos;
  }

  Widget montaCampoLista(List<Map<String, dynamic>> alimentos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione um alimento:', // Título ou rótulo
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white38,
          ),
          onSaved: (dynamic alimento) {
            if (alimento != null && alimento is String) {
              this.valoresSalvos.add(alimento);
            }
          },
          items: getItens(alimentos),
          onChanged: (dynamic newValue) {},
        ),
      ],
    );
  }

  List<DropdownMenuItem> getItens(List<Map<String, dynamic>> alimentos) {
    List<DropdownMenuItem<String>> menuItems = [];
    alimentos.forEach((alimento) {
      DropdownMenuItem<String> item = DropdownMenuItem(
        child: Text(alimento['nome']),
        value: alimento['id'],
      );
      menuItems.add(item);
    });

    List<dynamic> dadosFormulario = [];
    dadosFormulario.add('');
    return menuItems;
  }

  void resultado(String resultado) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Resultado"),
        //Retorna a função resultado
        content: Text(resultado),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Sair'),
            child: const Text('Sair'),
          )
        ],
      ),
    );
  }
}
