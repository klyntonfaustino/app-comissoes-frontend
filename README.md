# app-comissoes-frontend

## ✨ Sobre o Projeto

Este é o **front-end** do aplicativo de comissões, construído com **Flutter**. Ele serve como a interface visual para interagir com o backend de gerenciamento de comissões, que está conectado a um banco de dados MySQL no Docker.

## 🚀 Tecnologias Principais

- **Flutter**: Para o desenvolvimento da interface de usuário.
- **Dart**: A linguagem de programação do Flutter.
- **Comunicação HTTP**: Para se conectar ao seu backend.

## 🛠️ Como Rodar o Projeto

### Pré-requisitos

- **Flutter SDK** instalado e configurado.
- **Git** instalado.
- Seu **backend** (`app-comissoes-backend`) deve estar rodando e acessível.

### Passos de Execução

1.  **Clone o Repositório:**

    ```bash
    git clone [https://github.com/klyntonfaustino/app-comissoes-frontend.git](https://github.com/klyntonfaustino/app-comissoes-frontend.git)
    cd app-comissoes-frontend
    ```

2.  **Instale as Dependências:**

    ```bash
    flutter pub get
    ```

3.  **Configure a URL do Backend:**
    Você precisa informar ao aplicativo onde seu backend está rodando. Localize o arquivo em seu projeto onde a **URL base da API** está definida (geralmente em `lib/utils/constants.dart`, `lib/config/app_config.dart` ou similar) e **ajuste-a** para o endereço correto do seu backend (ex: `http://127.0.0.1:8000/api`).

4.  **Inicie o Aplicativo:**
    Você pode rodar o aplicativo em um dispositivo físico, em um emulador/simulador ou na web.

    **a. Verificando Dispositivos Disponíveis:**
    Para ver a lista de dispositivos conectados e emuladores disponíveis, use o comando:
    ```bash
    flutter devices
    ```

    **b. Iniciando um Emulador (Android):**
    Se você não tiver um emulador configurado, pode criar um através do **Android Studio** (Vá em `Tools > AVD Manager`).

    Para iniciar um emulador existente pelo terminal, primeiro liste os emuladores:
    ```bash
    flutter emulators
    ```
    E então inicie o emulador desejado usando seu ID:
    ```bash
    flutter emulators --launch <id_do_emulador>
    ```

    **c. Rodando o App:**
    Com um dispositivo conectado ou um emulador rodando, inicie o aplicativo:
    ```bash
    flutter run
    ```
    Ou para rodar na web (navegador Chrome):
    ```bash
    flutter run -d chrome
    ```

## ✉️ Contato

Se tiver dúvidas, pode entrar em contato:

- **Klynton Faustino** - [Seu Perfil do GitHub](https://github.com/klyntonfaustino)
