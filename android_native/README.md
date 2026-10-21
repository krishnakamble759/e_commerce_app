# 🛍️ E-Commerce App (Native Android - Kotlin & Jetpack Compose)

This is the native Android Studio version of the E-Commerce App, built using **Kotlin**, **Jetpack Compose (Material 3)**, **Retrofit 2**, **Room Database (SQLite)**, and the **MVVM Clean Architecture**, fully replicating the Flutter application.

---

## 🚀 Features (1:1 Exact Match)

- **Authentication (Login Screen)**:
  - Connects to FakeStore API (`POST https://fakestoreapi.com/auth/login`)
  - Displays the INAM Store brand logo (`inam.png`)
  - Pre-filled test credentials: username `mor_2314`, password `83r5^_`
  - Token persistence via secure `SessionManager` (SharedPreferences)
  - Validation, progress indicator, and error notifications

- **Product Catalog (Product List Screen)**:
  - Fetches product list (`GET https://fakestoreapi.com/products`)
  - Real-time global search bar filtering titles and descriptions
  - Navigation drawer with dynamic categories (`GET https://fakestoreapi.com/products/categories`)
  - Sorting options: *None*, *Price: Low to High*, *Price: High to Low*, *A-Z*
  - 2-Column responsive grid using `LazyVerticalGrid` and `ProductCard`
  - Floating cart badge with live quantity counter
  - Logout action in top app bar

- **Product Details Screen**:
  - Full-size product image loaded asynchronously with Coil
  - Title, description, teal-accented price
  - "Add to Cart" button with instant feedback SnackBar

- **Cart Management (Cart Screen)**:
  - Offline persistence using **Room Database (SQLite)**
  - Displays thumbnail, product title, quantity, and subtotal
  - Increment (`+`), Decrement (`-`), and Delete controls
  - "Clear Cart" icon in top bar
  - Real-time total calculation
  - "Proceed to Checkout" action

- **Guest Checkout Screen**:
  - Form validation for Name, Email, and Address
  - Submits order to FakeStore API (`POST https://fakestoreapi.com/carts`)
  - Clears cart upon successful order submission and returns to product catalog

---

## 🛠️ Tech Stack & Architecture

- **Language**: Kotlin 2.0+
- **UI Toolkit**: Jetpack Compose with Material 3 design system
- **Architecture**: MVVM (Model - View - ViewModel) + Repository Pattern
- **Networking**: Retrofit 2 + OkHttp + Gson
- **Local Database**: AndroidX Room (SQLite) with KSP compiler
- **Image Loading**: Coil Compose
- **Navigation**: Jetpack Navigation Compose

---

## 📂 Project Structure Comparison (Flutter vs Native Android)

| Feature / Layer | Flutter Location | Native Android (Kotlin & Compose) |
|---|---|---|
| **App Entry Point** | `lib/main.dart` | `MainActivity.kt` & `ECommerceApplication.kt` |
| **Product Model** | `lib/models/product.dart` | `data/model/Product.kt` |
| **Cart Model** | `lib/models/cart_item.dart` | `data/model/CartItem.kt` & `CartEntity.kt` |
| **User Model** | `lib/models/user.dart` | `data/model/User.kt` |
| **API Service** | `lib/services/api_services.dart` | `data/remote/FakeStoreApiService.kt` |
| **Auth Service** | `lib/services/auth_service.dart` | `data/repository/AuthRepository.kt` |
| **Local Database** | `lib/services/db_service.dart` | `data/local/CartDao.kt` & `CartDatabase.kt` |
| **Session / Storage**| `flutter_secure_storage` | `data/local/SessionManager.kt` |
| **Product State** | `lib/providers/product_provider.dart` | `ui/screens/product_list/ProductListViewModel.kt` |
| **Cart State** | `lib/providers/cart_provider.dart` | `ui/screens/cart/CartViewModel.kt` |
| **Auth State** | `lib/providers/auth_provider.dart` | `ui/screens/login/LoginViewModel.kt` |
| **Product Card** | `lib/widgets/product_card.dart` | `ui/components/ProductCard.kt` |
| **Search Bar** | `lib/widgets/search_bar.dart` | `ui/components/GlobalSearchBar.kt` |
| **Filter Panel** | `lib/widgets/filter_panel.dart` | `ui/components/FilterDrawer.kt` |
| **Login Screen** | `lib/screens/login_screen.dart` | `ui/screens/login/LoginScreen.kt` |
| **Product List** | `lib/screens/product_list_screen.dart` | `ui/screens/product_list/ProductListScreen.kt` |
| **Product Detail** | `lib/screens/product_detail_screen.dart`| `ui/screens/product_detail/ProductDetailScreen.kt` |
| **Cart Screen** | `lib/screens/cart_screen.dart` | `ui/screens/cart/CartScreen.kt` |
| **Checkout Screen** | `lib/screens/checkout_screen.dart` | `ui/screens/checkout/CheckoutScreen.kt` |

---

## 💻 How to Open in Android Studio

1. Open **Android Studio**.
2. Click **File -> Open...** (or **Open** from welcome window).
3. Browse and select the directory:
   `C:\Users\Krishna\projects\e_commerce_app\android_native`
4. Wait for Gradle Sync to complete.
5. Select your Emulator or Physical Device and press **Run (Shift + F10)**.

The precompiled debug APK is also ready at:
`android_native/app/build/outputs/apk/debug/app-debug.apk`
