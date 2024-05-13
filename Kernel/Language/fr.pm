# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2002 Bernard Choppy <choppy at imaginet.fr>
# Copyright (C) 2002 Nicolas Goralski <ngoralski at oceanet-technology.com>
# Copyright (C) 2004 Igor Genibel <igor.genibel at eds-opensource.com>
# Copyright (C) 2007 Remi Seguy <remi.seguy at laposte.net>
# Copyright (C) 2007 Massimiliano Franco <max-lists at ycom.ch>
# Copyright (C) 2004-2008 Yann Richard <ze at nbox.org>
# Copyright (C) 2009-2010,2013 Olivier Sallou <olivier.sallou at irisa.fr>
# Copyright (C) 2011-2013 Raphaël Doursenaud <rdoursenaud@gpcsolutions.fr>
# Copyright (C) 2013 Dylan Oberson <dylan.oberson@epfl.ch>
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::Language::fr;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.417504879147275;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Gestion des ACL',
        'Filter by valid state' => '',
        'Include invalid ACLs' => '',
        'Actions' => 'Actions',
        'Create New ACL' => 'Créer une nouvelle ACL',
        'Deploy ACLs' => 'Déployer les ACL',
        'Export ACLs' => 'Exporter les ACL',
        'Filter for ACLs' => 'Filtres pour les ACL',
        'Just start typing to filter...' => 'Commencez à saisir pour filtrer...',
        'Configuration Import' => 'Importation des configurations',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Vous pouvez mettre en ligne un fichier de configuration pour importer une ACL vers votre système. Ce fichier a besoin d\'être au format "yml".',
        'This field is required.' => 'Ce champ est requis.',
        'Overwrite existing ACLs?' => 'Remplacer les ACL existantes ?',
        'Upload ACL configuration' => 'Mettre en ligne la configuration des ACL',
        'Import ACL configuration(s)' => 'Importer la configuration des ACL',
        'Description' => 'Description',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Pour créer une nouvelle ACL, vous pouvez soit importer des ACL qui ont été exportés à partir d\'un autre système soit créer une nouvelle ACL.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Le changement d\'ACLs ici affecte uniquement le comportement du système, si vous déployez les ACLs par la suite. En déployant ces ACL, les nouveaux changements seront ajoutés à la configuration.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'N.B. : Cette table représente l\'ordre d’exécution des ACL. Si vous voulez changer cette ordre, veuillez changer les noms des ACL affectées.',
        'ACL name' => 'Nom de l\'ACL',
        'Comment' => 'Commentaire',
        'Validity' => 'Validité',
        'Export' => 'Exporter',
        'Copy' => 'Copier',
        'No data found.' => 'Aucunes données trouvées.',
        'No matches found.' => 'Aucun résultat trouvé.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Éditer l\'ACL %s',
        'Edit ACL' => 'Modifier l\'ACL',
        'Go to overview' => 'Aller à la vue d\'ensemble',
        'Delete ACL' => 'Supprimer l\'ACL',
        'Delete Invalid ACL' => 'Supprimer les ACL non valides',
        'Match settings' => 'Paramètres correspondants',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Etablir les critères correspondants pour cet ACL. Utiliser "Propriétés" pour faire correspondre l\'écran actuel ou "Propriétés de la BDD" pour faire correspondre les attributs de ce ticket avec celles de la BDD.',
        'Change settings' => 'Changer les paramètres',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Établir le changement souhaité si le critère correspond. Garder en tête que "Possible" est une liste blanche, "PossibleNot" est une liste noire.',
        'Check the official %sdocumentation%s.' => 'Vérifier la documentation officielle.',
        'Show or hide the content' => 'Montrer ou cacher le contenu',
        'Edit ACL Information' => 'Éditer les informations de l\'ACL',
        'Name' => 'Nom',
        'Stop after match' => 'Stopper après correspondance',
        'Edit ACL Structure' => 'Éditer la structure de l\'ACL',
        'Save ACL' => 'Sauvegarder l\'ACL',
        'Save' => 'Sauver',
        'or' => 'ou',
        'Save and finish' => 'Enregistrer et terminer',
        'Cancel' => 'Annuler',
        'Do you really want to delete this ACL?' => 'Voulez-vous vraiment supprimer cette ACL ?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Créer une nouvelle ACL en envoyant le contenu du formulaire. Après avoir créé l\'ACL, vous pourrez ajouter des éléments de configuration en mode édition.',

        # Template: AdminAbout
        'About' => 'A propos',
        'Toggle this widget' => 'Afficher ou cacher ce cadre',
        'This language is not present or enabled on the system. This text could be deleted if it is not needed anymore.' =>
            'Cette langue n\'est pas présente ou activée sur le système. Ce texte pourrait être supprimé s\'il n\'est plus nécessaire.',
        'Remove Language' => 'Supprimer la langue',
        'Text' => 'Texte',
        'Message body' => 'Corps du message',
        'This field is required and must have less than 4000 characters.' =>
            'Ce champ est requis et doit contenir moins de 4000 caractères.',
        'Remove About Language' => 'Supprimer À propos de la langue',
        'Add new language' => 'Ajouter une nouvelle langue',
        'Save Changes' => 'Enregistrer les modifications',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Gestion du calendrier',
        'Add Calendar' => 'Ajouter un calendrier',
        'Edit Calendar' => 'Modifier le calendrier',
        'Include invalid calendars' => '',
        'Calendar Overview' => 'Vue d\'ensemble calendrier',
        'Add new Calendar' => 'Ajouter un nouveau calendrier',
        'Import Appointments' => 'Importer des rendez-vous',
        'Calendar Import' => 'Import de calendrier',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Vous pouvez mettre en ligne un fichier de configuration pour importer un calendrier vers votre système. Ce fichier a besoin d\'être au format "yml".',
        'Overwrite existing entities' => 'Écraser les entités existantes',
        'Upload calendar configuration' => 'Téléverser la configuration du calendrier',
        'Import Calendar' => 'Importer un calendrier',
        'Filter for Calendars' => 'Filtres pour les calendriers',
        'Filter for calendars' => 'Filtres pour les calendriers',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Selon le groupe d\'appartenance, le système autorisera les utilisateurs à accéder au calendrier en fonction de leurs permissions.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Lecture seule : les utilisateurs peuvent voir et exporter tous les rendez-vous dans le calendrier.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Déplacer : les utilisateurs peuvent modifier les rendez-vous sans changer la sélection.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Créer : les utilisateurs peuvent créer et supprimer des rendez-vous dans le calendrier.',
        'Read/write: users can manage the calendar itself.' => 'Lecture/écriture : les utilisateurs peuvent gérer le calendrier lui-même.',
        'Group' => 'Groupe',
        'Changed' => 'Changé',
        'Created' => 'Créé',
        'Download' => 'Télécharger',
        'URL' => 'URL',
        'Export calendar' => 'Exporter le calendrier',
        'Download calendar' => 'Télécharger le calendrier',
        'Copy public calendar URL' => 'Copier l\'URL du calendrier public',
        'Calendar' => 'Calendrier',
        'Calendar name' => 'Nom du calendrier',
        'Calendar with same name already exists.' => 'Un calendrier avec un nom identique existe déjà.',
        'Color' => 'Couleur',
        'Permission group' => 'Permission du groupe',
        'Ticket Appointments' => 'Rendez-vous du ticket',
        'Rule' => 'Règle',
        'Remove this entry' => 'Supprimer cette entrée',
        'Remove' => 'Supprimer',
        'Start date' => 'Date de départ',
        'End date' => 'Date de fin',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Utiliser les options ci dessous pour affiner quels tickets de rendez vous seront automatiquement créés.',
        'Queues' => 'Files',
        'Please select a valid queue.' => 'Veuillez sélectionner une file valide.',
        'Search attributes' => 'Rechercher les attributs',
        'Add entry' => 'Ajouter une entrée',
        'Add' => 'Ajouter',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Définir des règles pour créer des rendez-vous automatiques dans ce calendrier basés sur les données du ticket.',
        'Add Rule' => 'Ajouter une règle',
        'Submit' => 'Envoyer',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Import de rendez-Vous',
        'Go back' => 'Retour',
        'Uploaded file must be in valid iCal format (.ics).' => 'le fichier téléversé doit être dans un format iCal valide (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Si le calendrier désiré n\'est pas listé ici, merci de vous assurer que vous disposez des permissions "créer".',
        'Upload' => 'Envoyer',
        'Update existing appointments?' => 'Mettre à jour les rendez-vous existants ?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Tous les rendez-vous existants dans le calendrier avec le même ID seront remplacés.',
        'Upload calendar' => 'Téléverser le calendrier',
        'Import appointments' => 'Importer les rendez-vous',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Gestion des notifications de rendez-vous',
        'Add Notification' => 'Ajouter une notification',
        'Edit Notification' => 'Editer la notification',
        'Include invalid appointment notifications' => '',
        'Include invalid appoitnment notifications' => '',
        'Export Notifications' => 'Exporter les notifications',
        'Filter for Notifications' => 'Filtre pour les notifications',
        'Filter for notifications' => 'filtre pour les notifications',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Ici vous pouvez téléverser un fichier de configuration pour importer les notifications de rendez-vous vers votre système. Le fichier doit être au format .yml comme celui exporté par le module de notification de rendez-vous.',
        'Overwrite existing notifications?' => 'Écraser les notifications existantes ?',
        'Upload Notification configuration' => 'Téléverser la configuration de notification',
        'Import Notification configuration' => 'Importer la configuration de notification',
        'List' => 'Lister',
        'Delete' => 'Supprimer',
        'Delete this notification' => 'Supprimer cette notification',
        'Show in agent preferences' => 'Montrer dans les préferences de l\'opérateur',
        'Agent preferences tooltip' => 'Infobulle des préférences de l\'opérateur',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ce message apparaîtra sur l\'écran des préférences de l\'opérateur comme une infobulle pour cette notification',
        'Events' => 'Évènements',
        'Event' => 'Évènement',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Vous pouvez choisir ici quel événement déclenchera cette notification. Un filtre de rendez-vous supplémentaire peut être appliqué ci dessous pour envoyer les rendez vous uniquement selon certains critères.',
        'Appointment Filter' => 'Filtre de rendez-vous',
        'Type' => 'Type',
        'Title' => 'Titre',
        'Location' => 'Plan',
        'Team' => 'Équipe',
        'Resource' => 'Ressource',
        'Recipients' => 'Destinataires',
        'Send to' => 'Envoyer à',
        'Send to these agents' => 'Envoyer aux agents',
        'Send to all group members (agents only)' => 'Envoyer à tous les membres du groupe (agents seulement)',
        'Send to all role members' => 'Envoyer à tous les membres du rôle',
        'Send on out of office' => 'Envoyer lorsqu\'absent du bureau',
        'Also send if the user is currently out of office.' => 'Envoyer même si l\'utilisateur est défini comme absent.',
        'Once per day' => 'Un par jour',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Notifie l\'utilisateur juste une fois par jour par un seul rendez vous en utilisant le transport désiré.',
        'Notification Methods' => 'Methodes de notification',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Voici les méthodes possible pour envoyer cette notification à chaque destinataire. Choisissez au moins une méthode ci-dessous.',
        'Enable this notification method' => 'Activer cette méthode de notification',
        'Transport' => 'Transport',
        'At least one method is needed per notification.' => 'Au moins une méthode par notification est nécessaire.',
        'Active by default in agent preferences' => 'Actif par défaut dans les préférences de l\'opérateur',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Il s\'agit de la valeur par défaut pour les agents destinataires affectés qui n\'ont pas encore fait de choix pour cette notification dans leurs préférences. Si la case est activée, la notification sera envoyée à ces agents.',
        'This feature is currently not available.' => 'Cette fonctionalité n\'est pas disponile pour l\'instant.',
        'Upgrade to %s' => 'Mettre à jour vers %s',
        'Please activate this transport in order to use it.' => 'Merci d\'activer ce transport afin de l\'utiliser.',
        'No data found' => 'Aucune donnée trouvée',
        'No notification method found.' => 'Aucune méthode de notification trouvée.',
        'Notification Text' => 'Message de notification',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Cette langue n\'est pas disponible ou activée dans le système. Cette notification peut être supprimée si celle-ci n\'est plus nécessaire.',
        'Remove Notification Language' => 'Supprimer la notification de language',
        'Subject' => 'Sujet',
        'Add new notification language' => 'Ajouter une nouvelle notification de langue',
        'Tag Reference' => 'Référence du tag',
        'Notifications are sent to an agent.' => 'Les notifications sont envoyés à un agent.',
        'You can use the following tags' => 'Vous pouvez utiliser les tags suivants',
        'To get the first 20 character of the appointment title.' => 'Pour avoir les 20 premiers caractères du titre d\'un rendez-vous.',
        'To get the appointment attribute' => 'Pour avoir l\'attribut d\'un rendez-vous',
        ' e. g.' => 'p. ex.',
        'To get the calendar attribute' => 'Pour avoir l\'attribut du calendrier',
        'Attributes of the recipient user for the notification' => 'Caractéristiques du destinataire pour les notifications',
        'Config options' => 'Options de configuration',
        'Example notification' => 'Exemple de notification',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Adresses de courriel supplémentaires pour les destinataires',
        'This field must have less then 200 characters.' => 'Ce champ doit contenir moins de 200 caractères.',
        'Article visible for customer' => 'Article visible pour le client',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Un article va être créé si la notification est envoyé au client ou à un email additionnel.',
        'Email template' => 'Modèle d\'email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Utiliser ce modèle pour générer l\'email (uniquement pour les emails au format HTML).',
        'Enable email security' => 'Activer la sécurité de l\'email',
        'Email security level' => 'Niveau de sécurité de l\'email',
        'If signing key/certificate is missing' => 'Si la clé/certificat de signature est manquant',
        'If encryption key/certificate is missing' => 'Si la clé/certificat de chiffrage est manquant',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestion des pièces jointes',
        'Add Attachment' => 'Ajouter une pièce jointe',
        'Edit Attachment' => 'Editer la pièce jointe',
        'Include invalid attachments' => '',
        'Filter for Attachments' => 'Filtres pour les pièces jointes',
        'Filter for attachments' => 'Filtres pour les pièces jointes',
        'Filename' => 'Nom de fichier',
        'Download file' => 'Télécharger le fichier',
        'Delete this attachment' => 'Supprimer la pièce jointe',
        'Do you really want to delete this attachment?' => 'Voulez-vous vraiment supprimer cette pièce jointe ? ',
        'Attachment' => 'Pièce jointe',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestion des réponses automatiques',
        'Add Auto Response' => 'Ajouter une réponse automatique',
        'Edit Auto Response' => 'Editer la réponse automatique',
        'Include invalid auto responses' => '',
        'Filter for Auto Responses' => 'Filtres pour les réponses automatiques',
        'Filter for auto responses' => 'Filtres pour les réponses automatiques',
        'Response' => 'Réponse',
        'Auto response from' => 'Réponse automatique de',
        'Reference' => 'Référence',
        'To get the first 20 character of the subject.' => 'Pour avoir les 20 premiers caractères du sujet.',
        'To get the first 5 lines of the email.' => 'Pour avoir les 5 premières lignes de l\'e-mail.',
        'To get the name of the ticket\'s customer user (if given).' => 'Pour obtenir le nom du client du ticket (si indiqué).',
        'To get the article attribute' => 'Pour avoir l\'attribut de l\'article',
        'Options of the current customer user data' => 'Options des données du client actuel',
        'Ticket owner options' => 'Options du propriétaire du ticket',
        'Ticket responsible options' => 'Options du responsable du ticket',
        'Options of the current user who requested this action' => 'Options de l\'utilisateur actuel qui a demandé cette action',
        'Options of the ticket data' => 'Options des données du ticket',
        'Options of ticket dynamic fields internal key values' => 'Options des clé internes des champs de tickets dynamique',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Options des valeurs d\'affichage des champs de tickets dynamiques, pour les champs Dropdown et Multiselect',
        'Example response' => 'Exemple de réponse',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestion des services de cloud',
        'Support Data Collector' => 'Collecteur des données de support',
        'Support data collector' => 'Collecteur des données de support',
        'Hint' => 'Conseil',
        'Currently support data is only shown in this system.' => 'Actuellement les données de support sont uniquement disponible sur ce système.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            'Il est recommandé d\'envoyer de temps en temps cette donnée à l\'équipe OTOBO dans le but d\'avoir un meilleur support.',
        'Configuration' => 'Configuration',
        'Send support data' => 'Envoyer les données de support',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            'Cela autorisera le système à envoyer des informations supplémentaires à l\'équipe OTOBO.',
        'Update' => 'Mettre à jour',
        'System Registration' => 'Enregistrement du système',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Pour permettre l\'envoi des données, enregistrez votre système à l\'équipe OTOBO or mettez à jour les informations d\'enregistrement de votre système (activez l\'option "envoi de données au support".)',
        'Register this System' => 'Enregistrer ce système',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'L\'enregistrement est désactivé pour votre système. Veuillez vérifier votre configuration.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            'L\'enregistrement du système est un service de l\'équipe OTOBO, qui donne beaucoup d\'avantages !',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'L\'utilisation des services de cloud OTOBO nécessitent d\'enregistrer le système.',
        'Register this system' => 'Enregistrer ce système',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Ici vous pouvez configurer les services de cloud qui communiquent de manière sécurisé avec %s.',
        'Available Cloud Services' => 'Service cloud disponible',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Journal d’événements des notifications',
        'Time Range' => 'Intervalle de temps',
        'Show only communication logs created in specific time range.' =>
            'Afficher uniquement les logs de communication créés pendant un intervalle de temps spécifique.',
        'Filter for Communications' => 'Filtre pour les Communications',
        'Filter for communications' => 'Filtre pour les communications',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Dans cet écran vous pouvez voir une synthèse des communications entrantes et sortantes.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Vous pouvez modifier l\'ordre des colonnes en cliquant sur l\'entête de la colonne.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Si vous cliquez sur les différentes entrées, vous serez redirigé vers un écran plus détaillé concernant le message.',
        'Status for: %s' => 'Statut pour : %s',
        'Failing accounts' => 'Comptes en erreurs',
        'Some account problems' => 'Problèmes de compte',
        'No account problems' => 'Aucun problème de compte',
        'No account activity' => 'Aucune activité de compte',
        'Number of accounts with problems: %s' => 'Nombre de comptes avec problèmes : %s',
        'Number of accounts with warnings: %s' => 'Nombre de comptes avec alertes : %s',
        'Failing communications' => 'communications impossibles',
        'No communication problems' => 'Aucun problème de communication',
        'No communication logs' => 'Aucun journal de comunication',
        'Number of reported problems: %s' => 'Nombre de problèmes reportés : %s',
        'Open communications' => 'Communications ouvertes',
        'No active communications' => 'Aucune communication active',
        'Number of open communications: %s' => 'Nombre de communication ouvertes : %s',
        'Average processing time' => 'temps moyen de chargement',
        'List of communications (%s)' => 'Liste des communications (%s)',
        'Settings' => 'Paramètres',
        'Entries per page' => 'Entrées par page',
        'No communications found.' => 'Aucune communication trouvée.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'statut du compte',
        'Back to overview' => 'Revenir à l\'aperçu',
        'Filter for Accounts' => 'Filtre pour les Comptes',
        'Filter for accounts' => 'Filtre pour les comptes',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Vus pouvez changer le tri et l\'ordre des colonnes en cliquant sur son titre.',
        'Account status for: %s' => 'Statut du compte pour : %s',
        'Status' => 'Statut',
        'Account' => 'Compte',
        'Edit' => 'Éditer',
        'No accounts found.' => 'Aucun compte trouvé.',
        'Communication Log Details (%s)' => 'Détail du journal des communications (%s)',
        'Direction' => 'Direction',
        'Start Time' => 'Temps de début',
        'End Time' => 'Temps de fin',
        'No communication log entries found.' => 'Aucune entrée dans le journal de communication trouvée. ',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Durée',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Priorité',
        'Module' => 'Module',
        'Information' => 'Information',
        'No log entries found.' => 'Aucune entrée de journal trouvée.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Vue détaillée pour %s la communication a démarrée à %s',
        'Filter for Log Entries' => 'Filtre pour les entrées de log',
        'Filter for log entries' => 'Filtre pour les journaux de log',
        'Show only entries with specific priority and higher:' => 'Afficher uniquement les entrées avec des priorités spécifiques ou importantes :',
        'Communication Log Overview (%s)' => 'Synthèse du journal des communications (%s)',
        'No communication objects found.' => 'Aucun objet de communication trouvé.',
        'Communication Log Details' => 'Détails des journaux de communication',
        'Please select an entry from the list.' => 'Merci de sélectionner une entrée dans la liste',

        # Template: AdminContactWD
        'Contact with data management' => 'Contact avec la gestion des données',
        'Contact with data' => 'Contacter avec des données',
        'Add contact with data' => 'Ajouter un contact avec des données',
        'Edit contact with data' => 'Editer les données du contact',
        'Back to search results' => 'Retour aux résultats de la recherche',
        'Select' => 'Sélectionner',
        'Search' => 'Rechercher',
        'Wildcards like \'*\' are allowed.' => 'Les caractères génériques tels que \'*\ sont autorisés',
        'Please enter a search term to look for contacts with data.' => 'Veuillez entrer un terme de recherche pour rechercher des contacts avec des données.',
        'Valid' => 'Valide',

        # Template: AdminCustomerAccept
        'Privacy Policy Management' => 'Gestion de la politique de confidentialité',
        'Privacy Policy' => 'Politique de confidentialité',
        'Remove PrivacyPolicy Language' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestion des clients',
        'Add Customer' => 'Ajouter un client',
        'Edit Customer' => 'Editer client',
        'Include invalid customer companies' => '',
        'List (only %s shown - more available)' => 'Liste (seulement %s affichés - plus disponible)',
        'total' => 'total',
        'Please enter a search term to look for customers.' => 'Merci d\'entrer un motif pour rechercher des clients',
        'Customer ID' => 'ID Client',
        'Please note' => 'Merci de mettre une note',
        'This customer backend is read only!' => 'Ce backend client est en lecture seule !',

        # Template: AdminCustomerDashboardInfoTile
        'Customer Info' => '',
        'Customer Info Management' => '',
        'Create new info tile entry' => '',
        'Filter for info tile entries' => '',
        'Create a new entry to be displayed on the info tile on the customer dashboard.' =>
            '',
        'Stop date' => '',
        'Delete info tile entry' => '',

        # Template: AdminCustomerDashboardInfoTileEdit
        'Edit customer dashboard info tile entry' => '',
        'Date invalid!' => 'Date non valide !',
        'Tile content' => '',
        'Content Body' => '',
        'Marquee content' => '',
        'Group Selection' => '',

        # Template: AdminCustomerDashboardInfoTileNew
        'Create new customer dashboard info tile entry' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Gérer les relations Client-Groupe',
        'Notice' => 'Note',
        'This feature is disabled!' => 'Cette fonctionnalité est désactivée !',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utiliser cette fonction uniquement si vous shouhaitez définir des permissions de groupe pour les clients',
        'Enable it here!' => 'Activez la ici !',
        'Edit Customer Default Groups' => 'Éditer les groupes par défault du client',
        'These groups are automatically assigned to all customers.' => 'Ces groupes sont automatiquement assignés à tous les clients',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Vous pouvez gérer ces groupes via le paramètre de configuration "CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filtre pour les Groupes',
        'Select the customer:group permissions.' => 'Selectionner les permissions client::groupe',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si rien n\'est sélectionné, alors il n\'y aura aucune permission dans ce groupe (les tickets ne seront pas accessibles au client).',
        'Search Results' => 'Résultat de recherche',
        'Customers' => 'Clients',
        'Groups' => 'Groupes',
        'Change Group Relations for Customer' => 'Modifier les Relations du Groupe pour le Client',
        'Change Customer Relations for Group' => 'Modifier les Relations du Client pour le Groupe',
        'Toggle %s Permission for all' => 'Sélectionner la Permission %s pour tous',
        'Toggle %s permission for %s' => 'Sélectionner la permission %s pour %s',
        'Customer Default Groups:' => 'Groupes par défaut du client',
        'No changes can be made to these groups.' => 'Aucun changement possible pour ces groupes',
        'ro' => 'lecture seule',
        'Read only access to the ticket in this group/queue.' => 'Accès en lecture seulement aux tickets de cette file/groupe.',
        'rw' => 'lecture/écriture',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accès complet en lecture et écriture aux tickets dans cette file/groupe.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestion des utilisateurs client',
        'Add Customer User' => 'Ajouter un utilisateur client',
        'Edit Customer User' => 'Éditer un utilisateur client',
        'Include invalid customer users' => '',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Les clients utilisateurs doivent avoir un historique client et se connecter via la page d\'identification client.',
        'List (%s total)' => 'Liste (%s au total)',
        'Username' => 'Identifiant',
        'Email' => 'E-mail',
        'Last Login' => 'Dernière connexion',
        'Login as' => 'Connecté en tant que',
        'Switch to customer' => 'Basculer vers le client',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Ce backend client est en lecture seule, mais les préférences utilisateur du client peuvent être modifiées !',
        'This field is required and needs to be a valid email address.' =>
            'Ce champ est obligatoire et doit être une adresse e-mail valide.',
        'This email address is not allowed due to the system configuration.' =>
            'Cette adresse e-mail n\'est past permise par la configuration du système.',
        'This email address failed MX check.' => 'Cette adresse e-mail n\'a pas passé la vérification MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problème DNS. Veuillez contrôler le journal d\'erreur ainsi que votre configuration.',
        'The syntax of this email address is incorrect.' => 'La syntaxe de cette adresse e-mail est incorrecte.',
        'This CustomerID is invalid.' => 'L\' IDClient est invalide.',
        'Effective Permissions for Customer User' => 'Permissions effectives pour l\'utilisateur client',
        'Group Permissions' => 'Permissions au sein des groupes',
        'This customer user has no group permissions.' => 'Cet utilisateur client n\'a pas de permission de groupe.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Le tableau ci-dessus montre les autorisations de groupe effectives pour l\'utilisateur client. La matrice prend en compte toutes les autorisations héritées (par exemple via les groupes de clients). Remarque : Le tableau ne prend pas en compte les modifications apportées à ce formulaire sans l\'avoir soumis.',
        'Customer Access' => 'Accès client',
        'Customer' => 'Client',
        'This customer user has no customer access.' => 'Cet utilisateur client n\'a pas d\'accès client.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Le tableau ci-dessus montre l\'accès client accordé à l\'utilisateur client par contexte d\'autorisation. La matrice prend en compte tous les accès hérités (par exemple via des groupes de clients). Remarque : Le tableau ne prend pas en compte les modifications apportées à ce formulaire sans le soumettre.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Gestion des relations entre utilisateurs client et clients',
        'Select the customer user:customer relations.' => 'Sélectionnez l\'utilisateur client ou un client',
        'Customer Users' => 'Utilisateurs client',
        'Change Customer Relations for Customer User' => 'Transformer le client en client utilisateur',
        'Change Customer User Relations for Customer' => 'Transformer l\'utilisateur client en client',
        'Toggle active state for all' => 'Sélectionner l\'état actif pour tous',
        'Active' => 'Actif',
        'Toggle active state for %s' => 'Sélectionner l\'état actif pour %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Gestion des relations entre utilisateurs client et groupes',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Utilisez cette fonctionnalité si vous souhaitez définir des permissions de groupe pour les utilisateurs client.',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Vous pouvez gérer ces groupes via le paramètre de configuration "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtre pour les groupes',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Éditer les services par défaut',
        'Filter for Services' => 'Filtres pour les services',
        'Filter for services' => 'Filtres pour les services',
        'Services' => 'Services',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestion des champs dynamiques',
        'Include invalid dynamic fields' => '',
        'Filter for Dynamic Fields' => 'Filtre pour les Champs Dynamiques',
        'Filter for dynamic fields' => 'Filtre pour les champs dynamiques',
        'Filter field by object type' => '',
        'Filter field by namespace' => '',
        'Add new field for object' => 'Ajouter un nouveau champ pour l\'objet',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Pour ajouter un nouveau champ, sélectionner le type de champ dans l\'un des objets de la liste. L\'objet défini la limite du champ et ne peut être modifié après la création de celui-ci.',
        'New Dynamic Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Base de données',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => 'Services Web',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'Dynamic Fields List' => 'Liste des champs dynamiques',
        'Dynamic fields per page' => 'Nombre de champs dynamiques par page',
        'Label' => 'Label',
        'Order' => 'Ordre',
        'Object' => 'Objet',
        'Copy this field' => '',
        'Delete this field' => 'Supprimer ce champ',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => '',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            '',
        'DynamicFields Import' => '',
        'DynamicFields Export' => '',
        'Dynamic Fields Screens' => '',
        'Here you can manage the dynamic fields in the respective screens.' =>
            '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Champs dynamiques',
        'Go back to overview' => 'Retour à la visualisation',
        'General' => 'Généralités',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ce champ est requis et sa valeur doit être composée de caractères alphabétiques et numériques seulement.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Le nom doit être unique et composé seulement de caractères alphabétiques et numériques.',
        'Changing this value will require manual changes in the system.' =>
            'Changer cette valeur exige également des changements manuels dans le système.',
        'This is the name to be shown on the screens where the field is active.' =>
            'L\'étiquette porte le nom qui sera affiché sur les écrans où le champ est actif.',
        'Field order' => 'Ordre du champ',
        'This field is required and must be numeric.' => 'Ce champ est requis et doit être composé de caractères numériques.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'L\'affichage sur les écrans où le champ est actif respectera l\'ordre choisi.',
        'Namespace' => 'Espace de nommage',
        'This is the namespace in which this field will be used as prefix with the name.' =>
            '',
        'Tooltip message:' => '',
        'This is the tooltip message shown inside the customer interface.' =>
            '',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Type de champ',
        'Object type' => 'Type d\'objet',
        'Internal field' => 'Champ interne',
        'This field is protected and can\'t be deleted.' => 'Ce champ est protégé et ne peut pas être supprimé',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Réglage du champ',
        'Default value' => 'Valeur par défaut',
        'This is the default value for this field.' => 'Il s\'agit de la valeur par défaut du champ',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Clé',
        'Value' => 'Valeur',
        'Remove value' => 'Retirer la valeur',
        'Add Field' => '',
        'Add value' => 'Ajouter une valeur',
        'These are the possible data attributes for contacts.' => '',
        'Mandatory fields' => '',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            '',
        'Sorted fields' => '',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            '',
        'Searchable fields' => '',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            '',
        'Translatable values' => 'Valeurs traduisibles',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Pour que le contenu des valeurs soit traduit dans la langue définie par l\'utilisateur, activez cette option.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'Vous devez traduire vous-même le contenu dans les fichiers de traduction.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Valeurs possibles',
        'Datatype' => '',
        'Filter' => 'Filtre',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Montrer le lien',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Ici vous pouvez spécifier un lien HTTP optionnel pour la valeur des champs dans les écrans de type Vue d\'ensemble et Zoom.',
        'Example' => 'Exemple',
        'You can reference the field with its own field name. You can also refer to other fields, e.g. with \'DynamicField_OtherFieldName\'.' =>
            '',
        'Link for preview' => 'Lien vers l\'aperçu',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'SID' => '',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Port',
        'Table / View' => '',
        'User' => 'Utilisateur',
        'Password' => 'Mot de Passe',
        'Identifier' => 'Identifiant',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => '',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',
        'Multiple Values' => '',
        'Activate this option to allow multiple values for this field.' =>
            '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Différence entre la date actuelle et le date affichée',
        'This field must be numeric.' => 'Ce champ doit être composé de caractères numériques',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'La différence depuis maintenant (en secondes) pour calculer la valeur par défaut du champ (ex. 3600 ou -60).',
        'Define years period' => 'Période déterminée (en années)',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Activez cette fonctionnalité afin de fixer le nombre d\'années devant être affiché (dans le futur et dans le passé) à l\'intérieur de la section « année » du champ.',
        'Years in the past' => 'années passées',
        'Years in the past to display (default: 5 years).' => 'années passées à afficher (par défaut, 5 années)',
        'Years in the future' => 'Années futures',
        'Years in the future to display (default: 5 years).' => 'Années futures à afficher (par défaut, 5 années)',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Ajouter une valeur',
        'Add empty value' => 'Ajouter une valeur sans contenu',
        'Activate this option to create an empty selectable value.' => 'Pour créer une valeur sans contenu, activer cette option.',
        'Tree View' => 'Vue hiérarchique',
        'Activate this option to display values as a tree.' => 'Activer cette option pour afficher les valeurs sous forme d\'arbre.',

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '',
        'Select the items you want to ' => '',
        'Select the desired elements and confirm the import with \'import\'.' =>
            '',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            '',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            '',
        'Toggle all available elements' => '',
        'Fields' => 'Champs',
        'Screens' => '',

        # Template: AdminDynamicFieldReference
        'Check ReferenceFilter' => '',
        'Below you can configure filters to restrict the list of referenced objects. The filters compare an attribute of the referenced object either to an attribute of the mask you are currently editing or to a fixed string.' =>
            '',
        'Object attribute' => '',
        'Select an attribute of the referenced object by which the selectable entries will be filtered.' =>
            '',
        'Invalid ReferenceFilter_ReferenceObjectAttribute' => '',
        'matches mask attribute' => '',
        'Select an attribute of the edit mask to compare the selected attribute of the referenced object against.' =>
            '',
        'matches string' => '',
        'Type a string to compare the selected attribute of the referenced object against.' =>
            '',
        'Add ReferenceFilter' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Vue d\'ensemble',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available elements' => '',
        'selected to available elements' => '',
        'Available Elements' => '',
        'Filter disabled elements' => '',
        'selected to disabled elements' => '',
        'Toggle all disabled elements' => '',
        'Disabled Elements' => '',
        'Filter assigned elements' => '',
        'selected to assigned elements' => '',
        'Toggle all assigned elements' => '',
        'Assigned Elements' => '',
        'Filter assigned required elements' => '',
        'selected to assigned required elements' => '',
        'Toggle all assigned required elements' => '',
        'Assigned Required Elements' => '',
        'Reset' => 'Remise à zéro',

        # Template: AdminDynamicFieldScript
        'Expression' => '',
        'The function which will be evaluated.' => '',
        'Requirements' => '',
        'If set, the function will only be evaluated if all chosen attributes are set.' =>
            '',
        'Preview Triggers' => '',
        'If set, the field will be recalculated upon AJAX updates in edit masks.' =>
            '',
        'Storage Triggers (Events)' => '',
        'If set, the field will be recalculated for the following events.' =>
            '',
        'Check RegEx' => 'Vérifier la RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Ici vous pouvez spécifier une expression régulière pour vérifier la valeur. L\'expression régulière va être exécutée avec les modfiicateurs xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx non valide',
        'Error Message' => 'Message d\'Erreur',
        'Add RegEx' => 'Ajouter une RegEx',

        # Template: AdminDynamicFieldSet
        'Auto Indent Code' => '',
        'Comment/Uncomment Code' => '',
        'Search & Replace' => '',
        'Select All' => '',
        'Full Screen' => '',
        'The YAML array of included dynamic fields. Syntax: \'--- [{DF: Name},...]\'' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Nombre de rangées',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Précisez la hauteur de ce champ (en nombre de lignes), présent lors de l\'édition.',
        'Number of cols' => 'Nombre de colonnes',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Précisez la largeur de ce champ (en nombre de caractères), présent lors de l\'édition.',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Modèle',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Taille',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Ce champ est requis',
        'The web service to be executed for possible values.' => '',
        'Invoker' => '',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            '',
        'Activate this option to allow multiselect on results.' => '',
        'Cache TTL' => '',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            '',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Le présent module permet aux administrateurs d\'envoyer des messages aux opérateurs, aux groupes et aux autres membres du même rôle.',
        'Create Administrative Message' => 'Création d\'un message de l\'administrateur',
        'Your message was sent to' => 'Votre message a été envoyé à',
        'From' => 'De',
        'Send message to users' => 'Envoyer un message aux utilisateurs',
        'Send message to group members' => 'Envoyer un message aux membres du groupe',
        'Group members need to have permission' => 'Préciser la permission accordée aux membres du groupe',
        'Send message to role members' => 'Envoyer message aux membres du rôle',
        'Also send to customers in groups' => 'Envoyer aussi aux clients dans les groupes',
        'Body' => 'Corps',
        'Send' => 'Envoyer',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => 'Editer la tâche',
        'Add Job' => 'Ajouter une tâche',
        'Run Job' => 'Exécuter la tâche',
        'Include invalid jobs' => '',
        'Filter for Jobs' => 'Filtre pour les tâches',
        'Filter for jobs' => 'Filtre pour les tâches',
        'Last run' => 'Dernier lancement',
        'Run Now!' => 'Lancer maintenant !',
        'Delete this task' => 'Supprimer cette tâche',
        'Run this task' => 'Exécuter cette tâche',
        'Job Settings' => 'Configuration de la tâche',
        'Job name' => 'Nom de la tâche',
        'The name you entered already exists.' => 'Le nom que vous avez entré existe déjà.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Planification d\'exécution',
        'Schedule minutes' => 'Planification Minutes',
        'Schedule hours' => 'Planification Heures',
        'Schedule days' => 'Planification Jours',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Actuellement, cet agent générique ne s\'exécutera pas automatiquement',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Pour permettre l\'exécution automatique, sélectionnez au moins une valeur dans minutes, heures et jours !',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Déclencheurs d\'évènement',
        'List of all configured events' => 'Liste de tous les événements configurés',
        'Delete this event' => 'Supprimer cet évenement',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Voulez-vous vraiment supprimer ce déclencheur d’événement?',
        'Add Event Trigger' => 'Ajouter un déclencheur d\'évènement',
        'To add a new event select the event object and event name' => 'Pour ajouter un nouvel évènement, sélectionner  le sujet de l\'évènement et son nom.',
        'Select Tickets' => 'Sélectionner des tickets',
        '(e. g. 10*5155 or 105658*)' => '(ex: 10*5155 or 105658*)',
        '(e. g. 234321)' => '(ex: 234321)',
        'Customer user ID' => 'ID du client',
        '(e. g. U5150)' => '(ex: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Recherche plein texte dans article (p. ex. "Valérie*m" ou "Eco*").',
        'To' => 'À',
        'Cc' => 'Copie ',
        'Service' => 'Service',
        'Service Level Agreement' => 'Contrat de niveau de support',
        'Queue' => 'File',
        'State' => 'État',
        'Agent' => 'Opérateur',
        'Owner' => 'Propriétaire',
        'Responsible' => 'Responsable',
        'Ticket lock' => 'Verrouillage ticket',
        'Dynamic fields' => 'Champs dynamiques',
        'Add dynamic field' => '',
        'Create times' => 'Date de création',
        'No create time settings.' => 'Pas de critère de date de création',
        'Ticket created' => 'Ticket créé',
        'Ticket created between' => 'Ticket créé entre le',
        'and' => 'et',
        'Last changed times' => 'Date du dernier changement',
        'No last changed time settings.' => 'Pas de réglage récent de l\'heure',
        'Ticket last changed' => 'Ticket modifié récemment ',
        'Ticket last changed between' => 'Dernière modification du ticket entre',
        'Change times' => 'Modification d\'heure',
        'No change time settings.' => 'Paramètrage de non modification d\'heure',
        'Ticket changed' => 'Ticket modifié',
        'Ticket changed between' => 'Ticket modifié entre',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Dates de clotûre',
        'No close time settings.' => 'Pas de paramètre de temps de fermeture',
        'Ticket closed' => 'Ticket fermé',
        'Ticket closed between' => 'Ticket fermé entre',
        'Pending times' => 'Dates de mise en attente',
        'No pending time settings.' => 'pas de critère de date d\'échéance',
        'Ticket pending time reached' => 'Date d\'échéance atteinte le',
        'Ticket pending time reached between' => 'Date d\'échéance atteinte entre le',
        'Escalation times' => 'Dates de remontée',
        'No escalation time settings.' => 'Pas de paramètres de délai de remontée',
        'Ticket escalation time reached' => 'Délai de remontée du ticket atteint',
        'Ticket escalation time reached between' => 'Délai de remontée du ticket atteint entre',
        'Escalation - first response time' => 'Remontée - Date de première réponse',
        'Ticket first response time reached' => 'Premier temps de réponse du ticket atteint',
        'Ticket first response time reached between' => 'Premier temps de réponse du ticket atteint entre',
        'Escalation - update time' => 'Remontée - Date de mise à jour',
        'Ticket update time reached' => 'Temps de mise à jour du ticket atteint',
        'Ticket update time reached between' => 'Temps de mise à jour du ticket atteint entre',
        'Escalation - solution time' => 'Remontée - Date de solution',
        'Ticket solution time reached' => 'Temps de résolution du ticket atteint',
        'Ticket solution time reached between' => 'Temps de résolution du ticket atteint entre',
        'Archive search option' => 'Option de recherche Archive',
        'Update/Add Ticket Attributes' => 'Mise à jour/ajout des attributs d\'un ticket',
        'Set new service' => 'Définir un nouveau service',
        'Set new Service Level Agreement' => 'Définir un nouveau contrat de niveau de service',
        'Set new priority' => 'Définir une nouvelle priorité',
        'Set new queue' => 'Définir une nouvelle file',
        'Set new state' => 'Définir un nouvel état',
        'Pending date' => 'Date de sortie d\'attente',
        'Set new agent' => 'Définir un nouveà l\'opérateur',
        'new owner' => 'nouveau propriétaire',
        'new responsible' => 'nouveau responsable',
        'Set new ticket lock' => 'Placer un nouveau verrou sur le ticket',
        'New customer user ID' => 'Nouvel ID utilisateur du client',
        'New customer ID' => 'Nouvel ID client',
        'New title' => 'Nouveau titre',
        'New type' => 'Nouveau type',
        'Archive selected tickets' => 'Archiver tickets sélectionnés',
        'Add Note' => 'Ajouter une note',
        'Visible for customer' => 'Visible par le client',
        'Time units' => 'Unités de temps',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Envoyer des notifications à l\'opérateur/au client sur les changements',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Cette commande sera exécuté. ARG[0] sera le numéro du ticket et ARG[1] son identifiant.',
        'Delete tickets' => 'Supprimer les tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Attention : Tous les tickets impactés seront supprimés de la base de données et ne pourront pas être restaurés !',
        'Execute Custom Module' => 'Exécuter le Module Client',
        'Param %s key' => 'Clé Param %s',
        'Param %s value' => 'Valeur Param %s',
        'Results' => 'Résultat',
        '%s Tickets affected! What do you want to do?' => '%s Tickets impactés! Que voulez vous faire?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Attention : Vous avez utilisé l\'option SUPPRIMER. Tous les tickets supprimés seront perdus !',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Affected Tickets' => 'Tickets impactés',
        'Age' => 'Âge',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Gestion des services Web de l\'interface générique',
        'Web Service Management' => 'Gestion des services Web',
        'Debugger' => 'Débogueur',
        'Go back to web service' => 'Retourner au service Web',
        'Clear' => 'Supprimer',
        'Do you really want to clear the debug log of this web service?' =>
            'Voulez-vous vraiment supprimer l\'enregistrement de débogage de ce service Web?',
        'Request List' => 'Liste de demandes',
        'Time' => 'Date et heure',
        'Communication ID' => '',
        'Remote IP' => 'Adresse IP distante',
        'Loading' => 'En cours de chargement',
        'Select a single request to see its details.' => 'Sélection une seule requête pour afficher son détail',
        'Filter by type' => 'Filtrer par type',
        'Filter from' => 'Filtrer à partir de',
        'Filter to' => 'Filtrer jusqu\'au',
        'Filter by remote IP' => 'Filtrer par adresse IP distante',
        'Limit' => 'Limite',
        'Refresh' => 'Rafraîchir',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Tous les paramètres seront perdus.',
        'General options' => 'Options générales',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Veuillez fournir un nom unique pour ce service Web.',
        'Error handling module backend' => '',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => 'Options de traitement',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => '',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => 'Code d\'erreur',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => 'Message d\'erreur',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'Voulez-vous vraiment supprimer ce demandeur?',
        'Invoker Details' => 'Détails du demandeur',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Le nom est généralement utilisé pour appeler l\'opération d\'un service Web à distance.',
        'Invoker backend' => 'Arrière-plan du demandeur',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Le module de OTOBO comprenant l\'arrière-plan du demandeur traitera les données envoyées au système distant ainsi que celles composant la réponse.',
        'Mapping for outgoing request data' => 'Mappage des données des requêtes sortantes',
        'Configure' => 'Configurer',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données du demandeur de OTOBO seront traitées lors du mappage; elles seront converties pour le système distant.',
        'Mapping for incoming response data' => 'Mappage des données composant les réponses entrantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Les données composant les réponses seront traitées lors du mappage; elles seront converties pour le demandeur de OTOBO.',
        'Asynchronous' => 'Asynchrone',
        'Condition' => 'Condition',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Les évènements configurés déclencheront le demandeur.',
        'Add Event' => 'Ajouter un événement',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Les déclencheurs d\'évènements synchrones seront traités directement lors de la requête Web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Retour à',
        'Delete all conditions' => 'Supprimer toutes les conditions',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => 'Paramètres généraux',
        'Event type' => 'Type d\'évènement',
        'Conditions' => 'Conditions',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Add a new Field' => 'Ajouter un nouveau champ',
        'Remove this Field' => 'Supprimer ce champ',
        'And can\'t be repeated on the same condition.' => '',
        'Add New Condition' => 'Ajouter une nouvelle condition',

        # Template: AdminGenericInterfaceInvokerTicket
        'General invoker data' => '',
        'Settings for outgoing request data' => '',
        'Ticket fields' => 'Champs du ticket',
        'Only the selected ticket fields will be considered for the request data.' =>
            '',
        'Article fields' => '',
        'Only the selected article fields will be considered for the request data.' =>
            '',
        'Ticket dynamic fields' => '',
        'Only the selected ticket dynamic fields will be considered for the request data.' =>
            '',
        'Article dynamic fields' => '',
        'Only the selected article dynamic fields will be considered for the request data.' =>
            '',
        'Number of articles' => '',
        'The outgoing request data will only contain the configured number of articles. If left empty, only 1 article will be sent.' =>
            '',
        'Communication channels' => '',
        'The outgoing request data will only consider articles of the selected communication channels. If left empty, articles created by all communication channels will be used.' =>
            '',
        'Customer visibility' => '',
        'The outgoing request data will only consider articles created with the selected customer visibility.' =>
            '',
        'Sender Types' => '',
        'The outgoing request data will only consider articles created by the selected sender types. If left empty, articles created by all sender types will be used.' =>
            '',
        'Mapping' => '',
        'Settings for incoming response data' => '',
        'Remote TicketID dynamic field' => '',
        'The selected ticket dynamic field is being used to store the remote TicketID.' =>
            '',
        'If left empty, the remote TicketID will not be stored, unless you define a system configuration value for this web service.' =>
            '',
        'The selected field is already in use by the Ticket dynamic fields option.' =>
            '',
        'Only the selected ticket dynamic fields are being considered for processing the incoming response data. If left empty, no dynamic field will be processed.' =>
            '',
        'Event data' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mappage simple',
        'Default rule for unmapped keys' => 'Règle par défaut pour les clés non mappées',
        'This rule will apply for all keys with no mapping rule.' => 'Cette règle sera appliquée à toutes les clés n\'ayant pas de règle de mappage.',
        'Default rule for unmapped values' => 'Règle par défaut pour les valeurs non mappées',
        'This rule will apply for all values with no mapping rule.' => 'Cette règle sera appliquée à toutes les valeurs n\'ayant pas de règle de mappage.',
        'New key map' => 'Nouvelle mappe de clé',
        'Add key mapping' => 'Ajouter un mappage de clé',
        'Mapping for Key ' => 'Mappage de clé',
        'Remove key mapping' => 'Supprimer le mappage de clé',
        'Key mapping' => 'Mappage de clé',
        'Map key' => 'Mappe de clé',
        'matching the' => 'faire correspondre le ou la',
        'to new key' => 'à la nouvelle clé',
        'Value mapping' => 'Mappage de valeurs',
        'Map value' => 'Mappe de valeur',
        'to new value' => 'à la nouvelle valeur',
        'Remove value mapping' => 'Supprimer le mappage de valeur',
        'New value map' => 'Nouvelle mappe de valeur',
        'Add value mapping' => 'Ajouter un mappage de valeur',
        'Do you really want to delete this key mapping?' => 'Voulez-vous vraiment supprimer ce mappage de clé?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Raccourcis généraux',
        'MacOS Shortcuts' => 'Raccourcis MacOS',
        'Comment/Uncomment code' => '',
        'Auto indent code' => '',
        'Jump to line' => '',
        'Autocomplete' => '',
        'Find' => 'Chercher',
        'Find next' => 'Chercher le suivant',
        'Find previous' => 'Chercher le précédent',
        'Find and replace' => 'Chercher et remplacer',
        'Exit full screen' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => 'Feuille de style XSLT',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => 'Expressions régulières',
        'Replace' => 'Remplacer',
        'Remove regex' => '',
        'Add regex' => 'Ajouter une expression régulière',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Ajouter une nouvelle opération',
        'Edit Operation' => 'Editer l\'opération',
        'Do you really want to delete this operation?' => 'Voulez-vous vraiment supprimer cette opération?',
        'Operation Details' => 'Détails de l\'opération',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Le nom est généralement utilisé pour appeler cette opération du service Web à partir d\'un système distant.',
        'Operation backend' => 'Arrière-plan des opérations',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ce module de l\'arrière-plan des opérations de OTOBO sera appelé dans le programme afin de traiter la demande, générant ainsi des donnée permettant de répondre.',
        'Mapping for incoming request data' => 'Mappage effectué pour une demande de donnée à venir',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'La réquisition de données sera traitée par mappage afin de la transformer en données lisibles par OTOBO.',
        'Mapping for outgoing response data' => 'Mappage pour les données de réponses sortantes',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Les données de réponse seront traitées par ce mappage afin de les transformer en un type de données lisibles par le système distant.',
        'Include Ticket Data' => 'Inclure les données du ticket',
        'Include ticket data in response.' => 'Inclure les données du ticket dans la réponse.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Transport Réseau',
        'Properties' => 'Propriétés',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => 'Valider les méthodes de demande pour l\'Operation',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limiter cette opération à une méthode de demande spécifique. Si aucune méthode n\'est sélectionnée, toutes les demandes seront acceptées.',
        'Maximum message length' => 'longueur maximale du message',
        'This field should be an integer number.' => 'Ce champ doit être un composé d\'un nombre entier.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '',
        'Send Keep-Alive' => 'Envoyer le Keep-Alive (conservation de la connexion)',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Point d\'extrémité',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g. https://www.otobo.de:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Authentification',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Nom d\'utilisateur devant être utilisé pour accéder au système distant.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Le mot de passe des usagers privilégiés.',
        'Kerberos User' => '',
        'Kerberos keytab file' => '',
        'The kerberos keytab file for the privileged user.' => '',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Serveur proxy',
        'URI of a proxy server to be used (if needed).' => 'Au besoin, utiliser le URI d\'un serveur proxy.',
        'e.g. http://proxy_hostname:8080' => 'par ex. http://proxy_hostname:8080',
        'Proxy User' => 'Utilisateur proxy',
        'The user name to be used to access the proxy server.' => 'Pour accéder au serveur proxy, utiliser ce nom d\'utilisateur.',
        'Proxy Password' => 'Mot de passe proxy',
        'The password for the proxy user.' => 'Le mot de passe de l\'utilisateur proxy.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Utiliser les options du protocole SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Afficher ou cacher les options SSL pour se connecter au système distant',
        'Client Certificate' => 'Certificat client',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => 'Clé du certificat client',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Le chemin complet et le nom du fichier de l\'autorité de certification qui authentifie la certification du protocole SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'par ex. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Répertoire de l\'autorité de certification (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Le chemin complet menant au répertoire de l\'autorité de certification, où les certificats sont stockés dans le système de fichiers.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'par ex. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => 'Commande par défaut',
        'The default HTTP command to use for the requests.' => 'La commande HTTP par défaut à utiliser pour les requêtes.',
        'Additional request headers (all invokers)' => '',
        'Additional request headers (invoker specific)' => '',
        'Remove all headers for this invoker' => '',
        'Headers for invoker' => '',
        'Additional response headers (all operations)' => '',
        'Additional response headers (operation specific)' => '',
        'Remove all headers for this operation' => '',
        'Headers for operation' => '',
        'Common headers' => '',
        'Header Name' => '',
        'Remove header' => '',
        'Add header' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otobo.de:8000/Webservice/Example' => '',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'séparateur d\'action du protocole SOAP (SOAPAction)',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'Identifiant uniforme de ressource (URI) pour offrir un contexte aux méthodes du protocole SOAP et réduire ainsi les ambiguïtés.',
        'e.g. urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions' =>
            '',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'indiquez ici le poids maximal (en octets) des messages du protocole SOAP que OTOBO traitera.',
        'Encoding' => 'codage',
        'The character encoding for the SOAP message contents.' => 'Le caractère codé pour le contenu du message du protocole SOAP',
        'e.g. utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'Sort options' => 'Lister options',
        'Add new first level element' => '',
        'Element' => 'Elément',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Ajouter un service Web',
        'Edit Web Service' => 'Éditer un service Web',
        'Include invalid webservices' => '',
        'Clone Web Service' => 'Cloner un service Web',
        'The name must be unique.' => 'Le nom doit être unique.',
        'Clone' => 'Cloner',
        'Export Web Service' => 'Exporter un service Web',
        'Import web service' => 'Importer un service Web',
        'Configuration File' => 'Fichier de configuration ',
        'The file must be a valid web service configuration YAML file.' =>
            'Le fichier doit être un fichier YAML de configuration de services Web valide.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Importer',
        'Configuration History' => '',
        'Delete web service' => 'Supprimer un service Web',
        'Do you really want to delete this web service?' => 'Voulez-vous vraiment supprimer ce service Web ?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices.' =>
            '',
        'Import Ready2Adopt web service' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Une fois la configuration sauvegardée, vous serez redirigé vers l\'écran de gestion des services Web de l\'interface générique, section « Ajouter ».',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si vous souhaitez accéder à l\'écran de visualisation, cliquez sur « Aller à la visualisation ».',
        'Remote system' => 'Système à distance ',
        'Provider transport' => 'Fournisseur de transport',
        'Requester transport' => 'Demandeur de transport',
        'Debug threshold' => 'Seuil de mise au point ',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'En mode « fournisseur », OTOBO offre des services Web aux systèmes à distance.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'En mode « demandeur », OTOBO utilise les services Web des systèmes à distance.',
        'Network transport' => 'Transport du réseau ',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Les opérations constituent des fonctions individuelles du système, et les systèmes à distance peuvent en faire la demande.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Les demandeurs préparent les données pour faire une demande à un service Web à distance, puis ils traitent les données de la réponse.',
        'Controller' => 'Contrôleur',
        'Inbound mapping' => 'Mappage des fonctions entrantes',
        'Outbound mapping' => 'Mappage des fonctions sortantes',
        'Delete this action' => 'Supprimer cet action',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Au moins un %s possède un contrôleur qui n\'est pas activé ou présent; veuillez vérifier l\'enregistrement du contrôleur ou supprimer le %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historique',
        'Go back to Web Service' => 'Retour au service Web',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'L\'historique permet de voir, d\'exporter ou de restaurer les anciennes versions des configurations de services Web habituels.',
        'Configuration History List' => 'Liste des historiques de configuration',
        'Version' => 'Version ',
        'Create time' => 'Date de création ',
        'Select a single configuration version to see its details.' => 'Sélectionnez une version pour voir l\'information s\'y rattachant.',
        'Export web service configuration' => 'Exporter la configuration d\'un service Web',
        'Restore web service configuration' => 'Restaurer la configuration d\'un service Web',
        'Do you really want to restore this version of the web service configuration?' =>
            'Voulez-vous vraiment restaurer cette version de la configuration du service Web ?',
        'Your current web service configuration will be overwritten.' => 'La configuration actuelle du service Web sera modifiée.',

        # Template: AdminGroup
        'Group Management' => 'Administration des groupes',
        'Add Group' => 'Ajouter un groupe',
        'Edit Group' => 'Editer Groupe',
        'Include invalid groups' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Le groupe admin permet d\'accéder à la zone d\'administration et le groupe stats à la zone de statistiques.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Créer de nouveux groupes de gestion des permissions d\'accès pour les différents groupes de opérateurs (p. ex. achats, support, ventes,...). ',
        'It\'s useful for ASP solutions. ' => 'C\'est utile pour les solutions ASP',

        # Template: AdminImportExport
        'Import/Export Management' => 'Gestion de l\'importation/exportation',
        'Add template' => 'Ajouter un modèle',
        'Create a template to import and export object information.' => 'Créer un modèle pour importer et exporter les informations d\'objet',
        'To use this module, you need to install ITSMConfigurationManagement or any other package that provides back end for objects to be imported and exported.' =>
            '',
        'Number' => 'Nombre',
        'Format' => 'Format',
        'Start Import' => 'Démarrer l\'import',
        'Start Export' => 'Démarrer l\'export',
        'Delete this template' => '',
        'Step 1 of 5 - Edit common information' => 'Étape 1 sur 5 - Éditer les information communes',
        'Name is required!' => 'Un nom est requis !',
        'Object is required!' => 'Un objet est requis !',
        'Format is required!' => 'Un format est requis !',
        'Next' => 'Suivant',
        'Step 2 of 5 - Edit object information' => 'Étape 2 sur 5 - Éditer les informations de l\'objet',
        'Back' => 'Retour',
        'Step 3 of 5 - Edit format information' => 'Étape 3 sur 5 - Éditer les informations du format',
        'is required!' => 'est requis !',
        'Step 4 of 5 - Edit mapping information' => 'Étape 4 sur 5 - Éditer les informations de mappage',
        'No map elements found.' => 'Aucun élément de mappage trouvé.',
        'Up' => 'Haut',
        'Down' => 'Bas',
        'Add Mapping Element' => 'Ajouter un élément de mappage',
        'Step 5 of 5 - Edit search information' => 'Étape 5 sur 5 - Éditer les informations de recherche',
        'Template Name' => 'Nom du Modèle',
        'Restrict export per search' => 'Restreindre l\'exportation par recherche',
        'Finish' => 'Terminer',
        'Import information' => 'Informations d\'importation',
        'Source File' => 'Fichier source',
        'Import summary for %s' => 'Importer le résumé pour %s',
        'Records' => 'Enregistrements',
        'Success' => 'Réussi',
        'Failed' => 'Echoué',
        'Duplicate names' => 'Noms en double',
        'Last processed line number of import file' => 'Numéro de la dernière ligne traitée dans le fichier d\'importation',
        'Ok' => 'Ok',
        'Do you really want to delete this template item?' => '',

        # Template: AdminLog
        'System Log' => 'Journaux du Système',
        'Here you will find log information about your system.' => 'Vous trouverez ici les informations de log sur votre système',
        'Hide this message' => 'Masquer ce message',
        'Recent Log Entries' => 'Entrées de log récentes',
        'Facility' => 'Service',
        'Message' => 'Message',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestion du compte de messagerie',
        'Add Mail Account' => 'Aouter un compte mail',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Include invalid Mail Accounts' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => 'Configuration système',
        'Host' => 'Hôte',
        'Delete account' => 'Supprimer le compte',
        'Fetch mail' => 'Parcourir mail',
        'Do you really want to delete this mail account?' => '',
        'Example: mail.example.com' => 'Exemple : mail.exemple.com',
        'IMAP Folder' => 'Dossier IMAP ',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifiez ce champ seulement si vous souhaitez avoir accès à des mails situés ailleurs que dans la boîte de réception.',
        'Trusted' => 'Vérifié',
        'Dispatching' => 'Répartition',
        'Edit Mail Account' => 'Editer compte mail',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => 'Filtres pour les éléments',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Vous pouvez ajouter des favoris en passant avec votre souris sur l\'élément à ajouter et en cliquant sur l\'icône en forme d\'étoile.',
        'Links' => '',
        'View the admin manual' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gestion de notification de ticket',
        'Include invalid notifications' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Ici vous pouvez envoyer un fichier de configuration pour importer un notification de ticket vers votre système. Ce fichier a besoin d\'être en format "yml" comme exporté par le module "Notification de ticket".',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Ici vous pouvez sélectionner un événement qui va actionner ce notification. Un filtre additionnel de ticket peut être appliqué en dessous pour envoyer uniquement un billet avec certains critères.',
        'Ticket Filter' => 'Filtre ticket',
        'Lock' => 'Verrouiller',
        'SLA' => 'SLA',
        'Customer User ID' => '',
        'Article Filter' => 'Filtre pour Article',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article sender type' => '',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Inclure les pièces jointes aux notifications',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Des notifications sont envoyées à un opérateur ou à un client.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article de l\'opérateur).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Pour avoir les 5 premières ligne du corps (du dernier article de l\'opérateur).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Pour avoir les 20 premiers caractères du sujet (du dernier article du client).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Pour avoir les 5 premières lignes du sujet (du dernier article du client).',
        'Attributes of the current customer user data' => 'Caractéristiques des données de l\'utilisateur client actuel ',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'Gestion de PGP',
        'Add PGP Key' => 'Ajouter Clé PGP',
        'PGP support is disabled' => 'Le support de PGP est désactivé',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Pour utiliser PGP dans OTOBO, vous devez l\'activer en premier.',
        'Enable PGP support' => 'Activer le support de PGP',
        'Faulty PGP configuration' => 'Mauvaise configuration PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Le support PGP est activé, mais la configuration relative contient des erreurs. Merci de vérifier la configuration à l\'aide du bouton suivant.',
        'Configure it here!' => 'Configurer ici!',
        'Check PGP configuration' => 'Vérifier configuration PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Dans ce cas vous pouvez directement éditer le trousseau configuré dans SysConfig.',
        'Introduction to PGP' => 'Introduction aux clés PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Empreinte',
        'Expires' => 'Expiration',
        'Delete this key' => 'Supprimer cette clé',
        'PGP key' => 'Clé PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestionnaire de paquets',
        'Uninstall Package' => '',
        'Uninstall package' => 'Désinstaller package',
        'Do you really want to uninstall this package?' => 'Voulez-vous vraiment déinstaller ce paquet ?',
        'Reinstall package' => 'Réinstaller package',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Voulez-vous vraiment réinstaller ce package? Un quelconque changement manuel sera perdu. ',
        'Go to updating instructions' => '',
        'Go to the OTOBO customer portal' => '',
        'package information' => '',
        'Package installation requires a patch level update of OTOBO.' =>
            '',
        'Package update requires a patch level update of OTOBO.' => '',
        'Please note that your installed OTOBO version is %s.' => 'Veuillez noter que la version OTOBO installée est la %s',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            '',
        'This package can only be installed on OTOBO version %s or older.' =>
            '',
        'This package can only be installed on OTOBO version %s or newer.' =>
            '',
        'Why should I keep OTOBO up to date?' => 'Pourquoi dois-je garder OTOBO à jour ?',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our customer portal and file a request.' => '',
        'Install Package' => 'Installer Package',
        'Update Package' => '',
        'Continue' => 'Continuer',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Merci de vérifier que votre base de données accepte les paquets supérieurs à %s MB (elle supporte actuellement uniquement les paquets jusqu\'à %s MB). Merci de mettre à jour le paramètre max_allowed_packet dans votre base de données pour éviter les erreurs.',
        'Install' => 'Installation',
        'Update repository information' => 'Mettre à jour les informations du dépôt',
        'Cloud services are currently disabled.' => 'Les services de Cloud sont actuellement désactivés.',
        'OTOBO Verify can not continue!' => '',
        'Enable cloud services' => 'Activer les services de cloud',
        'Update all installed packages' => '',
        'Online Repository' => 'Dépôt en ligne',
        'Vendor' => 'Vendeur',
        'Action' => 'Action',
        'Module documentation' => 'Documentation du module',
        'Local Repository' => 'Dépôt local',
        'This package is verified by OTOBOverify (tm)' => 'Ce paquet est vérifié par OTOBOverify (tm)',
        'Uninstall' => 'Désinstallation',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Package incorrectement déployé! Merci de réinstaller le package.',
        'Reinstall' => 'Ré-installation',
        'Features for %s customers only' => 'Fonctionnalités pour %s clients seulement',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Package Information' => '',
        'Download package' => 'Télécharger package',
        'Rebuild package' => 'Reconstruire package',
        'Metadata' => 'Metadata',
        'Change Log' => 'Journal des modifications',
        'Date' => 'Date',
        'List of Files' => 'Liste de fichiers',
        'Permission' => 'Droits',
        'Download file from package!' => 'Télécharger le fichier depuis le paquet !',
        'Required' => 'Obligatoire',
        'Primary Key' => 'Clef primaire',
        'Auto Increment' => 'Incrément automatique',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Différences de fichier pour le fichier %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Enregistrement des indicateurs de performance',
        'Range' => 'Plage',
        'last' => 'dernier',
        'This feature is enabled!' => 'Cette fonctionnalité est activée',
        'Just use this feature if you want to log each request.' => 'N\'employer cette fonction que si vous voulez enregitrer chaque requête',
        'Activating this feature might affect your system performance!' =>
            'Activer cette fonctionnalité peut avoir un impact sur les performances de votre système !',
        'Disable it here!' => 'Désactivez là ici !',
        'Logfile too large!' => 'Fichier de log trop grand !',
        'The logfile is too large, you need to reset it' => 'Le fichier de log est trop grand, vous devez le réinitialiser',
        'Interface' => 'Interface',
        'Requests' => 'Requêtes',
        'Min Response' => 'Temps de réponse minimum',
        'Max Response' => 'Temps de réponse maximun',
        'Average Response' => 'Temps de réponse moyen',
        'Period' => 'Période',
        'minutes' => 'minutes',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Moyenne',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestion des filtres PostMaster',
        'Add PostMaster Filter' => 'Ajouter un filtre PostMaster',
        'Edit PostMaster Filter' => 'Editer ce filtre PostMaster',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'Search through PostMaster filters' => '',
        'Search all filter attributes' => '',
        'Limit search to selected header fields' => '',
        'Limit search to selected set fields' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si vous voulez tester uniquement l\'e-mail, utiliser EMAILADDRESS:info@example.com dans De, À ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Supprimer ce filtre',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Condition de filtre',
        'AND Condition' => 'condition ET',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Le champ doit être une expression régulière valide ou un mot litéral',
        'Negate' => 'Negation',
        'Set Email Headers' => 'Régler les entêtes e-mail',
        'Set email header' => 'Régler les entêtes e-mail',
        'with value' => '',
        'The field needs to be a literal word.' => 'Ce champ doit comporter un libellé.',
        'Header' => 'En-tête',

        # Template: AdminPriority
        'Priority Management' => 'Gestion de la priorité',
        'Add Priority' => 'Ajouter la priorité',
        'Edit Priority' => 'Editer priorité',
        'Include invalid priorities' => '',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Gestion des processus',
        'Include inactive processes' => '',
        'Filter for Processes' => '',
        'Filter for processes' => '',
        'Create New Process' => 'Créer un nouveau processus.',
        'Deploy All Processes' => 'Déployer tous les processus',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Ici vous pouvez envoyer un fichier de configuration pour importer le processus vers votre système. Le fichier a besoin d\'être en format "yml" comme exporté par le module de gestion de processus.',
        'Upload process configuration' => '',
        'Import process configuration' => 'Importer configuration de processus',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Pour créer un nouveau processus, vous pouvez soit importer un processsu qui a été exporté par un autre système ou créer complétement un nouveau processus.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'Imprimer',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annuler & fermer',
        'Go Back' => 'Retour',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => 'Activité',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => 'Disponible dans',
        'Description (short)' => 'Description (courte)',
        'Description (long)' => 'Description (longue)',
        'The selected permission does not exist.' => 'La permission sélectionnée n\'existe pas. ',
        'Required Lock' => 'Verrou obligatoire',
        'The selected required lock does not exist.' => 'Le verrou sélectionné n\'existe pas. ',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Input Field Definition' => '',
        'Direct submit' => '',
        'This property won\'t take effect because there are fields configured as visible.' =>
            '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => 'Filtrer les champs disponibles',
        'Available Fields' => 'Champs disponibles',
        'Assigned Fields' => 'Champs assignés',
        'Communication Channel' => '',
        'Is visible for customer' => 'Est visible par le client',
        'Display' => 'Afficher',

        # Template: AdminProcessManagementPath
        'Path' => 'Chemin',
        'Edit this transition' => 'Éditer cette transition',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Activités',
        'Filter Activities...' => 'Filtrer les activités... ',
        'Create New Activity' => 'Créer une nouvelle activité',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'Process Name' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => 'Éditer cette activité',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => 'Voulez-vous vraiment supprimer cette activité ?',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'annuler et fermer',
        'Start Activity' => 'Démarrer l\'activité',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => 'Nom du module',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => 'Transition',
        'Transition Name' => 'Nom de la transition',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Add a new Parameter' => 'Ajouter un nouveau paramètre',
        'Remove this Parameter' => 'Supprimer ce paramètre',

        # Template: AdminQueue
        'Queue Management' => 'Gestion des files',
        'Add Queue' => 'Ajouter une file',
        'Edit Queue' => 'Editer la file',
        'Include invalid queues' => '',
        'Filter for Queues' => 'Filtre pour les files',
        'Filter for queues' => 'Filtre pour les files',
        'A queue with this name already exists!' => 'Une file avec ce nom existe déjà !',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Sous-file de',
        'Unlock timeout' => 'Délai du déverrouillage',
        '0 = no unlock' => '0 = pas de déverrouillage',
        'hours' => 'heures',
        'Only business hours are counted.' => 'Seules les plages horaires de bureau sont prises en compte.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un opérateur verrouille un ticket et ne le ferme pas avant le délai de déverrouillage, le ticket sera déverrouillé et sera disponible pour un autre opérateur.',
        'Notify by' => 'Notification par',
        '0 = no escalation' => '0 = pas de remontée du ticket',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si un contact client n\'est pas ajouté à un nouveau ticket, soit par e-mail externe ou téléphone, avant que le temps défini ici expire, le ticket sera remonté.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si le ticket n\'est pas clôturé avant que le délai défini ici n\'expire, le ticket est remonté.',
        'Follow up Option' => 'Option des suivis',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Défini si le suivi des tickets clôturés doit réouvrir le ticket, être rejeté ou créer un nouveau ticket.',
        'Ticket lock after a follow up' => 'Ticket verrouillé après un suivi',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si le tiket est clos et que le client envoie un suivi, le ticket sera vérouillé à l\'ancien propriétaire.',
        'System address' => 'Adresse Système',
        'Will be the sender address of this queue for email answers.' => 'Sera l\'adresse d\'expédition pour les réponses par e-mail de cette file.',
        'Default sign key' => 'Clé de signature par défaut',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Salutation',
        'The salutation for email answers.' => 'La formule de politesse pour les réponses par e-mail.',
        'Signature' => 'Signature',
        'The signature for email answers.' => 'La signature pour les réponses par e-mail.',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gérer les relations entre les files et les réponses automatiques',
        'Change Auto Response Relations for Queue' => 'Modifier les réponses automatiques pour la file',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without Auto Responses' => 'Files sans réponses automatiques liées',
        'This filter allow you to show all queues' => 'Ce filtre vous permet d\'afficher toutes les files',
        'Show All Queues' => '',
        'Auto Responses' => 'Réponses automatiques',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Filter for templates' => '',
        'Templates' => 'Modèles',

        # Template: AdminRegistration
        'System Registration Management' => 'Gestion Inscription Système',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTOBO-ID' => '',
        'Deregister System' => '',
        'Edit details' => 'Editer details',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'This system is registered with OTOBO Team.' => '',
        'System type' => '',
        'Unique ID' => 'ID unique',
        'Last communication with registration server' => '',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Veuillez noter que vous ne pouvez pas enregistrer votre système si le démon OTOBO ne fonctionne pas correctement !',
        'Instructions' => 'Instructions',
        'System Deregistration not Possible' => '',
        'OTOBO-ID Login' => 'Identifiant OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '',
        'Read more' => 'Lire plus',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Vous devez vous identifier avec votre identifiant OTOBO-ID pour enregistrer votre système.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Votre identifiant OTOBO-ID est votre adresse email utilisée pour vous connecter à la page web OTOBO.com.',
        'Data Protection' => 'Protection des données',
        'What are the advantages of system registration?' => 'Quels sont les avantages de l\'enregistrement de votre installation ?',
        'You will receive updates about relevant security releases.' => 'Vous recevrez les mises à jour de sécurité majeures.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTOBO without being registered?' => 'Puis-je utiliser OTOBO sans être enregistré ?',
        'System registration is optional.' => '',
        'You can download and use OTOBO without being registered.' => 'Vous pouvez télécharger et utiliser OTOBO sans être enregistré.',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTOBO Team:' => '',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => 'La description du système est optionelle.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTOBO system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            '',
        'OTOBO-ID' => '',
        'You don\'t have an OTOBO-ID yet?' => '',
        'Sign up now' => 'Enregistrez-vous maintenant',
        'Forgot your password?' => 'Mot de passe oublié ?',
        'Retrieve a new one' => '',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            '',
        'Attribute' => '',
        'FQDN' => '',
        'OTOBO Version' => 'Version OTOBO',
        'Operating System' => 'Système d\'Exploitation',
        'Perl Version' => 'Version de Perl',
        'Optional description of this system.' => '',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            '',
        'Register' => 'Enregistrement',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            '',
        'Deregister' => '',
        'You can modify registration settings here.' => '',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => 'Données de support',

        # Template: AdminResponseTemplatesStatePreselection
        'Manage ticket state pre-selections for response templates' => '',
        'Edit Response' => '',
        'Pre-selected ticket state' => '',

        # Template: AdminRole
        'Role Management' => 'Gestion des Rôles',
        'Add Role' => 'Ajouter un rôle',
        'Edit Role' => 'Editer rôle',
        'Include invalid roles' => '',
        'Filter for Roles' => 'Filtre pour Rôles',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Créer un rôle et attribuer des groupes. Ensuite, attribuer ce rôle aux utilisateurs.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Il n\'y a pas de rôle défini. Utilisez le bouton \'Ajouter\' pour créer un nouveau rôle.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gérer Relations Rôle-Groupe',
        'Roles' => 'Rôles',
        'Select the role:group permissions.' => 'Sélectionner les permissions rôle:groupe',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si rien n\'est sélectionné, alors il n\'y a aucune permission pour ce groupe (les tickets ne seront pas disponibles pour ce rôle).',
        'Toggle %s permission for all' => 'Sélectionner permission %s pour tous',
        'move_into' => 'déplacer dans',
        'Permissions to move tickets into this group/queue.' => 'Permission de déplacer un ticket dans cette file/ce groupe.',
        'create' => 'créer',
        'Permissions to create tickets in this group/queue.' => 'Permission de créer un ticket dans cette file/ce groupe.',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissions d\'ajouter des notes aux tickets dans ce groupe/cette file',
        'owner' => 'propriétaire',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissions de changer le propriétaire des tickets dans ce gorupe/cette file.',
        'priority' => 'priorité',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permission de changer la priorité d\'un ticket dans cette file/ce groupe.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gérer les relations opérateur-rôle',
        'Add Agent' => 'Ajouter un opérateur',
        'Filter for Agents' => 'Filtre pour opérateurs',
        'Filter for agents' => '',
        'Agents' => 'Opérateurs',
        'Manage Role-Agent Relations' => 'Gérer les relations rôle-opérateur',

        # Template: AdminSLA
        'SLA Management' => 'Gestion des Accords sur la qualité de service (Service Level Agreement)',
        'Edit SLA' => 'Editer SLA',
        'Add SLA' => 'Ajouter un SLA',
        'Include invalid SLAs' => '',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Merci de n\'écrire que des nombres',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add Certificate' => 'Ajouter un certificat',
        'Add Private Key' => 'Ajouter une clé privée',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Pour utiliser SMIME dans OTOBO, vous devez l\'activer en premier.',
        'Enable SMIME support' => 'Activer le support SMIME',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Filtres pour les certificats',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Voir aussi',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Dans ce cas vous pouvez directement éditer le certificat et la clé privée dans le système de fichier',
        'Hash' => 'Hashage',
        'Create' => 'Création',
        'Handle related certificates' => 'Gestion des certificats associés',
        'Read certificate' => 'Lire le certificat',
        'Delete this certificate' => 'Supprimer ce certificat',
        'File' => 'Fichier',
        'Secret' => 'Secret',
        'Related Certificates for' => 'Certificats associés à',
        'Delete this relation' => 'Supprimer cette relation',
        'Available Certificates' => 'Certificats disponibles',
        'Filter for S/MIME certs' => '',
        'Relate this certificate' => 'Lie ce certificat',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificat S/MIME',
        'Certificate Details' => '',
        'Close this dialog' => 'Fermer cette fenêtre de dialogue',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestion des Formules de Politesse',
        'Add Salutation' => 'Ajouter une Formule de Politesse',
        'Edit Salutation' => 'Editer Formule de Politesse',
        'Include invalid salutations' => '',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'p. ex.',
        'Example salutation' => 'Exemple de formule de politesse',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Le mode sécurisé sera (normallement) activé lorsque l\'installation initiale sera terminée.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si le mode sécurisé n\'est pas activé, activez le via SysConfig car votre application est en train de tourner',

        # Template: AdminSelectBox
        'SQL Box' => 'Requêtes SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Ici vous pouvez entrez du SQL pour l\'envoyer directement à la base de donnée',
        'Options' => 'Options',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Votre requête SQL comporte une erreur de syntaxe. Veuillez la corriger.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Il manque au moins un paramètre, ce qui empêche l\'association. Veuillez corriger la situation.',
        'Result format' => 'Format du résultat',
        'Run Query' => 'Exécuter requête',
        '%s Results' => '',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Gestion des services',
        'Add Service' => 'Ajouter un service',
        'Edit Service' => 'Éditer un service',
        'Include invalid services' => '',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Sous-service de',

        # Template: AdminSession
        'Session Management' => 'Gestion des sessions',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Toutes les sessions',
        'Agent sessions' => 'Sessions Opérateurs',
        'Customer sessions' => 'Session clients',
        'Unique agents' => 'Opérateurs uniques',
        'Unique customers' => 'Clients uniques',
        'Kill all sessions' => 'Supprimer toutes les sessions',
        'Kill this session' => 'tuer cette session',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Session',
        'Kill' => 'Tuer',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Gestion des signatures',
        'Add Signature' => 'Ajouter une signature',
        'Edit Signature' => 'Editer signature',
        'Include invalid signatures' => '',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Exemple de signature',

        # Template: AdminState
        'State Management' => 'Gestion des états',
        'Add State' => 'Ajouter un état',
        'Edit State' => 'Editer état',
        'Include invalid states' => '',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Attention',
        'Please also update the states in SysConfig where needed.' => 'Veuillez également mettre les états à jour dans SysConfig.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Type d\'état',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => 'Cet état est utilisé dans les réglages suivants :',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '',
        'Enable Cloud Services' => 'Activer les services du Cloud',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => 'Envoyer la mise à jour',
        'Currently this data is only shown in this system.' => 'Cette données n\'est actuellement affichée que dans ce système',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Merci de sélectionner l\'une des options suivantes.',
        'Send by Email' => 'Envoyé par email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => 'émetteur',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Informations',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestion des e-mails du système',
        'Add System Email Address' => 'Ajouter l\'adresse e-mail du système',
        'Edit System Email Address' => 'Éditer l\'adresse e-mail du système',
        'Include invalid system addresses' => '',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tous les e-mail entrants avec cette adresse en À ou Cc seront envoyés dans la file sélectionnée',
        'Email address' => 'Adresse e-mail',
        'Display name' => 'Nom à afficher',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Le nom à afficher et l\'adresse e-mail seront affichés dans les messages que vous envoyez.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => '',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => 'Déployer les changements sélectionnés',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => '',
        'Filter for Deployments' => '',
        'Recent Deployments' => '',
        'Restore' => '',
        'View Details' => '',
        'Restore this deployment.' => '',
        'Export this deployment.' => '',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => '',
        'by' => 'par',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importer & Exporter',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => 'Téléverser la configuration du système',
        'Import system configuration' => 'importer la configuration du système',
        'Download current configuration settings of your system in a .yml file.' =>
            'Télécharger la configuration actuelle de votre système dans un fichier .yml.',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Recherche pour',
        'Search for category' => 'Rechercher une catégorie',
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Catégorie',
        'Run search' => 'Lancer la recherche',

        # Template: AdminSystemConfigurationSettingHistoryDetails
        'Change History' => '',
        'Change History of %s' => '',
        'No modified values for this setting, the default value is used.' =>
            '',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => '',
        'Users Value' => '',
        'For' => '',
        'Delete all user values.' => '',
        'No user value for this setting.' => '',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => 'Retourner aux détails des déploiements',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Include invalid system maintenances' => '',
        'Schedule New System Maintenance' => '',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Delete System Maintenance' => '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => '',
        'Login message' => '',
        'This field must have less then 250 characters.' => '',
        'Show login message' => '',
        'Notify message' => 'Message de notification',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => 'Session Clients',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Ajouter un modèle',
        'Edit Template' => 'Modifier un modèle',
        'Include invalid templates' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Un modèle est un texte par défaut qui aide vos opérateurs à écrire plus rapidement des tickets, réponses ou renvois.',
        'Don\'t forget to add new templates to queues.' => 'N\'oubliez pas d\'ajouter les nouveaux modèles à une file',
        'Attachments' => 'Pièces jointes',
        'Delete this entry' => 'Supprimer cette entrée',
        'Do you really want to delete this template?' => 'Voulez-vous vraiment supprimer ce modèle ?',
        'A standard template with this name already exists!' => 'Un modèle standard avec ce nom existe déjà',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => 'Exemple de modèle',
        'The current ticket state is' => 'L\'état actuel du ticket est',
        'Your email address is' => 'Votre e-mail est',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Sélectionner actif pour tous',
        'Link %s to selected %s' => 'Lien %s vers sélection %s',

        # Template: AdminTicketMask
        'Ticket Mask Management' => '',
        'Change mask definition' => '',
        'Ticket Mask' => '',
        'Change' => '',
        'Definition' => '',

        # Template: AdminTranslations
        'Translation Management' => '',
        'Add Translations' => '',
        'Edit Translations' => '',
        'Language' => 'Langue',
        'Deploy Translations' => '',
        'Translation States' => '',
        'New Translation' => '',
        'Editing Translation' => '',
        'Translation Marked for Deletion' => '',
        'Deployed Translation' => '',
        'Changes made here only affect the system behaviour after your draft translations have been deployed. By deploying them, all changes will be written to the language files.' =>
            '',
        'Select an object to start adding translations. Depending on your selection, single or multiple translations can be added.' =>
            '',
        'Edit active translations using provided text fields!' => '',
        'List custom translations for' => '',
        'Draft Translations' => '',
        'Filter for Draft Translations' => '',
        'Active Translations' => '',
        'Filter for Active Translations' => '',
        'Content' => 'Contenu',
        'Translation' => '',
        'Marked for Deletion' => '',
        'Edit Translation' => '',
        'Overwrites OTOBO translation' => '',
        'Undo Delete Translation' => '',
        'Delete Translation' => '',
        'Translations' => '',

        # Template: AdminType
        'Type Management' => 'Gestion des Types',
        'Add Type' => 'Ajouter un Type',
        'Edit Type' => 'Editer Type',
        'Include invalid types' => '',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Un type avec le même nom existe déjà !',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Gestion des opérateurs',
        'Edit Agent' => 'Modifier l\'opérateur ',
        'Include invalid users' => '',
        'Edit personal preferences for this agent' => 'Éditer les préférences personnelles de cet opérateur',
        'Agents will be needed to handle tickets.' => 'Des opérateurs seront requis pour gérer les tickets',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'N\'oubliez pas d\'ajouter un nouvel opérateur aux groupes et/ou rôles',
        'Please enter a search term to look for agents.' => 'Merci d\'entrer un motif de recherche pour chercher des opérateurs',
        'Last login' => 'Dernière connexion',
        'Switch to agent' => 'Changer d\'opérateur vers',
        'Title or salutation' => '',
        'Firstname' => 'Prénom',
        'Lastname' => 'Nom',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Mobile' => 'Téléphone portable',
        'Effective Permissions for Agent' => 'Permissions actuelles de l\'opérateur',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gérer les relations opérateur-groupe',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Vue d\'ensemble des rendez-vous',
        'Manage Calendars' => 'Gérer les calendriers',
        'Add Appointment' => '',
        'Today' => 'Aujourd\'hui',
        'All-day' => '',
        'Repeat' => '',
        'Notification' => 'Notification',
        'Yes' => 'Oui',
        'No' => 'Non',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Aucun calendrier n\'a été trouvé. Veuillez d\'abord créer un calendrier à l\'aide du gestionnaire de calendriers.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Ajouter un nouveau rendez-vous',
        'Calendars' => 'Calendriers',

        # Template: AgentAppointmentEdit
        'Basic information' => '',
        'Date/Time' => '',
        'Invalid date!' => 'Date non valide !',
        'Please set this to value before End date.' => '',
        'Please set this to value after Start date.' => '',
        'This an occurrence of a repeating appointment.' => '',
        'Click here to see the parent appointment.' => '',
        'Click here to edit the parent appointment.' => '',
        'Frequency' => '',
        'Every' => '',
        'day(s)' => 'jour(s)',
        'week(s)' => 'semaine(s)',
        'month(s)' => 'mois',
        'year(s)' => 'année(s)',
        'On' => 'Activé',
        'Monday' => 'Lundi',
        'Mon' => 'Lun',
        'Tuesday' => 'Mardi',
        'Tue' => 'Mar',
        'Wednesday' => 'Mercredi',
        'Wed' => 'Mer',
        'Thursday' => 'Jeudi',
        'Thu' => 'Jeu',
        'Friday' => 'Vendredi',
        'Fri' => 'Ven',
        'Saturday' => 'Samedi',
        'Sat' => 'Sam',
        'Sunday' => 'Dimanche',
        'Sun' => 'Dim',
        'January' => 'Janvier',
        'Jan' => 'Jan',
        'February' => 'Février',
        'Feb' => 'Fév',
        'March' => 'Mars',
        'Mar' => 'Mar',
        'April' => 'Avril',
        'Apr' => 'Avr',
        'May_long' => 'Mai',
        'May' => 'Mai',
        'June' => 'Juin',
        'Jun' => 'Juin',
        'July' => 'Juillet',
        'Jul' => 'Juil',
        'August' => 'Août',
        'Aug' => 'Aoû',
        'September' => 'Septembre',
        'Sep' => 'Sep',
        'October' => 'Octobre',
        'Oct' => 'Oct',
        'November' => 'Novembre',
        'Nov' => 'Nov',
        'December' => 'Décembre',
        'Dec' => 'Déc',
        'Relative point of time' => '',
        'Link' => 'Lier',
        'Remove entry' => 'Supprimer l\'entrée',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centre d\'informations des utilisateurs client et clients',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Utilisateur client',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Note : Le client est incorrect!',
        'Start chat' => '',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Modèle de recherche',
        'Create Template' => 'Créer Modèle',
        'Create New' => 'Créer nouveau',
        'Save changes in template' => 'Sauvegarder les modifications du modèle',
        'Filters in use' => 'Filtres utilisés',
        'Additional filters' => 'Filtres complémentaires',
        'Add another attribute' => 'Ajouter un autre attribut',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Tout sélectionner',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Changer les options de recherche',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centre d\'informations des utilisateurs client',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            '',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            '',
        'Starting the OTOBO Daemon' => '',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            '',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            '',

        # Template: AgentDashboard
        'Dashboard' => 'Tableau de bord',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nouveau rendez-vous',
        'Tomorrow' => 'Demain',
        'Soon' => '',
        '5 days' => '5 jours',
        'Start' => 'Début',
        'none' => 'aucun',

        # Template: AgentDashboardCalendarOverview
        'in' => 'dans',

        # Template: AgentDashboardCommon
        'Save settings' => 'Sauvegarder les paramètres',
        'Close this widget' => '',
        'more' => 'plus',
        'Available Columns' => 'Colonnes disponibles',
        'Visible Columns (order by drag & drop)' => 'Colonnes visbles (glisser/déposer pour les ordonner)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Ouverts',
        'Closed' => 'Fermés',
        '%s open ticket(s) of %s' => '%s ticket(s) ouvert(s) de %s',
        '%s closed ticket(s) of %s' => '%s ticket(s) fermé(s) de %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets remontés',
        'Open tickets' => 'Tickets ouverts',
        'Closed tickets' => 'Tickets fermés',
        'All tickets' => 'Tous les tickets',
        'Archived tickets' => 'Tickets archivés',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Ticket téléphonique',
        'Email ticket' => 'Ticket par e-mail',
        'New phone ticket from %s' => 'Nouveau ticket téléphonique de %s',
        'New email ticket to %s' => 'Nouveau ticket par e-mail de %s',

        # Template: AgentDashboardMyLastChangedTickets
        'No tickets found.' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s est disponible !',
        'Please update now.' => 'Merci de mettre à jour maintenant',
        'Release Note' => 'Note de version',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Envoyé il y a %s',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Mes tickets verrouillés',
        'My watched tickets' => 'Mes tickets suivis',
        'My responsibilities' => 'Mes responsabilités',
        'Tickets in My Queues' => 'Tickets dans mes files',
        'Tickets in My Services' => 'Tickets dans mes services',
        'Service Time' => 'Temps pour le service',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => 'absence du bureau',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'jusqu\'à',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentElasticsearchQuickResult
        'Tickets' => 'Ticket',
        'ConfigItems' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Pour accepter des nouvelles, une licence ou des modifications.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Changer de mot de passe',
        'Current password' => 'Mot de passe actuel',
        'New password' => 'Nouveau mot de passe',
        'Repeat new password' => '',
        'Password needs to be renewed every %s days.' => '',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            '',
        'Password length must be at least %s characters.' => '',
        'Password requires at least two lower- and two uppercase characters.' =>
            '',
        'Password requires at least two characters.' => '',
        'Password requires at least one digit.' => '',
        'Change config options' => '',
        'Admin permissions are required!' => '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Editer vos préférences',
        'Personal Preferences' => 'Préférences personnelles',
        'Preferences' => 'Préférences',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Attention: vous êtes en train de modifier les préférences personnelles de %s.',
        'Go back to editing this agent' => 'Retourner modifier cet opérateur',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Définissez vos préférences personnelles. Sauvegardez chaque paramètres en cliquant sur la case à droite.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'End' => 'Fin',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTOBO at %s.' => 'Le saviez-vous ? Vous pouvez aider à traduire OTOBO sur %s',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Sélectionnez à droite les paramètres que vous souhaitez modifier.',
        'Did you know?' => 'Le saviez-vous ?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Vous pouvez modifier votre avatar en vous enregistrant à l\'aide de votre adresse mail %s sur le site %s.',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => 'Processus',
        'Split' => 'Scinder',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTOBO' => '',
        'Dynamic Matrix' => '',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => '',
        'Each row contains data of one entity.' => '',
        'Static' => '',
        'Non-configurable complex statistics.' => '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiques',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',

        # Template: AgentStatisticsReportsAdd
        'Report Management' => '',
        'Add Report' => '',

        # Template: AgentStatisticsReportsEdit
        'Edit Report' => '',
        'Here you can combine several statistics to a report which you can generate as a PDF manually or automatically at configured times.' =>
            '',
        'Please note that you can only select charts as statistics output format if you configured one of the renderer binaries on your system.' =>
            '',
        'Configure PhantomJS' => '',
        'Configure GoogleChrome' => '',
        'General settings' => '',
        'Automatic generation settings' => '',
        'Automatic generation times (cron)' => '',
        'Specify when the report should be automatically generated in cron format, e. g. "10 1 * * *" for every day at 1:10 am.' =>
            '',
        'Times are in the system timezone.' => '',
        'Last automatic generation time' => '',
        'Next planned automatic generation time' => '',
        'Automatic generation language' => '',
        'The language to be used when the report is automatically generated.' =>
            '',
        'Email subject' => '',
        'Specify the subject for the automatically generated email.' => '',
        'Email body' => '',
        'Specify the text for the automatically generated email.' => '',
        'Email recipients' => '',
        'Specify recipient email addresses (comma separated).' => '',
        'Output settings' => '',
        'Headline' => '',
        'Caption for preamble' => '',
        'Preamble' => '',
        'Caption for epilogue' => '',
        'Epilogue' => '',
        'Add statistic to report' => '',

        # Template: AgentStatisticsReportsOverview
        'Statistics Reports' => '',
        'Edit statistics report "%s".' => '',
        'Delete statistics report "%s"' => '',

        # Template: AgentStatisticsReportsView
        'View Report' => '',
        'This statistics report contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Créé par',
        'Changed by' => 'Changé par',
        'Sum rows' => 'Ligne de somme',
        'Sum columns' => 'Colonnes de somme',
        'Show as dashboard widget' => '',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'Edit Article "%s" of %s%s%s' => '',
        'The ticket has been locked' => 'Le ticket a été verrouillé',
        'Undo & close' => '',
        'Ticket Settings' => 'Paramètres du ticket',
        'Queue invalid.' => '',
        'Service invalid.' => 'Service non valide !',
        'SLA invalid.' => '',
        'New Owner' => 'Nouveau Propriétaire',
        'Please set a new owner!' => 'Merci de renseigner un propriétaire',
        'Owner invalid.' => '',
        'New Responsible' => 'Nouveau Responsable',
        'Please set a new responsible!' => 'Veuillez spécifier un nouveau responsable !',
        'Responsible invalid.' => '',
        'Next state' => 'État suivant',
        'State invalid.' => '',
        'For all pending* states.' => 'Pour tous les états en attente*',
        'Add Article' => 'Ajout d\'article',
        'Create an Article' => '',
        'Inform agents' => 'Informer des opérateurs',
        'Inform involved agents' => 'Informer les opérateurs impliqués',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Vous pouvez sélectionner des opérateurs additionnels, qui seront notifiés de l\'ajout de cet article.',
        'Text will also be received by' => '',
        'Text Template' => 'Modèle de texte',
        'Setting a template will overwrite any text or attachment.' => 'Spécifier un modèle va remplacer tout texte ou pièce jointe.',
        'Invalid time!' => 'Heure/Durée non valide !',

        # Template: AgentTicketArticleVersionView
        'Viewing Article Version#%s of current Article: #%s %s' => '',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Renvoyer à',
        'You need a email address.' => 'Vous devez avoir une adresse e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Une adresse e-mail valide est nécessaire ou n\'utilisez pas d\'adresse e-mail locale.',
        'Next ticket state' => 'Prochain état du ticket',
        'Inform sender' => 'Informer l\'émetteur',
        'Send mail' => 'Envoyer le message !',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ticket en action groupée',
        'Send Email' => 'Envoyer E-mail',
        'Merge' => 'Fusionner',
        'Merge to' => 'Fusionner avec',
        'Invalid ticket identifier!' => 'Identifiant de ticket non valide !',
        'Merge to oldest' => 'Fusionner avec le plus ancien',
        'Link together' => 'Lier ensemble',
        'Link to parent' => 'Lier au parent',
        'Unlock tickets' => 'Déverrouiller les tickets',
        'Execute Bulk Action' => '',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            '',
        'Please include at least one recipient' => 'Merci d\'inclure au moins un destinataire',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Retirer le Ticket Client',
        'Move to Cc' => '',
        'Move to Bcc' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Merci de retirer cette entrée et de la remplacer par une valeur correcte.',
        'This address already exists on the address list.' => 'Cette adresse existe déjà dans la liste d\'addresses.',
        'Remove Cc' => 'Retirer le Cc',
        'Move to To' => '',
        'Bcc' => 'Copie Invisible',
        'Remove Bcc' => 'Retirer le Bcc',
        'Date Invalid!' => 'Date non valide !',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',
        'Customer Information' => 'Information client',
        'Customer user' => 'Utilisateur client',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Créer un Nouveau Ticket par E-mail',
        'Example Template' => 'Exemple de modèle',
        'To customer user' => 'Vers le client',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => 'Sélectionner ce client comme le principal client',
        'Remove Ticket Customer User' => 'Retirer le Ticket de l\'Utilisateur Client',
        'From queue' => 'De la file',
        'Get all' => 'Tout prendre',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => '',
        'Article' => 'Article',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Vous devez utiliser un numéro de ticket !',
        'A valid ticket number is required.' => 'Un numéro de ticket valide est obligatoire.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => 'Informer l\'émetteur',
        'Need a valid email address.' => 'Une adresse e-mail valide est nécessaire.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Déplacer %s%s%s',
        'New Queue' => 'Nouvelle File',
        'Move' => 'Déplacer',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Aucune donnée de ticket trouvée',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Sélectionner ce ticket',
        'Sender' => 'émetteur',
        'First Response Time' => 'Temps pour fournir la première réponse (prise en compte)',
        'Update Time' => 'Temps pour fournir un point d\'avancement',
        'Solution Time' => 'Temps pour fournir la réponse',
        'Move ticket to a different queue' => 'Déplacer ticket vers une autre file',
        'Change queue' => 'Changer de file',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Supprimer les filtres actifs sur cette page',
        'Tickets per page' => 'Tickets par page',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Canal manquant',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Réinitialiser la vue d\'ensemble',
        'Column Filters Form' => 'Formulaire des filtres de colonne',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Séparer en un nouveau ticket téléphonique',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Créer un nouveau Ticket téléphonique',
        'Please include at least one customer for the ticket.' => 'Veuillez inclure au moins un client au ticket',
        'To queue' => 'Vers la file',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Tel quel',
        'Download this email' => 'Télécharger cet e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Profile link' => 'Lien du Profil',
        'Output' => 'Format du résultat',
        'Fulltext' => 'Texte Complet',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Créé dans la file',
        'Lock state' => 'État verrouillé',
        'Watcher' => 'Surveillance',
        'Article Create Time (before/after)' => 'Date Création Article (avant/après)',
        'Article Create Time (between)' => 'Date Création Article (Période)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Date Création Ticket (avant/après)',
        'Ticket Create Time (between)' => 'Date Création Ticket (Période)',
        'Ticket Change Time (before/after)' => 'Date Modification Ticket (avant/après)',
        'Ticket Change Time (between)' => 'Date Modification Ticket (Période)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Date Fermeture Ticket (avant/après)',
        'Ticket Close Time (between)' => 'Date Fermeture Ticket (Période)',
        'Ticket Escalation Time (before/after)' => 'Date Remontée Ticket (avant/après)',
        'Ticket Escalation Time (between)' => 'Date Remontée Ticket (Période)',
        'Archive Search' => 'Recherche Archive',

        # Template: AgentTicketZoom
        'Sender Type' => 'Type de l\'expéditeur',
        'Save filter settings as default' => 'Sauvegarder les paramètres de filtrage comme paramètres par défaut',
        'Event Type' => '',
        'Save as default' => '',
        'Drafts' => '',
        'Change Queue' => 'Modifier la file',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => 'Cet objet n\'a aucun article pour l\'instant. ',
        'Ticket Timeline View' => '',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Ajouter filtre',
        'Set' => 'Assigner',
        'Reset Filter' => 'Réinitialiser filtre',
        'No.' => 'N°.',
        'Unread articles' => 'Articles non lus',
        'Via' => 'Via',
        'Article Edited' => '',
        'Important' => 'Important',
        'Unread Article!' => 'Article non lu!',
        'Incoming message' => 'Message entrant',
        'Outgoing message' => 'Message sortant',
        'Internal message' => 'Message Interne',
        'Sending of this message has failed.' => 'L\'envoi du message a échoué.',
        'The article was edited' => '',
        'Resize' => 'Redimensionner',
        'Mark this article as read' => 'Marquer cet article comme lu ',
        'Show Full Text' => 'Voir le texte complet',
        'Full Article Text' => 'Texte complet de l\'article',
        'No more events found. Please try changing the filter settings.' =>
            '',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => 'Fermer ce message',
        'Image' => '',
        'PDF' => '',
        'Unknown' => 'Inconnu',
        'View' => 'Vue',

        # Template: LinkTable
        'Linked Objects' => 'Objets liés',

        # Template: TicketInformation
        'Archive' => 'Archiver',
        'This ticket is archived.' => 'Ce ticket est archivé',
        'Note: Type is invalid!' => '',
        'Pending till' => 'En attente jusque',
        'Locked' => 'Verrouillé',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Temp passé',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Pour protéger votre vie privée, les contenus distants ont été bloqués.',
        'Load blocked content.' => 'Charger le contenu bloqué',

        # Template: Breadcrumb
        'Home' => 'Accueil',
        'Back to admin overview' => 'Retour à la page d\'administration',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Cette fonctionnalité requiert l\'utilisation du Cloud',
        'You can' => 'Vous pouvez',
        'go back to the previous page' => 'Revenir à la page précédente',

        # Template: CustomerAccept
        'Click to accept' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'L\'ID Client n\'est pas modifiable, aucun autre ID client ne peut être assigné à ce ticket.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Vous devez d\'abord sélectionner un utilisateur, puis vous pourrez sélectionner un ID utilisateur pour assigner à ce ticket.',
        'Select a customer ID to assign to this ticket.' => 'Veuillez sélectionner un ID client à assigner à ce ticket.',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => 'Nouveau ticket',

        # Template: CustomerError
        'An Error Occurred' => 'Une erreur est survenue',
        'Error Details' => 'Détails de l\'erreur',
        'Traceback' => 'Trace du retour d\'erreur',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            'Il y a %s erreur de réseau possibles. Merci d\'essayer de recharger la page manuellement ou d\'attendre que le navigateur réponde.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'La connexion a été rétablie. Des éléments de cette page peuvent ne plus fonctionner. Merci de recharger cette page pour éviter tout désagrément.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non disponible',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Pour utiliser cette application, vous devez activer JavaScript dans votre navigateur.',
        'Browser Warning' => 'Avertissement du navigateur',
        'The browser you are using is too old.' => 'Votre navigateur est trop ancien.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Merci de se référer à la documentation ou demander à votre administrateur système pour de plus amples informations.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            '',
        'One moment please, you are being redirected...' => 'Merci de patienter, vous êtes redirigé...',
        'Login' => 'Connexion',
        'Your user name' => 'Votre Identifiant',
        'User name' => 'Identifiant',
        'Your password' => 'Votre mot de passe',
        'Forgot password?' => 'Mot de passe oublié?',
        'Your 2 Factor Token' => '',
        '2 Factor Token' => '',
        'Log In' => 'Connexion',
        'Request Account' => '',
        'Request New Password' => 'Demander un nouveau mot de passe',
        'Your User Name' => 'Votre nom',
        'A new password will be sent to your email address.' => 'Un nouveau mot de passe sera envoyé à votre adresse e-mail.',
        'Create Account' => 'Créer un compte',
        'Please fill out this form to receive login credentials.' => 'Veuillez remplir ce formulaire pour recevoir vos identifiants de connexion.',
        'How we should address you' => 'Comment devons-nous nous adresser à vous',
        'Your First Name' => 'Votre prénom',
        'Your Last Name' => 'Votre nom de famille',
        'Your email address (this will become your username)' => 'Votre adresse e-mail (celle-ci deviendra votre identifiant)',

        # Template: CustomerNavigationBar
        'Logout' => 'Déconnexion',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Welcome!' => 'Bienvenue !',
        'You have no tickets yet. Please click here, to create a new one.' =>
            'Vous n\'avez pas encore de tickets. Veuillez cliquer ici pour en créer un nouveau.',
        'Nothing to show.' => 'Rien à afficher.',
        'Click here for an unfiltered list of all your tickets.' => 'Cliquez ici pour une liste non filtrée de tous vos billets.',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => 'Créer un nouveau ticket',
        'Service level agreement' => 'Contrat de niveau de service (SLA)',

        # Template: CustomerTicketOverview
        'Your Tickets' => 'Vos Tickets',
        'Page' => 'Page',
        'Sort' => 'Trier',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'p. ex. 10*5155 ou 105658*',
        'CustomerID' => 'Code client',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Types',
        'Time Restrictions' => 'Restrictions de temps',
        'No time settings' => 'Pas de réglages de temps',
        'All' => 'Tous',
        'Specific date' => 'Date précise',
        'Only tickets created' => 'Seulement les tickets créés',
        'Date range' => 'période',
        'Only tickets created between' => 'Seulement les tickets créés entre',
        'Ticket Archive System' => 'Système d\'archivage des tickets',
        'Save Search as Template?' => 'Enregistrer la recherche en tant que modèle?',
        'Save as Template?' => 'Enregistrer comme Modèle?',
        'Save as Template' => 'Enregistrer comme Modèle',
        'Pick a profile name' => 'Choisissez un nom de profil',
        'Output to' => 'Sortie vers',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Résultats de recherche pour',
        'Remove this Search Term.' => 'Supprimer ce terme de la recherche. ',

        # Template: CustomerTicketZoom
        'Reply' => 'Répondre',
        'Discard' => '',

        # Template: Chat
        'Expand article' => 'Déplier l\'article',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: TicketInfo
        'Ticket Information' => 'Information Ticket',
        'Categories' => '',
        'Further actions' => 'Actions supplémentaires',

        # Template: CustomerWarning
        'Warning' => 'Attention',

        # Template: TileNewTicket
        'Issue%sa ticket' => 'Ouvrir%sun ticket',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Information de l\'événement',

        # Template: Error
        'Send a bugreport' => 'Envoyer un rapport de bug',
        'Expand' => 'Etendre',

        # Template: Footer
        'Powered by %s' => '',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Cliquer pour supprimer cette pièce jointe.',

        # Template: DraftButtons
        'Update draft' => 'Mettre à jour le brouillon',
        'Save as new draft' => 'Enregistrer comme brouillon',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Vous avez charger le brouillon " %s ".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Vous avez chargé le brouillon " %s ". Dernière modification : %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Vous avez chargé le brouillon " %s ". Dernière modification : %s par %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'Edit personal preferences' => 'Modifier vos préférences',
        'Personal preferences' => 'Préférences personnelles',
        'You are logged in as' => 'Vous êtes connecté avec',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponible',
        'Step %s' => 'Étape %s',
        'License' => 'Licence',
        'Database Settings' => 'Réglages de Base de Données',
        'General Specifications and Mail Settings' => 'Spécifications Générales et Réglages de Messagerie',
        'Welcome to %s' => 'Bien venue à %s',
        'Germany' => 'Allemagne',
        'Phone' => 'Téléphone',
        'Web site' => 'Site web',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurer le mail sortant',
        'Outbound mail type' => 'Type de mail sortant',
        'Select outbound mail type.' => 'Sélectionner le type de mail sortant',
        'Outbound mail port' => 'Port mail sortant',
        'Select outbound mail port.' => 'Sélectionner le port mail sortant',
        'SMTP host' => 'Hôte SMTP',
        'SMTP host.' => 'Hôte SMTP.',
        'SMTP authentication' => 'Authentification SMTP',
        'Does your SMTP host need authentication?' => 'Est-ce-que votre hôte SMTP supporte l\'authentification?',
        'SMTP auth user' => 'Utilisateur auth SMTP',
        'Username for SMTP auth.' => 'Nom utilisateur pour auth SMTP.',
        'SMTP auth password' => 'Mot de passe auth SMTP',
        'Password for SMTP auth.' => 'Mot de passe pour autgh SMTP.',
        'Configure Inbound Mail' => 'Configurer mail entrant',
        'Inbound mail type' => 'Type de mail entrant',
        'Select inbound mail type.' => 'Sélectionner le type de mail entrant',
        'Inbound mail host' => 'Hôte mail entrant',
        'Inbound mail host.' => 'Hôte mail entrant.',
        'Inbound mail user' => 'Utilisateur mail entrant',
        'User for inbound mail.' => 'Utilisateuyr pour mail entrant.',
        'Inbound mail password' => 'Mot de passe mail entrant',
        'Password for inbound mail.' => 'Mot de passe pour mail entrant.',
        'Result of mail configuration check' => 'Résultat du contrôle de configuration mail',
        'Check mail configuration' => 'Vérifier la configuration mail',
        'Skip this step' => 'Passer cette étape',

        # Template: InstallerDBResult
        'Done' => 'Fait',
        'Error' => 'Erreur',
        'Database setup successful!' => 'Mise en place Base de données réussie!',

        # Template: InstallerDBStart
        'Install Type' => 'Type d\'installation',
        'Create a new database for OTOBO' => 'Créer une nouvelle base de données pour OTOBO',
        'Use an existing database for OTOBO' => 'Utiliser une base de données existante pour OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Si vous avez défini un mot de passe root pour votre base de données, il doit être indiqué ici. Sinon, laissez ce champ vide.',
        'Database name' => 'Nom de la base de données',
        'Check database settings' => 'Vérifier la configuration base de données',
        'Result of database check' => 'Résultat du contrôle de la base de données',
        'Database check successful.' => 'Contrôle de base de donnée effectué avec succès.',
        'Database User' => 'Utilisateur de la base de données',
        'New' => 'Nouveau',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Un nouvel utilisateur de la base de données sera créé avec des droits limités pour ce système OTOBO.',
        'Generated password' => 'Mot de passe généré',
        'Repeat Password' => 'Répétez le mot de passe',
        'Passwords do not match' => 'Les mots de passe ne correspondent pas',

        # Template: InstallerFinish
        'Start page' => 'Page de démarrage',
        'Your OTOBO Team' => 'Votre Équipe OTOBO',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Ne pas accepter la licence',
        'Accept license and continue' => 'Accepter la licence et continuer',

        # Template: InstallerSystem
        'SystemID' => 'ID Système',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identifiant du système. Chaque numéro de ticket et session HTTP contiennent ce numéro.',
        'HTTP Type' => '',
        'Set the request scheme used for cookies and various links. For production purposes always use https.' =>
            '',
        'System FQDN' => 'FQDN du système',
        'Fully qualified domain name of your system.' => 'Nom de domaine pleinement qualifié de votre système.',
        'AdminEmail' => 'E-mail administrateur',
        'Email address of the system administrator.' => 'Adresse e-mail de l\'administrateur système.',
        'Organization' => 'Société',
        'Log' => 'Journal',
        'LogModule' => 'Module de journalisation',
        'Log backend to use.' => 'Moteur de journalisation à utiliser.',
        'LogFile' => 'Fichier de log',
        'Webfrontend' => 'Frontal web',
        'Default language' => 'Langue par défaut',
        'Default language.' => 'Langue par défaut.',
        'CheckMXRecord' => 'Vérifier les enregistrements MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Les adresses emails entrées manuellement sont contrevérifiées avec les enregistrements message du serveur de nom de domaine. N\'utilisez pas cette option si votre serveur de nom de domaine est lent ou qu\'il ne résout pas les adresses publiques.',
        'Elasticsearch' => '',
        'Initialize Elasticsearch' => '',
        'Elasticsearch server was found, and it has been activated automatically for OTOBO.' =>
            '',
        'Seemingly either no clean Elasticsearch server is running, or it is not using the standard configuration. To activate Elasticsearch manually, please edit the web service in the admin interface if necessary, activate \'Elasticsearch::Active\' and \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in the SysConfig and run the otobo.Console command \'Maint::Elasticsearch::Migration\'.' =>
            '',

        # Template: LinkObject
        'Delete link' => 'Supprimer le lien',
        'Delete Link' => 'Supprimer le lien',
        'Object#' => 'N° Objet',
        'Add links' => 'Ajouter des liens',
        'Delete links' => 'Supprimer les liens',

        # Template: Login
        'Lost your password?' => 'Mot de passe oublié ?',
        'Back to login' => 'Retour à la page de connexion',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => 'Ouvrir le lien dans un nouvel onglet',
        'Close preview' => 'Fermer l\'aperçu',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: Copy
        'Start migration' => '',
        'Result of data migration' => '',
        'Last successful task:' => '',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            '',
        'Clean up and finish' => '',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            '',
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Pour pouvoir utiliser OTOBO, vous devez entrer les commandes suivantes dans votre terminal en tant que root.',
        'Restart your webserver' => 'Redémarrer votre serveur web',
        'After doing so your OTOBO is up and running.' => 'Après avoir fait ceci votre OTOBO est en service',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            '',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            '',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            '',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            '',
        'All entered passwords are cached until the migration is finished.' =>
            '',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            '',
        'If you need support, just ask our experts – either at' => '',
        'OTOBO forum' => '',
        'or directly via mail to' => '',
        'Cached data found' => '',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            '',
        'An error occured.' => '',
        'Discard previous progress' => '',
        'Insecure HTTP connection' => '',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            '',
        'Continue anyways :(' => '',
        ' Continue anyways :(' => '',

        # Template: OTRSDBSettings
        'DSN' => '',
        'Skip DB migration' => '',
        'Expert option! Only works if the migration has already been done by hand.' =>
            '',
        'Skipped.' => '',

        # Template: OTRSFileSettings
        'OTRS server' => '',
        'SSH User' => '',
        'OTRS home directory' => '',
        'Check settings' => '',
        'Result of settings check' => '',
        'Settings check successful.' => '',

        # Template: PreChecks
        'Execute migration pre-checks' => '',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Fonctionnalité non disponible',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Désolé mais cette fonctionnalité d\'OTOBO n\'est actuellement pas disponible pour les appareils mobiles. Si vous le souhaitez, vous pouvez toutefois basculer en mode version pour ordinateur ou utiliser votre ordinateur de bureau.',

        # Template: Motd
        'Message of the Day' => 'Message du jour',
        'This is the message of the day. You can edit this in %s.' => 'Voici le message du jour. Il peut être édité dans %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Droits insuffisants',
        'Back to the previous page' => 'Revenir à la page précédente',

        # Template: Alert
        'Alert' => 'Attention',
        'Powered by' => 'Fonction assurée par',

        # Template: Pagination
        'Show first page' => 'Montrer la première page',
        'Show previous pages' => 'Montrer les pages précédentes',
        'Show page %s' => 'Montrer la page %s',
        'Show next pages' => 'Montrer les pages suivantes',
        'Show last page' => 'Montrer la dernière page',

        # Template: PictureUpload
        'Need FormID!' => 'Vous devez posséder un formulaire d\'identification.',
        'No file found!' => 'Aucun fichier trouvé !',
        'The file is not an image that can be shown inline!' => 'Le fichier n\'est pas une image qui puisse être affichée directement !',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Aucune notification paramétrable disponible.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Recevoir les messages d\'information \' %s\' par la méthode \' %s \'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Traitement de l\'nformation',
        'Dialog' => 'Discussion',

        # Template: Article
        'Inform Agent' => 'Informer l\'opérateur',

        # Template: PublicDefault
        'Welcome' => 'Bienvenue',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Voici l\'interface publique par défaut d\'OTOBO! Aucun paramètre n\'a été enregistré. ',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Il est possible d\'installer un module customisable (via le gestionnaire de paquets), par exemple le module FAQ, qui a une interface publique.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissions',
        'You can select one or more groups to define access for different agents.' =>
            'Afin de donner des accès à différents opérateurs, sélectionnez un ou plusieurs groupes.',
        'Result formats' => 'Formats de résultat',
        'Time Zone' => 'Fuseau horaire',
        'The selected time periods in the statistic are time zone neutral.' =>
            '',
        'Create summation row' => '',
        'Generate an additional row containing sums for all data rows.' =>
            'Génère une ligne supplémentaire contenant la somme de toutes les lignes de données.',
        'Create summation column' => '',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => '',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'If set to invalid end users can not generate the stat.' => 'Si mis à "non valide", les utilisateurs finaux ne pourront pas générer la statistique.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Il y a des problèmes dans la configuration de ces statistiques.',
        'You may now configure the X-axis of your statistic.' => 'Vous pouvez maintenant configurer l’abscisse de votre tableau.',
        'This statistic does not provide preview data.' => '',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'A noter que l\'aperçu prend des données au hasard et ne tient pas compte des filtres.',
        'Configure X-Axis' => 'Configure l\'axe X',
        'X-axis' => 'Axe X',
        'Configure Y-Axis' => 'Configure l\'axe Y',
        'Y-axis' => 'Axe Y',
        'Configure Filter' => 'Configure le filtre',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Sélectionnez un seul élément ou désactivez le bouton \'Fixé\'',
        'Absolute period' => 'Période absolue',
        'Between %s and %s' => 'Entre %s et %s',
        'Relative period' => 'Période relative',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            '',

        # Template: StatsParamsWidget
        'Exchange Axis' => 'Échangez les axes',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Aucun élément sélectionné.',
        'Scale' => 'Échelle',
        'show more' => 'Afficher plus',
        'show less' => 'Afficher moins',

        # Template: D3
        'Download SVG' => 'Télécharger SVG',
        'Download PNG' => 'Télécharger PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: StatsWidget
        'Remove statistic' => '',
        'If you don\'t specify a title here, the title of the statistic will be used.' =>
            '',
        'Preface' => '',
        'Postface' => '',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Ce paramètre est désactivé.',
        'This setting is fixed but not deployed yet!' => 'Ce paramètre est réparé mais pas encore déployé.',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => 'Basculer sur les options avancés pour ce paramètre',
        'Disable this setting, so it is no longer effective' => 'Désactive ce réglage pour qu\'il ne soit plus utilisé',
        'Disable' => 'Désactivé',
        'Enable this setting, so it becomes effective' => 'Active ce réglage afin qu\'il soit paramétrable',
        'Enable' => 'Activé',
        'Reset this setting to its default state' => 'Réinitialise ce paramètre à sa valeur par défaut',
        'Reset setting' => 'Réinitialiser le paramètre',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Autoriser les utilisateurs à régler ce paramètre depuis leurs préférences.',
        'Allow users to update' => 'Autoriser les utilisateurs à faire les mises à jour',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Ne pas autoriser les utilisateurs à régler ce paramètre depuis leurs préférences.',
        'Forbid users to update' => 'Interdire les utilisateurs a effectuer les mises à jour',
        'Show user specific changes for this setting' => 'Afficher les paramètres utilisateur pour ce réglage',
        'Show user settings' => 'Afficher les paramètres utilisateurs',
        'Copy a direct link to this setting to your clipboard' => 'Créé un lien direct vers ce réglage sur votre tableau de bord',
        'Copy direct link' => 'Créé un lien direct ',
        'Remove this setting from your favorites setting' => 'Supprime ce réglage de vos paramètres favoris',
        'Remove from favourites' => 'Supprime de vos favoris',
        'Add this setting to your favorites' => 'Ajoute ce réglage à vos favoris',
        'Add to favourites' => 'Ajouter aux favoris',
        'Cancel editing this setting' => 'Annuler l\'édition de ce paramètre',
        'Save changes on this setting' => 'Sauvegarder les changements',
        'Edit this setting' => 'Editer ce réglage',
        'Enable this setting' => 'Activer ce réglage',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => 'Maintenant',
        'User modification' => 'Modification de l\'utilisateur',
        'enabled' => 'Activé',
        'disabled' => 'Désactivé',
        'Setting state' => 'État du réglage',

        # Template: Actions
        'Edit search' => 'Éditer la recherche',
        'Go back to admin: ' => 'Retour à l\'administration:',
        'Deployment' => 'Déploiement',
        'My favourite settings' => 'Mes réglages préférés',
        'Invalid settings' => 'Réglages incorrects',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtrer les réglages affichés',
        'Enable edit mode for all settings' => 'Activer le mode édition pour tous les réglages',
        'Save all edited settings' => 'Sauvegarder tous les réglages ',
        'Cancel editing for all settings' => 'Annuler toutes les modifications',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => 'En cours d\'édition par moi',
        'Modified but not yet deployed.' => 'Modifié mais pas encore déployé',
        'Currently edited by another user.' => 'En cours d\'édition par un autre utilisateur.',
        'Different from its default value.' => 'Différent de sa valeur par défaut.',
        'Save current setting.' => 'Sauvegarder les réglages actuels.',
        'Cancel editing current setting.' => 'Annuler la modification en cours',

        # Template: Navigation
        'Navigation' => 'Navigation',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'Page de test d\'OTOBO',
        'Unlock' => 'Déverrouiller',
        'Welcome %s %s' => 'Bienvenue %s %s  ',
        'Counter' => 'Compteur',

        # Template: TranslationsTable
        'Filter Content' => '',
        'Filter for Translations' => '',
        'No content available to translate.' => '',

        # Template: Warning
        'Go back to the previous page' => 'Revenir à la page précédente',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Afficher',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Projet de titre',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Affichage article',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Voulez-vous vraiment supprimer "%s" ?',
        'Confirm' => 'Confirmer',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Chargement, merci de patienter...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Cliquer pour sélectionner un fichier à télécharger.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Cliquer pour sélectionner des fichiers ou les glisser-déposer ici.',
        'Click to select a file or just drop it here.' => 'Cliquer pour sélectionner un fichier ou le glisser-déposer ici.',
        'Uploading...' => 'Chargement...',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => 'État du processus',
        'Running' => 'En cours',
        'Finished' => 'Fini',
        'No package information available.' => 'Aucune information disponible sur ce paquet',

        # JS Template: AddButton
        'Add new entry' => 'Ajouter une nouvelle entrée',

        # JS Template: AddHashKey
        'Add key' => 'Ajouter une clé',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Commentaire de déploiement...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => 'En cours de déploiement, veuillez patienter...',
        'Preparing to deploy, please wait...' => 'Préparation au déploiement, veuillez patienter...',
        'Deploy now' => 'Déployer maintenant',
        'Try again' => 'Nouvel essai',

        # JS Template: DialogReset
        'Reset options' => 'Réinitialiser les options',
        'Reset setting on global level.' => 'Réinitialiser les options sur un niveau global.',
        'Reset globally' => 'Réinitialisation générale',
        'Remove all user changes.' => 'Supprimer toutes les modifications effectuées par les utilisateurs.',
        'Reset locally' => 'Réinitialiser localement',
        'user(s) have modified this setting.' => 'un ou des utilisateur(s) a/ont modifié ce réglage.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Voulez-vous vraiment réinitialiser ce réglage à sa valeur par défaut?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'Codes client (Groupe)',
        'Fax' => 'Fax',
        'Street' => 'Rue',
        'Zip' => 'Code postal',
        'City' => 'Ville',
        'Country' => 'Pays',
        'Mr.' => 'M.',
        'Mrs.' => 'Mme',
        'Manager' => '',
        'Address' => 'Adresse',
        'View system log messages.' => 'Voir les messages du journal système.',
        'Edit the system configuration settings.' => 'Modifier la configuration du système.',
        'Update and extend your system with software packages.' => 'Mettre à jour et améliorer OTOBO via des paquets.',

        # Perl Module: Kernel/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Les ACL de la base de données ne sont pas synchrones avec la configuration système. Veuillez synchroniser tous les ACL.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Ensemble de ACL ne peut pas être importé dû à un erreur inconnu, veuillez vérifier le journal de OTOBO pour plus d\'information.',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'There was an error creating the ACL' => 'Une erreur a été rencontrée en créant cette ACL',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => 'Une erreur a été rencontrée en mettant à jour cette ACL',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Correspondance exacte',
        'Negated exact match' => '',
        'Regular expression' => 'Expression régulière',
        'Regular expression (ignore case)' => 'Expression régulière (ignore la casse)',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminAbout.pm
        'Could not update About message!' => '',
        'About message updated!' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Le calendrier n\'a pas pu être créé!',
        'Please contact the administrator.' => 'Merci de contacter votre administrateur.',
        'No CalendarID!' => 'Pas de ID calendrier!',
        'You have no access to this calendar!' => 'Vous n\'avez pas accès à ce calendrier!',
        'Error updating the calendar!' => 'Une erreur est survenu pendant la mise à jour du calendrier!',
        'Couldn\'t read calendar configuration file.' => 'Impossible de lire le fichier de configuration du calendrier.',
        'Please make sure your file is valid.' => 'Veuillez vérifier que le fichier est valide.',
        'Could not import the calendar!' => 'Impossible d\'importer le calendrier!',
        'Calendar imported!' => 'Calendrier importé!',
        'Need CalendarID!' => 'ID du calendrier demandé.',
        'Could not retrieve data for given CalendarID' => 'Impossible de retrouver les données du calendrier donné',
        'Successfully imported %s appointment(s) to calendar %s.' => '',
        '+5 minutes' => '+5 minutes',
        '+15 minutes' => '+15 minutes',
        '+30 minutes' => '+30 minutes',
        '+1 hour' => '+1 heure',
        '+1 day' => '',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Aucune permission',
        'System was unable to import file!' => 'L\'importation a échoué!',
        'Please check the log for more information.' => 'Merci de lire les journaux pour plus d\'informations.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Ce nom de notification existe déjà!',
        'Notification added!' => 'Notification ajoutée!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Une erreur est survenue en récupérant le contenu de la notification dont l\'ID est: %s !',
        'Unknown Notification %s!' => 'Notification inconnue %s !',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Une erreur est survenue pendant la création de la notification',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Ensemble de notification ne peut pas être importé dû a un erreur, veuillez vérifier les journaux de OTOBO pour plus d\'information.',
        'The following Notifications have been added successfully: %s' =>
            'Les notifications suivantes ont bien été ajoutées. %s',
        'The following Notifications have been updated successfully: %s' =>
            'Les notifications suivantes ont bien été mises à jour. %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Notification updated!' => 'Notification mise à jour!',
        'Agent (resources), who are selected within the appointment' => '',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '',
        'All agents with write permission for the appointment (calendar)' =>
            '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'No permission to edit this attachment.' => '',
        'Attachment added!' => 'Pièce jointe ajoutée!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Réponse auto ajoutée!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'ID de communication incorrect!',
        'All communications' => 'Toutes les communications',
        'Last 1 hour' => 'La dernière heure',
        'Last 3 hours' => 'Les 3 dernières heures',
        'Last 6 hours' => 'Les 6 dernières heures',
        'Last 12 hours' => 'Les 12 dernières heures',
        'Last 24 hours' => 'Les 24 dernières heures',
        'Last week' => 'La semaine dernière',
        'Last month' => 'Le mois dernier',
        'Invalid StartTime: %s!' => 'Heure de début incorrecte: %s !',
        'Successful' => 'Validé',
        'Processing' => 'En cours',
        'Invalid Filter: %s!' => 'Filtre incorrecte: %s !',
        'Less than a second' => 'Moins d\'une seconde',
        'sorted descending' => 'Tri descendant',
        'sorted ascending' => 'Tri ascendant',
        'Trace' => 'Trace',
        'Debug' => 'Débogage',
        'Info' => 'Information',
        'Warn' => 'Attention',
        'days' => 'jours',
        'day' => 'jour',
        'hour' => 'heure',
        'minute' => 'minute',
        'seconds' => 'secondes',
        'second' => 'seconde',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => '',
        'No data found for given contact in given source!' => '',
        'Contact updated!' => '',
        'No field data found!' => '',
        'Contact created!' => '',
        'Error creating contact!' => '',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            '',
        'No data found for given source!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerAccept.pm
        'Could not update Privacy Policy!' => '',
        'Privacy Policy updated!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Entreprise du client mise à jour !',
        'Dynamic field %s not found!' => 'Domaine dynamique %s introuvable!',
        'Unable to set value for dynamic field %s!' => 'Impossible de régler la valeur du domaine dynamique %s !',
        'Customer Company %s already exists!' => '',
        'Customer company added!' => 'Entreprise du client ajoutée !',

        # Perl Module: Kernel/Modules/AdminCustomerDashboardInfoTile.pm
        'Start date shouldn\'t be defined after Stop date!' => '',
        'Name is missing!' => '',
        'Content is missing!' => '',
        'ValidID is missing!' => '',
        'Group is missing!' => '',
        'There was an error creating the info tile entry' => '',
        'Need ID!' => '',
        'This Entry does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Could not get data for ID %s' => '',
        'Info tile entry was added successfully!' => '',
        'Info tile entry was updated successfully!' => '',
        'Session has been killed!' => 'La session a été interrompue !',
        'All sessions have been killed, except for your own.' => 'Toutes les sessions ont été détruites, exceptée la vôtre. ',
        'There was an error updating the info tile entry' => '',
        'It was not possible to delete the info tile entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Client mis à jour!',
        'New phone ticket' => 'Nouveau ticket par téléphone',
        'New email ticket' => 'Nouveau ticket par e-mail',
        'Customer %s added' => 'Client %s ajouté',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'Add %s field' => '',
        'The field must be numeric.' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'Change %s field' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => '',
        'Checked' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'Syntax is incorrect. Please provide a parent element name in front of the double colon.' =>
            '',
        'An element is used as parent element, but not included itself. Please include it.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldLens.pm
        'The referenced dynamic field' => '',
        'Select the dynamic field that references an object' => '',
        'The attribute of the referenced object' => '',
        'Select the attribute dynamic field that references an object' =>
            '',
        'Not a valid dynamic field.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to reset the setting!' => '',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScript.pm
        'Need valid field driver.' => '',
        'Bad value in RequiredArgs.' => '',
        'Bad value in PreviewTriggers.' => '',
        'Bad value in StorageTriggers.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldSet.pm
        'Missing Dynamic Field.' => '',
        'No valid dynamic field "%s."' => '',
        'The dynamic field type "%s" of dynamic field "%s" can not be used in sets.' =>
            '',
        'The dynamic field "%s" is already in use in a ticket mask.' => '',
        'Misconfigured Grid - need Rows as Array!' => '',
        'Misconfigured Grid - need Columns as integer > 0!' => '',
        'Misconfigured Grid - Rows can\'t be empty!' => '',
        'Misconfigured Grid - Rows must contain entries with key \'DF\'!' =>
            '',
        'Missing Dynamic Field or Grid.' => '',
        'The field must be a valid YAML containing an array of dynamic fields.' =>
            '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minute(s)',
        'hour(s)' => 'heure(s)',
        'Time unit' => 'Unité de temps',
        'within the last ...' => 'dans les dernier(e)s',
        'within the next ...' => 'dans les prochain(e)s',
        'more than ... ago' => 'il y a plus de ...',
        'Unarchived tickets' => 'Tickets non archivés',
        'archive tickets' => '',
        'restore tickets from archive' => '',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',
        'ascending' => 'ascendant',
        'descending' => 'descendant',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => '',
        'Operation deleted' => 'Opération supprimée',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 minutes',
        '15 minutes' => '15 minutes',
        '30 minutes' => '',
        '1 hour' => '1 heure',
        '2 hours' => '2 heures',
        '3 hours' => '3 heures',
        '4 hours' => '4 heures',
        '5 hours' => '5 heures',
        '6 hours' => '6 heures',
        '12 hours' => '12 heures',
        '18 hours' => '18 heures',
        '1 day' => '1 jour',
        '2 days' => '2 jours',
        '3 days' => '3 jours',
        '4 days' => '4 jours',
        '6 days' => '6 jours',
        '1 week' => '1 semaine',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => '',
        'InvokerType %s is not registered' => 'InvokerType %s n\'est pas enregistré',
        'MappingType %s is not registered' => 'MappingType %s n\'est pas enregistré',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => 'L\'événement %s n\'est pas valide.',
        'Could not update configuration data for WebserviceID %s' => '',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => '',
        'Regexp' => '',
        'Validation Module' => 'Module de validation',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerTicket.pm
        'Invisible only' => 'Seulement invisible',
        'Visible only' => 'seulement visible',
        'Visible and invisible' => 'visible et invisible',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Keep (leave unchanged)' => '',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => 'Valeur(s) exacte',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => '',
        'OperationType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => 'Fichier ou dossier non trouvé.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Il y a un autre service web avec le même nom.',
        'There was an error updating the web service.' => 'Il y a eu une erreur en mettant à jour le service web.',
        'There was an error creating the web service.' => 'Il y a eu une erreur en créant le service web.',
        'Web service "%s" created!' => 'Le service web "%s" a été créé !',
        'Need Name!' => 'Nom requis !',
        'Need ExampleWebService!' => '',
        'Could not load %s.' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => 'Besoin d\'importer un fichier !',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'Le contenu du fichier importé n\'est pas en format "YAML" valide. Veuillez vérifier le journal de OTOBO pour des détails',
        'Web service "%s" deleted!' => 'Le service web "%s" a été supprimé !',
        'OTOBO as provider' => 'OTOBO, fournisseur',
        'Operations' => '',
        'OTOBO as requester' => 'OTOBO, demandeur',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Groupe ajouté!',

        # Perl Module: Kernel/Modules/AdminImportExport.pm
        'No object backend found!' => 'Aucun objet "backend" n\'a été trouvé !',
        'No format backend found!' => 'Aucun format "backend" n\'a été trouvé !',
        'Template not found!' => 'Modèle non trouvé !',
        'Can\'t insert/update template!' => 'Impossible d\'insérer ou mettre à jour le modèle !',
        'Needed TemplateID!' => 'L\'ID du modèle est requis !',
        'Error occurred. Import impossible! See Syslog for details.' => 'Une erreur est survenue, importation impossible ! Pour plus de détails, consultez le journal d’événements système.',
        'Error occurred. Export impossible! See Syslog for details.' => 'Une erreur est survenue, exportation impossible ! Pour plus de détails, consultez le journal d’événements système.',
        'Template List' => 'Liste des modèles',
        'number' => 'nombre',
        'number bigger than zero' => 'nombre plus grand que zéro',
        'integer' => 'entier',
        'integer bigger than zero' => 'entier plus grand que zéro',
        'Element required, please insert data' => 'Élément requis, veuillez entrer des données',
        'Invalid data, please insert a valid %s' => 'Données invalides. Veuillez insérer une %s valide',
        'Format not found!' => 'Format non trouvé !',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Compte de messagerie ajouté !',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Répartition par le champ \'À:\' de l\'e-mail',
        'Dispatching by selected Queue.' => 'Répartition selon la file sélectionnée',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'No permission to edit this ticket notification.' => '',
        'You need %s permissions!' => '',
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'L\'agent qui est propriétaire du ticket',
        'Agent who is responsible for the ticket' => 'L\'agent qui est responsable du ticket',
        'All agents watching the ticket' => 'Tous les agents en observation du ticket',
        'All agents with write permission for the ticket' => 'Tous les agents avec le droit d\'écriture pour le ticket',
        'All agents subscribed to the ticket\'s queue' => 'Tous les agents souscrits à la file de tickets',
        'All agents subscribed to the ticket\'s service' => 'Tous les agents souscrits au service des tickets',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Tous les agents souscrits à la file et service des tickets',
        'Customer user of the ticket' => 'Utilisateur client du ticket',
        'All recipients of the first article' => 'Tous les destinataires du premier article',
        'All recipients of the last article' => 'Tous les destinataires du dernier article',
        'Only send within working hours' => '',
        'Only send outside working hours' => '',
        'Invisible to customer' => 'Invisible par client',
        'Visible to customer' => 'Visible par le client',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'L\'environnement PGP ne fonctionne pas. Allez voir les logs pour plus d\'informations !',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => '',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'No such package!' => '',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => '',
        'File is OK' => 'Le fichier est OK',
        'Package has locally modified files.' => 'Le paquet a localement modifié les fichiers.',
        'Package not verified by the OTOBO Team!' => 'Le paquet n\'a pas été vérifié par l\'équipe OTOBO !',
        'Not Started' => 'Pas commencé',
        'Updated' => 'Mis à jour',
        'Already up-to-date' => 'Déjà à jour',
        'Installed' => 'Installé',
        'Not correctly deployed' => 'Pas correctement déployé',
        'Package updated correctly' => 'Le paquet a été mis à jour avec succès',
        'Package was already updated' => 'Le paquet a déjà été mis à jour',
        'Dependency installed correctly' => 'Les dépendances ont été installés correctement',
        'The package needs to be reinstalled' => 'Le paquet a besoin d\'être ré-installé',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => 'La version requise est plus élevé que celle disponible',
        'Dependencies fail to upgrade or install' => 'Les dépendances n\'ont pas pu être mises à jour ou installées',
        'Package could not be installed' => 'Le paquet pourrait ne pas installé',
        'Package could not be upgraded' => 'Le paquet pourrait ne pas être mis à jour',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Le paquet n\'a pas été vérifié à cause d\'un problème de communication avec le serveur de vérification !',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '',
        'Can\'t get OTOBO Feature Add-on list from server!' => '',
        'Can\'t get OTOBO Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Pas de filtre : %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Priorité ajoutée !',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Les informations de Gestion de Processus de la base de données ne sont pas synchrones avec la configurations système. Veuillez synchroniser tous les processus.',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => 'Le %s : %s est encore utilisé',
        'The %s:%s has a different EntityID' => 'Le %s : %s a un EntityID différent',
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => 'ActivityID requis !',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => 'Activité non trouvée !',
        'ActivityDialog not found!' => 'ActivityDialog non trouvé !',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog déjà assigné à une Activité. Vous ne pouvez pas ajouter un ActivityDialog 2 fois !',
        'Error while saving the Activity to the database!' => 'Erreur durant la sauvegarde de l\'Activité dans la base de données !',
        'This subaction is not valid' => '',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => 'Montrez le champ',
        'Show Field As Mandatory' => 'Montrez le champ comme obligatoire',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Editez le chemin',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => 'TransitionActionID requis !',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'File mise à jour !',
        'Don\'t use :: in queue name!' => 'Ne pas utiliser :: dans un nom de file !',
        'Click back and change it!' => '',
        '-none-' => '-aucun-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Files (sans réponses automatiques)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Production',
        'Test' => '',
        'Training' => 'Formation',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminResponseTemplatesStatePreselection.pm
        'Template updated!' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Rôle mis à jour!',
        'Role added!' => 'Rôle ajouté!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Modifier les relations des groupes pour le rôle',
        'Change Role Relations for Group' => 'Modifier les relations des rôles pour un groupe',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rôle',
        'Change Role Relations for Agent' => 'Changer les rôles pour un opérateur',
        'Change Agent Relations for Role' => 'Changer les opérateurs pour un rôle ',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Merci d\'activer %s en premier lieu',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Salutation ajoutée !',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Signature mise à jour!',
        'Signature added!' => 'Signature ajoutée!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'État ajouté!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Adresse e-mail système ajoutée !',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Paramètres invalides',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Importation non permis!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'System was unable to update setting!' => '',
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'System was not able to lock the setting!' => '',
        'Missing setting name.' => 'Nom du paramètre manquant.',
        'Setting not found.' => 'Paramètre non trouvé.',
        'Missing Settings!' => 'Paramètres manquant !',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => '',
        'Modified Version' => '',
        'Reset To Default' => '',
        'Default Version' => '',
        'No setting name or modified version id received!' => '',
        'Was not possible to revert the historical value!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => '',
        'System was not able to delete the user setting values!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'No permission to edit this template.' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '',
        'Change Template Relations for Attachment' => '',

        # Perl Module: Kernel/Modules/AdminTranslations.pm
        'Translation unmarked for deletion!' => '',
        'Error trying unmark translation for delete!' => '',
        'Translations changed!' => '',
        'No translations were changed!' => '',
        'Errors trying to change translations!' => '',
        'Translations added!' => '',
        'No translations were given to add!' => '',
        'Translation already exists!' => '',
        'Translations deployed successfuly!' => '',
        'Nothing to do!' => '',
        'Errors ocurred when trying to deploy translation. Please check system logs!' =>
            '',
        'All Items' => '',
        'Deployment Results' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Type ajouté !',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Information de l\'opérateur mises à jour !',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Changer les relations de groupe pour l\'opérateur : ',
        'Change Agent Relations for Group' => 'Changer les relations avec les opérateurs pour le groupe : ',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mois',
        'Week' => 'Semaine',
        'Day' => 'Jour',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Tous les rendez-vous',
        'Appointments assigned to me' => 'Tous les rendez-vous qui me sont assignés',
        'Showing only appointments assigned to you! Change settings' => 'Montrez seulement les rendez-vous qui me sont assignés ! Changement des paramètres',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Rendez-vous non trouvé !',
        'Never' => 'Jamais',
        'Every Day' => 'Chaque jour',
        'Every Week' => 'Chaque semaine',
        'Every Month' => 'Chaque mois',
        'Every Year' => 'Chaque année',
        'Custom' => '',
        'Daily' => 'Quotidien',
        'Weekly' => 'Hebdomadaire',
        'Monthly' => 'Mensuel',
        'Yearly' => 'Annuel',
        'every' => 'chaque',
        'for %s time(s)' => '',
        'until ...' => 'jusqu\'à ...',
        'for ... time(s)' => '',
        'until %s' => 'jusqu\'à %s',
        'No notification' => 'Pas de notification',
        '%s minute(s) before' => '%s minute(s) avant',
        '%s hour(s) before' => '%s hour(s) avant',
        '%s day(s) before' => '%s day(s) avant',
        '%s week before' => '%s semaine avant',
        'before the appointment starts' => 'avant que le rendez-vous commence',
        'after the appointment has been started' => 'après que le rendez-vous soit commencé',
        'before the appointment ends' => 'avant que le rendez-vous se termine',
        'after the appointment has been ended' => 'après que le rendez-vous soit terminé',
        'No permission!' => 'Pas les droits !',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => 'Pas les droits !',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Historique Client',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => '',
        'No preferences for %s!' => 'Pas de préférences pour %s !',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => 'Nom du Client',
        'Customer User Name' => 'Nom d\'utilisateur du client',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'SourceObject et SourceKey requis !',
        'You need ro permission!' => 'Vous avez besoin du droit de lecture !',
        'Can not delete link with %s!' => 'Ne peut pas supprimer le lien avec %s !',
        '%s Link(s) deleted successfully.' => '%s Liens supprimés avec succès.',
        'Can not create link with %s! Object already linked as %s.' => 'Ne peut pas créer le lien avec %s ! L\'objet est déjà lié en tant que %s.',
        'Can not create link with %s!' => 'Ne peut pas créer le lien avec %s !',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => 'L\'objet %s ne peut pas être lié avec un autre objet !',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'This feature is not available.' => 'Cette fonctionnalité n\'est pas disponible.',
        'Updated user preferences' => 'Les préférences utilisateur mises à jour',
        'System was unable to deploy your changes.' => 'Le système n\'a pas été capable de déployer vos changements.',
        'Setting not found!' => 'Paramètre non trouvé !',
        'System was unable to reset the setting!' => 'Le système a été incapable de réinitialiser le paramètre !',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Le paramètre %s est manquant.',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => 'Statistique n\'a pas pu être importé.',
        'Please upload a valid statistic file.' => 'Ajoutez un fichier de statistique valide.',
        'Export: Need StatID!' => 'Export : StatID requis !',
        'Delete: Get no StatID!' => 'Supprimer : Pas de StatID !',
        'Need StatID!' => 'StatID requis !',
        'Could not load stat.' => '',
        'Add New Statistic' => 'Ajout une nouvelle statistique',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentStatisticsReports.pm
        'Got no %s!' => '',
        'Add New Statistics Report' => '',
        'This name is already in use, please choose a different one.' => '',
        'Could not create report.' => '',
        'Need StatsReportID!' => '',
        'Edit Statistics Report' => '',
        'Could not find report.' => '',
        'Please provide a valid cron entry.' => '',
        'Could not update report.' => '',
        'View Statistics Report' => '',
        'Delete: Got no StatsReportID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Désolé, vous devez être le propriétaire du ticket pour effectuer cette action.',
        'Please change the owner first.' => 'D\'abord, veuillez modifier le propriétaire.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Pas de sujet',
        'Could not delete draft!' => 'Impossible de supprimer le brouillon !',
        'Previous Owner' => 'Propriétaire Précédent',
        'wrote' => 'a écrit',
        'Message from' => 'Message de',
        'End message' => 'Fin du message',

        # Perl Module: Kernel/Modules/AgentTicketArticleEdit.pm
        'No ArticleID is given!' => 'Aucun ArticleID donné !',

        # Perl Module: Kernel/Modules/AgentTicketArticleStatus.pm
        'Can\'t set this Ticket option, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => 'Impossible d\'envoyer le mail !',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Impossible de bloquer les tickets, aucun TicketIDs fournis !',
        'Ticket (%s) is not unlocked!' => 'Ticket (%s) n\'est pas débloqué !',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Les tickets suivants ont été ignorés parce qu\'ils sont bloqués par un autre agent ou vous n\'avez pas l\'accès en écriture aux tickets : %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'Le ticket suivant a été ignoré parce qu\'il a été bloqué par un autre agent ou vous n\'avez pas les droits d\'écriture sur le ticket : %s.',
        'You need to select at least one ticket.' => 'Vous devez sélectionner au moins un ticket.',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Les tickets suivants ont été ignorés parce qu\'ils sont bloqués par un autre agent ou vous n\'avez pas l\'accès en écriture aux tickets : %s.',
        'The following tickets were locked: %s.' => 'Les tickets suivants ont été bloqués : %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Adresse %s remplacée par celle du client enregistré.',
        'Customer user automatically added in Cc.' => 'Client ajouté automatiquement en Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Le ticket %s a été créé !',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => 'Erreur du système !',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Semaine prochaine',
        'Ticket Escalation View' => 'Vue des remontées du ticket',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'L\'article %s n\'a pas été trouvé !',
        'Forwarded message from' => 'Message transféré par',
        'End forwarded message' => 'Fin du message tranféré',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Impossible de monter l\'historique, aucun TicketID fourni !',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => 'Désolé, le propriétaire actuel est %s !',
        'Please become the owner first.' => 'Devenez le premier propriétaire.',
        'Ticket (ID=%s) is locked by %s!' => 'Le ticket (ID=%s) est bloqué par %s !',
        'Change the owner!' => 'Changement du propriétaire !',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nouvel Article',
        'Pending' => 'En attente',
        'Reminder Reached' => 'Rappel',
        'My Locked Tickets' => 'Mes tickets verrouillés',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Impossible de fusionner le ticket avec lui-même !',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Le tchat n\'est pas actif.',
        'No permission.' => 'Pas de droits.',
        '%s has left the chat.' => '%s a quitté le tchat.',
        'This chat has been closed and will be removed in %s hours.' => 'Ce tchat a été fermé et sera supprimé dans %s heures.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket verrouillé.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Aucun ArticleID !',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID requis !',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Impossible d\'obtenir ActivityDialogEntityID "%s" !',
        'No Process configured!' => '',
        'The selected process is invalid!' => 'Le processus sélectionné n\'est pas valide !',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => 'Le paramètre %s est manquant dans %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Pas de ActivityDialog configuré pour %s dans _RenderAjax !',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'En attendant la date',
        'for pending* states' => 'pour les états en attente*',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID manquant !',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => 'TicketID invalide : %s !',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Tickets Disponibles',
        'including subqueues' => 'sous-files incluses',
        'excluding subqueues' => 'sous-files excluses',
        'QueueView' => 'Vue file',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Tickets dont je suis responsable',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'dernière-recherche',
        'Untitled' => 'Sans titre',
        'Ticket Number' => 'Numéro de ticket',
        'Ticket' => 'Ticket',
        'printed by' => 'Imprimé par :',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => '',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'dans plus de ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Fonctionnalité non activée !',
        'Service View' => 'Vue par service',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Vue par statut',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mes tickets surveillés',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Fonctionnalité inactive',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Lien supprimé',
        'Ticket Locked' => 'Ticket verrouillé',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => 'Champ dynamique mis à jour',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Ticket créé',
        'Type Updated' => 'Type mis à jour',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Client mis à jour',
        'Internal Chat' => 'Messagerie interne',
        'Automatic Follow-Up Sent' => '',
        'Note Added' => 'Note ajoutée',
        'Note Added (Customer)' => 'Note ajoutée (Client)',
        'SMS Added' => 'SMS Ajouté',
        'SMS Added (Customer)' => 'SMS Ajouté (Client)',
        'State Updated' => 'Etat mis à jour',
        'Outgoing Answer' => '',
        'Service Updated' => 'Service mis à jour',
        'Link Added' => '',
        'Incoming Customer Email' => 'Mail client entrant',
        'Incoming Web Request' => 'Requête web entrante',
        'Priority Updated' => 'Priorité mise à jour',
        'Ticket Unlocked' => 'Ticket déverrouillé',
        'Outgoing Email' => 'Mail sortant',
        'Title Updated' => 'Titre mis à jou',
        'Ticket Merged' => 'Ticket fusionné',
        'Outgoing Phone Call' => 'Appel téléphonique sortant',
        'Forwarded Message' => 'Message transféré',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Appel téléphonique entrant',
        'System Request.' => '',
        'Incoming Follow-Up' => '',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'SLA mis à jour',
        'External Chat' => 'Messagerie externe',
        'Queue Changed' => '',
        'Notification Was Sent' => 'La notification a été envoyée',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Ce ticket n\'existe pas, ou vous n\'avez pas les droits pour y accéder dans son état actuel.',
        'Missing FormDraftID!' => 'FormDraftID manquant !',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Forward article via mail' => 'Transférer cet article par mail',
        'Forward' => 'Transférer',
        'Fields with no group' => 'Les champs sans groupe',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'L\'article ne peut être ouvert. Peut-être est-il déjà ouvert sur une autre page ?',
        'Show one article' => 'Montrer un article',
        'Show all articles' => 'Montrer tous les articles',
        'Show Ticket Timeline View' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerDashboardCommon.pm
        'Registration for tile %s of CustomerDashboard is invalid! Either Module or Template needed.' =>
            '',
        'Registration for tile %s of CustomerDashboard is invalid! Order needs to be a unique number.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerGenericContent.pm
        'Need Key!' => '',
        'Invalid Key!' => '',
        'Failed to load Content!' => '',
        'Destination unknown.' => '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID et ArticleID sont requis !',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'Mes Tickets',
        'Company Tickets' => 'Tickets de l\'entreprise',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Vrai nom du client',
        'Created within the last' => 'Créé dans les dernier(e)s',
        'Created more than ... ago' => 'Créé il y a plus de ...',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Could not load process module.' => '',
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => 'Créer un nouveau ticket !',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode est activé !',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => '',
        'Install OTOBO' => 'Installer OTOBO',
        'Intro' => 'Introduction',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Sélection de la base de donnée',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Entrer le mot de passe pour l\'utilisateur base de données',
        'Configure MySQL' => '',
        'Database %s' => 'Base de données %s',
        'Enter the password for the administrative database user.' => 'Entrer le mot de passe de l\'administrateur de la base de données',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Créer la base de données',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'Execution of SQL statement failed: ' => '',
        'https' => '',
        'http' => '',
        'System Settings' => 'Paramètres Système',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'Configurer Mail',
        'Mail Configuration' => 'Configuration de la messagerie',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'La base de données contient déjà des données - elle doit être vide !',
        'Error: database version requirement not satisfied. Have version: %s Want version: %s' =>
            '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => 'La migration de OTRS vers OTOBO',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => 'Calendrier invalide !',
        'Invalid URL!' => 'URL invalide !',
        'There was an error exporting the calendar!' => 'Il y a eu une erreur lors de l\'exportation du calendrier !',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Besoin de configurer Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Echec de l\'authentification à partir de %s !',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleDelete.pm
        'Delete this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleEdit.pm
        'Edit this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketArticleRestore.pm
        'Restore this article' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Faire suivre l\'article à une adresse mail différente',
        'Bounce' => 'Renvoyer',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Répondre à tous',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Ré-envoyer cet article',
        'Resend' => 'Ré-envoyer',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Répondre à une note',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Scinder cet article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Format texte',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Imprimer cet article',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at hello@otobo.de' => 'Contactez nous à hello@otobo.de',
        'Get Help' => 'Obtenir de l\'aide',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkArticleSeenUnseen.pm
        'Mark article as unseen' => '',
        'Mark as unseen' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Marquer comme important',
        'Unmark' => 'Ne pas marquer comme important',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypté',
        'Sent message encrypted to recipient!' => 'Envoyer un message chiffré au destinataire !',
        'Signed' => 'Signé',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        'Internal error during verification!' => '',
        'Impossible to decrypt: private key not found!' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => 'Chiffré',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'courriel sécurité',
        'PGP sign' => 'signature PGP',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => 'Chiffrement PGP',
        'SMIME sign' => 'Signature SMIME',
        'SMIME sign and encrypt' => 'Signature et chiffrement SMIME',
        'SMIME encrypt' => 'Chiffrement SMIME',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Ne peut utiliser une clé signée expirée: \'%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'Ne peut utiliser une clé signée révoquée: \'%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Il n\'y a aucunes clés signés disponible pour les adresses \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Il n\'y a pas de clés signées sélectionnées pour les adresses \'%s\'.',
        'Sign' => 'Signer',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Affiché(s)',
        'Refresh (minutes)' => 'Rafraichissement (minutes)',
        'off' => 'désactivé',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Utilisateurs clients affichés',
        'Offline' => 'Hors ligne',
        'User is currently offline.' => 'L\'utilisateur est actuellement hors-ligne.',
        'User is currently active.' => 'L\'utilisateur est actuellement en ligne.',
        'Away' => 'Absent',
        'User was inactive for a while.' => 'L\'utilisateur est resté inactif depuis un moment.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/MyLastChangedTickets.pm
        'Shown Tickets' => 'Tickets affichés',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Impossible de se connecter au serveur des nouvelles OTOBO !',
        'Can\'t get OTOBO News from server!' => 'Impossible d\'obtenir les nouvelles OTOBO à partir du serveur !',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Impossible de se connecter à %s !',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Columns' => 'Colonnes affcihées',
        'filter not active' => 'filtre non actif',
        'filter active' => 'filtre actif',
        'This ticket has no title or subject' => 'Ce ticket n\'a pas de titre ou sujet',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Stats sur 7 jours',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'L\'utilisateur a mis son statut en indisponible.',
        'Unavailable' => 'Indisponible',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => 'Les tickets suivants n\'ont pas été mis à jour : %s.',
        'h' => 'h',
        'm' => 'm',
        'd' => 'j',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Ce ticket n\'existe pas, ou vous n\'avez pas les droits d\'y accéder dans son état actuel. Vous pouvez prendre l\'une des actions suivantes :',
        'Year' => 'Année',
        'Hours' => 'Heures',
        'Minutes' => 'Minutes',
        'Check to activate this date' => 'Cochez pour activer cette date',
        '%s TB' => '%s To',
        '%s GB' => '%s Go',
        '%s MB' => '%s Mo',
        '%s KB' => '%s Ko',
        '%s B' => '%s o',
        'No Permission!' => 'Pas de permission !',
        'No Permission' => 'Pas de permission',
        'Show Tree Selection' => 'Afficher l\'Arbre de Sélection',
        'Split Quote' => '',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Lié en tant que',
        'Search Result' => 'Résultat de la recherche',
        'Linked' => 'Lié',
        'Bulk' => 'Actions groupées',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Allégée',
        'Unread article(s) available' => 'Article(s) non lu(s) disponible(s)',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Opérateurs en ligne: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Il y a d\'autres tickets remontés !',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Clients en ligne: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'La maintenance système est active !',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'La tâche de fond d\'OTOBO n\'est pas lancée',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Vous avez l\'Heure de sortie du travail\' activée, voulez-vous la désactiver?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Vous avez des paramètres non déployés, voulez-vous les déployer ?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'La configuration est en cours de mis à jour, soyez patient...',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'N\'utilisez pas le compte administrateur pour travailler avec %s ! Créer un nouvel opérateur et utilisez-le.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => 'Les préférences ont bien été mises à jour !',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Vérification du mot de passe',
        'The current password is not correct. Please try again!' => 'Le mot de passe actuel n\'est pas correct. Merci d\'essayer à nouveau!',
        'Please supply your new password!' => '',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossible de mettre à jour le mot de passe, il doit contenir au moins %s caractères !',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossible de mettre à jour le mot de passe, il doit contenir au moins 1 chiffre !',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Impossible de mettre à jour le mot de passe. Il doit contenir au moins 2 lettres !',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'non valide',
        'valid' => 'valide',
        'No (not supported)' => 'Non (non supporté)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => 'La date sélectionnée n\'est pas valide.',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => 'Sélectionner un élément pour l\'abscisse.',
        'You can only use one time element for the Y axis.' => 'Vous pouvez seulement sélectionner un seul élément à la fois pour l\'axe des ordonnées.',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => 'Sélectionnez une échelle de temps.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'seconde(s)',
        'quarter(s)' => 'trimestre(s)',
        'half-year(s)' => 'semestre(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => 'Réinitialiser ce paramètre à sa valeur par défaut.',
        'Unable to load %s!' => 'Incapable de charger %s !',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Déverrouiller et le remettre dans la file',
        'Lock it to work on it' => 'Le verrouiller afin de travailler dessus',

        # Perl Module: Kernel/Output/HTML/TicketMenu/ShowHideDeletedArticles.pm
        'Hide deleted articles' => '',
        'Click to hide deleted articles' => '',
        'Show deleted articles' => '',
        'Click to show deleted articles' => '',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Ne plus suivre',
        'Remove from list of watched tickets' => 'Enlever de la liste des tickets suivis',
        'Watch' => 'Suivre',
        'Add to list of watched tickets' => 'Ajouter à la liste des tickets suivis',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Trier par',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nouveaux tickets verrouillés',
        'Locked Tickets Reminder Reached' => 'Tickets verrouillés dont la date de rappel a été atteinte',
        'Locked Tickets Total' => 'Total des tickets verrouillés',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nouveaux tickets dont vous êtes responsable',
        'Responsible Tickets Reminder Reached' => 'Tickets dont vous êtes responsable et dont la date de rappel a été atteinte',
        'Responsible Tickets Total' => 'Total des tickets dont vous êtes responsable',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Nouveaux tickets que vous suivez',
        'Watched Tickets Reminder Reached' => 'Tickets suivis dont la date de rappel a été atteinte',
        'Watched Tickets Total' => 'Total des tickets suivis',

        # Perl Module: Kernel/Output/PDF/StatisticsReports.pm
        '%s Report' => '',
        'Error: this graph could not be generated: %s.' => '',
        'Table of Contents' => '',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Champs dynamiques des tickets',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Il n\'est actuellement pas possible de se connecter en raison d\'une maintenance planifiée du système.',

        # Perl Module: Kernel/System/Auth/OpenIDConnect.pm
        'Authentication error. Please contact the administrator.' => '',
        'Authentication error.' => '',
        'Invalid response from the authentication server. Maybe the process took too long. Please retry once.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'Please note that the session limit is almost reached.' => '',
        'Session limit reached! Please try again later.' => 'Limite de session atteinte. Veuillez réessayer ultérieurement',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Session non valide. Veuillez vous ré-authentifier.',
        'Session has timed out. Please log in again.' => 'Le délai de votre session est dépassé, veuillez vous ré-authentifier.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/Agent.pm
        'Group of the agents' => '',
        'Select the group of the agents' => '',
        'External-source key' => '',
        'When set via an external source (e.g. web service or import / export), the value will be interpreted as this attribute.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'avant/après',
        'between' => 'entre',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseReference.pm
        'e.g. Text or Te*t' => '',
        'Referenced object type' => '',
        'Select the type of the referenced object' => '',
        'Input mode of edit field' => '',
        'Select the input mode for the edit field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/CustomerCompany.pm
        'Attribute which will be searched on autocomplete' => '',
        'Select the attribute which customer companies will be searched by' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/RichText.pm
        'This field is required or' => 'Le champ est requis ou',
        'The field content is too long!' => 'Le contenu du champ est trop long',
        'Maximum size is %s characters.' => 'La taille maximum est de %s caractères. ',
        'Full %s Text' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Ticket.pm
        'Queue of the ticket' => '',
        'Select the queue of the ticket' => '',
        'Type of the ticket' => '',
        'Select the type of the ticket' => '',
        'Select the attribute which tickets will be searched by' => '',
        'Attribute which is displayed for values' => '',
        'Select the type of display' => '',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/CSV.pm
        'Column Separator' => 'Séparateur de colonne',
        'Tabulator (TAB)' => 'Tabulation (TAB)',
        'Semicolon (;)' => 'Point virgule (;)',
        'Colon (:)' => 'Deux points (:)',
        'Dot (.)' => 'Point (.)',
        'Comma (,)' => 'Virgule (,)',
        'Charset' => 'Jeu de caractères',
        'Include Column Headers' => 'Inclure les en-têtes de colonnes',
        'Column' => 'Colonne',

        # Perl Module: Kernel/System/ImportExport/FormatBackend/JSON.pm
        'Pretty print the exported concatenated JSON' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/CloneDB/Backend.pm
        'Sanity checks for database.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => '',
        'Deployment completed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => '',
        'Migration failed.' => '',
        'Migrate database table auto_response.' => '',
        'Migration completed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => '',
        'Completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Need OTRSData->%s!' => '',
        'Can\'t access OTRS Home: %s!' => '',
        'All needed files copied and migrated, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Copy database.' => '',
        'Skipped...' => '',
        'System was unable to connect to OTRS database.' => '',
        'System was unable to complete data transfer.' => '',
        'Data transfer completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO version is correct.' => '',
        'Check if OTOBO and OTRS connect is possible.' => '',
        'Can\'t open RELEASE file from OTRSHome: %s!' => '',
        'Check if OTOBO and OTRS version is correct.' => '',
        '%s does not exist!' => '',
        'No OTOBO system found!' => '',
        'You are trying to run this script on the wrong framework version %s!' =>
            '',
        'OTOBO Version is correct: %s.' => '',
        'Check if OTRS version is correct.' => '',
        'OTRS RELEASE file %s does not exist!' => '',
        'Can\'t read OTRS RELEASE file: %s' => '',
        'No OTRS system found!' => '',
        'Unknown PRODUCT found in OTRS RELASE file: %s. Expected values are %s.' =>
            '',
        'OTRS Version is correct: %s.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOItsmTablesMigrate.pm
        'Migrate ITSM database tables.' => '',
        'Nothing to do, as the the table \'%s\' does not exist.' => '',
        'UPDATE of the table \'%s\' failed.' => '',
        'Migration completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => '',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            '',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            '',
        'SysConfig data migration completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => '',
        'Failed - see the log!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => '',
        'Check if Kernel/Config.pm exists in OTOBO home.' => '',
        'Kernel/Config.pm exists in OTOBO home' => '',
        'Check if we are able to connect to OTRS Home.' => '',
        'Can\'t connect to OTRS file directory.' => '',
        'Connect to OTRS file directory is possible.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => '',
        'Could not create database object.' => '',
        'Database connect and sanity checks completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => '',
        'The following packages are only installed in OTRS:' => '',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            '',
        'The same packages are installed on both systems, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPackageSpecifics.pm
        'Package specific tasks' => '',
        'Done -' => '',
        'Failed at -' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => '',
        '%s script does not exist.' => '',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            '',
        'All required Perl modules have been installed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'installed' => 'installé',
        'Unable to parse repository index document.' => 'Impossible de lire le document d\'index du dépôt',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '',
        'Package not verified by the OTOBO community!' => '',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "Package::AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',
        'Verification not possible (e.g. no internet connection)!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inactif',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Impossible de contacter le serveur d\'enregistrement. Veuillez réessayer ultérieurement. ',
        'No content received from registration server. Please try again later.' =>
            'Aucune donnée reçue depuis le serveur d\'enregistrement. Veuillez réessayer ultérieurement. ',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Le nom et mot de passe ne correspondent pas. Merci d\'essayer à nouveau.',
        'Problems processing server result. Please try again later.' => 'Problèmes sur le serveur de processus. Veuillez réessayer ultérieurement.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Somme',
        'week' => 'semaine',
        'quarter' => 'trimestre',
        'half-year' => 'semestre',

        # Perl Module: Kernel/System/Stats/Dynamic/ArticleList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Attributs à imprimer',
        'Sort sequence' => 'Ordre de tri',
        'State Historic' => '',
        'State Type' => '',
        'State Type Historic' => '',
        'Created Priority' => 'Priorité créée',
        'Created State' => 'État créé',
        'Create Time' => 'Date de création',
        'Article Create Time' => '',
        'Pending until time' => '',
        'Close Time' => 'Date de clôture',
        'Historic Time Range' => '',
        'Escalation' => 'Remontée',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Opérateur/Propriétaire',
        'Created by Agent/Owner' => 'Créé par le Opérateur/Propriétaire',
        'Assigned to Customer User Login' => '',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluation par',
        'Ticket/Article Accounted Time' => 'Temps passé par Ticket/Article',
        'Ticket Create Time' => 'Heure de création du ticket',
        'Ticket Close Time' => 'Heure de fermeture du ticket',
        'Accounted time by Agent' => 'Temps passé par opérateur',
        'Total Time' => 'Temps Total',
        'Ticket Average' => 'Moyenne des tickets',
        'Ticket Min Time' => 'Temps minimum du ticket',
        'Ticket Max Time' => 'Temps maximum du ticket',
        'Number of Tickets' => 'Nombre de tickets',
        'Article Average' => 'Moyenne des articles',
        'Article Min Time' => 'Temps minimum des articles',
        'Article Max Time' => 'Temps maximum des articles',
        'Number of Articles' => 'Nombre d\'articles',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Jours',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '',
        'Internal Error: Could not open file.' => 'Erreur interne : impossible d\'ouvrir le fichier. ',
        'Table Check' => '',
        'Internal Error: Could not read file.' => 'Erreur interne: Ne peut pas lire le fichier.',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Taille de la base de donnée',
        'Could not determine database size.' => 'N\'a pas pu déteminer la taille de la base de donnée',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Version de la base de donnée',
        'Could not determine database version.' => 'Impossible de déterminer la version de la base de données. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Please convert your database to the character set \'utf8mb4\'.' =>
            '',
        'Table Charset' => '',
        'There were tables found which do not have \'utf8mb4\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be 64 MB or higher.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Format de la Date',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Certificates.pm
        'Certificate check' => '',
        'Found obsolete cryptographic function.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Partition disque OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Utilisation de la partition disque',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Impossible de déterminer la distribution. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Version du Noyau',
        'Could not determine kernel version.' => 'Impossible de déterminer la version du noyau. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Charge système',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Modules Perl',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Paramètres de configuration',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => '',
        'Ticket History Entries' => '',
        'Articles' => 'Articles',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => 'Clients avec au moins un ticket',
        'Dynamic Field Values' => 'Valeurs de Champ Dynamique',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => 'Tickets Par Mois (moyenne)',
        'Open Tickets' => 'Tickets ouverts',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => 'Nom de Domaine',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTOBO partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Des paquets ne sont pas correctement installés.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team.' => '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Liste des paquets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
        'OTOBO time zone' => '',
        'OTOBO time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Serveur Web',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variables d\'Environnement',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Collection des données de support',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/PSGIEnv.pm
        'PSGI Environment' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/RunsUnderPSGI.pm
        'Runs under PSGI' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Version du serveur Web',
        'Could not determine webserver version.' => 'Impossible de connaître la version du serveur Web.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Détail des utilisateurs concurrents',
        'Concurrent Users' => 'Utilisateurs concurrents',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problème',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Le paramètre %s n\'existe pas!',
        'Setting %s is not locked to this user!' => 'Le paramètre %s n\'est pas verrouillé pour cet utilisateur!',
        'Setting value is not valid!' => 'La valeur du paramètre est incorrecte!',
        'Could not add modified setting!' => 'Ajout de la modification impossible!',
        'Could not update modified setting!' => 'Mise à jour de la modification impossible!',
        'Setting could not be unlocked!' => 'Le réglage ne peut pas être déverrouillé',
        'Missing key %s!' => 'Clé manquante %s !',
        'Invalid setting: %s' => 'Réglage incorrect: %s',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => 'Tous les réglages',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Par défaut',
        'Value is not correct! Please, consider updating this field.' => 'Valeur incorrecte! Merci de mettre à jour ce champ.',
        'Value doesn\'t satisfy regex (%s).' => 'La valeur n\'est pas une expression régulière ( %s ).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Activé',
        'Disabled' => 'Désactivé',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Valeur incorrecte. Merci de mettre à jour ce module.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Valeur incorrecte. Merci de mettre à jour ce paramètre.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Remise à zéro de l\'heure.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Participant du Chat',
        'Chat Message Text' => 'Message texte du Chat',

        # Perl Module: Kernel/System/Ticket/Mask.pm
        'Base structure is not valid. Please provide an array with data in YAML format.' =>
            '',
        'Error parsing dynamic fields.' => '',
        'No dynamic field "%s".' => '',
        'Dynamic field "%s" not valid.' => '',
        'Dynamic field "%s" already in use in a Set.' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Mauvaise authentification! Votre nom de compte ou mot de passe étaient erronés',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Authentification réussie, mais aucune donnée utilisateur n\'a été trouvée dans la base. Merci de contacter votre administrateur.',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Déconnexion avec succès.',
        'Feature not active!' => 'Cette fonctionnalité n\'est pas activée !',
        'Sent password reset instructions. Please check your email.' => 'Instructions d\'initialisation du mot de passe envoyées. Veuillez consulter votre e-mail.',
        'Invalid Token!' => 'Jeton non valide !',
        'Sent new password to %s. Please check your email.' => 'Nouveau mot de passe envoyé à %s. Veuillez consulter votre e-mail.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Cet e-mail existe déjà. Merci de vous connecter ou de réinitailiser votre mot de passe.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Cette adresse mail n\'est pas autorisée. Merci de contacter votre équipe support. ',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nouveau compte créé. Informations de connexion envoyées à %s. Veuillez consulter votre e-mail.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.' =>
            '',
        'Action "%s" not found!' => '',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.' =>
            '',

        # Perl Module: Kernel/System/Web/InterfacePublic.pm
        'Could not connect to the database.' => '',

        # Database XML / SOPM Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'temporairement invalidé',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'nouveau',
        'All new state types (default: viewable).' => '',
        'open' => 'ouvert',
        'All open state types (default: viewable).' => '',
        'closed' => 'fermé',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'Attente de rappel',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'en attente auto',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'supprimé',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'fusionné',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'clos (résolu)',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'clos (non résolu)',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'en attente de fermeture automatique (+)',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'en attente de fermeture automatique (-)',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => 'Salutation standard',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'possible',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'rejeté',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'réponse automatique',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'rejet automatique',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'suivi automatique',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'réponse auto/nouveau ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'suppression automatique',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 très bas',
        '2 low' => '2 bas',
        '3 normal' => '3 normal',
        '4 high' => '4 important',
        '5 very high' => '5 très important',
        'unlock' => 'déverrouiller',
        'lock' => 'verrouiller',
        'tmp_lock' => '',
        'agent' => 'opérateur',
        'system' => 'système',
        'customer' => 'client',
        'Ticket create notification' => 'Notification de création d\'un ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Notification à chaque création d\'un ticket dans "Mes files" ou "Mes services".',
        'Ticket follow-up notification (unlocked)' => 'Notification de réponse client à un ticket non verrouillé',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Notification lorsqu\'un client envoie un réponse à un ticket déverrouillé dans "Mes files" ou "Mes services".',
        'Ticket follow-up notification (locked)' => 'Notification de réponse client à un ticket verrouillé',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Notification lorsqu\'un client envoie une réponse à un ticket verrouillé dont vous êtes propriétaire ou responsable.',
        'Ticket lock timeout notification' => 'Notification de déverrouillage automatique',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Notification lorsqu\'un ticket dont vous êtes propriétaire est déverrouillé suite au dépassement du délai.',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => 'Notification de déplacement vers une de vos files',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Notification lorsqu\'un ticket est déplacé vers une de "Mes files"',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => 'Notification de lien à un de vos services',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Notification si le service associé à un ticket est changé à un de "Mes services".',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Notification lorsque la date de rappel pour un de vos rendez-vous est atteinte.',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Tout ajouter',
        'An item with this name is already present.' => 'Un objet avec le même nom est déjà présent.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Cet élément contient des sous éléments. Êtes vous sur de vouloir supprimer cet élément incluant ses sous éléments?',

        # JS File: Core.Agent.Admin.About
        'Do you really want to delete this language?' => '',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '',
        'Less' => '',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.CustomerDashboardInfoTile
        'Do you really want to delete this customer dashboard info tile entry?' =>
            '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Voulez-vous vraiment supprimer ce champ dynamique ? Toutes les données associées seront PERDUES !',
        'Delete field' => 'Supprimer le champ',
        'Deleting the field and its data. This may take a while...' => 'Supprimer le champ et ses données. Cela peut prendre un certain temps...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Supprimer la sélection',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => '',
        'Duplicate event.' => 'Evenement double',
        'This event is already attached to the job, Please use a different one.' =>
            'Cet évenement est déjà attaché à un job, merci d\'en utiliser un autre.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Une erreur est survenue durant la communication.',
        'Request Details' => 'Demander des détails',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Afficher ou cacher le contenu.',
        'Clear debug log' => 'Supprimer l\'enregistrement de débogage',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Supprimer ce demandeur',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Supprimer ce mappage de clé',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Supprimer cette opération',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Cloner un service Web',
        'Delete operation' => 'Supprimer une opération',
        'Delete invoker' => 'Supprimer un demandeur',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATTENTION: Lorsque vous modifier le nom du group \'admin\', avant de faire les changements appropriés dans SysConfig, vous serez déconnecté du panneau d\'administration. Si cela arrive, veuillez renommer à nouveau le groupe admin par une requête SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '',
        'Do you really want to delete this notification?' => 'Voulez-vous vraiment supprimer cette notification ?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => '',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '',
        'No TransitionActions assigned.' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Cette activité ne peut pas être supprimée car c\'est l\'activité initiale.',
        'Remove the Transition from this Process' => '',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',
        'Delete Entity' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Hide EntityIDs' => '',
        'Edit Field Details' => 'Éditer les détails du champ',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Chargement...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => 'Déployer',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => 'Déploiement effectué ! Vous allez être redirigé...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.Translations
        'Missing Translations' => '',
        'At least one translation must be filled!' => '',
        'All translations must be filled!' => '',
        'Close' => 'Clôturer',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Précédent',
        'Resources' => '',
        'Su' => 'Di',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Me',
        'Th' => 'Je',
        'Fr' => 'Ve',
        'Sa' => 'Sa',
        'This is a repeating appointment' => '',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '',
        'All occurrences' => '',
        'Just this occurrence' => '',
        'Too many active calendars' => 'Il y a trop de calendriers actifs',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.ArticleFeatures
        'Article Delete' => '',
        'Are you sure you want to delete this article?' => '',
        'Article deleted successfully!' => '',
        'Article already marked as deleted.' => '',
        'Article Restore' => '',
        'Are you sure you want to restore this article?' => '',
        'Article restored successfully!' => '',
        'Article not available for restoring.' => '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Doublon',
        'It is going to be deleted from the field, please try again.' => 'Cela va être supprimé du champ. Veuillez ré-éssayer',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'merci d\'entrer au moins une valeur de recherche ou * pour trouver quoi que ce soit.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Information à propos de la tâche de fond d\'OTOBO',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Veuillez vérifier la validité des données pour les champs marqués en rouge. ',
        'month' => 'mois',
        'Remove active filters for this widget.' => 'Supprimer les filtres actifs pour ce widget',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '',

        # JS File: Core.Agent.StatisticsReports
        'Do you really want to delete this report?' => '',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => '',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Nouveau brouillon',
        'Delete draft' => 'Supprimer le brouillon',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtre d\'Article',
        'Apply' => 'Appliquer',
        'Event Type Filter' => '',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Déplacer la barre de navigation',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => '',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Une ou plusieurs erreurs se sont produites!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Contrôle de mail effectué avec succès.',
        'Error in the mail settings. Please correct and try again.' => 'Erreur dans la configuration de la messagerie. Merci de corriger et de ré-essayer.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.CodeMirrorEditor
        'Error trying to create CodeMirror instance, please check configuration!' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Sélection date d\'ouverture',
        'Invalid date (need a future date)!' => 'Date non valide (elle doit être future) !',
        'Invalid date (need a past date)!' => 'Date non valide (elle doit être passée) !',

        # JS File: Core.UI.InputFields
        'Not available' => '',
        'and %s more...' => '',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => '',
        'Filters' => '',
        'Clear search' => '',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Si vous quittez cette page maintenant, toutes les fenêtres popup seront closes également!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un popup de cet écran est déjà ouvert. Désirez-vous le fermer et charger celui-ci à la place?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'La fenêtre popup n\'a pas pu s\'ouvrir. Merci de désactiver le bloqueur de popup pour cette application.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: ITSM.Admin.ImportExport
        'Deleting template...' => '',
        'There was an error deleting the template. Please check the logs for more information.' =>
            '',
        'Template was deleted successfully.' => '',

        # JS File: Core.Language.UnitTest
        'yes' => 'oui',
        'no' => 'non',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Groupé',
        'Stacked' => 'Empilé',

        # JS File: OTOBOStackedAreaChart
        'Stream' => '',
        'Expanded' => '',

        # SysConfig
        '
            Show optional parameters in parameter list, too. If disabled, the optional parameters are only shown
            in an extra table
        ' => '',
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '',
        ' 2 minutes' => ' 2 minutes',
        ' 5 minutes' => ' 5 minutes',
        ' 7 minutes' => ' 7 minutes',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        '*** out of office until %s (%s d left) ***' => '',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '',
        '30 Minutes' => '',
        '300 (Beginner)' => '',
        '5 Minutes' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => 'Un site internet',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => 'Une image',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Module ACL qui autorise la fermture du ticket parent uniquement si tout ses enfants sont déjà clos("Etat" montre quels états ne sont pas disponibles pour le ticket parent tant que ses enfants ne sont pas clos).',
        'Access Control Lists (ACL)' => 'Listes de contrôle d\'accès (ACL)',
        'AccountedTime' => '',
        'Activate Elasticsearch.' => '',
        'Activate the customer frontend.' => '',
        'Activate the public frontend.' => '',
        'Activates Rendering of DynamicFields outside of the DynamicField block.' =>
            '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Active un mécanisme de clignotement du nom de la file qui contient le plus vieux ticket.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Active la fonction de mot de passe perdu pour les opérateurs, dans l\'interface des opérateurs.',
        'Activates lost password feature for customers.' => 'Active la fonction mot de passe perdu pour les clients.',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Active le filtre d\'article dans la vue de zoom pour spécifier quels articles doivent être montrés.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Active les thèmes disponibles sur le système. La valeur 1 le rend actif, 0 le désactive.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Activer le système d\'archive de tickets dans l\'interface client.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Active le système d\'archive de ticket pour accélérer le système en déplaçant des tickets qui ne sont pas du jour. Pour chercher dans ces tickets, le flag archive doit être activé dans la recherche de ticket.',
        'Activates time accounting.' => 'Active la comptabilisation du temps',
        'ActivityID' => '',
        'Add a note to this ticket' => 'Ajouter une note à ce ticket',
        'Add an inbound phone call to this ticket' => 'Ajouter un appel téléphonique entrant à ce ticket',
        'Add an outbound phone call to this ticket' => 'Ajouter un appel téléphonique sortant à ce ticket',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => 'Ajout d\'une adresse e-mail %s',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => 'Ajout d\'un lien vers le ticket "%s".',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Abonnement pour l\'utilisateur "%s".',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTOBO log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Administrateur',
        'Admin Area.' => '',
        'Admin Contact With Data' => '',
        'Admin Notification' => 'Notification des administrateurs',
        'Admin area navigation for the agent interface.' => '',
        'Admin contact with data.' => '',
        'Admin modules overview.' => 'Vue d\'ensemble des modules administrateur',
        'Admin.' => 'Administrateur.',
        'Administration' => 'Administration',
        'Agent Contact With Data Search' => '',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Dynamic Field Database Detailed Search' => '',
        'Agent Dynamic Field Database Details' => '',
        'Agent Dynamic Field Database Search' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Reference Dynamic Field With Data Search' => '',
        'Agent Statistics.' => 'Statistiques des opérateurs.',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent contact with data search.' => '',
        'Agent dynamic field database detailed search.' => '',
        'Agent dynamic field database details.' => '',
        'Agent dynamic field database search.' => '',
        'Agent frontend module registration (disable \'Edit contacts with data\' link if if there is no source field configured).' =>
            '',
        'Agent interface article notification module to check PGP.' => 'Module de notification d\'article dans l\'interface opérateur pour vérifier le PGP',
        'Agent interface article notification module to check S/MIME.' =>
            'Module de notification d\'article dans l\'interface opérateur pour vérifier le S/MIME',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent reference dynamic field with data search.' => '',
        'AgentTicketZoom widget that displays Contact with data dynamic field in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => 'Opérateurs ↔ Groupes',
        'Agents ↔ Roles' => 'Opérateurs ↔ Rôles',
        'All CustomerIDs of a customer user.' => '',
        'All closed tickets.' => '',
        'All customer users of a CustomerID' => '',
        'All escalated tickets' => 'Tous les tickets escaladés',
        'All new tickets, these tickets have not been worked on yet' => 'Les nouveaux tickets; ces tickets n\'ont pas encore été traités.',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Tous les tickets dont la date de rappel à été atteinte',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Autorise les opérateurs à échanger les axes d\'une statistique si ils en génèrent une.',
        'Allows agents to generate individual-related stats.' => 'Autorise les opérateurs à générer des statistiques relatives à un individu.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Answer' => 'Réponse',
        'Appointment Calendar overview page.' => 'Vue d\'ensemble des calendriers',
        'Appointment Notifications' => 'Notifications des rendez-vous',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '',
        'Appointment edit screen.' => '',
        'Appointment list' => '',
        'Appointment list.' => '',
        'Appointment notifications' => 'Notifications des rendez-vous',
        'Appointments' => '',
        'Arabic (Saudi Arabia)' => '',
        'Article ID: %s was deleted by "%s" (%s)' => '',
        'Article ID: %s was edited by "%s" (%s)' => '',
        'Article ID: %s was restored by "%s" (%s)' => '',
        'Article Version View' => '',
        'Article attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            '',
        'ArticleTree' => '',
        'As soon as the move queue option dropdown is enabled for example in the AgentTicketZoom dialogue, it is possible to move tickets locked to other agents to another queue by activating this option.' =>
            '',
        'Attachment Name' => 'Nom de la Pièce Jointe',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically generate statistics reports and email them to the specified recipients.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Redirigé vers "%s".',
        'Bulgarian' => 'Bulgare',
        'Bulk Action' => 'Action groupée',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'CSV Separator' => 'Séparateur CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Calendar manage screen.' => '',
        'Cancel whole escalation if ticket is in configured suspend state (EscalationSuspendStates). Ticket will not escalate at all in configured suspend state. No escalation times are shown. Ticket will not be shown in escalation view.' =>
            '',
        'Catalan' => '',
        'Categories used in ticket presentation. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            '',
        'Categories used in ticket presentation. Order is only used to determine the starting position before size arrangement. If no default color is given, item will not be shown if selection is not defined in the color hash. Optionally the attribute Text can be added to override the field value, templating methods can be used (e.g. "Text" => "[% Data.Value | remove(\'^.+::\') %]"). Link can be used the same way.' =>
            '',
        'Change Ticket' => '',
        'Change Ticket information' => '',
        'Change queue!' => 'Changer de file!',
        'Change the customer for this ticket' => 'Changer le client de ce ticket',
        'Change the owner for this ticket' => 'Changer le propriétaire du ticket',
        'Change the priority for this ticket' => 'Changer la priorité de ce ticket',
        'Change the responsible for this ticket' => 'Changer le responsable de ce ticket',
        'Change your avatar image.' => 'Changer votre avatar.',
        'Change your password and more.' => 'Modifier votre mot de passe, etc...',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Changement de priorité de "%s" (%s) pour "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => 'Changer l´état de "%s" á "%s".',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Chat communication channel.' => '',
        'Checkbox' => 'Case à cocher',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Child' => 'Enfant',
        'Chinese (Simplified)' => 'Chinois (simplifié)',
        'Chinese (Traditional)' => 'Chinois (traditionnel)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Choisissez les changements à propos desquels vous souhaitez être notifié(e). Notez que vous ne pouvez pas complétement désactiver les notifications marquées comme étant obligatoires.',
        'Choose which notifications you\'d like to receive.' => 'Choisissez quelles notifications vous souhaitez recevoir.',
        'Christmas Eve' => 'Réveillon de Noël',
        'Close this ticket' => 'Clôturer ce ticket',
        'Closed Tickets' => '',
        'Closed tickets (customer user)' => 'Tickets clôturés (utilisateur client)',
        'Closed tickets (customer)' => 'Tickets fermés (client)',
        'Cloud Services' => 'Services cloud',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Color definitions for Agent interface highcontrast skin.' => '',
        'Color definitions for Customer Interface highcontrast skin.' => '',
        'Color definitions for the agent interface (default skin). MainDark, -Light and Hover are the navigation background, buttons and some other main elements. Highlight are e.g. icons and selected elements in the navbar. BG- and Text colors are various background, and text colors. Hover colors are used in selections and tables. Notify colors are the background of notifications.' =>
            '',
        'Color definitions for the customer interface.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Communication' => '',
        'Communication & Notifications' => 'Communication et notifications',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => 'Statut de l\'entreprise',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Composer',
        'Configure Processes.' => 'Configurer les Processus.',
        'Configure and manage ACLs.' => 'Configurer et gérer les ACL.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTOBO Team for improved support.' =>
            '',
        'Configure the About information.' => '',
        'Configure the privacy policy.' => '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Sélectionnez l\'écran qui doit être affiché après la création d\'un nouveau ticket.',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otobo.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Contrôle si les clients ont la possibilité de classer leurs tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Contrôle si plus d\'une entrée peut être mise dans un nouveau ticket téléphone depuis l\'interface opérateur.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controler la permission d\'un administrateur a importer un configuration de système sauvegardé dans SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => '',
        'Create Templates for AdminDynamicFieldTitle.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => 'Créer un nouveau rendez-vous lié à ce ticket',
        'Create and manage Service Level Agreements (SLAs).' => 'Créer et gérer les contrats de niveau de support (SLAs).',
        'Create and manage advanced definitions for ticket masks.' => '',
        'Create and manage agents.' => 'Créer et gérer les opérateurs.',
        'Create and manage appointment notifications.' => 'Créer et gérer les notifications de rendez-vous',
        'Create and manage attachments.' => 'Créer et gérer les pièces jointes.',
        'Create and manage calendars.' => 'Créer et gérer les calendriers.',
        'Create and manage custom translations.' => '',
        'Create and manage customer users.' => 'Créer et gérer les utilisateurs clients.',
        'Create and manage customers.' => 'Créer et gérer les clients.',
        'Create and manage dynamic fields.' => 'Créer et gérer les champs dynamiques.',
        'Create and manage groups.' => 'Créer et gérer les groupes.',
        'Create and manage queues.' => 'Créer et gérer les files.',
        'Create and manage responses that are automatically sent.' => 'Créer et gérer  les réponses automatiques.',
        'Create and manage roles.' => 'Créer et gérer les rôles.',
        'Create and manage salutations.' => 'Créer et gérer les salutations.',
        'Create and manage services.' => 'Créer et gérer les services.',
        'Create and manage signatures.' => 'Créer et gérer les signatures.',
        'Create and manage templates.' => 'Créer et gérer les modèles.',
        'Create and manage ticket notifications.' => 'Créer et gérer les notifications des tickets.',
        'Create and manage ticket priorities.' => 'Créer et gérer les priorités de ticket.',
        'Create and manage ticket states.' => 'Créer et gérer les états de ticket.',
        'Create and manage ticket types.' => 'Créer et gérer les types de ticket.',
        'Create and manage web services.' => 'Créer et gérer les services Web.',
        'Create new Ticket.' => 'Créer un nouveau ticket.',
        'Create new appointment.' => 'Créer un nouveau rendez-vous.',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => '',
        'Create new phone ticket (inbound).' => '',
        'Create new phone ticket.' => '',
        'Create new process ticket.' => '',
        'Create tickets.' => 'Créer des tickets.',
        'Create your first ticket' => 'Créez votre premier ticket',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => '',
        'Custom RSS Feed' => 'Flux RSS personnalisé',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Administration des clients',
        'Customer Companies' => 'Entreprises clientes',
        'Customer Dashboard' => '',
        'Customer Dynamic Field Database Detailed Search' => '',
        'Customer Dynamic Field Database Details' => '',
        'Customer Dynamic Field Database Search' => '',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => 'Rechercher dans le centre d\'information des utilisateurs clients et clients',
        'Customer Information Center.' => '',
        'Customer Password.' => '',
        'Customer Reference Dynamic Field With Data Search' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => 'Administration des utilisateurs client',
        'Customer User Information' => 'Informations des utilisateurs client',
        'Customer User Information Center Search.' => 'Rechercher dans le centre d\'informations des utilisateurs client.',
        'Customer User Information Center search.' => 'Rechercher dans le centre d\'informations des utilisateurs client.',
        'Customer User Information Center.' => 'Centre d\'informations des utilisateurs client.',
        'Customer Users ↔ Customers' => 'Utilisateurs client ↔ Clients',
        'Customer Users ↔ Groups' => 'Utilisateurs client ↔ Groupes',
        'Customer Users ↔ Services' => 'Utilisateurs client ↔ Services',
        'Customer dynamic field database detailed search.' => '',
        'Customer dynamic field database details.' => '',
        'Customer dynamic field database search.' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer reference dynamic field with data search.' => '',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Recherche d\'un utilisateur client',
        'CustomerCompany' => '',
        'CustomerDashboard Info Tile' => '',
        'CustomerID search' => '',
        'CustomerName' => 'Nom du client',
        'CustomerUser' => 'Utilisateur client',
        'Customers ↔ Groups' => 'Clients ↔ Groupes',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => '',
        'Dashboard overview.' => 'Vue d\'ensemble du tableau de bord.',
        'Data used to export the search result in CSV format.' => 'Données utilisées pour exporter les résultats de recherche dans le format CSV.',
        'Date / Time' => 'Date / Heure',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => 'ACL par défaut pour les actions du ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => 'ID de file par défaut utilisée par le système dans l\'interface opérateur.',
        'Default skin for the agent interface (slim version).' => 'Thème par défaut pour l\'interface opérateur (version slim).',
        'Default skin for the agent interface.' => 'Thème par défaut pour l\'interface opérateur.',
        'Default skin for the customer interface.' => 'Thème par défaut pour l\'interface client.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket par défaut utilisé par le système dans l\'interface opérateur.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket par défaut utilisé par le système dans l\'interface client.',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '',
        'Define a result field for the TicketID of the invoker response per web service (WebserviceID => DynamicFieldName).' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define possible namespaces for dynamic fields.' => '',
        'Define the max depth of queues.' => '',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone LinkedIn à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone XING à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone Google à la fin du bloc d\'information client.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Défini un élément client qui génère un icone Google Maps à la fin du bloc d\'information client.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => 'Défini tous les X-headers qui doivent être analysés',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => 'Détermine une adresse URL alternative à l\'endroit ou mène le lien de déconnexion.',
        'Defines an alternate login URL for the customer panel.' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if CSV-mappings are re-created on next package reinstallation or upgrade if already existent.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required for the quick close.' => '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and the servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as support data sending, Package Verify™ and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the ticket info widget is displayed permanently on the left below the article list or is available via click on the \'Information\' button.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface, if a note is entered.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines if user can modify all possible values/labels of dynamic fields in one data table.' =>
            '',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body for the quick close action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the close state for quick close.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the communication chanel for the quick close article action.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketSeenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters available in the preferences view. The default redirect URL from SysConfig \'MarkTicketUnseenRedirectDefaultURL\' is used if no selection is made by the agent.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the data objects avaliable to be translated.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS for creating CKEditor articles.' => '',
        'Defines the default CSS used for displaying articles.' => '',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default frontend (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otobo.org/.' =>
            '',
        'Defines the default frontend language. All the possible values are determined by the available language files on the system. These values are listed as the keys in the setting \'DefaultUsedLanguages\'.' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default interface. Unknown pathes below the script alias are redirected to the selected interface.' =>
            '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default queue for new tickets in the agent interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            '',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the HTML templates.' => '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTOBO_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the headers which will be shown to generic content for the requested key.' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of params that can be passed to ticket search function.' =>
            '',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTOBO instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface if the OTOBO Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the customer interface. UseMarquee options: 1/0. NotifyPriority options: Notice/Error/Success/Info.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the modules in Kernel/Output/HTML/GenericContent/ which provide the inner content to the chosen key.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTOBO.' =>
            '',
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the number of tickets shown in the widget.' => '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Only works if DashboardBackend::AllowCmdOutput is enabled in Config.pm.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the path to the Google Chrome or Chromium binary. If set, this binary will be used instead of PhantomJS::Bin.' =>
            '',
        'Defines the path to the PhantomJS binary. You can use a static build from http://phantomjs.org/download.html for an easy installation process.' =>
            '',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the redirect URL for setting a ticket article to \'seen\'.' =>
            '',
        'Defines the redirect URL for setting a ticket article to \'unseen\'.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer interface of this OTOBO system. The value in "Key" is the external URL, the value in "Content" is the shown label. <OTOBO_CONFIG_HttpType>, <OTOBO_CONFIG_FQDN> and <OTOBO_CONFIG_ScriptAlias> will be substituted.' =>
            '',
        'Defines the source dynamic field for storing historical data.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the subject for the quick close action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the target dynamic fields for storing historical data.' =>
            '',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol that is used by the web server to serve the application. If the webserver uses HTTP instead of of HTTPS, then \'http\' must be specified here. The setting of \'HttpType\' has no affect on the web server\'s settings or behavior. Specifically, it will not change the method of access to the application. If the setting is wrong, it will not prevent you from logging into the application. This setting is used mainly via the template variable OTOBO_CONFIG_HttpType. This variable is found in all forms of messaging used by the application. It is used to build links to the tickets within your system. Another effect of keeping \'HttpType\' set to \'https\' is that the session management cookie will only be set for secure connections.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the value of the SameSite attribute of the OTOBO session cookies. Used in otobo.psgi.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired form cache hourly.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Supprimer ce ticket',
        'Deleted link to ticket "%s".' => 'Suppression du lien vers le ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'DeploymentHistory' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate article lists.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the process screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Dialog to show after marking a ticket as seen' => '',
        'Dialog to show after marking a ticket as unseen' => '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTOBO to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => 'Désactiver les services cloud',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => 'Afficher le journal d\'événements des notifications.',
        'Display settings to override defaults for Process Tickets.' => '',
        'Display settings to override defaults for dynamic field widget for Tickets.' =>
            '',
        'Displayable via click' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Field Contents' => '',
        'Dynamic Field Information' => '',
        'Dynamic Field Labels' => '',
        'Dynamic Field Set' => '',
        'Dynamic Field Set Backend GUI' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Contact Data Backend GUI' => '',
        'Dynamic Fields Database Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Lens Backend GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Reference Backend GUI' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields Web Service Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic field event module that deletes script field events if a dynamic field of type script gets deleted.' =>
            '',
        'Dynamic field event module that updates PartOfSet attributes of fields which are included in a set.' =>
            '',
        'Dynamic fields groups for dynamic field widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the dynamic field widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'DynamicFieldScreen' => '',
        'DynamicField_%s' => '',
        'E-Mail Outbound' => 'Mail sortant',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => '',
        'Edit contacts with data' => '',
        'Edit contacts with data.' => '',
        'Edit customer company' => '',
        'Elasticsearch quick result module.' => '',
        'Email Addresses' => 'Adresses e-mail',
        'Email Outbound' => '',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTOBO user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode for translations module.' => '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enabling SecureMode disables the web installer (http://yourhost.example.com/otobo/installer.pl) and the migrations. This is done in order to prevent the system from being hijacked. When SecureMode is not enabled the system can be reinstalled. In this case the current basic configuration will be used to pre-populate the questions within the installer script. Enabling SecureMode also enables GenericAgent, PackageManager and SQL Box.' =>
            '',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Tickets remontés',
        'Escalation view' => 'Vue par remontées',
        'EscalationTime' => '',
        'Estonian' => '',
        'Evaluate all script fields.' => '',
        'Event module registration (store historical data in dynamic fields).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => 'Agenda des Événements de Ticket',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => 'Executer des requêtes SQL.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on OTOBO Header \'X-OTOBO-Bounce\'.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'Fields of the customer company index, used for the company fulltext search. Fields are also stored, but are not mandatory for the overall functionality.' =>
            '',
        'Fields of the ticket index, used for the ticket fulltext search. Fields are also stored, but are not mandatory for the overall functionality. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            '',
        'Fields stored in the customer company index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            '',
        'Fields stored in the customer user index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            '',
        'Fields stored in the ticket index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            '',
        'Fields to be searched in ticket index. Fields are also stored, but are not mandatory for the overall functionality.' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtrer les e-mails entrants.',
        'Finnish' => '',
        'First Christmas Day' => '1er jour de Noël',
        'First Queue' => '',
        'First response time' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Format of Creation date shown for tickets. As an example \'%Y-%m-%d %H:%M:%S\' would be interpreted as \'2020-01-22 18:07:23\'. Please refer to http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.' =>
            '',
        'Format to be ingested.' => '',
        'Forwarded to "%s".' => 'Transféré vers "%s".',
        'French' => 'Français',
        'French (Canada)' => 'Français (Canada)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module for dashboard info tile in customer interface.' =>
            '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the admin interface.' => '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend module registration for the public interface.' => 'Interface d\'enregistrement de module pour l\'interface publique.',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Fulltext search using Elasticsearch.' => '',
        'FulltextES' => '',
        'Galician' => '',
        'General Label' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate HTML comment hooks for the specified blocks so that filters can use them.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => 'Automate générique',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the PassThrough invoker layer.' =>
            '',
        'GenericInterface module registration for the TicketCreate invoker layer.' =>
            '',
        'GenericInterface module registration for the TicketUpdate invoker layer.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => 'Aller au tableau de bord !',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => 'Grec',
        'Hebrew' => 'Hébreu',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => '',
        'Hungarian' => '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and you wish to use TLS security to communicate with the LDAP server, the "verify" parameter can be specified here. See Net::LDAP::start_tls for more information about the parameter.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTOBO. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If activated, a clicked activity button will be hidden in the customer ticket zoom frontend.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled defines the preselected state for customer follow-up in the customer interface.' =>
            '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTOBOHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTOBO will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTOBO will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTOBO version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Lorsqu\'activé, les différentes vues d\'ensemble (Tableau de bord, Vue file, etc) seront automatiquement rafraîchies après le temps spécifié.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If enabled, the quick close action will create an article.' => '',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTOBOTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is enabled, it is possible to install packages which are not verified by OTOBO Team. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Si vous prévoyez d\'être absent(e) du bureau, vous pouvez choisir de le faire savoir aux autres utilisateurs en spécifiant les dates de départ et retour.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Ignores not ticket related attributes.' => '',
        'Import and export object information.' => 'Importer et exporter des informations d\'objet',
        'Import appointments screen.' => '',
        'Import/Export' => 'Importer/Exporter',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => 'Appel téléphonique entrant',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Langue de l\'interface',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Fête internationale des travailleurs',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => 'Japonais',
        'JavaScript function for the search frontend.' => '',
        'Jump to OTOBO!' => '',
        'Korean' => '',
        'Languages' => '',
        'Large' => 'Grand',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'LastnameFirstname' => '',
        'Latvian' => '',
        'Lax' => '',
        'Left' => 'Gauche',
        'Lens' => '',
        'Link Object' => 'Lier l\'objet',
        'Link Object.' => '',
        'Link agents to groups.' => 'Lier les opérateurs aux groupes.',
        'Link agents to roles.' => 'Lier les opérateurs aux rôles.',
        'Link customer users to customers.' => 'Lier les utilisateurs client aux clients.',
        'Link customer users to groups.' => 'Lier les utilisateurs client aux groupes.',
        'Link customer users to services.' => 'Lier les utilisateurs client aux services.',
        'Link customers to groups.' => 'Lier les clients aux groupes.',
        'Link queues to auto responses.' => 'Lier les réponses automatiques aux files.',
        'Link roles to groups.' => 'Lier les rôles aux groupes.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => 'Lier les modèles aux files.',
        'Link this ticket to other objects' => 'Lier ce ticket à d\'autres objets',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'Links appointments and tickets with a "Normal" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all appointment events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all calendar events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List of states for which escalations should be suspended.' => '',
        'List of ticket masks which can be altered using AdminTicketMask.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Loader module for dashboard info tile in customer interface.' =>
            '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => 'Vérrouiller / déverrouiller ce ticket',
        'Locked Tickets' => 'Tickets verrouillés',
        'Locked Tickets.' => 'Tickets verrouillés.',
        'Locked ticket.' => 'Ticket verrouillé.',
        'Logged in users.' => 'Utilisateurs actuellement connectés.',
        'Logged-In Users' => 'Utilisateurs actuellement connectés',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'Voir le détail du ticket !',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => 'Comptes de messagerie',
        'MailQueue configuration settings.' => '',
        'Main menu for the agent interface.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage Customer Dashboard Info Tile Entries' => '',
        'Manage OTOBO Team cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Gérer les clés PGP pour le chiffrement des e-mails.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gérer les comptes où aller chercher les e-mails (POP3 ou IMAP)',
        'Manage S/MIME certificates for email encryption.' => 'Gérer les certificats S/MIME pour le chiffrement des e-mails.',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => 'Gérer les différents calendriers.',
        'Manage dynamic field in screens.' => '',
        'Manage existing sessions.' => 'Gérer les sessions existantes.',
        'Manage support data.' => 'Gestion des données de support.',
        'Manage system registration.' => 'Gérer l\'inscription du système.',
        'Manage tasks triggered by event or time based execution.' => 'Gérer les tâches déchenchées par un événement ou une exécution temporelle.',
        'Manage ticket state pre-selections for response templates.' => '',
        'Mark as Spam!' => 'Marquer comme Spam !',
        'Mark this ticket as junk!' => '',
        'Mark ticket as seen' => '',
        'Mark ticket as unseen' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal number of results returned by ES per field.' => '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum file size for the ingest plugin.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Medium' => 'Moyen',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTOBO_TICKET> to <OTOBO_MERGE_TO_TICKET>.' => 'Fusionner le ticket <OTOBO_TICKET> avec <OTOBO_MERGE_TO_TICKET>.',
        'Minute' => '',
        'Miscellaneous' => 'Divers',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Module used to detect if attachments are present.' => '',
        'My Queues' => 'Mes files',
        'My Services' => 'Mes services',
        'My last changed tickets' => '',
        'MyLastChangedTickets dashboard widget.' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Tickets' => 'Nouveaux tickets',
        'New Window' => '',
        'New Year\'s Day' => 'Jour de l\'An',
        'New Year\'s Eve' => 'Veille du jour de l\'An',
        'New process ticket' => '',
        'News about OTOBO.' => 'Nouveautés à propos d\'OTOBO.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '',
        'Norwegian' => '',
        'Notification Settings' => 'Paramètres de notification',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Nombre de tickets affichés',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of shards (NS), replicas (NR) and fields limit for the index \'ticket\'.' =>
            '',
        'Number of shards (NS), replicas (NR) and fields limit for the index. Note: \'Elasticsearch::ArticleIndexCreationSettings\' is deprecated. For upwards compatibility use \'Elasticsearch::IndexSettings###Default\' instead.' =>
            '',
        'Number of shards (NS), replicas (NR) and fields limit for the indices. This replaces \'Elasticsearch::ArticleIndexCreationSettings\' in future versions. If both are present and not equal this one has priority. Use \'Elasticsearch::IndexSettings###...\' if you want to define special settings for single indices.\'...\' may be one of \'Customer\', \'CustomerUser\', \'Ticket\' or \'ConfigItem\'.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTOBO News' => 'Nouvelles d\'OTOBO',
        'OTOBO Team Services' => '',
        'OTOBO can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTOBO doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Object backend module registration for the import/export module.' =>
            '',
        'Objects to search for, how many entries and which attributs to show.' =>
            '',
        'Objects to search for, how many entries and which attributs to show. Ticket attributes, except queue, have to explicitely be stored via Elasticsearch.' =>
            '',
        'Open an external link!' => '',
        'Open the OTOBO home page in a new window' => '',
        'Open tickets (customer user)' => 'Tickets ouverts (utilisateurs client)',
        'Open tickets (customer)' => 'Ouvrir les tickets (client)',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => 'Absence du bureau',
        'Out Of Office Time' => 'Absence du bureau',
        'Out of Office users.' => 'Utilisateurs à l\'extérieur du bureau.',
        'Outbound request headers not allowed to be used in frontend configuration.' =>
            '',
        'Outbound response headers not allowed to be used in frontend configuration.' =>
            '',
        'Output filter to inject the necessary Dynamic field names in hidden input.' =>
            '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Délai de rafraichissement des vues d\'ensembles',
        'Overview of all Tickets per assigned Queue.' => 'Vue d\'ensemble des tickets assignés par files.',
        'Overview of all appointments.' => 'Vue d\'ensemble de tous les rendez-vous',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Vue d\'ensemble des tickets ouverts',
        'Overview of all open tickets.' => 'Vue d\'ensemble de tous les tickets ouverts.',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'Clé PGP',
        'PGP Key Management' => '',
        'PGP Keys' => 'Clés PGP',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Package event module trigger package reinstall in containers.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the closed tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Parent' => 'Parent',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Pending time' => '',
        'People' => 'Personne',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permanent' => '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call Inbound' => 'Appel téléph. entrant',
        'Phone Call Outbound' => 'Appel téléph. sortant',
        'Phone Call.' => '',
        'Phone call' => 'Appel téléphonique',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Ticket Téléphone',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => 'Envoyer une image',
        'Please click the button below to create your first ticket.' => 'Merci de cliquer sur le bouton suivant pour créer votre premier ticket.',
        'Plugin search' => '',
        'Plugin search module for autocomplete.' => '',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'Filtres Postmaster',
        'PostMaster Mail Accounts' => 'Comptes e-mail Postmaster',
        'Print this ticket' => 'Imprimer ce ticket',
        'Priorities' => 'Priorités',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => 'Processus et automatisation',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Protection against brute force attacks. MaxAttempt: How many login attempts are allowed before a ban. BanDuration: Duration of the ban. KeepCacheDuration: How long failed attempts are remembered.' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => '',
        'Public Interface' => '',
        'Public calendar.' => '',
        'Queue view' => 'Vue par files',
        'Queues ↔ Auto Responses' => '',
        'Quick Close' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Rebuilds Elasticsearch indices. Can be used for example, if CustomerUsers are authenticated via LDAP. Highly inefficient however, as the whole index is rebuild every time.' =>
            '',
        'Rebuilds the ACL preselection cache.' => '',
        'Rebuilds the escalation index.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Redis server address. Example: 127.0.0.1:6379.' => '',
        'Refresh interval' => 'Intervalle d\'actualisation',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as seen.' =>
            '',
        'Registers a link in the ticket menu of ticket overviews to mark all articles of the ticket as unseen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as seen.' =>
            '',
        'Registers a link in the ticket menu to mark a ticket as unseen.' =>
            '',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Registration of the CSV format backend module for the ImportExport feature.' =>
            '',
        'Registration of the JSON format backend module for the ImportExport feature.' =>
            '',
        'Reminder Tickets' => 'Tickets avec date de rappel atteinte',
        'Removed subscription for user "%s".' => 'Désabonnement pour l\'utilisateur "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'Rapports',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Retraiter les courriels du répertoire de file d\'attente qui ne peuvent pas être importés la première fois.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use quick close in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Richtext' => '',
        'Right' => '',
        'Roles ↔ Groups' => 'Rôles ↔ Groupes',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => 'Processus Tickets en Cours',
        'Runs an initial wildcard search of the existing contacts with data when accessing the AdminContactWD module.' =>
            '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => 'Russe',
        'S/MIME Certificates' => 'Certificats S/MIME',
        'SLAs' => '',
        'Salutations' => 'Salutations',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTOBO user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used. "S3" is experimental.' =>
            '',
        'Schedule a maintenance period.' => 'Planifier une plage de maintenance.',
        'Screen after new ticket' => 'Écran suivant la création d\'un ticket',
        'Script (Template Toolkit)' => '',
        'Search Customer' => 'Recherche de client',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => 'Rechercher un utilisateur',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'Rechercher.',
        'Second Christmas Day' => '2e jour de Noël',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the algorithm used for encryption. Fallback is aes256. Try "/usr/bin/openssl enc -ciphers" to get a list of ciphers supported by your system (written without the leading \'-\').' =>
            '',
        'Select the main interface language.' => 'Sélectionnez la langue principale de l\'interface.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Sélectionner le caractère séparateur pour les fichiers CSV (stats et recherches). Si rien n\'est indiqué ici, le séparateur par défaut pour votre langage est utilisé.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            'Sélectionnez votre fuseau horaire personnel. L\'horaire du système OTOBO sera relatif à cette heure.',
        'Select your preferred layout for the software.' => 'Sélectionnez votre skin préféré pour le système.',
        'Select your preferred theme for OTOBO.' => 'Sélectionnez votre thème préféré pour OTOBO.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => 'Envoyer un mail à partir de ce ticket',
        'Send notifications to users.' => 'Envoyer des notifications aux utilisateurs.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to Rother OSS.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Envoyer les notifications qui sont configurées dans le module "Notifications des tickets" de l\'interface administrateur.',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => 'Contrats de niveau de support',
        'Service view' => 'Vue par service',
        'ServiceView' => 'Vue par service',
        'Set a new password by filling in your current password and a new one.' =>
            'Définissez un nouveau mot de passe en renseignant votre mot de passe actuel et le nouveau.',
        'Set sender email addresses for this system.' => 'Mettre en place les adresses d\'envoi d\'e-mails pour ce système.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Mettre ce ticket en attente',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for quick close action in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the preferred digest to be used for PGP binary.' => '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTOBO_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTOBO to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTOBO time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Settings for the customer login screen.' => '',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => 'Afficher le résultat de la ligne de commande.',
        'Show or Hide deleted articles.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Show the ticket history' => 'Afficher Historique du Ticket',
        'Show various content.' => '',
        'ShowHideDeletedArticles' => '',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to quick close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to quick close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to show/hide deleted articles in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTOBO Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'Signatures',
        'Simple' => '',
        'Skin' => 'Skin',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'Petit',
        'Software Package Manager.' => '',
        'Solution time' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com). You can use the OTOBO_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward and bounce. Make sure that "rw" is always the last registered permission, as rw automatically grants all additional permissions.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Stat#',
        'State pre-selection for Templates' => '',
        'States' => 'État',
        'Statistics overview.' => 'Vue d\'ensemble des statistiques.',
        'Statistics reports.' => '',
        'Status view' => 'Vue par statut',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strict' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Suspend already escalated tickets.' => '',
        'Swahili' => '',
        'Swedish' => '',
        'Switch deleted article status view' => '',
        'Switch deleted article status view.' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Configuration Setting History' => '',
        'System Maintenance' => 'Maintenance Système',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => 'Modèles ↔ Files',
        'Textarea' => 'Zone de texte',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for sync with S3.' => '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo and signet shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server. The signet will be scaled to 32px*32px, the logo to 196px*32px. (In the mobile setup both have a height of 24px with variable length.)' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Le logo affiché sur la page d\'authentification des opérateurs. L\'URL peut faire référence à un fichier situé sur l\'ordinateur, ou à l\'adresse Web de l\'image.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'Theme' => 'Thème',
        'This configuration defines all possible screens to enable or disable default columns.' =>
            '',
        'This configuration defines all possible screens to enable or disable dynamic fields.' =>
            '',
        'This configuration defines if only valids or all (invalids) dynamic fields should be shown.' =>
            '',
        'This configuration defines the number of iterations that should be performed at max for calculating the WorkingTime for a Ticket. Attention: Setting this configuration to high can lead to performance issues.' =>
            'Cette configuration définit le nombre d\'itérations à effectuer au maximum pour calculer le temps de travail d\'un Ticket. Attention : Définir cette configuration sur élevée peut entraîner des problèmes de performances.',
        'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is being used to extend the password policy.' => '',
        'This module is part of the admin area of OTOBO.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option sets additional quick date buttons to pending dates. For ordering purposes one hash entry per array segment has to be set. The key is the button name, value is the value, where a single number n sets the date to n days from now, +n adds n days to the currently set date, and -n subtracts them.' =>
            '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Ce paramètre permet d\'utiliser ta propre liste des pays plutôt que celle par défaut. C\'est conseillé si vous souhaitez seulement utiliser une sélection de pays.',
        'This setting is deprecated. Set OTOBOTimeZone instead.' => 'Ce paramètre est déprécié. Utilisez OTOBOTimeZone.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'Ticket Close' => 'Ticket fermé',
        'Ticket Close.' => 'Ticket fermé.',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => 'Ticket Client.',
        'Ticket Forward Email.' => 'Transfert du ticket par Email.',
        'Ticket FreeText.' => '',
        'Ticket History.' => 'Historique du ticket.',
        'Ticket Lock.' => 'Verrouillage ticket.',
        'Ticket Masks' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => 'Note du ticket.',
        'Ticket Notifications' => 'Notifications concernant les tickets',
        'Ticket Outbound Email.' => '',
        'Ticket Overview "Medium" Limit' => 'limite "Moyenne" de Vue Générale des Tickets',
        'Ticket Overview "Preview" Limit' => 'Vue générale "­<petit | moyen | élargi>" - Limite',
        'Ticket Overview "Small" Limit' => 'limite "Petite" de Vue Générale des Tickets',
        'Ticket Owner.' => 'Propriétaire du ticket.',
        'Ticket Pending.' => 'Ticket en attente.',
        'Ticket Print.' => 'Impression du ticket.',
        'Ticket Priority.' => 'Priorité du ticket.',
        'Ticket Queue Overview' => 'Vue d\'ensemble des files de tickets',
        'Ticket Responsible.' => 'Responsable du ticket.',
        'Ticket States' => '',
        'Ticket Types' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket attributes that should be available in ticket invoker configuration frontend (0 = visible/selectable, 1 = default/preselected).' =>
            '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'Notifications concernant les tickets',
        'Ticket overview' => 'Vue d\'ensemble du Ticket',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket state pre-selection for response templates' => '',
        'Ticket title' => 'Titre du ticket',
        'Ticket zoom view.' => '',
        'TicketNumber' => 'NuméroTicket',
        'Tickets in the following queues will not be stored on the Elasticsearch server. To apply this to existing tickets, the ticket migration has to be run via console, after changing this option.' =>
            'Les tickets dans les files suivantes ne seront pas stockés sur le serveur Elasticsearch. Pour appliquer ceci aux tickets existants, la migration des tickets doit être lancée via la console, après le changement de cette option.',
        'Tickets.' => 'Tickets.',
        'Tile registration for the CustomerDashboard. Module is required.' =>
            '',
        'Tile registration for the CustomerDashboard. Module is required. Optionally, an order for items can be set. The order must have the name of the item as key and the desired position as integer value.' =>
            '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Temps en secondes à ajouter à l\'heure actuelle dans le cas dans état en attente (défaut: 86400 = 1 jour).',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => 'Pour télécharger les pièces jointes.',
        'To view HTML attachments.' => 'Voir les pièces jointes HTML.',
        'Toggles display of OTOBO FeatureAddons list in PackageManager.' =>
            'Déclenche l\'affichage de la liste des modules complémentaires d\'OTOBO dans le gestionnaire de paquets.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Translate the country names in the country selection. The CLDR country codes will be stored in the database. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Translate the language names in the language selection. Requires that Locale::CLDR and the relevant language packs are installed.' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => 'Vue hiérarchique',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => 'turc',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Désactive la validation des certificats SSL, par exemple si vous utilisez un proxy HTTPS transparent. A utiliser en connaissance de cause !',
        'Turns on drag and drop for the main navigation.' => 'Activez le glisser déposer pour la navigation principale.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => 'Ajuster le système comme vous le désirez.',
        'Type of daemon log rotation to use: Choose \'OTOBO\' to let OTOBO system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => 'ukrainien',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Ticket déverrouillé.',
        'Upcoming Events' => 'Évènements à venir',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => 'temps mis à jour',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Mise à jour de l\'index d\'escalade des tickets après qu\'un ticket attribué a été mis à jour.',
        'Updates the ticket index accelerator.' => 'Mise à jour de l\'accélérateur d\'index des tickets.',
        'Upload your PGP key.' => 'Ajoutez votre clé PGP.',
        'Upload your S/MIME certificate.' => 'Ajouter votre certificat S/MIME.',
        'Use Redis::Fast instead of Redis.' => 'Utilisez Redis::Fast au lieu de Redis.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use specified Redis logical database.' => '',
        'User Profile' => 'Profil utilisateur',
        'UserFirstname' => 'Prénom utilisateur',
        'UserLastname' => 'Nom de famille utilisateur',
        'Users, Groups & Roles' => 'Utilisateurs, groupes et rôles',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'Voir les résultats du benchmark de performance.',
        'View stored article version.' => '',
        'Watch this ticket' => 'Suivre ce ticket',
        'Watched Tickets' => 'Tickets surveillés',
        'Watched Tickets.' => 'Tickets observés.',
        'We are performing scheduled maintenance.' => 'Nous effectuons une opération de maintenance.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Nous effectuons une opération de maintenance. L\'authentification est temporairement non disponible.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Nous effectuons une opération de maintenance. Le service sera de retour d\'ici quelques instants.',
        'We have changed the default ticket unlock behaviour in OTOBO 10.1. Now, the ticket is not only unlocked, but also handed over to the system user again. Thus, the behaviour is clearer, but it is no longer possible to read out who last edited the ticket. Please deactivate this option to restore the behaviour of OTRS versions 2 to 6 and OTOBO version 10.0.' =>
            '',
        'Web Service' => 'Service Web',
        'Web Services' => 'Services Web',
        'Welcome text for the dashboard header. Name will be inserted to %s of the WelcomeText. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" and "UserLogin" will be substituted.' =>
            '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Dès que les tickets sont fusionnés, une note est ajoutée automatiquement au ticket qui devient inactif. Vous pouvez définir ici le texte de cette note (ce texte ne peut pas être modifié par les agents).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Dès que les tickets sont fusionnés, une note est ajoutée automatiquement au ticket qui devient inactif. Vous pouvez définir ici le sujet de cette note (ce sujet ne peut pas être modifié par les agents).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Quand les tickets sont fusionnés, le client peut être informé par mail en cochant la case "Informer l\'émetteur". Dans cette zone de texte, vous pouvez définir un texte pré-formaté qui pourra ensuite être modifié par les agents.',
        'Whether extended customer information is shown in the ticket print screen of the customer interface.' =>
            '',
        'Whether fields should be automatically filled (1), and in that case also be hidden from ticket formulars (2).' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Collecter ou non les meta informations à partir des articles en utilisant les filtres configurés dans Ticket::Frontend::ZoomCollectMetaFilters.',
        'Whether the execution of TicketACL can be avoided by checking cached field dependencies. This can improve loading times of ticket formulars, but has to be disabled, if ACLModules are to be used for Ticket- and Form-ReturnTypes.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => 'Oui mais masquer les tickets archivés',
        'Your email with ticket number "<OTOBO_TICKET>" is bounced to "<OTOBO_BOUNCE_TO>". Contact this address for further information.' =>
            'Votre email avec le ticket numéro "<OTOBO_TICKET>" est renvoyé à "<OTOBO_BOUNCE_TO>". Contactez cette adresse pour plus d\'informations.',
        'Your email with ticket number "<OTOBO_TICKET>" is merged to "<OTOBO_MERGE_TO_TICKET>".' =>
            'Votre e-mail avec le numéro de ticket "<OTOBO_TICKET>" a été fusionné avec le ticket numéro "<OTOBO_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Votre sélection de files préférées. Vous serez également notifié(e) par courriel à propos de ces files si les notifications sont activées.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Votre sélection de services préférés. Vous serez également notifié(e) par courriel à propos de ces services si les notifications sont activées.',
        'Zoom' => 'Détails',
        'attachment' => 'pièce jointe',
        'bounce' => '',
        'compose' => 'écrire',
        'debug' => 'debug',
        'error' => 'erreur',
        'forward' => 'transférer',
        'info' => 'information',
        'inline' => 'en ligne',
        'normal' => 'normal',
        'notice' => '',
        'pending' => 'en attente',
        'phone' => 'téléphone',
        'responsible' => 'responsable',
        'reverse' => 'inverse',
        'stats' => 'statistiques',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All translations must be filled!',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to delete this article?',
        'Are you sure you want to remove all user values?',
        'Are you sure you want to restore this article?',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article Delete',
        'Article Restore',
        'Article already marked as deleted.',
        'Article deleted successfully!',
        'Article display',
        'Article filter',
        'Article not available for restoring.',
        'Article restored successfully!',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'At least one translation must be filled!',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Click to select or drop files here.',
        'Clone web service',
        'Close',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete this template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting template...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this customer dashboard info tile entry?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this language?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this report?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error trying to create CodeMirror instance, please check configuration!',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Ignore',
        'Import web service',
        'Information',
        'Information about the OTOBO Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Migrate',
        'Missing Translations',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Package',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Results',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show all',
        'Show current selection',
        'Show less',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Template was deleted successfully.',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error deleting the template. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This dynamic field database value is already selected.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTOBO Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Time needed',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Uninstall from OTOBO',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
