# EuroHive

Uma plataforma social para desenvolvedores compartilharem ideias, projetos e se conectarem com outros profissionais da área de tecnologia.

## 🚀 Funcionalidades

### Tela de Login
- Interface moderna com design glassmorphism
- Login com email e senha
- Login com Google
- Opção "Lembrar de mim"
- Link para recuperação de senha
- Link para cadastro

### Home Screen
- **Menu lateral** com navegação e informações do usuário
- **Cards de estatísticas** (Posts, Curtidas, Seguidores)
- **Seção de notícias** com cards horizontais
- **Projetos recentes** em lista
- Design responsivo e moderno

### Feed Screen (Tipo Twitter)
- **Criação de posts** com texto e imagens
- **Timeline de posts** com interações
- **Ações de interação**: Comentar, Repostar, Curtir, Compartilhar
- **Interface similar ao Twitter** com cards de posts
- **Floating Action Button** para criar novos posts

### Discovery Screen
- **Filtros por categoria**: Mobile, Web, AI/ML, Blockchain, IoT, Gaming
- **Grid de projetos** com cards visuais
- **Sistema de avaliação** com estrelas e curtidas
- **Modal de detalhes** do projeto
- **Funcionalidade de aplicação** em projetos
- **Categorização visual** por cores

### Navegação
- **Bottom Navigation Bar** com 3 guias principais
- **Navegação fluida** entre telas
- **Estado persistente** das telas

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.32.8
- **Dart** 3.8.1
- **Material Design** 3
- **Google Fonts**
- **Flutter Lints** para qualidade de código

## 📱 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_assets.dart
│   │   ├── app_colors.dart
│   │   └── app_texts.dart
│   └── theme/
│       └── app_theme.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── feed_screen.dart
│   ├── discovery_screen.dart
│   └── main_screen.dart
├── routes/
│   └── app_routes.dart
└── main.dart
```

## 🎨 Design System

### Cores Principais
- **Azul Principal**: `#0A5481`
- **Azul Claro**: `#4486A8`
- **Azul Escuro**: `#090A36`
- **Branco**: `#FFFFFF`
- **Cinza Claro**: `#E0E2E1`
- **Cinza Escuro**: `#959BA5`

### Componentes
- Cards com sombras suaves
- Gradientes modernos
- Bordas arredondadas
- Ícones consistentes
- Tipografia hierárquica

## 🚀 Como Executar

1. **Clone o repositório**
   ```bash
   git clone [url-do-repositorio]
   cd eurohive
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o projeto**
   ```bash
   flutter run
   ```

## 📋 Pré-requisitos

- Flutter SDK 3.32.8 ou superior
- Dart 3.8.1 ou superior
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

## 🔧 Configuração

O projeto está configurado para:
- **Android**: API 21+
- **iOS**: iOS 11.0+
- **Web**: Suporte completo
- **Desktop**: Windows, macOS, Linux

## 📱 Telas Implementadas

### 1. Login Screen (`/login`)
- Tela inicial do app
- Design glassmorphism
- Validação de campos
- Navegação para Home após login

### 2. Main Screen (`/main`)
- Container principal com navegação inferior
- Gerencia as 3 telas principais
- Estado persistente das telas

### 3. Home Screen
- Dashboard principal
- Menu lateral (Drawer)
- Cards de estatísticas
- Seção de notícias
- Lista de projetos recentes

### 4. Feed Screen
- Timeline de posts
- Criação de novos posts
- Interações sociais
- Interface similar ao Twitter

### 5. Discovery Screen
- Explorar projetos
- Filtros por categoria
- Cards visuais de projetos
- Sistema de aplicação

## 🎯 Próximos Passos

- [ ] Implementar autenticação real
- [ ] Adicionar backend (Firebase/API)
- [ ] Implementar notificações push
- [ ] Adicionar chat entre usuários
- [ ] Implementar upload de imagens
- [ ] Adicionar sistema de busca
- [ ] Implementar favoritos
- [ ] Adicionar perfil do usuário
- [ ] Implementar configurações
- [ ] Adicionar testes unitários e de widget

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**EuroHive Team**
- Desenvolvido com ❤️ para a comunidade de desenvolvedores

---

**EuroHive** - Conectando desenvolvedores, compartilhando ideias, construindo o futuro! 🚀
