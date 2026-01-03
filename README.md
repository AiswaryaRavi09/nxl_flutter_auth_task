# Flutter Authentication App (Login & Registration)

A Flutter application implementing **Login and Registration** functionality using **Firebase Authentication** and **Riverpod** for state management.  
The app follows **Material Design principles** with a clean **black & white themed UI** and smooth animations.

---

## 📱 Features

### Login Page
- Email input field
- Password input field
- Login button
- “Forgot Password” link (UI only)
- “Register” link to navigate to Registration page
- Input validation & error handling
- Loading indicator during authentication

### Registration Page
- Name input field
- Email input field
- Password input field
- Confirm password input field
- Register button
- “Back to Login” navigation
- Strong validation (email format, password rules, match check)
- Error messages for invalid inputs or Firebase errors

### Home Page
- Displays logged-in user details
- Logout functionality
- Confirmation dialog on logout
- Animated UI elements

---

##  State Management

- **Riverpod** is used for:
    - Dependency injection
    - Authentication controller
    - Clean separation of UI, logic, and data layers

**Architecture Pattern:**  
MVC-style separation:
- **Model** → Firebase Auth & User model
- **Controller** → AuthController (business logic & validation)
- **View** → Login, Register, Home pages

---

##  Authentication

- Firebase Authentication (Email & Password)
- Dummy Firebase project setup
- Proper error handling for:
    - Invalid email
    - Wrong password
    - User not found
    - Weak password
    - Email already in use

---

##  UI & Design

- Black & White minimal theme
- Material Design guidelines followed
- Animated transitions:
    - Fade
    - Slide
    - Scale
- Responsive layout for different screen sizes

---

##  Tech Stack

- **Flutter**
- **Dart**
- **Firebase Authentication**
- **Riverpod**
- **Material UI**
- **Animations (AnimationController, Tween, Curves)**

---

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.3.0
  firebase_auth: ^6.1.3
  flutter_riverpod: ^3.1.0
