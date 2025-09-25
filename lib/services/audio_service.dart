import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AudioService {
  static bool _isRecording = false;
  static String? _currentRecordingPath;
  static final SpeechToText _speechToText = SpeechToText();
  static String _recognizedText = '';
  static double _confidence = 0.0;
  static DateTime? _recordingStartTime;

  // Callbacks para notificar mudanças
  static Function(String)? onTextRecognized;
  static Function(double)? onConfidenceChanged;
  static Function(bool)? onRecordingStateChanged;

  // Solicitar permissões necessárias
  static Future<bool> requestPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();
    
    return microphoneStatus.isGranted && storageStatus.isGranted;
  }

  // Inicializar speech-to-text
  static Future<bool> initializeSpeechToText() async {
    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          // Debug: Speech-to-text status
          if (status == 'done' || status == 'notListening') {
            _isRecording = false;
            onRecordingStateChanged?.call(false);
          }
        },
        onError: (error) {
          // Debug: Speech-to-text error
          _isRecording = false;
          onRecordingStateChanged?.call(false);
        },
      );
      return available;
    } catch (e) {
      // Debug: Erro ao inicializar speech-to-text
      return false;
    }
  }

  // Iniciar gravação com speech-to-text
  static Future<bool> startRecording() async {
    try {
      if (_isRecording) return false;

      // Verificar permissões
      if (!await requestPermissions()) {
        throw Exception('Permissões de microfone não concedidas');
      }

      // Inicializar speech-to-text se necessário
      if (!await initializeSpeechToText()) {
        throw Exception('Speech-to-text não disponível');
      }

      // Obter diretório para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/recording_$timestamp.m4a';

      // Iniciar gravação
      _isRecording = true;
      _recordingStartTime = DateTime.now();
      _recognizedText = '';
      _confidence = 0.0;
      
      onRecordingStateChanged?.call(true);

      // Iniciar escuta
      _speechToText.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          if (result.hasConfidenceRating && result.confidence > 0) {
            _confidence = result.confidence;
            onConfidenceChanged?.call(_confidence);
          }
          onTextRecognized?.call(_recognizedText);
        },
      );
      
      return true;
    } catch (e) {
      _isRecording = false;
      onRecordingStateChanged?.call(false);
      throw Exception('Erro ao iniciar gravação: $e');
    }
  }

  // Parar gravação
  static Future<String?> stopRecording() async {
    try {
      if (!_isRecording) return null;

      _speechToText.stop();
      _isRecording = false;
      onRecordingStateChanged?.call(false);
      
      return _currentRecordingPath;
    } catch (e) {
      throw Exception('Erro ao parar gravação: $e');
    }
  }

  // Cancelar gravação
  static Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        _speechToText.stop();
        _isRecording = false;
        onRecordingStateChanged?.call(false);
        
        // Deletar arquivo se existir
        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
        _currentRecordingPath = null;
        _recognizedText = '';
        _confidence = 0.0;
      }
    } catch (e) {
      throw Exception('Erro ao cancelar gravação: $e');
    }
  }

  // Reproduzir áudio (implementação simulada)
  static Future<void> playAudio(String filePath) async {
    try {
      // Debug: Reproduzindo áudio
      // Simular reprodução
    } catch (e) {
      throw Exception('Erro ao reproduzir áudio: $e');
    }
  }

  // Parar reprodução (implementação simulada)
  static Future<void> stopPlayback() async {
    try {
      // Debug: Parando reprodução
      // Simular parada da reprodução
    } catch (e) {
      throw Exception('Erro ao parar reprodução: $e');
    }
  }

  // Verificar se está gravando
  static bool get isRecording => _isRecording;

  // Verificar se está reproduzindo (sempre false na implementação simulada)
  static bool get isPlaying => false;

  // Obter texto reconhecido
  static String get recognizedText => _recognizedText;

  // Obter confiança do reconhecimento
  static double get confidence => _confidence;

  // Obter duração da gravação atual
  static Duration? getRecordingDuration() {
    if (_recordingStartTime != null) {
      return DateTime.now().difference(_recordingStartTime!);
    }
    return null;
  }

  // Limpar recursos
  static Future<void> dispose() async {
    try {
      if (_isRecording) {
        await cancelRecording();
      }
      _speechToText.stop();
    } catch (e) {
      // Ignorar erro
    }
  }

  // Configurar callbacks
  static void setCallbacks({
    Function(String)? onTextRecognized,
    Function(double)? onConfidenceChanged,
    Function(bool)? onRecordingStateChanged,
  }) {
    AudioService.onTextRecognized = onTextRecognized;
    AudioService.onConfidenceChanged = onConfidenceChanged;
    AudioService.onRecordingStateChanged = onRecordingStateChanged;
  }
}