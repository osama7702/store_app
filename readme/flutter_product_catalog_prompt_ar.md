# برومبت تفصيلي لتنفيذ Flutter Technical Task

## عنوان المهمة

نفّذ تطبيق Flutter باسم **Product Catalog with Local Cart** يعرض منتجات من REST API، ويدعم البحث، المفضلة، تفاصيل المنتج، وسلة شراء محلية محفوظة باستخدام Sqflite.

> \\\*\\\*تنبيه مهم:\\\*\\\* لا تحذف أي مطلب من المتطلبات الأصلية. المطلوب هو تنفيذ التاسك كاملًا كما هو، مع إضافة تحسينات UI/UX وأفكار إثرائية تجعل المشروع أقوى وأكثر احترافية.

\---

## الدور المطلوب منك

تصرف كمطور Flutter محترف لديه خبرة في:

* Flutter 3.x
* Dart مع Null Safety
* Clean Architecture أو تنظيم ملفات واضح جدًا
* Cubit كـ State Management أساسي ووحيد
* Repository Pattern
* Dio للتعامل مع API
* Sqflite للتخزين المحلي للسلة
* SharedPreferences أو SharedPreferencesAsync لحفظ المفضلة
* UI/UX احترافي مع Animation وتجربة استخدام سلسة

\---

## ملاحظة مهمة حول الإصدارات

استخدم **آخر إصدار مستقر متاح** من كل مكتبة وقت إنشاء المشروع.

يفضل إضافة الحزم بهذه الطريقة حتى يتم جلب أحدث إصدار تلقائيًا:

```bash
flutter pub add flutter\\\_bloc
flutter pub add dio
flutter pub add sqflite
flutter pub add path
flutter pub add shared\\\_preferences
flutter pub add cached\\\_network\\\_image
flutter pub add equatable
flutter pub add flutter\\\_animate
flutter pub add skeletonizer
flutter pub add lottie
flutter pub add badges
flutter pub add go\\\_router
flutter pub add get\\\_it
flutter pub add internet\\\_connection\\\_checker\\\_plus

flutter pub add google\\\_fonts
```

> لا تكتب إصدارات قديمة يدويًا داخل `pubspec.yaml` إلا إذا احتجت لتثبيت نسخة محددة بسبب توافق المشروع.

\---

## API المطلوب استخدامه

استخدم الرابط التالي لجلب المنتجات:

```text
https://fakestoreapi.com/products
```

يجب جلب المنتجات من API وعرضها داخل التطبيق.

\---

## المتطلبات الأساسية للتطبيق

### 1\. الشاشة الرئيسية Home Screen

يجب أن تحتوي الشاشة الرئيسية على:

* جلب المنتجات من API عند فتح التطبيق.
* عرض المنتجات داخل Responsive Grid.
* دعم Pull to Refresh لإعادة تحميل المنتجات.
* عرض Loading State أثناء جلب البيانات.
* عرض Error State عند حدوث خطأ مع زر Try Again.
* عرض Empty State إذا لم توجد منتجات.

كل Product Card يجب أن يحتوي على:

* صورة المنتج.
* عنوان المنتج.
* السعر.
* أيقونة Favorite.
* زر Add to Cart.

### تحسينات مطلوبة في الشاشة الرئيسية

* استخدم `Skeletonizer` بدل `CircularProgressIndicator` فقط أثناء التحميل.
* استخدم `CachedNetworkImage` لعرض الصور مع Placeholder و Error Widget.
* أضف Animation خفيف عند ظهور الكروت باستخدام `flutter\\\_animate`.
* أضف Badge فوق أيقونة السلة يظهر عدد عناصر السلة.
* عند الضغط على Add to Cart، اعرض SnackBar واضح مثل:

```text
Product added to cart successfully
```

\---

### 2\. شاشة تفاصيل المنتج Product Details

عند الضغط على أي منتج، انتقل إلى شاشة تفاصيل المنتج.

يجب عرض:

* صورة المنتج.
* العنوان.
* الوصف.
* التصنيف Category.
* التقييم Rating.
* السعر.
* زر Add to Cart.
* أيقونة Favorite.

### تحسينات مطلوبة في شاشة التفاصيل

* استخدم Hero Animation بين صورة المنتج في الكرت وصورة المنتج في صفحة التفاصيل.
* اجعل التصميم منظمًا وواضحًا.
* أضف Bottom Button ثابت أو واضح لإضافة المنتج للسلة.
* عند الإضافة للسلة، إذا كان المنتج موجودًا مسبقًا، قم بزيادة الكمية بدل تكراره كسطر جديد.

\---

### 3\. البحث Search

أضف Search Field في الشاشة الرئيسية.

يجب أن يعمل البحث محليًا بعد جلب المنتجات من API، وليس عن طريق طلب جديد للسيرفر.

آلية البحث:

* البحث يكون حسب عنوان المنتج Title.
* البحث غير حساس لحالة الأحرف.
* عند عدم وجود نتائج، اعرض Empty State واضح.

### تحسينات مقترحة للبحث

* أضف Debounce بسيط أثناء الكتابة لتقليل عمليات الفلترة المتكررة.
* أضف زر Clear داخل حقل البحث عند وجود نص.

\---

### 4\. المفضلة Favorites

يجب دعم إضافة وإزالة المنتجات من المفضلة.

المطلوب:

* عند الضغط على القلب، يتم إضافة أو إزالة المنتج من المفضلة.
* يجب أن تبقى المفضلة محفوظة بعد إغلاق التطبيق وفتحه مرة أخرى.
* استخدم `SharedPreferences` أو الأفضل `SharedPreferencesAsync` إن كان مناسبًا.
* خزّن قائمة IDs للمنتجات المفضلة.

### تحسينات مطلوبة للمفضلة

* أضف Animation بسيط عند الضغط على القلب.
* اجعل لون القلب يتغير بوضوح حسب الحالة.
* من الجيد إضافة شاشة أو فلتر لعرض المنتجات المفضلة فقط، إذا لم يؤثر ذلك على وقت التنفيذ.

\---

### 5\. سلة الشراء Shopping Cart باستخدام Sqflite

يجب تنفيذ السلة باستخدام قاعدة بيانات محلية `Sqflite`.

السلة يجب أن تدعم:

* إضافة المنتجات.
* حذف المنتجات.
* تحديث كمية المنتج.
* زيادة الكمية.
* تقليل الكمية.
* حذف المنتج عند وصول الكمية إلى صفر أو بعد تأكيد المستخدم.
* عرض السعر الكلي.
* حفظ بيانات السلة بعد إغلاق التطبيق وإعادة فتحه.

شاشة السلة يجب أن تعرض:

* صورة المنتج.
* عنوان المنتج.
* السعر.
* أزرار التحكم بالكمية + و -.
* Subtotal لكل منتج.
* Total cart price.

### تحسينات مطلوبة في السلة

* أضف Empty Cart State بتصميم لطيف أو Lottie Animation.
* أضف Confirm Dialog عند حذف منتج من السلة.
* أضف Clear Cart اختيارية لتفريغ السلة بالكامل.
* اجعل Total Price واضحًا في أسفل الشاشة.
* عند الضغط على + أو - يجب تحديث Sqflite والـ Cubit State مباشرة.

\---

## إدارة الحالة State Management

استخدم **Cubit فقط** كـ State Management.

لا تستخدم Provider لإدارة الحالة، ولا تستخدم GetX.

المطلوب تقسيم Cubits بشكل واضح:

```text
ProductsCubit
FavoritesCubit
CartCubit
```

### ProductsCubit

مسؤول عن:

* جلب المنتجات.
* Loading State.
* Success State.
* Error State.
* Refresh.
* Search محلي.
* Sort/Filter إن تم إضافتهما.

### FavoritesCubit

مسؤول عن:

* تحميل المنتجات المفضلة من SharedPreferences.
* إضافة منتج للمفضلة.
* إزالة منتج من المفضلة.
* معرفة هل المنتج Favorite أم لا.

### CartCubit

مسؤول عن:

* تحميل السلة من Sqflite.
* إضافة منتج للسلة.
* حذف منتج.
* زيادة الكمية.
* تقليل الكمية.
* حساب الإجمالي.
* حساب عدد عناصر السلة.

\---

## هيكلة المشروع المقترحة

استخدم هيكلة منظمة وواضحة، ويفضل أن تكون قريبة من Clean Architecture:

```text
lib/
  main.dart
  app.dart

  core/
    constants/
      app\\\_constants.dart
    network/
      dio\\\_client.dart
      api\\\_endpoints.dart
    database/
      app\\\_database.dart
    errors/
      failure.dart
    utils/
      price\\\_formatter.dart
    widgets/
      custom\\\_error\\\_widget.dart
      empty\\\_state\\\_widget.dart
      loading\\\_skeleton.dart
      custom\\\_app\\\_bar.dart

  features/
    products/
      data/
        models/
          product\\\_model.dart
          rating\\\_model.dart
        datasources/
          products\\\_remote\\\_data\\\_source.dart
        repositories/
          products\\\_repository\\\_impl.dart
      domain/
        entities/
          product\\\_entity.dart
        repositories/
          products\\\_repository.dart
      presentation/
        cubit/
          products\\\_cubit.dart
          products\\\_state.dart
        screens/
          home\\\_screen.dart
          product\\\_details\\\_screen.dart
        widgets/
          product\\\_card.dart
          products\\\_grid.dart
          search\\\_field.dart
          category\\\_filter.dart

    favorites/
      data/
        datasources/
          favorites\\\_local\\\_data\\\_source.dart
        repositories/
          favorites\\\_repository\\\_impl.dart
      domain/
        repositories/
          favorites\\\_repository.dart
      presentation/
        cubit/
          favorites\\\_cubit.dart
          favorites\\\_state.dart

    cart/
      data/
        models/
          cart\\\_item\\\_model.dart
        datasources/
          cart\\\_local\\\_data\\\_source.dart
        repositories/
          cart\\\_repository\\\_impl.dart
      domain/
        entities/
          cart\\\_item\\\_entity.dart
        repositories/
          cart\\\_repository.dart
      presentation/
        cubit/
          cart\\\_cubit.dart
          cart\\\_state.dart
        screens/
          cart\\\_screen.dart
        widgets/
          cart\\\_item\\\_tile.dart
          quantity\\\_controls.dart
          cart\\\_total\\\_section.dart
```

\---

## Models المطلوبة

### ProductModel

يجب أن يحتوي على:

* id
* title
* price
* description
* category
* image
* rating

### RatingModel

يجب أن يحتوي على:

* rate
* count

### CartItemModel

يجب أن يحتوي على:

* productId
* title
* price
* image
* quantity

ويجب حساب subtotal كالتالي:

```dart
subtotal = price \\\* quantity
```

\---

## قاعدة بيانات Sqflite

أنشئ جدول باسم `cart\\\_items` يحتوي على الأعمدة التالية:

```text
product\\\_id INTEGER PRIMARY KEY
title TEXT NOT NULL
price REAL NOT NULL
image TEXT NOT NULL
quantity INTEGER NOT NULL
```

### قواعد مهمة للسلة

* إذا تمت إضافة منتج موجود مسبقًا، لا تضف Row جديد، بل زد الكمية.
* إذا تم تقليل الكمية ووصلت إلى 0، احذف المنتج من السلة.
* كل عملية تعديل يجب أن تنعكس مباشرة على الواجهة.

\---

## تحسينات إضافية مميزة

أضف قدر الإمكان من هذه الميزات بدون الإضرار بالمطلوب الأساسي:

### 1\. Sort Products

أضف إمكانية ترتيب المنتجات حسب:

* السعر من الأقل للأعلى.
* السعر من الأعلى للأقل.
* الأعلى تقييمًا.

### 2\. Filter by Category

استخرج التصنيفات من المنتجات واعرضها كـ Chips أعلى الشبكة.

### 3\. Dark Mode

أضف دعم Light و Dark Theme.

### 4\. Responsive Grid

اجعل عدد الأعمدة يتغير حسب عرض الشاشة:

```text
Small phones: 2 columns
Large phones: 2 columns
Tablet: 3 or 4 columns
```

### 5\. Internet Error Handling

في حال عدم توفر الإنترنت أو فشل الطلب، اعرض رسالة واضحة مع زر إعادة المحاولة.

### 6\. Image Full Preview

عند الضغط على صورة المنتج في التفاصيل، يمكن فتحها بحجم أكبر.

### 7\. App Polish

أضف:

* App Icon.
* Splash Screen إن أمكن.
* ألوان متناسقة.
* Typography مرتب.
* Padding ومسافات جيدة.

\---

## قواعد كتابة الكود

يجب الالتزام بما يلي:

* استخدم Null Safety بشكل صحيح.
* لا تضع منطق API داخل UI.
* لا تضع منطق Sqflite داخل UI.
* لا تجعل Cubit يتعامل مباشرة مع Dio أو Sqflite، بل عبر Repository.
* استخدم `Equatable` للـ States والموديلات إن كان مناسبًا.
* اجعل الواجهات Reusable Widgets قدر الإمكان.
* تجنب الملفات الضخمة.
* اكتب أسماء واضحة للكلاسات والدوال.
* عالج الأخطاء برسائل مفهومة للمستخدم.

\---

## الحالات المطلوبة لكل Cubit

### ProductsState

يجب أن يغطي الحالات التالية:

```text
initial
loading
success
error
```

ويفضل أن يحتوي Success على:

* allProducts
* filteredProducts
* selectedCategory
* searchQuery
* sortType

### FavoritesState

يجب أن يحتوي على:

* favoriteIds
* loading إذا احتجت
* error إذا احتجت

### CartState

يجب أن يحتوي على:

* cartItems
* totalPrice
* totalItems
* loading
* error

\---

## التنقل Navigation

يمكن استخدام `go\\\_router` أو Navigator العادي.

الأفضل استخدام `go\\\_router` لتنظيم المشروع.

المسارات المقترحة:

```text
/
/product-details
/cart
```

\---

## معايير قبول المشروع

يُعتبر المشروع مكتملًا إذا تحقق التالي:

* المنتجات تظهر من API.
* الشبكة Responsive.
* البحث يعمل محليًا.
* صفحة التفاصيل تعمل.
* الإضافة للسلة تعمل.
* السلة محفوظة في Sqflite.
* التحكم بالكمية يعمل.
* السعر الكلي صحيح.
* المفضلة محفوظة بعد إعادة تشغيل التطبيق.
* يوجد Loading و Error Handling.
* Pull to Refresh يعمل.
* Cubit مستخدم بشكل واضح.
* الكود منظم باستخدام Repository Pattern.
* توجد إضافات UI/UX مثل Skeleton Loading و Animation و Empty States.

\---

## المطلوب في النهاية

أنشئ مشروع Flutter كامل ومنظم يحقق كل المتطلبات السابقة، مع واجهة جميلة وتجربة استخدام سلسة، واهتم بجودة الكود ونظافته وكأن المشروع سيتم تسليمه كتاسك تقني لشركة.

يجب أن يكون الناتج النهائي قابلًا للتشغيل مباشرة بعد:

```bash
flutter pub get
flutter run
```

\---

## ملاحظة ختامية

لا تركز فقط على أن التطبيق يعمل، بل اجعل المشروع يظهر أنك تفهم:

* State Management باستخدام Cubit.
* Repository Pattern.
* Local Database باستخدام Sqflite.
* API Integration باستخدام Dio.
* Persistent Favorites.
* Error Handling.
* Clean UI و Responsive Design.

