# Mithran - Empowering Farmers with Technology

Welcome to the Mithran project repository! Mithran is an innovative agritech application designed to assist small and marginal farmers by providing comprehensive agricultural solutions. Our app leverages advanced technologies, APIs, and a robust tech stack to deliver a seamless and user-friendly experience.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [APIs Used](#apis-used)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

Mithran aims to bridge the gap between smallholder farmers and modern agricultural technology. By offering a suite of tools and resources, Mithran helps farmers make informed decisions, optimize their operations, and improve their productivity.

## Features

1. **Realtime Weather Forecasts and Alerts**: Provides up-to-date weather information and alerts.
2. **AI-Powered Pest and Disease Management**: Utilizes machine learning to identify pests and diseases.
3. **Realtime Market Information**: Keeps farmers informed about market prices.
4. **AgriBOT**: An interactive chatbot for agricultural queries.
5. **Say it Out**: Reads content aloud, supporting one Indic language.
6. **Soil Health Monitoring**: Provides historical soil health data.
7. **Digital Twin of Crop**: Interactive 3D model representing crop growth stages.
8. **Awareness and Government Schemes**: News, video guides, and information about government schemes.
9. **Expense Tracker (Khata Book)**: Helps farmers manage their expenses.
10. **Field Boundaries and Operations**: Tools for managing field boundaries and crop monitoring.

## Tech Stack
![image](https://github.com/user-attachments/assets/1a245b9b-d200-4549-93ec-6088da6f5d12)

### Frontend

- **Flutter**: For building cross-platform mobile applications.
- **Dart**: Programming language used with Flutter.

### Backend

- **Node.js**: Server-side JavaScript runtime.
- **Python**: For AI and machine learning functionalities.
- **Rust**: For performance-critical components.

### Cloud and Infrastructure

- **Google Cloud Platform (GCP)**:
  - **Compute Engine**: For scalable computing.
  - **Cloud Functions**: Serverless functions.
  - **App Engine**: Platform for building scalable web applications.
  - **Cloud SQL (MySQL)**: Managed relational database service.
  - **Firebase**: For real-time database management and push notifications.
  - **Google Cloud Storage**: For storing large datasets.

### APIs and Integrations

- **OpenAI**: For advanced AI and natural language processing.
- **Google Cloud Translation API**: For language translation services.
- **Google Cloud Text-to-Speech API**: For converting text to speech.
- **Google Maps API**: For mapping and location services.
- **Weather APIs**: For realtime weather data.
- **Market APIs**: For market price information.
- **Plantix API**: For pest and disease management.
- **Leaf API**: For crop management and monitoring.

### DevOps and Containerization

- **Docker**: For containerizing applications.
- **GitHub**: For version control and collaboration.
- **VS Code**: Preferred IDE for development.

### Project Management and Design

- **Jira**: For project management and task tracking.
- **Adobe Illustrator, Canva, Figma**: For design and prototyping.

## Architecture

Mithran's architecture is designed to be scalable, reliable, and efficient. The application follows a microservices architecture, with each service responsible for a specific functionality. These services communicate with each other via REST APIs and are deployed on Google Cloud Platform for scalability and high availability.

![image](https://github.com/user-attachments/assets/04c85111-678a-40f1-8ba4-babab51ce5d0)


## APIs Used

### OpenAI
- **Purpose**: Natural language processing for chatbot and AI functionalities.
- **Endpoints**: 
  - `/v1/engines/davinci-codex/completions`: For generating responses.

### Google Cloud Translation API
- **Purpose**: Translating content to different languages.
- **Endpoints**: 
  - `https://translation.googleapis.com/language/translate/v2`: For translation requests.

### Google Cloud Text-to-Speech API
- **Purpose**: Converting text to speech for the "Say it Out" feature.
- **Endpoints**: 
  - `https://texttospeech.googleapis.com/v1/text:synthesize`: For synthesizing speech from text.

### Google Maps API
- **Purpose**: Mapping and geolocation services.
- **Endpoints**: 
  - `https://maps.googleapis.com/maps/api/geocode/json`: For geocoding addresses.
  - `https://maps.googleapis.com/maps/api/directions/json`: For route planning.

### Plantix API
- **Purpose**: Pest and disease identification.
- **Endpoints**: Provided upon obtaining API access.

### Leaf API
- **Purpose**: Crop management and monitoring.
- **Endpoints**: Provided upon obtaining API access.

## Installation

1. **Clone the Repository**:
   bash
   git clone https://github.com/yourusername/mithran.git
   cd mithran
   

2. **Install Dependencies**:
   bash
   npm install
   flutter pub get
   

3. **Set Up Environment Variables**:
   Create a `.env` file in the root directory and add the necessary environment variables.

4. **Run the Application**:
   bash
   npm start
   flutter run
   

## Usage

- **User Registration**: Users can register and create profiles.
- **Weather Forecast**: Access real-time weather information.
- **Pest and Disease Management**: Identify and manage pests and diseases.
- **Market Information**: View current market prices.
- **Digital Twin**: Monitor crop growth stages.

## Contributing

We welcome contributions from the community! Please follow these steps to contribute:

1. **Fork the Repository**.
2. **Create a Feature Branch**:
   bash
   git checkout -b feature/your-feature-name
   
3. **Commit Your Changes**:
   bash
   git commit -m 'Add some feature'
   
4. **Push to the Branch**:
   bash
   git push origin feature/your-feature-name
   
5. **Open a Pull Request**.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Thank you for your interest in Mithran! Together, we can empower farmers and transform agriculture through technology.
