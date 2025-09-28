import 'package:eurohive/core/constants/app_assets.dart';
import 'package:eurohive/core/constants/app_colors.dart';
import 'package:eurohive/screens/project_application_screen.dart';
import 'package:flutter/material.dart';

class ApplicationMethodChoiceScreen extends StatefulWidget {
  final String projectId;

  const ApplicationMethodChoiceScreen({super.key, required this.projectId});

  @override
  State<ApplicationMethodChoiceScreen> createState() =>
      _ApplicationMethodChoiceScreenState();
}

class _ApplicationMethodChoiceScreenState
    extends State<ApplicationMethodChoiceScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [_buildAppBar(),Expanded(child: _buildBody())]));
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Conteúdo centralizado
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Escolha sua jornada',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha o método que melhor se adapta ao seu estilo:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
            
                // opções de seleção
                _buildSelectorButton(
                  index: 0,
                  label: 'Preenchimento Manual',
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildSelectorButton(
                  index: 1,
                  label: 'Impulsionar com IA',
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildSelectorButton(
                  index: 2,
                  label: 'Gravação de Áudio',
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        
        // Botão Avançar separado na parte inferior
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedIndex != null
                  ? () {
                      // lógica de navegação dependendo da opção selecionada
                      switch (selectedIndex) {
                        case 0:
                          _navigateToManualApplication(context);
                          break;
                        case 1:
                          _navigateToAIAssistedApplication(context);
                          break;
                        case 2:
                          _navigateToAudioApplication(context);
                          break;
                      }
                    }
                  : null, // se nada estiver selecionado, desabilita
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.black
                    : Colors.grey,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Avançar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 100,
      decoration: const BoxDecoration(color: AppColors.black),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Image.asset(AppAssets.eurohiveName, height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorButton({
    required int index,
    required String label,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedIndex == index;
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.white : Colors.grey[800],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToManualApplication(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectApplicationScreen(
          projectId: widget.projectId,
          applicationMode: ApplicationMode.manual,
        ),
      ),
    );
  }

  void _navigateToAIAssistedApplication(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectApplicationScreen(
          projectId: widget.projectId,
          applicationMode: ApplicationMode.aiAssisted,
        ),
      ),
    );
  }

  void _navigateToAudioApplication(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectApplicationScreen(
          projectId: widget.projectId,
          applicationMode: ApplicationMode.audio,
        ),
      ),
    );
  }
}

enum ApplicationMode { manual, aiAssisted, audio }
