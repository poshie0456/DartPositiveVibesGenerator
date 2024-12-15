# DartPositiveVibesGenerator
Dart Service for Text-to-Speech and Affirmation Generation

This Dart service provides functionality for generating affirmations and converting them to speech. The service interacts with two APIs:

1. **Generative Language API** for generating affirmation content.
2. **Eleven Labs API** for converting text to speech.

## Features

- **Text Generation**: Randomly selects an affirmation prompt or uses custom input to generate a text response.
- **Text-to-Speech**: Converts the generated affirmation text into speech and saves it as an MP3 file.

## Setup

1. **API Keys**: Replace the `APIKEY` and Eleven Labs API key with your own credentials.
   - For the **Generative Language API**, provide your API key from Google Cloud.
   - For **Eleven Labs**, obtain your `voice_id` and API key for text-to-speech functionality.

2. **Dependencies**:
   - `http`: For making HTTP requests.
   - `path_provider`: To save the MP3 file to a local directory.
   - `audioplayers`: To play the generated audio file.

## Example Usage

https://github.com/user-attachments/assets/66428673-9781-42b3-9633-5a2b1880857f

```dart
final service = Service();

// Generate and print an affirmation
String affirmation = await service.textGeneration();
print(affirmation);

// Generate speech from the affirmation and save as MP3
String audioFilePath = await service.generateAndPlaySpeech(affirmation);
print("Audio saved at $audioFilePath");







