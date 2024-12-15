import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart'; // To play audio

class Service {
  // Replace with your API key for the language generation service
  final String APIKEY = "insert here"; 

  // List of random affirmation prompts
  List<String> prompts = [
    "Give me one short positive affirmation about self-love.",
    "Tell me one short affirmation to boost my confidence.",
    "Provide one short calming affirmation for when I'm feeling stressed.",
    "Share one short motivational affirmation to achieve my goals.",
    "Give me one short, uplifting affirmation for a great day.",
    "Provide one short powerful affirmation to overcome fear.",
    "Tell me one short affirmation about being grateful.",
    "Share one short positive affirmation about personal growth."
  ];

  // Function to generate text based on prompts or input text
  Future<String> textGeneration({String aboutText = ""}) async {
    const String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

    // If no input text is provided, use a random affirmation prompt
    String promptText = (aboutText.isNotEmpty
        ? "The following response is about mental health or affirmation, respond accordingly:" + aboutText
        : (prompts..shuffle()).first);

    // Request payload for the API
    Map<String, dynamic> payload = {
      "contents": [
        {
          "parts": [
            {"text": promptText}
          ]
        }
      ]
    };

    try {
      // Make the POST request to the language generation API
      final response = await http.post(
        Uri.parse("$url?key=$APIKEY"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response contains generated candidates
        if (responseData.containsKey('candidates') &&
            responseData['candidates'].isNotEmpty) {
          final text =
              responseData['candidates'][0]['content']['parts'][0]['text'];
          return text; // Return the generated affirmation text
        } else {
          return "No affirmation generated.";
        }
      } else {
        return "Failed to fetch affirmation. Status code: ${response.statusCode}";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  // Function to generate speech from the given text and save it as an MP3 file
  Future<String> generateAndPlaySpeech(String text) async {
    try {
      // Replace with your valid voice_id and model_id
      String voice_id = "insert here";  // Example: "9BWtsMINqrJLrRacOk9x"
      String model_id = "eleven_multilingual_v2"; // Default model

      // Define the request body for the Eleven Labs API
      final Map<String, dynamic> requestBody = {
        'text': text,
        'model_id': model_id,
        'voice_settings': {
          'similarity_boost': 0.75,
          'speaker_boost': true,
          'stability': 0.7,
        },
      };

      // Send the request to Eleven Labs API
      final response = await http.post(
        Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voice_id'),
        headers: {
          'xi-api-key': 'insert here',  // Insert your Eleven Labs API key here
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Save the audio file to the temporary directory
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/output.mp3');
        
        // Write the response bytes to the file
        await file.writeAsBytes(response.bodyBytes);
        print('Audio file saved as ${file.path}');
        
        return file.path;
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return "Error: ${response.body}";
      }
    } catch (error) {
      print('Error generating speech: $error');
      return "Error: $error";
    }
  }
}
