// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get additem => 'اضافة العناصر';

  @override
  String get removeitem => 'ازالة العناصر';

  @override
  String get settlement => 'التسوية';

  @override
  String get createclient => 'إنشاء عميل';

  @override
  String get viewinventory => 'عرض المخزون';

  @override
  String get manageclients => 'إدارة العملاء';

  @override
  String get viewinputs => 'عرض المدخلات';

  @override
  String get viewoutputs => 'عرض المخرجات';

  @override
  String get viewsettlements => 'عرض التسويات';

  @override
  String get addnewitems => 'إضافة العناصر الجديدة إلى المخزون';

  @override
  String get removeitems => 'إزالة العناصر من المخزون';

  @override
  String get settlementitems => 'التسوية للعناصر';

  @override
  String get inventoryManagementSystem => 'نظام إدارة المخزون';

  @override
  String get showStorage => 'عرض التخزين';

  @override
  String get showAllOrders => 'عرض جميع الطلبات';

  @override
  String get showAllInputs => 'عرض جميع المدخلات';

  @override
  String get showAllClients => 'عرض جميع العملاء';

  @override
  String get showAllSettlements => 'عرض جميع التسويات';

  @override
  String get showInventory => 'عرض المخزون';

  @override
  String get logoutFromStoreflow => 'تسجيل الخروج ';

  @override
  String get areYouSureLogout => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get loggingOut => 'جاري تسجيل الخروج...';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get allOutputs => 'جميع المخرجات';

  @override
  String get allInputs => 'جميع المدخلات';

  @override
  String get allClients => 'جميع العملاء';

  @override
  String get allSettlements => 'جميع التسويات';

  @override
  String get allInventory => 'جميع المخزون';

  @override
  String get allOrders => 'جميع الطلبات';

  @override
  String get type => 'النوع';

  @override
  String get noa => 'الرقم الأول';

  @override
  String get client => 'العميل';

  @override
  String get item => 'العنصر';

  @override
  String get quantity => 'الكمية';

  @override
  String get add => 'اضافة';

  @override
  String get production => 'الإنتاج';

  @override
  String get returnitem => 'مرتجع';

  @override
  String get addedItems => 'العناصر المضافة';

  @override
  String get items => 'العناصر';

  @override
  String get send => 'إرسال';

  @override
  String get oneormoreitem => 'العنصر موجود بالفعل بالقائمة';

  @override
  String get sender => 'المرسل';

  @override
  String get adjustmentQuantity => 'تعديل الكمية (+/-)';

  @override
  String get addToSettlement => 'إضافة إلى التسوية';

  @override
  String get settlementSummary => 'ملخص التسوية';

  @override
  String get totalAdjustment => 'التعديل الإجمالي';

  @override
  String get reason => 'السبب / الملاحظات (اختياري)';

  @override
  String get submitSettlement => 'إرسال التسوية';

  @override
  String get selectItem => 'اختر منتج';

  @override
  String get adjustment => 'تعديل';

  @override
  String get action => 'الإجراء';

  @override
  String get inventorySettlement => 'تسوية المخزون';

  @override
  String get pleaseSelectItemAndQty => 'الرجاء اختيار عنصر وإدخال الكمية';

  @override
  String get pleaseEnterValidQty => 'يرجى إدخال كمية صالحة غير صفرية.';

  @override
  String get itemAlreadyInSettlement => 'العنصر موجود بالفعل بالقائمة.';

  @override
  String get youMustAdjustAtLeastTwoItems => 'يجب أن تعدل على الأقل عنصرين.';

  @override
  String get totalAdjustmentMustBeZero => 'يجب أن يكون التعديل الإجمالي صفر. المجموع الحالي: \$totalAdjustment';

  @override
  String get inventorySettlementRecordedSuccessfully => 'تم تسجيل التسوية المخزنية بنجاح.';

  @override
  String adjustmentQuantityExceedsStock(Object adjustmentQuantity, Object qtn) {
    return 'الكمية المعدلة ($adjustmentQuantity) تتجاوز المخزون المتاح ($qtn).';
  }

  @override
  String get createNewClient => 'إنشاء عميل جديد';

  @override
  String get clientName => 'اسم العميل';

  @override
  String get address => 'العنوان';

  @override
  String get phone => 'الهاتف';

  @override
  String get clientUrl => 'رابط العميل (اختياري)';

  @override
  String get saveClient => 'حفظ العميل';

  @override
  String get pleaseEnterClientName => 'يرجى إدخال اسم العميل';

  @override
  String get enterClientAddress => 'أدخل عنوان العميل';

  @override
  String get enterClientPhone => 'أدخل رقم هاتف العميل (اختياري)';

  @override
  String get enterClientUrl => 'أدخل رابط العميل';

  @override
  String get clientCreatedSuccessfully => 'تم إنشاء العميل بنجاح!';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get areYouSureYouWantToDeleteThisItem => 'هل أنت متأكد من حذف هذا العنصر؟';

  @override
  String get errorDeletingItem => 'خطأ في حذف العنصر';

  @override
  String get noItemsInTheStore => 'لا يوجد عناصر في المخزن';

  @override
  String get addNewItemsToStart => 'إضافة عناصر جديدة للبدء';

  @override
  String get name => 'الاسم';

  @override
  String get qty => 'الكمية';

  @override
  String get box => 'العلبة';

  @override
  String get delete => 'حذف';

  @override
  String get itemDeletedSuccessfully => 'تم حذف العنصر بنجاح';

  @override
  String get store => 'المخزن';

  @override
  String get editItems => 'تعديل العناصر';

  @override
  String get createInventory => 'إنشاء المخزون';

  @override
  String get inventoryCreatedSuccessfully => 'تم إنشاء المخزون بنجاح';

  @override
  String get errorCreatingInventory => 'خطأ في إنشاء المخزون';

  @override
  String get tryAdjustingYourSearchCriteria => 'حاول تعديل معايير البحث';

  @override
  String get networkError => 'حدث خطأ في الشبكة';

  @override
  String get errorSearchingByDate => 'خطأ في البحث بالتاريخ';

  @override
  String get errorSearchingByInvoiceNumber => 'خطأ في البحث برقم الفاتورة';

  @override
  String get allInput => 'جميع المدخلات';

  @override
  String get noInputsFound => 'لا يوجد مدخلات';

  @override
  String get loadingInputs => 'جاري تحميل المدخلات...';

  @override
  String get allOutput => 'جميع المخرجات';

  @override
  String get noOutputsFound => 'لا يوجد مخرجات';

  @override
  String get loadingOutputs => 'جاري تحميل المخرجات...';

  @override
  String get deleteOrder => 'حذف الطلب';

  @override
  String get areYouSureYouWantToDeleteThisOrderRecord => 'هل أنت متأكد من حذف هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get failedToDeleteOrder => 'فشل حذف الطلب';

  @override
  String get orderDeletedSuccessfully => 'تم حذف الطلب بنجاح';

  @override
  String get order => 'الطلب';

  @override
  String get loadingClients => 'جاري تحميل العملاء...';

  @override
  String get deleteClient => 'حذف العميل';

  @override
  String get areYouSureYouWantToDeleteThisClient => 'هل أنت متأكد من حذف هذا العميل؟';

  @override
  String get clientRecords => 'سجلات العميل';

  @override
  String get records => 'سجلات';

  @override
  String get actions => 'الإجراءات';

  @override
  String get prev => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get page => 'الصفحة';

  @override
  String get deleteInput => 'حذف المدخل';

  @override
  String get areYouSureYouWantToDeleteThisInputRecord => 'هل أنت متأكد من حذف هذا المدخل؟';

  @override
  String get inputDeletedSuccessfully => 'تم حذف المدخل بنجاح';

  @override
  String get loadingSettlements => 'جاري تحميل التسويات...';

  @override
  String get noSettlementsFound => 'لا يوجد تسويات';

  @override
  String get createNewSettlementToSeeItHere => 'إنشاء تسوية جديدة لرؤيتها هنا.';

  @override
  String get confirmDeletion => 'تأكيد الحذف';

  @override
  String get thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure => 'هل أنت متأكد من حذف هذه التسوية وإعادة الكميات المعدلة للعناصر في المخزون؟';

  @override
  String get failedToLoadDetails => 'فشل تحميل التفاصيل.';

  @override
  String get couldNotLoadSettlementDetails => 'فشل تحميل تفاصيل التسوية.';

  @override
  String get adjustedItems => 'العناصر المعدلة';

  @override
  String get reasonNotes => 'السبب / الملاحظات:';

  @override
  String get inventoryRec => 'تسجيلات الجرد';

  @override
  String get topordered => 'العناصر الأكثر طلبًا';

  @override
  String get soldout => 'المنتجات المباعة';

  @override
  String get outofstock => 'نفذ من المخزن';

  @override
  String get appTitle => 'ستور فلو';

  @override
  String get menu => 'القائمة';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get french => 'الفرنسية';

  @override
  String get german => 'الألمانية';

  @override
  String get welcome => 'مرحباً';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get inventory => 'المخزون';

  @override
  String get clients => 'العملاء';

  @override
  String get inputs => 'المدخلات';

  @override
  String get outputs => 'المخرجات';

  @override
  String get settlements => 'التسويات';

  @override
  String get addItems => 'إضافة منتجات';

  @override
  String get removeItems => 'إزالة منتجات';

  @override
  String get storage => 'التخزين';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginButton => 'دخول';

  @override
  String get invalidCredentials => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get welcomeMessage => 'مرحباً بك في ستور فلو';

  @override
  String get totalItems => 'إجمالي المنتجات';

  @override
  String get totalClients => 'إجمالي العملاء';

  @override
  String get totalInputs => 'إجمالي المدخلات';

  @override
  String get totalOutputs => 'إجمالي المخرجات';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get addNewItem => 'إضافة منتج جديد';

  @override
  String get removeItem => 'إزالة منتج';

  @override
  String get viewInventory => 'عرض المخزون';

  @override
  String get manageClients => 'إدارة العملاء';

  @override
  String get viewInputs => 'عرض المدخلات';

  @override
  String get viewOutputs => 'عرض المخرجات';

  @override
  String get viewSettlements => 'عرض التسويات';

  @override
  String get itemName => 'اسم المنتج';

  @override
  String get itemQuantity => 'الكمية';

  @override
  String get itemPrice => 'السعر';

  @override
  String get itemCategory => 'الفئة';

  @override
  String get itemDescription => 'الوصف';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get sort => 'ترتيب';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get status => 'الحالة';

  @override
  String get details => 'التفاصيل';

  @override
  String get back => 'رجوع';

  @override
  String get previous => 'السابق';

  @override
  String get submit => 'إرسال';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get ok => 'موافق';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get refresh => 'تحديث';

  @override
  String get close => 'إغلاق';

  @override
  String get open => 'فتح';

  @override
  String get create => 'إنشاء';

  @override
  String get update => 'تحديث';

  @override
  String get remove => 'إزالة';

  @override
  String get select => 'اختيار';

  @override
  String get choose => 'اختر';

  @override
  String get all => 'الكل';

  @override
  String get to => 'إلى';

  @override
  String get pleaseFillAllFields => 'الرجاء تعبئة جميع الحقول';

  @override
  String get itemCreatedSuccess => 'تم إنشاء المنتج بنجاح';

  @override
  String get itemCreateError => 'حدث خطأ أثناء إنشاء المنتج';

  @override
  String get updateItem => 'تحديث المنتج';

  @override
  String get itemUpdatedSuccess => 'تم تحديث المنتج بنجاح';

  @override
  String get itemUpdateError => 'حدث خطأ أثناء تحديث المنتج';

  @override
  String get errorLoadingData => 'حدث خطأ أثناء تحميل البيانات';

  @override
  String areYouSureDeleteItem(Object item) {
    return 'هل أنت متأكد من حذف \"$item\"؟';
  }

  @override
  String get pleaseSelectItem => 'الرجاء اختيار منتج للتحديث';

  @override
  String get itemDeletedSuccess => 'تم حذف المنتج بنجاح';

  @override
  String get itemDeleteError => 'حدث خطأ أثناء حذف المنتج';

  @override
  String get itemsRemovedSuccess => 'تم إزالة المنتجات بنجاح';

  @override
  String get errorSavingData => 'حدث خطأ أثناء حفظ البيانات';

  @override
  String get pleaseSelectAtLeastOne => 'الرجاء اختيار عنصر واحد على الأقل وملء الكمية';

  @override
  String get alreadyInList => 'عنصر أو أكثر موجود بالفعل في القائمة';

  @override
  String get enterValidQty => 'الرجاء إدخال كمية صحيحة غير صفرية';

  @override
  String get alreadyInSettlement => 'هذا العنصر موجود بالفعل في التسوية';

  @override
  String qtyExceedsStock(Object adjustmentQuantity, Object stock) {
    return 'كمية التعديل ($adjustmentQuantity) تتجاوز المخزون المتاح ($stock)';
  }

  @override
  String get mustAdjustTwoItems => 'يجب تعديل عنصرين على الأقل';

  @override
  String totalAdjustmentZero(Object totalAdjustment) {
    return 'يجب أن يكون إجمالي التعديل صفرًا. الإجمالي الحالي: $totalAdjustment';
  }

  @override
  String get inventorySettlementSuccess => 'تم تسجيل تسوية المخزون بنجاح';

  @override
  String errorOccurred(Object error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get boxQuantity => 'الكمية في الصندوق';

  @override
  String get newName => 'اسم جديد';

  @override
  String get newQuantity => 'كمية جديدة';
}
