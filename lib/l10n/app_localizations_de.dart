// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get additem => 'Artikel hinzufügen';

  @override
  String get removeitem => 'Artikel entfernen';

  @override
  String get settlement => 'Abwicklung';

  @override
  String get createclient => 'Kunde erstellen';

  @override
  String get viewinventory => 'Inventar anzeigen';

  @override
  String get manageclients => 'Kunden verwalten';

  @override
  String get viewinputs => 'Eingänge anzeigen';

  @override
  String get viewoutputs => 'Ausgänge anzeigen';

  @override
  String get viewsettlements => 'Abwicklungen anzeigen';

  @override
  String get addnewitems => 'Neue Artikel zum Inventar hinzufügen';

  @override
  String get removeitems => 'Artikel aus dem Inventar entfernen';

  @override
  String get settlementitems => 'Abwicklung für Artikel';

  @override
  String get inventoryManagementSystem => 'Inventarverwaltungssystem';

  @override
  String get showStorage => 'Lager anzeigen';

  @override
  String get showAllOrders => 'Alle Bestellungen anzeigen';

  @override
  String get showAllInputs => 'Alle Eingänge anzeigen';

  @override
  String get showAllClients => 'Alle Kunden anzeigen';

  @override
  String get showAllSettlements => 'Alle Abwicklungen anzeigen';

  @override
  String get showInventory => 'Inventar anzeigen';

  @override
  String get logoutFromStoreflow => 'Abmelden';

  @override
  String get areYouSureLogout => 'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get loggingOut => 'Abmeldung läuft...';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get allOutputs => 'Alle Ausgänge';

  @override
  String get allInputs => 'Alle Eingänge';

  @override
  String get allClients => 'Alle Kunden';

  @override
  String get allSettlements => 'Alle Abwicklungen';

  @override
  String get allInventory => 'Gesamtes Inventar';

  @override
  String get allOrders => 'Alle Bestellungen';

  @override
  String get type => 'Typ';

  @override
  String get noa => 'Nummer';

  @override
  String get client => 'Kunde';

  @override
  String get item => 'Artikel';

  @override
  String get quantity => 'Menge';

  @override
  String get add => 'Hinzufügen';

  @override
  String get production => 'Produktion';

  @override
  String get returnitem => 'Rückgabe';

  @override
  String get addedItems => 'Hinzugefügte Artikel';

  @override
  String get items => 'Artikel';

  @override
  String get send => 'Senden';

  @override
  String get oneormoreitem => 'Artikel ist bereits in der Liste';

  @override
  String get sender => 'Absender';

  @override
  String get adjustmentQuantity => 'Menge anpassen (+/-)';

  @override
  String get addToSettlement => 'Zur Abwicklung hinzufügen';

  @override
  String get settlementSummary => 'Abwicklungszusammenfassung';

  @override
  String get totalAdjustment => 'Gesamtanpassung';

  @override
  String get reason => 'Grund / Notizen (optional)';

  @override
  String get submitSettlement => 'Abwicklung abschicken';

  @override
  String get selectItem => 'Artikel auswählen';

  @override
  String get adjustment => 'Anpassung';

  @override
  String get action => 'Aktion';

  @override
  String get inventorySettlement => 'Inventarabwicklung';

  @override
  String get pleaseSelectItemAndQty => 'Bitte wählen Sie einen Artikel und geben Sie die angepasste Menge ein.';

  @override
  String get pleaseEnterValidQty => 'Bitte geben Sie eine gültige Menge ein (nicht Null).';

  @override
  String get itemAlreadyInSettlement => 'Artikel ist bereits in der Liste.';

  @override
  String get youMustAdjustAtLeastTwoItems => 'Sie müssen mindestens zwei Artikel anpassen.';

  @override
  String get totalAdjustmentMustBeZero => 'Die Gesamtanpassung muss Null sein. Aktueller Gesamtbetrag: \$totalAdjustment';

  @override
  String get inventorySettlementRecordedSuccessfully => 'Inventarabwicklung erfolgreich aufgezeichnet.';

  @override
  String adjustmentQuantityExceedsStock(Object adjustmentQuantity, Object qtn) {
    return 'Die angepasste Menge ($adjustmentQuantity) übersteigt den verfügbaren Bestand ($qtn).';
  }

  @override
  String get createNewClient => 'Neuen Kunden erstellen';

  @override
  String get clientName => 'Kundenname';

  @override
  String get address => 'Adresse';

  @override
  String get phone => 'Telefon';

  @override
  String get clientUrl => 'Kunden-URL (optional)';

  @override
  String get saveClient => 'Kunden speichern';

  @override
  String get pleaseEnterClientName => 'Bitte geben Sie den Kundennamen ein';

  @override
  String get enterClientAddress => 'Kundenadresse eingeben';

  @override
  String get enterClientPhone => 'Kundentelefonnummer eingeben (optional)';

  @override
  String get enterClientUrl => 'Kunden-URL eingeben';

  @override
  String get clientCreatedSuccessfully => 'Kunde erfolgreich erstellt!';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get areYouSureYouWantToDeleteThisItem => 'Sind Sie sicher, dass Sie diesen Artikel löschen möchten?';

  @override
  String get errorDeletingItem => 'Fehler beim Löschen des Artikels';

  @override
  String get noItemsInTheStore => 'Keine Artikel im Lager';

  @override
  String get addNewItemsToStart => 'Fügen Sie neue Artikel hinzu, um zu beginnen';

  @override
  String get name => 'Name';

  @override
  String get qty => 'Menge';

  @override
  String get box => 'Box';

  @override
  String get delete => 'Löschen';

  @override
  String get itemDeletedSuccessfully => 'Artikel erfolgreich gelöscht';

  @override
  String get store => 'Lager';

  @override
  String get editItems => 'Artikel bearbeiten';

  @override
  String get createInventory => 'Inventar erstellen';

  @override
  String get inventoryCreatedSuccessfully => 'Inventar erfolgreich erstellt';

  @override
  String get errorCreatingInventory => 'Fehler beim Erstellen des Inventars';

  @override
  String get tryAdjustingYourSearchCriteria => 'Versuchen Sie, Ihre Suchkriterien anzupassen';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get errorSearchingByDate => 'Fehler bei der Suche nach Datum';

  @override
  String get errorSearchingByInvoiceNumber => 'Fehler bei der Suche nach Rechnungsnummer';

  @override
  String get allInput => 'Alle Eingänge';

  @override
  String get noInputsFound => 'Keine Eingänge gefunden';

  @override
  String get loadingInputs => 'Eingänge werden geladen...';

  @override
  String get allOutput => 'Alle Ausgänge';

  @override
  String get noOutputsFound => 'Keine Ausgänge gefunden';

  @override
  String get loadingOutputs => 'Ausgänge werden geladen...';

  @override
  String get deleteOrder => 'Bestellung löschen';

  @override
  String get areYouSureYouWantToDeleteThisOrderRecord => 'Sind Sie sicher, dass Sie diese Bestellung löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get failedToDeleteOrder => 'Bestellung konnte nicht gelöscht werden';

  @override
  String get orderDeletedSuccessfully => 'Bestellung erfolgreich gelöscht';

  @override
  String get order => 'Bestellung';

  @override
  String get loadingClients => 'Kunden werden geladen...';

  @override
  String get deleteClient => 'Kunde löschen';

  @override
  String get areYouSureYouWantToDeleteThisClient => 'Sind Sie sicher, dass Sie diesen Kunden löschen möchten?';

  @override
  String get clientRecords => 'Kundenaufzeichnungen';

  @override
  String get records => 'Aufzeichnungen';

  @override
  String get actions => 'Aktionen';

  @override
  String get prev => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get page => 'Seite';

  @override
  String get deleteInput => 'Eingang löschen';

  @override
  String get areYouSureYouWantToDeleteThisInputRecord => 'Sind Sie sicher, dass Sie diesen Eingang löschen möchten?';

  @override
  String get inputDeletedSuccessfully => 'Eingang erfolgreich gelöscht';

  @override
  String get loadingSettlements => 'Abwicklungen werden geladen...';

  @override
  String get noSettlementsFound => 'Keine Abwicklungen gefunden';

  @override
  String get createNewSettlementToSeeItHere => 'Erstellen Sie eine neue Abwicklung, um sie hier zu sehen.';

  @override
  String get confirmDeletion => 'Löschen bestätigen';

  @override
  String get thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure => 'Dadurch wird die Abwicklung dauerhaft gelöscht und die Artikelmengen in Ihrem Inventar zurückgesetzt. Sind Sie sicher?';

  @override
  String get failedToLoadDetails => 'Details konnten nicht geladen werden.';

  @override
  String get couldNotLoadSettlementDetails => 'Abwicklungsdetails konnten nicht geladen werden.';

  @override
  String get adjustedItems => 'Angepasste Artikel';

  @override
  String get reasonNotes => 'Grund / Notizen:';

  @override
  String get inventoryRec => 'Inventuraufzeichnung';

  @override
  String get topordered => 'Meistbestellte Artikel';

  @override
  String get soldout => 'Ausverkaufte Produkte';

  @override
  String get outofstock => 'Nicht vorrätig';

  @override
  String get appTitle => 'StoreFlow';

  @override
  String get menu => 'Menü';

  @override
  String get language => 'Sprache';

  @override
  String get arabic => 'Arabisch';

  @override
  String get english => 'Englisch';

  @override
  String get french => 'Französisch';

  @override
  String get german => 'Deutsch';

  @override
  String get welcome => 'Willkommen';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get inventory => 'Inventar';

  @override
  String get clients => 'Kunden';

  @override
  String get inputs => 'Eingänge';

  @override
  String get outputs => 'Ausgänge';

  @override
  String get settlements => 'Abwicklungen';

  @override
  String get addItems => 'Produkte hinzufügen';

  @override
  String get removeItems => 'Produkte entfernen';

  @override
  String get storage => 'Lager';

  @override
  String get logout => 'Abmelden';

  @override
  String get login => 'Anmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get invalidCredentials => 'Ungültige E-Mail oder Passwort';

  @override
  String get welcomeMessage => 'Willkommen bei StoreFlow';

  @override
  String get totalItems => 'Gesamte Produkte';

  @override
  String get totalClients => 'Gesamte Kunden';

  @override
  String get totalInputs => 'Gesamte Eingänge';

  @override
  String get totalOutputs => 'Gesamte Ausgänge';

  @override
  String get quickActions => 'Schnelle Aktionen';

  @override
  String get addNewItem => 'Neues Produkt hinzufügen';

  @override
  String get removeItem => 'Produkt entfernen';

  @override
  String get viewInventory => 'Inventar anzeigen';

  @override
  String get manageClients => 'Kunden verwalten';

  @override
  String get viewInputs => 'Eingänge anzeigen';

  @override
  String get viewOutputs => 'Ausgänge anzeigen';

  @override
  String get viewSettlements => 'Abwicklungen anzeigen';

  @override
  String get itemName => 'Produktname';

  @override
  String get itemQuantity => 'Menge';

  @override
  String get itemPrice => 'Preis';

  @override
  String get itemCategory => 'Kategorie';

  @override
  String get itemDescription => 'Beschreibung';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get search => 'Suchen';

  @override
  String get filter => 'Filtern';

  @override
  String get sort => 'Sortieren';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Uhrzeit';

  @override
  String get status => 'Status';

  @override
  String get details => 'Details';

  @override
  String get back => 'Zurück';

  @override
  String get previous => 'Zurück';

  @override
  String get submit => 'Absenden';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get info => 'Info';

  @override
  String get loading => 'Laden...';

  @override
  String get noData => 'Keine Daten verfügbar';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get close => 'Schließen';

  @override
  String get open => 'Öffnen';

  @override
  String get create => 'Erstellen';

  @override
  String get update => 'Aktualisieren';

  @override
  String get remove => 'Entfernen';

  @override
  String get select => 'Auswählen';

  @override
  String get choose => 'Wählen';

  @override
  String get all => 'Alle';

  @override
  String get to => 'bis';

  @override
  String get pleaseFillAllFields => 'Bitte füllen Sie alle Felder aus';

  @override
  String get itemCreatedSuccess => 'Produkt erfolgreich erstellt';

  @override
  String get itemCreateError => 'Fehler beim Erstellen des Produkts';

  @override
  String get updateItem => 'Produkt aktualisieren';

  @override
  String get itemUpdatedSuccess => 'Produkt erfolgreich aktualisiert';

  @override
  String get itemUpdateError => 'Fehler beim Aktualisieren des Produkts';

  @override
  String get errorLoadingData => 'Fehler beim Laden der Daten';

  @override
  String areYouSureDeleteItem(Object item) {
    return 'Sind Sie sicher, dass Sie \"$item\" löschen möchten?';
  }

  @override
  String get pleaseSelectItem => 'Bitte wählen Sie ein Produkt zur Aktualisierung aus';

  @override
  String get itemDeletedSuccess => 'Produkt erfolgreich gelöscht';

  @override
  String get itemDeleteError => 'Fehler beim Löschen des Produkts';

  @override
  String get itemsRemovedSuccess => 'Produkte erfolgreich entfernt';

  @override
  String get errorSavingData => 'Fehler beim Speichern der Daten';

  @override
  String get pleaseSelectAtLeastOne => 'Bitte wählen Sie mindestens einen Artikel aus und geben Sie die Menge ein';

  @override
  String get alreadyInList => 'Ein oder mehrere Artikel sind bereits in der Liste';

  @override
  String get enterValidQty => 'Bitte geben Sie eine gültige Menge ein (nicht Null)';

  @override
  String get alreadyInSettlement => 'Dieser Artikel ist bereits in der Abwicklung';

  @override
  String qtyExceedsStock(Object adjustmentQuantity, Object stock) {
    return 'Die angepasste Menge ($adjustmentQuantity) übersteigt den verfügbaren Bestand ($stock)';
  }

  @override
  String get mustAdjustTwoItems => 'Sie müssen mindestens zwei Artikel anpassen';

  @override
  String totalAdjustmentZero(Object totalAdjustment) {
    return 'Die Gesamtanpassung muss Null sein. Aktueller Gesamtbetrag: $totalAdjustment';
  }

  @override
  String get inventorySettlementSuccess => 'Inventarabwicklung erfolgreich aufgezeichnet';

  @override
  String errorOccurred(Object error) {
    return 'Ein Fehler ist aufgetreten: $error';
  }

  @override
  String get boxQuantity => 'Menge in der Box';

  @override
  String get newName => 'Neuer Name';

  @override
  String get newQuantity => 'Neue Menge';
}
