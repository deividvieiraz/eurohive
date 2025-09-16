import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  static bool _isRecording = false;
  static String? _currentRecordingPath;

  // Solicitar permissões necessárias
  static Future<bool> requestPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    
    return microphoneStatus.isGranted && storageStatus.isGranted;
  }

  // Iniciar gravação (implementação simulada)
  static Future<bool> startRecording() async {
    try {
      if (_isRecording) return false;

      // Verificar permissões
      if (!await requestPermissions()) {
        throw Exception('Permissões de microfone não concedidas');
      }

      // Obter diretório para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/recording_$timestamp.m4a';

      // Simular início da gravação
      _isRecording = true;
      
      return true;
    } catch (e) {
      throw Exception('Erro ao iniciar gravação: $e');
    }
  }

  // Parar gravação (implementação simulada)
  static Future<String?> stopRecording() async {
    try {
      if (!_isRecording) return null;

      // Simular parada da gravação
      _isRecording = false;
      
      return _currentRecordingPath;
    } catch (e) {
      throw Exception('Erro ao parar gravação: $e');
    }
  }

  // Cancelar gravação
  static Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        _isRecording = false;
        
        // Deletar arquivo se existir
        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
        _currentRecordingPath = null;
      }
    } catch (e) {
      throw Exception('Erro ao cancelar gravação: $e');
    }
  }

  // Reproduzir áudio (implementação simulada)
  static Future<void> playAudio(String filePath) async {
    try {
      // Simular reprodução
      print('Reproduzindo áudio: $filePath');
    } catch (e) {
      throw Exception('Erro ao reproduzir áudio: $e');
    }
  }

  // Parar reprodução (implementação simulada)
  static Future<void> stopPlayback() async {
    try {
      // Simular parada da reprodução
      print('Parando reprodução');
    } catch (e) {
      throw Exception('Erro ao parar reprodução: $e');
    }
  }

  // Verificar se está gravando
  static bool get isRecording => _isRecording;

  // Verificar se está reproduzindo (sempre false na implementação simulada)
  static bool get isPlaying => false;

  // Obter duração da gravação atual
  static Future<Duration?> getRecordingDuration() async {
    if (_currentRecordingPath != null) {
      try {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          return Duration.zero;
        }
      } catch (e) {
        // Ignorar erro
      }
    }
    return null;
  }

  // Limpar recursos
  static Future<void> dispose() async {
    try {
      if (_isRecording) {
        await cancelRecording();
      }
    } catch (e) {
      // Ignorar erro
    }
  }
}