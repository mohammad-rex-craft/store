import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<Object>> localizationsDelegates = <LocalizationsDelegate<Object>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @additem.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get additem;

  /// No description provided for @removeitem.
  ///
  /// In en, this message translates to:
  /// **'Remove Items'**
  String get removeitem;

  /// No description provided for @settlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get settlement;

  /// No description provided for @createclient.
  ///
  /// In en, this message translates to:
  /// **'Create Client'**
  String get createclient;

  /// No description provided for @viewinventory.
  ///
  /// In en, this message translates to:
  /// **'View Inventory'**
  String get viewinventory;

  /// No description provided for @manageclients.
  ///
  /// In en, this message translates to:
  /// **'Manage Clients'**
  String get manageclients;

  /// No description provided for @viewinputs.
  ///
  /// In en, this message translates to:
  /// **'View Inputs'**
  String get viewinputs;

  /// No description provided for @viewoutputs.
  ///
  /// In en, this message translates to:
  /// **'View Outputs'**
  String get viewoutputs;

  /// No description provided for @viewsettlements.
  ///
  /// In en, this message translates to:
  /// **'View Settlements'**
  String get viewsettlements;

  /// No description provided for @addnewitems.
  ///
  /// In en, this message translates to:
  /// **'Add New Items to Inventory'**
  String get addnewitems;

  /// No description provided for @removeitems.
  ///
  /// In en, this message translates to:
  /// **'Remove Items from Inventory'**
  String get removeitems;

  /// No description provided for @settlementitems.
  ///
  /// In en, this message translates to:
  /// **'Settlement for Items'**
  String get settlementitems;

  /// No description provided for @inventoryManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management System'**
  String get inventoryManagementSystem;

  /// No description provided for @showStorage.
  ///
  /// In en, this message translates to:
  /// **'Show Storage'**
  String get showStorage;

  /// No description provided for @showAllOrders.
  ///
  /// In en, this message translates to:
  /// **'Show All Orders'**
  String get showAllOrders;

  /// No description provided for @showAllInputs.
  ///
  /// In en, this message translates to:
  /// **'Show All Inputs'**
  String get showAllInputs;

  /// No description provided for @showAllClients.
  ///
  /// In en, this message translates to:
  /// **'Show All Clients'**
  String get showAllClients;

  /// No description provided for @showAllSettlements.
  ///
  /// In en, this message translates to:
  /// **'Show All Settlements'**
  String get showAllSettlements;

  /// No description provided for @showInventory.
  ///
  /// In en, this message translates to:
  /// **'Show Inventory'**
  String get showInventory;

  /// No description provided for @logoutFromStoreflow.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutFromStoreflow;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @allOutputs.
  ///
  /// In en, this message translates to:
  /// **'All Outputs'**
  String get allOutputs;

  /// No description provided for @allInputs.
  ///
  /// In en, this message translates to:
  /// **'All Inputs'**
  String get allInputs;

  /// No description provided for @allClients.
  ///
  /// In en, this message translates to:
  /// **'All Clients'**
  String get allClients;

  /// No description provided for @allSettlements.
  ///
  /// In en, this message translates to:
  /// **'All Settlements'**
  String get allSettlements;

  /// No description provided for @allInventory.
  ///
  /// In en, this message translates to:
  /// **'All Inventory'**
  String get allInventory;

  /// No description provided for @allOrders.
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get allOrders;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @noa.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get noa;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @returnitem.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnitem;

  /// No description provided for @addedItems.
  ///
  /// In en, this message translates to:
  /// **'Added Items'**
  String get addedItems;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @oneormoreitem.
  ///
  /// In en, this message translates to:
  /// **'Item already exists in the list'**
  String get oneormoreitem;

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get sender;

  /// No description provided for @adjustmentQuantity.
  ///
  /// In en, this message translates to:
  /// **'Adjust Quantity (+/-)'**
  String get adjustmentQuantity;

  /// No description provided for @addToSettlement.
  ///
  /// In en, this message translates to:
  /// **'Add to Settlement'**
  String get addToSettlement;

  /// No description provided for @settlementSummary.
  ///
  /// In en, this message translates to:
  /// **'Settlement Summary'**
  String get settlementSummary;

  /// No description provided for @totalAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Total Adjustment'**
  String get totalAdjustment;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason / Notes (optional)'**
  String get reason;

  /// No description provided for @submitSettlement.
  ///
  /// In en, this message translates to:
  /// **'Submit Settlement'**
  String get submitSettlement;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItem;

  /// No description provided for @adjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get adjustment;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @inventorySettlement.
  ///
  /// In en, this message translates to:
  /// **'Inventory Settlement'**
  String get inventorySettlement;

  /// No description provided for @pleaseSelectItemAndQty.
  ///
  /// In en, this message translates to:
  /// **'Please select an item and enter the adjusted quantity.'**
  String get pleaseSelectItemAndQty;

  /// No description provided for @pleaseEnterValidQty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid non-zero quantity.'**
  String get pleaseEnterValidQty;

  /// No description provided for @itemAlreadyInSettlement.
  ///
  /// In en, this message translates to:
  /// **'Item already exists in the list.'**
  String get itemAlreadyInSettlement;

  /// No description provided for @youMustAdjustAtLeastTwoItems.
  ///
  /// In en, this message translates to:
  /// **'You must adjust at least two items.'**
  String get youMustAdjustAtLeastTwoItems;

  /// No description provided for @totalAdjustmentMustBeZero.
  ///
  /// In en, this message translates to:
  /// **'Total adjustment must be zero. Current total: \$totalAdjustment'**
  String get totalAdjustmentMustBeZero;

  /// No description provided for @inventorySettlementRecordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Inventory settlement recorded successfully.'**
  String get inventorySettlementRecordedSuccessfully;

  /// No description provided for @adjustmentQuantityExceedsStock.
  ///
  /// In en, this message translates to:
  /// **'Adjusted quantity ({adjustmentQuantity}) exceeds available stock ({qtn}).'**
  String adjustmentQuantityExceedsStock(Object adjustmentQuantity, Object qtn);

  /// No description provided for @createNewClient.
  ///
  /// In en, this message translates to:
  /// **'Create New Client'**
  String get createNewClient;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @clientUrl.
  ///
  /// In en, this message translates to:
  /// **'Client URL (optional)'**
  String get clientUrl;

  /// No description provided for @saveClient.
  ///
  /// In en, this message translates to:
  /// **'Save Client'**
  String get saveClient;

  /// No description provided for @pleaseEnterClientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter client name'**
  String get pleaseEnterClientName;

  /// No description provided for @enterClientAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter client address'**
  String get enterClientAddress;

  /// No description provided for @enterClientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter client phone (optional)'**
  String get enterClientPhone;

  /// No description provided for @enterClientUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter client URL'**
  String get enterClientUrl;

  /// No description provided for @clientCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Client created successfully!'**
  String get clientCreatedSuccessfully;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @areYouSureYouWantToDeleteThisItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get areYouSureYouWantToDeleteThisItem;

  /// No description provided for @errorDeletingItem.
  ///
  /// In en, this message translates to:
  /// **'Error deleting item'**
  String get errorDeletingItem;

  /// No description provided for @noItemsInTheStore.
  ///
  /// In en, this message translates to:
  /// **'No items in the store'**
  String get noItemsInTheStore;

  /// No description provided for @addNewItemsToStart.
  ///
  /// In en, this message translates to:
  /// **'Add new items to start'**
  String get addNewItemsToStart;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get qty;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @itemDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item deleted successfully'**
  String get itemDeletedSuccessfully;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @editItems.
  ///
  /// In en, this message translates to:
  /// **'Edit Items'**
  String get editItems;

  /// No description provided for @createInventory.
  ///
  /// In en, this message translates to:
  /// **'Create Inventory'**
  String get createInventory;

  /// No description provided for @inventoryCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Inventory created successfully'**
  String get inventoryCreatedSuccessfully;

  /// No description provided for @errorCreatingInventory.
  ///
  /// In en, this message translates to:
  /// **'Error creating inventory'**
  String get errorCreatingInventory;

  /// No description provided for @tryAdjustingYourSearchCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingYourSearchCriteria;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @errorSearchingByDate.
  ///
  /// In en, this message translates to:
  /// **'Error searching by date'**
  String get errorSearchingByDate;

  /// No description provided for @errorSearchingByInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Error searching by invoice number'**
  String get errorSearchingByInvoiceNumber;

  /// No description provided for @allInput.
  ///
  /// In en, this message translates to:
  /// **'All Inputs'**
  String get allInput;

  /// No description provided for @noInputsFound.
  ///
  /// In en, this message translates to:
  /// **'No inputs found'**
  String get noInputsFound;

  /// No description provided for @loadingInputs.
  ///
  /// In en, this message translates to:
  /// **'Loading inputs...'**
  String get loadingInputs;

  /// No description provided for @allOutput.
  ///
  /// In en, this message translates to:
  /// **'All Outputs'**
  String get allOutput;

  /// No description provided for @noOutputsFound.
  ///
  /// In en, this message translates to:
  /// **'No outputs found'**
  String get noOutputsFound;

  /// No description provided for @loadingOutputs.
  ///
  /// In en, this message translates to:
  /// **'Loading outputs...'**
  String get loadingOutputs;

  /// No description provided for @deleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Delete Order'**
  String get deleteOrder;

  /// No description provided for @areYouSureYouWantToDeleteThisOrderRecord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this order? This action cannot be undone.'**
  String get areYouSureYouWantToDeleteThisOrderRecord;

  /// No description provided for @failedToDeleteOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete order'**
  String get failedToDeleteOrder;

  /// No description provided for @orderDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order deleted successfully'**
  String get orderDeletedSuccessfully;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @loadingClients.
  ///
  /// In en, this message translates to:
  /// **'Loading clients...'**
  String get loadingClients;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClient;

  /// No description provided for @areYouSureYouWantToDeleteThisClient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this client?'**
  String get areYouSureYouWantToDeleteThisClient;

  /// No description provided for @clientRecords.
  ///
  /// In en, this message translates to:
  /// **'Client Records'**
  String get clientRecords;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @deleteInput.
  ///
  /// In en, this message translates to:
  /// **'Delete Input'**
  String get deleteInput;

  /// No description provided for @areYouSureYouWantToDeleteThisInputRecord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this input?'**
  String get areYouSureYouWantToDeleteThisInputRecord;

  /// No description provided for @inputDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Input deleted successfully'**
  String get inputDeletedSuccessfully;

  /// No description provided for @loadingSettlements.
  ///
  /// In en, this message translates to:
  /// **'Loading settlements...'**
  String get loadingSettlements;

  /// No description provided for @noSettlementsFound.
  ///
  /// In en, this message translates to:
  /// **'No settlements found'**
  String get noSettlementsFound;

  /// No description provided for @createNewSettlementToSeeItHere.
  ///
  /// In en, this message translates to:
  /// **'Create a new settlement to see it here.'**
  String get createNewSettlementToSeeItHere;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the settlement and revert the adjusted item quantities in your inventory. Are you sure?'**
  String get thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure;

  /// No description provided for @failedToLoadDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load details.'**
  String get failedToLoadDetails;

  /// No description provided for @couldNotLoadSettlementDetails.
  ///
  /// In en, this message translates to:
  /// **'Could not load settlement details.'**
  String get couldNotLoadSettlementDetails;

  /// No description provided for @adjustedItems.
  ///
  /// In en, this message translates to:
  /// **'Adjusted Items'**
  String get adjustedItems;

  /// No description provided for @reasonNotes.
  ///
  /// In en, this message translates to:
  /// **'Reason / Notes:'**
  String get reasonNotes;

  /// No description provided for @inventoryRec.
  ///
  /// In en, this message translates to:
  /// **'Inventory Records'**
  String get inventoryRec;

  /// No description provided for @topordered.
  ///
  /// In en, this message translates to:
  /// **'Top Ordered Items'**
  String get topordered;

  /// No description provided for @soldout.
  ///
  /// In en, this message translates to:
  /// **'Sold Out Products'**
  String get soldout;

  /// No description provided for @outofstock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outofstock;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'StoreFlow'**
  String get appTitle;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @inputs.
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get inputs;

  /// No description provided for @outputs.
  ///
  /// In en, this message translates to:
  /// **'Outputs'**
  String get outputs;

  /// No description provided for @settlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get settlements;

  /// No description provided for @addItems.
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get addItems;

  /// No description provided for @removeItems.
  ///
  /// In en, this message translates to:
  /// **'Remove Products'**
  String get removeItems;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to StoreFlow'**
  String get welcomeMessage;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalItems;

  /// No description provided for @totalClients.
  ///
  /// In en, this message translates to:
  /// **'Total Clients'**
  String get totalClients;

  /// No description provided for @totalInputs.
  ///
  /// In en, this message translates to:
  /// **'Total Inputs'**
  String get totalInputs;

  /// No description provided for @totalOutputs.
  ///
  /// In en, this message translates to:
  /// **'Total Outputs'**
  String get totalOutputs;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewItem;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove Product'**
  String get removeItem;

  /// No description provided for @viewInventory.
  ///
  /// In en, this message translates to:
  /// **'View Inventory'**
  String get viewInventory;

  /// No description provided for @manageClients.
  ///
  /// In en, this message translates to:
  /// **'Manage Clients'**
  String get manageClients;

  /// No description provided for @viewInputs.
  ///
  /// In en, this message translates to:
  /// **'View Inputs'**
  String get viewInputs;

  /// No description provided for @viewOutputs.
  ///
  /// In en, this message translates to:
  /// **'View Outputs'**
  String get viewOutputs;

  /// No description provided for @viewSettlements.
  ///
  /// In en, this message translates to:
  /// **'View Settlements'**
  String get viewSettlements;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get itemName;

  /// No description provided for @itemQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get itemQuantity;

  /// No description provided for @itemPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get itemPrice;

  /// No description provided for @itemCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get itemCategory;

  /// No description provided for @itemDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get itemDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @itemCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product created successfully'**
  String get itemCreatedSuccess;

  /// No description provided for @itemCreateError.
  ///
  /// In en, this message translates to:
  /// **'Error creating product'**
  String get itemCreateError;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Product'**
  String get updateItem;

  /// No description provided for @itemUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get itemUpdatedSuccess;

  /// No description provided for @itemUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating product'**
  String get itemUpdateError;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @areYouSureDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{item}\"?'**
  String areYouSureDeleteItem(Object item);

  /// No description provided for @pleaseSelectItem.
  ///
  /// In en, this message translates to:
  /// **'Please select a product to update'**
  String get pleaseSelectItem;

  /// No description provided for @itemDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get itemDeletedSuccess;

  /// No description provided for @itemDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting product'**
  String get itemDeleteError;

  /// No description provided for @itemsRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Products removed successfully'**
  String get itemsRemovedSuccess;

  /// No description provided for @errorSavingData.
  ///
  /// In en, this message translates to:
  /// **'Error saving data'**
  String get errorSavingData;

  /// No description provided for @pleaseSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one item and fill the quantity'**
  String get pleaseSelectAtLeastOne;

  /// No description provided for @alreadyInList.
  ///
  /// In en, this message translates to:
  /// **'One or more items already exist in the list'**
  String get alreadyInList;

  /// No description provided for @enterValidQty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid non-zero quantity'**
  String get enterValidQty;

  /// No description provided for @alreadyInSettlement.
  ///
  /// In en, this message translates to:
  /// **'This item is already in the settlement'**
  String get alreadyInSettlement;

  /// No description provided for @qtyExceedsStock.
  ///
  /// In en, this message translates to:
  /// **'Adjusted quantity ({adjustmentQuantity}) exceeds available stock ({stock})'**
  String qtyExceedsStock(Object adjustmentQuantity, Object stock);

  /// No description provided for @mustAdjustTwoItems.
  ///
  /// In en, this message translates to:
  /// **'You must adjust at least two items'**
  String get mustAdjustTwoItems;

  /// No description provided for @totalAdjustmentZero.
  ///
  /// In en, this message translates to:
  /// **'Total adjustment must be zero. Current total: {totalAdjustment}'**
  String totalAdjustmentZero(Object totalAdjustment);

  /// No description provided for @inventorySettlementSuccess.
  ///
  /// In en, this message translates to:
  /// **'Inventory settlement recorded successfully'**
  String get inventorySettlementSuccess;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @boxQuantity.
  ///
  /// In en, this message translates to:
  /// **'Box Quantity'**
  String get boxQuantity;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New Name'**
  String get newName;

  /// No description provided for @newQuantity.
  ///
  /// In en, this message translates to:
  /// **'New Quantity'**
  String get newQuantity;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
