# Anime Character Identifier App

An iOS application that helps users identify anime characters by taking photos, the app provides quick identification of anime characters along with their series information. Using advanced AI technology including Meta's Llama3 for character recognition, Exa ai for searching, and Claude3.5 for debugging, I was able to develop this app in a day.

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Demo

### App Screenshots
![Icon](/Pic/icon.png)
![Home Screen](/Pic/homepage.jpg)
![Camera View](/Pic/mainpage.jpg)

### Character Recognition Demo
![Character Recognition Demo](/Pic/demo.GIF)


## Features

- 📸 Take photos or select from photo library
- 🎯 Precise character segmentation using SAM2
- 🔍 Accurate character identification powered by Llama3
- 📱 Clean and intuitive iOS interface
- 🗃️ RAG-enhanced anime character database integration

## How It Works

1. **Capture**: Take a photo of an anime character you want to identify
2. **Process**: SAM2 segments the character from the background (Not yet developing)
3. **Identify**: Llama3 analyzes the image using our Anime Characters Database (ACDB)
4. **Result**: Get character name, anime series, and related information

## AI-Assisted Development

This project showcases the power of AI-assisted development, utilizing multiple AI tools throughout its lifecycle:
![Proposal](/Pic/proposal.png)

### Project Planning & Documentation
- **Claude (Anthropic)**: Used for generating comprehensive documentation, including this README, technical specifications, and API documentation.
- **Cursor AI**: Assisted in code generation and real-time pair programming during development.
- **Exa AI**: Helped with research on anime character databases and optimal AI model selection.

### Development Benefits
- Reduced development time greatly through AI-assisted coding
- Enhanced code quality with AI-powered code reviews
- Improved documentation accuracy and completeness
- Streamlined decision-making process for technical architecture

### AI Development Process
1. Initial proposal and concept development with Claude
2. Technical architecture planning with Exa AI
3. Code generation and optimization with Cursor AI
4. Documentation and testing strategy with Claude

## Technical Stack

- **Platform**: iOS
- **AI Models**: 
  - Meta's SAM2 for character segmentation
  - Llama3 for character identification
- **Database**: Anime Characters Database (ACDB)
- **Framework**: UIKit
- **Camera**: AVFoundation

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/anime-character-identifier-app.git
```

2. Install dependencies (if using CocoaPods/SPM)
3. Open `anime_character_identifier_app.xcodeproj` in Xcode
4. Build and run the project

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Camera or Photo Library access

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

The project includes both unit tests and UI tests:
- Unit tests for core services (Llama3Service, CameraService)
- UI tests for basic user flows
- Integration tests for AI model interactions

Run tests using:
```bash
xcodebuild test -scheme AnimeCharacterIdentifier -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Error Handling

The app includes comprehensive error handling for:
- Camera/Photo access issues
- Character identification failures
- Network connectivity problems
- Model processing errors

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Meta for SAM2 and Llama3 models
- The anime community for supporting this project
- All contributors and testers
- AI assistants (Claude, Cursor AI, Exa AI) for development support

## Contact

Project Link: [https://github.com/yourusername/anime-character-identifier-app](https://github.com/yourusername/anime-character-identifier-app)

---
Built with ❤️ for anime fans and powered by AI 🤖
