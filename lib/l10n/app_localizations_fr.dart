// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get additem => 'Ajouter des articles';

  @override
  String get removeitem => 'Supprimer des articles';

  @override
  String get settlement => 'Règlement';

  @override
  String get createclient => 'Créer un client';

  @override
  String get viewinventory => 'Voir l\'inventaire';

  @override
  String get manageclients => 'Gérer les clients';

  @override
  String get viewinputs => 'Voir les entrées';

  @override
  String get viewoutputs => 'Voir les sorties';

  @override
  String get viewsettlements => 'Voir les règlements';

  @override
  String get addnewitems => 'Ajouter de nouveaux articles à l\'inventaire';

  @override
  String get removeitems => 'Supprimer des articles de l\'inventaire';

  @override
  String get settlementitems => 'Règlement des articles';

  @override
  String get inventoryManagementSystem => 'Système de gestion d\'inventaire';

  @override
  String get showStorage => 'Afficher le stockage';

  @override
  String get showAllOrders => 'Afficher toutes les commandes';

  @override
  String get showAllInputs => 'Afficher toutes les entrées';

  @override
  String get showAllClients => 'Afficher tous les clients';

  @override
  String get showAllSettlements => 'Afficher tous les règlements';

  @override
  String get showInventory => 'Afficher l\'inventaire';

  @override
  String get logoutFromStoreflow => 'Se déconnecter';

  @override
  String get areYouSureLogout => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get loggingOut => 'Déconnexion en cours...';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get allOutputs => 'Toutes les sorties';

  @override
  String get allInputs => 'Toutes les entrées';

  @override
  String get allClients => 'Tous les clients';

  @override
  String get allSettlements => 'Tous les règlements';

  @override
  String get allInventory => 'Tout l\'inventaire';

  @override
  String get allOrders => 'Toutes les commandes';

  @override
  String get type => 'Type';

  @override
  String get noa => 'Numéro';

  @override
  String get client => 'Client';

  @override
  String get item => 'Article';

  @override
  String get quantity => 'Quantité';

  @override
  String get add => 'Ajouter';

  @override
  String get production => 'Production';

  @override
  String get returnitem => 'Retour';

  @override
  String get addedItems => 'Articles ajoutés';

  @override
  String get items => 'Articles';

  @override
  String get send => 'Envoyer';

  @override
  String get oneormoreitem => 'L\'article existe déjà dans la liste';

  @override
  String get sender => 'Expéditeur';

  @override
  String get adjustmentQuantity => 'Ajuster la quantité (+/-)';

  @override
  String get addToSettlement => 'Ajouter au règlement';

  @override
  String get settlementSummary => 'Résumé du règlement';

  @override
  String get totalAdjustment => 'Ajustement total';

  @override
  String get reason => 'Raison / Notes (optionnel)';

  @override
  String get submitSettlement => 'Soumettre le règlement';

  @override
  String get selectItem => 'Sélectionner un article';

  @override
  String get adjustment => 'Ajustement';

  @override
  String get action => 'Action';

  @override
  String get inventorySettlement => 'Règlement d\'inventaire';

  @override
  String get pleaseSelectItemAndQty => 'Veuillez sélectionner un article et saisir la quantité ajustée.';

  @override
  String get pleaseEnterValidQty => 'Veuillez saisir une quantité valide non nulle.';

  @override
  String get itemAlreadyInSettlement => 'L\'article existe déjà dans la liste.';

  @override
  String get youMustAdjustAtLeastTwoItems => 'Vous devez ajuster au moins deux articles.';

  @override
  String get totalAdjustmentMustBeZero => 'L\'ajustement total doit être zéro. Total actuel : \$totalAdjustment';

  @override
  String get inventorySettlementRecordedSuccessfully => 'Règlement d\'inventaire enregistré avec succès.';

  @override
  String adjustmentQuantityExceedsStock(Object adjustmentQuantity, Object qtn) {
    return 'La quantité ajustée ($adjustmentQuantity) dépasse le stock disponible ($qtn).';
  }

  @override
  String get createNewClient => 'Créer un nouveau client';

  @override
  String get clientName => 'Nom du client';

  @override
  String get address => 'Adresse';

  @override
  String get phone => 'Téléphone';

  @override
  String get clientUrl => 'URL du client (optionnel)';

  @override
  String get saveClient => 'Enregistrer le client';

  @override
  String get pleaseEnterClientName => 'Veuillez saisir le nom du client';

  @override
  String get enterClientAddress => 'Saisir l\'adresse du client';

  @override
  String get enterClientPhone => 'Saisir le numéro de téléphone du client (optionnel)';

  @override
  String get enterClientUrl => 'Saisir l\'URL du client';

  @override
  String get clientCreatedSuccessfully => 'Client créé avec succès !';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get areYouSureYouWantToDeleteThisItem => 'Êtes-vous sûr de vouloir supprimer cet article ?';

  @override
  String get errorDeletingItem => 'Erreur lors de la suppression de l\'article';

  @override
  String get noItemsInTheStore => 'Aucun article dans le magasin';

  @override
  String get addNewItemsToStart => 'Ajouter de nouveaux articles pour commencer';

  @override
  String get name => 'Nom';

  @override
  String get qty => 'Quantité';

  @override
  String get box => 'Boîte';

  @override
  String get delete => 'Supprimer';

  @override
  String get itemDeletedSuccessfully => 'Article supprimé avec succès';

  @override
  String get store => 'Magasin';

  @override
  String get editItems => 'Modifier les articles';

  @override
  String get createInventory => 'Créer un inventaire';

  @override
  String get inventoryCreatedSuccessfully => 'Inventaire créé avec succès';

  @override
  String get errorCreatingInventory => 'Erreur lors de la création de l\'inventaire';

  @override
  String get tryAdjustingYourSearchCriteria => 'Essayez d\'ajuster vos critères de recherche';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get errorSearchingByDate => 'Erreur lors de la recherche par date';

  @override
  String get errorSearchingByInvoiceNumber => 'Erreur lors de la recherche par numéro de facture';

  @override
  String get allInput => 'Toutes les entrées';

  @override
  String get noInputsFound => 'Aucune entrée trouvée';

  @override
  String get loadingInputs => 'Chargement des entrées...';

  @override
  String get allOutput => 'Toutes les sorties';

  @override
  String get noOutputsFound => 'Aucune sortie trouvée';

  @override
  String get loadingOutputs => 'Chargement des sorties...';

  @override
  String get deleteOrder => 'Supprimer la commande';

  @override
  String get areYouSureYouWantToDeleteThisOrderRecord => 'Êtes-vous sûr de vouloir supprimer cette commande ? Cette action est irréversible.';

  @override
  String get failedToDeleteOrder => 'Échec de la suppression de la commande';

  @override
  String get orderDeletedSuccessfully => 'Commande supprimée avec succès';

  @override
  String get order => 'Commande';

  @override
  String get loadingClients => 'Chargement des clients...';

  @override
  String get deleteClient => 'Supprimer le client';

  @override
  String get areYouSureYouWantToDeleteThisClient => 'Êtes-vous sûr de vouloir supprimer ce client ?';

  @override
  String get clientRecords => 'Dossiers clients';

  @override
  String get records => 'Dossiers';

  @override
  String get actions => 'Actions';

  @override
  String get prev => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get page => 'Page';

  @override
  String get deleteInput => 'Supprimer l\'entrée';

  @override
  String get areYouSureYouWantToDeleteThisInputRecord => 'Êtes-vous sûr de vouloir supprimer cette entrée ?';

  @override
  String get inputDeletedSuccessfully => 'Entrée supprimée avec succès';

  @override
  String get loadingSettlements => 'Chargement des règlements...';

  @override
  String get noSettlementsFound => 'Aucun règlement trouvé';

  @override
  String get createNewSettlementToSeeItHere => 'Créez un nouveau règlement pour le voir ici.';

  @override
  String get confirmDeletion => 'Confirmer la suppression';

  @override
  String get thisWillPermanentlyDeleteTheSettlementAndRevertTheItemQuantitiesInYourInventoryAreYouSure => 'Cela supprimera définitivement le règlement et rétablira les quantités d\'articles dans votre inventaire. Êtes-vous sûr ?';

  @override
  String get failedToLoadDetails => 'Échec du chargement des détails.';

  @override
  String get couldNotLoadSettlementDetails => 'Impossible de charger les détails du règlement.';

  @override
  String get adjustedItems => 'Articles ajustés';

  @override
  String get reasonNotes => 'Raison / Notes :';

  @override
  String get inventoryRec => 'Enregistrement d\'inventaire';

  @override
  String get topordered => 'Articles les plus commandés';

  @override
  String get soldout => 'Produits vendus';

  @override
  String get outofstock => 'En rupture de stock';

  @override
  String get appTitle => 'StoreFlow';

  @override
  String get menu => 'Menu';

  @override
  String get language => 'Langue';

  @override
  String get arabic => 'Arabe';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get german => 'Allemand';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get inventory => 'Inventaire';

  @override
  String get clients => 'Clients';

  @override
  String get inputs => 'Entrées';

  @override
  String get outputs => 'Sorties';

  @override
  String get settlements => 'Règlements';

  @override
  String get addItems => 'Ajouter des produits';

  @override
  String get removeItems => 'Supprimer des produits';

  @override
  String get storage => 'Stockage';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get login => 'Se connecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginButton => 'Connexion';

  @override
  String get invalidCredentials => 'E-mail ou mot de passe incorrect';

  @override
  String get welcomeMessage => 'Bienvenue sur StoreFlow';

  @override
  String get totalItems => 'Total des produits';

  @override
  String get totalClients => 'Total des clients';

  @override
  String get totalInputs => 'Total des entrées';

  @override
  String get totalOutputs => 'Total des sorties';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get addNewItem => 'Ajouter un nouveau produit';

  @override
  String get removeItem => 'Supprimer un produit';

  @override
  String get viewInventory => 'Voir l\'inventaire';

  @override
  String get manageClients => 'Gérer les clients';

  @override
  String get viewInputs => 'Voir les entrées';

  @override
  String get viewOutputs => 'Voir les sorties';

  @override
  String get viewSettlements => 'Voir les règlements';

  @override
  String get itemName => 'Nom du produit';

  @override
  String get itemQuantity => 'Quantité';

  @override
  String get itemPrice => 'Prix';

  @override
  String get itemCategory => 'Catégorie';

  @override
  String get itemDescription => 'Description';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get status => 'Statut';

  @override
  String get details => 'Détails';

  @override
  String get back => 'Retour';

  @override
  String get previous => 'Précédent';

  @override
  String get submit => 'Soumettre';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Information';

  @override
  String get loading => 'Chargement...';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get refresh => 'Actualiser';

  @override
  String get close => 'Fermer';

  @override
  String get open => 'Ouvrir';

  @override
  String get create => 'Créer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get remove => 'Supprimer';

  @override
  String get select => 'Sélectionner';

  @override
  String get choose => 'Choisir';

  @override
  String get all => 'Tous';

  @override
  String get to => 'à';

  @override
  String get pleaseFillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get itemCreatedSuccess => 'Produit créé avec succès';

  @override
  String get itemCreateError => 'Erreur lors de la création du produit';

  @override
  String get updateItem => 'Mettre à jour le produit';

  @override
  String get itemUpdatedSuccess => 'Produit mis à jour avec succès';

  @override
  String get itemUpdateError => 'Erreur lors de la mise à jour du produit';

  @override
  String get errorLoadingData => 'Erreur lors du chargement des données';

  @override
  String areYouSureDeleteItem(Object item) {
    return 'Êtes-vous sûr de vouloir supprimer \"$item\" ?';
  }

  @override
  String get pleaseSelectItem => 'Veuillez sélectionner un produit à mettre à jour';

  @override
  String get itemDeletedSuccess => 'Produit supprimé avec succès';

  @override
  String get itemDeleteError => 'Erreur lors de la suppression du produit';

  @override
  String get itemsRemovedSuccess => 'Produits supprimés avec succès';

  @override
  String get errorSavingData => 'Erreur lors de l\'enregistrement des données';

  @override
  String get pleaseSelectAtLeastOne => 'Veuillez sélectionner au moins un article et remplir la quantité';

  @override
  String get alreadyInList => 'Un ou plusieurs articles existent déjà dans la liste';

  @override
  String get enterValidQty => 'Veuillez saisir une quantité valide non nulle';

  @override
  String get alreadyInSettlement => 'Cet article existe déjà dans le règlement';

  @override
  String qtyExceedsStock(Object adjustmentQuantity, Object stock) {
    return 'La quantité ajustée ($adjustmentQuantity) dépasse le stock disponible ($stock)';
  }

  @override
  String get mustAdjustTwoItems => 'Vous devez ajuster au moins deux articles';

  @override
  String totalAdjustmentZero(Object totalAdjustment) {
    return 'L\'ajustement total doit être zéro. Total actuel : $totalAdjustment';
  }

  @override
  String get inventorySettlementSuccess => 'Règlement d\'inventaire enregistré avec succès';

  @override
  String errorOccurred(Object error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String get boxQuantity => 'Quantité en boîte';

  @override
  String get newName => 'Nouveau nom';

  @override
  String get newQuantity => 'Nouvelle quantité';
}
