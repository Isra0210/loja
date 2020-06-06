import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/Product.dart';
import 'package:shop/providers/products.dart';

class ProductFormsScreen extends StatefulWidget {
  @override
  _ProductFormsScreenState createState() => _ProductFormsScreenState();
}

class _ProductFormsScreenState extends State<ProductFormsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endWithPng = url.toLowerCase().endsWith('.png');
    bool endWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endWithPng || endWithJpg || endWithJpeg);
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  //libera qualquer tipo de uso de memória
  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final product = Product(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
              child: Text(
            'Ops',
            textAlign: TextAlign.center,
          )),
          content: Text('Ocorreu um erro inesperado.. :('),
          actions: <Widget>[
            FlatButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Formulário',
          textAlign: TextAlign.center,
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellow),),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length <= 3;

                        if (isEmpty || isInvalid) {
                          return 'Informe um título válido com no mínimo 3 caracteres!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true), //tipo do teclado
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Informe um número válido!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length <= 10;

                        if (isEmpty || isInvalid) {
                          return 'Informe uma descrição válida com no mínimo 10 caracteres!';
                        }

                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'URL da Imagem'),
                          keyboardType: TextInputType.url, //tipo do teclado
                          textInputAction: TextInputAction.done,
                          focusNode: _imageUrlFocusNode,
                          controller: _imageUrlController,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) => _formData['imageUrl'] = value,
                          validator: (value) {
                            bool isEmpty = value.trim().isEmpty;
                            bool isInvalid = isValidImageUrl(value);

                            if (isEmpty || !isInvalid) {
                              return 'Informe uma url válida!';
                            }

                            return null;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          )),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a imagem')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}