**RozgarLink — Daily Wage Worker Support System**

Empowering India's daily wage workers by connecting them with local short-term job opportunities.

📌 About The Project
RozgarLink is a Flutter-based mobile application developed as part of the Programming Skills Development Laboratory mini project. It addresses the real-world problem of unstable work for daily wage laborers in India by creating a digital platform that connects workers with short-term local job opportunities.
The app supports two user roles — Worker and Employer — and provides features like real-time job listings, skill-based matching, shift scheduling, skill training, and mock payment tracking.

🎯 Domain
Labour Tech / Social Impact

# Features
1.Firebase (Group A)
Firebase Authentication — Secure login and registration for Workers and Employers
Cloud Firestore — Real-time job listings and worker profiles
Payment Tracking — Mock daily wage history stored in Firestore

2.Image Transformation (Group B)
Scaling — Zoom profile photo in and out
Rotation — Rotate profile photo to any angle
Translation — Move profile photo horizontally and vertically
Image Picker — Pick photo from Gallery or Camera

3.Time Picker (Group B)
Shift Start & End Time — Worker selects available work hours
Job Reminder Alarm — Set reminder for next day's job
Application Tracking — Track applied jobs with shift timings

4.Multimedia (Group B)
Video Player — Skill training tutorial videos with controls
Audio Player — Job site audio briefs from employers
Playback Controls — Play, pause, seek, forward, rewind


# App Screens
ScreenDescription🌅 Splash ScreenApp logo and tagline🔐 Login ScreenFirebase Auth login📝 Register ScreenWorker or Employer registration🏠 Home ScreenReal-time job listings from Firestore👤 Profile ScreenImage transformation editor📋 Job Detail ScreenJob info + time picker + apply🎓 Learn ScreenVideo & audio skill training💰 Payment ScreenMock daily wage history

# Team Division
MemberModuleResponsibilityMember 1Firebase + Auth + HomeLogin, Register, Firestore job listingsMember 2Image TransformationProfile screen with scale, rotate, translateMember 3Time Picker + JobsJob detail screen, shift timing, remindersMember 4MultimediaVideo player, audio player, learn screen

🛠️Tech Stack
Frontend — Flutter (Dart)
Backend — Firebase (Auth + Firestore)
Packages — image_picker, video_player, audioplayers, cloud_firestore, firebase_auth


🚀 Getting Started
Prerequisites
Flutter SDK installed
Android Studio or VS Code
Firebase project configured

Installation

Clone the repository
bashgit clone https://github.com/aryaa183/RozgarLink.git
cd RozgarLink

Install dependencies

bashflutter pub get

Run the app

bashflutter run

📂 Project Structure
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart       ← Image Transformation
│   ├── job_detail_screen.dart    ← Time Picker
│   ├── learn_screen.dart         ← Multimedia
│   └── payment_screen.dart
└── services/
    └── auth_service.dart

🗂️ Firebase Structure
/users
   /workers
      - name, skill, location, photo, availability
   /employers
      - name, company, contact

/jobs
   - title, location, wage, shift_time, category, employer_id

/payments
   - worker_id, job_id, amount, date, status

📊 Lab Assignment Coverage
Lab AssignmentFeatureScreenStatusFirebase AuthLogin / RegisterLogin Screen
✅Firebase FirestoreReal-time job listingsHome Screen
✅Image TranslationMove photo X/YProfile Screen
✅Image ScalingZoom photoProfile Screen
✅Image RotationRotate photoProfile Screen
✅Time PickerShift selector + reminderJob Detail Screen
✅Video PlayerSkill training videosLearn Screen
✅Audio PlayerJob audio briefsLearn Screen✅

💡 Social Impact
RozgarLink addresses a critical problem faced by millions of daily wage workers in India:

🏗️ No stable work — Workers struggle to find consistent daily employment
📵 No digital presence — Most workers have no way to showcase skills online
💸 Payment uncertainty — No tracking of daily wages earned
📚 Skill gap — No easy access to skill development resources

RozgarLink solves all of these through a simple, accessible mobile app.

The app is designed for easy live modifications during hackathon evaluations:

Add new job categories instantly via Firestore console
Adjust image transformation ranges in seconds
Switch video/audio sources with one line change
Add new filters (gender, location, skill) easily


📄 License
This project is developed for educational purposes as part of the Programming Skills Development Laboratory.
