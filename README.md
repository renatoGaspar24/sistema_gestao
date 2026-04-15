# sistema_gestao

Sistema de gestão para Hamburgaria Coky Licius.

## Visão geral

Este aplicativo Flutter é um sistema de gestão com duas responsabilidades principais:

- Área administrativa para gerenciar produtos, funcionários e pedidos.
- Área de cliente para visualizar produtos, montar carrinho e finalizar pedidos.

A arquitetura foi organizada para separar:

- dados (`models/`)
- persistência e lógica de negócio (`*service.dart`)
- interface do usuário (`*.dart` de telas)
- estilos e dimensões comuns (`constants.dart`)

## Organização de arquivos

### Arquivos principais em `lib/`

- `main.dart` – inicializa o app, carrega Hive e cria instâncias dos serviços.
- `welcome_page.dart` – página inicial de boas-vindas.
- `login_page.dart` – autenticação e escolha de perfil (admin ou cliente).
- `register_page.dart` – cadastro de usuário cliente.
- `home_page.dart` – roteia entre `AdminPage` e `ClientePage`.
- `admin_page.dart` – interface administrativa.
- `cliente_page.dart` – catálogo de produtos para cliente.
- `carrinho_page.dart` – revisão e finalização do pedido.
- `constants.dart` – valores visuais e de layout centralizados.

### Dados em `lib/models/`

- `produto.dart` – modelo de produto.
- `usuario.dart` – modelo de usuário/funcionário.
- `pedido.dart` – modelo de pedido.
- `item_pedido.dart` – item dentro do carrinho/pedido.

### Persistência e lógica em serviços

- `produto_service.dart` – CRUD de produtos e controle de estoque.
- `usuario_service.dart` – CRUD de funcionários.
- `pedido_service.dart` – CRUD de pedidos e lógica de entrega.

### Adapters do Hive

- `produto_adapter.dart`
- `usuario_adapter.dart`
- `pedido_adapter.dart`

Os adapters permitem armazenar objetos complexos no Hive sem conversão manual para JSON.

## Funcionamento do aplicativo

### Inicialização (`main.dart`)

O app inicia com:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `Hive.initFlutter()`
3. inicialização de `ProdutoService`, `UsuarioService` e `PedidoService`
4. execução de `runApp(MyApp(...))`

A injeção de dependência é feita manualmente via construtores, o que melhora a clareza das dependências e facilita testes.

### Fluxo de navegação

1. `WelcomePage`
2. `LoginPage` ou `RegisterPage`
3. `HomePage`
4. `AdminPage` ou `ClientePage`

### `HomePage`

Decide qual interface exibir com base em `isAdmin`:

- admin → `AdminPage`
- cliente → `ClientePage`

## Estrutura do Admin

`AdminPage` apresenta três abas:

- `Produtos/Estoque`
- `Funcionários`
- `Pedidos`

### Por que organizar assim?

- separa responsabilidades por aba
- faz o admin ter uma visão clara de cada domínio
- facilita adição de novas funcionalidades no futuro

### Detalhes técnicos do admin

- usa `DefaultTabController` e `TabBarView`
- `AnimatedBuilder` no `FloatingActionButton` para atualizar o botão conforme a aba muda
- cada aba usa `ListView.builder` ou `ExpansionTile` para exibir dados

### Funcionalidades adicionais

- adicionar e deletar produtos
- adicionar funcionários
- marcar pedidos como entregues
- deletar pedidos entregues

## Estrutura do Cliente

`ClientePage` é o catálogo de produtos.

### Layout responsivo

O número de colunas do grid é controlado em `constants.dart` com:

- `kGridColumnsSmall`
- `kGridColumnsMedium`
- `kGridColumnsLarge`
- `kGridBreakpointMedium`
- `kGridBreakpointLarge`

Isso torna os cards de produto responsivos e fáceis de ajustar.

### Carrinho de compras

- adiciona itens ao carrinho no clique do produto
- exibe badge com quantidade no ícone do carrinho
- apresenta botão fixo no rodapé para ver o carrinho
- navega para `CarrinhoPage`

## `CarrinhoPage`

Responsável pela revisão do pedido antes do fechamento.

### Funcionalidades

- listar itens do carrinho
- aumentar/diminuir quantidade
- remover itens
- mostrar total do pedido
- solicitar dados de entrega
- salvar o pedido em `PedidoService`

### Por que separar em página?

- permite revisão antes da confirmação
- evita finalização acidental
- dá foco à etapa de pagamento/entrega

## Por que usar Hive?

Hive é usado para persistência local porque é:

- rápido
- leve
- compatível com Flutter
- simples de usar com objetos serializados via adapters

Cada serviço abre sua própria `Box`:

- `produtos`
- `usuarios`
- `pedidos`

## Por que essa arquitetura?

### Separação de responsabilidades

- modelos em `models/`
- persistência e regras em `*Service`
- UI em páginas específicas
- constantes em `constants.dart`

### Vantagens

- manutenção mais fácil
- menor acoplamento
- mais fácil de estender
- mais simples de revisar o código

## Principais métodos e motivos

### Na camada de serviços

- `init()` — prepara Hive e boxes
- `get...()` — retorna listas de entidades
- `add...()` — adiciona dados no banco
- `remove...()` — exclui dados
- `decrementarQuantidade()` — reduz estoque após venda
- `marcarEntregue()` — controla status de pedido

### Na interface

- `setState()` — atualiza componentes após mudanças
- `Navigator.push()` — navegação entre telas
- `showDialog()` — confirmações e formulários
- `GridView.builder` — catálogo responsivo
- `ListView.builder` — listagem eficiente

## Por que organizar o projeto assim?

### Clareza

Cada arquivo tem um propósito claro. Isso evita que lógica de UI e persistência fiquem misturadas.

### Evolução

O app pode crescer sem revisão completa. Serviços podem ser expandidos sem alterar telas, e telas podem ser alteradas sem mexer no banco.

### Facilidade de edição

Com `constants.dart`, estilos e dimensões ficam centralizados e fáceis de alterar.

## Como editar o layout de cards

Se quiser mudar o tamanho ou largura dos cards de produto, edite em `lib/constants.dart`:

- `kGridColumnsSmall`
- `kGridColumnsMedium`
- `kGridColumnsLarge`
- `kGridChildAspectRatio`
- `kGridBreakpointMedium`
- `kGridBreakpointLarge`

## Possíveis melhorias futuras

- usar `Provider` ou `Riverpod` para gerenciamento de estado
- adicionar testes unitários e de widget
- salvar carrinho no Hive para persistência temporária
- autenticação real em vez de credenciais fixas
- adicionar edição de produto/usuário
- adicionar filtros e buscas no catálogo

## Conclusão

O projeto foi estruturado como um aplicativo Flutter modular com separação clara entre UI, dados e lógica de negócio. Isso torna o código legível, fácil de manter e preparado para evolução.

Se desejar, posso também adicionar um diagrama de arquitetura ou um guia de contribuição para o projeto.