import 'package:flutter/material.dart';
import 'package:app_estoque_limpeza/data/model/produto_model.dart';
import 'package:app_estoque_limpeza/data/repositories/produto_repositories.dart';

class ProdutosHomePage extends StatefulWidget {
  const ProdutosHomePage({super.key});

  @override
  ProdutosHomePageState createState() => ProdutosHomePageState();
}

class ProdutosHomePageState extends State<ProdutosHomePage> {
  final ProdutoRepositories _produtoRepository = ProdutoRepositories();
  List<ProdutoModel> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  // Método para carregar os produtos cadastrados
  _carregarProdutos() async {
    //try {
    final produtos = await _produtoRepository.getProduto();
    print(produtos);
    if (mounted) {
      setState(() {
        _produtos = produtos; // Atualiza a lista de produtos
      });
    }
    /*} catch (e, stackTrace) {
      debugPrint('Erro: $e\n$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar material: $e')),
        );
      }
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Cadastrados'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _produtos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  final produto = _produtos[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.blue),
                      title: Text(produto.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Quantidade: ${produto.quantidade}'),
                      onTap: () {
                        // Ação ao clicar no produto
                        _showProdutoDetails(produto);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Função para mostrar detalhes do produto
  void _showProdutoDetails(ProdutoModel produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(produto.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${produto.codigo}'),
            Text('Quantidade: ${produto.quantidade}'),
            Text('Data de Entrada: ${produto.entrada}'),
            if (produto.validade != null) Text('Validade: ${produto.validade}'),
            if (produto.local.isNotEmpty) Text('Local: ${produto.local}'),
            Text('Tipo: ${produto.idtipo}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
