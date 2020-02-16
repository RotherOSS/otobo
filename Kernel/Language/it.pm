# --
# Copyright (C) 2003,2008 Remo Catelotti <Remo.Catelotti at eutelia.it>
# Copyright (C) 2003 Gabriele Santilli <gsantilli at omnibus.net>
# Copyright (C) 2005,2009 Giordano Bianchi <giordano.bianchi at gmail.com>
# Copyright (C) 2009 Remo Catelotti <Remo.Catelotti at agilesistemi.com>
# Copyright (C) 2009 Emiliano Coletti <e.coletti at gmail.com>
# Copyright (C) 2009 Alessandro Faraldi <faraldia at gmail.com>
# Copyright (C) 2010 Alessandro Grassi <alessandro.grassi at devise.it>
# Copyright (C) 2012,2013 Massimo Bianchi <mxbianchi at tiscali.it>
# Copyright (C) 2013 Luca Maranzano <liuk@linux.it>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::it;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.789733464955578;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Gestione ACL',
        'Actions' => 'Azioni',
        'Create New ACL' => 'Crea una nuova ACL',
        'Deploy ACLs' => 'Rendi attive le ACL',
        'Export ACLs' => 'Esporta le ACL',
        'Filter for ACLs' => 'Filtro per ACL',
        'Just start typing to filter...' => 'Digita qualche carattere per attivare il filtro...',
        'Configuration Import' => 'Importazione configurazione',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Qui puoi caricare un file di configurazione per importare le ACL. Il file deve essere in formato .yml così come viene esportato dal modulo editor delle ACL.',
        'This field is required.' => 'Questo campo è obbligatorio.',
        'Overwrite existing ACLs?' => 'Sovrascrivere le ACL esistenti?',
        'Upload ACL configuration' => 'Carica una configurazione di ACL',
        'Import ACL configuration(s)' => 'Importa una configurazione di ACL',
        'Description' => 'Descrizione',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Per creare una nuova ACL si può importarne una proveniente da un altro sistema o crearne una nuova del tutto.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'I cambiamenti al processo sono riportati a sistema solo se effettuate la sincronizzazione. Con la sincronizzazione le modifiche sono scritte nella configurazione.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Nota: questa tabella rappresenta l\'ordine di esecuzione delle ACL. Se è necessario modificare l\'ordine in cui vengono eseguite le ACL, modifica i nomi delle ACL interessate.',
        'ACL name' => 'Nome ACL',
        'Comment' => 'Commento',
        'Validity' => 'Validità',
        'Export' => 'Esporta',
        'Copy' => 'Copia',
        'No data found.' => 'Nessun dato trovato.',
        'No matches found.' => 'Nessun risultato.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Modifica l\'ACL %s',
        'Edit ACL' => 'Modifica ACL',
        'Go to overview' => 'Vai al riepilogo',
        'Delete ACL' => 'Elimina ACL',
        'Delete Invalid ACL' => 'Elimina ACL non valida',
        'Match settings' => 'Criteri di corrispondenza',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Imposta i criteri di corrispondenza per questa ACL. Usare \'Properties\' per corrispondenze con la schermata corrente, oppure \'PropertiesDatabase" per corrispondenze con gli attributi del ticket corrente che sono nel database.',
        'Change settings' => 'Cambia impostazioni',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Imposta cosa cambiare nei criteri di corrispondenza. Considerare che \'Possible\' è una whitelist, \'PossibileNot\' una blacklist.',
        'Check the official %sdocumentation%s.' => 'Controlla la %s documentazione ufficiale %s.',
        'Show or hide the content' => 'Mostra o nascondi contenuto',
        'Edit ACL Information' => 'Modifica informazioni ACL',
        'Name' => 'Nome',
        'Stop after match' => 'Ferma dopo trovato',
        'Edit ACL Structure' => 'Modifica struttura ACL',
        'Save ACL' => 'Salva ACL',
        'Save' => 'Salva',
        'or' => 'oppure',
        'Save and finish' => 'Salva e termina',
        'Cancel' => 'Annulla',
        'Do you really want to delete this ACL?' => 'Sei sicuro di volere eliminare questa ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Crea una nuova ACL confermando i dati. Dopo la creazione dell\'ACL, sarà possibile aggiungere voci di configurazione in modalità modifica.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Gestione Calendario',
        'Add Calendar' => 'Aggiungi Calendario',
        'Edit Calendar' => 'Modifica Celendario',
        'Calendar Overview' => 'Panoramica calendario',
        'Add new Calendar' => 'Aggiungi nuovo Calendario',
        'Import Appointments' => 'Importa Appuntamenti',
        'Calendar Import' => 'Importazione Calendario',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Qui è possibile caricare un file di configurazione per importare un calendario nel sistema. Il file deve essere nel formato YML così come esportato dal modulo di gestione calendari.',
        'Overwrite existing entities' => 'Sovrascrivi le entità esistenti',
        'Upload calendar configuration' => 'Carica configurazione calendario',
        'Import Calendar' => 'Importa Calendario',
        'Filter for Calendars' => 'Filtra per Calendari',
        'Filter for calendars' => 'Filtra per calendari',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Dipende dal gruppo di appartenenza, l\'accesso al calendario sarà regolato secondo i permessi settati sul sistema.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Solo lettura: gli utenti possono visualizzare e esportare tutti gli appuntamenti nel calendario.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Muovi in: gli utenti possono modificare gli appuntamenti nel calendario, ma senza cambiare la selezione del calendario.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Creare: gli utenti possono creare e cancellare gli appuntamenti nel calendario.',
        'Read/write: users can manage the calendar itself.' => 'Lettura/scrittura: gli utenti possono gestire autonomamente il calendario.',
        'Group' => 'Gruppo',
        'Changed' => 'Modificato',
        'Created' => 'Creato',
        'Download' => 'Scarica',
        'URL' => 'URL',
        'Export calendar' => 'Esporta calendario',
        'Download calendar' => 'Scarica calendario',
        'Copy public calendar URL' => 'Copia URL pubblico calendario',
        'Calendar' => 'Calendario',
        'Calendar name' => 'Nome Calendario',
        'Calendar with same name already exists.' => 'Esiste già un calendario con lo stesso nome.',
        'Color' => 'Colore',
        'Permission group' => 'Permessi di gruppo',
        'Ticket Appointments' => 'Appuntamenti ticket',
        'Rule' => 'Regola',
        'Remove this entry' => 'Rimuovi questa voce',
        'Remove' => 'Rimuovi',
        'Start date' => 'Data di inizio',
        'End date' => 'Data fine',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Usare le opzioni sottostanti per limitare gli appuntamenti ticket che verranno creati automaticamente.',
        'Queues' => 'Code',
        'Please select a valid queue.' => 'Si prega di selezionare una coda valida.',
        'Search attributes' => 'Attributi di ricerca',
        'Add entry' => 'Aggiungi entry',
        'Add' => 'Aggiungi',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definisce le regole per creare in questo calendario appuntamenti automatici basati sui dati dei ticket.',
        'Add Rule' => 'Aggiungi Regola',
        'Submit' => 'Invia',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Caricamento Appuntamento',
        'Go back' => 'Indietro',
        'Uploaded file must be in valid iCal format (.ics).' => 'Il file caricato deve essere in formato iCal (.ics) valido.',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Il calendario desiderato non è elencato, assicurarsi di avere almeno i permessi \'crea\'.',
        'Upload' => 'Caricamento',
        'Update existing appointments?' => 'Aggiornare appuntamenti esistenti?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Tutti gli appuntamenti esistenti nel calendario con lo stesso UniqueID saranno sovrascritti.',
        'Upload calendar' => 'Carica calendario',
        'Import appointments' => 'Importa appuntamenti',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Gestione delle notifiche di appuntamento',
        'Add Notification' => 'Aggiungi notifica',
        'Edit Notification' => 'Modifica notifica',
        'Export Notifications' => 'Esportazione notifiche',
        'Filter for Notifications' => 'Filtro per notifiche',
        'Filter for notifications' => 'Filtro per notifiche',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'qui puoi caricare un file di configurazione per importare notifiche di appuntamenti nel tuo sistema.Il file deve avere il formato .yml come viene esportato dal modulo di notifiche appuntamenti .',
        'Overwrite existing notifications?' => 'Vuoi sovrascrivere le notifiche esistenti?',
        'Upload Notification configuration' => 'Carica configurazione delle notifiche',
        'Import Notification configuration' => 'Importa configurazione delle notifiche',
        'List' => 'Lista',
        'Delete' => 'Elimina',
        'Delete this notification' => 'Elimina questa notifica',
        'Show in agent preferences' => 'Mostra nelle preferenze degli agenti',
        'Agent preferences tooltip' => 'Suggerimento preferenze agente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Questo messaggio verrà visualizzato nella schermata delle preferenze dell\'agente come descrizione per questa notifica.',
        'Toggle this widget' => 'Imposta questo widget',
        'Events' => 'Eventi',
        'Event' => 'Evento',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Qui puoi scegliere quali eventi attiveranno questa notifica. Di seguito è possibile applicare un filtro di appuntamenti aggiuntivo per inviare solo appuntamenti con determinati criteri.',
        'Appointment Filter' => 'Filtro appuntamenti',
        'Type' => 'Tipo',
        'Title' => 'Titolo',
        'Location' => 'Sede',
        'Team' => 'Squadra',
        'Resource' => 'Seguenti appuntamenti sono iniziati',
        'Recipients' => 'Destinatari',
        'Send to' => 'Invia a',
        'Send to these agents' => 'Invia a questi agenti',
        'Send to all group members (agents only)' => 'Invia a tutti i membri del gruppo (solo agenti)',
        'Send to all role members' => 'Invia a tutti i membri del ruolo',
        'Send on out of office' => 'Invia se fuori sede',
        'Also send if the user is currently out of office.' => 'Invia anche se l\'utente è attualmente fuori sede.',
        'Once per day' => 'Una volta al giorno',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Avvisare l\'utente solo una volta al giorno di un singolo appuntamento utilizzando un trasporto selezionato.',
        'Notification Methods' => 'Metodi di notifica',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Questi sono i possibili metodi che possono essere utilizzati per inviare questa notifica a ciascuno dei destinatari. Seleziona almeno un metodo di seguito.',
        'Enable this notification method' => 'Abilita questo metodo di notifica',
        'Transport' => 'Trasporto',
        'At least one method is needed per notification.' => 'È necessario almeno un metodo per ogni notifica.',
        'Active by default in agent preferences' => 'Attivo di default nelle preferenze dell\'agente',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Questo è il valore predefinito per gli agenti destinatario assegnati che non hanno ancora scelto questa notifica nelle loro preferenze. Se la casella è abilitata, la notifica verrà inviata a tali agenti.',
        'This feature is currently not available.' => 'Questa funzionalità non è attualmente disponibile.',
        'Upgrade to %s' => 'Aggiorna a %s',
        'Please activate this transport in order to use it.' => 'Si prega di attivare questo trasporto per poterlo utilizzare.',
        'No data found' => 'Nessun dato trovato',
        'No notification method found.' => 'Nessun metodo di notifica trovato.',
        'Notification Text' => 'Testo della notifica',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Questa lingua non è presente o abilitata sul sistema. Questo testo di notifica può essere eliminato se non più necessario.',
        'Remove Notification Language' => 'Rimuovi lingua delle notifiche',
        'Subject' => 'Oggetto',
        'Text' => 'Testo',
        'Message body' => 'Corpo del messaggio',
        'Add new notification language' => 'Aggiungi nuova lingua delle notifiche',
        'Save Changes' => 'Salva cambiamenti',
        'Tag Reference' => 'Riferimento tag',
        'Notifications are sent to an agent.' => 'Le notifiche sono inviate ad un agente.',
        'You can use the following tags' => 'Puoi usare i seguenti tag',
        'To get the first 20 character of the appointment title.' => 'Usa i primi 20 caratteri dell\'oggetto.',
        'To get the appointment attribute' => 'Per recuperare l’attributo appuntamento',
        ' e. g.' => ' ad es.',
        'To get the calendar attribute' => 'Per ottenere l\'attributo calendario',
        'Attributes of the recipient user for the notification' => 'Attributi dell\'utente destinatario delle notifiche',
        'Config options' => 'Opzioni di configurazione',
        'Example notification' => 'Notifica di esempio',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Indirizzi email di destinazione aggiuntivi',
        'This field must have less then 200 characters.' => 'Questo campo deve avere meno di 200 caratteri.',
        'Article visible for customer' => 'Articolo visibile al cliente',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Verrà creato un articolo se la notifica viene inviata al cliente o un indirizzo e-mail aggiuntivo.',
        'Email template' => 'Modello di email',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Utilizza questo modello per generare l\'email completa (solo per email HTML).',
        'Enable email security' => 'Abilitare la sicurezza via email',
        'Email security level' => 'Livello di sicurezza email',
        'If signing key/certificate is missing' => 'Nel caso in cui il certificato di firma sia mancante',
        'If encryption key/certificate is missing' => 'Nel caso in cui la chiave di criptaggio sia mancante',

        # Template: AdminAttachment
        'Attachment Management' => 'Gestione allegati',
        'Add Attachment' => 'Aggiungi allegato',
        'Edit Attachment' => 'Modifica allegato',
        'Filter for Attachments' => 'Filtro per gli allegati',
        'Filter for attachments' => 'Filtro per allegati',
        'Filename' => 'Nome file',
        'Download file' => 'Scarica file',
        'Delete this attachment' => 'Elimina questo allegato',
        'Do you really want to delete this attachment?' => 'Vuoi veramente cancellare questo allegato?',
        'Attachment' => 'Allegato',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Gestione risposte automatiche',
        'Add Auto Response' => 'Aggiungi risposta automatica',
        'Edit Auto Response' => 'Modifica risposta automatica',
        'Filter for Auto Responses' => 'Filtri per le risposte automatiche',
        'Filter for auto responses' => 'Filtri per le risposte automatiche',
        'Response' => 'Risposta',
        'Auto response from' => 'Risposta automatica da',
        'Reference' => 'Riferimento',
        'To get the first 20 character of the subject.' => 'Usa i primi 20 caratteri dell\'oggetto.',
        'To get the first 5 lines of the email.' => 'Usa le prime 5 righe dell\'email.',
        'To get the name of the ticket\'s customer user (if given).' => 'Per ottenere il nome dell’utenza cliente del ticket (se fornito).',
        'To get the article attribute' => 'Usa l\'attributo dell\'articolo',
        'Options of the current customer user data' => 'Opzioni dei dati dell’utenza cliente attuale',
        'Ticket owner options' => 'Operazioni proprietario ticket',
        'Ticket responsible options' => 'Operazione responsabile ticket',
        'Options of the current user who requested this action' => 'Opzioni dell\'utente corrente che ha richiesto questa azione',
        'Options of the ticket data' => 'Opzioni dei dati del ticket',
        'Options of ticket dynamic fields internal key values' => 'Opzioni per i valori dei campi dinamici a livello di ticket',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opzioni per i valori dei campi dinamici a livello di ticket, utili per i campi a tendina e a selezione multipla',
        'Example response' => 'Risposta di esempio',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestione servizi Cloud',
        'Support Data Collector' => 'Collezionatore dati di supporto',
        'Support data collector' => 'Collezionatore dati di supporto',
        'Hint' => 'Suggerimento',
        'Currently support data is only shown in this system.' => 'Attualmente i dati di supporto sono mostrati solo in questo sistema.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Configurazione',
        'Send support data' => 'Invia dati di supporto',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Aggiorna',
        'System Registration' => 'Registrazione del sistema',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Registra questo sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'La registrazione è disabilitata per il tuo sistema. Controlla la tua configurazione.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Notare che i servizi sul cloud di OTOBO richiedono che il sistema sia registrato.',
        'Register this system' => 'Registra questo sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Qui puoi configurare i servizi cloud disponibili che comunicano in modo sicuro con %s.',
        'Available Cloud Services' => 'Servizi Cloud disponibili',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Log di comunicazione',
        'Time Range' => 'Intervallo di tempo',
        'Show only communication logs created in specific time range.' =>
            'Mostrare solo i registri di comunicazione creati in un intervallo di tempo specifico.',
        'Filter for Communications' => 'Filtra per Comunicazioni',
        'Filter for communications' => 'Filtro per le comunicazioni',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'In questa schermata è possibile visualizzare una panoramica delle comunicazioni in entrata e in uscita.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'È possibile modificare l\'ordinamento e l\'ordine delle colonne facendo clic sull\'intestazione della colonna.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Se fai clic sulle diverse voci, verrai reindirizzato a una schermata dettagliata sul messaggio.',
        'Status for: %s' => 'Stato per: %s',
        'Failing accounts' => 'Account con errori',
        'Some account problems' => 'Qualche problema con gli account.',
        'No account problems' => 'Nessun problema con gli account.',
        'No account activity' => 'Nessuna attività degli account.',
        'Number of accounts with problems: %s' => 'Numero di account con problemi: %s',
        'Number of accounts with warnings: %s' => 'Numero di account con avvisi: %s',
        'Failing communications' => 'Comunicazioni fallite',
        'No communication problems' => 'Nessun problema di comunicazione',
        'No communication logs' => 'Nessun log delle comunicazioni',
        'Number of reported problems: %s' => 'Numero di problemi segnalati: %s',
        'Open communications' => 'Comunicazioni aperte',
        'No active communications' => 'Nessuna comunicazione attiva',
        'Number of open communications: %s' => 'Numero di comunicazioni aperte: %s',
        'Average processing time' => 'Tempo medio di elaborazione',
        'List of communications (%s)' => ' Elenco delle comunicazioni (%s)',
        'Settings' => 'Impostazioni',
        'Entries per page' => 'Voci per pagina',
        'No communications found.' => 'Nessuna comunicazione trovata.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Stato account',
        'Back to overview' => 'Torna alla Panoramica',
        'Filter for Accounts' => 'Filtra per Account',
        'Filter for accounts' => 'Filtro per gli account',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'È possibile modificare l\'ordinamento e l\'ordine di tali colonne facendo clic sull\'intestazione della colonna.',
        'Account status for: %s' => 'Stato account per: %s',
        'Status' => 'Stato',
        'Account' => 'Account',
        'Edit' => 'Modifica',
        'No accounts found.' => 'Nessun account trovato.',
        'Communication Log Details (%s)' => 'Dettagli del log di comunicazione (%s)',
        'Direction' => 'Direzione',
        'Start Time' => 'Istante di Inizio',
        'End Time' => 'Orario di termine',
        'No communication log entries found.' => ' Nessuna voce del registro di comunicazione trovata.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Durata',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Priorità',
        'Module' => 'Modulo',
        'Information' => 'Informazione',
        'No log entries found.' => 'Nessuna voce di registro trovata.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Vista dettagliata per %s la comunicazione iniziata alle %s',
        'Filter for Log Entries' => ' Filtro per voci di registro',
        'Filter for log entries' => 'Filtro per il log',
        'Show only entries with specific priority and higher:' => 'Mostrare solo le voci con priorità specifica e superiore:',
        'Communication Log Overview (%s)' => 'Panoramica del registro di comunicazione (%s)',
        'No communication objects found.' => 'Nessun oggetto di comunicazione trovato.',
        'Communication Log Details' => 'Dettagli del log di comunicazione',
        'Please select an entry from the list.' => 'Seleziona una voce dall\'elenco.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Contatto con dati',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Torna ai risultati della ricerca',
        'Select' => 'Seleziona',
        'Search' => 'Cerca',
        'Wildcards like \'*\' are allowed.' => 'Sono permessi i caratteri jolly come \'*\'.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Valido',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestione clienti',
        'Add Customer' => 'Aggiungi cliente',
        'Edit Customer' => 'Modifica cliente',
        'List (only %s shown - more available)' => 'Elenco (%s visualizzati - altri disponibili)',
        'total' => 'totale',
        'Please enter a search term to look for customers.' => 'Inserire una chiave di ricerca per i clienti.',
        'Customer ID' => 'ID Cliente',
        'Please note' => 'Nota',
        'This customer backend is read only!' => 'Questo backend del cliente è di sola lettura!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Gestisci relazioni Cliente-Gruppo',
        'Notice' => 'Notifica',
        'This feature is disabled!' => 'Questa funzione è disabilitata!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Usa questa funzione solo se vuoi definire permessi di gruppo per i clienti.',
        'Enable it here!' => 'Abilita funzione qui!',
        'Edit Customer Default Groups' => 'Modifica gruppi predefiniti degli utenti',
        'These groups are automatically assigned to all customers.' => 'Questi gruppi saranno assegnati automaticamente a tutti gli utenti.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'È possibile gestire questi gruppi tramite l\'impostazione di configurazione "CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filtri per gruppi',
        'Select the customer:group permissions.' => 'Seleziona i permessi cliente:gruppo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se non si effettua una selezione, non ci saranno permessi in questo gruppo (i ticket non saranno disponibili al cliente)',
        'Search Results' => 'Risultato della ricerca',
        'Customers' => 'Clienti',
        'Groups' => 'Gruppi',
        'Change Group Relations for Customer' => 'Cambia relazioni di gruppo per il cliente',
        'Change Customer Relations for Group' => 'Cambia relazioni dei clienti per il gruppo',
        'Toggle %s Permission for all' => 'Imposta permesso %s per tutti',
        'Toggle %s permission for %s' => 'Imposta permesso %s per %s',
        'Customer Default Groups:' => 'Gruppi predefiniti cliente:',
        'No changes can be made to these groups.' => 'Nessun cambiamento verrà effettuato a questi gruppi.',
        'ro' => 'sola lettura',
        'Read only access to the ticket in this group/queue.' => 'Accesso in sola lettura ai ticket in questo gruppo/coda.',
        'rw' => 'lettura e scrittura',
        'Full read and write access to the tickets in this group/queue.' =>
            'Accesso completo in lettura e scrittura ai ticket in questo gruppo/coda.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestione utenze cliente',
        'Add Customer User' => 'Aggiungi utenza cliente',
        'Edit Customer User' => 'Modifica utenza cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Le utenze cliente sono necessarie per avere una cronologia del cliente e per effettuare l\'accesso dal pannello clienti.',
        'List (%s total)' => 'Elenco (% totale)',
        'Username' => 'Nome utente',
        'Email' => 'Email',
        'Last Login' => 'Ultimo accesso',
        'Login as' => 'Accedi come',
        'Switch to customer' => 'Impersona il cliente',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Questo backend clienti è in sola lettura, ma è possibile cambiare le preferenze dell’utenza cliente.',
        'This field is required and needs to be a valid email address.' =>
            'Questo campo è obbligatorio e deve contenere un indirizzo email valido.',
        'This email address is not allowed due to the system configuration.' =>
            'Questo indirizzo email non è consentito dalla configurazione di sistema.',
        'This email address failed MX check.' => 'Questo indirizzo email non ha superato il controllo MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con il DNS, verifica la tua configurazione e il log degli errori.',
        'The syntax of this email address is incorrect.' => 'La sintassi di questa email è errata.',
        'This CustomerID is invalid.' => 'Questo CustomerID è  invalido',
        'Effective Permissions for Customer User' => 'Permessi effettivi per utenza cliente',
        'Group Permissions' => 'Permessi di gruppo',
        'This customer user has no group permissions.' => 'Questa utenza cliente non ha permessi di gruppo.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'La tabella sopra mostra le autorizzazioni di gruppo di permessi per l\'utenza cliente. La matrice tiene conto di tutti i permessi ereditato (ad es. tramite gruppi di cliente). Nota: la tabella non considera le modifiche apportate a questo modulo senza inviarlo.',
        'Customer Access' => 'Accesso cliente',
        'Customer' => 'Cliente',
        'This customer user has no customer access.' => 'Questo utenza cliente non ha accesso al cliente.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'La tabella sopra mostra l\'accesso al cliente concesso all\'utenza cliente in base al contesto dell\'autorizzazione. La matrice tiene conto di tutti gli accessi ereditati (ad es. Gruppi cliente). Nota: la tabella non considera le modifiche apportate a questo modulo senza inviarlo.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Gestire le relazioni utenza cliente-cliente',
        'Select the customer user:customer relations.' => 'Seleziona le relazioni utenza cliente:cliente',
        'Customer Users' => 'Utenze clienti',
        'Change Customer Relations for Customer User' => 'Modifica le relazioni con il cliente per l\'utenza cliente',
        'Change Customer User Relations for Customer' => 'Modifica le relazioni utenza cliente per cliente',
        'Toggle active state for all' => 'Imposta stato attivo per tutti',
        'Active' => 'Attivo',
        'Toggle active state for %s' => 'Imposta stato attivo per %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Gestire le relazioni utenza cliente-gruppo',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Usa questa funzione solo se vuoi definire le permessi di gruppo per gli utenti dei cliente.',
        'Edit Customer User Default Groups' => 'Modifica gruppi predefiniti utenza cliente',
        'These groups are automatically assigned to all customer users.' =>
            'Questi gruppi vengono automaticamente assegnati a tutti gli utenti dei cliente.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'È possibile gestire questi gruppi tramite l\'impostazione di configurazione "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtri per gruppi',
        'Select the customer user - group permissions.' => 'Seleziona l\'utenza cliente - permessi di gruppo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Se non viene selezionato nulla, non ci sono permessi in questo gruppo (i ticket non saranno disponibili per l\'utenza cliente).',
        'Customer User Default Groups:' => 'Gruppi predefiniti utenza cliente:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Gestire le utenza cliente con il servizio clienti',
        'Edit default services' => 'Modifica servizi di default',
        'Filter for Services' => 'Filtri per i servizi',
        'Filter for services' => 'Filtri per i servizi',
        'Services' => 'Servizi',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestione campi dinamici',
        'Add new field for object' => 'Aggiungi un nuovo campo per l\'oggetto',
        'Filter for Dynamic Fields' => 'Filtri per Campi dinamici',
        'Filter for dynamic fields' => 'Filtri per Campi dinamici',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Database',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Utilizzare database esterni come origini dati configurabili per questo Campo dinamico.',
        'Web service' => 'Servizio web',
        'External web services can be configured as data sources for this dynamic field.' =>
            'I servizi Web esterni possono essere configurati come origini dati per questo campo dinamico.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Questa funzione consente di aggiungere (più) contatti con dati ai ticket.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Per aggiungere un nuovo campo, selezionare il tipo di campo da uno degli elenchi dell\'oggetto, l\'oggetto definisce il limite del campo e non può essere modificato dopo la creazione del campo.',
        'Dynamic Fields List' => 'Elenco campi dinamici',
        'Dynamic fields per page' => 'Campi dinamici per pagina',
        'Label' => 'Etichetta',
        'Order' => 'Ordine',
        'Object' => 'Oggetto',
        'Delete this field' => 'Elimina questo campo',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campi dinamici',
        'Go back to overview' => 'Torna alla vista globale',
        'General' => 'Generale',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Campo obbligatorio. Il valore può contenere solo lettere e numeri.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Deve essere univoco e contenere solo lettere e numeri.',
        'Changing this value will require manual changes in the system.' =>
            'La modifica di questo valore richiede modifiche manuali al sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Questo è il nome mostrato sulle pagine quando il campo è attivo.',
        'Field order' => 'Ordine del campo',
        'This field is required and must be numeric.' => 'Campo obbligatorio. Può contenere solo numeri.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Questo è l\'ordine con cui il campo sarà mostrato sulle pagine quando è attivo.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Non è possibile invalidare questa voce, tutte le impostazioni di configurazione devono essere modificate in anticipo.',
        'Field type' => 'Tipo di campo',
        'Object type' => 'Tipo di oggetto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Questo campo è protetto e non può essere eliminato.',
        'This dynamic field is used in the following config settings:' =>
            'Questo campo dinamico viene utilizzato nelle seguenti impostazioni di configurazione:',
        'Field Settings' => 'Impostazioni del campo',
        'Default value' => 'Valore predefinito',
        'This is the default value for this field.' => 'Questo è il valore predefinito per il campo.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Chiave',
        'Value' => 'Valore',
        'Remove value' => 'Rimuovi valore',
        'Add Field' => '',
        'Add value' => 'Aggiungi valore',
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
        'Translatable values' => 'Valore da tradurre',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Se attivate questa opzione i valori saranno tradotti nella lingua dell\'utente.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'È necessario aggiungere le traduzioni manualmente nei file di traduzione.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Valori ammessi',
        'Datatype' => '',
        'Filter' => 'Filtro',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Mostra collegamento',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Qui puoi specificare un collegamento http per il campo nelle schermate vista globale e zoom.',
        'Example' => 'Esempio',
        'Link for preview' => 'Link per l\'anteprima',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Se compilato, questo URL verrà utilizzato per un\'anteprima che viene mostrata quando questo link viene spostato nello zoom del ticket. Per far funzionare tutto questo, è necessario compilare anche il normale campo URL sopra.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Porta',
        'Table / View' => '',
        'User' => 'Utente',
        'Password' => 'Password',
        'Identifier' => 'Identificatore',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Selezione multipla',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Differenza predefinita tra le date',
        'This field must be numeric.' => 'Questo campo deve essere numerico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Differenza rispetto al momento attuale in secondi, per calcolare il valore predefinito del campo (ad es. 3600 o -60).',
        'Define years period' => 'Periodo in anni',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Attiva questa funzionalità per definire un intervallo fisso di anni, nel futuro e nel passato, mostrato nella parte anno del campo.',
        'Years in the past' => 'Anni nel passato',
        'Years in the past to display (default: 5 years).' => 'Anni nel passato da mostrare (predefinito: 5 anni).',
        'Years in the future' => 'Anni nel futuro',
        'Years in the future to display (default: 5 years).' => 'Anni nel futuro da mostrare (predefinito: 5 anni).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Se i caratteri speciali (&, @,:, /, ecc.) non devono essere codificati, utilizzare \'url\' invece del filtro \'uri\'.',
        'Restrict entering of dates' => 'Limita la digitazione di date',
        'Here you can restrict the entering of dates of tickets.' => 'Qui puoi limitare la digitazione delle date dei ticket.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Aggiungi valore',
        'Add empty value' => 'Aggiungi valore vuoto',
        'Activate this option to create an empty selectable value.' => 'Attiva questa opzione per creare un valore nullo selezionabile.',
        'Tree View' => 'Visualizzazione ad albero',
        'Activate this option to display values as a tree.' => 'Attiva questa opzione per visualizzare i valori come un albero.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Numero di righe',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Specifica l\'altezza (in righe) per questo campo in modalità di modifica.',
        'Number of cols' => 'Numero di colonne',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Specifica la larghezza (in caratteri) per questo campo in modalità di modifica.',
        'Check RegEx' => 'Espressione regolare di controllo',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Qui puoi specificare un\'espressione regolare per verificare il valore. Il regex verrà eseguito con i modificatori xms.',
        'RegEx' => 'Espressione regolare',
        'Invalid RegEx' => 'Espressione regolare non valida',
        'Error Message' => 'Messaggio di errore',
        'Add RegEx' => 'Aggiungi espressione regolare',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Modello',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Dimensione',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Questo campo è obbligatorio',
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
        'Admin Message' => 'Messaggio dell\'amministratore',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con questo modulo, gli amministratori possono inviare messaggi ad agenti e ai membri di gruppi o ruoli.',
        'Create Administrative Message' => 'Creazione messaggio amministrativo',
        'Your message was sent to' => 'Il messaggio è stato inviato a',
        'From' => 'Da',
        'Send message to users' => 'Invia messaggio agli utenti',
        'Send message to group members' => 'Invia messaggio ai membri del gruppo',
        'Group members need to have permission' => 'I membri del gruppo necessitano del permesso',
        'Send message to role members' => 'Invia messaggio ai membri del ruolo',
        'Also send to customers in groups' => 'Invia anche ai clienti nei gruppi',
        'Body' => 'Testo',
        'Send' => 'Invia',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Gestione dei lavori dell\'agente generico',
        'Edit Job' => 'Modifica lavoro',
        'Add Job' => 'Aggiungere lavoro',
        'Run Job' => 'Esegui lavoro',
        'Filter for Jobs' => 'Filtro per lavori',
        'Filter for jobs' => 'Filtro per lavori',
        'Last run' => 'Ultima esecuzione',
        'Run Now!' => 'Esegui ora!',
        'Delete this task' => 'Elimina questo task',
        'Run this task' => 'Esegui questo task',
        'Job Settings' => 'Impostazioni job',
        'Job name' => 'Nome job',
        'The name you entered already exists.' => 'Il nome immesso è già esistente.',
        'Automatic Execution (Multiple Tickets)' => 'Esecuzione automatica (più ticket)',
        'Execution Schedule' => 'Pianificazione esecuzione',
        'Schedule minutes' => 'Minuti della pianificazione',
        'Schedule hours' => 'Ore della pianificazione',
        'Schedule days' => 'Giorni della pianificazione',
        'Automatic execution values are in the system timezone.' => 'I valori di esecuzione automatica si trovano nel fuso orario del sistema.',
        'Currently this generic agent job will not run automatically.' =>
            'Al momento questo job agente generico non viene eseguito automaticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Per abilitare l\'esecuzione automatica, seleziona almeno un valore per i minuti, ore e giorni!',
        'Event Based Execution (Single Ticket)' => 'Esecuzione basata su eventi (ticket singolo)',
        'Event Triggers' => 'Trigger di eventi',
        'List of all configured events' => 'Elenco di tutti gli eventi configurati',
        'Delete this event' => 'Elimina questo evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Questo job può essere lanciato sulla base di eventi legati al ticket, in aggiunta o in alternativa all\'esecuzione periodica.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Se viene generato un evento ticket, verrà applicato il filtro ticket per verificare se il ticket corrisponde. Solo allora il lavoro viene eseguito su quel ticket.',
        'Do you really want to delete this event trigger?' => 'Vuoi davvero eliminare questo trigger?',
        'Add Event Trigger' => 'Aggiungi trigger di eventi',
        'To add a new event select the event object and event name' => 'Per aggiungere un nuovo evento selezionare l\'oggetto evento e il nome dell\'evento',
        'Select Tickets' => 'Seleziona ticket',
        '(e. g. 10*5155 or 105658*)' => '(per esempio \'10*5155\' o \'105658*\')',
        '(e. g. 234321)' => '(per esempio \'234321\')',
        'Customer user ID' => 'ID utenza cliente',
        '(e. g. U5150)' => '(per esempio \'U5150\')',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Ricerca a testo nell\'articolo (ad es. "Mar*in" o "Baue*").',
        'To' => 'A',
        'Cc' => 'Cc',
        'Service' => 'Servizio',
        'Service Level Agreement' => 'Accordo sul livello di servizio',
        'Queue' => 'Coda',
        'State' => 'Stato',
        'Agent' => 'Agente',
        'Owner' => 'Proprietario',
        'Responsible' => 'Responsabile',
        'Ticket lock' => 'Blocco ticket',
        'Dynamic fields' => 'Campi dinamici',
        'Add dynamic field' => '',
        'Create times' => 'Tempi di creazione',
        'No create time settings.' => 'Data di creazione mancante.',
        'Ticket created' => 'Ticket creato',
        'Ticket created between' => 'Ticket creato tra',
        'and' => 'e',
        'Last changed times' => 'Ultimo evento di modifica',
        'No last changed time settings.' => 'Nessuna ultima modifica dell\'ora.',
        'Ticket last changed' => 'Ultima modifica apportata al ticket',
        'Ticket last changed between' => 'Ultima modifica apportata al ticket fra',
        'Change times' => 'Modifica orari',
        'No change time settings.' => 'Nessuna modifica tempo.',
        'Ticket changed' => 'Ticket cambiato',
        'Ticket changed between' => 'Ticket cambiato fra',
        'Close times' => 'Tempi di chiusura',
        'No close time settings.' => 'Nessuna data di chiusura.',
        'Ticket closed' => 'Ticket chiusi',
        'Ticket closed between' => 'Ticket chiuso tra',
        'Pending times' => 'Tempi di attesa',
        'No pending time settings.' => 'Tempo di attesa non selezionato',
        'Ticket pending time reached' => 'Tempo di attesa per ticket raggiunto',
        'Ticket pending time reached between' => 'Tempo di attesa per ticket raggiunto fra ',
        'Escalation times' => 'Tempi di escalation',
        'No escalation time settings.' => 'Tempo di gestione non selezionato.',
        'Ticket escalation time reached' => 'Tempo di gestione per ticket superato',
        'Ticket escalation time reached between' => 'Tempo di gestione per ticket superato fra',
        'Escalation - first response time' => 'Escalation - Prima risposta',
        'Ticket first response time reached' => 'Tempo di prima risposta superato',
        'Ticket first response time reached between' => 'Tempo di prima risposta superato fra',
        'Escalation - update time' => 'Escalation - Aggiornamento',
        'Ticket update time reached' => 'Tempo di gestione - Aggiorna scaduto ',
        'Ticket update time reached between' => 'Tempo di gestione - Aggiorna scaduto fra',
        'Escalation - solution time' => 'Escalation - Soluzione',
        'Ticket solution time reached' => 'Tempo per soluzione scaduto',
        'Ticket solution time reached between' => 'Tempo per soluzione scaduto fra ',
        'Archive search option' => 'Opzione di ricerca in archivio',
        'Update/Add Ticket Attributes' => 'Aggiorna/Aggiungi attributi ticket',
        'Set new service' => 'Imposta nuovo servizio',
        'Set new Service Level Agreement' => 'Imposta nuovo Service Level Agreement',
        'Set new priority' => 'Imposta nuova priorità',
        'Set new queue' => 'Imposta nuova coda',
        'Set new state' => 'Imposta nuovo stato',
        'Pending date' => 'In attesa fino a',
        'Set new agent' => 'Imposta nuovo agente',
        'new owner' => 'nuovo proprietario',
        'new responsible' => 'nuovo responsabile',
        'Set new ticket lock' => 'Imposta il nuovo blocco ticket',
        'New customer user ID' => 'Nuovo ID utenza cliente',
        'New customer ID' => 'Nuovo ID cliente',
        'New title' => 'Nuovo titolo',
        'New type' => 'Nuovo tipo',
        'Archive selected tickets' => 'Archivia i ticket selezionati',
        'Add Note' => 'Aggiungi nota',
        'Visible for customer' => 'Visibile per il cliente',
        'Time units' => 'Tempo',
        'Execute Ticket Commands' => 'Esegui i comandi associati al ticket',
        'Send agent/customer notifications on changes' => 'Invia notifiche ad agente/cliente alla modifica',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Questo comando sarà eseguito. ARG[0] sarà il numero del ticket. ARG[1] sarà l\'identificativo del ticket.',
        'Delete tickets' => 'Elimina ticket',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Attenzione: Tutti i ticket corrispondenti saranno rimossi dal database e non potranno essere ripristinati!',
        'Execute Custom Module' => 'Esegui Modulo Custom',
        'Param %s key' => 'Chiave parametro %s',
        'Param %s value' => 'Valore parametro %s',
        'Results' => 'Risultati',
        '%s Tickets affected! What do you want to do?' => '%s ticket corrispondenti! Cosa vuoi fare?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Avviso: è stata usata l\'opzione ELIMINA. Tutti i ticket eliminati saranno persi!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Avvertenza: vi sono %s ticket interessati ma possono essere modificati solo %s durante l\'esecuzione di un lavoro!',
        'Affected Tickets' => 'Ticket corrispondenti',
        'Age' => 'Età',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface gestione web service',
        'Web Service Management' => 'Gestione dei servizi Web',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Ritorna al web service',
        'Clear' => 'Cancella',
        'Do you really want to clear the debug log of this web service?' =>
            'Vuoi davvero cancellare il log di debug per questo web service?',
        'Request List' => 'Lista richieste',
        'Time' => 'Tempo',
        'Communication ID' => 'ID comunicazione',
        'Remote IP' => 'IP remoto',
        'Loading' => 'Caricamento',
        'Select a single request to see its details.' => 'Seleziona una sola richiesta per vederne i dettagli.',
        'Filter by type' => 'Filtra per tipo',
        'Filter from' => 'Filtra da',
        'Filter to' => 'Filtra a',
        'Filter by remote IP' => 'Filtra per IP remoto',
        'Limit' => 'Limite',
        'Refresh' => 'Aggiorna',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Aggiungi ErrorHandling',
        'Edit ErrorHandling' => 'Modificare ErrorHandling',
        'Do you really want to delete this error handling module?' => 'Vuoi veramente cancellare questo modulo di gestione degli errori?',
        'All configuration data will be lost.' => 'Tutti i dati di configurazione saranno persi.',
        'General options' => 'Opzioni generali',
        'The name can be used to distinguish different error handling configurations.' =>
            'Il nome può essere utilizzato per distinguere diverse configurazioni di gestione degli errori.',
        'Please provide a unique name for this web service.' => 'Indica un nome univoco per questo web service.',
        'Error handling module backend' => 'Errore nella gestione del back-end del modulo',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => 'Opzioni di elaborazione',
        'Configure filters to control error handling module execution.' =>
            'Configurare i filtri per controllare l\'esecuzione del modulo di gestione degli errori.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Solo le richieste corrispondenti a tutti i filtri configurati (se presenti) attiveranno l\'esecuzione del modulo.',
        'Operation filter' => 'Filtro operativo',
        'Only execute error handling module for selected operations.' => 'Eseguire il modulo di gestione degli errori solo per le operazioni selezionate.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Nota: l\'operazione non è determinata per errori che si verificano durante la ricezione dei dati della richiesta in arrivo. I filtri che coinvolgono questa fase di errore non devono utilizzare il filtro operativo.',
        'Invoker filter' => 'Filtro Invoker',
        'Only execute error handling module for selected invokers.' => 'Eseguire il modulo di gestione degli errori solo per i chiamanti selezionati.',
        'Error message content filter' => 'Filtro contenuto messaggio di errore',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Immettere un\'espressione regolare per limitare quali messaggi di errore dovrebbero causare l\'esecuzione del modulo di gestione degli errori.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Oggetto del messaggio di errore e dati (come indicato nella voce dell\'errore del debugger) verranno considerati per una corrispondenza.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Esempio: immettere \'^.*401 Non autorizzato. *\$\' per gestire solo errori relativi all\'autenticazione.',
        'Error stage filter' => 'Filtro fase errore',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Eseguire il modulo di gestione degli errori solo sugli errori che si verificano durante specifiche fasi di elaborazione.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Esempio: gestire solo errori in cui non è stato possibile applicare la mappatura per i dati in uscita.',
        'Error code' => 'Codice di errore',
        'An error identifier for this error handling module.' => 'Un identificatore di errore per questo modulo di gestione degli errori.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Questo identificatore sarà disponibile in XSLT-Mapping e mostrato nell\'output del debugger.',
        'Error message' => 'Messaggio di errore',
        'An error explanation for this error handling module.' => 'Una spiegazione dell\'errore per questo modulo di gestione degli errori.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Questo messaggio sarà disponibile in XSLT-Mapping e mostrato in uscita debugger.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Definire se l\'elaborazione deve essere sospesa dopo è stato eseguito modulo, saltando tutti i moduli rimanenti o solo quelli dello stesso backend.',
        'Default behavior is to resume, processing the next module.' => 'Il comportamento predefinito è quello di riprendere, elaborare il modulo successivo.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Questo modulo permette di configurare in programma tentativi per le richieste non riuscite.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Il comportamento predefinito di servizi WEB un\'interfaccia generica è quella di inviare ogni richiesta esattamente una volta e non di riprogrammare dopo gli errori.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Se viene eseguito più di un modulo in grado di programmare un nuovo tentativo per una singola richiesta, il modulo eseguito per ultimo è autorevole e determina se è stato pianificato un nuovo tentativo.',
        'Request retry options' => 'Richiedi opzioni di nuovo tentativo',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Le opzioni di tentativo vengono applicate quando le richieste causano errori nella gestione del modulo (basato sulle opzioni di elaborazione).',
        'Schedule retry' => 'Riprova',
        'Should requests causing an error be triggered again at a later time?' =>
            'Le richieste che causano un errore devono essere nuovamente attivate in un secondo momento?',
        'Initial retry interval' => 'Intervallo di tentativi iniziali',
        'Interval after which to trigger the first retry.' => 'Intervallo dopo il quale attivare il primo tentativo.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Nota: questo e tutti gli altri intervalli di tentativi si basano sul tempo di esecuzione del modulo di gestione degli errori per la richiesta iniziale.',
        'Factor for further retries' => 'Fattore per ulteriori tentativi',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Se una richiesta restituisce un errore anche dopo un primo tentativo, definire se i tentativi successivi vengono attivati ​​utilizzando lo stesso intervallo o in intervalli crescenti.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Esempio: se una richiesta viene inizialmente attivata alle 10:00 con intervallo iniziale a \'1 minuto\' e fattore di ripetizione a \'2\', i tentativi verranno attivati ​​alle 10:01 (1 minuto), 10:03 (2*1 = 2 minuti), 10:07 (2*2 = 4 minuti), 10:15 (2*4 = 8 minuti), ...',
        'Maximum retry interval' => 'Intervallo massimo di tentativi',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Se si seleziona un fattore di intervallo di tentativi di \'1,5\' o \'2\', è possibile impedire intervalli indesiderabili lunghi definendo l\'intervallo massimo consentito.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Gli intervalli calcolati per superare l\'intervallo massimo di tentativi verranno automaticamente abbreviati di conseguenza.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Esempio: se una richiesta viene inizialmente attivata alle 10:00 con intervallo iniziale a \'1 minuto\', fattore di tentativo a \'2\' e intervallo massimo a \'5 minuti\', i tentativi verranno attivati ​​alle 10:01 (1 minuto), 10:03 (2 minuti), 10:07 (4 minuti), 10:12 (8 => 5 minuti), 10:17, ...',
        'Maximum retry count' => 'Numero massimo di tentativi',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Numero massimo di tentativi prima di scartare una richiesta non riuscita, senza contare la richiesta iniziale.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Esempio: se una richiesta viene inizialmente attivata alle 10:00 con intervallo iniziale a \'1 minuto\', fattore di tentativo a \'2\' e conteggio massimo dei tentativi a \'2\', i tentativi verranno attivati ​​solo alle 10:01 e 10:02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Nota: il conteggio massimo dei tentativi potrebbe non essere raggiunto se è configurato anche un periodo massimo di tentativi e raggiunto in precedenza.',
        'This field must be empty or contain a positive number.' => 'Questo campo deve essere vuoto o contenere un numero positivo.',
        'Maximum retry period' => 'Periodo massimo di tentativi',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Periodo massimo di tempo per i tentativi di richieste non riuscite prima che vengano eliminate (in base al tempo di esecuzione del modulo di gestione degli errori per la richiesta iniziale).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'I tentativi che verrebbero normalmente attivati ​​dopo che è trascorso il periodo massimo (in base al calcolo dell\'intervallo di tentativi) verranno automaticamente attivati ​​al periodo massimo esatto.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Esempio: se una richiesta viene inizialmente attivata alle 10:00 con intervallo iniziale a "1 minuto", fattore di tentativo a "2" e periodo di tentativo massimo a "30 minuti", i tentativi verranno attivati ​​alle 10:01, 10:03, 10:07, 10:15 e infine alle 10:31 => 10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Nota: il periodo massimo di tentativi potrebbe non essere raggiunto se anche un conteggio massimo tentativi è configurato e raggiunto in precedenza.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Aggiungi Invoker',
        'Edit Invoker' => 'Modifica Invoker',
        'Do you really want to delete this invoker?' => 'Vuoi davvero eliminare questo invoker?',
        'Invoker Details' => 'Dettagli dell\'Invoker',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Questo nome è normalmente usato per innescare l\'operazione di un web service remoto.',
        'Invoker backend' => 'Invoker backend',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Questo modulo di Invoker di backend viene utilizzato per preparare i dati da inviare al sistema remoto e per processare le risposte.',
        'Mapping for outgoing request data' => 'Mapping per i dati delle richieste in uscita',
        'Configure' => 'Configurazione',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'I dati dell\'Invoker OTOBO saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema remoto.',
        'Mapping for incoming response data' => 'Mapping per i dati delle richieste in ingresso',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'I dati del sistema remoto saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema OTOBO.',
        'Asynchronous' => 'Asincrono',
        'Condition' => 'Condizione',
        'Edit this event' => 'Modifica questo evento',
        'This invoker will be triggered by the configured events.' => 'Questo Invoker sarà scatenato dagli eventi configurati.',
        'Add Event' => 'Aggiungi evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Per aggiungere un nuovo evento seleziona nome e oggetto, e premi sul pulsante "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'I trigger sincroni di eventi saranno elaborati direttamente durante la richiesta web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'GenericInterface Invoker Event Settings per il servizio Web %s',
        'Go back to' => 'Torna indietro a',
        'Delete all conditions' => 'Elimina tutte le condizioni',
        'Do you really want to delete all the conditions for this event?' =>
            'Vuoi veramente cancellare tutte le condizioni per questo evento?',
        'General Settings' => 'Impostazioni generali',
        'Event type' => 'Tipo di evento',
        'Conditions' => 'Condizioni',
        'Conditions can only operate on non-empty fields.' => 'Le condizioni possono funzionare solo su campi non vuoti.',
        'Type of Linking between Conditions' => 'Tipo del collegamento tra le Condizioni',
        'Remove this Condition' => 'Rimuovi questa condizione',
        'Type of Linking' => 'Tipo di Collegamento',
        'Fields' => 'Campi',
        'Add a new Field' => 'Aggiungi un nuovo campo',
        'Remove this Field' => 'Rimuovi questo campo',
        'And can\'t be repeated on the same condition.' => 'E non può essere ripetuto nella stessa condizione.',
        'Add New Condition' => 'Aggiungi nuova condizione',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mapping Semplice',
        'Default rule for unmapped keys' => 'Regole di default per chiavi non mappate',
        'This rule will apply for all keys with no mapping rule.' => 'Questa regola sarà applicata per tutte le chiavi senza regole specifiche di mapping',
        'Default rule for unmapped values' => 'Regola di default per valori non mappati',
        'This rule will apply for all values with no mapping rule.' => 'Questa regola sarà applicata per tutti i valori senza regole specifiche di mapping',
        'New key map' => 'Nuova mappatura chiavi',
        'Add key mapping' => 'Aggiungi mappatura chiavi',
        'Mapping for Key ' => 'Mappatura per la chiave',
        'Remove key mapping' => 'Rimuovere mappatura chiave',
        'Key mapping' => 'Mappatura chiave',
        'Map key' => 'Chiave Sorgente',
        'matching the' => 'appaiata con',
        'to new key' => 'Chiave Destinazione',
        'Value mapping' => 'Mappatura valori',
        'Map value' => 'Valore Sorgente',
        'to new value' => 'Valore Destinazione',
        'Remove value mapping' => 'Rimuovere mappatura valori',
        'New value map' => 'Nuova mappatura valori',
        'Add value mapping' => 'Aggiungi mappatura valori',
        'Do you really want to delete this key mapping?' => 'Vuoi davvero eliminare questa mappatura?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Scorciatoie generiche',
        'MacOS Shortcuts' => 'Scorciatoie MacOS',
        'Comment code' => 'Codice commento',
        'Uncomment code' => 'Rimuovere il codice commento',
        'Auto format code' => 'Auto formato codice',
        'Expand/Collapse code block' => 'Espandi / comprimi blocco di codice',
        'Find' => 'Trova',
        'Find next' => 'Trova successivo',
        'Find previous' => 'Trova precedente',
        'Find and replace' => 'Trova e sostituisci',
        'Find and replace all' => 'Trova e sostituisci tutto',
        'XSLT Mapping' => 'Mappa XSLT',
        'XSLT stylesheet' => 'Foglio di stile XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'I dati inseriti non sono un foglio di stile XSLT valido.',
        'Here you can add or modify your XSLT mapping code.' => 'Qui puoi aggiungere o modificare il codice di mappatura XSLT.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'Il campo di modifica consente di utilizzare diverse funzioni come la formattazione automatica, il ridimensionamento della finestra e il completamento di tag e parentesi.',
        'Data includes' => 'Certificato client',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Selezionare uno o più set di dati che sono stati creati nelle fasi precedenti di richiesta/risposta da includere nei dati mappabili.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Questi set appariranno nella struttura dei dati in \'/ DataInclude/<DataSetName>\'(vedere l\'output del debugger delle richieste effettive per i dettagli).',
        'Data key regex filters (before mapping)' => 'Filtri regex chiave dati (prima della mappatura)',
        'Data key regex filters (after mapping)' => 'Filtri regex chiave dati (dopo la mappatura)',
        'Regular expressions' => 'Espressioni regolari',
        'Replace' => 'Sostituisci',
        'Remove regex' => 'Rimuovi espressione regolare',
        'Add regex' => 'Aggiungi espressione regolare',
        'These filters can be used to transform keys using regular expressions.' =>
            'Questi filtri possono essere usati per trasformare le chiavi usando espressioni regolari.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'La struttura dei dati verrà attraversata in modo ricorsivo e tutte le regex configurate verranno applicate a tutte le chiavi.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'I casi d\'uso sono ad es. rimozione di prefissi chiave indesiderati o correzione di chiavi non valide come nomi di elementi XML.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Esempio 1: Cerca = \'^jira:\' / Sostituisci = \'\' trasforma \'jira:element\' in \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Esempio 2: Cerca = \'^\' / Sostituisci = \'_\' trasforma \'16x16\' in \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Esempio 3: Cerca = \'^ (?<number>\ d +) (?<text>. +?) \ $\' / Sostituisci = \'_\$+{text}_ \$+{numero}\' trasforma \'16 elementname \'into \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Per informazioni sulle espressioni regolari in Perl, consultare qui:',
        'Perl regular expressions tutorial' => 'Tutorial sulle espressioni regolari del Perl',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Se si desidera che i modificatori debbano essere specificati all\'interno delle regex stesse.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Le espressioni regolari qui definite verranno applicate prima della mappatura XSLT.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Le espressioni regolari qui definite verranno applicate dopo la mappatura XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Aggiungi operazione',
        'Edit Operation' => 'Modifica operazione',
        'Do you really want to delete this operation?' => 'Vuoi davvero eliminare questa operazione?',
        'Operation Details' => 'Dettagli operazione',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Il nome è solitamente utilizzato per richiamare questa operazione del web service da un sistema remoto',
        'Operation backend' => 'Motore operazione',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Questo modulo di backend di OTOBO sarà chiamato internamente per elaborare la richiesta, generando i dati per la risposta.',
        'Mapping for incoming request data' => 'Mappatura per i dati in ingresso',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'I dati del sistema remoto saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema OTOBO.',
        'Mapping for outgoing response data' => 'Mappatura per i dati in uscita',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'I dati ricevuti saranno trasformati con questa mappatura, per modificarli secondo le aspettative del sistema remoto.',
        'Include Ticket Data' => 'Includi dati ticket',
        'Include ticket data in response.' => 'Include i dati del ticket nella risposta.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Trasporto di rete',
        'Properties' => 'Proprietà',
        'Route mapping for Operation' => 'Mappatura di instradamento per l\'Operazione',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Definire il percorso che dovrebbe essere mappato a questa operazione. Le variabili contrassegnate da un \':\' verranno mappate al nome inserito e passate insieme alle altre alla mappatura. (ad es. / Ticket /: TicketID).',
        'Valid request methods for Operation' => 'Metodi di richiesta validi per l\'operazione',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limitare questa operazione a metodi di richiesta specifici. Se non viene selezionato alcun metodo, verranno accettate tutte le richieste.',
        'Maximum message length' => 'Lunghezza massima del messaggio',
        'This field should be an integer number.' => 'Questo campo deve essere un numero intero.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            '',
        'Send Keep-Alive' => 'Invia Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Questa configurazione definisce se le connessioni in entrata devono essere chiuse o mantenute attive.',
        'Additional response headers' => 'Intestazioni di risposta aggiuntive',
        'Add response header' => 'Aggiungi intestazione risposta',
        'Endpoint' => 'Terminatore',
        'URI to indicate specific location for accessing a web service.' =>
            'URI per indicare la posizione specifica per l\'accesso a un servizio web.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Tempo scaduto',
        'Timeout value for requests.' => 'Valore di time scaduto per le richieste.',
        'Authentication' => 'Autenticazione',
        'An optional authentication mechanism to access the remote system.' =>
            'Un meccanismo di autenticazione opzionale per accedere al sistema remoto.',
        'BasicAuth User' => 'Utente BasicAuth',
        'The user name to be used to access the remote system.' => 'Utente per accesso al sistema remoto.',
        'BasicAuth Password' => 'Password BasicAuth',
        'The password for the privileged user.' => 'Password per l\'utente',
        'Use Proxy Options' => 'Usa le opzioni proxy',
        'Show or hide Proxy options to connect to the remote system.' => 'Mostrare o nascondi le opzioni proxy per connettersi al sistema remoto.',
        'Proxy Server' => 'Server proxy',
        'URI of a proxy server to be used (if needed).' => 'URI del Proxy Server, se richiesto',
        'e.g. http://proxy_hostname:8080' => 'es. http://proxy_hostname:8080',
        'Proxy User' => 'Utente del proxy',
        'The user name to be used to access the proxy server.' => 'Utente per l\'accesso al Proxy Server',
        'Proxy Password' => 'Password per l\'utente del proxy',
        'The password for the proxy user.' => 'La password per l\'utente per il proxy.',
        'Skip Proxy' => 'Salta Proxy',
        'Skip proxy servers that might be configured globally?' => 'Salta i server proxy che potrebbero essere configurati a livello globale?',
        'Use SSL Options' => 'Opzione per utilizzo di SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Mostra o nascondi l\'opzione SSL per connettersi al sistema remoto.',
        'Client Certificate' => 'Certificato del cliente',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Il percorso completo e il nome del file del certificato client SSL (deve essere in formato PEM, DER o PKCS # 12).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'esempio: /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Chiave del certificato client',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Il percorso completo e il nome del file della chiave del certificato client SSL (se non già incluso nel file del certificato).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'ad es. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Password chiave certificato client',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'La password per aprire il certificato SSL se la chiave è crittografata.',
        'Certification Authority (CA) Certificate' => 'Certificato Autorità di certificazione (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Percorso completo e nome del file dell\'autorità di certificazione che convalida il certificato SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'es. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Cartella dell\'autorità di certificazione (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Percorso completo e nome del file della directory che contiene i certificati CA',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'es. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Mappatura del controller per l\'invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Il controller a cui il chiamante deve inviare richieste. Le variabili contrassegnate da un \':\' verranno sostituite dal valore dei dati e passate insieme alla richiesta. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password)',
        'Valid request command for Invoker' => 'Comando di richiesta per l\'invoker valido',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Uno specifico comando HTTP da utilizzare per le richieste con questo invoker (facoltativo).',
        'Default command' => 'Comando predefinito',
        'The default HTTP command to use for the requests.' => 'Il comando HTTP predefinito da utilizzare per le richieste.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'ad es. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Imposta SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Impostare su "Sì" per inviare un\'intestazione SOAPAction riempita.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Impostare su "No" al fine di inviare un header SOAPAction vuota.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Impostare su "Sì" al fine di verificare l\'intestazione SOAPAction ricevuto (se non vuoto).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Impostare su "No" per ignorare l\'intestazione SOAPAction ricevuto.',
        'SOAPAction scheme' => 'Schema SOAPAction',
        'Select how SOAPAction should be constructed.' => 'Seleziona come deve essere costruita SOAPAction.',
        'Some web services require a specific construction.' => 'Alcuni servizi Web richiedono una costruzione specifica.',
        'Some web services send a specific construction.' => 'Alcuni servizi Web inviano una costruzione specifica.',
        'SOAPAction separator' => 'separatore SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            'Carattere da utilizzare come separatore tra spazio dei nomi e operazione SOAP.',
        'Usually .Net web services use "/" as separator.' => 'Di solito i servizi web .Net usano "/" come separatore.',
        'SOAPAction free text' => 'SOAPAction testo libero',
        'Text to be used to as SOAPAction.' => 'Testo da utilizzare come SOAPAction.',
        'Namespace' => 'Spazio dei nomi',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI per indicare ai metodi SOAP il contesto, per ridurre le ambiguità',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'es. rn:otobo-com:soap:functions o http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Schema del nome di richiesta',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Seleziona la modalità di creazione del involucro della funzione di richiesta SOAP.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' viene utilizzato come esempio per il nome effettivo dell\'operatore / operazione.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' è un esempio di valore realmente configurato.',
        'Request name free text' => 'Richiedi nome testo libero',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Testo da utilizzare come suffisso o sostituzione del nome del involucro di funzione.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Considera le restrizioni sulla denominazione degli elementi XML (ad es. Non utilizzare "<" e "&").',
        'Response name scheme' => 'Schema del nome di risposta',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Seleziona la modalità di creazione del wrapper della funzione di risposta SOAP.',
        'Response name free text' => 'Testo del nome di risposta',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Specifica il la dimensione massima (in byte) del messaggio SOAP che OTOBO elaborerà.',
        'Encoding' => 'Codifica',
        'The character encoding for the SOAP message contents.' => 'La codifica di caratteri del contenuto del messaggio SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'es. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => 'Opzioni di ordinamento',
        'Add new first level element' => 'Aggiungi nuovo elemento di primo livello',
        'Element' => 'Elemento',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Ordinamento in uscita per i campi xml (struttura che inizia sotto il wrapper del nome della funzione): consultare la documentazione per il trasporto SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Aggiungi servizio Web',
        'Edit Web Service' => 'Modifica servizio WEB',
        'Clone Web Service' => 'Clona Servizio Web',
        'The name must be unique.' => 'Il nome deve essere univoco.',
        'Clone' => 'Copia',
        'Export Web Service' => 'Esporta web service',
        'Import web service' => 'Importa web service',
        'Configuration File' => 'File di Configurazione',
        'The file must be a valid web service configuration YAML file.' =>
            'Il file deve essere un file di configurazione di web service in formato YAML.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Qui è possibile specificare un nome per il servizio web. Se questo campo è vuoto, il nome del file di configurazione viene utilizzato come nome.',
        'Import' => 'Importa',
        'Configuration History' => 'Cronologia di configurazione',
        'Delete web service' => 'Elimina il web service',
        'Do you really want to delete this web service?' => 'Vuoi davvero eliminare questo web service?',
        'Ready2Adopt Web Services' => 'Ready2Adopt Web Services',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Qui è possibile attivare i servizi Web Ready2Adopt in mostra le nostre migliori pratiche che fanno parte di %s.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Si noti che questi servizi Web possono dipendere da altri moduli disponibili solo con determinati %s livelli di contratto (ci sarà una notifica con ulteriori dettagli durante l\'importazione).',
        'Import Ready2Adopt web service' => 'Importa il servizio Web Ready2Adopt',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            'Vorresti beneficiare dei servizi web creati da esperti? L\'aggiornamento a %s per importare alcuni sofisticati servizi web Ready2Adopt.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Dopo aver salvato, sarai rediretto alla schermata di modifica.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se vuoi ritornare alla vista globale, utilizza il pulsante "Vai alla vista globale".',
        'Remote system' => 'Sistema Remoto',
        'Provider transport' => 'Trasporto del Provider',
        'Requester transport' => 'Trasporto del Richiedente',
        'Debug threshold' => 'Soglia di debug',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'In modalità fornitore, OTOBO espone web service utilizzati dai sistemi remoti.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'In modalità richiedente, OTOBO sfrutta i web service del sistema remoto',
        'Network transport' => 'Network transport',
        'Error Handling Modules' => 'Moduli di gestione degli errori',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'I moduli di gestione degli errori vengono utilizzati per reagire in caso di errori durante la comunicazione. Tali moduli vengono eseguiti in un ordine specifico, che può essere modificato trascinandolo.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Aggiungi modulo di gestione degli errori',
        'Operations are individual system functions which remote systems can request.' =>
            'Operazioni sono funzionalità singole che i sistemi remoti possono richiedere',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Gli invoker preparano i dati per una richiesta al web service di un sistema remoto, e processano i dati ricevuti in risposta',
        'Controller' => 'Controller',
        'Inbound mapping' => 'Mappatura in ingresso',
        'Outbound mapping' => 'Mappatura in uscita',
        'Delete this action' => 'Elimina questa azione',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Almeno un %s ha un controller che è non attivo o non disponibile, verifica la registrazione del controller o elimina la %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Storico',
        'Go back to Web Service' => 'Ritorna al web service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Qui potete vedere le versioni precedenti della configurazione del web service, potete esportarle o ripristinale.',
        'Configuration History List' => 'Elenco storico configurazioni',
        'Version' => 'Versione',
        'Create time' => 'Data di Creazione',
        'Select a single configuration version to see its details.' => 'Selezionate una sola versione per vederne i dettagli.',
        'Export web service configuration' => 'Esporta la configurazione del web service',
        'Restore web service configuration' => 'Ripristina la configurazione del web service',
        'Do you really want to restore this version of the web service configuration?' =>
            'Vuoi davvero ripristinare questa versione della configurazione del web service?',
        'Your current web service configuration will be overwritten.' => 'La configurazione attuale del web service sarà sovrascritta.',

        # Template: AdminGroup
        'Group Management' => 'Gestione gruppo',
        'Add Group' => 'Inserisci gruppo',
        'Edit Group' => 'Modifica gruppo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Il gruppo admin ha accesso all\'area di amministrazione mentre il gruppo stats ha accesso alle statistiche.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crea nuovi gruppi per gestire i permessi di accesso per diversi gruppi di agenti (ad esempio il dipartimento acquisti, dipartimento di supporto, dipartimento vendite, ...). ',
        'It\'s useful for ASP solutions. ' => 'È utile per soluzioni ASP. ',

        # Template: AdminLog
        'System Log' => 'Log di sistema',
        'Here you will find log information about your system.' => 'Qui si troveranno informazioni di log sul sistema.',
        'Hide this message' => 'Nascondi questo messaggio',
        'Recent Log Entries' => 'Interazioni recenti',
        'Facility' => 'Funzione',
        'Message' => 'Messaggio',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gestione Credenziali Mail ',
        'Add Mail Account' => 'Aggiungi account di posta',
        'Edit Mail Account for host' => 'Modifica account di posta per host',
        'and user account' => 'e account utente',
        'Filter for Mail Accounts' => 'Filtro per account di posta',
        'Filter for mail accounts' => 'Filtro per account di posta',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Tutte le e-mail in arrivo con un account verranno spedite nella coda selezionata.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Se il tuo account è contrassegnato come attendibile, le intestazioni X-OTRS già esistenti all\'ora di arrivo (per priorità ecc.) Verranno conservate e utilizzate, ad esempio nei filtri PostMaster.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'La posta elettronica in uscita può essere configurata tramite le impostazioni di Sendmail * in %s.',
        'System Configuration' => 'Configurazione di sistema',
        'Host' => 'Server',
        'Delete account' => 'Elimina account',
        'Fetch mail' => 'Scarica posta',
        'Do you really want to delete this mail account?' => 'Vuoi veramente cancellare questo account di posta?',
        'Example: mail.example.com' => 'Esempio: mail.esempio.it',
        'IMAP Folder' => 'Cartella IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifica questo solo per recuperare la posta da una cartella diversa da INBOX',
        'Trusted' => 'Fidato',
        'Dispatching' => 'Smistamento',
        'Edit Mail Account' => 'Modifica account di posta',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Panoramica dell\'amministrazione',
        'Filter for Items' => 'Filtro per articoli',
        'Favorites' => 'Preferiti',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Puoi aggiungere i preferiti spostando il cursore sugli elementi a destra e facendo clic sull\'icona a forma di stella.',
        'Links' => 'Collegamenti',
        'View the admin manual on Github' => 'Visualizza il manuale di amministrazione su Github',
        'No Matches' => 'Nessuna corrispondenza',
        'Sorry, your search didn\'t match any items.' => 'Siamo spiacenti, la tua ricerca non ha prodotto risultati.',
        'Set as favorite' => 'Imposta come preferito',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gestione delle notifiche dei ticket',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Qui puoi caricare un file di configurazione per importare le Notifiche ticket sul tuo sistema. Il file deve essere in formato .yml esportato dal modulo Notifica ticket.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Qui puoi scegliere quali eventi attiveranno questa notifica. Di seguito è possibile applicare un filtro ticket aggiuntivo per inviare il ticket solo con determinati criteri.',
        'Ticket Filter' => 'Filtro ticket',
        'Lock' => 'Blocca',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID utenza cliente',
        'Article Filter' => 'Filtro articoli',
        'Only for ArticleCreate and ArticleSend event' => 'Solo per eventi ArticleCreate e ArticleSend',
        'Article sender type' => 'Tipologia del mittente dell\'articolo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Se ArticleCreate o ArticleSend viene utilizzato come evento trigger, è necessario specificare anche un filtro articolo. Seleziona almeno uno dei campi filtro articolo.',
        'Customer visibility' => 'Visibilità cliente',
        'Communication channel' => 'Canale di comunicazione',
        'Include attachments to notification' => 'Includi allegati nella notifica',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Avvisare l\'utente una sola volta al giorno di un singolo ticket utilizzando un trasporto selezionato.',
        'This field is required and must have less than 4000 characters.' =>
            'Questo campo è obbligatorio e deve contenere meno di 4000 caratteri.',
        'Notifications are sent to an agent or a customer.' => 'Le notifiche sono inviate ad un agente o a un cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Per avere i primi 20 caratteri mail - subject (agent) ',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Per avere le prime 5 righe del corpo messaggio (dell\'ultimo articolo dell\'agente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Per avere i primi 20 caratteri mail - subject (customer).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Per avere le prime 5 righe corpo mail (customer).',
        'Attributes of the current customer user data' => 'Attributi dei dati utente del cliente attuale',
        'Attributes of the current ticket owner user data' => 'Attributi dei dati utente del proprietario del ticket corrente',
        'Attributes of the current ticket responsible user data' => 'Attributi dei dati utente responsabili del ticket corrente',
        'Attributes of the current agent user who requested this action' =>
            'Attributi dell\'attuale utente agente che ha richiesto questa azione',
        'Attributes of the ticket data' => 'Attributi dei dati del ticket',
        'Ticket dynamic fields internal key values' => 'Valori chiave interni dei campi dinamici del ticket',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'I campi dinamici del ticket visualizzano valori, utili per i campi Dropdown e Multiselect',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Utilizzare la virgola o il punto e virgola per separare gli indirizzi e-mail.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'Gestione PGP',
        'Add PGP Key' => 'Aggiungi chiave PGP',
        'PGP support is disabled' => 'Il supporto PGP è disabilitato',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Per poter utilizzare PGP in OTOBO, devi prima abilitarlo.',
        'Enable PGP support' => 'Abilita supporto PGP',
        'Faulty PGP configuration' => 'Configurazione PGP non valida',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Il supporto PGP è abilitato, ma la relativa configurazione contiene errori. Si prega di verificare la configurazione usando il pulsante qui sotto.',
        'Configure it here!' => 'Configuralo qui!',
        'Check PGP configuration' => 'Controlla la configurazione PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'In questo modo puoi configurare direttamente il portachiavi PGP in SysConfig',
        'Introduction to PGP' => 'Introduzione a PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Impronta (fingerprint)',
        'Expires' => 'Scade',
        'Delete this key' => 'Elimina questa chiave',
        'PGP key' => 'Chiave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestione Pacchetti',
        'Uninstall Package' => 'Disinstalla pacchetto',
        'Uninstall package' => 'Disinstalla pacchetto',
        'Do you really want to uninstall this package?' => 'Vuoi davvero disinstallare questo pacchetto?',
        'Reinstall package' => 'Reinstalla pacchetto',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Vuoi davvero reinstallare questo pacchetto? Ogni modifica manuale sarà persa.',
        'Go to updating instructions' => 'Vai alle istruzioni di aggiornamento',
        'Go to the OTOBO customer portal' => 'Val al portale clienti di OTOBO',
        'package information' => 'informazioni sul pacchetto',
        'Package installation requires a patch level update of OTOBO.' =>
            '',
        'Package update requires a patch level update of OTOBO.' => '',
        'Please note that your installed OTOBO version is %s.' => '',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            '',
        'This package can only be installed on OTOBO version %s or older.' =>
            '',
        'This package can only be installed on OTOBO version %s or newer.' =>
            '',
        'Why should I keep OTOBO up to date?' => '',
        'You will receive updates about relevant security issues.' => 'Riceverai aggiornamenti su importanti problemi di sicurezza.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Come posso effettuare un aggiornamento a livello di patch se non ho un contratto?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Tutte le informazioni pertinenti sono disponibili nelle istruzioni di aggiornamento all\'indirizzo %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'Nel caso dovessi avere altre domande, saremo felici di risponderti.',
        'Please visit our customer portal and file a request.' => 'Per cortesia visita il nostro portale clienti e inoltra una richiesta.',
        'Install Package' => 'Installa pacchetto',
        'Update Package' => 'Aggiorna pacchetto',
        'Continue' => 'Continua',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Assicurati che il tuo database accetti i pacchetti %s dimensioni MB (al momento accetta solo pacchetti fino a %s MB). Adatta l\'impostazione max_allowed_packet del tuo database per evitare errori.',
        'Install' => 'Installa',
        'Update repository information' => 'Aggiorna informazioni sui repository',
        'Cloud services are currently disabled.' => 'I servizi cloud sono attualmente disabilitati.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify non può continuare!',
        'Enable cloud services' => 'Abilita i servizi cloud',
        'Update all installed packages' => 'Aggiorna tutti i pacchetti installati',
        'Online Repository' => 'Archivio Online',
        'Vendor' => 'Fornitore',
        'Action' => 'Azione',
        'Module documentation' => 'Documentazione sul modulo',
        'Local Repository' => 'Archivio Locale',
        'This package is verified by OTOBOverify (tm)' => 'Questo pacchetto è verificato da OTOBOverify (tm)',
        'Uninstall' => 'Disinstalla',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Estensione non installata correttamente! Reinstalla il pacchetto!',
        'Reinstall' => 'Re-installa',
        'Features for %s customers only' => 'Funzionalità solo per i clienti %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s, puoi beneficiare delle seguenti funzionalità opzionali. Contatta %s se hai bisogno di ulteriori informazioni.',
        'Package Information' => 'Informazioni sul pacchetto',
        'Download package' => 'Scarica pacchetto',
        'Rebuild package' => 'Ricostruisci pacchetto',
        'Metadata' => 'Metadati',
        'Change Log' => 'Storia delle Modifiche',
        'Date' => 'Data',
        'List of Files' => 'Lista dei file',
        'Permission' => 'Permessi',
        'Download file from package!' => 'Scarica file dal pacchetto!',
        'Required' => 'Richiesto',
        'Primary Key' => 'Chiave primaria',
        'Auto Increment' => 'Incremento automatico',
        'SQL' => 'Limite',
        'File Differences for File %s' => 'Differenze di file per file %s',
        'File differences for file %s' => 'Differenze per il file %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log delle Performance',
        'Range' => 'Intervallo',
        'last' => 'ultimo',
        'This feature is enabled!' => 'Funzione abilitata',
        'Just use this feature if you want to log each request.' => 'Usa questa funzionalità per tracciare ogni richiesta.',
        'Activating this feature might affect your system performance!' =>
            'L\'attivazione di questa funzionalità può ridurre le prestazioni del sistema.',
        'Disable it here!' => 'Disabilita funzione qui',
        'Logfile too large!' => 'Log File troppo grande ',
        'The logfile is too large, you need to reset it' => 'Il file di log è troppo grande, è necessario un reset del file',
        'Reset' => 'Ripristina',
        'Overview' => 'Vista Globale',
        'Interface' => 'Interfaccia',
        'Requests' => 'Richieste',
        'Min Response' => 'Minimo per Risposta',
        'Max Response' => 'Massimo per Risposta',
        'Average Response' => 'Media per Risposta',
        'Period' => 'Periodo',
        'minutes' => 'minuti',
        'Min' => 'Minimo',
        'Max' => 'Massimo',
        'Average' => 'Media',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gestione filtri posta in ingresso',
        'Add PostMaster Filter' => 'Aggiungi filtro PostMaster',
        'Edit PostMaster Filter' => 'Modifica filtro PostMaster',
        'Filter for PostMaster Filters' => 'Filtro per filtri PostMaster',
        'Filter for PostMaster filters' => 'Filtro per filtri PostMaster',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Per gestire o filtrare email in entrata basandosi sugli header. È anche possibile usare espressioni regolari.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se vuoi che corrisponda solo negli indirizzi di email , usa EMAILADDRESS:info@example.com in From, To or Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se desideri usare espressioni regolari, puoi usare il valore corrispondente tra () come [***] nell\'azione \'Set\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Puoi anche utilizzare acquisizioni con nome %s e utilizzare i nomi nell\'azione "Imposta" %s (ad es. Regexp: %s, Imposta azione: %s). Un EMAILADDRESS abbinato ha il nome \'%s\'.',
        'Delete this filter' => 'Elimina questo filtro',
        'Do you really want to delete this postmaster filter?' => 'Vuoi veramente eliminare questo filtro postmaster?',
        'A postmaster filter with this name already exists!' => 'Esiste già un filtro postmaster con questo nome!',
        'Filter Condition' => 'Condizione per il filtro',
        'AND Condition' => 'Condizione AND',
        'Search header field' => 'Cerca campo di intestazione',
        'for value' => 'per valore',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Il campo deve essere una espressione regolare valida o una parola specifica.',
        'Negate' => 'Nega',
        'Set Email Headers' => 'Imposta intestazione dell\'email',
        'Set email header' => 'Imposta intestazione dell\'email',
        'with value' => 'con valore',
        'The field needs to be a literal word.' => 'Il campo deve essere una parola specifica',
        'Header' => 'Intestazione',

        # Template: AdminPriority
        'Priority Management' => 'Gestione Priorità',
        'Add Priority' => 'Aggiungi Priorità',
        'Edit Priority' => 'Modifica Priorità',
        'Filter for Priorities' => 'Filtro per priorità',
        'Filter for priorities' => 'Filtro per priorità',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Questa priorità è presente in un\'impostazione di SysConfig, è necessaria la conferma dell\'aggiornamento delle impostazioni per puntare alla nuova priorità!',
        'This priority is used in the following config settings:' => 'Questa priorità viene utilizzata nelle seguenti impostazioni di configurazione:',

        # Template: AdminProcessManagement
        'Process Management' => 'Gestione dei processi',
        'Filter for Processes' => 'Filtra per Processo',
        'Filter for processes' => 'Filtro per processi',
        'Create New Process' => 'Crea Nuovo Processo',
        'Deploy All Processes' => 'Attiva tutti i processi',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Qui è possibile importare un file di configurazione per importare un processo a sistema. Il file deve essere in formato .yml come esportato dal modulo di export della gestione processi',
        'Upload process configuration' => 'Carica la configurazione di processo',
        'Import process configuration' => 'Importa la configurazione di processo',
        'Ready2Adopt Processes' => 'Processi Ready2Adopt',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Qui è possibile attivare i processi Ready2Adopt che mostrano le nostre migliori pratiche. Si noti che potrebbe essere necessaria una configurazione aggiuntiva.',
        'Import Ready2Adopt process' => 'Importa il processo Ready2Adopt',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Per creare un nuovo processo puoi importare un processo esportato da un altro sistema o crearne uno completamente nuovo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'I cambiamenti al processo sono riportati a sistema solo se effettuate la sincronizzazione. Con la sincronizzazione le modifiche sono scritte nella configurazione.',
        'Processes' => 'Processi',
        'Process name' => 'Nome del processo',
        'Print' => 'Stampa',
        'Export Process Configuration' => 'Esporta la configurazione del processo',
        'Copy Process' => 'Copia il Processo',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annulla e chiudi',
        'Go Back' => 'Indietro',
        'Please note, that changing this activity will affect the following processes' =>
            'Attenzione, i cambiamenti a questa attività influenzano i seguenti processi',
        'Activity' => 'Attività',
        'Activity Name' => 'Nome dell\'attività',
        'Activity Dialogs' => 'Interazioni dell\'attività',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare le interazioni dell\'attività trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Puoi ordinare gli elementi dell\'elenco anche attraverso il trascinamento.',
        'Filter available Activity Dialogs' => 'Imposta un filtro alle interazioni delle attività disponibili.',
        'Available Activity Dialogs' => 'Interazioni dell\'attività disponibili',
        'Name: %s, EntityID: %s' => 'Nome: %s, EntityID:  %s',
        'Create New Activity Dialog' => 'Crea una nuova interazione per l\'attività',
        'Assigned Activity Dialogs' => 'Interazioni per l\'attività assegnati',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Attenzione, i cambiamenti a questo messaggio delle attività influenzano le seguenti attività',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Notare che l\'utenza cliente non potrà vedere o usare i seguenti campi: Proprietario, Responsabile, Blocco, TempoAttesa e IDCliente.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Il campo Coda può essere utilizzato solo dai clienti durante la creazione di un nuovo ticket.',
        'Activity Dialog' => 'messaggio dell\'attività',
        'Activity dialog Name' => 'Nome per messaggio dell\'attività',
        'Available in' => 'Disponibile in',
        'Description (short)' => 'Descrizione (breve)',
        'Description (long)' => 'Descrizione (estesa)',
        'The selected permission does not exist.' => 'Il permesso selezionato non esiste.',
        'Required Lock' => 'Blocco richiesto',
        'The selected required lock does not exist.' => 'Il lock richiesto e selezionato non esiste.',
        'Submit Advice Text' => 'Testo per i suggerimenti di invio',
        'Submit Button Text' => 'Testo per il bottone di invio',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare campi a questo messaggio di attività trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Filter available fields' => 'Filtro sui campi disponibili',
        'Available Fields' => 'Campi disponibili',
        'Assigned Fields' => 'Campi assegnati',
        'Communication Channel' => 'Canale di comunicazione',
        'Is visible for customer' => 'È visibile per il cliente',
        'Display' => 'Mostra',

        # Template: AdminProcessManagementPath
        'Path' => 'percorso',
        'Edit this transition' => 'Modifica questa transizione',
        'Transition Actions' => 'Azioni di transizione',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Puoi assegnare azioni di transizione a questo transizione trascinando gli elementi con il mouse dalla lista di sinistra a quella di destra.',
        'Filter available Transition Actions' => 'Filtra sulle azioni di transizioni disponibili',
        'Available Transition Actions' => 'Azioni di transizione disponibili',
        'Create New Transition Action' => 'Crea nuova azione di transizione',
        'Assigned Transition Actions' => 'Azione di transizione assegnate',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Attività',
        'Filter Activities...' => 'Filtra attività...',
        'Create New Activity' => 'Crea nuova attività...',
        'Filter Activity Dialogs...' => 'Filtra le interazioni dell\'attività',
        'Transitions' => 'Transizioni',
        'Filter Transitions...' => 'Filtra sulle transizioni...',
        'Create New Transition' => 'Crea Nuova Transizione',
        'Filter Transition Actions...' => 'Filtra sulle azioni di transizione',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Modifica Processo',
        'Print process information' => 'Stampa le informazioni del processo',
        'Delete Process' => 'Elimina processo',
        'Delete Inactive Process' => 'Elimina processo inattivo',
        'Available Process Elements' => 'Elementi di Processo disponibili',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Gli elementi presenti sopra questa barra possono essere spostati nel riquadro a destra trascinandoli.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Puoi immettere Attività nel riquadro per assegnare l\'Attività al Processo',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Per assegnare un messaggio di attività ad una attività trascinare il messaggio dalla barra sopra l\'attività nel riquadro.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'È possibile avviare una connessione tra due attività rilasciando l\'elemento Transizione sull\'attività di avvio della connessione. Dopodiché puoi spostare l\'estremità libera della freccia su Fine attività.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Le azioni possono essere assegnate ad una transizione trascinando l\'elemento sulla descrizione della trascrizione.',
        'Edit Process Information' => 'Modifica le informazioni del Processo',
        'Process Name' => 'Nome del Processo',
        'The selected state does not exist.' => 'Lo stato selezionato non esiste.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Aggiungi e modifica le attività, le interazioni delle attività e le transizioni',
        'Show EntityIDs' => 'Mostra gli identificativi EntityID',
        'Extend the width of the Canvas' => 'Aumenta la larghezza del riquadro',
        'Extend the height of the Canvas' => 'Aumenta l\'altezza del riquadro',
        'Remove the Activity from this Process' => 'Rimuovi l\'attività dal processo',
        'Edit this Activity' => 'Modifica questa attività',
        'Save Activities, Activity Dialogs and Transitions' => 'Salva attività, finestre di attività e transizioni',
        'Do you really want to delete this Process?' => 'Vuoi davvero eliminare questo processo?',
        'Do you really want to delete this Activity?' => 'Vuoi davvero eliminare questa attività?',
        'Do you really want to delete this Activity Dialog?' => 'Vuoi davvero eliminare questa finestra dell\'attività?',
        'Do you really want to delete this Transition?' => 'Vuoi davvero eliminare questa transizione?',
        'Do you really want to delete this Transition Action?' => 'Vuoi davvero eliminare questa azione di transizione?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vuoi davvero rimuovere questa attività dal riquadro? Ciò può essere annullato solo uscendo dalla schermata senza salvare.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Vuoi davvero rimuovere questa transizione dal riquadro? Ciò può essere annullato solo uscendo dalla schermata senza salvare.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'In questa schermata puoi creare un nuovo processo. Per rendere il nuovo processo disponibile agli utenti, occorre mettere lo stato in \'Attivo\' ed effettuare la sincronizzazione al termine del lavoro.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'annulla e chiudi',
        'Start Activity' => 'Avvia attività',
        'Contains %s dialog(s)' => 'Contiene %s finestra(e)',
        'Assigned dialogs' => 'Finestre assegnate',
        'Activities are not being used in this process.' => 'Le attività non sono utilizzate in questo processo.',
        'Assigned fields' => 'Campi assegnati',
        'Activity dialogs are not being used in this process.' => 'Le finestre di attività non sono utilizzate in questo processo.',
        'Condition linking' => 'Collegamento delle condizioni',
        'Transitions are not being used in this process.' => 'Le transizioni non sono utilizzate in questo processo.',
        'Module name' => 'Nome del modulo',
        'Transition actions are not being used in this process.' => 'Le azioni di transizione non sono utilizzate in questo processo.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Attenzione, i cambiamenti a questa transizione impattano sui seguenti processi',
        'Transition' => 'Transizione',
        'Transition Name' => 'Nome della Transizione',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Attenzione, i cambiamenti a questa azione di transizione impattano sui seguenti processi',
        'Transition Action' => 'Azione di Transizione',
        'Transition Action Name' => 'Nome dell\'azione di transizione',
        'Transition Action Module' => 'Modulo per l\'azione di transizione',
        'Config Parameters' => 'parametri di configurazione',
        'Add a new Parameter' => 'Aggiungi un nuovo parametro',
        'Remove this Parameter' => 'Rimuovi questo parametro',

        # Template: AdminQueue
        'Queue Management' => 'Gestione coda',
        'Add Queue' => 'Aggiungi coda',
        'Edit Queue' => 'Modifica coda',
        'Filter for Queues' => 'Filtri per le code',
        'Filter for queues' => 'Filtro per le code',
        'A queue with this name already exists!' => 'Una coda con questo nome esiste già!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Questa coda è presente in un\'impostazione SysConfig, è necessaria la conferma dell\'aggiornamento delle impostazioni per puntare alla nuova coda!',
        'Sub-queue of' => 'Sotto-coda di',
        'Unlock timeout' => 'Tempo di sblocco automatico',
        '0 = no unlock' => '0 = nessuno sblocco automatico',
        'hours' => 'ore',
        'Only business hours are counted.' => 'Sono considerate solo le ore lavorative.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se un agente blocca un ticket e non lo chiude prima dello sblocco automatico, il ticket viene sbloccato e diventa disponibile per altri agenti.',
        'Notify by' => 'Notificato da',
        '0 = no escalation' => '0 = nessuna escalation',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se non c\'è un nuovo contatto con il cliente, sia per email che per telefono per un ticket nuovo, prima che il tempo qui definito scada, il ticket viene scalato.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se c\'è un articolo aggiunto, come un follow-up o il portale cliente, il tempo di aggiornamento di scalo viene azzerato. Se non c\'è un contatto con il cliente, sia per posta che per telefono, aggiunto al ticket prima che scada il tempo definito qui, il ticket viene scalato.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se il ticket non viene impostato a chiuso prima che scada il tempo qui definito, il ticket viene scalato.',
        'Follow up Option' => 'Opzioni per i follow-up',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Specifica se i follow-up ai ticket chiusi riaprono i ticket, vengono respinti o portano a un nuovo ticket.',
        'Ticket lock after a follow up' => 'Blocco del ticket dopo una prosecuzione',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se un ticket viene chiuso e il cliente invia un follow-up, il ticket sarà preso in carica dal vecchio proprietario.',
        'System address' => 'Indirizzo di sistema',
        'Will be the sender address of this queue for email answers.' => 'Sarà l’indirizzo del mittente di questa cosa per le risposte via email.',
        'Default sign key' => 'Chiave di default per le firme',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Per utilizzare una chiave di segno, è necessario aggiungere chiavi PGP o certificati S / MIME con identificatori per l\'indirizzo di sistema della coda selezionato.',
        'Salutation' => 'Saluto',
        'The salutation for email answers.' => 'Saluto (parte iniziale) per le email generate automaticamente dal sistema.',
        'Signature' => 'Firma',
        'The signature for email answers.' => 'Firma (parte finale) per le email generate automaticamente dal sistema.',
        'This queue is used in the following config settings:' => 'Questa coda viene utilizzata nelle seguenti impostazioni di configurazione:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gestisci relazioni Coda-Risposte automatiche',
        'Change Auto Response Relations for Queue' => 'Cambia le relazioni delle risposte automatiche con la coda',
        'This filter allow you to show queues without auto responses' => 'Questo filtro ti consente di mostrare le code senza risposte automatiche',
        'Queues without Auto Responses' => 'Code senza risposte automatiche',
        'This filter allow you to show all queues' => 'Questo filtro ti consente di mostrare tutte le code',
        'Show All Queues' => 'Mostra tutte le code',
        'Auto Responses' => 'Risposte Automatiche',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Gestione relazioni Modelli-Code',
        'Filter for Templates' => 'Filtro per modelli',
        'Filter for templates' => 'Filtro per modelli',
        'Templates' => 'Modelli',

        # Template: AdminRegistration
        'System Registration Management' => 'Gestione della registrazione del sistema',
        'Edit System Registration' => 'Modifica la registrazione del sistema',
        'System Registration Overview' => 'Panoramica sulla registrazione del sistema',
        'Register System' => 'Sistema di registro',
        'Validate OTOBO-ID' => '',
        'Deregister System' => 'Cancella registrazione sistema',
        'Edit details' => 'Modifica i dettagli',
        'Show transmitted data' => 'Mostra i dati trasmessi',
        'Deregister system' => 'Cancella registrazione sistema',
        'Overview of registered systems' => 'Riepilogo dei sistemi registrati',
        'This system is registered with OTOBO Team.' => 'Questo sistema è registrato con OTOBO Team.',
        'System type' => 'Tipo di sistema',
        'Unique ID' => 'ID univoco',
        'Last communication with registration server' => 'Ultima comunicazione con il server di registrazione',
        'System Registration not Possible' => 'Registrazione del sistema non possibile',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Nota che non puoi registrare il tuo sistema se OTOBO Daemon non è correttamente in esecuzione!',
        'Instructions' => 'Istruzioni',
        'System Deregistration not Possible' => 'Cancellazione del sistema non possibile',
        'OTOBO-ID Login' => 'Accesso OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'La registrazione del sistema è un servizio di OTOBO Team, che fornisce molti vantaggi!',
        'Read more' => 'Leggi altro',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Devi accedere con il tuo OTOBO-ID per registrare il tuo sistema.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Il tuo OTOBO-ID è l\'indirizzo email che hai utilizzato per registrarti sulla pagina web di OTOBO.com.',
        'Data Protection' => 'Protezione dati',
        'What are the advantages of system registration?' => 'Quali sono i vantaggi della registrazione del sistema?',
        'You will receive updates about relevant security releases.' => 'Riceverai aggiornamenti sui rilascio di sicurezza importanti.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Con la registrazione del sistema, possiamo migliorare il nostro servizio per te, poiché abbiamo la disponibilità di tutte le informazioni rilevanti.',
        'This is only the beginning!' => 'Questo è solo l\'inizio!',
        'We will inform you about our new services and offerings soon.' =>
            'Ti informeremo sui nostri nuovi servizi e sulle offerte in arrivo.',
        'Can I use OTOBO without being registered?' => 'Posso utilizzare OTOBO senza essere registrato?',
        'System registration is optional.' => 'La registrazione del sistema è facoltativa.',
        'You can download and use OTOBO without being registered.' => 'Puoi scaricare e utilizzare OTOBO senza essere registrato.',
        'Is it possible to deregister?' => 'È possibile cancellare la registrazione?',
        'You can deregister at any time.' => 'Puoi cancellare la registrazione in qualsiasi momento.',
        'Which data is transfered when registering?' => 'Quali dati sono trasferiti con la registrazione?',
        'A registered system sends the following data to OTOBO Team:' => 'Un sistema registrato invia i dati seguenti a OTOBO Team:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Nome di dominio qualificato (FQDN), versione OTOBO, database, sistema operativo e versione Perl.',
        'Why do I have to provide a description for my system?' => 'Perché devo fornire una descrizione del mio sistema?',
        'The description of the system is optional.' => 'La descrizione del sistema è facoltativa.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'La descrizione e il tipo di sistema che specifichi ti aiutano a identificare e gestire i dettagli dei tuoi sistemi registrati.',
        'How often does my OTOBO system send updates?' => 'Quanto spesso il mio sistema OTOBO invia aggiornamenti?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Il tuo server invierà aggiornamenti al server di registrazione a intervalli regolari.',
        'Typically this would be around once every three days.' => 'Normalmente dovrebbe avvenire una volta ogni tre giorni.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se cancelli la registrazione del tuo sistema, perderai questi vantaggi:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Devi accedere con il tuo OTOBO-ID per cancellare la registrazione del tuo sistema.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Non hai ancora un OTOBO-ID?',
        'Sign up now' => 'Registrazione',
        'Forgot your password?' => 'Hai dimenticato la password?',
        'Retrieve a new one' => 'Ottienine uno nuovo',
        'Next' => 'Successivo',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Questi dati saranno trasferiti frequentemente a OTOBO Team quando registri questo sistema.',
        'Attribute' => 'Attributo',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'Versione OTOBO',
        'Operating System' => 'Sistema operativo',
        'Perl Version' => 'Versione di Perl',
        'Optional description of this system.' => 'Descrizione facoltativa del sistema.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Ciò consentirà al sistema di inviare dati di supporto aggiuntivi a OTRS Group.',
        'Register' => 'Registra',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Se si prosegue con questo passaggio, la registrazione del sistema sarà cancellata da OTOBO Team.',
        'Deregister' => 'Cancella registrazione',
        'You can modify registration settings here.' => 'Puoi modificare qui le impostazioni di registrazione.',
        'Overview of Transmitted Data' => 'Panoramica dei dati trasmessi',
        'There is no data regularly sent from your system to %s.' => 'Non ci sono dati inviati regolarmente dal tuo sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'I seguenti dati sono inviati almeno ogni 3 giorni dal tuo sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'I dati saranno trasferiti in formato JSON tramite una connessione sicura HTTPS.',
        'System Registration Data' => 'Dati di registrazione del sistema',
        'Support Data' => 'Dati di supporto',

        # Template: AdminRole
        'Role Management' => 'Gestione ruoli',
        'Add Role' => 'Aggiungi Ruolo',
        'Edit Role' => 'Modifica ruolo',
        'Filter for Roles' => 'Filtri per i ruoli',
        'Filter for roles' => 'Filtro per ruoli',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crea un ruolo e mettici i gruppi. Poi aggiungi il ruolo agli utenti.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Non ci sono ruoli definiti. Usa il tasto Aggiungi per crearne uno nuovo.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gestione relazioni ruolo-gruppo',
        'Roles' => 'Ruoli',
        'Select the role:group permissions.' => 'Seleziona i permessi ruolo:gruppo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se non si seleziona niente, non ci sono permessi in questo gruppo (i ticket non saranno disponibili per questo ruolo).',
        'Toggle %s permission for all' => 'Imposta il permesso %s per tutti',
        'move_into' => 'sposta_in',
        'Permissions to move tickets into this group/queue.' => 'Permessi per spostare i ticket in questo gruppo/coda.',
        'create' => 'crea',
        'Permissions to create tickets in this group/queue.' => 'Permessi per creare ticket in questo gruppo/coda.',
        'note' => 'Annotazioni',
        'Permissions to add notes to tickets in this group/queue.' => 'Permesso di aggiungere note ai ticket in questo gruppo/coda.',
        'owner' => 'gestore',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permessi per cambiare il gestore dei ticket in questo gruppo/coda.',
        'priority' => 'priorità',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Autorizzazione a cambiare la priorità di un ticket in questo gruppo/coda.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gestisci relazioni Agente-Ruolo',
        'Add Agent' => 'Aggiungi agente',
        'Filter for Agents' => 'Filtra per agenti',
        'Filter for agents' => 'Filtro per agenti',
        'Agents' => 'Agenti',
        'Manage Role-Agent Relations' => 'Gestisci relazioni Ruolo-Agente',

        # Template: AdminSLA
        'SLA Management' => 'Gestione SLA',
        'Edit SLA' => 'Modifica SLA',
        'Add SLA' => 'Aggiungi SLA',
        'Filter for SLAs' => 'Filtro per SLA',
        'Please write only numbers!' => 'Usa solo numeri!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestione S/MIME ',
        'Add Certificate' => 'Aggiungi certificato',
        'Add Private Key' => 'Aggiunti chiave privata',
        'SMIME support is disabled' => 'Il supporto SMIME è disabilitato',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Per poter utilizzare SMIME in OTOBO, devi prima abilitarlo.',
        'Enable SMIME support' => 'Abilita supporto SMIME',
        'Faulty SMIME configuration' => 'Configurazione SMIME non valida',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Il supporto SMIME è abilitato, ma la relativa configurazione contiene errori. Si prega di verificare la configurazione usando il pulsante qui sotto',
        'Check SMIME configuration' => 'Controllo configurazione SMIME',
        'Filter for Certificates' => 'Filtro per certificati',
        'Filter for certificates' => 'Filtro per i certificati',
        'To show certificate details click on a certificate icon.' => 'Per mostrare i dettagli del certificato, fai clic sull\'icona del certificato.',
        'To manage private certificate relations click on a private key icon.' =>
            'Per gestire le relazione del certificato privato, fai clic sull\'icona di una chiave privata.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Qui puoi aggiungere relazioni al tuo certificato privato, che verranno incorporate nella firma S / MIME ogni volta che usi questo certificato per firmare un\'email.',
        'See also' => 'Vedi anche',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',
        'Hash' => 'Puoi modificare il certificato e la chiave privata direttamente sul filesystem.',
        'Create' => 'Crea',
        'Handle related certificates' => 'Gestisci i certificati collegati',
        'Read certificate' => 'leggi il certificato',
        'Delete this certificate' => 'Elimina questo certificato',
        'File' => 'File',
        'Secret' => 'Segreto',
        'Related Certificates for' => 'Certificato collegato a',
        'Delete this relation' => 'Elimina questa relazione',
        'Available Certificates' => 'Certificati disponibili',
        'Filter for S/MIME certs' => 'Filtro per i certificati S/MIME',
        'Relate this certificate' => 'Collegati a questo certificato',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificato S/MIME',
        'Certificate Details' => 'Dettagli certificato',
        'Close this dialog' => 'Chiudere questa schermata',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestione saluti',
        'Add Salutation' => 'Aggiungi saluto',
        'Edit Salutation' => 'Modifica saluto',
        'Filter for Salutations' => 'Filtro per i Saluti',
        'Filter for salutations' => 'Filtro per i saluti',
        'e. g.' => 'es.',
        'Example salutation' => 'Saluto di esempio',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'La modalità protetta deve essere abilitata!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'La modalità sicura (normalmente) viene abilitata dopo il completamento installazione.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se non è attivata la modalità sicura, attivarla tramite SySConfig perché il programma è già in esecuzione.',

        # Template: AdminSelectBox
        'SQL Box' => 'script SQL ',
        'Filter for Results' => 'Filtro per risultati',
        'Filter for results' => 'Filtra per risultati',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Qui è possibile inserire SQL per inviarlo direttamente al database dell\'applicazione. Non è possibile modificare il contenuto delle tabelle, sono consentite solo determinate query.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Qui è possibile inserire SQL per inviarlo direttamente al database.',
        'Options' => 'Opzioni',
        'Only select queries are allowed.' => 'Sono consentite solo query di selezione.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintassi della query SQL è sbagliata.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'C\'è almeno un parametro mancante per il binding. Controlla.',
        'Result format' => 'Formato dei risultati',
        'Run Query' => 'Esegui query',
        '%s Results' => '%s risultati',
        'Query is executed.' => 'La query è eseguita.',

        # Template: AdminService
        'Service Management' => 'Gestione Servizi',
        'Add Service' => 'inserisci un servizio',
        'Edit Service' => 'Modifica servizio',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'La lunghezza massima del nome del servizio è di 200 caratteri (con sottoservizio).',
        'Sub-service of' => 'Sotto-servizio di',

        # Template: AdminSession
        'Session Management' => 'Gestione Sessioni',
        'Detail Session View for %s (%s)' => 'Vista dettagli sessione per %s (%s)',
        'All sessions' => 'Tutte le sessioni',
        'Agent sessions' => 'Sessioni agenti',
        'Customer sessions' => 'Sessioni clienti',
        'Unique agents' => 'Agenti unici',
        'Unique customers' => 'Clienti unici',
        'Kill all sessions' => 'termina tutte le sessioni',
        'Kill this session' => 'Termina questa sessione',
        'Filter for Sessions' => 'Filtra per sessioni',
        'Filter for sessions' => 'Filtra per sessioni',
        'Session' => 'Sessione',
        'Kill' => 'Termina',
        'Detail View for SessionID: %s - %s' => 'Vista dettagli per SessionID: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Gestione firme digitali',
        'Add Signature' => 'Aggiungi firma',
        'Edit Signature' => 'Modifica firma',
        'Filter for Signatures' => 'Filtro per Firme',
        'Filter for signatures' => 'Filtro per firme',
        'Example signature' => 'Firma di esempio',

        # Template: AdminState
        'State Management' => 'Gestione Stati',
        'Add State' => 'inserisci stato',
        'Edit State' => 'Modifica stato',
        'Filter for States' => 'Filtra per Stati',
        'Filter for states' => 'Filtra per stati',
        'Attention' => 'Attenzione',
        'Please also update the states in SysConfig where needed.' => 'Aggiorna anche gli stati in SysConfig, dove necessario.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Questo stato è presente in un\'impostazione SysConfig, è necessaria una conferma per l\'aggiornamento delle impostazioni per puntare al nuovo tipo!',
        'State type' => 'Tipo di stato',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Non è possibile invalidare questa voce perché non ci sono altri stati di unione nel sistema!',
        'This state is used in the following config settings:' => 'Questo stato viene utilizzato nelle seguenti impostazioni di configurazione:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'Non è possibile inviare dati di supporto al gruppo OTOBO!',
        'Enable Cloud Services' => 'Abilita servizi cloud',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Questi dati sono inviati a OTOBO Team con regolarità. Per fermare l\'invio di questi dati, aggiorna la tua registrazione di sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'È possibile attivare manualmente l\'invio dei dati di supporto premendo questo pulsante:',
        'Send Update' => 'Invia aggiornamento',
        'Currently this data is only shown in this system.' => 'Attualmente questi dati sono mostrati solo in questo sistema.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Consigliamo vivamente di inviare questi dati a OTOBO Team per ottenere un supporto migliore.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Per abilitare l\'invio di dati, registrare il sistema con OTRS Group o aggiornare le informazioni di registrazione del sistema (assicurarsi di attivare l\'opzione "invia dati di supporto").',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Un bundle di supporto (incluso: informazioni sulla registrazione del sistema, dati di supporto, un elenco di pacchetti installati e tutti i file di codice sorgente modificati localmente) può essere generato premendo questo pulsante:',
        'Generate Support Bundle' => 'Genera pacchetto di supporto',
        'The Support Bundle has been Generated' => 'Il pacchetto di supporto è stato generato',
        'Please choose one of the following options.' => 'Scegli una delle seguenti opzioni.',
        'Send by Email' => 'Invia tramite posta',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Il pacchetto di supporto è troppo grande per inviarlo via e-mail, questa opzione è stata disabilitata.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'L\'indirizzo email per questo utente non è valido, questa opzione è stata disabilitata.',
        'Sending' => 'Mittente',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'Il pacchetto di supporto verrà inviato automaticamente al gruppo OTRS via e-mail.',
        'Download File' => 'Scarica file',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'Un file contenente il pacchetto di supporto verrà scaricato nel sistema locale. Salvare il file e inviarlo al gruppo OTRS, utilizzando un metodo alternativo.',
        'Error: Support data could not be collected (%s).' => 'Errore: i dati di supporto non possono essere collezionati (%s).',
        'Details' => 'Dettagli',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gestione indirizzi Email di sistema',
        'Add System Email Address' => 'Aggiungi indirizzo email di sistema',
        'Edit System Email Address' => 'Modifica indirizzo email di sistema',
        'Add System Address' => 'Aggiungi indirizzo di sistema',
        'Filter for System Addresses' => 'Filtro per Indirizzi di Sistema',
        'Filter for system addresses' => 'Filtro per indirizzi di sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Tutta la posta in entrata con questo indirizzo in A: o Cc: verrà inoltrata alla coda selezionata.',
        'Email address' => 'Indirizzo email',
        'Display name' => 'Nome visibile',
        'This email address is already used as system email address.' => 'Questo indirizzo email è già utilizzato come indirizzo email di sistema.',
        'The display name and email address will be shown on mail you send.' =>
            'Il nome visualizzato e l\'indirizzo email verranno visualizzati sulle email inviate da qui.',
        'This system address cannot be set to invalid.' => 'Questo indirizzo di sistema non può essere impostato su non valido.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Questo indirizzo di sistema non può essere impostato su non valido, poiché viene utilizzato in una coda(e) o risposta(e) automatica.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'documentazione dell\'amministratore online',
        'System configuration' => 'Configurazione di sistema',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Navigare attraverso le impostazioni disponibili utilizzando l\'albero nella casella di navigazione sul lato sinistro.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Trova alcune impostazioni utilizzando il campo di ricerca in basso o dall\'icona di ricerca nella barra di navigazione in alto.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Scopri come utilizzare la configurazione del sistema leggendo il %s.',
        'Search in all settings...' => 'Cerca in tutte le impostazioni ...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Al momento non ci sono impostazioni disponibili. Assicurati di eseguire \'otrs.Console.pl Maint::Config::Rebuild\' prima di utilizzare il software.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Attivazione modifiche',
        'Help' => 'Aiuto',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Questa è una panoramica di tutte le impostazioni che faranno parte dell\'attivazione che sta per effettuare. È possibile confrontare ogni impostazione con il suo stato precedente facendo clic sull\'icona in alto a destra.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'Per escludere alcune impostazioni dall\'attivazione, fare clic sulla casella di spunta nella barra di intestazione dell\'impostazione.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'In modo predefinito, verrano attivate solo le impostazioni cambiate da te. Per attivare impostazioni cambiate da altri utenti, fare clic sul link nella parte superiore dello schermo per passare alla modalità di attivazione avanzata.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Una distribuzione è stata appena ripristinata, il che significa che tutte le impostazioni interessate sono state ripristinate allo stato dalla distribuzione selezionata.',
        'Please review the changed settings and deploy afterwards.' => 'Rivedere le impostazioni cambiate e attivare in seguito',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Un elenco vuoto di modifiche significa che non ci sono differenze tra lo stato ripristinato e quello corrente delle impostazioni interessate.',
        'Changes Overview' => 'Panoramica delle modifiche',
        'There are %s changed settings which will be deployed in this run.' =>
            'Ci sono %s impostazioni cambiate che verranno attivate in questa esecuzione.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Passare alla modalità base per attivare soltanto le impostazioni cambiate da te.',
        'You have %s changed settings which will be deployed in this run.' =>
            'Hai %s impostazioni cambiate che verranno attivate in questa esecuzione.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Passare alla modalità avanzata per attivare anche le impostazioni cambiate dagli altri utenti.',
        'There are no settings to be deployed.' => 'Non ci sono impostazioni da attivare.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Passare alla modalità base per vedere le impostazioni attivabili cambiati dagli altri utenti.',
        'Deploy selected changes' => 'Attiva le modifiche selezionate',

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
        'by' => 'da',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Questo gruppo non contiene alcuna impostazione. Prova a navigare in uno dei suoi sottogruppi.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importa ed esporta',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Carica un file da importare nel tuo sistema (formato .yml esportato dal modulo di configurazione del sistema).',
        'Upload system configuration' => 'Carica la configurazione del sistema',
        'Import system configuration' => 'Importa la configurazione del sistema',
        'Download current configuration settings of your system in a .yml file.' =>
            'Scarica le impostazioni di configurazione correnti del tuo sistema in un file .yml.',
        'Include user settings' => 'Includi impostazioni utente',
        'Export current configuration' => 'Esporta la configurazione corrente',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Cercare',
        'Search for category' => 'Cerca per categoria',
        'Settings I\'m currently editing' => 'Impostazioni che sto modificando',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'La tua ricerca di "%s" nella categoria "%s" non ha restituito alcun risultato.',
        'Your search for "%s" in category "%s" returned one result.' => 'La tua ricerca di "%s" nella categoria "%s" ha restituito un risultato.',
        'Your search for "%s" in category "%s" returned %s results.' => 'La tua ricerca di "%s" nella categoria "%s" tornò %s risultati.',
        'You\'re currently not editing any settings.' => 'Al momento non stai modificando alcuna impostazione.',
        'You\'re currently editing %s setting(s).' => 'Attualmente stai modificando %s impostazione(i).',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Categoria',
        'Run search' => 'Esegui ricerca',

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
        'View a custom List of Settings' => 'Visualizza un elenco personalizzato di impostazioni',
        'View single Setting: %s' => 'Visualizza impostazione singola: %s',
        'Go back to Deployment Details' => 'Torna ai dettagli di attivazione',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Gestione delle manutenzioni del sistema',
        'Schedule New System Maintenance' => 'Pianifica nuova manutenzione di sistema',
        'Filter for System Maintenances' => 'Filtro per manutenzioni di sistema',
        'Filter for system maintenances' => 'Filtro per manutenzioni di sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Pianifica un periodo di manutenzione del sistema per annunciare agli agenti e ai clienti che il sistema sarà non disponibile per un certo intervallo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Qualche tempo prima dell\'inizio della manutenzione del sistema, gli utenti riceveranno una notifica su ogni schermata che annuncia questo fatto.',
        'Stop date' => 'Data di fine',
        'Delete System Maintenance' => 'Elimina manutenzione di sistema',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Modifica manutenzione del sistema',
        'Edit System Maintenance Information' => 'Modifica le informazioni di manutenzione del sistema',
        'Date invalid!' => 'Data invalida!',
        'Login message' => 'Messaggio all\'accesso',
        'This field must have less then 250 characters.' => 'Questo campo deve contenere meno di 250 caratteri.',
        'Show login message' => 'Mostra messaggio all\'accesso',
        'Notify message' => 'Messaggio di notifica',
        'Manage Sessions' => 'Gestisci sessioni',
        'All Sessions' => 'Tutte le sessioni',
        'Agent Sessions' => 'Sessioni agente',
        'Customer Sessions' => 'Sessioni clienti',
        'Kill all Sessions, except for your own' => 'Termina tutte le sessioni, eccetto la tua',

        # Template: AdminTemplate
        'Template Management' => 'Gestione del modello',
        'Add Template' => 'Aggiungi modello',
        'Edit Template' => 'Modifica modello',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Un modello è un testo predefinito che aiuta gli agenti a scrivere più velocemente ticket, risposte o inoltri.',
        'Don\'t forget to add new templates to queues.' => 'Non dimenticare di aggiungere nuovi modelli alle code.',
        'Attachments' => 'Allegati',
        'Delete this entry' => 'Elimina questa voce',
        'Do you really want to delete this template?' => 'Vuoi veramente cancellare questo modello?',
        'A standard template with this name already exists!' => 'Un modello standard con questo nome esiste già!',
        'Create type templates only supports this smart tags' => 'Crea modelli di tipi supporta solo questi smart tag',
        'Example template' => 'Modello di esempio',
        'The current ticket state is' => 'Lo stato attuale del ticket è',
        'Your email address is' => 'Il tuo indirizzo email è',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Gestisci relazioni modello-allegato',
        'Toggle active for all' => 'Imposta attivo per tutti',
        'Link %s to selected %s' => 'Collega %s a %s selezionato',

        # Template: AdminType
        'Type Management' => 'Gestione tipologie',
        'Add Type' => 'Aggiungi tipo',
        'Edit Type' => 'Modifica tipo',
        'Filter for Types' => 'Filtro per Tipi',
        'Filter for types' => 'Filtro per tipi',
        'A type with this name already exists!' => 'Un tipo con questo nome esiste già!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Questo tipo è presente in un\'impostazione SysConfig, è necessaria una conferma per l\'aggiornamento delle impostazioni per puntare al nuovo tipo!',
        'This type is used in the following config settings:' => 'Questo tipo viene utilizzato nelle seguenti impostazioni di configurazione:',

        # Template: AdminUser
        'Agent Management' => 'Gestione agenti',
        'Edit Agent' => 'Modifica agente',
        'Edit personal preferences for this agent' => 'Modifica le preferenze personali per questo agente.',
        'Agents will be needed to handle tickets.' => 'Gli agenti servono a gestire i ticket.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Non dimenticare di aggiungere un nuovo agente ai gruppi e/o ai ruoli!',
        'Please enter a search term to look for agents.' => 'Inserisci una chiave di ricerca per trovare gli agenti.',
        'Last login' => 'Ultimo accesso',
        'Switch to agent' => 'Passa all’agente',
        'Title or salutation' => 'Titolo o formula di saluto',
        'Firstname' => 'Nome',
        'Lastname' => 'Cognome',
        'A user with this username already exists!' => 'Un utente con questo nome esiste già!',
        'Will be auto-generated if left empty.' => 'Sarà generato automaticamente se lasciato vuoto.',
        'Mobile' => 'Cellulare',
        'Effective Permissions for Agent' => 'Permessi in vigore per agente',
        'This agent has no group permissions.' => 'Questo agente non ha permessi di gruppo.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'La tabella sopra mostra i permessi di gruppo efficaci per l\'agente. La matrice tiene conto di tutti i permessi ereditari (ad es. Tramite ruoli).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestisci relazioni Agentge-Gruppo',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Panoramica dell\'Agenda',
        'Manage Calendars' => 'Amministrazione Calendari',
        'Add Appointment' => 'Aggiungi Evento',
        'Today' => 'Oggi',
        'All-day' => 'Giorno intero',
        'Repeat' => 'Ripetizione',
        'Notification' => 'Notifica',
        'Yes' => 'Sì',
        'No' => 'No',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Nessun calendario trovato. Si prega di aggiungere in primis un calendario utilizzando la pagina di Gestione dei calendari.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Aggiungi nuovo appuntamento',
        'Calendars' => 'Calendari',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Informazioni di base',
        'Date/Time' => 'Data/ora',
        'Invalid date!' => 'Data non valida!',
        'Please set this to value before End date.' => 'Si prega di impostare questo valore prima della data di fine.',
        'Please set this to value after Start date.' => 'Si prega di impostare questo valore dopo la data di inizio.',
        'This an occurrence of a repeating appointment.' => 'Questo è il verificarsi di un appuntamento ricorrente.',
        'Click here to see the parent appointment.' => 'Clicca qui per vedere l\'appuntamento dei genitori.',
        'Click here to edit the parent appointment.' => 'Fai clic qui per modificare l\'appuntamento principale.',
        'Frequency' => 'Frequenza',
        'Every' => 'Ogni',
        'day(s)' => 'giorno(i)',
        'week(s)' => 'settimana(e)',
        'month(s)' => 'mese(i)',
        'year(s)' => 'anno(i)',
        'On' => 'Acceso',
        'Monday' => 'Lunedì',
        'Mon' => 'Lun',
        'Tuesday' => 'Martedì',
        'Tue' => 'Mar',
        'Wednesday' => 'Mercoledì',
        'Wed' => 'Mer',
        'Thursday' => 'Giovedì',
        'Thu' => 'Gio',
        'Friday' => 'Venerdì',
        'Fri' => 'Ven',
        'Saturday' => 'Sabato',
        'Sat' => 'Sab',
        'Sunday' => 'Domenica',
        'Sun' => 'Dom',
        'January' => 'Gennaio',
        'Jan' => 'Gen',
        'February' => 'Febbraio',
        'Feb' => 'Feb',
        'March' => 'Marzo',
        'Mar' => 'Mar',
        'April' => 'Aprile',
        'Apr' => 'Apr',
        'May_long' => 'Maggio',
        'May' => 'Mag',
        'June' => 'Giugno',
        'Jun' => 'Giu',
        'July' => 'Luglio',
        'Jul' => 'Lug',
        'August' => 'Agosto',
        'Aug' => 'Ago',
        'September' => 'Settembre',
        'Sep' => 'Set',
        'October' => 'Ottobre',
        'Oct' => 'Ott',
        'November' => 'Novembre',
        'Nov' => 'Nov',
        'December' => 'Dicembre',
        'Dec' => 'Dic',
        'Relative point of time' => 'Punto di tempo relativo',
        'Link' => 'Collega',
        'Remove entry' => 'Rimuovi voce',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro informazioni clienti',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Utenza clienti',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: il cliente non è valido!',
        'Start chat' => 'Avvia chat',
        'Video call' => 'Video chiamata',
        'Audio call' => 'Chiamata audio',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Rubrica utenze clienti',
        'Search for recipients and add the results as \'%s\'.' => 'Cerca i destinatari e aggiungi i risultati come \'%s\'.',
        'Search template' => 'Modello di ricerca',
        'Create Template' => 'Crea modello',
        'Create New' => 'Crea nuovo',
        'Save changes in template' => 'Salva modifiche al template',
        'Filters in use' => 'Filtri in uso',
        'Additional filters' => 'Filtri aggiuntivi',
        'Add another attribute' => 'Aggiungi un altro attributo',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Gli attributi con l\'identificatore \'(Cliente)\' provengono dalla società del cliente.',
        '(e. g. Term* or *Term*)' => '(es. Termine* o *Termine*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Seleziona tutto',
        'The customer user is already selected in the ticket mask.' => 'L\'utenza cliente è già selezionato nella maschera del ticket.',
        'Select this customer user' => 'Seleziona questa utenza cliente',
        'Add selected customer user to' => 'Aggiungi l\'utenza cliente selezionato a',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Modifica le opzioni di ricerca',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centro informazioni utenze clienti',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTOBO Daemon è un processo demone che esegue operazioni asincrone, ad es. trigger dell\'escalation dei ticket, invio delle email, ecc.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Un OTOBO Daemon in esecuzione è obbligatorio per una corretta operatività del sistema.',
        'Starting the OTOBO Daemon' => 'Avvio di OTOBO Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            '',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Esecuzione \'%s avviata\' per assicurarsi che i lavori cron dell\'utente\' otrs \'siano attivi.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Dopo 5 minuti, controlla che OTOBO Daemon sia in esecuzione nel sistema (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Cruscotto',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nuovo appuntamento',
        'Tomorrow' => 'Domani',
        'Soon' => 'Presto',
        '5 days' => '5 giorni',
        'Start' => 'Inizio',
        'none' => 'nessuno',

        # Template: AgentDashboardCalendarOverview
        'in' => 'in',

        # Template: AgentDashboardCommon
        'Save settings' => 'Salva impostazioni',
        'Close this widget' => 'Chiudi questo widget',
        'more' => 'altro',
        'Available Columns' => 'Colonne disponibili',
        'Visible Columns (order by drag & drop)' => 'Colonne visibili (ordina con trascinamento e rilascio)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Cambia le relazioni con il cliente',
        'Open' => 'Aperto',
        'Closed' => 'Chiuso',
        '%s open ticket(s) of %s' => '%s ticket aperti su %s',
        '%s closed ticket(s) of %s' => '%s ticket chiusi su %s',
        'Edit customer ID' => 'Modifica ID cliente',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',
        'Open tickets' => 'Ticket aperti',
        'Closed tickets' => 'Ticket chiusi',
        'All tickets' => 'Tutti i ticket',
        'Archived tickets' => 'Ticket archiviati',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Nota: utenza cliente non valida!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Informazioni utenza cliente',
        'Phone ticket' => 'Ticket da Telefonata',
        'Email ticket' => 'Ticket da Email',
        'New phone ticket from %s' => 'Nuovo Ticket telefonico da %s',
        'New email ticket to %s' => 'Nuovo Ticket via email da %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s è disponibile!',
        'Please update now.' => 'Aggiorna ora.',
        'Release Note' => 'Nota di rilascio',
        'Level' => 'Livello',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Inviato %s giorni fa.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'La configurazione per questo widget statistico contiene errori, si prega di rivedere le impostazioni.',
        'Download as SVG file' => 'Scarica come file SVG',
        'Download as PNG file' => 'Scarica come file PNG',
        'Download as CSV file' => 'Scarica come file CSV',
        'Download as Excel file' => 'Scarica come file Excel',
        'Download as PDF file' => 'Scarica come file PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Seleziona un formato di uscita grafico valido nella configurazione di questo widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Il contenuto di questa statistica è in preparazione per te, per favore sii paziente.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Questa statistica al momento non può essere utilizzata perché la sua configurazione deve essere corretta dall\'amministratore delle statistiche.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Assegnato a utenza cliente',
        'Accessible for customer user' => 'Accessibile per utenza cliente',
        'My locked tickets' => 'Ticket bloccati da me',
        'My watched tickets' => 'Ticket osservati da me',
        'My responsibilities' => 'Mie responsabilità',
        'Tickets in My Queues' => 'Ticket nelle mie code',
        'Tickets in My Services' => 'Ticket nei miei servizi',
        'Service Time' => 'Tempo di servizio',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Totale',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fuori sede',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'Fino a',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Precedente',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Accettare delle news, una licenza o dei cambiamenti.',
        'Yes, accepted.' => 'Sì, accettato',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Gestisci collegamenti per %s',
        'Create new links' => 'Crea nuovi collegamenti',
        'Manage existing links' => 'Gestisci collegamenti esistenti',
        'Link with' => 'Collegamento con',
        'Start search' => 'Inizia la ricerca',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Al momento non ci sono collegamenti. Fai clic su \'Crea nuovi collegamenti\' in alto per collegare questo oggetto ad altri oggetti.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Cambio password',
        'Current password' => 'Password attuale',
        'New password' => 'Nuova password',
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
        'Edit your preferences' => 'Modifica preferenze',
        'Personal Preferences' => 'Preferenze personali',
        'Preferences' => 'Preferenze',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Nota: al momento stai modificando le preferenze di %s.',
        'Go back to editing this agent' => 'Torna alla modifica di questo agente',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Imposta le tue preferenze personali. Salvare ciascuna impostazione facendo clic sul segno di spunta sulla destra.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'È possibile utilizzare la struttura di navigazione in basso per mostrare solo le impostazioni di determinati gruppi.',
        'Dynamic Actions' => 'Azioni dinamiche',
        'Filter settings...' => 'Impostazioni filtro...',
        'Filter for settings' => 'Filtro per impostazioni',
        'Save all settings' => 'Salva tutte le impostazioni',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Gli avatar sono stati disabilitati dall\'amministratore di sistema. Vedrai invece le tue iniziali.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Puoi cambiare l\'immagine dell\'avatar registrandoti con il tuo indirizzo email %s a %s. Tieni presente che potrebbe trascorrere del tempo prima che il tuo nuovo avatar diventi disponibile a causa della memorizzazione nella cache.',
        'Off' => 'Spento',
        'End' => 'Fine',
        'This setting can currently not be saved.' => 'Questa impostazione al momento non può essere salvata.',
        'This setting can currently not be saved' => 'Questa impostazione al momento non può essere salvata',
        'Save this setting' => 'Salva questa impostazione',
        'Did you know? You can help translating OTOBO at %s.' => 'Lo sapevi? Puoi collaborare alla traduzione di OTOBO su %s.',

        # Template: SettingsList
        'Reset to default' => 'Reset alle condizioni originali',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Scegli tra i gruppi sulla destra per trovare le impostazioni che desideri modificare.',
        'Did you know?' => 'Lo sapevate?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Puoi cambiare il tuo avatar registrandoti con il tuo indirizzo email %s su %s',

        # Template: AgentSplitSelection
        'Target' => 'Obbiettivo',
        'Process' => 'Processo',
        'Split' => 'Dividi',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Gestione delle statistiche',
        'Add Statistics' => 'Aggiungi statistiche',
        'Read more about statistics in OTOBO' => '',
        'Dynamic Matrix' => 'Matrice dinamica',
        'Each cell contains a singular data point.' => 'Ogni cella contiene un punto dati singolare.',
        'Dynamic List' => 'Elenco dinamico',
        'Each row contains data of one entity.' => 'Ogni riga contiene i dati di un\'entità.',
        'Static' => 'Statico',
        'Non-configurable complex statistics.' => 'Statistiche complesse non configurabili.',
        'General Specification' => 'Specifiche generali',
        'Create Statistic' => 'Crea statistica',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Modifica statistiche',
        'Run now' => 'Esegui ora',
        'Statistics Preview' => 'Anteprima statistiche',
        'Save Statistic' => 'Salva Statistica',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Statistiche di importazione',
        'Import Statistics Configuration' => 'Importa configurazione statistiche',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Statistiche',
        'Run' => 'Esegui',
        'Edit statistic "%s".' => 'Modifica la statistica "%s".',
        'Export statistic "%s"' => 'Esporta statistica "%s"',
        'Export statistic %s' => 'Esporta statistica %s',
        'Delete statistic "%s"' => 'Elimina la statistica "%s"',
        'Delete statistic %s' => 'Elimina la statistica %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Panoramica delle statistiche',
        'View Statistics' => 'Visualizza statistiche',
        'Statistics Information' => 'Informazioni statistiche',
        'Created by' => 'Creato da',
        'Changed by' => 'Modificato da',
        'Sum rows' => 'Somma le righe',
        'Sum columns' => 'somma le colonne',
        'Show as dashboard widget' => 'Mostrare come widget nel cruscotto',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Questa statistica contiene errori di configurazione e al momento non può essere utilizzata.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Cambia testo libero di %s%s%s',
        'Change Owner of %s%s%s' => 'Cambia proprietario di %s%s%s',
        'Close %s%s%s' => 'Chiudi %s%s%s',
        'Add Note to %s%s%s' => 'Aggiungi note a %s%s%s',
        'Set Pending Time for %s%s%s' => 'Imposta tempo di attesa per %s%s%s',
        'Change Priority of %s%s%s' => 'Cambia priorità di %s%s%s',
        'Change Responsible of %s%s%s' => 'Responsabile del cambiamento di %s%s%s',
        'The ticket has been locked' => 'Il ticket è stato bloccato',
        'Undo & close' => 'Annulla e chiudi',
        'Ticket Settings' => 'Impostazioni dei ticket',
        'Queue invalid.' => 'Coda non valida.',
        'Service invalid.' => 'Servizio non valido.',
        'SLA invalid.' => 'SLA non valido.',
        'New Owner' => 'Nuovo Gestore',
        'Please set a new owner!' => 'Imposta un nuovo proprietario!',
        'Owner invalid.' => 'Proprietario non valido.',
        'New Responsible' => 'Nuovo responsabile',
        'Please set a new responsible!' => 'Impostare un nuovo responsabile!',
        'Responsible invalid.' => 'Responsabile non valido.',
        'Next state' => 'Stato successivo',
        'State invalid.' => 'Stato non valido.',
        'For all pending* states.' => 'Per tutti gli stati* in sospeso.',
        'Add Article' => 'Aggiungi articolo',
        'Create an Article' => 'Crea un articolo',
        'Inform agents' => 'Informa agenti',
        'Inform involved agents' => 'Informa agenti coinvolti',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Qui è possibile selezionare gli altri agenti che dovrebbero ricevere una notifica relativa al nuovo articolo.',
        'Text will also be received by' => 'Il testo sarà ricevuto anche da',
        'Text Template' => 'Modello di testo',
        'Setting a template will overwrite any text or attachment.' => 'L\'impostazione di un modello sovrascriverà qualsiasi testo o allegato.',
        'Invalid time!' => 'Ora non valida!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Rimbalzo %s%s%s',
        'Bounce to' => 'Rispedisci a',
        'You need a email address.' => 'È necessario un indirizzo email.',
        'Need a valid email address or don\'t use a local email address.' =>
            'È necessario un indirizzo email valido o non usare un indirizzo email locale.',
        'Next ticket state' => 'Stato successivo del ticket',
        'Inform sender' => 'Informa il mittente',
        'Send mail' => 'Invia messaggio!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Azioni multiple',
        'Send Email' => 'Invia Email',
        'Merge' => 'Unisci',
        'Merge to' => 'Unisci a',
        'Invalid ticket identifier!' => 'Identificatore ticket non valido!',
        'Merge to oldest' => 'Unisci a precedente',
        'Link together' => 'Collega',
        'Link to parent' => 'Collega a genitore',
        'Unlock tickets' => 'Sblocca ticket',
        'Execute Bulk Action' => 'Esegui l\'azione in blocco',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Componi risposta per %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Questo indirizzo è registrato come indirizzo di sistema e non può essere utilizzato: %s',
        'Please include at least one recipient' => 'Includere almeno un destinatario',
        'Select one or more recipients from the customer user address book.' =>
            'Seleziona uno o più destinatari dalla rubrica dell\'utenza cliente.',
        'Customer user address book' => 'Rubrica utenze clienti',
        'Remove Ticket Customer' => 'Rimuovi ticket del cliente',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Rimuovere i valori ed immetterne di validi',
        'This address already exists on the address list.' => 'Questo indirizzo esiste già nell\'elenco.',
        'Remove Cc' => 'Rimuovi Cc',
        'Bcc' => 'Ccn',
        'Remove Bcc' => 'Rimuovi Ccn',
        'Date Invalid!' => 'Data non valida!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Cambia cliente di %s%s%s',
        'Customer Information' => 'Informazioni cliente',
        'Customer user' => 'Utenza cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crea nuovo ticket email',
        'Example Template' => 'Modello di esempio',
        'From queue' => 'Dalla coda',
        'To customer user' => 'Alla utenza cliente',
        'Please include at least one customer user for the ticket.' => 'Includere almeno una utenza cliente per il ticket.',
        'Select this customer as the main customer.' => 'Seleziona questo cliente come cliente principale.',
        'Remove Ticket Customer User' => 'Rimuovi utenza cliente dal ticket',
        'Get all' => 'Prendi tutto',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Messaggio di posta in uscita per %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Reinvia email per %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: il tempo di prima risposta è scaduto (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: il tempo di prima risposta scadrà tra %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s : tempo di aggiornamento scaduto (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: il tempo di aggiornamento scadrà tra %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s : tempo di soluzione scaduto (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: il tempo di soluzione scadrà tra %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Inoltrare %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Storia di %s%s%s',
        'Filter for history items' => 'Filtro per elementi cronologici',
        'Expand/collapse all' => 'Espandi/comprimi tutto',
        'CreateTime' => 'CreateTime',
        'Article' => 'Articolo',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Unisci %s%s%s',
        'Merge Settings' => 'Impostazioni di unione',
        'You need to use a ticket number!' => 'Devi usare un numero di ticket!',
        'A valid ticket number is required.' => 'Serve un numero ticket valido.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Prova a digitare parte del numero o del titolo del ticket per cercarlo.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Limita la ricerca ai ticket con lo stesso ID cliente (%s).',
        'Inform Sender' => 'Informa mittente',
        'Need a valid email address.' => 'Serve un indirizzo email valido',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Muove %s%s%s',
        'New Queue' => 'Nuova coda',
        'Move' => 'Sposta',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Non sono stati trovati dati ticket.',
        'Open / Close ticket action menu' => 'Apre / chiude il menu di azione del ticket',
        'Select this ticket' => 'Seleziona questo ticket',
        'Sender' => 'Mittente',
        'First Response Time' => 'Tempo iniziale per risposta',
        'Update Time' => 'Tempo per aggiornamento',
        'Solution Time' => 'Tempo per soluzione',
        'Move ticket to a different queue' => 'Sposta il ticket ad una coda differente',
        'Change queue' => 'Cambia coda',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Rimuovi i filtri attivi per questa schermata.',
        'Tickets per page' => 'Numero di ticket per pagina',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Canale mancante',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Ripristina panoramica',
        'Column Filters Form' => 'Modulo filtri colonna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividi in nuovo ticket telefonico',
        'Save Chat Into New Phone Ticket' => 'Salva chat in nuovo ticket telefonico',
        'Create New Phone Ticket' => 'Crea nuovo ticket telefonico',
        'Please include at least one customer for the ticket.' => 'Si prega di includere almeno un cliente per il ticket.',
        'To queue' => 'Alla coda',
        'Chat protocol' => 'Protocollo di chat',
        'The chat will be appended as a separate article.' => 'La chat sarà aggiunta come un articolo separato.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefonata per %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Visualizza e-mail testo semplice per %s%s%s',
        'Plain' => 'Testo nativo',
        'Download this email' => 'Scarica questa email',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crea nuovo ticket con processo',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Iscriviti al ticket in un processo',

        # Template: AgentTicketSearch
        'Profile link' => 'Collegamento a profilo',
        'Output' => 'Tipo di risultato',
        'Fulltext' => 'Testo libero',
        'Customer ID (complex search)' => 'ID cliente (ricerca complessa)',
        '(e. g. 234*)' => '(e. g. 234*)',
        'Customer ID (exact match)' => 'ID cliente (ricerca complessa)',
        'Assigned to Customer User Login (complex search)' => 'Assegnato al login utenza cliente (ricerca complessa)',
        '(e. g. U51*)' => '(e. g. U51*)',
        'Assigned to Customer User Login (exact match)' => 'Assegnato al login utenza cliente (corrispondenza esatta)',
        'Accessible to Customer User Login (exact match)' => 'Accessibile al login utenza cliente (corrispondenza esatta)',
        'Created in Queue' => 'Creata nella Coda',
        'Lock state' => 'Stato blocco',
        'Watcher' => 'Osservatore',
        'Article Create Time (before/after)' => 'Tempo di creazione articolo (prima/dopo)',
        'Article Create Time (between)' => 'Tempo di creazione articolo (in mezzo)',
        'Please set this to value before end date.' => 'Si prega di impostare questo valore prima della data di fine.',
        'Please set this to value after start date.' => 'Si prega di impostare questo valore dopo la data di inizio.',
        'Ticket Create Time (before/after)' => 'Tempo di creazione ticket (prima/dopo)',
        'Ticket Create Time (between)' => 'Tempo di creazione ticket (in mezzo)',
        'Ticket Change Time (before/after)' => 'Tempo di modifica ticket (prima/dopo)',
        'Ticket Change Time (between)' => 'Tempo di modifica ticket (in mezzo)',
        'Ticket Last Change Time (before/after)' => 'Ora ultima modifica ticket (prima/dopo)',
        'Ticket Last Change Time (between)' => 'Ora ultima modifica ticket (tra)',
        'Ticket Pending Until Time (before/after)' => 'Ticket in sospeso fino a ora (prima/dopo)',
        'Ticket Pending Until Time (between)' => 'Ticket in sospeso fino a ora (tra)',
        'Ticket Close Time (before/after)' => 'Tempo di chiusura ticket (prima/dopo)',
        'Ticket Close Time (between)' => 'Tempo di chiusura ticket (in mezzo)',
        'Ticket Escalation Time (before/after)' => 'Tempo di escalation del ticket (prima/dopo)',
        'Ticket Escalation Time (between)' => 'Tempo di escalation del ticket (tra)',
        'Archive Search' => 'Ricerca archivio',

        # Template: AgentTicketZoom
        'Sender Type' => 'Tipo mittente',
        'Save filter settings as default' => 'Salva impostazioni filtri come predefinite',
        'Event Type' => 'Tipo evento',
        'Save as default' => 'Salva come predefinito',
        'Drafts' => 'Bozze',
        'Change Queue' => 'Cambia coda',
        'There are no dialogs available at this point in the process.' =>
            'Non ci sono finestre di dialogo disponibili a questo punto nel processo.',
        'This item has no articles yet.' => 'Questo oggetto non ha ancora articoli',
        'Ticket Timeline View' => 'Visualizzazione cronologia ticket',
        'Article Overview - %s Article(s)' => 'Panoramica dell\'articolo - %s Articolo(i)',
        'Page %s' => 'Pagina %s',
        'Add Filter' => 'Aggiungi filtro',
        'Set' => 'Impostazione',
        'Reset Filter' => 'Reimposta filtro',
        'No.' => 'Num.',
        'Unread articles' => 'Articoli non letti',
        'Via' => 'Attraverso',
        'Important' => 'Importante',
        'Unread Article!' => 'Articolo non letto!',
        'Incoming message' => 'Messaggio ricevuto',
        'Outgoing message' => 'messaggio in uscita',
        'Internal message' => 'messaggio interno',
        'Sending of this message has failed.' => 'L\'invio di questo messaggio non è riuscito.',
        'Resize' => 'Ridimensiona',
        'Mark this article as read' => 'Marca questo articolo come letto',
        'Show Full Text' => 'Mostra testo completo',
        'Full Article Text' => 'Testo completo articolo',
        'No more events found. Please try changing the filter settings.' =>
            'Nessun altro evento trovato. Prova a modificare le impostazioni del filtro.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'attaverso %s',
        'by %s' => 'da %s',
        'Toggle article details' => 'Attiva/disattiva i dettagli dell\'articolo',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Questo messaggio è in fase di elaborazione. Ho già provato a inviare %s volta(e). Il prossimo tentativo sarà %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Per aprire i collegamenti nel seguente articolo, potrebbe essere necessario premere Ctrl o Cmd o Maiusc mentre si fa clic sul collegamento (a seconda del browser e del sistema operativo).',
        'Close this message' => 'Chiudi questo messaggio',
        'Image' => 'Immagine',
        'PDF' => 'PDF',
        'Unknown' => 'Sconosciuto',
        'View' => 'Vista',

        # Template: LinkTable
        'Linked Objects' => 'Oggetti collegati',

        # Template: TicketInformation
        'Archive' => 'Archivio',
        'This ticket is archived.' => 'Questo ticket è stato archiviato.',
        'Note: Type is invalid!' => 'Nota: il tipo non è valido!',
        'Pending till' => 'In attesa fino a',
        'Locked' => 'Bloccato',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Tempo addebitato',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'L\'anteprima di questo articolo non è possibile perché %s manca il canale nel sistema.',
        'Please re-install %s package in order to display this article.' =>
            'Per favore, reinstalla %s pacchetto per visualizzare questo articolo.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Per proteggere la tua privacy, il contenuto remoto è stato bloccato.',
        'Load blocked content.' => 'Carica contenuto bloccato.',

        # Template: Breadcrumb
        'Home' => 'Casa',
        'Back to admin overview' => 'Torna alla panoramica dell\'amministratore',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Questa funzione richiede servizi cloud',
        'You can' => 'Si può',
        'go back to the previous page' => 'torna alla pagina precedente',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'L\'ID cliente non è modificabile, nessun altro ID cliente può essere assegnato a questo ticket.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Prima seleziona un utenza cliente, quindi puoi selezionare un ID cliente da assegnare a questo ticket.',
        'Select a customer ID to assign to this ticket.' => 'Seleziona un ID cliente da assegnare a questo ticket.',
        'From all Customer IDs' => 'Da tutti gli ID cliente',
        'From assigned Customer IDs' => 'Dagli ID cliente assegnati',

        # Template: CustomerDashboard
        'Ticket Search' => '',

        # Template: CustomerError
        'An Error Occurred' => 'Si è verificato un errore',
        'Error Details' => 'Dettagli dell\'errore',
        'Traceback' => 'Dettaglio della tracciatura ',

        # Template: CustomerFooter
        'Powered by %s' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s rilevato possibili problemi di rete. Puoi provare a ricaricare questa pagina manualmente o attendere fino a quando il tuo browser non ha ristabilito la connessione da solo.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'La connessione è stata ristabilita dopo una perdita temporanea della connessione. Per questo motivo, gli elementi di questa pagina potrebbero non funzionare più correttamente. Per poter riutilizzare correttamente tutti gli elementi, si consiglia vivamente di ricaricare questa pagina.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript non disponibile',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Per provare questo software, devi abilitare JavaScript nel tuo browser.',
        'Browser Warning' => 'Attenzione: browser non compatibile',
        'The browser you are using is too old.' => 'Il browser in uso è obsoleto.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Questo software funziona con un enorme elenco di browser, per favore esegui l\'upgrade a uno di questi.',
        'Please see the documentation or ask your admin for further information.' =>
            'Consulta la documentazione o chiedi al tuo amministratore per ulteriori informazioni.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => 'Attendi un attimo, stai per essere rediretto...',
        'Login' => 'Accesso',
        'Your user name' => 'Il suo user name',
        'User name' => 'Nome utente',
        'Your password' => 'La sua password',
        'Forgot password?' => 'Password dimenticata?',
        'Your 2 Factor Token' => 'Tuo 2 token fattore',
        '2 Factor Token' => '2 token fattore',
        'Log In' => 'Accesso',
        'Request Account' => '',
        'Request New Password' => 'Richiedi nuova password',
        'Your User Name' => 'Il tuo nome utente',
        'A new password will be sent to your email address.' => 'Una nuova password sarà inviata al tuo indirizzo email.',
        'Create Account' => 'Registrati',
        'Please fill out this form to receive login credentials.' => 'Compila questo modulo per ricevere le credenziali di accesso.',
        'How we should address you' => 'Come chiamarla',
        'Your First Name' => 'Nome',
        'Your Last Name' => 'Cognome',
        'Your email address (this will become your username)' => 'Indirizzo email (diventerà il tuo username)',

        # Template: CustomerNavigationBar
        'Logout' => 'Esci',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Benvenuto!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'SLA',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'New Ticket' => 'Nuovo ticket',
        'Page' => 'Pagina',
        'Tickets' => 'Ticket',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Profilo',
        'e. g. 10*5155 or 105658*' => 'es 10*5155 or 105658*',
        'CustomerID' => 'Codice cliente',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Ricerca testo completo nei ticket (ad esempio "John*n" o "Will*")',
        'Types' => 'Tipi',
        'Time Restrictions' => 'Restrizioni temporali',
        'No time settings' => 'Nessuna impostazione per il tempo',
        'All' => 'Tutti',
        'Specific date' => 'Data specifica',
        'Only tickets created' => 'Solo ticket creati',
        'Date range' => 'Periodo',
        'Only tickets created between' => 'Solo ticket creati tra',
        'Ticket Archive System' => 'Sistema di archiviazione ticket',
        'Save Search as Template?' => 'Salva ricerca come modello?',
        'Save as Template?' => 'Salvare come modello?',
        'Save as Template' => 'Salva come modello',
        'Template Name' => 'Nome modello',
        'Pick a profile name' => 'Scegli un profilo',
        'Output to' => 'Output',

        # Template: CustomerTicketSearchResultShort
        'of' => 'di',
        'Search Results for' => 'Risultati di ricerca per',
        'Remove this Search Term.' => 'Rimuovi questo termine di ricerca.',

        # Template: CustomerTicketZoom
        'Reply' => 'Risposta',
        'Discard' => '',
        'Ticket Information' => 'Informazioni sul ticket',
        'Categories' => '',

        # Template: Chat
        'Expand article' => 'Espandi l\'articolo',

        # Template: CustomerWarning
        'Warning' => 'Attenzione',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Informazioni evento',
        'Ticket fields' => 'Campi ticket',

        # Template: Error
        'Send a bugreport' => 'Invia una segnalazione di bug',
        'Expand' => 'Espandi',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Fai clic per eliminare questo allegato.',

        # Template: DraftButtons
        'Update draft' => 'Aggiorna bozza',
        'Save as new draft' => 'Salva in bozza',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Hai caricato la bozza "%s"',
        'You have loaded the draft "%s". You last changed it %s.' => 'Hai caricato la bozza "%s". L\'hai modificata per ultimo %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Hai caricato la bozza "%s". L\'ultima modifica è %s di %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Attenzione: questa bozza è obsoleta perché il ticket è stato modificato dopo che la bozza è stata creata.',

        # Template: Header
        'Edit personal preferences' => 'Modifica impostazioni personali',
        'Personal preferences' => 'Preferenze personali',
        'You are logged in as' => 'Hai effettuato l\'accesso come',

        # Template: Installer
        'JavaScript not available' => 'JavaScript non disponibile',
        'Step %s' => 'Passo %s',
        'License' => 'Licenza',
        'Database Settings' => 'Impostazioni database',
        'General Specifications and Mail Settings' => 'Specifiche generiche ed impostazioni email',
        'Finish' => 'Fine',
        'Welcome to %s' => 'Benvenuto in %s',
        'Germany' => 'Germania',
        'Phone' => 'Telefono',
        'Switzerland' => '',
        'Web site' => 'Sito web',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configura posta in uscita',
        'Outbound mail type' => 'Tipo di posta in uscita',
        'Select outbound mail type.' => 'Seleziona il tipo di posta in uscita.',
        'Outbound mail port' => 'Porta del server di posta in uscita',
        'Select outbound mail port.' => 'Seleziona la porta del server di posta in uscita.',
        'SMTP host' => 'Host SMTP',
        'SMTP host.' => 'Host SMTP.',
        'SMTP authentication' => 'Autenticazione SMTP',
        'Does your SMTP host need authentication?' => 'Serve autenticazione SMTP per questo host?',
        'SMTP auth user' => 'Utente per autenticazione SMTP',
        'Username for SMTP auth.' => 'Username per l\'autenticazione SMTP',
        'SMTP auth password' => 'Password per autenticazione SMTP',
        'Password for SMTP auth.' => 'Password per l\'autenticazione SMTP',
        'Configure Inbound Mail' => 'Configura posta in entrata',
        'Inbound mail type' => 'Tipo posta in entrata',
        'Select inbound mail type.' => 'Seleziona il tipo di posta in entrata.',
        'Inbound mail host' => 'Host di posta in entrata',
        'Inbound mail host.' => 'Host di posta in entrata',
        'Inbound mail user' => 'Host di posta in entrata',
        'User for inbound mail.' => 'Nome utente per la posta in entrata.',
        'Inbound mail password' => 'Password per la posta in entrata',
        'Password for inbound mail.' => 'Password per la posta in entrata',
        'Result of mail configuration check' => 'Risultato del controllo di configurazione della posta',
        'Check mail configuration' => 'Controllo configurazione della posta',
        'Skip this step' => 'Salta questo passaggio',

        # Template: InstallerDBResult
        'Done' => 'Fatto',
        'Error' => 'Errore',
        'Database setup successful!' => 'Configurazione database terminata con successo',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo di installazione',
        'Create a new database for OTOBO' => 'Crea un nuovo database per OTOBO',
        'Use an existing database for OTOBO' => 'Usa un database esistente per OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se hai impostato una password di root per il database inseriscila qui, altrimenti lascia il campo vuoto.',
        'Database name' => 'Nome del database',
        'Check database settings' => 'Controlla impostazioni database',
        'Result of database check' => 'Risultato del controllo database',
        'Database check successful.' => 'Controllo database eseguito con successo.',
        'Database User' => 'Utente del database',
        'New' => 'Nuovi',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Verrà creato un nuovo database a permessi limitati per questo sistema OTOBO',
        'Repeat Password' => 'Ripeti la password',
        'Generated password' => 'Password generata',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Le password non coincidono',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Per poter usare OTOBO, devi inserire questa riga di comando in una shell come utente root.',
        'Restart your webserver' => 'Riavvia il tuo server web',
        'After doing so your OTOBO is up and running.' => 'Dopo di ciò OTOBO sarà pronto all\'uso.',
        'Start page' => 'Pagina iniziale',
        'Your OTOBO Team' => 'Gruppo di sviluppo di OTOBO',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Non accetto la licenza',
        'Accept license and continue' => 'Accetto la licenza e continua',

        # Template: InstallerSystem
        'SystemID' => 'ID del sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'L\'identificatore di questo sistema. Ogni numero di ticket e ogni ID di sessione HTTP contengono questo numero.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nome FQDN di questo sistema',
        'AdminEmail' => 'Admin Email',
        'Email address of the system administrator.' => 'Indirizzo dell\'amministratore di sistema.',
        'Organization' => 'Società',
        'Log' => 'Log',
        'LogModule' => 'Modulo di log',
        'Log backend to use.' => 'Backend di log da usare',
        'LogFile' => 'File di log',
        'Webfrontend' => 'Interfaccia web',
        'Default language' => 'Lingua di default',
        'Default language.' => 'Lingua di default.',
        'CheckMXRecord' => 'Controlli sui record MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Gli indirizzi scritti a mano vengono controllati tramite i record MX trovati nei DNS. Non usare questa opzione se il DNS usato dalla macchina è lento o non risolve gli indirizzi pubblici.',

        # Template: LinkObject
        'Delete link' => 'Elimina collegamenti',
        'Delete Link' => 'Elimina Collegamenti',
        'Object#' => 'Oggetto#',
        'Add links' => 'Aggiungi collegamenti',
        'Delete links' => 'Elimina collegamenti',

        # Template: Login
        'Lost your password?' => 'Hai dimenticato la password?',
        'Back to login' => 'Torna all\'accesso',

        # Template: MetaFloater
        'Scale preview content' => 'Ridimensiona il contenuto dell\'anteprima',
        'Open URL in new tab' => 'Apri l\'URL in una nuova scheda',
        'Close preview' => 'Chiude l’anteprima',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Non è possibile fornire un\'anteprima di questo sito Web perché non ha permesso di essere incorporato.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Funzionalità non Disponibile',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Motto del giorno',
        'This is the message of the day. You can edit this in %s.' => 'Questo è il messaggio del giorno. Puoi modificarlo in %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Permessi insufficienti',
        'Back to the previous page' => 'Pagina precedente',

        # Template: Alert
        'Alert' => 'Mettere in guardia',
        'Powered by' => 'Fornito da',

        # Template: Pagination
        'Show first page' => 'Mostra prima pagina',
        'Show previous pages' => 'Mostra pagine precedenti',
        'Show page %s' => 'Mostra pagina %s',
        'Show next pages' => 'Mostra pagine successive',
        'Show last page' => 'Mostra ultima pagina',

        # Template: PictureUpload
        'Need FormID!' => 'FormID necessario!',
        'No file found!' => 'Nessun file trovato!',
        'The file is not an image that can be shown inline!' => 'Il file non è un\'immagine che può essere mostrata in linea!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Non sono state trovate notifiche configurabili dall\'utente.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Ricevi messaggi per notifica \'%s\' per metodo di trasporto\'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informazioni processo',
        'Dialog' => 'Finestra',

        # Template: Article
        'Inform Agent' => 'Informa agente',

        # Template: PublicDefault
        'Welcome' => 'Benvenuto',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'È possibile installare un modulo pubblico personalizzato (tramite il gestore pacchetti), ad esempio il modulo FAQ, che ha un\'interfaccia pubblica.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permessi',
        'You can select one or more groups to define access for different agents.' =>
            'Si può scegliere uno o più gruppi per definire l\'accesso a diversi agenti.',
        'Result formats' => 'Formati dei risultati',
        'Time Zone' => 'Fuso orario',
        'The selected time periods in the statistic are time zone neutral.' =>
            'I periodi di tempo selezionati nella statistica sono neutrali rispetto al fuso orario.',
        'Create summation row' => 'Crea riga di riepilogo',
        'Generate an additional row containing sums for all data rows.' =>
            'Genera una riga aggiuntiva contenente somme per tutte le righe di dati.',
        'Create summation column' => 'Crea colonna di riepilogo',
        'Generate an additional column containing sums for all data columns.' =>
            'Genera una colonna aggiuntiva contenente somme per tutte le colonne di dati.',
        'Cache results' => 'Risultato della ricerca',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Memorizza i dati dei risultati delle statistiche in una cache da utilizzare nelle viste successive con la stessa configurazione (richiede almeno un campo orario selezionato).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Fornisci la statistica come widget che gli agenti possono attivare nel loro cruscotto.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Si noti che l\'attivazione del widget cruscotto attiverà la memorizzazione nella cache di questa statistica nel cruscotto.',
        'If set to invalid end users can not generate the stat.' => 'Se impostato a invalido gli utenti finali non possono generare la statistica.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Ci sono problemi nella configurazione di questa statistica:',
        'You may now configure the X-axis of your statistic.' => 'Ora puoi configurare l\'asse X della tua statistica.',
        'This statistic does not provide preview data.' => 'Questa statistica non fornisce dati di anteprima.',
        'Preview format' => 'Formato anteprima',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Si noti che l\'anteprima utilizza dati casuali e non considera i filtri di dati.',
        'Configure X-Axis' => 'Configura asse X',
        'X-axis' => 'Asse X',
        'Configure Y-Axis' => 'Configura asse Y',
        'Y-axis' => 'Asse Y',
        'Configure Filter' => 'Configura filtro',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Seleziona solo un elemento e togli  \'Fisso\'. ',
        'Absolute period' => 'Periodo assoluto',
        'Between %s and %s' => 'Tra %s e %s',
        'Relative period' => 'Periodo relativo',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Il passato è completo %s e l\'attuale + imminente completato %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Non consentire modifiche a questo elemento quando viene generata la statistica.',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Scambia assi',
        'Configurable Params of Static Stat' => 'Parametri configurabili di Static Stat',
        'No element selected.' => 'Nessun elemento selezionato.',
        'Scale' => 'scala valori',
        'show more' => 'mostrare di più',
        'show less' => 'mostrare di meno',

        # Template: D3
        'Download SVG' => 'Scarica SVG',
        'Download PNG' => 'Scarica PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Il periodo di tempo selezionato definisce il periodo di tempo predefinito per questa statistica da cui raccogliere i dati.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Definisce l\'unità di tempo che verrà utilizzata per dividere il periodo di tempo selezionato in punti dati di reporting.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Ricordare che la scala per l\'asse Y deve essere più grande della scala per l\'asse X (ad es. Asse X => mese, asse Y => anno).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Questa impostazione è disabilitata.',
        'This setting is fixed but not deployed yet!' => 'Questa impostazione è fissa ma non ancora distribuita!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Questa impostazione è attualmente ignorata %s e non può quindi essere modificata qui!',
        'Changing this setting is only available in a higher config level!' =>
            'La modifica di questa impostazione è disponibile solo a un livello di configurazione superiore!',
        '%s (%s) is currently working on this setting.' => '%s(%s) sta attualmente lavorando su questa impostazione.',
        'Toggle advanced options for this setting' => 'Attiva o disattiva le opzioni avanzate per questa impostazione',
        'Disable this setting, so it is no longer effective' => 'Disabilita questa impostazione, quindi non è più efficace',
        'Disable' => 'Disabilita',
        'Enable this setting, so it becomes effective' => 'Abilita questa impostazione, quindi diventa effettiva',
        'Enable' => 'Abilita',
        'Reset this setting to its default state' => 'Ripristina questa impostazione al suo stato predefinito',
        'Reset setting' => 'Ripristinare le impostazioni',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Consenti agli utenti di adattare questa impostazione all\'interno delle loro preferenze personali',
        'Allow users to update' => 'Consenti agli utenti di aggiornare',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Non consentire più agli utenti di adattare questa impostazione all\'interno delle loro preferenze personali',
        'Forbid users to update' => 'Vietare aggiornare agli utenti',
        'Show user specific changes for this setting' => 'Mostrare le modifiche specifiche dell\'utente per questa impostazione',
        'Show user settings' => 'Mostrare le impostazioni dell\'utente',
        'Copy a direct link to this setting to your clipboard' => 'Copia un link diretto a questa impostazione negli appunti',
        'Copy direct link' => 'Copia collegamento diretto',
        'Remove this setting from your favorites setting' => 'Rimuovi questa impostazione dalle tue impostazioni preferite',
        'Remove from favourites' => 'Rimuovi dai preferiti',
        'Add this setting to your favorites' => 'Aggiungi questa impostazione ai tuoi preferiti',
        'Add to favourites' => 'Aggiungi ai preferiti',
        'Cancel editing this setting' => 'Annulla la modifica di questa impostazione',
        'Save changes on this setting' => 'Salva le modifiche su questa impostazione',
        'Edit this setting' => 'Modifica questa impostazione',
        'Enable this setting' => 'Abilita questa impostazione',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Questo gruppo non contiene alcuna impostazione. Prova a navigare verso uno dei suoi sottogruppi o un altro gruppo.',

        # Template: SettingsListCompare
        'Now' => 'Ora',
        'User modification' => 'Modifica dell\'utente',
        'enabled' => 'abilita',
        'disabled' => 'disabilita',
        'Setting state' => 'Stato di impostazione',

        # Template: Actions
        'Edit search' => 'Modifica ricerca',
        'Go back to admin: ' => 'Torna all\'amministratore:',
        'Deployment' => 'Attivazione',
        'My favourite settings' => 'Le mie impostazioni preferite',
        'Invalid settings' => 'Impostazioni non valide',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtra le impostazioni visibili ...',
        'Enable edit mode for all settings' => 'Abilita la modalità di modifica per tutte le impostazioni',
        'Save all edited settings' => 'Salva tutte le impostazioni modificate',
        'Cancel editing for all settings' => 'Annulla la modifica per tutte le impostazioni',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Tutte le azioni da questo widget si applicano solo alle impostazioni visibili a destra.',

        # Template: Help
        'Currently edited by me.' => 'Attualmente modificato da me.',
        'Modified but not yet deployed.' => 'Modificata, ma non ancora attivata.',
        'Currently edited by another user.' => 'Attualmente modificato da un altro utente.',
        'Different from its default value.' => 'Diverso dal suo valore predefinito.',
        'Save current setting.' => 'Salva le impostazioni correnti.',
        'Cancel editing current setting.' => 'Annulla la modifica delle impostazioni correnti.',

        # Template: Navigation
        'Navigation' => 'Navigazione',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'Pagina di test OTOBO',
        'Unlock' => 'Sblocca',
        'Welcome %s %s' => 'Benvenuto %s %s',
        'Counter' => 'Contatore',

        # Template: Warning
        'Go back to the previous page' => 'Torna alla pagina precedente',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Visualizza',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Titolo della bozza',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Visualizzazione dell\'articolo',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Vuoi veramente cancellare "%s"?',
        'Confirm' => 'Conferma',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Attendere il caricamento prego...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Fare clic per selezionare un file per il caricamento.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Fare clic per selezionare i file o semplicemente rilasciarli qui.',
        'Click to select a file or just drop it here.' => 'Fare clic per selezionare un file o semplicemente rilasciarlo qui.',
        'Uploading...' => 'Caricamento...',

        # JS Template: InformationDialog
        'Process state' => 'Stato processo',
        'Running' => 'Avvio',
        'Finished' => 'Operazione terminata',
        'No package information available.' => 'Nessuna informazione sul pacchetto disponibile.',

        # JS Template: AddButton
        'Add new entry' => 'Aggiungi nuova entry',

        # JS Template: AddHashKey
        'Add key' => 'Aggiungi chiave',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Commento di attivazione...',
        'This field can have no more than 250 characters.' => 'Questo campo non può contenere più di 250 caratteri.',
        'Deploying, please wait...' => 'Attivazione in corso, attendere...',
        'Preparing to deploy, please wait...' => 'Preparazione dell\'attivazione, attendere...',
        'Deploy now' => 'Attiva adesso',
        'Try again' => 'Riprova',

        # JS Template: DialogReset
        'Reset options' => 'Reimposta opzioni',
        'Reset setting on global level.' => 'Ripristina le impostazioni a livello globale.',
        'Reset globally' => 'Ripristina a livello globale',
        'Remove all user changes.' => 'Rimuovi tutte le modifiche dell\'utente.',
        'Reset locally' => 'Ripristina localmente',
        'user(s) have modified this setting.' => 'gli utente(i) hanno modificato questa impostazione.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Vuoi davvero ripristinare questa impostazione al suo valore predefinito?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'È possibile utilizzare la selezione della categoria per limitare la struttura di navigazione in basso alle voci della categoria selezionata. Non appena si seleziona la categoria, l\'albero verrà ricostruito.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Backend del database',
        'CustomerIDs' => 'Codici cliente',
        'Fax' => 'Fax',
        'Street' => 'Via',
        'Zip' => 'CAP',
        'City' => 'Città',
        'Country' => 'Stato',
        'Mr.' => 'Sig',
        'Mrs.' => 'Sig.ra',
        'Address' => 'Indirizzo',
        'View system log messages.' => 'Visualizza messaggi del log di sistema.',
        'Edit the system configuration settings.' => 'Modifica le impostazioni di sistema.',
        'Update and extend your system with software packages.' => 'Aggiorna ed estendi il tuo sistema con i pacchetti software.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Le ACL dal database non sono allineate con la configurazione di sistema, effettua il rilascio di tutte le ACL.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => 'Sono stati aggiunti correttamente i seguenti ACL: %s',
        'The following ACLs have been updated successfully: %s' => 'Sono stati aggioranti correttamente i seguenti ACL: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Lì dove errori durante l\'aggiunta / aggiornamento dei seguenti ACL: %s. Per ulteriori informazioni, consultare il file di registro.',
        'There was an error creating the ACL' => 'Si è verificato un errore durante la creazione dell\'ACL',
        'Need ACLID!' => 'ACLID necessario!',
        'Could not get data for ACLID %s' => 'Impossibile ottenere i dati per ACLID %s',
        'There was an error updating the ACL' => 'Si è verificato un errore durante l\'aggiornamento dell\'ACL',
        'There was an error setting the entity sync status.' => 'Si è verificato un errore durante l\'impostazione dello stato di sincronizzazione dell\'entità.',
        'There was an error synchronizing the ACLs.' => 'Si è verificato un errore durante la sincronizzazione degli ACL.',
        'ACL %s could not be deleted' => 'L\'ACL %s non può essere eliminata',
        'There was an error getting data for ACL with ID %s' => 'Si è verificato un errore durante il recupero dei dati per ACL con ID %s',
        '%s (copy) %s' => '%s (copia) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Si noti che le restrizioni ACL verranno ignorate per l\'account Amministratore (UserID 1).',
        'Exact match' => 'Corrispondenza esatta',
        'Negated exact match' => 'Corrispondenza esatta negata',
        'Regular expression' => 'Espressione regolare',
        'Regular expression (ignore case)' => 'Espressione regolare (non distinguere le maiuscole)',
        'Negated regular expression' => 'Espressione regolare negata',
        'Negated regular expression (ignore case)' => 'Espressione regolare negata (non distinguere le maiuscole)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Non è stato possibile creare il Calendario nel sistema!',
        'Please contact the administrator.' => 'Si prega di contattare l\'amministratore.',
        'No CalendarID!' => 'Non c\'è il CalendarID!',
        'You have no access to this calendar!' => 'Non hai accesso a questo calendario!',
        'Error updating the calendar!' => 'Errore durante l\'aggiornamento del calendario!',
        'Couldn\'t read calendar configuration file.' => 'Impossibile leggere il file di configurazione del calendario.',
        'Please make sure your file is valid.' => 'Assicurati che il tuo file sia valido.',
        'Could not import the calendar!' => 'Non è stato possibile importare il calendario!',
        'Calendar imported!' => 'Calendario importato!',
        'Need CalendarID!' => 'Serve il CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Impossibile recuperare i dati per il CalendarID specificato',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Importato con successo %s appuntamento(i) al calendario %s.',
        '+5 minutes' => '+5 minuti',
        '+15 minutes' => '+15 minuti',
        '+30 minutes' => '+30 minuti',
        '+1 hour' => '+1 ora',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'No Permessi',
        'System was unable to import file!' => 'Il sistema non è stato in grado di importare il file!',
        'Please check the log for more information.' => 'Si prega di controllare il registro per ulteriori informazioni.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Il nome della notifica esiste già!',
        'Notification added!' => 'Notifica aggiunta!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Si è verificato un errore durante il recupero dei dati per la notifica con ID:%s!',
        'Unknown Notification %s!' => 'Notifica sconosciuta %s!',
        '%s (copy)' => '%s (copia)',
        'There was an error creating the Notification' => 'Si è verificato un errore durante la creazione della notifica',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            '',
        'The following Notifications have been added successfully: %s' =>
            'Le seguenti notifiche sono state aggiunte correttamente: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Le seguenti notifiche sono state aggiornate correttamente: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Lì dove errori durante l\'aggiunta/aggiornamento delle seguenti notifiche: %s. Per ulteriori informazioni, consultare il file di registro.',
        'Notification updated!' => 'Notifica aggiornata!',
        'Agent (resources), who are selected within the appointment' => 'Agente (risorse), che sono selezionati all\'interno dell\'appuntamento',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Tutti gli agenti con (almeno) il permesso di lettura per l\'appuntamento (calendario)',
        'All agents with write permission for the appointment (calendar)' =>
            'Tutti gli agenti con permesso di scrittura per l\'appuntamento (calendario)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Allegato aggiunto!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Aggiunta risposta automatica!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'CommunicationID non valido!',
        'All communications' => 'Tutte le comunicazioni',
        'Last 1 hour' => 'Ultima 1 ora',
        'Last 3 hours' => 'Ultime 3 ore',
        'Last 6 hours' => 'Ultime 6 ore',
        'Last 12 hours' => 'Ultime 12 ore',
        'Last 24 hours' => 'Ultime 24 ore',
        'Last week' => 'Ultima settimana',
        'Last month' => 'Ultimo mese',
        'Invalid StartTime: %s!' => 'StartTime non valido: %s!',
        'Successful' => 'Successo',
        'Processing' => 'Processo',
        'Failed' => 'Fallito',
        'Invalid Filter: %s!' => 'Filtro non valido: %s!',
        'Less than a second' => 'Meno di un secondo',
        'sorted descending' => 'ordine decrescente',
        'sorted ascending' => 'ordine crescente',
        'Trace' => 'Tracciare',
        'Debug' => 'Debug',
        'Info' => 'Informazioni',
        'Warn' => 'Avvisare',
        'days' => 'giorni',
        'day' => 'giorno',
        'hour' => 'ora',
        'minute' => 'minuto',
        'seconds' => 'secondi',
        'second' => 'secondo',

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

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Azienda del cliente aggiornata!',
        'Dynamic field %s not found!' => 'Campo dinamico %s non trovato!',
        'Unable to set value for dynamic field %s!' => 'Impossibile impostare il valore per il campo dinamico %s!',
        'Customer Company %s already exists!' => 'La società cliente %s esite già!',
        'Customer company added!' => 'Azienda del cliente aggiunta!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Nessuna configurazione trovata per \'CustomerGroupPermissionContext\' trovata!',
        'Please check system configuration.' => 'Si prega di verificare la configurazione del sistema.',
        'Invalid permission context configuration:' => 'Configurazione del contesto di autorizzazione non valida:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Cliente aggiornato!',
        'New phone ticket' => 'Nuovo ticket da telefonata',
        'New email ticket' => 'Nuovo ticket da email',
        'Customer %s added' => 'Cliente %s aggiunto',
        'Customer user updated!' => 'Utenza cliente aggiornata!',
        'Same Customer' => 'Stesso cliente',
        'Direct' => 'Diretto',
        'Indirect' => 'Indiretto',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Modifica relazioni utenza cliente per gruppo',
        'Change Group Relations for Customer User' => 'Cambia relazioni di gruppo per l\'utenza cliente',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Allocare gli utenti del cliente al servizio',
        'Allocate Services to Customer User' => 'Allocare servizi all\'utenza cliente',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'La configurazione dei campi non è valida',
        'Objects configuration is not valid' => 'La configurazione degli oggetti non è valida',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Impossibile ripristinare correttamente l\'ordine del Campo dinamico, controllare il registro errori per ulteriori dettagli.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Sottrazione indefinita.',
        'Need %s' => '%s richiesto',
        'Add %s field' => 'Aggiungi %s campo',
        'The field does not contain only ASCII letters and numbers.' => 'Il campo non contiene solo lettere e numeri ASCII.',
        'There is another field with the same name.' => 'C\'è un altro campo con lo stesso nome.',
        'The field must be numeric.' => 'Il campo deve essere numerico.',
        'Need ValidID' => 'ValidID richiesto',
        'Could not create the new field' => 'Impossibile creare il nuovo campo',
        'Need ID' => 'ID richiesto',
        'Could not get data for dynamic field %s' => 'Impossibile ottenere i dati per il campo dinamico %s',
        'Change %s field' => 'Cambio %s campo',
        'The name for this field should not change.' => 'Il nome per questo campo non dovrebbe cambiare.',
        'Could not update the field %s' => 'Impossibile aggiornare il campo %s',
        'Currently' => 'Attualmente',
        'Unchecked' => 'Non verificato',
        'Checked' => 'Verificato',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'Questo valore di campo è duplicato.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Impedisci l\'inserimento di date in futuro',
        'Prevent entry of dates in the past' => 'Impedisci l\'inserimento di date nel passato',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Seleziona almeno un destinatario.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minuto(i)',
        'hour(s)' => 'ora(e)',
        'Time unit' => 'Unità di tempo',
        'within the last ...' => 'negli ultimi ... ',
        'within the next ...' => 'nei prossimi ... ',
        'more than ... ago' => 'più di ...',
        'Unarchived tickets' => 'Ticket non archiviati',
        'archive tickets' => 'ticket d\'archivio',
        'restore tickets from archive' => 'ripristinare i ticket dall\'archivio',
        'Need Profile!' => 'Profilo richiesto!',
        'Got no values to check.' => 'Non ho valori da controllare.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Rimuovi le seguenti parole perché non possono essere utilizzate per la selezione del ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Bisogno WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Impossibile ottenere i dati per WebserviceID %s',
        'ascending' => 'Crescente',
        'descending' => 'Decrescente',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Hai bisogno di un tipo di comunicazione!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Il tipo di comunicazione deve essere "Richiedente" o "Provider"!',
        'Invalid Subaction!' => 'Sottrazione non valida!',
        'Need ErrorHandlingType!' => 'Hai bisogno di ErrorHandlingType!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s non è registrato',
        'Could not update web service' => 'Impossibile aggiornare il servizio Web',
        'Need ErrorHandling' => 'Ha bisogno di ErrorHandling',
        'Could not determine config for error handler %s' => 'Impossibile determinare la configurazione per il gestore errori %s',
        'Invoker processing outgoing request data' => 'Invoker che elabora i dati delle richieste in uscita',
        'Mapping outgoing request data' => 'Mappatura dei dati delle richieste in uscita',
        'Transport processing request into response' => 'Richiesta di elaborazione del trasporto in risposta',
        'Mapping incoming response data' => 'Mappatura dei dati di risposta in entrata',
        'Invoker processing incoming response data' => 'Invoker che elabora i dati di risposta in arrivo',
        'Transport receiving incoming request data' => 'Trasporto che riceve i dati della richiesta in arrivo',
        'Mapping incoming request data' => 'Mappatura dei dati delle richieste in arrivo',
        'Operation processing incoming request data' => 'Operazione che elabora i dati della richiesta in arrivo',
        'Mapping outgoing response data' => 'Mappatura dei dati di risposta in uscita',
        'Transport sending outgoing response data' => 'Trasporto che invia i dati di risposta in uscita',
        'skip same backend modules only' => 'salta solo gli stessi moduli backend',
        'skip all modules' => 'salta tutti i moduli',
        'Operation deleted' => 'Operazione eliminata',
        'Invoker deleted' => 'Invoker eliminato',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 secondi',
        '15 seconds' => '15 secondi',
        '30 seconds' => '30 secondi',
        '45 seconds' => '45 secondi',
        '1 minute' => '1 minuto',
        '2 minutes' => '2 minuti',
        '3 minutes' => '3 minuti',
        '4 minutes' => '4 minuti',
        '5 minutes' => '5 minuti',
        '10 minutes' => '10 minuti',
        '15 minutes' => '15 minuti',
        '30 minutes' => '30 minuti',
        '1 hour' => '1 ora',
        '2 hours' => '2 ore',
        '3 hours' => '3 ore',
        '4 hours' => '4 ore',
        '5 hours' => '5 ore',
        '6 hours' => '6 ore',
        '12 hours' => '12 ore',
        '18 hours' => '18 ore',
        '1 day' => '1 giorno',
        '2 days' => '2 giorni',
        '3 days' => '3 giorni',
        '4 days' => '4 giorni',
        '6 days' => '6 giorni',
        '1 week' => '1 settimana',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Impossibile determinare la configurazione per invoker %s',
        'InvokerType %s is not registered' => 'InvokerType  %s non è registrato',
        'MappingType %s is not registered' => 'MappingType %s non è registrato',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Hai bisogno di Invoker!',
        'Need Event!' => 'Hai bisogno di un evento!',
        'Could not get registered modules for Invoker' => 'Impossibile ottenere i moduli registrati per Invoker',
        'Could not get backend for Invoker %s' => 'Impossibile ottenere il backend per Invoker %s',
        'The event %s is not valid.' => 'L\'evento %s non è valido.',
        'Could not update configuration data for WebserviceID %s' => 'Impossibile aggiornare i dati di configurazione per WebserviceID %s',
        'This sub-action is not valid' => 'Questa azione secondaria non è valida',
        'xor' => 'xor',
        'String' => 'Stringa',
        'Regexp' => 'Regexp',
        'Validation Module' => 'Modulo di convalida',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Mappatura semplice per i dati in uscita',
        'Simple Mapping for Incoming Data' => 'Mappatura semplice per i dati in entrata',
        'Could not get registered configuration for action type %s' => 'Impossibile ottenere la configurazione registrata per il tipo di azione %s',
        'Could not get backend for %s %s' => 'Impossibile ottenere backend per %s %s',
        'Keep (leave unchanged)' => 'Mantieni (lascia invariato)',
        'Ignore (drop key/value pair)' => 'Ignora (tasto drop/coppia valore)',
        'Map to (use provided value as default)' => 'Mappa su (usa il valore fornito come predefinito)',
        'Exact value(s)' => 'Valori esatto(i)',
        'Ignore (drop Value/value pair)' => 'Ignora (elimina coppia valore/valore)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'Mappatura XSLT per dati in uscita',
        'XSLT Mapping for Incoming Data' => 'Mappatura XSLT per dati in entrata',
        'Could not find required library %s' => 'Impossibile trovare la libreria %s richiesta',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Dati di richiesta in uscita prima dell\'elaborazione (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Dati di richiesta in uscita prima del mapping (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Dati delle richieste in uscita dopo il mapping (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Dati di risposta in entrata prima del mapping (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Dati del gestore degli errori in uscita dopo la gestione degli errori (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Dati di richiesta in entrata prima del mapping (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Dati della richiesta in arrivo dopo il mapping (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Dati di risposta in uscita prima del mapping (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Dati del gestore degli errori in uscita dopo la gestione degli errori (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Impossibile determinare la configurazione per l\'operazione %s',
        'OperationType %s is not registered' => 'OperationType %s non è registrato',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Hai bisogno di una subazione valida!',
        'This field should be an integer.' => 'Questo campo dovrebbe essere un numero intero.',
        'File or Directory not found.' => 'File o cartella non trovata.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Esiste un altro servizio web con lo stesso nome.',
        'There was an error updating the web service.' => 'Si è verificato un errore durante l\'aggiornamento del servizio Web.',
        'There was an error creating the web service.' => 'Si è verificato un errore durante la creazione del servizio Web.',
        'Web service "%s" created!' => 'Web service "%s" creato!',
        'Need Name!' => 'Hai bisogno di un nome!',
        'Need ExampleWebService!' => 'Hai bisogno di ExampleWebService!',
        'Could not load %s.' => 'Impossibile caricare %s.',
        'Could not read %s!' => 'Impossibile leggere %s!',
        'Need a file to import!' => 'Hai bisogno di un file da importare!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            '',
        'Web service "%s" deleted!' => 'Web service "%s" eliminato!',
        'OTOBO as provider' => 'OTOBO come fornitore',
        'Operations' => 'Operazioni',
        'OTOBO as requester' => 'OTOBO come richiedente',
        'Invokers' => 'Invokers',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Non avuto WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Impossibile ottenere i dati della cronologia per WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Gruppo aggiornato!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Account di posta aggiunto!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Recupero dell\'account e-mail già recuperato da un altro processo. Per favore riprova più tardi!',
        'Dispatching by email To: field.' => 'Smistamento in base al campo A:.',
        'Dispatching by selected Queue.' => 'Smistamento in base alla coda selezionata.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'L’agente che ha creato il ticket',
        'Agent who owns the ticket' => 'L’agente che possiede il ticket',
        'Agent who is responsible for the ticket' => 'L’agente che è responsabile del ticket',
        'All agents watching the ticket' => 'Tutti gli agenti che osservano il ticket',
        'All agents with write permission for the ticket' => 'Tutti gli agenti con permesso di scrittura per il ticket',
        'All agents subscribed to the ticket\'s queue' => 'Tutti gli agenti si sono iscritti alla coda del ticket',
        'All agents subscribed to the ticket\'s service' => 'Tutti gli agenti si sono iscritti al servizio del ticket',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Tutti gli agenti si sono abbonati alla coda e al servizio del ticket',
        'Customer user of the ticket' => 'Utenza cliente del ticket',
        'All recipients of the first article' => 'Tutti i destinatari del primo articolo',
        'All recipients of the last article' => 'Tutti i destinatari dell\'ultimo articolo',
        'Invisible to customer' => 'Invisibile al cliente',
        'Visible to customer' => 'Visibile al cliente',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'L\'ambiente PGP non funziona. Si prega di controllare il registro per maggiori informazioni!',
        'Need param Key to delete!' => 'È necessaria la chiave param per eliminare!',
        'Key %s deleted!' => 'Chiave %s eliminata!',
        'Need param Key to download!' => 'È necessario scaricare la chiave param!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Spiacenti, Apache::Reload è necessario come PerlModule e PerlInitHandler nel file di configurazione di Apache. Vedi anche script/apache2-httpd.include.conf. In alternativa, è possibile utilizzare lo strumento da riga di comando bin/otrs.Console.pl per installare i pacchetti!',
        'No such package!' => 'Nessun pacchetto del genere!',
        'No such file %s in package!' => 'Nessun file del genere %s nel pacchetto!',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => 'Impossibile leggere %s!',
        'File is OK' => 'File è OK',
        'Package has locally modified files.' => 'Il pacchetto ha file modificati localmente.',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'Pacchetto non verificato da OTRS! Si consiglia di non utilizzarlo.',
        'Not Started' => 'Non iniziato',
        'Updated' => 'Aggiornato',
        'Already up-to-date' => 'Già aggiornato',
        'Installed' => 'Installato',
        'Not correctly deployed' => 'Non correttamente attivata',
        'Package updated correctly' => 'Pacchetto aggiornato correttamente',
        'Package was already updated' => 'Il pacchetto è stato già aggiornato',
        'Dependency installed correctly' => 'Dipendenza installata correttamente',
        'The package needs to be reinstalled' => 'Il pacchetto deve essere reinstallato',
        'The package contains cyclic dependencies' => 'Il pacchetto contiene dipendenze cicliche',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '',
        'Can\'t get OTOBO Feature Add-on list from server!' => '',
        'Can\'t get OTOBO Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Nessun filtro: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Priorità aggiunta!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Le informazioni di Process Management del database non sono sincronizzate con la configurazione di sistema, sincronizza tutti i processi.',
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => 'Sì (obbligatorio)',
        'Unknown Process %s!' => 'Processo %s sconosciuto!',
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
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => 'Impossibile eliminare %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => 'Impossibile ottenere %s',
        'Need %s!' => '%s richiesto!',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => 'Attività non trovata!',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
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
        'Customer Interface' => 'Interfaccia clienti',
        'Agent and Customer Interface' => 'Interfaccia agenti e clienti',
        'Do not show Field' => '',
        'Show Field' => 'Mostra campo',
        'Show Field As Mandatory' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Modifica percorso',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => 'Modifica transizione "%s"',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Coda aggiornata!',
        'Don\'t use :: in queue name!' => 'Non utilizzare :: nel nome della coda!',
        'Click back and change it!' => '',
        '-none-' => '-nessuno-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Code ( senza risposte automatiche )',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Cambia le relazioni con le code per il modello',
        'Change Template Relations for Queue' => 'Cambia le relazioni con i modelli per la coda',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produzione',
        'Test' => 'Test',
        'Training' => 'Formazione',
        'Development' => 'Sviluppo',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Ruolo aggiornato!',
        'Role added!' => 'Ruolo aggiunto!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Cambia le relazioni del gruppo per il ruolo',
        'Change Role Relations for Group' => 'Cambia le relazioni del ruolo per il gruppo',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Ruolo',
        'Change Role Relations for Agent' => 'Cambia relazioni ruolo per agente',
        'Change Agent Relations for Role' => 'Cambia relazioni agente per ruolo',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Attiva prima %s!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => 'La relazione esiste!',
        'Relation added!' => 'Relazione aggiunta!',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => 'La relazione non esiste',
        'Relation deleted!' => 'Relazione eliminata!',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Firma aggiornata!',
        'Signature added!' => 'Firma aggiunta!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Stato aggiunto!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Il file %s non può essere letto!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Account di posta di sistema aggiunto!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Importazione non consentita!',
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
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

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
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => '',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Modello aggiornato!',
        'Template added!' => 'Modello aggiunto!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '',
        'Change Template Relations for Attachment' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',
        'Type added!' => 'Tipo aggiunto!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agente aggiornato!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Cambia relazioni gruppo per agente',
        'Change Agent Relations for Group' => 'Cambia relazioni agente per gruppo',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mese',
        'Week' => 'Settimana',
        'Day' => 'Giorno',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '',
        'Appointments assigned to me' => '',
        'Showing only appointments assigned to you! Change settings' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '',
        'Never' => '',
        'Every Day' => '',
        'Every Week' => '',
        'Every Month' => '',
        'Every Year' => '',
        'Custom' => '',
        'Daily' => '',
        'Weekly' => '',
        'Monthly' => '',
        'Yearly' => '',
        'every' => '',
        'for %s time(s)' => '',
        'until ...' => '',
        'for ... time(s)' => '',
        'until %s' => '',
        'No notification' => '',
        '%s minute(s) before' => '',
        '%s hour(s) before' => '',
        '%s day(s) before' => '',
        '%s week before' => '',
        'before the appointment starts' => '',
        'after the appointment has been started' => '',
        'before the appointment ends' => '',
        'after the appointment has been ended' => '',
        'No permission!' => '',
        'Cannot delete ticket appointment!' => '',
        'No permissions!' => '',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Cronologia cliente',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => 'Statistica',
        'No preferences for %s!' => 'Nessuna preferenza per %s!',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Name' => 'Nome cliente',
        'Customer User Name' => 'Nome utenza cliente',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => 'Impossibile eliminare il collegamento con %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Impossibile creare il collegamento con %s!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',
        'This feature is not available.' => '',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => 'Il sistema non è riuscito ad attivare le tue modifiche.',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Manca il parametro %s.',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => 'La statistica non può essere importata.',
        'Please upload a valid statistic file.' => 'Carica un file di statistiche valido.',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Add New Statistic' => 'Aggiungi nuova statistica',
        'Could not create statistic.' => '',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Loading draft failed!' => 'Caricamento della bozza fallito!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Spiacente, devi essere il proprietario del ticket per effettuare questa operazione.',
        'Please change the owner first.' => 'Prima è necessario cambiare il proprietario.',
        'FormDraft functionality disabled!' => 'Funzione bozze non attiva!',
        'Draft name is required!' => 'La bozza richiede un nome!',
        'FormDraft name %s is already in use!' => 'Il nome %s per il modulo bozza è già usato!',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Nessun oggetto',
        'Could not delete draft!' => 'Non puoi cancellare la bozza!',
        'Previous Owner' => 'Gestore precedente',
        'wrote' => 'ha scritto',
        'Message from' => 'Messaggio da',
        'End message' => 'Fine messaggio',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s è richiesto!',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => 'Impossibile inviare il messaggio!',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => 'Il ticket (%s) non è sbloccato!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'L\'indirizzo %s è stato sostituito con l\'indirizzo registrato del cliente.',
        'Customer user automatically added in Cc.' => 'Utenza cliente aggiunta automaticamente in CC.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Ticket "%s" creato!',
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => 'Errore di sistema!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Settimana prossima',
        'Ticket Escalation View' => 'Vista Ticket Escalation',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Messaggio inoltrato da',
        'End forwarded message' => 'Fine messaggio inoltrato',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => 'Spiacente, l\'attuale proprietario è %s!',
        'Please become the owner first.' => 'Prima è necessario diventare il proprietario.',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => 'Cambia il proprietario!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nuovo articolo',
        'Pending' => 'In attesa',
        'Reminder Reached' => 'Promemoria raggiunti',
        'My Locked Tickets' => 'Ticket bloccati da me',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Ti servono i permessi di spostamento!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'La chat non è attiva.',
        'No permission.' => 'Nessun permesso.',
        '%s has left the chat.' => '%s ha lasciato la chat.',
        'This chat has been closed and will be removed in %s hours.' => 'Questa chat è stata chiusa e sarà rimossa tra %s ore.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket bloccato.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'The selected process is invalid!' => 'Il processo selezionato non è valido!',
        'Process %s is invalid!' => 'Il processo %s non è valido!',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
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
        'Pending Date' => 'Attesa fino a',
        'for pending* states' => 'per gli stati di attesa*',
        'ActivityDialogEntityID missing!' => '',
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
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Ticket disponibili',
        'including subqueues' => 'incluse le sottocode',
        'excluding subqueues' => 'escluse le sottocode',
        'QueueView' => 'Vista della coda',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Miei ticket di cui sono il responsabile',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'Ultima ricerca',
        'Untitled' => 'Senza titolo',
        'Ticket Number' => 'Numero ticket',
        'Ticket' => 'Ticket',
        'printed by' => 'stampato da',
        'CustomerID (complex search)' => '',
        'CustomerID (exact match)' => '',
        'Invalid Users' => 'Utenti non validi',
        'Normal' => 'Normale',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'in più di ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Funzionalità non abilitata!',
        'Service View' => 'Visualizzazione servizio',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Visualizzazione stato',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Miei ticket osservati',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'La funzionalità non è attiva',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Collegamento eliminato',
        'Ticket Locked' => 'Ticket bloccato',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => 'Campo dinamico aggiornato',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Ticket creato',
        'Type Updated' => 'Tipo aggiornato',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Cliente aggiornato',
        'Internal Chat' => 'Chat interna',
        'Automatic Follow-Up Sent' => 'Inviata prosecuzione automatica',
        'Note Added' => 'Nota aggiunta',
        'Note Added (Customer)' => 'Nota aggiunta (cliente)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'Stato aggiornato',
        'Outgoing Answer' => 'Risposta in uscita',
        'Service Updated' => 'Servizio aggiornato',
        'Link Added' => 'Collegamento aggiunto',
        'Incoming Customer Email' => 'Email cliente in entrata',
        'Incoming Web Request' => 'Richiesta web in entrata',
        'Priority Updated' => 'Priorità aggiornata',
        'Ticket Unlocked' => 'Ticket sbloccato',
        'Outgoing Email' => 'Email in uscita',
        'Title Updated' => 'Titolo aggiornato',
        'Ticket Merged' => 'Ticket unito',
        'Outgoing Phone Call' => 'Telefonata in uscita',
        'Forwarded Message' => 'Messaggio inoltrato',
        'Removed User Subscription' => '',
        'Time Accounted' => 'Tempo addebitato',
        'Incoming Phone Call' => 'Telefonata in entrata',
        'System Request.' => '',
        'Incoming Follow-Up' => 'Prosecuzione in arrivo',
        'Automatic Reply Sent' => '',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'SLA aggiornato',
        'External Chat' => 'Chat esterna',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => 'Manca l\'ID del modulo bozza!',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Forward article via mail' => 'Inoltra l\'articolo via email',
        'Forward' => 'Inoltra',
        'Fields with no group' => 'Campi senza gruppo',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',
        'Show one article' => 'Mostra un articolo',
        'Show all articles' => 'Mostra tutti gli articoli',
        'Show Ticket Timeline View' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'I miei ticket',
        'Company Tickets' => 'Ticket della Società',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Nome reale cliente',
        'Created within the last' => 'Creato negli ultimi',
        'Created more than ... ago' => 'Creato più di ... fa',
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => 'Creare un nuovo ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => 'Cartella "%s" non trovata!',
        'Install OTOBO' => 'Installa OTOBO',
        'Intro' => 'Introduzione',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Database Selection' => 'Selezione database',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Enter the password for the database user.' => 'Inserisci la password per l\'utente del database',
        'Database %s' => 'Database %s',
        'Configure MySQL' => '',
        'Enter the password for the administrative database user.' => 'Inserisci la password per l\'utente amministrativo del database',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Create Database' => 'Crea database',
        'Install OTOBO - Error' => '',
        'File "%s/%s.xml" not found!' => 'File "%s/%s.xml" non trovato!',
        'Contact your Admin!' => 'Contatta il tuo amministratore!',
        'System Settings' => 'Impostazioni di sistema',
        'Syslog' => '',
        'Configure Mail' => 'Configurazione posta',
        'Mail Configuration' => 'Configurazione della posta',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Database already contains data - it should be empty!' => 'Il database risulta contenere dati - dovrebbe essere vuoto!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '',
        'No such user!' => '',
        'Invalid calendar!' => '',
        'Invalid URL!' => '',
        'There was an error exporting the calendar!' => '',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => 'Autenticazione non riuscita da %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Reinvia l\'articolo a un indirizzo di posta diverso',
        'Bounce' => 'Rispedisci',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Rispondi a tutti',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Rispondere alla nota',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Dividi questo articolo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '',
        'Plain Format' => 'Formato semplice',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Stampa questo articolo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Seleziona',
        'Unmark' => 'Deseleziona',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => '',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Cifrato',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Firmato',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => 'Decifratura avvenuta con successo',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Firma',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Mostrati',
        'Refresh (minutes)' => '',
        'off' => 'spento',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Id clienti mostrati',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Utenze clienti mostrate',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => '',
        'Can\'t get OTOBO News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Ticket visualizzati',
        'Shown Columns' => 'Mostra colonne',
        'filter not active' => 'filtro non attivo',
        'filter active' => 'filtro attivo',
        'This ticket has no title or subject' => 'Questo ticket non ha né titolo né oggetto',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Statistiche ultimi 7 Giorni',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '',
        'Unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Standard',
        'The following tickets are not updated: %s.' => '',
        'h' => 'h',
        'm' => 'm',
        'd' => 'g',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Questo è un',
        'email' => 'email',
        'click here' => 'fai clic qui',
        'to open it in a new window.' => 'per aprire in una nuova finestra.',
        'Year' => 'Anno',
        'Hours' => 'Ore',
        'Minutes' => 'Minuti',
        'Check to activate this date' => 'Seleziona per attivare questa data',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Permessi insufficienti!',
        'No Permission' => 'Nessun permesso',
        'Show Tree Selection' => 'Mostra la selezione ad albero',
        'Split Quote' => '',
        'Remove Quote' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Collegato come',
        'Search Result' => 'Risultato della ricerca',
        'Linked' => 'Collegato',
        'Bulk' => 'Aggiornamento multiplo',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Ridotta',
        'Unread article(s) available' => 'Articoli non letti disponibili',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Appuntamento',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Agenti collegati: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Ci sono altri ticket scalati!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Clienti collegati: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'Il demone OTOBO non è in esecuzione.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Risposta automatica abilitata. Vuoi disabilitarla?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Hai %s impostazioni non valide attivate. Fare clic qui per vedere le impostazioni non valide.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Ci sono modifiche non attivate. Attivarle adesso?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',
        'Preferences updated successfully!' => 'Preferenze modificate con successo!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(in corso)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Verifica password',
        'The current password is not correct. Please try again!' => 'La password corrente è errata. Riprova!',
        'Please supply your new password!' => 'Fornisci la nuova password!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Impossibile aggiornare la password, deve essere lunga almeno %s caratteri!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Impossibile aggiornare la password, deve contenere almeno un numero!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'non valido',
        'valid' => 'valido',
        'No (not supported)' => 'No (non supportato)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => 'La data selezionata non è valida.',
        'The selected end time is before the start time.' => 'L\'ora di fine selezionata precede l\'ora di inizio.',
        'There is something wrong with your time selection.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => 'Seleziona un elemento per l\'asse X.',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => 'Seleziona almeno un valore di questo campo.',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => 'Seleziona una scala temporale.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'second(s)' => 'secondo(i)',
        'quarter(s)' => 'trimestre(i)',
        'half-year(s)' => 'semestre(i)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Contenuto',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Sbloccalo per rimetterlo nella coda',
        'Lock it to work on it' => 'Bloccalo per lavorare sul ticket',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Non osservare',
        'Remove from list of watched tickets' => 'Rimuovere dalla lista di ticket osservati',
        'Watch' => 'Osserva',
        'Add to list of watched tickets' => 'Aggiungere alla lista di ticket osservati',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordina per ',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Nuovi ticket bloccati',
        'Locked Tickets Reminder Reached' => 'Reminder raggiunto ticket bloccati',
        'Locked Tickets Total' => 'Totale ticket bloccati',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Nuovi ticket assegnati',
        'Responsible Tickets Reminder Reached' => 'Reminder raggiunto ticket assegnati',
        'Responsible Tickets Total' => 'Totale ticket assegnati',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Nuovi ticket osservati',
        'Watched Tickets Reminder Reached' => 'Reminder raggiunto ticket osservati',
        'Watched Tickets Total' => 'Totale ticket osservati',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Campi dinamici ticket',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Al momento non è possibile accedere al sistema per attività di manutenzione in corso.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sessione non valida. Effettua di nuovo l\'accesso.',
        'Session has timed out. Please log in again.' => 'Sessione scaduta per inattività. Effettua di nuovo l\'accesso.',

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
        'Configuration Options Reference' => 'Riferimenti per Opzioni di Configurazione',
        'This setting can not be changed.' => 'Questa impostazione non può essere modificata.',
        'This setting is not active by default.' => 'Questa impostazione non è attiva in modo predefinito.',
        'This setting can not be deactivated.' => 'Questa impostazione non può essere disattivata.',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'prima/dopo',
        'between' => 'tra',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Questo campo è obbligatorio oppure ',
        'The field content is too long!' => 'Il contenuto del campo è troppo lungo!',
        'Maximum size is %s characters.' => 'La dimensione massima è di %s caratteri.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'non installato',
        'installed' => 'Installato',
        'Unable to parse repository index document.' => 'Impossibile analizzare l\'indice dei repository.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Non esistono pacchetti per la vostra versione del framework in questo repository, ne sono contenuti solo per altre versioni.',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inattivo',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Impossibile contattare il server per la registrazione. Riprova più tardi.',
        'No content received from registration server. Please try again later.' =>
            'Nessun dato ricevuto dal server per la registrazione. Riprova più tardi.',
        'Can\'t get Token from sever' => '',
        'Username and password do not match. Please try again.' => 'Il nome utente e la password non corrispondono. Prova ancora.',
        'Problems processing server result. Please try again later.' => 'Si sono verificati problemi elaborando la risposta del server. Riprova più tardi.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Somma',
        'week' => 'settimana',
        'quarter' => 'trimestre',
        'half-year' => 'semestre',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tipo di stato',
        'Created Priority' => 'Priorità creata',
        'Created State' => 'Stato ticket',
        'Create Time' => 'Tempo di Creazione',
        'Pending until time' => '',
        'Close Time' => 'Tempo di Chiusura',
        'Escalation' => 'Escalation',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agente/Proprietario',
        'Created by Agent/Owner' => 'Creato da Agente/Proprietario',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Valutato da',
        'Ticket/Article Accounted Time' => 'Ticket/Tempo allocato',
        'Ticket Create Time' => 'Istante di creazione Ticket',
        'Ticket Close Time' => 'Istante di chiusura Ticket',
        'Accounted time by Agent' => 'Tempo impiegato dall\'operatore',
        'Total Time' => 'Tempo totale',
        'Ticket Average' => 'Media Ticket',
        'Ticket Min Time' => 'Max Tempo Ticket',
        'Ticket Max Time' => 'Min Tempo Ticket',
        'Number of Tickets' => 'Numero dei Tickets',
        'Article Average' => 'Media Articolo',
        'Article Min Time' => 'Min Tempo Articolo',
        'Article Max Time' => 'Max Tempo Articolo',
        'Number of Articles' => 'Numero di Articoli',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'Attributes to be printed' => 'Attributi sa stampare',
        'Sort sequence' => 'Sequenza di ordinamento',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',
        'Number' => 'Numero',
        'Last Changed' => '',

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
        'Days' => 'Giorni',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabella delle Presenze',
        'Internal Error: Could not open file.' => 'Errore interno: Impossibile aprire il file.',
        'Table Check' => 'Controllo Tabelle',
        'Internal Error: Could not read file.' => 'Errore interno: Impossibile leggere il file.',
        'Tables found which are not present in the database.' => 'Trovate tabelle non presenti nel database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Dimensione Database',
        'Could not determine database size.' => 'Impossibile determinare la dimensione del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versione Database',
        'Could not determine database version.' => 'Impossibile determinare la versione del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Charset della Connessione Client',
        'Setting character_set_client needs to be utf8.' => 'Il parametro character_set_client deve essere impostato a utf8.',
        'Server Database Charset' => 'Charset del Server Database',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Charset della Tabella',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Dimensione Massima della Query',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Dimensione della Query Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Si consiglia l\'uso del parametro \'query_cache_size\' (fra 10 MB e 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Default Storage Engine',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Sono state trovate tabelle che hanno una storage engine diversa dal default del database.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'È richiesto l\'uso di MySQL 5.x o versioni superiori.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Impostazione NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG deve essere impostato a al32utf8 (ad es. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Parametro NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'Il parametro NLS_DATE_FORMAT deve essere impostato nel formato \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'Controllo impostazione SQL NLS_DATE_FORMAT',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Il parametro client_encoding deve essere UNICODE o UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Il parametro server_encoding deve essere UNICODE o UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato Data',
        'Setting DateStyle needs to be ISO.' => 'Il parametro DateStyle deve essere di tipo ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Partizione disco di OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Utilizzo Disco',
        'The partition where OTOBO is located is almost full.' => 'La partizione dove risiede OTOBO è quasi satura.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'La partizione disco dove risiede OTOBO non ha problemi di spazio.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Utilizzo delle partizioni disco',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribuzione',
        'Could not determine distribution.' => 'Impossibile determinare la distribuzione.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versione di Kernel',
        'Could not determine kernel version.' => 'Impossibile ricavare la versione del Kernel',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carico di sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Moduli Perl',
        'Not all required Perl modules are correctly installed.' => 'Non tutti i moduli Perl necessari sono correttamente installati.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Spazio Swap libero (%)',
        'No swap enabled.' => 'Swap non abilitata.',
        'Used Swap Space (MB)' => 'Utilizzo spazio Swap (MB)',
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
        'Config Settings' => 'Impostazioni di configurazione',
        'Could not determine value.' => 'Impossibile determinare il valore.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Demone',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Il demone non è in esecuzione.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Record di Database',
        'Ticket History Entries' => 'Voci nello Storico Ticket',
        'Articles' => 'Articoli',
        'Attachments (DB, Without HTML)' => 'Allegati (DB, senza HTML)',
        'Customers With At Least One Ticket' => 'Clienti Con Almeno Un Ticket',
        'Dynamic Field Values' => 'Valori dei Campi Dinamici',
        'Invalid Dynamic Fields' => 'Campi Dinamici non validi',
        'Invalid Dynamic Field Values' => 'Valori dei Campi Dinamici non validi',
        'GenericInterface Webservices' => 'GenericInterface Webservice',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Numero mesi fra primo e ultimo Ticket',
        'Tickets Per Month (avg)' => 'Ticket per mese (media)',
        'Open Tickets' => 'Ticket aperti',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Nome utente e password SOAP predefiniti',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Possibile rischio sicurezza: si stanno usando le impostazioni predefinite per SOAP::User e SOAP::Password, si consiglia di cambiarle.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Password di Admin predefinita',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Attenzione: l\'utente root@localhost ha la password predefinita. Si consiglia di cambiare la password o disabilitare l\'utente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nome di dominio)',
        'Please configure your FQDN setting.' => 'Configura l\'impostazione di FQDN.',
        'Domain Name' => 'Nome a Dominio',
        'Your FQDN setting is invalid.' => 'L\'impostazione del FQDN non è valida.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'File System scrivibile.',
        'The file system on your OTOBO partition is not writable.' => 'Il file system dove risiede OTOBO non è scrivibile.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Stato di installazione del pacchetto',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Alcuni pacchetti non sono correttamente installati.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Lista pacchetti',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTOBO could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Il parametro SystemID è invalido, può contenere solo numeri.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Modulo indice ticket',
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
        'Server time zone' => 'Fuso orario server',
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
        'Webserver' => 'Webserver',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Modello MPM',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Utilizzo dell\'acceleratore CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => 'Utilizzo di mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Si suggerisce l\'installazione di mod_deflate per migliorare i tempi di risposta dell\'interfaccia utente',
        'mod_filter Usage' => 'Utilizzo mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Installa mod_filter se è utilizzato mod_deflate.',
        'mod_headers Usage' => 'Utilizzo di mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Si suggerisce l\'installazione di mod_headers per migliorare i tempi di risposta dell\'interfaccia utente.',
        'Apache::Reload Usage' => 'Utilizzo di Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => 'Apache2::DBI Usage',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variabili di ambiente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versione Webserver',
        'Could not determine webserver version.' => 'Impossibile determinare la versione del server web.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Utenti concomitanti',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problema',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => 'Impossibile bloccare l\'attivazione per l\'UserID \'%s\'!',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Predefinito',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '',
        'Disabled' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Accesso non riuscito! Il nome utente o la password sono errati.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => 'Disconnessione avvenuta.',
        'Feature not active!' => 'Funzione non attiva!',
        'Sent password reset instructions. Please check your email.' => 'Inviate le istruzioni per il ripristino della password. Controlla l\'email.',
        'Invalid Token!' => 'Token non valido!',
        'Sent new password to %s. Please check your email.' => 'Nuova password inviata a %s. Controlla l\'email.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'L\'indirizzo email inserito esiste già. Effettuare l\'accesso o reimposta la password.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'L\'indirizzo email inserito non è abilitato per la registrazione. Contatta il supporto tecnico.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nuovo account creato. Le informazioni di accesso sono state inviate a %s. Controlla l\'email.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Azione "%s" non trovata!',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'non valido-temporaneamente',
        'Group for default access.' => 'Gruppo per l\'accesso predefinito.',
        'Group of all administrators.' => 'Gruppo di tutti gli amministratori.',
        'Group for statistics access.' => 'Gruppo per l\'accesso alle statistiche.',
        'new' => 'nuovo',
        'All new state types (default: viewable).' => '',
        'open' => 'aperto',
        'All open state types (default: viewable).' => '',
        'closed' => 'chiuso',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'in attesa di promemoria',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'in attesa di chiusura automatica',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'rimosso',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'unito',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => 'Nuovo ticket creato dal cliente.',
        'closed successful' => 'chiuso con successo',
        'Ticket is closed successful.' => 'Ticket chiuso con successo.',
        'closed unsuccessful' => 'chiuso senza successo',
        'Ticket is closed unsuccessful.' => 'Ticket chiuso senza successo.',
        'Open tickets.' => 'Ticket aperti.',
        'Customer removed ticket.' => 'Il cliente ha rimosso il ticket.',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'in attesa di chiusura automatica+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'in attesa di chiusura automatica-',
        'State for merged tickets.' => 'Stato per i ticket uniti.',
        'system standard salutation (en)' => 'formula di saluto standard di sistema (en)',
        'Standard Salutation.' => 'Formula di saluto standard.',
        'system standard signature (en)' => 'firma standard di sistema (en)',
        'Standard Signature.' => 'Firma standard.',
        'Standard Address.' => 'Indirizzo standard.',
        'possible' => 'possibile',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Sono possibili prosecuzioni .per i ticket chiusi. Il ticket verrà riaperto.',
        'reject' => 'rifiuta',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Non sono possibili prosecuzioni per i ticket. Non verrà creato alcun nuovo ticket.',
        'new ticket' => 'nuovo ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Non sono possibili prosecuzioni per i ticket chiusi. Verrà creato un nuovo ticket.',
        'Postmaster queue.' => 'Coda Postmaster.',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'risposta automatica',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'rifiuto automatico',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Rifiuto automatico che verrà inviato dopo che una prosecuzione è stata respinta (nel caso in cui l\'opzione prosecuzione per la coda è "reject").',
        'auto follow up' => 'follow up automatico',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Conferma automatica che viene inviata dopo che è stata ricevuta una prosecuzione per un ticket (qualora l\'opzione prosecuzione per la cosa è "possibile").',
        'auto reply/new ticket' => 'risposta automatica con creazione nuovo ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Risposta automatica che verrà inviata dopo aver respinto una prosecuzione e aver creato un nuovo ticket (qualora l\'opzione prosecuzione per la coda è "new ticket").',
        'auto remove' => 'rimozione automatica',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Non classificato',
        '1 very low' => '1 molto bassa',
        '2 low' => '2 bassa',
        '3 normal' => '3 normale',
        '4 high' => '4 alta',
        '5 very high' => '5 molto alta',
        'unlock' => 'sbloccato',
        'lock' => 'bloccato',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'Agente',
        'system' => 'sistema',
        'customer' => 'cliente',
        'Ticket create notification' => 'Notifica di creazione dei ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Riceverai una notifica ogni volta che un nuovo ticket vine creato in una delle "Mie code" o "Miei servizi".',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Riceverai una notifica se un cliente invia un seguito a un ticket sbloccato che è in una delle "Mie code" o "Miei servizi".',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Riceverai una notifica se un cliente invia una prosecuzione a un ticket bloccato per il quale sei proprietario o responsabile.',
        'Ticket lock timeout notification' => 'Notifica scadenza blocco ticket',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => 'Notifica aggiornamento proprietario ticket',
        'Ticket responsible update notification' => 'Notifica aggiornamento responsabile ticket',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Riceverai una notifica se un ticket viene trasferito in una delle tue "Code personali"',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => '',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Aggiungi tutto',
        'An item with this name is already present.' => 'Una voce con questo nome esiste già.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Questa voce contiene delle sottovoci. Sei sicuro di volere rimuovere questa voce con le relative sottovoci?',

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

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vuoi davvero eliminare questo campo dinamico? TUTTI i dati associati saranno PERSI!',
        'Delete field' => 'Elimina campo',
        'Deleting the field and its data. This may take a while...' => 'Eliminazione del campo e dei suoi dati. Ciò potrebbe richiedere del tempo...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Rimuovi selezione',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Elimina questo trigger',
        'Duplicate event.' => 'Evento duplicato.',
        'This event is already attached to the job, Please use a different one.' =>
            'Questo evento è già collegato al job, specificarne uno diverso',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Errore durante la comunicazione',
        'Request Details' => 'Richiedi dettagli',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Mostra o nascondi il contenuto',
        'Clear debug log' => 'Cancella il debug log',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Elimina questo invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Elimina questa mappatura',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Elimina questa operazione',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Copia web service',
        'Delete operation' => 'Elimina operazione',
        'Delete invoker' => 'Elimina invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVVISO: Quando cambi il nome del gruppo \'admin\', prima delle opportune modifiche in SysConfig, sarai escluso dal pannello di amministrazione! Se ciò accade ripristina il nome precedente del gruppo a \'admin\'.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Vuoi davvero eliminare questa lingua delle notifiche?',
        'Do you really want to delete this notification?' => 'Vuoi davvero eliminare questa notifica?',

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
        'No TransitionActions assigned.' => 'Non ci sono Azioni di Transizione Assegnate.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Non ci sono interazioni assegnate. Seleziona un messaggio dall\'elenco a sinistra e trascinalo qui.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Questa attività non può essere eliminata perché è l\'attività iniziale.',
        'Remove the Transition from this Process' => 'Rimuovi la transizione da questo processo',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Non appena utilizzi il pulsante o il collegamento, abbandonerai questa schermata e lo stato corrente sarà salvato in automatico. Vuoi continuare?',
        'Delete Entity' => 'Elimina entità',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Questa attività è già in uso nel Processo. Non puoi aggiungerla due volte!.',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Questa Transizione è già utilizzata per questa Attività. Non puoi aggiungerla due volte!.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Questa Azione di Transizione è già in uso in questo percorso. Non puoi usarla due volte!.',
        'Hide EntityIDs' => 'Nascondi EntityID',
        'Edit Field Details' => 'Modifica i dettagli per il campo',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Invio aggiornamenti in corso...',
        'Support Data information was successfully sent.' => 'Informazioni dei dati di supporto inviate correttamente.',
        'Was not possible to send Support Data information.' => 'Non è stato possibile inviare le informazioni dei dati di supporto.',
        'Update Result' => 'Aggiorna risultati',
        'Generating...' => 'Generazione in corso...',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => 'Il messaggio non può essere inviato',

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
            'La voce che si sta visualizzando fa parte di una impostazione di configurazione non ancora attivata. Non è possibile modificala nello stato attuare. Attendere fino al completamento dell\'attivazione. Nel dubbio, contattare il proprio amministratore di sistema.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Caricamento in corso...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Impossibile eseguire adesso l\'attivazione, forse è in corso un\'altra attivazione da parte di un altro agente. Provare nuovamente in seguito.',
        'Deploy' => 'Attiva',
        'The deployment is already running.' => 'L\'attivazione è già in esecuzione.',
        'Deployment successful. You\'re being redirected...' => 'Attivazione riuscita. Redirezione ad altra pagina...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Ripristinando questa attivazione, verranno ripristinati tutti i valori che le impostazioni avevano al momento dell\'attivazione. Continuare?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Vuoi davvero eliminare questa manutenzione di sistema pianificata?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '',
        'Timeline Month' => '',
        'Timeline Week' => '',
        'Timeline Day' => '',
        'Previous' => 'Precedente',
        'Resources' => '',
        'Su' => 'Do',
        'Mo' => 'Lu',
        'Tu' => 'Ma',
        'We' => 'Me',
        'Th' => 'Gi',
        'Fr' => 'Ve',
        'Sa' => 'Sa',
        'This is a repeating appointment' => 'Questo è un evento ripetuto',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Vorresti modificare solo questo evento o tutti gli eventi nella serie?',
        'All occurrences' => 'Tutti gli eventi',
        'Just this occurrence' => 'Solo questo evento',
        'Too many active calendars' => '',
        'Please either turn some off first or increase the limit in configuration.' =>
            '',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Voce duplicata',
        'It is going to be deleted from the field, please try again.' => 'Sta per essere eliminato dal campo, riprova.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Inserisci almeno un termine o * per cercare tutto.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informazioni su OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '',
        'month' => 'mese',
        'Remove active filters for this widget.' => '',

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
            'Spiacenti, ma non puoi disabilitare tutti i metodi per questa notifica.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Passa alla modalità desktop',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Vuoi davvero eliminare questa statistica?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Vuoi davvero continuare?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Aggiungi nuova bozza',
        'Delete draft' => 'Cancella bozza',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtro articolo',
        'Apply' => 'Applica',
        'Event Type Filter' => 'Filtro tipo di evento',

        # JS File: Core.Agent
        'Slide the navigation bar' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Disattiva la modalità di compatibilità in Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Passa alla modalità mobile',

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
        'One or more errors occurred!' => 'Si sono verificati uno o più errori!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Controllo email eseguito con successo.',
        'Error in the mail settings. Please correct and try again.' => 'Errore nelle impostazioni dell\'email. Correggi e riprova.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Apri selezione data',
        'Invalid date (need a future date)!' => 'Data non valida (è necessaria una data nel futuro)!',
        'Invalid date (need a past date)!' => 'Data non valida (è necessaria una data nel passato)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Non disponibile',
        'and %s more...' => 'e %s altri...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Cancella tutto',
        'Filters' => 'Filtri',
        'Clear search' => 'Cancella la ricerca',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se si abbandona questa pagina, tutti i popup verranno chiusi!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Un popup di questa schermata è già aperto. Si desidera chiuderlo ed aprire questo invece?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Impossibile aprire una finestra di popup. Disabilita ogni blocco di popup per questa applicazione.',

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
        'The following files are not allowed to be uploaded: %s' => 'Non è permesso caricare i seguenti file: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'sì',
        'no' => 'no',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTOBOLineChart
        'No Data Available.' => '',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Raggruppato',
        'Stacked' => 'Impilato',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Flusso',
        'Expanded' => 'Espanso',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
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
        'Are you sure you want to remove all user values?',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
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
        'Delete web service',
        'Deleting attachment...',
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
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
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
        'Import web service',
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
        'Show current selection',
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
