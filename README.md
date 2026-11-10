# GreenStock 🌱

<br>
<br>

## 1. Identificação

**Nome do projeto:** GreenStock

**Desafio:** CitizenTech

**Integrantes:**
- Ana Carolina Calheiros de Lima — RM: 555316
- Stefany Miyahara Omori — RM: 558792
- Yasmin Sayuri Iechika Muniz — RM: 559011

<br>
<br>

## 2. Sobre o Projeto

O GreenStock é um aplicativo desenvolvido para facilitar o controle de estoque de pequenos estabelecimentos, ajudando a evitar desperdícios e melhorar a organização dos produtos.
A solução permite cadastrar, consultar, editar e excluir produtos, além de acompanhar a quantidade disponível e identificar itens com estoque baixo.

**Público-alvo:** pequenos comerciantes e estabelecimentos que precisam organizar seus produtos e controlar seus estoques.

### Funcionalidades do MVP

- Cadastro de produtos.
- Listagem e consulta de produtos.
- Edição e exclusão de produtos.
- Visualização dos detalhes de cada produto.
- Identificação de produtos com estoque baixo.
- Dashboard com indicadores gerais do estoque.

### ODS relacionados

O projeto está relacionado ao ODS 12 — Consumo e Produção Responsáveis, contribuindo para a redução do desperdício por meio de um controle mais eficiente dos produtos em estoque.

<br>
<br>

## 3. Arquitetura e Persistência

O aplicativo foi desenvolvido em Flutter, utilizando a linguagem Dart e a biblioteca Provider para gerenciamento de estado.
A persistência dos dados é realizada por meio de uma API HTTP pública, utilizando o MockAPI.

**URL base:**
`https://6af312c0d2377d6c370478a6.mockapi.io/api/v1/produtos/produtos`

**Endpoints utilizados:**

GET - Listar produtos
POST - Cadastrar produto
PUT - Atualizar produto
DELETE - Excluir produto

### Organização do projeto

- models: representação dos dados dos produtos.
- data: comunicação com a API.
- providers: gerenciamento dos dados e estados do aplicativo.
- screens: telas e interfaces do aplicativo.

<br>
<br>

## 4. Galeria de Telas

Abaixo estão as principais telas do GreenStock em execução.

### Home
Tela inicial com indicadores gerais do estoque e acesso às funcionalidades do aplicativo.

<img width="500" height="867" alt="Screenshot 2026-11-10 103818" src="https://github.com/user-attachments/assets/2da90830-c834-4405-a237-5168b3973e66" />


### Listagem de Produtos
Exibe os produtos cadastrados, permitindo consultar e acessar seus detalhes.

<img width="496" height="865" alt="Screenshot 2026-11-10 103910" src="https://github.com/user-attachments/assets/8e8310f3-1a18-4344-9562-f85b4abf3ff0" />


### Formulário de Produto
Permite cadastrar e editar produtos, com validação dos campos obrigatórios.

<img width="498" height="864" alt="Screenshot 2026-11-10 104008" src="https://github.com/user-attachments/assets/215a7a46-ac07-44b1-94e4-ad3ec9dd5638" />
<img width="500" height="864" alt="Screenshot 2026-11-10 104055" src="https://github.com/user-attachments/assets/c27185cb-e35b-4a02-bc36-6a6064071eed" />


### Detalhes do Produto
Apresenta as informações completas de um produto, com opções de edição e exclusão.

<img width="494" height="862" alt="Screenshot 2026-11-10 103929" src="https://github.com/user-attachments/assets/f89ec7a3-b92b-4220-8b6b-9eeeea53ed13" />


### Estoque Baixo
Exibe os produtos cuja quantidade está igual ou abaixo do estoque mínimo definido.

<img width="498" height="862" alt="Screenshot 2026-11-10 104026" src="https://github.com/user-attachments/assets/bf81ce07-aa48-43b9-8f78-b042bf7792ba" />

<br>
<br>
<br>
<br>

## 5. Instruções de Execução

### Pré-requisitos

- Flutter instalado.
- VS Code ou outro ambiente configurado para executar aplicativos Flutter.
- Dispositivo Android ou emulador.
- Acesso à internet para comunicação com a API.

### Como executar o projeto

**1. Clone o repositório:**

```bash
git clone https://github.com/StefanyOmori/green_stock.git
```

**2. Entre na pasta do projeto:**

```bash
cd green_stock
```

**3. Instale as dependências:**

```bash
flutter pub get
```

**4. Execute o aplicativo:**

```bash
flutter run
```

### Como executar os testes

Para executar os testes automatizados do projeto, utilize:

```bash
flutter test
```

Os testes verificam o comportamento das funcionalidades e o gerenciamento dos produtos.

---

<br>
<br>

**GreenStock — Tecnologia a favor de um consumo mais consciente. 🌱**
