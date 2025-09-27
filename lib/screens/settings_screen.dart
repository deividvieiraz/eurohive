import 'package:eurohive/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'Português';

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
          'Configurações',
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
            _buildSectionCard(
              'Conta',
              [
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Informações Pessoais',
                  subtitle: 'Editar perfil e dados pessoais',
                  onTap: () {
                    // TODO: Navegar para edição de perfil
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.security,
                  title: 'Segurança',
                  subtitle: 'Senha e autenticação',
                  onTap: () {
                    // TODO: Navegar para configurações de segurança
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacidade',
                  subtitle: 'Controle de dados e privacidade',
                  onTap: () {
                    // TODO: Navegar para configurações de privacidade
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            _buildSectionCard(
              'Preferências',
              [
                _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  subtitle: 'Receber notificações do app',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Modo Escuro',
                  subtitle: 'Ativar tema escuro',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: _selectedLanguage,
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            _buildSectionCard(
              'Segurança',
              [
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Biometria',
                  subtitle: 'Usar impressão digital ou face ID',
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Alterar Senha',
                  subtitle: 'Atualizar senha de acesso',
                  onTap: () {
                    // TODO: Navegar para alteração de senha
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            _buildSectionCard(
              'Sobre',
              [
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'Sobre o App',
                  subtitle: 'Versão 1.0.0',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Termos de Uso',
                  subtitle: 'Leia nossos termos e condições',
                  onTap: () {
                    // TODO: Navegar para termos de uso
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de Privacidade',
                  subtitle: 'Como protegemos seus dados',
                  onTap: () {
                    // TODO: Navegar para política de privacidade
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.darkOrange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.darkOrange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.darkOrange,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Português', 'pt'),
            _buildLanguageOption('English', 'en'),
            _buildLanguageOption('Español', 'es'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code) {
    final isSelected = _selectedLanguage == language;
    
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.darkOrange) : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o Eurohive'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versão: 1.0.0'),
            SizedBox(height: 8),
            Text('Eurohive é uma plataforma inovadora para conectar colaboradores e projetos da Eurofarma.'),
            SizedBox(height: 16),
            Text('Desenvolvido com ❤️ pela equipe Eurofarma.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
