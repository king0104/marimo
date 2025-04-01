import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:marimo_client/models/ai/ai_response_model.dart';
import 'package:openai_dart/openai_dart.dart';

class ChatService {
  final OpenAIClient client;

  ChatService._(this.client);

  /// factory 생성자를 통해 dotenv에서 API 키를 읽어 OpenAIClient를 초기화합니다.
  factory ChatService.create() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY is not set in .env');
    }
    return ChatService._(OpenAIClient(apiKey: apiKey));
  }

  Future<AIResponseModel> fetchChatGPTResponse({
    required String code,
    required String title,
  }) async {
    final prompt = '''
진단 코드: $code
문제: $title

아래 JSON 형식으로 답변해줘:
{
  "meaningList": ["설명1", "설명2", ...],
  "actionList": ["조치1", "조치2", ...]
}
''';

    final response = await client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId('gpt-4o'),
        messages: [
          ChatCompletionMessage.system(content: 'You are a helpful assistant.'),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(prompt),
          ),
        ],
        temperature: 0.7,
      ),
    );

    String? text = response.choices.first.message.content;
    if (text == null) {
      throw Exception("Response message content is null");
    }
    // 응답 텍스트의 앞뒤 공백 제거
    text = text.trim();

    // 만약 코드 블록(백틱)으로 감싸져 있다면 제거
    if (text.startsWith("```json")) {
      text = text.replaceFirst("```json", "").trim();
      if (text.endsWith("```")) {
        text = text.substring(0, text.length - 3).trim();
      }
    } else if (text.startsWith("```")) {
      text = text.replaceFirst("```", "").trim();
      if (text.endsWith("```")) {
        text = text.substring(0, text.length - 3).trim();
      }
    }

    try {
      // 정리된 텍스트를 JSON으로 파싱
      final Map<String, dynamic> jsonData = json.decode(text);
      return AIResponseModel.fromJson(jsonData);
    } catch (e) {
      // 파싱에 실패한 경우, 콘솔에 전체 응답을 출력해서 디버깅에 도움을 줍니다.
      debugPrint('JSON parsing failed. Response text: $text');
      rethrow;
    }
  }
}
