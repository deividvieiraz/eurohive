import 'package:eurohive/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'Como faço para me inscrever em um projeto?',
      answer: 'Para se inscrever em um projeto, navegue até a seção "Descobrir" no menu inferior, encontre o projeto de seu interesse e toque em "Aplicar". Preencha o formulário de inscrição com suas informações e envie sua candidatura.',
    ),
    FAQItem(
      question: 'Posso me inscrever em mais de um projeto?',
      answer: 'Sim! Você pode se inscrever em quantos projetos desejar. Cada projeto é independente e você pode participar de múltiplas iniciativas simultaneamente.',
    ),
    FAQItem(
      question: 'Como acompanho o status da minha inscrição?',
      answer: 'Você pode acompanhar o status de suas inscrições na seção "Meu Perfil". Lá você encontrará todas as suas aplicações com o status atual (enviada, em análise, aprovada, etc.).',
    ),
    FAQItem(
      question: 'O que acontece se minha inscrição for rejeitada?',
      answer: 'Se sua inscrição for rejeitada, você receberá uma notificação explicando o motivo. Você pode se inscrever novamente em outros projetos ou tentar novamente em uma próxima edição do mesmo projeto.',
    ),
    FAQItem(
      question: 'Como funciona o sistema de IA para preenchimento de formulários?',
      answer: 'O sistema de IA oferece sugestões inteligentes para ajudar no preenchimento dos formulários. Você pode usar o botão da IA (ícone de varinha mágica) para obter sugestões baseadas no contexto do projeto e suas respostas anteriores.',
    ),
    FAQItem(
      question: 'Posso gravar áudio para preencher os formulários?',
      answer: 'Sim! O Eurohive oferece a opção de gravação de áudio para preenchimento de formulários. Toque no botão do microfone e fale suas respostas. O sistema converterá automaticamente sua fala em texto.',
    ),
    FAQItem(
      question: 'Como faço para anexar arquivos nas inscrições?',
      answer: 'Quando um campo de arquivo estiver disponível no formulário, toque no campo para selecionar um arquivo do seu dispositivo. Você pode anexar documentos, imagens ou outros arquivos relevantes para sua candidatura.',
    ),
    FAQItem(
      question: 'Esqueci minha senha. Como recuperar?',
      answer: 'Na tela de login, toque em "Esqueci minha senha" e siga as instruções para redefinir sua senha. Você receberá um email com as instruções para criar uma nova senha.',
    ),
    FAQItem(
      question: 'Como entro em contato com o suporte?',
      answer: 'Você pode entrar em contato com nossa equipe de suporte através do email suporte@eurohive.com ou através do chat de suporte disponível no aplicativo.',
    ),
    FAQItem(
      question: 'O aplicativo funciona offline?',
      answer: 'O Eurohive requer conexão com a internet para funcionar completamente. Algumas funcionalidades básicas podem estar disponíveis offline, mas para enviar inscrições e sincronizar dados, é necessário estar conectado.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ajuda',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com busca
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.darkOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: AppColors.darkOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Central de Ajuda',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Encontre respostas para as dúvidas mais comuns sobre o Eurohive.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Seção de contato rápido
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precisa de ajuda imediata?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          subtitle: 'suporte@eurohive.com',
                          onTap: () {
                            // TODO: Abrir email
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.chat_outlined,
                          title: 'Chat',
                          subtitle: 'Suporte online',
                          onTap: () {
                            // TODO: Abrir chat
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // FAQ Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perguntas Frequentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._faqItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildFAQCard(item, index);
                  }),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkOrange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.darkOrange.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.darkOrange,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(FAQItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.darkOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppColors.darkOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            item.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          iconColor: AppColors.darkOrange,
          collapsedIconColor: Colors.grey[600],
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                item.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
