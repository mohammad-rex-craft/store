// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get additem => 'Add Items';

  @override
  String get removeitem => 'Remove Items';

  @override
  String get settlement => 'Settlement';

  @override
  String get createclient => 'Create Client';

  @override
  String get viewinventory => 'View Inventory';

  @override
  String get manageclients => 'Manage Clients';

  @override
  String get viewinputs => 'View Inputs';

  @override
  String get viewoutputs => 'View Outputs';

  @override
  String get viewsettlements => 'View Settlements';

  @override
  String get addnewitems => 'Add New Items to Inventory';

  @override
  String get removeitems => 'Remove Items from Inventory';

  @override
  String get settlementitems => 'Settlement for Items';

  @override
  String get inventoryManagementSystem => 'Inventory Management System';

  @override
  String get showStorage => 'Show Storage';

  @override
  String get showAllOrders => 'Show All Orders';

  @override
  String get showAllInputs => 'Show All Inputs';

  @override
  String get showAllClients => 'Show All Clients';

  @override
  String get showAllSettlements => 'Show All Settlements';

  @override
  String get showInventory => 'Show Inventory';

  @override
  String get logoutFromStoreflow => 'Logout';

  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get allOutputs => 'All Outputs';

  @override
  String get allInputs => 'All Inputs';

  @override
  String get allClients => 'All Clients';

  @override
  String get allSettlements => 'All Settlements';

  @override
  String get allInventory => 'All Inventory';

  @override
  String get allOrders => 'All Orders';

  @override
  String get type => 'Type';

  @override
  String get noa => 'Number';

  @override
  String get client => 'Client';

  @override
  String get item => 'Item';

  @override
  String get quantity => 'Quantity';

  @override
  String get add => 'Add';

  @override
  String get production => 'Production';

  @override
  String get returnitem => 'Return';

  @override
  String get addedItems => 'Added Items';

  @override
  String get items => 'Items';

  @override
  String get send => 'Send';

  @override
  String get oneormoreitem => 'Item already exists in the list';

  @override
  String get sender => 'Sender';

  @override
  String get adjustmentQuantity => 'Adjust Quantity (+/-)';

  @override
  String get addToSettlement => 'Add to Settlement';

  @override
  String get settlementSummary => 'Settlement Summary';

  @override
  String get totalAdjustment => 'Total Adjustment';

  @override
  String get reason => 'Reason / Notes (optional)';

  @override
  String get submitSettlement => 'Submit Settlement';

  @override
  String get selectItem => 'Select Item';

  @override
  String get adjustment => 'Adjustment';

  @override
  String get action => 'Action';

  @override
  String get inventorySettlement => 'Inventory Settlement';

  @override
  String get pleaseSelectItemAndQty => 'Please select an item and enter the adjusted quantity.';

  @override
  String get pleaseEnterValidQty => 'Please enter a valid non-zero quantity.';

  @override
  String get itemAlreadyInSettlement => 'Item already exists in the list.';

  @override
  String get youMustAdjustAtLeastTwoItems => 'You must adjust at least two items.';

  @override
  String get totalAdjustmentMustBeZero => 'Total adjustment must be zero. Current total: \$totalAdjustment';

  @override
  String get inventorySettlementRecordedSuccessfully => 'Inventory settlement recorded successfully.';

  @override
  String adjustmentQuantityExceedsStock(Object adjustmentQuantity, Object qtn) {
    return 'Adjusted quantity ($adjustmentQuantity) exceeds available stock ($qtn).';
  }

  @override
  String get createNewClient => 'Create New Client';

  @override
  String get clientName => 'Client Name';

  @override
  String get address => 'Address';

  @override
  String get phone => 'Phone';

  @override
  String get clientUrl => 'Client URL (optional)';

  @override
  String get saveClient => 'Save Client';

  @override
  String get pleaseEnterClientName => 'Please enter client name';

  @override
  String get enterClientAddress => 'Enter client address';

  @override
  String get enterClientPhone => 'Enter client phone (optional)';

  @override
  String get enterClientUrl => 'Enter client URL';

  @override
  String get clientCreatedSuccessfully => 'Client created successfully!';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get areYouSureYouWantToDeleteThisItem => 'Are you sure you want to delete this item?';

  @override
  String get errorDeletingItem => 'Error deleting item';

  @override
  String get noItemsInTheStore => 'No items in the store';

  @override
  String get addNewItemsToStart => 'Add new items to start';

  @override
  String get name => 'Name';

  @override
  String get qty => 'Quantity';

  @override
  String get box => 'Box';

  @override
  String get delete => 'Delete';

  @override
  String get itemDeletedSuccessfully => 'Item deleted successfully';

  @override
  String get store => 'Store';

  @override
  String get editItems => 'Edit Items';

  @override
  String get createInventory => 'Create Inventory';

  @override
  String get inventoryCreatedSuccessfully => 'Inventory created successfully';

  @override
  String get errorCreatingInventory => 'Error creating inventory';

  @override
  String get tryAdjustingYourSearchCriteria => 'Try adjusting your search criteria';

  @override
  String get networkError => 'Network error';

  @override
  String get errorSearchingByDate => 'Error searching by date';

  @override
  String get errorSearchingByInvoiceNumber => 'Error searching by invoice number';

  @override
  String get allInput => 'All Inputs';

  @override
  String get noInputsFound => 'No inputs found';

  @override
  String get loadingInputs => 'Loading inputs...';

  @override
  String get allOutput => 'All Outputs';

  @override
  String get noOutputsFound => 'No outputs found';

  @override
  String get loadingOutputs => 'Loading outputs...';

  @override
  String get deleteOrder => 'Delete Order';

  @override
  String get areYouSureYouWantToDeleteThisOrderRecord => 'Are you sure you want to delete this order? This action cannot be undone.';

  @override
  String get failedToDeleteOrder => 'Failed to delete order';

  @override
  String get orderDeletedSuccessfully => 'Order deleted successfully';

  @override
  String get order => 'Order';

  @override
  String get loadingClients => 'Loading clients...';

  @override
  String get deleteClient => 'Delete Client';

  @override
  String get areYouSureYouWantToDeleteThisClient => 'Are you sure you want to delete this client?';

  @override
  String get clientRecords => 'Client Records';

  @override
  String get records => 'Records';

  @override
  String get actions => 'Actions';

  @override
  String get prev => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get page => 'Page';

  @override
  String get deleteInput => 'Delete Input';

  @override
  String get areYouSureYouWantToDeleteThisInputRecord => 'Are you sure you want to delete this input?';

  @override
  String get inputDeletedSuccessfully => 'Input deleted successfully';

  @override
  String get loadingSettlements => 'Loading settlements...';

  @override
  String get noSettlementsFound => 'No settlements found';

  @override
  String get createNewSettlementToSeeItHere => 'Create a new settlement to see it here.';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String get thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure => 'This will permanently delete the settlement and revert the adjusted item quantities in your inventory. Are you sure?';

  @override
  String get failedToLoadDetails => 'Failed to load details.';

  @override
  String get couldNotLoadSettlementDetails => 'Could not load settlement details.';

  @override
  String get adjustedItems => 'Adjusted Items';

  @override
  String get reasonNotes => 'Reason / Notes:';

  @override
  String get inventoryRec => 'Inventory Records';

  @override
  String get topordered => 'Top Ordered Items';

  @override
  String get soldout => 'Sold Out Products';

  @override
  String get outofstock => 'Out of Stock';

  @override
  String get appTitle => 'StoreFlow';

  @override
  String get menu => 'Menu';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get german => 'German';

  @override
  String get welcome => 'Welcome';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get inventory => 'Inventory';

  @override
  String get clients => 'Clients';

  @override
  String get inputs => 'Inputs';

  @override
  String get outputs => 'Outputs';

  @override
  String get settlements => 'Settlements';

  @override
  String get addItems => 'Add Products';

  @override
  String get removeItems => 'Remove Products';

  @override
  String get storage => 'Storage';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get welcomeMessage => 'Welcome to StoreFlow';

  @override
  String get totalItems => 'Total Products';

  @override
  String get totalClients => 'Total Clients';

  @override
  String get totalInputs => 'Total Inputs';

  @override
  String get totalOutputs => 'Total Outputs';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addNewItem => 'Add New Product';

  @override
  String get removeItem => 'Remove Product';

  @override
  String get viewInventory => 'View Inventory';

  @override
  String get manageClients => 'Manage Clients';

  @override
  String get viewInputs => 'View Inputs';

  @override
  String get viewOutputs => 'View Outputs';

  @override
  String get viewSettlements => 'View Settlements';

  @override
  String get itemName => 'Product Name';

  @override
  String get itemQuantity => 'Quantity';

  @override
  String get itemPrice => 'Price';

  @override
  String get itemCategory => 'Category';

  @override
  String get itemDescription => 'Description';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get status => 'Status';

  @override
  String get details => 'Details';

  @override
  String get back => 'Back';

  @override
  String get previous => 'Previous';

  @override
  String get submit => 'Submit';

  @override
  String get reset => 'Reset';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get refresh => 'Refresh';

  @override
  String get close => 'Close';

  @override
  String get open => 'Open';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get remove => 'Remove';

  @override
  String get select => 'Select';

  @override
  String get choose => 'Choose';

  @override
  String get all => 'All';

  @override
  String get to => 'to';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get itemCreatedSuccess => 'Product created successfully';

  @override
  String get itemCreateError => 'Error creating product';

  @override
  String get updateItem => 'Update Product';

  @override
  String get itemUpdatedSuccess => 'Product updated successfully';

  @override
  String get itemUpdateError => 'Error updating product';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String areYouSureDeleteItem(Object item) {
    return 'Are you sure you want to delete \"$item\"?';
  }

  @override
  String get pleaseSelectItem => 'Please select a product to update';

  @override
  String get itemDeletedSuccess => 'Product deleted successfully';

  @override
  String get itemDeleteError => 'Error deleting product';

  @override
  String get itemsRemovedSuccess => 'Products removed successfully';

  @override
  String get errorSavingData => 'Error saving data';

  @override
  String get pleaseSelectAtLeastOne => 'Please select at least one item and fill the quantity';

  @override
  String get alreadyInList => 'One or more items already exist in the list';

  @override
  String get enterValidQty => 'Please enter a valid non-zero quantity';

  @override
  String get alreadyInSettlement => 'This item is already in the settlement';

  @override
  String qtyExceedsStock(Object adjustmentQuantity, Object stock) {
    return 'Adjusted quantity ($adjustmentQuantity) exceeds available stock ($stock)';
  }

  @override
  String get mustAdjustTwoItems => 'You must adjust at least two items';

  @override
  String totalAdjustmentZero(Object totalAdjustment) {
    return 'Total adjustment must be zero. Current total: $totalAdjustment';
  }

  @override
  String get inventorySettlementSuccess => 'Inventory settlement recorded successfully';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get boxQuantity => 'Box Quantity';

  @override
  String get newName => 'New Name';

  @override
  String get newQuantity => 'New Quantity';
}
