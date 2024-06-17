# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Language::es_MX;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y - %T';
    $Self->{DateFormatLong}      = '%A, %D %B %Y - %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.998864926220204;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = '.';
    $Self->{ThousandSeparator} = ',';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Administración de ACL',
        'Actions' => 'Acciones',
        'Create New ACL' => 'Crear Nueva ACL',
        'Deploy ACLs' => 'Desplegar ACL',
        'Export ACLs' => 'Exportar ACL',
        'Filter for ACLs' => 'Filtrar por ACLs',
        'Just start typing to filter...' => 'Comience a teclear para filtrar...',
        'Configuration Import' => 'Importar Configuración',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aquí puede cargar un archivo de configuración para importar ACLs a su sistema. El archivo debe estar en formato .yml tal y como lo exporta el módulo de edición de ACL.',
        'This field is required.' => 'Este es un campo obligatorio.',
        'Overwrite existing ACLs?' => '¿Sobre escribir ACLs existentes?',
        'Upload ACL configuration' => 'Cargar configuración de ACL',
        'Import ACL configuration(s)' => 'Importar configuración(es) de ACL',
        'Description' => 'Descripción',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para crear una nueva ACL puede importar ACLs que hayan sido exportadas en otro sistema, o bien crear una completamente nueva.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Los cambios a estas ACL sólo afectan al comportamiento del sistema, si despliega los datos de las ACL después. Al desplegar los datos de las ACL, los nuevos cambios realizados se escribirán en la configuración.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor, observe: Esta tabla representa el orden de ejecución de las ACL. Si necesita cambiar el orden en que se ejecutan las ACL, cambie los nombres de las ACL afectadas.',
        'ACL name' => 'Nombre de la ACL',
        'Comment' => 'Comentario',
        'Validity' => 'Validez',
        'Export' => 'Exportar',
        'Copy' => 'Copiar',
        'No data found.' => 'No se encontraron datos.',
        'No matches found.' => 'No se encontraron coincidencias.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Editar ACL %s',
        'Edit ACL' => 'Editar ACL',
        'Go to overview' => 'Ir la vista de resumen',
        'Delete ACL' => 'Eliminar ACL',
        'Delete Invalid ACL' => 'Eliminar ACL Inválida',
        'Match settings' => 'Configuración de Coincidencias',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Establecer los criterios de coincidencia para esta ACL. Use \'Properties\' para coincidir con la pantalla actual o \'PropertiesDatabase\' para coincidir con los atributos del ticket actual que están en la base de datos.',
        'Change settings' => 'Cambiar configuración',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Configure lo que quiere cambiar si los criterios corresponden entre si. Tenga en cuenta que \'Possible\' es una lista blanca, \'PossibleNot\' una lista negra.',
        'Check the official %sdocumentation%s.' => 'Verifique la documentación oficial %sdocumentation%s.',
        'Show or hide the content' => 'Mostrar u ocultar el contenido',
        'Edit ACL Information' => 'Editar Información de ACL',
        'Name' => 'Nombre',
        'Stop after match' => 'Parar al coincidir',
        'Edit ACL Structure' => 'Editar Estructura de ACL',
        'Save ACL' => 'Guardar ACL',
        'Save' => 'Guardar',
        'or' => 'o',
        'Save and finish' => 'Guardar y terminar',
        'Cancel' => 'Cancelar',
        'Do you really want to delete this ACL?' => '¿Realmente desea eliminar esta ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Crear una nueva ALC al ingresar los datos del formulario. Una vez creada la ACL, usted podrá añadir elementos de configuración en modo de edición.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Gestión de Calendarios',
        'Add Calendar' => 'Añadir Calendario',
        'Edit Calendar' => 'Editar Calendario',
        'Calendar Overview' => 'Resumen de Calendarios',
        'Add new Calendar' => 'Añadir un Calendario nuevo',
        'Import Appointments' => 'Importar Citas',
        'Calendar Import' => 'Importar Calendario',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Aquí es posible cargar un archivo de configuración para importar un calendario a su sistema. El archivo necesita estar en el formato .yml para poder ser exportado por el módulo de gestión de calendarios.',
        'Overwrite existing entities' => 'Sobrescribir entidades existentes',
        'Upload calendar configuration' => 'Cargar configuración de calendario',
        'Import Calendar' => 'Importar Calendario',
        'Filter for Calendars' => 'Filtro para Calendarios',
        'Filter for calendars' => 'Filtro para Calendarios',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Dependiendo del campo de grupo, el sistema permite el acceso a usuarios al calendario de acuerdo a sus niveles de permisos.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'RO: usuarios que pueden ver y exportar todas las citas en el calendario.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Mover_A: usuarios que pueden modificar citas en el calendario, pero sin cambiar la selección de calendario.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Crear: usuarios que pueden crear y borrar citas en el calendario.',
        'Read/write: users can manage the calendar itself.' => 'Lectura/Escritura: usuario que pueden gestionar el calendario en sí.',
        'Group' => 'Grupo',
        'Changed' => 'Modificado',
        'Created' => 'Creado',
        'Download' => 'Descargar',
        'URL' => 'URL',
        'Export calendar' => 'Exportar calendario',
        'Download calendar' => 'Descargar calendario',
        'Copy public calendar URL' => 'Copiar URL pública de calendario',
        'Calendar' => 'Calendario',
        'Calendar name' => 'Nombre del calendario',
        'Calendar with same name already exists.' => 'Ya existe un calendario con el mismo nombre.',
        'Color' => 'Color',
        'Permission group' => 'Grupo de permisos',
        'Ticket Appointments' => 'Citas de Ticket',
        'Rule' => 'Regla',
        'Remove this entry' => 'Eliminar esta entrada',
        'Remove' => 'Quitar',
        'Start date' => 'Fecha de Inicio',
        'End date' => 'Fecha de término',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Use las opciones mostradas abajo para acortar las citas de tickets serán creadas automáticamente.',
        'Queues' => 'Colas',
        'Please select a valid queue.' => 'Por favor, seleccione una cola válida.',
        'Search attributes' => 'Atributos de búsqueda',
        'Add entry' => 'Añadir entrada',
        'Add' => 'Añadir',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Define reglas para creación de citas automáticas en este calendario basadas en los datos de los tickets.',
        'Add Rule' => 'Añadir regla',
        'Submit' => 'Enviar',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Importar Cita',
        'Go back' => 'Regresar',
        'Uploaded file must be in valid iCal format (.ics).' => 'El archivo cargado tiene que estar en un formato iCal válido (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Si el Calendario deseado no aparece en la lista, por favor asegúrese de que tenga al menos el permiso de "crear".',
        'Upload' => 'Subir',
        'Update existing appointments?' => '¿Actualizar las citas existentes?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Todas las citas existentes en el calendario con el mismo UniqueID se sobrescribirán.',
        'Upload calendar' => 'Cargar calendario',
        'Import appointments' => 'Importar citas',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Gestión de Notificaciones de Citas',
        'Add Notification' => 'Agregar Notificación',
        'Edit Notification' => 'Modificar Notificación',
        'Export Notifications' => 'Exportar Notificaciones',
        'Filter for Notifications' => 'Filtro para Notificaciones',
        'Filter for notifications' => 'Filtro para notificaciones',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Aquí es posible cargar un archivo de configuración para importar las notificaciones de las citas a su sistema. El archivo necesita estar en el formato .yml como los exportados por el módulo de notificaciones de citas.',
        'Overwrite existing notifications?' => 'Sobrescribir las notificaciones existentes?',
        'Upload Notification configuration' => 'Cargar Configuración de Notificaciones',
        'Import Notification configuration' => 'Importar Configuración de Notificaciones',
        'List' => 'Listar',
        'Delete' => 'Borrar',
        'Delete this notification' => 'Eliminar esta notificación',
        'Show in agent preferences' => 'Mostrar en las preferencias del agente',
        'Agent preferences tooltip' => 'Preferencias de ayuda de agente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Este mensaje se mostrará en la pantalla de preferencias del agente como un "tooltip" para esta notificación.',
        'Toggle this widget' => 'Activar este widget',
        'Events' => 'Eventos',
        'Event' => 'Evento',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Aquí es posible elegir los eventos que iniciarán esta notificación. Un filtro adicional de la cita se puede aplicar a continuación para enviar sólo citas con ciertos criterios.',
        'Appointment Filter' => 'Filtro de citas',
        'Type' => 'Tipo',
        'Title' => 'Título',
        'Location' => 'Ubicación',
        'Team' => 'Equipo',
        'Resource' => 'Recurso',
        'Recipients' => 'Recipientes',
        'Send to' => 'Enviar a',
        'Send to these agents' => 'Enviar a estos agentes',
        'Send to all group members (agents only)' => 'Enviar a todos los miembros del grupo (solo agentes)',
        'Send to all role members' => 'enviar a todos los miembros del rol',
        'Send on out of office' => 'Mandar cuando esta fuera de la oficina',
        'Also send if the user is currently out of office.' => 'Mandar incluso de el usuario de encuentra fuera de la oficina.',
        'Once per day' => 'Una vez al día',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Notificar al usuario solo una vez al día acerca de una sola cita usando el transporte seleccionado.',
        'Notification Methods' => 'Métodos de notificación',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Estos son los métodos posibles que pueden usarsa para enviar notificaciones a cada uno de los destinatarios. Favor de seleccionar al menos uno de los métodos siguientes.',
        'Enable this notification method' => 'Activar este método de notificación',
        'Transport' => 'Transporte',
        'At least one method is needed per notification.' => 'AL menos un métodos es necesario por cada notificación.',
        'Active by default in agent preferences' => 'Activo por omisión en las preferencias del agente',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Este es el valor predeterminado para los agentes destinatarios asignados que aún no han elegido esta notificación en sus preferencias. Si la casilla está habilitada, la notificación se enviará a dichos agentes.',
        'This feature is currently not available.' => 'Esta funcionalidad no está disponible por el momento.',
        'Upgrade to %s' => 'Actualizar a %s',
        'Please activate this transport in order to use it.' => 'Por favor active este transporte para poder usarlo.',
        'No data found' => 'No se encontraron datos',
        'No notification method found.' => 'Método de notificación no encontrado.',
        'Notification Text' => 'Texto de Notificación',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Este idioma no está presente o habilitado en el sistema. Este texto de notificación podría eliminarse si ya no es necesario.',
        'Remove Notification Language' => 'Eliminar Lenguaje De Notificación',
        'Subject' => 'Asunto',
        'Text' => 'Texto',
        'Message body' => 'Cuerpo del mensaje',
        'Add new notification language' => 'Añadir nuevo lenguaje de notificaciones',
        'Save Changes' => 'Guardar Cambios',
        'Tag Reference' => 'Etiqueta de Referencia',
        'Notifications are sent to an agent.' => 'Las notificaciones se envían a un agente.',
        'You can use the following tags' => 'Puede utilizar las siguientes etiquetas',
        'To get the first 20 character of the appointment title.' => 'Para obtener los primeros 20 caracteres del título de la cita.',
        'To get the appointment attribute' => 'Para obtener el atributo de la cita',
        ' e. g.' => ' Por ejemplo.',
        'To get the calendar attribute' => 'Para obtener el atributo del calendario',
        'Attributes of the recipient user for the notification' => 'Atributos del usuario destino para la notificación',
        'Config options' => 'Opciones de configuración',
        'Example notification' => 'Notificación de ejemplo',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Direcciones de correo electrónico adicionales para el destinatario',
        'This field must have less then 200 characters.' => 'Este campo debe contener menos de 200 caracteres.',
        'Article visible for customer' => 'Artículo visible para el cliente',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Se creará un artículo si la notificación se envía al cliente o a una dirección de correo electrónico adicional.',
        'Email template' => 'Plantilla de correo electrónico',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Use esta plantilla para generar el correo electrónico completo (solo para correos electrónicos HTML).',
        'Enable email security' => 'Activar seguridad de correo electrónico',
        'Email security level' => 'Nivel de seguridad de correo electrónico',
        'If signing key/certificate is missing' => 'Si la llave o certificado para firmar no se encuentran',
        'If encryption key/certificate is missing' => 'Si la llave o certificado de encriptación no se encuentran',

        # Template: AdminAttachment
        'Attachment Management' => 'Administración de Anexos',
        'Add Attachment' => 'Adjuntar Archivo',
        'Edit Attachment' => 'Modificar Archivo Adjunto',
        'Filter for Attachments' => 'Filtro para Archivos Adjuntos',
        'Filter for attachments' => 'Filtro para archivos adjuntos',
        'Filename' => 'Nombre del archivo',
        'Download file' => 'Descargar archivo',
        'Delete this attachment' => 'Eliminar este archivo adjunto',
        'Do you really want to delete this attachment?' => 'Está seguro de eliminar este adjunto?',
        'Attachment' => 'Anexo',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administración de Respuestas Automáticas',
        'Add Auto Response' => 'Agregar Respuesta Automática',
        'Edit Auto Response' => 'Modificar Respuesta Automática',
        'Filter for Auto Responses' => 'Filtro para Respuestas Automáticas',
        'Filter for auto responses' => 'Filtro para respuestas automáticas',
        'Response' => 'Respuesta',
        'Auto response from' => 'Respuesta automática de',
        'Reference' => 'Referencia',
        'To get the first 20 character of the subject.' => 'Para obtener los primeros 20 caracteres del asunto.',
        'To get the first 5 lines of the email.' => 'Para obtener las primeras 5 líneas del correo.',
        'To get the name of the ticket\'s customer user (if given).' => 'Para obtener el nombre del usuario del cliente (si se asignó).',
        'To get the article attribute' => 'Para obtener el atributo del artículo',
        'Options of the current customer user data' => 'Opciones para los datos del cliente actual',
        'Ticket owner options' => 'Opciones para el propietario del ticket',
        'Ticket responsible options' => 'Opciones para el responsable del ticket',
        'Options of the current user who requested this action' => 'Opciones del usuario actual, quien solicitó esta acción',
        'Options of the ticket data' => 'Opciones de los datos del ticket',
        'Options of ticket dynamic fields internal key values' => 'Opciones de los valores de las claves internas de los campos dinámicos de los tickets',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opciones de los valores mostrados de los campos dinámicos de los tickets, útil para los campos desplegables y de selección múltiple',
        'Example response' => 'Respuesta de ejemplo',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestión de Servicio en la Nube',
        'Support Data Collector' => 'Recolector de datos de soporte',
        'Support data collector' => 'Recolector de datos de soporte',
        'Hint' => 'Consejo',
        'Currently support data is only shown in this system.' => 'Actualmente los datos de soporte sólo son mostrados en este sistema.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            'A veces se recomienda enviar estos datos al equipo de OTOBO para obtener un mejor apoyo.',
        'Configuration' => 'Configuración',
        'Send support data' => 'Enviar datos de soporte',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            'Esto permitirá que el sistema envíe información adicional de datos de apoyo al equipo de OTOBO.',
        'Update' => 'Actualizar',
        'System Registration' => 'Registro del sistema',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para habilitar el envío de datos, registre su sistema con el equipo de OTOBO o actualice la información de registro de su sistema (asegúrese de activar la opción "enviar datos de soporte")',
        'Register this System' => 'Registrar este sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'El registro no está disponible para su sistema. Por favor revise su configuración.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            'El registro del sistema es un servicio del equipo de OTOBO, ¡que ofrece muchas ventajas!',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Por favor tenga en cuenta que el uso de servicios en la nube de OTOBO requiere que el sistema esté registrado.',
        'Register this system' => 'Registrar este sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Aquí puede configurar los servicios en la nube disponibles que se comunican de forma segura con %s.',
        'Available Cloud Services' => 'Servicios en la nube disponibles',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Bitácora de comunicación',
        'Time Range' => 'Rango de tiempo',
        'Show only communication logs created in specific time range.' =>
            'Mostrar solo los registros de comunicación creados en un rango de tiempo específico.',
        'Filter for Communications' => 'Filtro para comunicaciones',
        'Filter for communications' => 'Filtro para comunicaciones',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'En esta pantalla puede ver una descripción general de las comunicaciones entrantes y salientes.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Puede cambiar el orden de las columnas haciendo clic en el encabezado de la columna.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Si hace clic en las diferentes entradas, será redirigido a una pantalla detallada sobre el mensaje.',
        'Status for: %s' => 'Estado de: %s',
        'Failing accounts' => 'Cuentas con fallos',
        'Some account problems' => 'Algunos problemas con las cuentas',
        'No account problems' => 'Ningún problema con las cuentas',
        'No account activity' => 'No hay actividad en las cuentas',
        'Number of accounts with problems: %s' => 'Número de cuentas con problemas: %s',
        'Number of accounts with warnings: %s' => 'Número de cuentas con advertencias: %s',
        'Failing communications' => 'Comunicaciones fallidas',
        'No communication problems' => 'Nungún problema con las comunicaciones',
        'No communication logs' => 'No hay registros de comunicación',
        'Number of reported problems: %s' => 'Número de problemas reportados: %s',
        'Open communications' => 'Comunicaciones abiertas',
        'No active communications' => 'No existen comunicaciones activas',
        'Number of open communications: %s' => 'Número de comunicaciones abiertas: %s',
        'Average processing time' => 'Tiempo promedio de procesamiento',
        'List of communications (%s)' => 'Lista de comunicaciones (%s)',
        'Settings' => 'Configuraciones',
        'Entries per page' => 'Entradas por página',
        'No communications found.' => 'No se encontraron comunicaciones.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Estado de la Cuenta',
        'Back to overview' => 'Regresar a la vista general',
        'Filter for Accounts' => 'Filtro para Acciones',
        'Filter for accounts' => 'Filtro para cuentas',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Puede cambiar el orden de esas columnas haciendo clic en el encabezado de la columna.',
        'Account status for: %s' => 'Estado de la cuenta para: %s',
        'Status' => 'Estado',
        'Account' => 'Cuenta',
        'Edit' => 'Editar',
        'No accounts found.' => 'No se encontraron cuentas.',
        'Communication Log Details (%s)' => 'Detalles del registro de comunicación (%s)',
        'Direction' => 'Dirección',
        'Start Time' => 'Hora de inicio',
        'End Time' => 'Hora de finalización',
        'No communication log entries found.' => 'No se encontraron entradas de registro de comunicación.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Duración',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioridad',
        'Module' => 'Módulo',
        'Information' => 'Información',
        'No log entries found.' => 'No se encontraron entradas de registro.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Vista detallada para %s la comunicación iniciada a las %s',
        'Filter for Log Entries' => 'Filtro para entradas de registro',
        'Filter for log entries' => 'Filtrar por entradas de registro',
        'Show only entries with specific priority and higher:' => 'Mostrar solo entradas con un prioridad en específico y mas altas:',
        'Communication Log Overview (%s)' => 'Resumen de registro de comunicación (%s)',
        'No communication objects found.' => 'No se encontraron objetos de comunicación.',
        'Communication Log Details' => 'Detalles del registro de comunicación',
        'Please select an entry from the list.' => 'Por favor seleccione una entrada de la lista.',

        # Template: AdminContactWD
        'Contact with data management' => 'Contacto con la gestión de datos',
        'Contact with data' => 'Contacto con datos',
        'Add contact with data' => 'Añadir contacto con datos',
        'Edit contact with data' => 'Editar contacto con los datos',
        'Back to search results' => 'Regresar a los resultados de búsqueda',
        'Select' => 'Seleccionar',
        'Search' => 'Buscar',
        'Wildcards like \'*\' are allowed.' => 'Están permitidos comodines como \'*\'.',
        'Please enter a search term to look for contacts with data.' => 'Introduzca un término de búsqueda para buscar contactos con datos.',
        'Valid' => 'Válido',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gestión de Clientes',
        'Add Customer' => 'Añadir Cliente',
        'Edit Customer' => 'Modificar Cliente',
        'List (only %s shown - more available)' => 'Lista (solo el %s es mostrado - mas disponible)',
        'total' => 'total',
        'Please enter a search term to look for customers.' => 'Por favor, introduzca un parámetro de búsqueda para buscar clientes.',
        'Customer ID' => 'ID del Cliente',
        'Please note' => 'Por favor tome en cuenta',
        'This customer backend is read only!' => 'Este backend cliente es de solo lectura!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Gestionar Relaciones Cliente-Grupo',
        'Notice' => 'Aviso',
        'This feature is disabled!' => '¡Esta característica está deshabilitada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilice esta función únicamente si desea definir permisos de grupo para los clientes.',
        'Enable it here!' => '¡Habilítelo aquí!',
        'Edit Customer Default Groups' => 'Modificar los grupos por defecto de los clientes',
        'These groups are automatically assigned to all customers.' => 'Estos grupos se asignan automáticamente a todos los clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Es posible gestionar estos grupos por medio de la configuración "CustomerGroupCompanyAlwaysGroups".',
        'Filter for Groups' => 'Filtro para Grupos',
        'Select the customer:group permissions.' => 'Seleccione los permisos cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Si nada se selecciona, no habrá permisos para este grupo y los tickets no estarán disponibles para el cliente.',
        'Search Results' => 'Resultado de la búsqueda',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'Change Group Relations for Customer' => 'Modificar las Relaciones de Grupo de los Clientes',
        'Change Customer Relations for Group' => 'Modificar las Relaciones de Cliente de los Grupos',
        'Toggle %s Permission for all' => 'Activar permiso %s para todos',
        'Toggle %s permission for %s' => 'Activar permiso %s para %s',
        'Customer Default Groups:' => 'Grupos por defecto de los clientes:',
        'No changes can be made to these groups.' => 'Estos grupos no se pueden modificar.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Acceso de sólo lectura a los tickets de este grupo/fila.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acceso completo de lectura y escritura a los tickets de este grupo/fila.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gestión de Usuarios del Cliente',
        'Add Customer User' => 'Agregar Usuario del Cliente',
        'Edit Customer User' => 'Editar Usuario del Cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Los usuarios del cliente necesitan tener un historial de cliente e iniciar sesión por medio del panel de cliente.',
        'List (%s total)' => 'Lista (%s total)',
        'Username' => 'Nombre de Usuario',
        'Email' => 'Correo electrónico',
        'Last Login' => 'Último inicio de sesión',
        'Login as' => 'Iniciar sesión como',
        'Switch to customer' => 'Cambiar a cliente',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '¡Este backend del cliente es de solo lectura, pero las preferencias del usuario pueden ser cambiadas!',
        'This field is required and needs to be a valid email address.' =>
            'Este es un campo obligatorio y tiene que ser una dirección de correo electrónico válida.',
        'This email address is not allowed due to the system configuration.' =>
            'Esta dirección de correo electrónico no está permitida, debido a la configuración del sistema.',
        'This email address failed MX check.' => 'Esta dirección de correo electrónico falló la verificación MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema con el DNS. Por favor, verifique su configuración y el registro de errores.',
        'The syntax of this email address is incorrect.' => 'La sintáxis de esta dirección de correo electrónico es incorrecta.',
        'This CustomerID is invalid.' => 'El CustomerID es inválido.',
        'Effective Permissions for Customer User' => 'Permisos Efectivos para el Usuario Cliente',
        'Group Permissions' => 'Permisos de Grupo',
        'This customer user has no group permissions.' => 'Este usuario cliente no tiene permisos grupales.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'La tabla anterior muestra los permisos de grupo efectivos para el usuario del cliente. La matriz tiene en cuenta todos los permisos heredados (por ejemplo, a través de grupos de clientes). Nota: La tabla no considera los cambios realizados en este formulario sin enviarlo.',
        'Customer Access' => 'Acceso a Clientes',
        'Customer' => 'Cliente',
        'This customer user has no customer access.' => 'Este usuario cliente no tiene acceso a los clientes.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'La tabla anterior muestra el acceso otorgado para los usuarios del cliente por contexto de permiso. La matriz tiene en cuenta todos los accesos heredados (por ejemplo, a través de grupos de clientes). Nota: La tabla no considera los cambios realizados en este formulario sin enviarlo.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Gestionar Relaciones Cliente Usuario-Cliente',
        'Select the customer user:customer relations.' => 'Seleccionar las relaciones cliente usuario:cliente.',
        'Customer Users' => 'Usuarios del Cliente',
        'Change Customer Relations for Customer User' => 'Cambiar la Relaciones Cliente Usuario Cliente',
        'Change Customer User Relations for Customer' => 'Cambiar la Relaciones Usuario Cliente para el Cliente',
        'Toggle active state for all' => 'Habilitar estado activo para todos',
        'Active' => 'Activo',
        'Toggle active state for %s' => 'Habilitar estado activo para %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Gestionar Relaciones Usuario de Cliente-Relaciones de Grupo',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Utiliza esté grupo si buscas definir permisos de grupo para los usuarios de los clientes.',
        'Edit Customer User Default Groups' => 'Editar Grupos Predeterminados del Usuario del Cliente',
        'These groups are automatically assigned to all customer users.' =>
            'Estos grupos se asignan automáticamente a todos los usuarios del clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Es posible gestionar estos grupos por medio de la configuración "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtro para grupos',
        'Select the customer user - group permissions.' => 'Selecciona el usuario del cliente - grupo de permisos.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Si nada se selecciona, no habrá permisos para este grupo (los tickets no estarán disponibles para los usuarios del cliente).',
        'Customer User Default Groups:' => 'Grupos por default en los usuarios del cliente:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Administrar las relaciones Usuarios de cliente-Servicios',
        'Edit default services' => 'Modificar los servicios por defecto',
        'Filter for Services' => 'Filtro para Servicios',
        'Filter for services' => 'Filtro para servicios',
        'Services' => 'Servicios',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gestión de Campos Dinámicos',
        'Add new field for object' => 'Agregar nuevo campo para el objeto',
        'Filter for Dynamic Fields' => 'Filtro para Campos Dinámcos',
        'Filter for dynamic fields' => 'Filtro para campos dinámicos',
        'New OTOBO Community  Fields' => 'Nuevos campos comunitarios de OTOBO',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '¿Desea beneficiarse de otros tipos de campos dinámicos? Tiene acceso completo a los siguientes tipos de campo:',
        'Database' => 'Base de Datos',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Utilice bases de datos externas como fuentes de datos configurables para este campo dinámico.',
        'Web service' => 'Servicio web',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Se pueden configurar servicios web externos como fuentes de datos para este campo dinámico.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Esta función permite añadir contactos (múltiples) con datos a los tickets.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para añadir un nuevo campo, seleccione el tipo de campo de la lista de objetos, el objeto define los limites del campo y no puede ser cambiado después de la creación del campo.',
        'Dynamic Fields List' => 'Lista de Campos Dinámicos',
        'Dynamic fields per page' => 'Campos dinámicos por página',
        'Label' => 'Etiqueta',
        'Order' => 'Orden',
        'Object' => 'Objeto',
        'Delete this field' => 'Eliminar este campo',

        # Template: AdminDynamicFieldAdvanced
        'Import / Export' => 'Importación / Exportación',
        'Here you can upload a configuration file to import dynamic fields to your system. The file needs to be in .yml format as exported by dynamic field management module.' =>
            'Aquí puede subir un archivo de configuración para importar campos dinámicos a su sistema. El archivo debe estar en formato .yml, tal y como lo exporta el módulo de gestión de campos dinámicos.',
        'DynamicFields Import' => 'Importación de DynamicFields',
        'DynamicFields Export' => 'Importación de DynamicFields',
        'Dynamic Fields Screens' => 'Pantallas de campos dinámicos',
        'Here you can manage the dynamic fields in the respective screens.' =>
            'Aquí puede gestionar los campos dinámicos en las respectivas pantallas.',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Campos Dinámicos',
        'Go back to overview' => 'Regresar al resumen',
        'General' => 'General',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo es obligatorio, y el valor debe ser solo de caracteres alfabéticos y numéricos.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Debe ser único y sólo acepta caracteres alfabéticos y numéricos.',
        'Changing this value will require manual changes in the system.' =>
            'Cambiar este valor requerirá cambios manuales en el sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Éste es el nombre a ser mostrado en las pantallas en las que el campo esté activo.',
        'Field order' => 'Orden del campo',
        'This field is required and must be numeric.' => 'Este campo es obligatorio y debe ser numérico.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Éste es el orden en que se mostrará este campo en las pantallas en las que esté activo.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'No es posible invalidar esta entrada, todos los ajustes de configuración tienen que ser cambiados de antemano.',
        'Field type' => 'Typo de campo',
        'Object type' => 'Tipo de objeto',
        'Internal field' => 'Campo interno',
        'This field is protected and can\'t be deleted.' => 'Este campo está protegido y no puede ser eliminado.',
        'This dynamic field is used in the following config settings:' =>
            'Este campo dinámico se utiliza en los siguientes ajustes de configuración:',
        'Field Settings' => 'Configuración del Campo',
        'Default value' => 'Valor por defecto',
        'This is the default value for this field.' => 'Este es el valor predefinido para este campo.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => 'Añadir o editar contactos',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            'Para añadir contactos a este campo, rellene toda la información necesaria y guárdela.',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            'Haga clic en el nombre del campo desde la vista general para editarlo y busque la acción correspondiente en la barra lateral o en el menú \'Tickets.',
        'Name Field' => 'Campo nombre',
        'ValidID Field' => 'Campo ValidID',
        'Other Fields' => 'Otros campos',
        'Key' => 'Clave',
        'Value' => 'Valor',
        'Remove value' => 'Eliminar valor',
        'Add Field' => 'Campo agregar',
        'Add value' => 'Agregar valor',
        'These are the possible data attributes for contacts.' => 'Estos son los posibles atributos de datos para los contactos.',
        'Mandatory fields' => 'Campos obligatorios',
        'Comma separated list of mandatory keys (optional). Keys \'Name\' and \'ValidID\' are always mandatory and doesn\'t have to be listed here.' =>
            'Lista separada por comas de las claves obligatorias (opcional). Las claves \'Nombre\' y \'ValidID\' son siempre obligatorias y no tienen que ser listadas aquí.',
        'Sorted fields' => 'Campos ordenados',
        'Comma separated list of keys in sort order (optional). Keys listed here come first, all remaining fields afterwards and sorted alphabetically.' =>
            'Lista de claves separadas por comas en orden de clasificación (opcional). Las claves listadas aquí vienen primero, todos los campos restantes después y ordenados alfabéticamente.',
        'Searchable fields' => 'Campos de búsqueda',
        'Comma separated list of searchable keys (optional). Key \'Name\' is always searchable and doesn\'t have to be listed here.' =>
            'Lista separada por comas de las claves que se pueden buscar (opcional). La clave \'Nombre\' siempre se puede buscar y no tiene que aparecer en esta lista.',
        'Translatable values' => 'Valores traducibles',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Si activa esta opción los valores se traducirán al idioma definido por el usuario.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Necesita añadir las traducciones manualmente en los ficheros de traducción de idiomas.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Valores posibles',
        'Datatype' => 'Tipo de dato',
        'Filter' => 'Filtro',
        'Searchfield' => 'Campo de búsqueda',
        'Listfield' => 'Campo de la lista',
        'Show link' => 'Mostrar enlace',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aquí puede indicar un enlace HTTP opcional para el valor del campo en las pantallas de Vista general y Ampliación.',
        'Example' => 'Ejemplo',
        'Link for preview' => 'Enlace para muestra',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Si se rellena, esta URL se utilizará para una vista previa que se mostrará cuando se pase el ratón por este enlace en el zoom del ticket. Tenga en cuenta que para que esto funcione, el campo de la URL normal de arriba también debe rellenarse.',
        'SID' => 'SID',
        'Driver' => 'Controlador',
        'Server' => 'Servidor',
        'Port' => 'Puerto',
        'Table / View' => 'Tabla / Vista',
        'User' => 'Usuario',
        'Password' => 'Contraseña',
        'Identifier' => 'Identificador',
        'Must be unique column from the table entered in Table/View.' => 'Debe ser una columna única de la tabla introducida en la Tabla/Vista.',
        'Multiselect' => 'Selección múltiple',
        'CacheTTL' => 'Cache TTL',
        'Searchprefix' => 'Prefijo de búsqueda',
        'Searchsuffix' => 'Sufijo de búsqueda',
        'Result Limit' => 'Límite de resultados',
        'Case Sensitive' => 'Caso Sensible',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferencia de fechas predeterminada',
        'This field must be numeric.' => 'Este campo debe ser numérico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'La diferencia de AHORA (en segundos) para calcular el valor predeterminado del campo (p. ej. 3600 o -60).',
        'Define years period' => 'Años en el futuro',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Active esta característica para definir un rango fijo de años (en el futuro y en el pasado) para mostrar en la parte del campo año.',
        'Years in the past' => 'Años en el pasado',
        'Years in the past to display (default: 5 years).' => 'Años en el pasado a mostrar (valor predeterminado: 5 años).',
        'Years in the future' => 'Años en el futuro',
        'Years in the future to display (default: 5 years).' => 'Años en el futuro a mostrar (valor predeterminado: 5 años).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Si los caracteres especiales (&, @, :, /, etc.) no deben codificarse, utilice el filtro \'url\' en lugar de \'uri\'.',
        'Restrict entering of dates' => 'Restringir el ingreso de fechas',
        'Here you can restrict the entering of dates of tickets.' => 'Aquí puede restringir el ingreso de fechas para los tickets.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Agregar Valor',
        'Add empty value' => 'Agregar un valor vacío',
        'Activate this option to create an empty selectable value.' => 'Active esta opción para crear un valor seleccionable vacío.',
        'Tree View' => 'Viste de Árbol',
        'Activate this option to display values as a tree.' => 'Active esta opción para mostrar los valores como un árbol.',

        # Template: AdminDynamicFieldImportExport
        '%s - %s' => '%s - %s',
        'Select the items you want to ' => 'Seleccione los elementos que desea ',
        'Select the desired elements and confirm the import with \'import\'.' =>
            'Seleccione los elementos deseados y confirme la importación con "importar".',
        'Here you can export a configuration file of dynamic fields and dynamic field screens to import these on another system. The configuration file is exported in yml format.' =>
            'Aquí puede exportar un archivo de configuración de campos dinámicos y pantallas de campos dinámicos para importarlos en otro sistema. El archivo de configuración se exporta en formato yml.',
        'The following dynamic fields can not be imported because of an invalid backend.' =>
            'Los siguientes campos dinámicos no pueden ser importados debido a un backend inválido.',
        'Toggle all available elements' => 'Alternar todos los elementos disponibles',
        'Fields' => 'Campos',
        'Screens' => 'Pantallas',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => 'Gestión de Campos Dinámicos <-> Pantallas',
        'Overview' => 'Resumen',
        'Default Columns Screens' => 'Columnas por defecto de Pantallas',
        'Add DynamicField' => 'Añadir DynamicField',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar elementos a esta Pantalla/Campo arrastrando los elementos con el ratón desde la lista de la izquierda a la de la derecha.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'También es posible ordenar los elementos de la lista arrastrando y soltando los elementos .',
        'Filter available elements' => 'Elementos filtrantes disponibles',
        'selected to available elements' => 'seleccionados a los elementos disponibles',
        'Available Elements' => 'Elementos disponibles',
        'Filter disabled elements' => 'Elementos filtrantes desactivados',
        'selected to disabled elements' => 'seleccionados a elementos deshabilitados',
        'Toggle all disabled elements' => 'Conmutar todos los elementos desactivados',
        'Disabled Elements' => 'Elementos desactivados',
        'Filter assigned elements' => 'Elementos filtrantes asignados',
        'selected to assigned elements' => 'seleccionados a los elementos asignados',
        'Toggle all assigned elements' => 'Conmutar todos los elementos asignados',
        'Assigned Elements' => 'Elementos asignados',
        'Filter assigned required elements' => 'Filtrar los elementos necesarios asignados',
        'selected to assigned required elements' => 'seleccionados para asignar los elementos necesarios',
        'Toggle all assigned required elements' => 'Alternar todos los elementos asignados requeridos',
        'Assigned Required Elements' => 'Elementos requeridos asignados',
        'Reset' => 'Resetear',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de renglones',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Indica la altura (en líneas) de este campo en el modo de edición.',
        'Number of cols' => 'Número de columnas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Indica el ancho (en caracteres) para este campo en el modo de edición.',
        'Check RegEx' => 'Verificar RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Aquí puede especificar una expresión regular para comprobar el valor. El regex se ejecutara con los modificadores xms.',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'RegEx inválido',
        'Error Message' => 'Mensaje de error',
        'Add RegEx' => 'Agregar RedEx',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Plantilla',
        'Style' => 'Estilo',
        'bold' => 'negrita',
        'italic' => 'itálica',
        'underline' => 'subrayar',
        'Font style of the label.' => 'Estilo de fuente de la etiqueta.',
        'Size' => 'Tamaño',
        'Font size of the label.' => 'Tamaño de fuente de la etiqueta.',
        'Color in hex.' => 'Color en hexadecimal.',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Esta campo es requerido',
        'The web service to be executed for possible values.' => 'El servicio web a ejecutar para posibles valores.',
        'Invoker' => 'Invocador',
        'The invoker to be used to perform requests (invoker needs to be of type \'Generic::PassThrough\').' =>
            'El invocador que se utilizará para realizar las solicitudes (el invocador debe ser de tipo \'Generic::PassThrough\').',
        'Activate this option to allow multiselect on results.' => 'Active esta opción para permitir la selección múltiple de resultados.',
        'Cache TTL' => 'Cache TTL',
        'Cache time to live (in minutes), to save the retrieved possible values.' =>
            'Almacene el tiempo de vida en caché (en minutos), para guardar los posibles valores recuperados.',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens. Optional HTTP link works only for single-select fields.' =>
            'Aquí puede especificar un enlace HTTP opcional para el valor del campo en las pantallas de Panorama y Zoom. El enlace HTTP opcional sólo funciona para los campos de selección única.',

        # Template: AdminEmail
        'Admin Message' => 'Mensaje del Administrador',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Con este módulo, los administradores pueden enviar mensajes a los agentes, a los miembros de un grupo o agentes con algún tipo de rol.',
        'Create Administrative Message' => 'Crear un Mmensaje Administrativo',
        'Your message was sent to' => 'Mensaje enviado a',
        'From' => 'De',
        'Send message to users' => 'Enviar mensaje a los usuarios',
        'Send message to group members' => 'Enviar mensaje a los miembros del grupo',
        'Group members need to have permission' => 'Los miembros del grupo necesitan tener permiso',
        'Send message to role members' => 'Enviar mensaje a los miembros del rol',
        'Also send to customers in groups' => 'También enviar a los clientes de los grupos',
        'Body' => 'Cuerpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Gestión de Trabajos para el Agente Genérico',
        'Edit Job' => 'Editar tarea',
        'Add Job' => 'Agregar Tarea',
        'Run Job' => 'Ejecutar Tarea',
        'Filter for Jobs' => 'Filtro para Tareas',
        'Filter for jobs' => 'Filtro para tareas',
        'Last run' => 'Última ejecución',
        'Run Now!' => '¡Ejecutar ahora!',
        'Delete this task' => 'Eliminar esta tarea',
        'Run this task' => 'Ejecutar esta tarea',
        'Job Settings' => 'Configuraciones de la Tarea',
        'Job name' => 'Nombre de la tarea',
        'The name you entered already exists.' => 'El nombre introdujo ya existe.',
        'Automatic Execution (Multiple Tickets)' => 'Ejecución Automática (Múltiples Tickets)',
        'Execution Schedule' => 'Agenda de Ejecución',
        'Schedule minutes' => 'Fijar minutos',
        'Schedule hours' => 'Fijar horas',
        'Schedule days' => 'Fijar días',
        'Automatic execution values are in the system timezone.' => 'Los valores de ejecución automática están en la zona horaria del sistema.',
        'Currently this generic agent job will not run automatically.' =>
            'Actualmente esta tarea del agente genérico no se ejecutará automáticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '¡Para habilitar la ejecución automática, seleccione al menos un valor de minutos, horas y días!',
        'Event Based Execution (Single Ticket)' => 'Ejecución Basada en Eventos (Ticket Individual)',
        'Event Triggers' => 'Disparadores de Eventos',
        'List of all configured events' => 'Lista de todos los eventos configurados',
        'Delete this event' => 'Eliminar este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Puede definir eventos de un ticket, de forma adicional o alternativa a un periodo de ejecución, que disparararán este trabajo.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Si se dispara un evento de ticket, se aplicará el filtro de tickets para comprobar si el ticket coincide. Sólo entonces se ejecuta el trabajo sobre ese ticket.',
        'Do you really want to delete this event trigger?' => '¿Realmente desea eliminar este disparador de evento?',
        'Add Event Trigger' => 'Agregar Disparador de Evento',
        'To add a new event select the event object and event name' => 'Para agregar un nuevo evento, seleccione el objeto del evento y el nombre del evento',
        'Select Tickets' => 'Seleccionar Tickets',
        '(e. g. 10*5155 or 105658*)' => '(ej: 10*5155 o 105658*)',
        '(e. g. 234321)' => '(ej: 234321)',
        'Customer user ID' => 'ID de usuario cliente',
        '(e. g. U5150)' => '(ej: U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Búsqueda en todo el texto del artículo (por ejemplo: "Mar*in" o "Baue*").',
        'To' => 'Para',
        'Cc' => 'Con Copia',
        'Service' => 'Servicio',
        'Service Level Agreement' => 'Acuerdo de Nivel de Servicio',
        'Queue' => 'Fila',
        'State' => 'Estado',
        'Agent' => 'Agente',
        'Owner' => 'Propietario',
        'Responsible' => 'Responsable',
        'Ticket lock' => 'Bloqueo de ticket',
        'Dynamic fields' => 'Campos Dinámicos',
        'Add dynamic field' => 'Agregar campo dinámico',
        'Create times' => 'Tiempos de creación',
        'No create time settings.' => 'No existen configuraciones para tiempo de creación.',
        'Ticket created' => 'Ticket creado',
        'Ticket created between' => 'Ticket creado entre',
        'and' => 'y',
        'Last changed times' => 'Últimas veces que se cambió',
        'No last changed time settings.' => 'No hay configuración para las últimas veces que se cambió.',
        'Ticket last changed' => 'Último cambio del ticket',
        'Ticket last changed between' => 'Últimos cambios del ticket entre',
        'Change times' => 'Tiempos en que se efectuaron los cambios',
        'No change time settings.' => 'Sin cambio de marca de tiempo.',
        'Ticket changed' => 'Ticket modificado',
        'Ticket changed between' => 'Ticket modificado entre',
        'Last close times' => 'Últimos tiempos de cierre',
        'No last close time settings.' => 'Sin configuración de hora de último cierre.',
        'Ticket last close' => 'Último cierre del Ticket',
        'Ticket last close between' => 'Último cierre del Ticket entre',
        'Close times' => 'Tiempos de cierre',
        'No close time settings.' => 'No existen configuraciones para tiempo de cierre.',
        'Ticket closed' => 'Ticket cerrado',
        'Ticket closed between' => 'Ticket cerrado entre',
        'Pending times' => 'Tiempos de espera',
        'No pending time settings.' => 'No existen configuraciones para tiempo en espera.',
        'Ticket pending time reached' => 'El tiempo en espera del Ticket ha sido alcanzado',
        'Ticket pending time reached between' => 'El tiempo en espera del Ticket ha sido alcanzado entre',
        'Escalation times' => 'Tiempos para escalada',
        'No escalation time settings.' => 'No existen configuraciones de tiempo para escalada.',
        'Ticket escalation time reached' => 'El tiempo para escalada del ticket ha sido alcanzado',
        'Ticket escalation time reached between' => 'El tiempo para escalada del ticket ha sido alcanzado entre',
        'Escalation - first response time' => 'Escalada - tiempo de primera respuesta',
        'Ticket first response time reached' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado',
        'Ticket first response time reached between' => 'El tiempo para la primer respuesta del Ticket ha sido alcanzado entre',
        'Escalation - update time' => 'Escalada - tiempo de actualización',
        'Ticket update time reached' => 'El tiempo para la actualización del Ticket ha sido alcanzado',
        'Ticket update time reached between' => 'El tiempo para la actualización del Ticket ha sido alcanzado entre',
        'Escalation - solution time' => 'Escalada - tiempo de solución',
        'Ticket solution time reached' => 'El tiempo para la solución del Ticket ha sido alcanzado',
        'Ticket solution time reached between' => 'El tiempo para la solución del Ticket ha sido alcanzado entre',
        'Archive search option' => 'Opción de búsqueda en el archivo',
        'Update/Add Ticket Attributes' => 'Actualizar/Añadir Atributos del Ticket',
        'Set new service' => 'Establecer servicio nuevo',
        'Set new Service Level Agreement' => 'Establecer Acuerdo de Nivel de Servicio nuevo',
        'Set new priority' => 'Establecer prioridad nueva',
        'Set new queue' => 'Establecer fila nueva',
        'Set new state' => 'Establecer estado nuevo',
        'Pending date' => 'Fecha pendiente',
        'Set new agent' => 'Establecer agente nuevo',
        'new owner' => 'propietario nuevo',
        'new responsible' => 'nuevo responsable',
        'Set new ticket lock' => 'Establecer bloqueo de ticket nuevo',
        'New customer user ID' => 'Nuevo ID de usuario cliente',
        'New customer ID' => 'ID de cliente nuevo',
        'New title' => 'Título nuevo',
        'New type' => 'Tipo nuevo',
        'Archive selected tickets' => 'Tickets seleccionados del archivo',
        'Add Note' => 'Añadir Nota',
        'Visible for customer' => 'Visible para el cliente',
        'Time units' => 'Unidades de tiempo',
        'Execute Ticket Commands' => 'Ejecutar Comandos del Ticket',
        'Send agent/customer notifications on changes' => 'Enviar notificación de cambios al agente/cliente',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando se ejecutará. ARG[0] será el número del ticket y ARG[0] el identificador del ticket.',
        'Delete tickets' => 'Eliminar tickets',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Advertencia: ¡Todos los tickets afectados serán eliminados de la base de datos y no se podrá restaurar!',
        'Execute Custom Module' => 'Ejecutar Módulo Personalizado',
        'Param %s key' => 'Parámetro %s llave',
        'Param %s value' => 'Parámetro %s valor',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '¡%s Tickets afectados! ¿Qué desea hacer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Advertencia: ¡Eligió la opción ELIMINAR. ¡Todos los tickets eliminados se perderán!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Advertencia: ¡Hay %s tickets afectados pero sólo %s pueden ser modificados durante la ejecución de un trabajo!',
        'Affected Tickets' => 'Tickets Afectados',
        'Age' => 'Antigüedad',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Interfaz genérica de gestión de servicios web',
        'Web Service Management' => 'Gestión de Servicios Web',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Regresar al web service',
        'Clear' => 'Limpiar',
        'Do you really want to clear the debug log of this web service?' =>
            '¿Está usted seguro que desea limpiar el registro de depuración de este web service?',
        'Request List' => 'Lista de solicitudes',
        'Time' => 'Tiempo',
        'Communication ID' => 'ID de comunicación',
        'Remote IP' => 'IP Remota',
        'Loading' => 'Cargando',
        'Select a single request to see its details.' => 'Seleccione una solicitud para ver sus detalles.',
        'Filter by type' => 'Filtro por tipo',
        'Filter from' => 'Filtro desde',
        'Filter to' => 'Filtro hasta',
        'Filter by remote IP' => 'Filtro por IP remota',
        'Limit' => 'Límite',
        'Refresh' => 'Refrescar',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Agregar Manejo de Errores',
        'Edit ErrorHandling' => 'Editar manejo de errores',
        'Do you really want to delete this error handling module?' => '¿Realmente quiere remover este módulo de manejo de errores?',
        'All configuration data will be lost.' => 'Todos los datos de la configuración se perderán.',
        'General options' => 'Opciones generales',
        'The name can be used to distinguish different error handling configurations.' =>
            'El nombre puede ser utilizado para distinguir diferentes configuraciones de manejo de errores.',
        'Please provide a unique name for this web service.' => 'Por favor ingrese un nombre único para este servicio web.',
        'Error handling module backend' => 'Módulo de gestión de errores backend',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Este módulo backend de manejo de errores de OTOBO será llamado internamente para procesar el mecanismo de manejo de errores.',
        'Processing options' => 'Procesando opciones',
        'Configure filters to control error handling module execution.' =>
            'Configure los filtros para controlar la ejecución del módulo de gestión de errores.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Sólo las solicitudes que coincidan con todos los filtros configurados (si los hay) activarán la ejecución del módulo.',
        'Operation filter' => 'Filtro de operaciones',
        'Only execute error handling module for selected operations.' => 'Sólo ejecuta el módulo de tratamiento de errores para las operaciones seleccionadas.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Nota: La operación es indeterminada para los errores que se producen al recibir los datos de la solicitud. Los filtros que implican esta etapa de error no deben utilizar el filtro de operación.',
        'Invoker filter' => 'Filtro para invocador',
        'Only execute error handling module for selected invokers.' => 'Sólo ejecuta el módulo de manejo de errores para los invocadores seleccionados.',
        'Error message content filter' => 'Filtro para el contenido del mensaje de error',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Introduzca una expresión regular para restringir qué mensajes de error deben provocar la ejecución del módulo de gestión de errores.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'El asunto y los datos del mensaje de error (como se ve en la entrada de error del depurador) se considerarán para una coincidencia.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Ejemplo: Introduzca \'^.*401 Unauthorized.*\$\' para gestionar sólo los errores relacionados con la autenticación.',
        'Error stage filter' => 'Filtro de etapa de error',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Sólo ejecuta el módulo de tratamiento de errores en los errores que se producen durante las etapas de procesamiento específicas.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Ejemplo: Manejar sólo los errores en los que no se ha podido aplicar la asignación de datos de salida.',
        'Error code' => 'Código de error',
        'An error identifier for this error handling module.' => 'Un identificador de error para este módulo de manejo de errores.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Este identificador estará disponible en XSLT-Mapping y se mostrará en la salida del depurador.',
        'Error message' => 'Mensaje de error',
        'An error explanation for this error handling module.' => 'Una explicación de error para este módulo de manejo de errores.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Este mensaje estará disponible en XSLT-Mapping y se mostrará en la salida del depurador.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Define si el procesamiento debe detenerse después de la ejecución del módulo, omitiendo todos los módulos restantes o sólo los del mismo backend.',
        'Default behavior is to resume, processing the next module.' => 'El comportamiento por defecto es reanudar, procesando el siguiente módulo.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Este módulo permite configurar los reintentos programados para las solicitudes fallidas.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'El comportamiento por defecto de los servicios web de la interfaz genérica es enviar cada solicitud exactamente una vez y no reprogramar después de los errores.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Si se ejecuta más de un módulo capaz de programar un reintento para una solicitud individual, el módulo ejecutado en último lugar es el autoritario y determina si se programa un reintento.',
        'Request retry options' => 'Opciones de reintento de la petición',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Las opciones de reintento se aplican cuando las solicitudes provocan la ejecución del módulo de gestión de errores (en función de las opciones de procesamiento).',
        'Schedule retry' => 'Agendar reintento',
        'Should requests causing an error be triggered again at a later time?' =>
            '¿Las solicitudes que provocan un error deben activarse de nuevo en un momento posterior?',
        'Initial retry interval' => 'Intervalo de intento inicial',
        'Interval after which to trigger the first retry.' => 'Intervalo tras el cual se activa el primer reintento.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Nota: Este y todos los intervalos de reintentos posteriores se basan en el tiempo de ejecución del módulo de tratamiento de errores para la solicitud inicial.',
        'Factor for further retries' => 'Factor para siguientes teintentos',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Si una solicitud devuelve un error incluso después de un primer reintento, defina si los siguientes reintentos se activan utilizando el mismo intervalo o en intervalos crecientes.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Ejemplo: Si una solicitud se lanza inicialmente a las 10:00 con un intervalo inicial de \'1 minuto\' y un factor de reintento de \'2\', los reintentos se lanzarían a las 10:01 (1 minuto), 10:03 (2*1=2 minutos), 10:07 (2*2=4 minutos), 10:15 (2*4=8 minutos), ...',
        'Maximum retry interval' => 'Intervalo máximo de reintento',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Si se selecciona un factor de intervalo de reintento de \'1,5\' o \'2\', se pueden evitar intervalos indeseablemente largos definiendo el mayor intervalo permitido.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Los intervalos calculados para superar el intervalo máximo de reintentos se acortarán automáticamente en consecuencia.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Ejemplo: Si una solicitud se lanza inicialmente a las 10:00 con un intervalo inicial de \'1 minuto\', un factor de reintentos de \'2\' y un intervalo máximo de \'5 minutos\', los reintentos se lanzarían a las 10:01 (1 minuto), 10:03 (2 minutos), 10:07 (4 minutos), 10:12 (8=>5 minutos), 10:17, ...',
        'Maximum retry count' => 'Conteo máximo de reintentos',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Número máximo de reintentos antes de descartar una solicitud fallida, sin contar la solicitud inicial.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Ejemplo: Si una solicitud se lanza inicialmente a las 10:00 con un intervalo inicial de \'1 minuto\', un factor de reintentos de \'2\' y un recuento máximo de reintentos de \'2\', los reintentos se lanzarían sólo a las 10:01 y a las 10:02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Nota: Es posible que no se alcance el número máximo de reintentos si también se ha configurado un periodo máximo de reintentos y se ha alcanzado antes.',
        'This field must be empty or contain a positive number.' => 'Este campo debe estar vacío o contener un numero positivo.',
        'Maximum retry period' => 'Periodo máximo de reintentas',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Periodo máximo de tiempo para reintentos de solicitudes fallidas antes de que sean descartadas (basado en el tiempo de ejecución del módulo de gestión de errores para la solicitud inicial).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Los reintentos que normalmente se activarían una vez transcurrido el periodo máximo (según el cálculo del intervalo de reintentos) se activarán automáticamente exactamente en el periodo máximo.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Ejemplo: Si una petición se lanza inicialmente a las 10:00 con un intervalo inicial de \'1 minuto\', un factor de reintento de \'2\' y un periodo máximo de reintento de \'30 minutos\', los reintentos se lanzarían a las 10:01, 10:03, 10:07, 10:15 y finalmente a las 10:31=>10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Nota: Es posible que no se alcance el periodo máximo de reintentos si también se ha configurado un recuento máximo de reintentos y se ha alcanzado antes.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Agregar Invocador',
        'Edit Invoker' => 'Editar Invocador',
        'Do you really want to delete this invoker?' => 'Realmente desea eliminar este invocador?',
        'Invoker Details' => 'Detalles del invocador',
        'The name is typically used to call up an operation of a remote web service.' =>
            'El nombre que se usa normalmente para llamar una operación de un web service remoto.',
        'Invoker backend' => 'Backend del invocador',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Este módulo OTOBO invoker backend será llamado para preparar los datos que se enviarán al sistema remoto, y para procesar sus datos de respuesta.',
        'Mapping for outgoing request data' => 'Mapeo para los datos de la solicitud saliente',
        'Configure' => 'Configurar',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Los datos del invocador de OTOBO serán procesador por este mapeo, para transformarlos al tipo de datos que el sistema remoto espera.',
        'Mapping for incoming response data' => 'Mapeo para los datos de la respuesta entrante',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Los datos de la respuesta serán procesados por este mapeo, para transformarlos al tipo de datos que el invocador de OTOBO espera.',
        'Asynchronous' => 'Asíncrono',
        'Condition' => 'Condición',
        'Edit this event' => 'Editar este evento',
        'This invoker will be triggered by the configured events.' => 'Este invocador será disparado por los eventos configurados.',
        'Add Event' => 'Agregar Evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para añadir un nuevo evento debe seleccionar el objeto evento y el nombre del evento y después pulsar el botón "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Los disparadores de evento asíncronos son manejados por el Demonio Planificador de OTOBO en segundo plano (recomendado).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Los disparadores de eventos asíncronos serían procesados directamente durante la solicitud web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Configuración de eventos del invocador de la interfaz genérica para el servicio web %s',
        'Go back to' => 'Regresar a',
        'Delete all conditions' => 'Eliminar todas las condiciones',
        'Do you really want to delete all the conditions for this event?' =>
            '¿Realmente desea eliminar todas las condiciones para este evento?',
        'General Settings' => 'Opciones Generales',
        'Event type' => 'Tipo de evento',
        'Conditions' => 'Condiciones',
        'Conditions can only operate on non-empty fields.' => 'Las condiciones solamente pueden operar en campos no-vacíos.',
        'Type of Linking between Conditions' => 'Tipo de Vinculación entre las Condiciones',
        'Remove this Condition' => 'Remover esta Condición',
        'Type of Linking' => 'Tipo de Vinculación',
        'Add a new Field' => 'Agregar un nuevo Campo',
        'Remove this Field' => 'Eliminar este Campo',
        'And can\'t be repeated on the same condition.' => 'Y no se puede repetir en la misma condición.',
        'Add New Condition' => 'Añadir Nueva Condición',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mapeo Simple',
        'Default rule for unmapped keys' => 'Regla predeterminada para llaves sin mapear',
        'This rule will apply for all keys with no mapping rule.' => 'Esta regla se aplicara para todas las llaves sin reglas de mapeo.',
        'Default rule for unmapped values' => 'Regla predeterminada para valores sin mapear',
        'This rule will apply for all values with no mapping rule.' => 'Esta regla se aplicará a todos los valores sin regla de asignación.',
        'New key map' => 'Nueva llave de mapa',
        'Add key mapping' => 'Añadir mapeo de llaves',
        'Mapping for Key ' => 'Mapeo para la llave ',
        'Remove key mapping' => 'Remover mapeo de llave',
        'Key mapping' => 'Mapeo de llave',
        'Map key' => 'Mapear llave',
        'matching the' => 'que coincide con',
        'to new key' => 'a la nueva llave',
        'Value mapping' => 'Mapeo de valor',
        'Map value' => 'Mapeo de valor',
        'to new value' => 'al nuevo valor',
        'Remove value mapping' => 'Remover mapeo de valores',
        'New value map' => 'Agregar un mapeo de valor',
        'Add value mapping' => 'Agregar un mapeo de valor',
        'Do you really want to delete this key mapping?' => '¿Realmente quieres eliminar esta asignación de teclas?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Atajos Generales',
        'MacOS Shortcuts' => 'Atajos MacOS',
        'Comment code' => 'Comentar código',
        'Uncomment code' => 'Descomentar código',
        'Auto format code' => 'Auto formato para el código',
        'Expand/Collapse code block' => 'Expandir/Colapsar bloque de código',
        'Find' => 'Buscar',
        'Find next' => 'Buscar siguiente',
        'Find previous' => 'Buscar hacia atrás',
        'Find and replace' => 'Buscar y reemplazar',
        'Find and replace all' => 'Buscar y reemplazar todo',
        'XSLT Mapping' => 'Mapeo XSLT',
        'XSLT stylesheet' => 'Hoja de estilos XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'Los datos introducidos no son una hoja de estilo XSLT válida.',
        'Here you can add or modify your XSLT mapping code.' => 'Aquí puede añadir o modificar su código de mapeo XSLT.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'El campo de edición permite utilizar diferentes funciones, como el formateo automático, el cambio de tamaño de la ventana y el completamiento de etiquetas y corchetes.',
        'Data includes' => 'Los datos incluyen',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Seleccione uno o más conjuntos de datos creados en etapas anteriores de solicitud/respuesta para incluirlos en los datos mapeables.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Estos conjuntos aparecerán en la estructura de datos en \'/DataInclude/<DataSetName>\' (véase la salida del depurador de las solicitudes reales para más detalles).',
        'Data key regex filters (before mapping)' => 'Filtros regex de claves de datos (antes de la asignación)',
        'Data key regex filters (after mapping)' => 'Filtros regex de claves de datos (después de la asignación)',
        'Regular expressions' => 'Expresiones regulares',
        'Replace' => 'Reemplazar',
        'Remove regex' => 'Remover expresión regular',
        'Add regex' => 'Añadir expresión regular',
        'These filters can be used to transform keys using regular expressions.' =>
            'Estos filtros pueden utilizarse para transformar las claves mediante expresiones regulares.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'La estructura de datos se recorrerá recursivamente y todas las expresiones regulares configuradas se aplicarán a todas las claves.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Los casos de uso son, por ejemplo, la eliminación de prefijos de clave no deseados o la corrección de claves no válidas como nombres de elementos XML.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Ejemplo 1: Buscar= \'^jira:\' / Replace = \'\' convierte \'jira:element\' en \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Ejemplo 2: Buscar = \'^\' / Reemplazar = \'_\' convierte \'16x16\' en \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Ejemplo 3: Buscar = \'^(?<número>\d+) (?<texto>.+?)\$\' / Reemplazar = \'_\$+{texto}_\$+{número}\' convierte \'16 elementname\' en \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Para obtener información sobre las expresiones regulares en Perl, consulte aquí:',
        'Perl regular expressions tutorial' => 'Tutorial de expresiones regulares en Perl',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Si se desean modificadores, deben especificarse dentro de las propias expresiones regulares.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Las expresiones regulares definidas aquí se aplicarán antes del mapeo XSLT.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Las expresiones regulares definidas aquí se aplicarán después del mapeo XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Añadir Operación',
        'Edit Operation' => 'Editar Operación',
        'Do you really want to delete this operation?' => 'Está seguro de eliminar esta operación?',
        'Operation Details' => 'Detalles del a operación',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'El nombre se utiliza normalmente para llamar a esta operación de servicio web desde un sistema remoto.',
        'Operation backend' => 'Operación backend',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo backend de la operación OTOBO será llamado internamente para procesar la solicitud, generando datos para la respuesta.',
        'Mapping for incoming request data' => 'Asignación de los datos de la solicitud entrante',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Los datos de la solicitud serán procesados por este mapeo, para transformarlos en el tipo de datos que OTOBO espera.',
        'Mapping for outgoing response data' => 'Asignación de los datos de respuesta salientes',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Los datos de la respuesta serán procesados por este mapeo, para transformarlos en el tipo de datos que el sistema remoto espera.',
        'Include Ticket Data' => 'Incluir Datos del Ticket',
        'Include ticket data in response.' => 'Incluir datos del ticket en la respuesta.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Transporte de Red',
        'Properties' => 'Propiedades',
        'Route mapping for Operation' => 'Mapa de rutas para la Operación',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Define la ruta que debe ser asignada a esta operación. Las variables marcadas con un \':\' se asignarán al nombre introducido y se pasarán junto con las demás a la asignación. (por ejemplo, /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Métodos de solicitud válidos para la operación',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limite esta Operación a métodos de solicitud específicos. Si no se selecciona ningún método, se aceptarán todas las solicitudes.',
        'Maximum message length' => 'Longitud máxima del mensaje',
        'This field should be an integer number.' => 'Este campo debe ser un número entero.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Aquí puede especificar el tamaño máximo (en bytes) de mensajes REST que procesará OTOBO.',
        'Send Keep-Alive' => 'Enviar Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Esta configuración define si las conexiones entrantes deben quedar cerradas o mantenerse activas.',
        'Additional response headers' => 'Encabezados de respuesta adicionales',
        'Add response header' => 'Agregar encabezado de respuesta',
        'Endpoint' => 'Punto final',
        'URI to indicate specific location for accessing a web service.' =>
            'URI para indicar la ubicación específica para acceder a un servicio web.',
        'e.g https://www.otobo.de:10745/api/v1.0 (without trailing backslash)' =>
            'Por ejemplo, https://www.otobo.de:10745/api/v1.0 (sin barra invertida al final)',
        'Timeout' => 'Tiempo de espera',
        'Timeout value for requests.' => 'Valor de tiempo de espera para las solicitudes.',
        'Authentication' => 'Autenticación',
        'An optional authentication mechanism to access the remote system.' =>
            'Un mecanismo de autenticación opcional para acceder al sistema remoto.',
        'BasicAuth User' => 'Usuario para BasicAuth',
        'The user name to be used to access the remote system.' => 'El nombre de usuario para ser usado al acceder al sistema remoto.',
        'BasicAuth Password' => 'Contraseña para BasicAuth',
        'The password for the privileged user.' => 'La contraseña para el usuario con privilegios.',
        'Use Proxy Options' => 'Utilizar Opciones de Proxy',
        'Show or hide Proxy options to connect to the remote system.' => 'Mostrar u ocultar las opciones de Proxy para conectarse al sistema remoto.',
        'Proxy Server' => 'Servidor Proxy',
        'URI of a proxy server to be used (if needed).' => 'URI de un servidor proxy a usar (si es necesario).',
        'e.g. http://proxy_hostname:8080' => 'ej. http://proxy_hostname:8080',
        'Proxy User' => 'Usuario Proxy',
        'The user name to be used to access the proxy server.' => 'El nombre de usuario para acceder al servidor proxy.',
        'Proxy Password' => 'Contraseña del proxy',
        'The password for the proxy user.' => 'La contraseña para el usuario proxy.',
        'Skip Proxy' => 'Saltar Proxy',
        'Skip proxy servers that might be configured globally?' => '¿Saltar los servidores proxy que puedan estar configurados globalmente?',
        'Use SSL Options' => 'Usar Opciones SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Muestra u oculta las opciones de SSL para conectarse al sistema remoto.',
        'Client Certificate' => 'Certificado del Cliente',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'La ruta completa y el nombre del archivo del certificado del cliente SSL (debe estar en formato PEM, DER o PKCS#12).',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'p.e. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Certificado Llave del Cliente',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'La ruta completa y el nombre del archivo de la clave del certificado del cliente SSL (si no está ya incluido en el archivo de certificado).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'p.e. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Contraseña para el Certificado Llave del Cliente',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'La contraseña para abrir el certificado SSL si la clave está cifrada.',
        'Certification Authority (CA) Certificate' => 'Certificado de la Autoridad certificadora (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'La ruta completa y el nombre del archivo certificado por la autoridad de certificación que valida el certificado SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'ej. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Directorio del Certificado de Autorización (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'La ruta completa del directorio de la autoridad de certificación donde se almacenan los certificados CA en el sistema de archivos.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'p.e. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => 'Verificación de nombre de host SSL.',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            'Aborta la solicitud si el nombre de host no puede ser verificado. ¡Desactivar con precaución! Omitir la verificación es un riesgo para la seguridad. Principalmente para propósitos de prueba en caso de certificados SSL autofirmados, o si usted sabe lo que está haciendo.',
        'Controller mapping for Invoker' => 'Mapeo del Controlador para el Invocador',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'El controlador al que el invocador debe enviar las peticiones. Las variables marcadas con un \':\' se sustituirán por el valor de los datos y se pasarán junto con la solicitud. (por ejemplo, /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Petición de comando válida para el Invocador',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Un comando HTTP específico a usar en las peticiones con este invocador (opcional).',
        'Default command' => 'Comando por defecto',
        'The default HTTP command to use for the requests.' => 'El comando HTTP predeterminado para usar con las peticiones.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otobo.de:8000/Webservice/Example' => 'ejemplo: https://local.otobo.de:8000/Webservice/Example',
        'Set SOAPAction' => 'Establecer la acción SOAP',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Establecer como "Sí" para enviar una cabecera de acción SOAP llena.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Establezca el valor "No" para enviar una cabecera de acción SOAP vacía.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Establecer como "Sí" para comprobar la cabecera de acción SOAP recibida (si no está vacía).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Establecer como "No" para ignorar la cabecera de Acción SOAP recibida.',
        'SOAPAction scheme' => 'Esquema de acción SOAP',
        'Select how SOAPAction should be constructed.' => 'Select how SOAP Action should be constructed.',
        'Some web services require a specific construction.' => 'Algunos servicios web requieren una construcción específica.',
        'Some web services send a specific construction.' => 'Algunos servicios web envían una construcción específica.',
        'SOAPAction separator' => 'Separador de acciones SOAP',
        'Character to use as separator between name space and SOAP operation.' =>
            'Carácter a utilizar como separador entre el espacio de nombres y la operación SOAP.',
        'Usually .Net web services use "/" as separator.' => 'Normalmente los servicios web .Net utilizan "/" como separador.',
        'SOAPAction free text' => 'Texto libre de la acción SOAP',
        'Text to be used to as SOAPAction.' => 'Texto que se utilizará como Acción SOAP.',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI para dar a los métodos SOAP un contexto, reduciendo las ambigüedades.',
        'e.g urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions' =>
            'ejemplo: urn:otobo-com:soap:functions or http://www.otobo.de/GenericInterface/actions',
        'Request name scheme' => 'Solicitar nombre de esquema',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Seleccione cómo debe construirse la envoltura de la función de solicitud SOAP.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' se utiliza como ejemplo para el nombre real del invocador/operación.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' se utiliza como ejemplo para el valor real configurado.',
        'Request name free text' => 'Solicitar nombre de texto libre',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Texto que se utilizará como sufijo del nombre de la envoltura de la función o como reemplazo.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Tenga en cuenta las restricciones de denominación de los elementos XML (por ejemplo, no utilice "<" y "&").',
        'Response name scheme' => 'Nombre del esquema de la respuesta',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Seleccione cómo debe construirse la envoltura de la función de respuesta SOAP.',
        'Response name free text' => 'Nombre de la respuesta de texto libre',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Aquí puede especificar el tamaño máximo (en bytes) de los mensajes SOAP que OTOBO procesará.',
        'Encoding' => 'Codificación',
        'The character encoding for the SOAP message contents.' => 'La codificación de caracteres para el contenidos del mensaje SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ej. utf-8, latin1, iso-8859-1, cp1250, Etc.',
        'Sort options' => 'Opciones de Ordenado',
        'Add new first level element' => 'Agregar un nuevo elemento de primer nivel',
        'Element' => 'Elemento',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Orden de salida para los campos xml (estructura que comienza debajo de la envoltura del nombre de la función) - véase la documentación para el transporte SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Añadir un Servicio Web',
        'Edit Web Service' => 'Editar un Servicio Web',
        'Clone Web Service' => 'Clonar un Servicio Web',
        'The name must be unique.' => 'El nombre debe ser único.',
        'Clone' => 'Clon',
        'Export Web Service' => 'Exportar un Servicio Web',
        'Import web service' => 'Importar web service',
        'Configuration File' => 'Archivo de configuración',
        'The file must be a valid web service configuration YAML file.' =>
            'Debe ser un archivo válido YAML de configuración de servicio web.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Aquí puede especificar un nombre para el webservice. Si este campo está vacío, se utilizará como nombre el del archivo de configuración.',
        'Import' => 'Importar',
        'Configuration History' => 'Historial de Configuración',
        'Delete web service' => 'Eliminar web service',
        'Do you really want to delete this web service?' => '¿Realmente desea eliminar este web service?',
        'Ready2Adopt Web Services' => 'Listo para adoptar (Ready2Adopt) Servicios Web',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Aquí puede activar los servicios web de Ready2Adopt que muestran nuestras mejores prácticas que forman parte de %s.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Tenga en cuenta que estos servicios web pueden depender de otros módulos que sólo están disponibles con ciertos niveles de contrato %s (habrá una notificación con más detalles al importar).',
        'Import Ready2Adopt web service' => 'Importar el servicio web Ready2Adopt',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '¿Quiere beneficiarse de los servicios web creados por expertos? Actualice a %s para importar algunos sofisticados servicios web de Ready2Adopt.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Después de guardar la configuración será redirigido de nuevo a la pantalla de edición.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Si desea volver a la vista general, haga clic en el botón "Ir a la vista general".',
        'Remote system' => 'Sistema remoto',
        'Provider transport' => 'Transporte de aprovicionameinto',
        'Requester transport' => 'Transporte de requerimiento',
        'Debug threshold' => 'Alncanse de Depuración',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'En modo proveedor, OTOBO ofrece servicios web que son utilizados por sistemas remotos.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'En el modo solicitante, OTOBO utiliza servicios web de sistemas remotos.',
        'Network transport' => 'Transporte de Red',
        'Error Handling Modules' => 'Módulos de manejo de errores',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Los módulos de gestión de errores se utilizan para reaccionar en caso de errores durante la comunicación. Dichos módulos se ejecutan en un orden específico, que puede cambiarse arrastrando y soltando.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Añadir un módulo de manejo de errores',
        'Operations are individual system functions which remote systems can request.' =>
            'Las operaciones son funciones individuales del sistema que los sistemas remotos pueden solicitar.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Los invocadores preparan los datos para una solicitud a un servicio web remoto y procesan sus datos de respuesta.',
        'Controller' => 'Contolador',
        'Inbound mapping' => 'Mapeo de entrada',
        'Outbound mapping' => 'Mapeo de salida',
        'Delete this action' => 'Eliminar esta acción',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Al menos un %s tiene un controlador que no está activo o no está presente, por favor compruebe el registro del controlador o elimine el %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Historial',
        'Go back to Web Service' => 'Regresar al Web Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Aquí puede ver versiones antiguas de la configuración del servicio web actual, exportarlas o incluso restaurarlas.',
        'Configuration History List' => 'Lista del Historial de Configuración',
        'Version' => 'Versión',
        'Create time' => 'Hora de creación',
        'Select a single configuration version to see its details.' => 'Seleccionar solo una versión de la configuración para ver sus detalles.',
        'Export web service configuration' => 'Exportar configuración del web service',
        'Restore web service configuration' => 'Restaurar configuración del web service',
        'Do you really want to restore this version of the web service configuration?' =>
            '¿Está usted seguro de querer restablecer esta versión de la configuración del servicio web?',
        'Your current web service configuration will be overwritten.' => 'Su configuración actual del servicio web va a ser sobrescrita.',

        # Template: AdminGroup
        'Group Management' => 'Administración de grupos',
        'Add Group' => 'Añadir Grupo',
        'Edit Group' => 'Modificar Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'El grupo admin es para usar el área de administración y el grupo stats para usar el área estadisticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crear grupos nuevos para manejar los permisos de acceso para los diferentes grupos de agentes (por ejemplo: departamento de compras, soporte técnico, ventas, etc.). ',
        'It\'s useful for ASP solutions. ' => 'Es útil para soluciones ASP. ',

        # Template: AdminLog
        'System Log' => 'Log del Sistema',
        'Here you will find log information about your system.' => 'Aquí puede encontrar información de registros sobre su sistema.',
        'Hide this message' => 'Ocultar este mensaje',
        'Recent Log Entries' => 'Registros de eventos recientes',
        'Facility' => 'Instalación',
        'Message' => 'Mensaje',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administración de Cuentas de Correo',
        'Add Mail Account' => 'Agregar Dirección de Correo',
        'Edit Mail Account for host' => 'Editar Cuenta de Correo para el host',
        'and user account' => 'y agregar cuenta de usuario',
        'Filter for Mail Accounts' => 'Filtro para cuentas de correo',
        'Filter for mail accounts' => 'Filtro para cuentas de correo',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Todos los correos electrónicos entrantes con una cuenta serán enviados en la cola seleccionada.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Si su cuenta está marcada como de confianza, las cabeceras X-OTOBO ya existentes en el momento de la llegada (para la prioridad, etc.) se mantendrán y se utilizarán, por ejemplo, en los filtros de PostMaster.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'El correo electrónico saliente se puede configurar a través de los ajustes de Sendmail* en %s.',
        'System Configuration' => 'Configuración del Sistema',
        'Host' => 'Host',
        'Delete account' => 'Eliminar cuenta',
        'Fetch mail' => 'Obtener correo',
        'Do you really want to delete this mail account?' => '¿Realmente desea borrar esta cuenta de correo?',
        'Example: mail.example.com' => 'Ejemplo: correo.ejemplo.com',
        'IMAP Folder' => 'Carpeta IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Modifique esto solo si necesita obtener correos de un directorio distinto a INBOX.',
        'Trusted' => 'Confiable',
        'Dispatching' => 'Remitiendo',
        'Edit Mail Account' => 'Modificar Dirección de Correo',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Visión general de la administración',
        'Filter for Items' => 'Filtro de artículos',
        'Favorites' => 'Favoritos',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Puedes añadir favoritos moviendo el cursor sobre los elementos de la derecha y haciendo clic en el icono de la estrella.',
        'Links' => 'Vínculos',
        'View the admin manual on Github' => 'Ver el manual del administrador en Github',
        'No Matches' => 'No hay coincidencias',
        'Sorry, your search didn\'t match any items.' => 'Lo sentimos, su búsqueda no ha encontrado ningún artículo.',
        'Set as favorite' => 'Fijar como favorito',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gestión de Notificaciones de Tickets',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Aquí puede cargar un archivo de configuración para importar notificaciones de entradas a su sistema. El archivo debe estar en formato .yml, tal y como lo exporta el módulo de Notificación de Tickets.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Aquí puede elegir qué eventos activarán esta notificación. A continuación, se puede aplicar un filtro de tickets adicional para enviar únicamente los tickets con determinados criterios.',
        'Ticket Filter' => 'Filtro de Ticket',
        'Lock' => 'Bloquear',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID de Usuario Cliente',
        'Article Filter' => 'Filtro de Artículos',
        'Only for ArticleCreate and ArticleSend event' => 'Sólo para el evento de creación y envío de artículos',
        'Article sender type' => 'Tipo de remitente de artículo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Si se utiliza Crear artículo o Enviar artículo como evento desencadenante, debe especificar también un filtro de artículo. Seleccione al menos uno de los campos de filtro de artículos.',
        'Customer visibility' => 'Visibilidad del cliente',
        'Communication channel' => 'Canal de comunicaciones',
        'Include attachments to notification' => 'Incluir archivos adjuntos en la notificación',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notificar al usuario sólo una vez al día sobre un ticket único utilizando un transporte seleccionado.',
        'This field is required and must have less than 4000 characters.' =>
            'Este campo es requerido y debe tener menos de 4000 caracteres.',
        'Notifications are sent to an agent or a customer.' => 'Las notificaciones se envían a un agente o cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del agente).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del agente).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para obtener los primeros 20 caracters del Sujeto (del último artículo del cliente).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para obtener las primeras 5 líneas del cuerpo (del último artículo del cliente).',
        'Attributes of the current customer user data' => 'Atributos de los datos del cliente actual',
        'Attributes of the current ticket owner user data' => 'Atributos de los datos del propietario del ticket actual',
        'Attributes of the current ticket responsible user data' => 'Atributos de los datos del responsable actual del ticket',
        'Attributes of the current agent user who requested this action' =>
            'Atributos del agente actual que solicitó esta acción',
        'Attributes of the ticket data' => 'Atributos de los datos del ticket',
        'Ticket dynamic fields internal key values' => 'Valores clave internos de los campos dinámicos del ticket',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Valores de visualización de los campos dinámicos del ticket, útiles para los campos desplegables y multiselección',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Utilice coma o punto y coma para separar las direcciones de correo.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Puede utilizar etiquetas OTOBO como <OTOBO_TICKET_DynamicField_...> para insertar valores en el ticket actual.',

        # Template: AdminPGP
        'PGP Management' => 'Administración PGP',
        'Add PGP Key' => 'Agregar Llave PGP',
        'PGP support is disabled' => 'Soporte PGP deshabitado',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Para poder utilizar PGP en OTOBO, es necesario habilitarlo primero.',
        'Enable PGP support' => 'Habilitar soporte para PGP',
        'Faulty PGP configuration' => 'Configuration PGP erronea',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'La compatibilidad con PGP está activada, pero la configuración correspondiente contiene errores. Por favor, compruebe la configuración utilizando el botón de abajo.',
        'Configure it here!' => '¡Configurelo aquí!',
        'Check PGP configuration' => 'Revisar configuración de PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'De esta forma puede editar directamente el anillo de Claves configurado en Sysconfig.',
        'Introduction to PGP' => 'Introducción a PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Huella',
        'Expires' => 'Expira',
        'Delete this key' => 'Eliminar esta llave',
        'PGP key' => 'Llave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gestor de paquetes',
        'Uninstall Package' => 'Desinstalar Paquete',
        'Uninstall package' => 'Desinstalar paquete',
        'Do you really want to uninstall this package?' => '¿Está seguro de que desea desinstalar este paquete?',
        'Reinstall package' => 'Reinstalar paquete',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '¿Está seguro de que desea reinstalar este paquete? Cualquier cambio manual se perderá.',
        'Go to updating instructions' => 'Ir a las instrucciones de actualización',
        'Go to the OTOBO customer portal' => 'Ir al portal de clientes de OTOBO',
        'package information' => 'información de paquete',
        'Package installation requires a patch level update of OTOBO.' =>
            'La instalación del paquete requiere una actualización a nivel de parche de OTOBO.',
        'Package update requires a patch level update of OTOBO.' => 'La actualización del paquete requiere una actualización a nivel de parche de OTOBO.',
        'Please note that your installed OTOBO version is %s.' => 'Por favor, tenga en cuenta que su versión de OTOBO instalada es %s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'Para instalar este paquete, necesita actualizar OTOBO a la versión %s o más reciente.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Este paquete sólo puede instalarse en OTOBO versión %s o anterior.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Este paquete sólo puede instalarse en OTOBO versión %s o más reciente.',
        'Why should I keep OTOBO up to date?' => '¿Por qué debo mantener OTOBO actualizado?',
        'You will receive updates about relevant security issues.' => 'Recibirá actualizaciones acerca de problemas de seguridad relevantes.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Recibirá actualizaciones de todos los demás problemas relevantes de OTOBO.',
        'How can I do a patch level update if I don’t have a contract?' =>
            '¿Cómo puedo hacer una actualización de nivel de parche si no tengo contrato?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Por favor, encuentre toda la información relevante dentro de las instrucciones de actualización en %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'En caso de que tenga más preguntas, estaremos encantados de responderlas.',
        'Please visit our customer portal and file a request.' => 'Visite nuestro portal de clientes y presente una solicitud.',
        'Install Package' => 'Instalar Paquete',
        'Update Package' => 'Actualizar Paquete',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Por favor, asegúrese de que su base de datos acepta paquetes de más de %s MB de tamaño (actualmente sólo acepta paquetes de hasta %s MB). Por favor, adapte el ajuste max_allowed_packet de su base de datos para evitar errores.',
        'Install' => 'Instalar',
        'Update repository information' => 'Actualizar la información del repositorio',
        'Cloud services are currently disabled.' => 'Los servicios en la nube se encuentran deshabitados actualmente.',
        'OTOBO Verify can not continue!' => '¡OTOBO Verify no puede continuar!',
        'Enable cloud services' => 'Habilitar servicios en la nube',
        'Update all installed packages' => 'Actualizar todos los paquetes instalados',
        'Online Repository' => 'Repositorio Online',
        'Vendor' => 'Vendedor',
        'Action' => 'Acción',
        'Module documentation' => 'Módulo de Documentación',
        'Local Repository' => 'Repositorio Local',
        'This package is verified by OTOBOverify (tm)' => 'Este paquete esta verificado por OTOBOVerify (tm)',
        'Uninstall' => 'Desinstalar',
        'Package not correctly deployed! Please reinstall the package.' =>
            'El paquete no fue desplegado correctamente. Por favor, reinstale el paquete.',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Características sólo para los clientes de %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Con %s, puede beneficiarse de las siguientes funciones opcionales. Póngase en contacto con %s si necesita más información.',
        'Package Information' => 'Información del Paquete',
        'Download package' => 'Descargar paquete',
        'Rebuild package' => 'Reconstruir paquete',
        'Metadata' => 'Metadatos',
        'Change Log' => 'Registro de Cambios',
        'Date' => 'Fecha',
        'List of Files' => 'Lista de Archivos',
        'Permission' => 'Permiso',
        'Download file from package!' => 'Descargar archivo del paquete!',
        'Required' => 'Obligatorio',
        'Primary Key' => 'Llave Primaria',
        'Auto Increment' => 'Auto Incremento',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Diferencias de Archivo para el Archivo %s',
        'File differences for file %s' => 'Diferencias de archivo para %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log de rendimiento',
        'Range' => 'Rango',
        'last' => 'último',
        'This feature is enabled!' => '¡Esta característica está habilitada!',
        'Just use this feature if you want to log each request.' => 'Use esta característica sólo si desea registrar cada petición.',
        'Activating this feature might affect your system performance!' =>
            'Activar esta opción podría afectar el rendimiento de su sistema!',
        'Disable it here!' => '¡Deshabilítelo aquí!',
        'Logfile too large!' => '¡Archivo de log muy grande!',
        'The logfile is too large, you need to reset it' => 'El archivo de registros es muy grande, necesita restablecerlo',
        'Interface' => 'Interfase',
        'Requests' => 'Solicitudes',
        'Min Response' => 'Respuesta Mínima',
        'Max Response' => 'Respuesta Máxima',
        'Average Response' => 'Respuesta Promedio',
        'Period' => 'Periodo',
        'minutes' => 'minutos',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Promedio',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administración del filtro maestro',
        'Add PostMaster Filter' => 'Añadir Filtro de Administración de Correo',
        'Edit PostMaster Filter' => 'Modificar Filtro de Administración de Correo',
        'Filter for PostMaster Filters' => 'Filtro para Filtros de PostMaster',
        'Filter for PostMaster filters' => 'Filtro apra filtros de PostMaster',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para remitir o filtrar correos electrónicos entrantes basándose en los encabezados de dichos correos. También es posible utilizar Expresiones Regulares para las coincidencias.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Si desea chequear sólo la dirección del email, use EMAILADDRESS:info@example.com en De, Para o Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Si utiliza Expresiones Regulares, también puede utilizar el valor de coincidencia en () como [***] en la acción de \'Establecer\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'También puede utilizar capturas con nombre %s y utilizar los nombres en la acción \'Set\' %s (por ejemplo, Regexp: %s, Set action: %s). Una EMAILADDRESS coincidente tiene el nombre \'%s\'.',
        'Delete this filter' => 'Eliminar este filtro',
        'Do you really want to delete this postmaster filter?' => '¿Realmente quieres eliminar este filtro postmaster?',
        'A postmaster filter with this name already exists!' => '¡Ya existe un filtro de postmaster con este nombre!',
        'Filter Condition' => 'Condición del Filtro',
        'AND Condition' => 'Condición AND',
        'Search header field' => 'Buscar campo de encabezado',
        'for value' => 'para el valor',
        'The field needs to be a valid regular expression or a literal word.' =>
            'El campo tiene que ser una expresión regular válida o una palabra literal.',
        'Negate' => 'Negar',
        'Set Email Headers' => 'Establecer los Encabezados del Correo Electrónico',
        'Set email header' => 'Establecer encabezado del Email',
        'with value' => 'con el valor',
        'The field needs to be a literal word.' => 'El campo tiene que ser una palabra literal.',
        'Header' => 'Encabezado',

        # Template: AdminPriority
        'Priority Management' => 'Administración de Prioridades',
        'Add Priority' => 'Añadir Prioridad',
        'Edit Priority' => 'Modificar Prioridad',
        'Filter for Priorities' => 'Filtro para Prioridades',
        'Filter for priorities' => 'Filtro para prioridades',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Esta prioridad está presente en un ajuste de SysConfig, ¡se necesita confirmación para actualizar los ajustes para que apunten a la nueva prioridad!',
        'This priority is used in the following config settings:' => 'Esta prioridad se utiliza en los siguientes ajustes de configuración:',

        # Template: AdminProcessManagement
        'Process Management' => 'Gestión de Procesos',
        'Filter for Processes' => 'Filtro por Proceso',
        'Filter for processes' => 'Filtro para procesos',
        'Create New Process' => 'Crear Nuevo Proceso',
        'Deploy All Processes' => 'Desplegar Todos los Procesos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Aquí puede cargar un archivo de configuración para importar un proceso a su sistema. El archivo debe estar en formato .yml como se exporta por el módulo de gestión de procesos.',
        'Upload process configuration' => 'Cargar configuración de proceso',
        'Import process configuration' => 'Importar configuración de proceso',
        'Ready2Adopt Processes' => 'Procesos Ready2Adopt',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Aquí puede activar los procesos de Ready2Adopt mostrando nuestras mejores prácticas. Tenga en cuenta que puede ser necesaria alguna configuración adicional.',
        'Import Ready2Adopt process' => 'Importar procesos Ready2Adopt',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para crear un nuevo proceso, puede importar un proceso exportado desde otro sistema o crear uno completamente nuevo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Los cambios en los procesos sólo afectan al comportamiento del sistema si se sincronizan los datos de los procesos. Al sincronizar los Procesos, los cambios recién realizados se escribirán en la Configuración.',
        'Processes' => 'Procesos',
        'Process name' => 'Nombre del Proceso',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuración de Procesos',
        'Copy Process' => 'Copiar Proceso',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancelar y cerrar',
        'Go Back' => 'Regresar',
        'Please note, that changing this activity will affect the following processes' =>
            'Tenga en cuenta que el cambio de esta actividad afectará a los siguientes procesos',
        'Activity' => 'Actividad',
        'Activity Name' => 'Nombre de la Actividad',
        'Activity Dialogs' => 'Dialogos de la Actividad',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Diálogos de la Actividad a esta Actividad arrastrándolos con el mouse de la lista izquierda a la lista de la derecha .',
        'Filter available Activity Dialogs' => 'Filtros disponibles en Diálogos de la Actividad',
        'Available Activity Dialogs' => 'Diálogos de Actividad Disponibles',
        'Name: %s, EntityID: %s' => 'Nombre: %s, ID de Entidad: %s',
        'Create New Activity Dialog' => 'Crear un nuevo Diálogo para la Actividad',
        'Assigned Activity Dialogs' => 'Diálogos de Actividad Asignados',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Tenga en cuenta que el cambio de este cuadro de diálogo afectará a las siguientes actividades',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Tenga en cuenta que los usuarios clientes no podrán ver ni utilizar los siguientes campos: Propietario, Responsable, Bloqueo, Hora pendiente y CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'El campo de Fila solo puede ser utilizado por los clientes al crear un nuevo ticket.',
        'Activity Dialog' => 'Diálogo de Actividad',
        'Activity dialog Name' => 'Nombre del diálogo de actividad',
        'Available in' => 'Disponible en',
        'Description (short)' => 'Descripción (corta)',
        'Description (long)' => 'Descripción (larga)',
        'The selected permission does not exist.' => 'El permiso seleccionado no existe.',
        'Required Lock' => 'Bloqueo Requerido',
        'The selected required lock does not exist.' => 'El bloqueo requerido que ha seleccionado no existe.',
        'Submit Advice Text' => 'Envíe Texto del Aviso',
        'Submit Button Text' => 'Texto del Botón Enviar',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Campos a este cuadro de actividad arrastrando los elementos con el ratón desde la lista de la izquierda a la de la derecha.',
        'Filter available fields' => 'Filtrar campos disponibles',
        'Available Fields' => 'Campos Disponibles',
        'Assigned Fields' => 'Campos Asignados',
        'Communication Channel' => 'Canal de Comunicacion',
        'Is visible for customer' => 'Es visible para el cliente',
        'Display' => 'Mostrar',

        # Template: AdminProcessManagementPath
        'Path' => 'Ruta',
        'Edit this transition' => 'Editar esta transición',
        'Transition Actions' => 'Acciones de Transición',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Puede asignar Acciones esta Transición arrastrando con el mouse elementos de la lista izquierda a la lista de la derecha .',
        'Filter available Transition Actions' => 'Filtro para Acciones de Transición disponible',
        'Available Transition Actions' => 'Acciones de Transición Disponibles',
        'Create New Transition Action' => 'Crear Nueva Acción de Transición',
        'Assigned Transition Actions' => 'Acción de Transición Asignada',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Actividades',
        'Filter Activities...' => 'Filtrar Actividades...',
        'Create New Activity' => 'Crear Nueva Actividad',
        'Filter Activity Dialogs...' => 'Filtrar Diálogos de Actividad...',
        'Transitions' => 'Transiciónes',
        'Filter Transitions...' => 'Filtrar Transiciones...',
        'Create New Transition' => 'Crear Nueva Transición',
        'Filter Transition Actions...' => 'Filtrar Acciones de Transición...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Editar Proceso',
        'Print process information' => 'Imprimir información del proceso',
        'Delete Process' => 'Eliminar Proceso',
        'Delete Inactive Process' => 'Eliminar Proceso Inactivo',
        'Available Process Elements' => 'Elementos de Proceso Disponibles',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Los elementos listados arriba en esta barra lateral pueden ser movidos al área del cuadro a la derecha usando la función de arrastrar y soltar.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Puede colocar Actividades en el área del cuadro para asignar esta Actividad al Proceso.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Para asignar un diálogo de actividad a una actividad, suelte el elemento de diálogo de actividad de esta barra lateral sobre la actividad colocada en el área del cuadro.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Puede iniciar una conexión entre dos Actividades soltando el elemento de Transición sobre la Actividad de Inicio de la conexión. Después puede mover el extremo suelto de la flecha a la Actividad Final.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Las acciones pueden asignarse a una transición soltando el elemento de acción en la etiqueta de una transición.',
        'Edit Process Information' => 'Editar Información del Proceso',
        'Process Name' => 'Nombre del Proceso',
        'The selected state does not exist.' => 'El estado seleccionado no existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Añada y Edite Actividades, Diálogos de Actividad y Transiciones',
        'Show EntityIDs' => 'Mostrar EntityIDs',
        'Extend the width of the Canvas' => 'Amplíe la ancho del Lienzo',
        'Extend the height of the Canvas' => 'Amplíe la altura del Lienzo',
        'Remove the Activity from this Process' => 'Elimine la Actividad de este Proceso',
        'Edit this Activity' => 'Editar esta Actividad',
        'Save Activities, Activity Dialogs and Transitions' => 'Guarde las Actividades, Diálogos de Actividad y Transiciones',
        'Do you really want to delete this Process?' => '¿Está Usted seguro de querer eliminar este Proceso?',
        'Do you really want to delete this Activity?' => '¿Está Usted seguro de querer eliminar esta Actividad?',
        'Do you really want to delete this Activity Dialog?' => '¿Realmente quiere eliminar este Diálogo de Actividad?',
        'Do you really want to delete this Transition?' => '¿Realmente quieres borrar esta Transición?',
        'Do you really want to delete this Transition Action?' => '¿Realmente quiere eliminar esta Acción de Transición?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '¿Realmente quiere eliminar esta actividad del cuadro? Esto sólo puede deshacerse saliendo de esta pantalla sin guardar.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '¿Realmente quiere eliminar esta transición del cuadro? Esto sólo puede deshacerse saliendo de esta pantalla sin guardar.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'En esta pantalla, puede crear un nuevo proceso. Para que el nuevo proceso esté disponible para los usuarios, asegúrese de establecer su estado en "Activo" y sincronizarlo después de completar su trabajo.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'cancelar y cerrar',
        'Start Activity' => 'Iniciar Actividad',
        'Contains %s dialog(s)' => 'Contiene %s diálogo(s)',
        'Assigned dialogs' => 'Diálogos Asignados',
        'Activities are not being used in this process.' => 'Las Actividades no están siendo usadas en este proceso.',
        'Assigned fields' => 'Campos asignados',
        'Activity dialogs are not being used in this process.' => 'Los Diálogos de Actividad no están siendo usados en este proceso.',
        'Condition linking' => 'Vinculación de Condiciones',
        'Transitions are not being used in this process.' => 'Las Acciones de transición no están siendo usadas en este proceso.',
        'Module name' => 'Nombre del Módulo',
        'Transition actions are not being used in this process.' => 'Las acciones de transición no se utilizan en este proceso.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Tenga en cuenta que el cambio de esta transición afectará a los siguientes procesos',
        'Transition' => 'Transición',
        'Transition Name' => 'Nombre de la Transición',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Tenga en cuenta que el cambio de esta acción de transición afectará a los siguientes procesos',
        'Transition Action' => 'Acción de Transición',
        'Transition Action Name' => 'Nombre de la Acción de Transición',
        'Transition Action Module' => 'Módulo Acción de Transición',
        'Config Parameters' => 'Parámetros de Configuración',
        'Add a new Parameter' => 'Añada un nuevo Parámetro',
        'Remove this Parameter' => 'Eliminar este Parámetro',

        # Template: AdminQueue
        'Queue Management' => 'Gestión de Filas',
        'Add Queue' => 'Agregar Fila',
        'Edit Queue' => 'Modificar Fila',
        'Filter for Queues' => 'Filtro por colas',
        'Filter for queues' => 'Filtro por colas',
        'A queue with this name already exists!' => '¡Ya existe una fila con este nombre!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Esta cola está presente en una configuración de SysConfig, ¡se necesita confirmación para actualizar la configuración para que apunte a la nueva cola!',
        'Sub-queue of' => 'Sub-fila de',
        'Unlock timeout' => 'Tiempo para desbloqueo automático',
        '0 = no unlock' => '0 = sin desbloqueo',
        'hours' => 'horas',
        'Only business hours are counted.' => 'Sólo se contarán las horas de trabajo.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Si un agente bloquea un ticket y no lo cierra antes de que el tiempo de espera termine, dicho ticket se desbloqueará y estará disponible para otros agentes.',
        'Notify by' => 'Notificado por',
        '0 = no escalation' => '0 = sin escalada',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Si no se ha contactado al cliente, ya sea por medio de una nota externa o por teléfono, de un ticket nuevo antes de que el tiempo definido aquí termine, el ticket escalará.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Si se añade un artículo, tal como un seguimiento, vía correo electrónico o interfaz del cliente, el tiempo para escalada por actualización se reinicia. Si no se ha contactado al cliente, ya sea por medio de una nota externa o por teléfono agregados a un ticket antes de que el tiempo definido aquí expire, el ticket escala.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Si el ticket no se cierra antes de que el tiempo definido aquí termine, dicho ticket escalará.',
        'Follow up Option' => 'Opción de seguimiento',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica si seguimiento a tickets cerrados: reabrirá dichos tickets, se rechazará o generará un ticket nuevo.',
        'Ticket lock after a follow up' => 'Bloquear un ticket después del seguimiento',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Si un ticket está cerrado y el cliente le da seguimiento, el ticket se bloqueará para el antigüo propietario.',
        'System address' => 'Dirección del Sistema',
        'Will be the sender address of this queue for email answers.' => 'Será la dirección del emisor en esta fila para respuestas por correo.',
        'Default sign key' => 'Llave de firma por defecto',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Para utilizar una clave de firma, es necesario añadir claves PGP o certificados S/MIME con identificadores para la dirección del sistema de colas seleccionado.',
        'Salutation' => 'Saludo',
        'The salutation for email answers.' => 'Saludo para respuestas por correo.',
        'Signature' => 'Firma',
        'The signature for email answers.' => 'Firma para respuestas por correo.',
        'This queue is used in the following config settings:' => 'Esta cola se utiliza en los siguientes ajustes de configuración:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrar Relaciones Fila-Respuesta Automática',
        'Change Auto Response Relations for Queue' => 'Modificar las Relaciones de Respuesta Automática para la Fila',
        'This filter allow you to show queues without auto responses' => 'Este filtro le permite mostrar las colas sin respuestas automáticas',
        'Queues without Auto Responses' => 'Colas sin Respuestas Automáticas',
        'This filter allow you to show all queues' => 'Este filtro le permite mostrar todas las colas',
        'Show All Queues' => 'Mostrar todas las colas',
        'Auto Responses' => 'Respuestas Automáticas',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Administrar Relaciones Plantilla-Fila',
        'Filter for Templates' => 'Filtrar por Plantillas',
        'Filter for templates' => 'Filtro para plantillas',
        'Templates' => 'Plantillas',

        # Template: AdminRegistration
        'System Registration Management' => 'Gestión del registro del sistema',
        'Edit System Registration' => 'Editar registro del sistema',
        'System Registration Overview' => 'Resumen del registro del sistema',
        'Register System' => 'Registrar Sistema',
        'Validate OTOBO-ID' => 'Validad OTOBO-ID',
        'Deregister System' => 'Dar de Baja Este Sistema',
        'Edit details' => 'Editar detalles',
        'Show transmitted data' => 'Mostrar datos transmitidos',
        'Deregister system' => 'Dar de baja su sistema',
        'Overview of registered systems' => 'Vista general de sus sistemas registrados',
        'This system is registered with OTOBO Team.' => 'Este sistema está registrado en el equipo OTOBO.',
        'System type' => 'Tipo de sistema',
        'Unique ID' => 'ID único',
        'Last communication with registration server' => 'Última comunicación con el servidor de registro',
        'System Registration not Possible' => 'No es posible el registro del sistema',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Tenga en cuenta que no puede registrar su sistema si el Demonio de OTOBO no está funcionando correctamente!',
        'Instructions' => 'Instrucciones',
        'System Deregistration not Possible' => 'No es posible dar de baja el sistema',
        'OTOBO-ID Login' => 'Inicio de sesión con OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            '¡El registro del sistema es un servicio del equipo OTOBO, que ofrece muchas ventajas!',
        'Read more' => 'Leer más',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Necesita iniciar sesión con su OTOBO-ID para registrar su sistema.',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Su OTOBO-ID es la dirección de email que utilizó para registrarse en la página web OTOBO.com.',
        'Data Protection' => 'Protección de Datos',
        'What are the advantages of system registration?' => '¿Cuáles son las ventajas de registrar su sistema?',
        'You will receive updates about relevant security releases.' => 'Recibirás actualizaciones sobre los lanzamientos de seguridad relevantes.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Con el registro de su sistema podemos mejorar nuestros servicios para usted, ya que disponemos de toda la información relevante.',
        'This is only the beginning!' => '¡Esto es sólo el principio!',
        'We will inform you about our new services and offerings soon.' =>
            'Pronto le informaremos sobre nuestros nuevos servicios y ofertas.',
        'Can I use OTOBO without being registered?' => '¿Puedo utilizar OTOBO sin estar registrado?',
        'System registration is optional.' => 'El registro del sistema es opcional.',
        'You can download and use OTOBO without being registered.' => 'Puedes descargar y utilizar OTOBO sin estar registrado.',
        'Is it possible to deregister?' => '¿Es posible darse de baja?',
        'You can deregister at any time.' => 'Puede darse de baja en cualquier momento.',
        'Which data is transfered when registering?' => '¿Qué datos se transfieren al registrarse?',
        'A registered system sends the following data to OTOBO Team:' => 'Un sistema registrado envía los siguientes datos a OTOBO Team:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Nombre de dominio completo (FQDN), versión de OTOBO, base de datos, sistema operativo y versión de Perl.',
        'Why do I have to provide a description for my system?' => '¿Por qué tengo que dar una descripción de mi sistema?',
        'The description of the system is optional.' => 'La descripción del sistema es opcional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'La descripción y el tipo de sistema que especifique le ayudarán a identificar y gestionar los detalles de sus sistemas registrados.',
        'How often does my OTOBO system send updates?' => '¿Con qué frecuencia envía actualizaciones mi sistema OTOBO?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Su sistema enviará actualizaciones al servidor de registro a intervalos regulares.',
        'Typically this would be around once every three days.' => 'Lo normal es que sea una vez cada tres días.',
        'If you deregister your system, you will lose these benefits:' =>
            'Si se da de baja en el sistema, perderá estas ventajas:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Tienes que entrar con tu OTOBO-ID para dar de baja tu sistema.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => '¿Aún no tiene su OTOBO-ID?',
        'Sign up now' => 'Inscríbase ahora',
        'Forgot your password?' => '¿Olvidó su contraseña?',
        'Retrieve a new one' => 'Solicitar una nueva',
        'Next' => 'Siguiente',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Estos datos serán transferidos con frecuencia al equipo OTOBO cuando registre este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'Nombre de dominio totalmente calificado',
        'OTOBO Version' => 'Versión de OTOBO',
        'Operating System' => 'Sistema Operativo',
        'Perl Version' => 'Versión de Perl',
        'Optional description of this system.' => 'Descripción opcional de este sistema.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Esto permitirá que el sistema envíe información adicional de datos de apoyo al equipo OTOBO.',
        'Register' => 'Registrar',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Al continuar con este paso se dará de baja el sistema del equipo OTOBO.',
        'Deregister' => 'Dar de baja',
        'You can modify registration settings here.' => 'Aquí puede modificar la configuración del registro.',
        'Overview of Transmitted Data' => 'Resumen de los datos transmitidos',
        'There is no data regularly sent from your system to %s.' => 'No hay datos enviados regularmente desde su sistema a %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Los siguientes datos se envían como mínimo cada 3 días desde su sistema a %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Los datos se transferirán en formato JSON a través de una conexión segura https.',
        'System Registration Data' => 'Datos de Registro del Sistema',
        'Support Data' => 'Datos de Soporte',

        # Template: AdminRole
        'Role Management' => 'Gestión de Roles',
        'Add Role' => 'Añadir Rol',
        'Edit Role' => 'Modificar Rol',
        'Filter for Roles' => 'Filtro para Roles',
        'Filter for roles' => 'Filtro por roles',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Cree un rol y coloque grupos en el mismo. Luego añada el rol a los usuarios.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'No hay roles definidos. Por favor, use el botón \'Añadir\' para crear un rol nuevo.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Administrar Relaciones Rol-Grupo',
        'Roles' => 'Roles',
        'Select the role:group permissions.' => 'Seleccionar los permisos rol:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Si nada se selecciona, no habrá permisos para este grupo y los tickets no estarán disponibles para el rol.',
        'Toggle %s permission for all' => 'Activar permiso %s para todos',
        'move_into' => 'mover_a',
        'Permissions to move tickets into this group/queue.' => 'Permiso para mover tickets a este grupo/fila.',
        'create' => 'crear',
        'Permissions to create tickets in this group/queue.' => 'Permiso para crear tickets en este grupo/fila.',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permisos para añadir notas a los tickets de este/a grupo/fila.',
        'owner' => 'propietario',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permisos para modificar el propietario de los tickets en este/a grupo/fila.',
        'priority' => 'prioridad',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permiso para cambiar la prioridad del ticket en este grupo/fila.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Administrar Relaciones Agente-Rol',
        'Add Agent' => 'Añadir Agente',
        'Filter for Agents' => 'Filtro para Agentes',
        'Filter for agents' => 'Filtro para agenters',
        'Agents' => 'Agentes',
        'Manage Role-Agent Relations' => 'Administrar Relaciones Rol-Agente',

        # Template: AdminSLA
        'SLA Management' => 'Administración de SLA',
        'Edit SLA' => 'Modificar SLA',
        'Add SLA' => 'Añadir SLA',
        'Filter for SLAs' => 'Filtro para SLAs',
        'Please write only numbers!' => '¡Por favor, escriba sólo números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gestion S/MIME',
        'Add Certificate' => 'Añadir Certificado',
        'Add Private Key' => 'Añadir Clave Privada',
        'SMIME support is disabled' => 'soporte SMIME deshabitado',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Para poder utilizar SMIME en OTOBO, primero hay que habilitarlo.',
        'Enable SMIME support' => 'Habilitar el soporte de SMIME',
        'Faulty SMIME configuration' => 'Configuración defectuosa de SMIME',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'El soporte de SMIME está activado, pero la configuración correspondiente contiene errores. Por favor, compruebe la configuración utilizando el botón de abajo.',
        'Check SMIME configuration' => 'Comprobar la configuración de SMIME',
        'Filter for Certificates' => 'Filtro para certificados',
        'Filter for certificates' => 'Filtro para certificados',
        'To show certificate details click on a certificate icon.' => 'Para mostrar los detalles del certificado, haga clic en el icono de un certificado.',
        'To manage private certificate relations click on a private key icon.' =>
            'Para gestionar las relaciones de los certificados privados, haga clic en el icono de una clave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aquí puede añadir relaciones a su certificado privado, éstas se incorporarán a la firma S/MIME cada vez que utilice este certificado para firmar un correo electrónico.',
        'See also' => 'Vea también',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de archivos.',
        'Hash' => 'De esta forma Ud. puede editar directamente la certificación y claves privadas en el sistema de archivos.',
        'Create' => 'Crear',
        'Handle related certificates' => 'Maneje certificados relacionados',
        'Read certificate' => 'Leer certificado',
        'Delete this certificate' => 'Eliminar este certificado',
        'File' => 'Archivo',
        'Secret' => 'Secreto',
        'Related Certificates for' => 'Certificados relacionados para',
        'Delete this relation' => 'Eliminar esta relación',
        'Available Certificates' => 'Certificados Disponibles',
        'Filter for S/MIME certs' => 'Filtro para certificados S/MIME',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificado S/MIME',
        'Certificate Details' => 'Detalles del certificado',
        'Close this dialog' => 'Cerrar este diálogo',

        # Template: AdminSalutation
        'Salutation Management' => 'Gestión de Saludos',
        'Add Salutation' => 'Agregar Saludo',
        'Edit Salutation' => 'Modificar Saludo',
        'Filter for Salutations' => 'Filtro para saludos',
        'Filter for salutations' => 'Filtro de saludos',
        'e. g.' => 'Por ejemplo.',
        'Example salutation' => 'Saludo de ejemplo',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '¡Es necesario activar el modo seguro!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'El Modo Seguro (normalmente) queda habilitado cuando la instalación inicial se completa.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Si el modo seguro no está activo aún, hágalo a través de la Configuración del Sistema, porque su aplicación ya se está ejecutando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Consola SQL',
        'Filter for Results' => 'Filtro de resultados',
        'Filter for results' => 'Filtro de resultados',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aquí se puede introducir el SQL para enviarlo directamente a la base de datos de la aplicación. No es posible modificar el contenido de las tablas, sólo se permiten las consultas de selección.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aquí puede introducir SQL para ejecutarse directamente en la base de datos de la aplicación.',
        'Options' => 'Opciones',
        'Only select queries are allowed.' => 'Solo están permitidas las consultas select.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'La sintaxis de su consulta SQL tiene un error. Por favor, verifíquela.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Existe al menos un parámetro faltante para en enlace. Por favor, verifíquelo.',
        'Result format' => 'Formato del resultado',
        'Run Query' => 'Ejecutar Consulta',
        '%s Results' => '%s Resultados',
        'Query is executed.' => 'Se ejecuta la consulta.',

        # Template: AdminService
        'Service Management' => 'Administración de Servicios',
        'Add Service' => 'Añadir Servicio',
        'Edit Service' => 'Modificar Servicio',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'La longitud máxima del nombre del servicio es de 200 caracteres (con sub-servicio).',
        'Sub-service of' => 'Subservicio de',

        # Template: AdminSession
        'Session Management' => 'Administración de Sesiones',
        'Detail Session View for %s (%s)' => 'Vista detallada de la sesión de %s (%s)',
        'All sessions' => 'Todas las sesiones',
        'Agent sessions' => 'Sesiones de agente',
        'Customer sessions' => 'Sesiones de cliente',
        'Unique agents' => 'Agentes únicos',
        'Unique customers' => 'Clientes únicos',
        'Kill all sessions' => 'Finalizar todas las sesiones',
        'Kill this session' => 'Terminar esta sesión',
        'Filter for Sessions' => 'Filtrar por Sesiones',
        'Filter for sessions' => 'Filtrar por sesiones',
        'Session' => 'Sesión',
        'Kill' => 'Terminar',
        'Detail View for SessionID: %s - %s' => 'Vista detallada para SessionID: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Administración de Firmas',
        'Add Signature' => 'Añadir Firma',
        'Edit Signature' => 'Modificar Firma',
        'Filter for Signatures' => 'Filtro de firmas',
        'Filter for signatures' => 'Filtro de firmas',
        'Example signature' => 'Firma de ejemplo',

        # Template: AdminState
        'State Management' => 'Administración de Estados',
        'Add State' => 'Añadir Estado',
        'Edit State' => 'Modificar Estado',
        'Filter for States' => 'Filtro para los Estados',
        'Filter for states' => 'Filtro de estados',
        'Attention' => 'Atención',
        'Please also update the states in SysConfig where needed.' => 'Actualice también los estados en SysConfig donde sea necesario.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Este estado está presente en un ajuste de SysConfig, ¡se necesita confirmación para actualizar los ajustes para que apunten al nuevo tipo!',
        'State type' => 'Tipo de Estado',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '¡No es posible invalidar esta entrada porque no hay otros estados de unión en el sistema!',
        'This state is used in the following config settings:' => 'Este estado se utiliza en los siguientes ajustes de configuración:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => '¡No es posible enviar datos de apoyo al equipo OTOBO!',
        'Enable Cloud Services' => 'Habilitar los servicios en la nube',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Estos datos se envían al equipo de OTOBO de forma regular. Para dejar de enviar estos datos, actualice su registro en el sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Puede activar manualmente el envío de datos de soporte pulsando este botón:',
        'Send Update' => 'Enviar Actualización',
        'Currently this data is only shown in this system.' => 'Actualmente estos datos sólo se muestran en este sistema.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'Se recomienda encarecidamente enviar estos datos al equipo de OTOBO para obtener una mejor asistencia.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para habilitar el envío de datos, registre su sistema en el equipo de OTOBO o actualice la información de registro de su sistema (asegúrese de activar la opción "enviar datos de soporte".)',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Pulsando este botón se puede generar un paquete de soporte (que incluye: información de registro del sistema, datos de soporte, una lista de paquetes instalados y todos los archivos de código fuente modificados localmente):',
        'Generate Support Bundle' => 'Generar un paquete de soporte',
        'The Support Bundle has been Generated' => 'Se ha generado el paquete de soporte',
        'Please choose one of the following options.' => 'Por favor escoja una de las siguientes opciones.',
        'Send by Email' => 'Enviar por Email',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'El paquete de soporte es demasiado grande para enviarlo por correo electrónico, esta opción ha sido desactivada.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'La dirección de correo electrónico de este usuario es inválida, esta opción se ha deshabitado.',
        'Sending' => 'Emisor',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'El paquete de soporte se enviará al equipo de OTOBO por correo electrónico automáticamente.',
        'Download File' => 'Descargar Archivo',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'Se descargará un archivo que contiene el paquete de soporte en el sistema local. Por favor, guarde el archivo y envíelo al equipo de OTOBO, utilizando un método alternativo.',
        'Error: Support data could not be collected (%s).' => 'Error: Los datos de soporte no han podido ser recolectados (%s).',
        'Details' => 'Detalles',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administración de Direcciones de Correo del sistema',
        'Add System Email Address' => 'Agregar Dirección de Correo Electrónico del Sistema',
        'Edit System Email Address' => 'Modificar Dirección de Correo Electrónico del Sistema',
        'Add System Address' => 'Añadir dirección del sistema',
        'Filter for System Addresses' => 'Filtro de direcciones del sistema',
        'Filter for system addresses' => 'Filtro de direcciones del sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos los correos electrónicos entrantes con esta dirección en Para o Cc serán enviados a la fila seleccionada.',
        'Email address' => 'Dirección de correo electrónico',
        'Display name' => 'Nombre mostrado',
        'This email address is already used as system email address.' => 'Esta dirección de correo electrónico ya se utiliza como dirección de correo electrónico del sistema.',
        'The display name and email address will be shown on mail you send.' =>
            'El nombre a mostrar y la dirección de correo electrónico se agregarán en los correos que ud. envíe.',
        'This system address cannot be set to invalid.' => 'Esta dirección del sistema no se puede establecer como inválida.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Esta dirección del sistema no puede establecerse como no válida, porque se utiliza en una o más colas o respuestas automáticas.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'documentación del administrador en línea',
        'System configuration' => 'Configuración del sistema',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Navegue por los ajustes disponibles utilizando el árbol de navegación de la izquierda.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Encuentre determinados ajustes utilizando el campo de búsqueda de abajo o desde el icono de búsqueda de la navegación superior.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Averigüe cómo utilizar la configuración del sistema leyendo los %s.',
        'Search in all settings...' => 'Buscar en todos los ajustes...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Actualmente no hay ninguna configuración disponible. Asegúrese de ejecutar \'otobo.Console.pl Maint::Config::Rebuild\' antes de utilizar el software.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Cambios en el despliegue',
        'Help' => 'Ayuda',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Este es un resumen de todos los ajustes que formarán parte del despliegue si lo inicia ahora. Puede comparar cada ajuste con su estado anterior haciendo clic en el icono de la parte superior derecha.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'Para excluir determinadas configuraciones de un despliegue, haga clic en la casilla de verificación de la barra de encabezamiento de una configuración.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Por defecto, sólo se desplegarán las configuraciones que hayas cambiado tú mismo. Si quieres desplegar también los ajustes modificados por otros usuarios, haz clic en el enlace de la parte superior de la pantalla para acceder al modo de despliegue avanzado.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Un despliegue acaba de ser restaurado, lo que significa que todos los ajustes afectados han sido revertidos al estado del despliegue seleccionado.',
        'Please review the changed settings and deploy afterwards.' => 'Por favor, revise los ajustes modificados y desplegados.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Una lista de cambios vacía significa que no hay diferencias entre el estado restaurado y el actual de los ajustes afectados.',
        'Changes Overview' => 'Resumen de los cambios',
        'There are %s changed settings which will be deployed in this run.' =>
            'Hay %s ajustes modificados que se desplegarán en esta ejecución.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Cambie al modo básico para desplegar los ajustes que sólo usted puede cambiar.',
        'You have %s changed settings which will be deployed in this run.' =>
            'Tiene %s ajustes modificados que se desplegarán en esta ejecución.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Cambie al modo avanzado para desplegar también los ajustes modificados por otros usuarios.',
        'There are no settings to be deployed.' => 'No hay ajustes que desplegar.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Cambie al modo avanzado para ver los ajustes desplegables modificados por otros usuarios.',
        'Deploy selected changes' => 'Despliegue de los cambios seleccionados',

        # Template: AdminSystemConfigurationDeploymentHistory
        'Deployment History' => 'Historial de despliegue',
        'Filter for Deployments' => 'Filtro de despliegues',
        'Recent Deployments' => 'Despliegues recientes',
        'Restore' => 'Restaurar',
        'View Details' => 'Ver detalles',
        'Restore this deployment.' => 'Restablecer este despliegue.',
        'Export this deployment.' => 'Exportar este despliegue.',

        # Template: AdminSystemConfigurationDeploymentHistoryDetails
        'Deployment Details' => 'Detalles del despliegue',
        'by' => 'por',
        'No settings have been deployed in this run.' => 'No se ha desplegado ninguna configuración en esta ejecución.',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Este grupo no contiene ninguna configuración. Por favor, intente navegar a uno de sus subgrupos.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importación y exportación',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Cargue un archivo para importarlo a su sistema (formato .yml como el exportado desde el módulo de configuración del sistema).',
        'Upload system configuration' => 'Cargar la configuración del sistema',
        'Import system configuration' => 'Importar la configuración del sistema',
        'Download current configuration settings of your system in a .yml file.' =>
            'Descargue los ajustes de configuración actuales de su sistema en un archivo .yml.',
        'Include user settings' => 'Incluir la configuración del usuario',
        'Export current configuration' => 'Exportar la configuración actual',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Buscar por',
        'Search for category' => 'Buscar categoria',
        'Settings I\'m currently editing' => 'Ajustes que estoy editando actualmente',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Su búsqueda de "%s" en la categoría "%s" no ha dado ningún resultado.',
        'Your search for "%s" in category "%s" returned one result.' => 'Su búsqueda de "%s" en la categoría "%s" ha dado un resultado.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Su búsqueda de "%s" en la categoría "%s" ha dado %s resultados.',
        'You\'re currently not editing any settings.' => 'Actualmente no estás editando ninguna configuración.',
        'You\'re currently editing %s setting(s).' => 'Estás editando %s ajustes.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Categoría',
        'Run search' => 'Ejecutar la búsqueda',

        # Template: AdminSystemConfigurationSettingHistoryDetails
        'Change History' => 'Modificar el historial',
        'Change History of %s' => 'Historial de cambios de %s',
        'No modified values for this setting, the default value is used.' =>
            'No hay valores modificados para este ajuste, se utiliza el valor por defecto.',

        # Template: AdminSystemConfigurationUserModifiedDetails
        'Review users setting value' => 'Revisar el valor de ajuste de los usuarios',
        'Users Value' => 'Valor de los usuarios',
        'For' => 'Para',
        'Delete all user values.' => 'Borrar todos los valores del usuario.',
        'No user value for this setting.' => 'No hay valor de usuario para este ajuste.',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => 'Ver una lista personalizada de ajustes',
        'View single Setting: %s' => 'Ver un solo ajuste: %s',
        'Go back to Deployment Details' => 'Volver a los Detalles del despliegue',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Gestión de Mantenimiento del Sistema',
        'Schedule New System Maintenance' => 'Programas Nuevo Mantenimiento del Sistema',
        'Filter for System Maintenances' => 'Filtro para el mantenimiento del sistema',
        'Filter for system maintenances' => 'Filtro para el mantenimiento del sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Programe un periodo de mantenimiento del sistema para anunciar a los Agentes y Clientes que el sistema está fuera de servicio durante un periodo de tiempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Un tiempo antes de que comience el mantenimiento del sistema, los usuarios recibirán una notificación en cada pantalla anunciando este proceso.',
        'Stop date' => 'Fecha de Finalización',
        'Delete System Maintenance' => 'Eliminar Mantenimiento del Sisema',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Editar el mantenimiento del sistema',
        'Edit System Maintenance Information' => 'Editar la información de mantenimiento del sistema',
        'Date invalid!' => '¡Fecha inválida!',
        'Login message' => 'Mensaje de inicio de sesión',
        'This field must have less then 250 characters.' => 'Este campo debe tener menos de 250 caracteres.',
        'Show login message' => 'Mostrar mensaje de inicio de sesión',
        'Notify message' => 'Mensaje de notificación',
        'Manage Sessions' => 'Gestionar Sesiones',
        'All Sessions' => 'Todas las Sesiones',
        'Agent Sessions' => 'Sesiones de Agentes',
        'Customer Sessions' => 'Sesiones de Clientes',
        'Kill all Sessions, except for your own' => 'Matar todas las Sesiones, excepto su propia sesión',

        # Template: AdminTemplate
        'Template Management' => 'Gestión de plantillas',
        'Add Template' => 'Agregar Plantilla',
        'Edit Template' => 'Editar Plantilla',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Una plantilla es un texto predeterminado que ayuda a sus agentes a escribir más rápidamente los tickets, las respuestas o los reenvíos.',
        'Don\'t forget to add new templates to queues.' => 'No olvide agregar las plantillas nuevas a las colas de espera.',
        'Attachments' => 'Anexos',
        'Delete this entry' => 'Eliminar esta entrada',
        'Do you really want to delete this template?' => '¿Realmente quieres eliminar esta plantilla?',
        'A standard template with this name already exists!' => '¡Ya existe una plantilla estándar con este nombre!',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Para obtener los primeros 20 caracteres del asunto del actual/último artículo del agente (actual para Responder y Reenviar, último para el tipo Nota de plantilla ). Esta etiqueta no es compatible con otros tipos de plantillas.',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Para obtener las 5 primeras líneas del cuerpo del artículo del agente actual/último (actual para Respuesta y Avance, último para el tipo Nota de plantilla ). Esta etiqueta no es compatible con otros tipos de plantillas.',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Para obtener los primeros 20 caracteres del asunto del artículo actual/último (actual para Responder y Reenviar, último para el tipo Nota de plantilla ). Esta etiqueta no es compatible con otros tipos de plantillas.',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            'Para obtener las 5 primeras líneas del cuerpo del artículo actual/último (actual para Respuesta y Avance, último para el tipo Nota de plantilla ). Esta etiqueta no es compatible con otros tipos de plantillas.',
        'Create type templates only supports this smart tags' => 'Crear tipos de plantillas que sólo admitan estas etiquetas inteligentes',
        'Example template' => 'Plantilla de ejemplo',
        'The current ticket state is' => 'El estado actual del ticket es',
        'Your email address is' => 'Su dirección de correo electrónico es',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Gestionar las relaciones entre plantillas y archivos adjuntos',
        'Toggle active for all' => 'Activar para todos',
        'Link %s to selected %s' => 'Vínculo %s a %s seleccionados(as)',

        # Template: AdminType
        'Type Management' => 'Administración de Tipos',
        'Add Type' => 'Añadir Tipo',
        'Edit Type' => 'Modificar Tipo',
        'Filter for Types' => 'Filtro por tipos',
        'Filter for types' => 'Filtro por tipos',
        'A type with this name already exists!' => '¡Ya existe un tipo con este nombre!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Este tipo está presente en un ajuste de SysConfig, ¡se necesita confirmación para actualizar los ajustes para que apunten al nuevo tipo!',
        'This type is used in the following config settings:' => 'Este tipo se utiliza en los siguientes ajustes de configuración:',

        # Template: AdminUser
        'Agent Management' => 'Gestión de Agentes',
        'Edit Agent' => 'Modificar Agente',
        'Edit personal preferences for this agent' => 'Modifica las preferencias personales para este agente',
        'Agents will be needed to handle tickets.' => 'Los agentes se requieren para que se encarguen de los tickets.',
        'Don\'t forget to add a new agent to groups and/or roles!' => '¡Recuerde añadir a los agentes nuevos a grupos y/o roles!',
        'Please enter a search term to look for agents.' => 'Por favor, introduzca un parámetro de búsqueda para buscar agentes.',
        'Last login' => 'Último inicio de sesión',
        'Switch to agent' => 'Cambiar a agente',
        'Title or salutation' => 'Título o saludo',
        'Firstname' => 'Nombre',
        'Lastname' => 'Apellido',
        'A user with this username already exists!' => '¡Ya existe un usuario con el mismo nombre se usuario!',
        'Will be auto-generated if left empty.' => 'Si se deja vació, será generado automáticamente.',
        'Mobile' => 'Móvil',
        'Effective Permissions for Agent' => 'Permisos efectivos para el agente',
        'This agent has no group permissions.' => 'Este agente no tiene permisos de grupo.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'La tabla anterior muestra los permisos de grupo efectivos para el agente. La matriz tiene en cuenta todos los permisos heredados (por ejemplo, a través de los roles).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gestionar Relaciones Agente-Grupo',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Resumen de la Agenda',
        'Manage Calendars' => 'Gestionar Calendarios',
        'Add Appointment' => 'Añadir Cita',
        'Today' => 'Hoy',
        'All-day' => 'Todo el día',
        'Repeat' => 'Repetición',
        'Notification' => 'Notificaciones',
        'Yes' => 'Sí',
        'No' => 'No',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'No se encontraron calendario. Por favor primero añada un calendario utilizado la pagina de Gestionar Calendarios.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Añadir nueva cita',
        'Calendars' => 'Calendarios',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Información básica',
        'Date/Time' => 'Fecha/Hora',
        'Invalid date!' => '¡Fecha inválida!',
        'Please set this to value before End date.' => 'Por favor fije este valor antes de la fecha de término.',
        'Please set this to value after Start date.' => 'Por favor fije este valor después de la fecha de inicio.',
        'This an occurrence of a repeating appointment.' => 'Esta es una ocurrencia de una cita repetitiva.',
        'Click here to see the parent appointment.' => 'Clic aquí para ver la cita padre.',
        'Click here to edit the parent appointment.' => 'Clic aquí para editar la cita padre.',
        'Frequency' => 'Frecuencia',
        'Every' => 'Cada',
        'day(s)' => 'día(s)',
        'week(s)' => 'semana(s)',
        'month(s)' => 'mes(es)',
        'year(s)' => 'año(s)',
        'On' => 'Encendido',
        'Monday' => 'Lunes',
        'Mon' => 'Lun',
        'Tuesday' => 'Martes',
        'Tue' => 'Mar',
        'Wednesday' => 'Miércoles',
        'Wed' => 'Mié',
        'Thursday' => 'Jueves',
        'Thu' => 'Jue',
        'Friday' => 'Viernes',
        'Fri' => 'Vie',
        'Saturday' => 'Sábado',
        'Sat' => 'Sáb',
        'Sunday' => 'Domingo',
        'Sun' => 'Dom',
        'January' => 'Enero',
        'Jan' => 'Ene',
        'February' => 'Febrero',
        'Feb' => 'Feb',
        'March' => 'Marzo',
        'Mar' => 'Mar',
        'April' => 'Abril',
        'Apr' => 'Abr',
        'May_long' => 'Mayo',
        'May' => 'May',
        'June' => 'Junio',
        'Jun' => 'Jun',
        'July' => 'Julio',
        'Jul' => 'Jul',
        'August' => 'Agosto',
        'Aug' => 'Ago',
        'September' => 'Septiembre',
        'Sep' => 'Sep',
        'October' => 'Octubre',
        'Oct' => 'Oct',
        'November' => 'Noviembre',
        'Nov' => 'Nov',
        'December' => 'Diciembre',
        'Dec' => 'Dic',
        'Relative point of time' => 'Punto de tiempo relativo',
        'Link' => 'Enlazar',
        'Remove entry' => 'Eliminar entrada',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de Información de Clientes',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Usuario del Cliente',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: ¡El cliente es inválido!',
        'Start chat' => 'Iniciar chat',
        'Video call' => 'Video llamada',
        'Audio call' => 'Audio llamada',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Libreta de Direcciones del Usuario del Cliente',
        'Search for recipients and add the results as \'%s\'.' => 'Busca los destinatarios y añade los resultados como "%s".',
        'Search template' => 'Buscar-Modelo',
        'Create Template' => 'Crear Plantilla',
        'Create New' => 'Crear Nuevo(a)',
        'Save changes in template' => 'Guardar los cambios en la plantilla',
        'Filters in use' => 'Filtros en uso',
        'Additional filters' => 'Filtros Adicionales',
        'Add another attribute' => 'Añadir otro atributo',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Los atributos con el identificador \'(Cliente)\' son de la empresa cliente.',
        '(e. g. Term* or *Term*)' => '(Ejemplo:. Term* o *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Seleccionar todos',
        'The customer user is already selected in the ticket mask.' => 'El usuario cliente ya está seleccionado en la máscara del ticket.',
        'Select this customer user' => 'Selecciona el usuario del cliente',
        'Add selected customer user to' => 'Agregar el usuario del cliente seleccionado a',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Cambiar opciones de búsqueda',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centro de Información de Usuario del Cliente',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'El Servicio OTOBO es un proceso de servicio que efectúa tareas asíncronas, por ejemplo disparo de escalada de tickets, envío de emails, etc.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'Es indispensable que el Demonio de OTOBO esté ejecutándose para que el sistema opere correctamente.',
        'Starting the OTOBO Daemon' => 'Iniciando el Demonio de OTOBO',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Asegúrese de que el archivo \'%s\' existe (sin extensión .dist). Esta tarea cron comprobará cada 5 minutos si el demonio OTOBO se está ejecutando y lo iniciará si es necesario.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Ejecuta \'%s start\' para asegurarte de que las tareas cron del usuario \'otobo\' están activas.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Después de 5 minutos, compruebe que el demonio OTOBO está funcionando en el sistema (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Panel principal',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Nueva Cita',
        'Tomorrow' => 'Mañana',
        'Soon' => 'Pronto',
        '5 days' => '5 días',
        'Start' => 'Iniciar',
        'none' => 'ninguno',

        # Template: AgentDashboardCalendarOverview
        'in' => 'en',

        # Template: AgentDashboardCommon
        'Save settings' => 'Grabar configuración',
        'Close this widget' => 'Cerrar este widget',
        'more' => 'más',
        'Available Columns' => 'Columnas Disponibles',
        'Visible Columns (order by drag & drop)' => 'Columnas Visibles (ordenar arrastrando y soltando)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Cambiar las relaciones con los clientes',
        'Open' => 'Abierto',
        'Closed' => 'Cerrado',
        '%s open ticket(s) of %s' => '%s tickets abiertos de %s',
        '%s closed ticket(s) of %s' => '%s tickets cerrados de %s',
        'Edit customer ID' => 'Editar el ID del cliente',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Tickets Escalados',
        'Open tickets' => 'Tickets abiertos',
        'Closed tickets' => 'Tickets cerrados',
        'All tickets' => 'Todos los tickets',
        'Archived tickets' => 'Tickets Archivados',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Nota: ¡Usuario del Cliente inválido!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Información del usuario del cliente',
        'Phone ticket' => 'Teléfono del ticket',
        'Email ticket' => 'Email del ticket',
        'New phone ticket from %s' => 'Nuevo ticket telefónico de %s',
        'New email ticket to %s' => 'Nuevo ticket por correo para %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponible!',
        'Please update now.' => 'Por favor, actualice ahora.',
        'Release Note' => 'Notas del Lanzamiento',
        'Level' => 'Nivel',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Enviado hace %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'La configuración de este widget estadístico contiene errores, por favor revise su configuración.',
        'Download as SVG file' => 'Descargar como archivo SVG',
        'Download as PNG file' => 'Descargar como archivo PNG',
        'Download as CSV file' => 'Descargar como archivo CSV',
        'Download as Excel file' => 'Descargar como archivo de Excel',
        'Download as PDF file' => 'Descargar como archivo PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Por favor, seleccione un formato válido de salida para el gráfico en la configuración de este widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'El contenido de esta estadística se está preparando para usted, por favor sea paciente.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Esta estadística no puede utilizarse actualmente porque su configuración debe ser corregida por el administrador de estadísticas.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Asignado al usuario del cliente',
        'Accessible for customer user' => 'Accesible para el usuario del cliente',
        'My locked tickets' => 'Mis tickets bloqueados',
        'My watched tickets' => 'Mis tickes en seguimiento',
        'My responsibilities' => 'Mis responsabilidades',
        'Tickets in My Queues' => 'Tickets en Mis Colas',
        'Tickets in My Services' => 'Tickets en Mis Servicios',
        'Service Time' => 'Tiempo de Servicio',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Total',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fuera de la oficina',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'hasta',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Atrás',
        'Detailed search' => 'Búsqueda detallada',
        'Add an additional attribute' => 'Añadir un atributo adicional',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => 'Ver detalles',

        # Template: AgentElasticsearchQuickResult
        'Tickets' => 'Tickets',
        'ConfigItems' => 'Elementos de configuración',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Para aceptar noticias, una licencia o algunos cambios.',
        'Yes, accepted.' => 'Sí, aceptado.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Gestionar enlaces para %s',
        'Create new links' => 'Crear nuevos enlaces',
        'Manage existing links' => 'Gestionar los enlaces existentes',
        'Link with' => 'Enlace con',
        'Start search' => 'Iniciar la búsqueda',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Actualmente no hay enlaces. Por favor, haga clic en "Crear nuevos enlaces" en la parte superior para vincular este elemento a otros objetos.',

        # Template: AgentPassword
        'Password Policy' => 'Política de contraseñas',
        'Your current password is older than %s days. You need to set a new one.' =>
            'Su contraseña actual tiene más de %s días. Necesitas establecer una nueva.',
        'Change password' => 'Cambiar contraseña',
        'Current password' => 'Contraseña actual',
        'New password' => 'Nueva contraseña',
        'Repeat new password' => 'Repetir la nueva contraseña',
        'Password needs to be renewed every %s days.' => 'La contraseña debe renovarse cada %s días.',
        'Password history is active, you can\'t use a password which was used the last %s times.' =>
            'El historial de contraseñas está activo, no se puede utilizar una contraseña que se haya usado las últimas %s veces.',
        'Password length must be at least %s characters.' => 'La longitud de la contraseña debe ser de al menos %s caracteres.',
        'Password requires at least two lower- and two uppercase characters.' =>
            'La contraseña requiere al menos dos caracteres en minúscula y dos en mayúscula.',
        'Password requires at least two characters.' => 'La contraseña requiere al menos dos caracteres.',
        'Password requires at least one digit.' => 'La contraseña requiere al menos un dígito.',
        'Change config options' => 'Cambiar las opciones de configuración',
        'Admin permissions are required!' => '¡Se requieren permisos de administrador!',

        # Template: AgentPreferences
        'Edit your preferences' => 'Modificar mis preferencias',
        'Personal Preferences' => 'Preferencias Personales',
        'Preferences' => 'Preferencias',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Por favor, tenga en cuenta que está editando las preferencias de %s.',
        'Go back to editing this agent' => 'Volver a editar este agente',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Configure sus preferencias personales. Guarde cada configuración haciendo click en los cuadros de selección a la derecha.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Puede utilizar el árbol de navegación de abajo para mostrar sólo los ajustes de ciertos grupos.',
        'Dynamic Actions' => 'Acciones dinámicas',
        'Filter settings...' => 'Ajustes del filtro...',
        'Filter for settings' => 'Filtro para la configuración',
        'Save all settings' => 'Guardar todos los ajustes',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Los avatares han sido desactivados por el administrador del sistema. En su lugar verás tus iniciales.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Puedes cambiar la imagen de tu avatar registrándote con tu dirección de correo electrónico %s en %s. Tenga en cuenta que puede pasar algún tiempo hasta que su nuevo avatar esté disponible debido al almacenamiento en caché.',
        'Off' => 'Apagado',
        'End' => 'Fin',
        'This setting can currently not be saved.' => 'Actualmente, este ajuste no se puede guardar.',
        'This setting can currently not be saved' => 'Este ajuste no se puede guardar actualmente',
        'Save this setting' => 'Guardar este ajuste',
        'Did you know? You can help translating OTOBO at %s.' => '¿Sabías que? Puedes ayudar a traducir OTOBO en %s.',

        # Template: SettingsList
        'Reset to default' => 'Restablecer los valores por defecto',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Elija entre los grupos de la derecha para encontrar los ajustes que desea cambiar.',
        'Did you know?' => '¿Sabía qué?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Puedes cambiar tu avatar registrándote con tu dirección de correo electrónico %s en %s',

        # Template: AgentSplitSelection
        'Target' => 'Objetivo',
        'Process' => 'Proceso',
        'Split' => 'Separar',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Gestión de estadísticas',
        'Add Statistics' => 'Añadir estadísticas',
        'Read more about statistics in OTOBO' => 'Más información sobre las estadísticas en OTOBO',
        'Dynamic Matrix' => 'Matriz Dinámica',
        'Each cell contains a singular data point.' => 'Cada celda contiene un punto de datos singular.',
        'Dynamic List' => 'Lista Dinámica',
        'Each row contains data of one entity.' => 'Cada fila contiene datos de una entidad.',
        'Static' => 'Estático',
        'Non-configurable complex statistics.' => 'Estadísticas complejas no configurables.',
        'General Specification' => 'Especificación General',
        'Create Statistic' => 'Crear Estádística',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Editar estadísticas',
        'Run now' => 'Ejecutar ahora',
        'Statistics Preview' => 'Vista Previa de Estadísticas',
        'Save Statistic' => 'Guardar la estadística',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Importar estadísticas',
        'Import Statistics Configuration' => 'Importar configuración de estadísticas',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Estadísticas',
        'Run' => 'Ejecutar',
        'Edit statistic "%s".' => 'Editar estadística "%s".',
        'Export statistic "%s"' => 'Exportar estadística "%s"',
        'Export statistic %s' => 'Exportar estadística %s',
        'Delete statistic "%s"' => 'Eliminar estadística "%s"',
        'Delete statistic %s' => 'Eliminar estadística %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Resumen de estadísticas',
        'View Statistics' => 'Ver estadísticas',
        'Statistics Information' => 'Información de estadísticas',
        'Created by' => 'Creado por',
        'Changed by' => 'Modificado por',
        'Sum rows' => 'Sumar filas',
        'Sum columns' => 'Sumar columnas',
        'Show as dashboard widget' => 'Mostrar como widget en el panel principal',
        'Cache' => 'Caché',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Esta estadísticas contiene errores de configuración y no puede ser utilizada en este momento.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Cambiar el texto de %s%s%s',
        'Change Owner of %s%s%s' => 'Cambiar el propietario de %s%s%s',
        'Close %s%s%s' => 'Cerrar %s%s%s',
        'Add Note to %s%s%s' => 'Añadir nota a %s%s%s',
        'Set Pending Time for %s%s%s' => 'Fijar la hora de espera para %s%s%s',
        'Change Priority of %s%s%s' => 'Cambiar la prioridad de %s%s%s',
        'Change Responsible of %s%s%s' => 'Cambio Responsable de %s%s%s',
        'The ticket has been locked' => 'El ticket ha sido bloqueado',
        'Undo & close' => 'Deshacer cambios y cerrar',
        'Ticket Settings' => 'Configuraciones de Ticket',
        'Queue invalid.' => 'Fila Inválida.',
        'Service invalid.' => 'Servicio inválido.',
        'SLA invalid.' => 'SLA inválido.',
        'New Owner' => 'Propietario nuevo',
        'Please set a new owner!' => '¡Por favor, defina un propietario nuevo!',
        'Owner invalid.' => 'Propietario inválido.',
        'New Responsible' => 'Nuevo Responsable',
        'Please set a new responsible!' => 'Por favor, ¡asigne un nuevo responsable!',
        'Responsible invalid.' => 'Responsable inválido.',
        'Next state' => 'Siguiente estado',
        'State invalid.' => 'Estado inválido.',
        'For all pending* states.' => 'Para todos los estados pendientes*.',
        'Add Article' => 'Añadir Artículo',
        'Create an Article' => 'Crear un Artículo',
        'Inform agents' => 'Informar a los agentes',
        'Inform involved agents' => 'Informar a los agentes involucrados',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aquí puede seleccionar agentes adicionales que deben recibir una notificación sobre el nuevo artículo.',
        'Text will also be received by' => 'El texto también será recibido por',
        'Text Template' => 'Plantilla de texto',
        'Setting a template will overwrite any text or attachment.' => 'Establecer una plantilla sobrescribirá cualquier texto o adjunto.',
        'Invalid time!' => '¡Hora inválida!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Rebote %s%s%s',
        'Bounce to' => 'Rebotar a',
        'You need a email address.' => 'Se requiere una dirección de correo electrónico.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Se requiere una dirección de correo electrónica válida, que no sea local.',
        'Next ticket state' => 'Nuevo estado del ticket',
        'Inform sender' => 'Informar al emisor',
        'Send mail' => 'Enviar correo',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Acción múltiple con Tickets',
        'Send Email' => 'Enviar correo',
        'Merge' => 'Mezclar',
        'Merge to' => 'Fusionar con',
        'Invalid ticket identifier!' => '¡Identificador de ticket inválido!',
        'Merge to oldest' => 'Combinar con el mas viejo',
        'Link together' => 'Enlazar juntos',
        'Link to parent' => 'Enlazar al padre',
        'Unlock tickets' => 'Desbloquear tickets',
        'Execute Bulk Action' => 'Ejecutar acción masiva',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Componer la respuesta para %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Esta dirección está registrada como una dirección del sistema y no puede ser usada: %s',
        'Please include at least one recipient' => 'Incluya al menos un destinatario',
        'Select one or more recipients from the customer user address book.' =>
            'Seleccione uno o mas destinatarios de la libreta de direcciones del usuario del cliente.',
        'Customer user address book' => 'Libreta de direcciones del usuario del cliente',
        'Remove Ticket Customer' => 'Eliminar al cliente del ticket',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Elimine esta entrada e introduzca una nueva con el valor correcto.',
        'This address already exists on the address list.' => 'Esta dirección ya existe en la lista de direcciones.',
        'Remove Cc' => 'Eliminar Copia para',
        'Bcc' => 'Copia Oculta',
        'Remove Bcc' => 'Eliminar Copia oculta',
        'Date Invalid!' => '¡Fecha Inválida!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Cambiar cliente de %s%s%s',
        'Customer Information' => 'Información del Cliente',
        'Customer user' => 'Usuario del cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Crear un Ticket nuevo de Correo Electrónico',
        'Example Template' => 'Plantilla de Ejemplo',
        'To customer user' => 'Al usuario del cliente',
        'Please include at least one customer user for the ticket.' => 'Por favor, incluya en el ticket al menos un usuario del cliente.',
        'Select this customer as the main customer.' => 'Seleccionar a este cliente como el cliente principal.',
        'Remove Ticket Customer User' => 'Eliminar del Ticket al Usuario del Cliente',
        'From queue' => 'De la fila',
        'Get all' => 'Obtener todos',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Correo electrónico de salida para %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Reenviar correo electrónico para %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Ticket %s: ¡el primer tiempo de respuesta ha terminado (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Ticket %s: ¡el tiempo de primera respuesta terminará en %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Ticket %s: ¡el tiempo de actualización ha terminado (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Ticket %s: ¡el tiempo de actualización terminará en %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Ticket %s: ¡el tiempo de solución ha terminado (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Ticket %s: ¡el tiempo de solución terminará en %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Adelante %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Historia de %s%s%s',
        'Filter for history items' => 'Filtro para los elementos del historial',
        'Expand/collapse all' => 'Expandir/contraer todo',
        'CreateTime' => 'Crear tiempo',
        'Article' => 'Artículo',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Combinar %s%s%s',
        'Merge Settings' => 'Unir Configuraciones',
        'You need to use a ticket number!' => '¡Necesita usar un número de ticket!',
        'A valid ticket number is required.' => 'Se requiere un número de ticket válido.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Intente escribir parte del número de ticket o el título para buscarlo.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Limitar la búsqueda a los tickets con el mismo ID de cliente (%s).',
        'Inform Sender' => 'Informar al emisor',
        'Need a valid email address.' => 'Se require una dirección de correo electrónica válida.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Mover %s%s%s',
        'New Queue' => 'Fila Nueva',
        'Move' => 'Mover',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'No se encontraron datos de ticket.',
        'Open / Close ticket action menu' => 'Abrir / Cerrar el Menú de acción del ticket',
        'Select this ticket' => 'Seleccionar este ticket',
        'Sender' => 'Emisor',
        'First Response Time' => 'Tiempo para Primera Respuesta',
        'Update Time' => 'Tiempo para Actualización',
        'Solution Time' => 'Tiempo para Solución',
        'Move ticket to a different queue' => 'Mover ticket a una fila diferente',
        'Change queue' => 'Modificar fila',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Eliminar los filtros activos para esta pantalla.',
        'Tickets per page' => 'Tickets por página',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Canal ausente',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Restablecer la vista general',
        'Column Filters Form' => 'Formulario de filtros de columna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir En Nuevo Ticket Telefónico',
        'Save Chat Into New Phone Ticket' => 'Guardar Chat En Nuevo Ticket Telefónico',
        'Create New Phone Ticket' => 'Crear un Ticket Telefónico Nuevo',
        'Please include at least one customer for the ticket.' => 'Por favor, Incluya al menos un cliente para el ticket.',
        'To queue' => 'Para la fila',
        'Chat protocol' => 'Protocolo de Chat',
        'The chat will be appended as a separate article.' => 'El chat se agregará como un artículo separado.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Llamada telefónica para %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Ver el texto sin formato del correo electrónico de %s%s%s',
        'Plain' => 'Texto plano',
        'Download this email' => 'Descargar este correo electrónico',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Crear Nuevo Ticket de Proceso',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Registrar Ticket en un Proceso',

        # Template: AgentTicketSearch
        'Profile link' => 'Enlace al perfil',
        'Output' => 'Modelo de Resultados',
        'Fulltext' => 'Texto Completo',
        'Customer ID (complex search)' => 'ID de cliente (búsqueda compleja)',
        '(e. g. 234*)' => '(por ejemplo, 234*)',
        'Customer ID (exact match)' => 'ID del cliente (coincidencia exacta)',
        'Assigned to Customer User Login (complex search)' => 'Asignado al inicio de sesión del usuario cliente (búsqueda compleja)',
        '(e. g. U51*)' => '(por ejemplo, U51*)',
        'Assigned to Customer User Login (exact match)' => 'Asignado al inicio de sesión del usuario cliente (coincidencia exacta)',
        'Accessible to Customer User Login (exact match)' => 'Accesible para el inicio de sesión del cliente (coincidencia exacta)',
        'Created in Queue' => 'Creado en la Fila',
        'Lock state' => 'Estado de bloqueo',
        'Watcher' => 'Observador',
        'Article Create Time (before/after)' => 'Hora de Creación del Artículo (antes/después)',
        'Article Create Time (between)' => 'Hora de Creación del Artículo (entre)',
        'Please set this to value before end date.' => 'Por favor, ponga este valor antes de la fecha de finalización.',
        'Please set this to value after start date.' => 'Por favor, establezca este valor después de la fecha de inicio.',
        'Ticket Create Time (before/after)' => 'Hora de Creación del Ticket (antes/después)',
        'Ticket Create Time (between)' => 'Hora de Creación del Ticket (entre)',
        'Ticket Change Time (before/after)' => 'Hora de Modificación del Ticket (antes/después)',
        'Ticket Change Time (between)' => 'Hora de Modificación del Ticket (entre)',
        'Ticket Last Change Time (before/after)' => 'Hora de la Última Modificación del Ticket (antes/después)',
        'Ticket Last Change Time (between)' => 'Hora de la Última Modificación del Ticket (entre)',
        'Ticket Pending Until Time (before/after)' => 'Ticket pendiente hasta la hora (antes/después)',
        'Ticket Pending Until Time (between)' => 'Ticket pendiente hasta la hora (entre)',
        'Ticket Close Time (before/after)' => 'Hora en que fue Cerrado del Ticket (antes/después)',
        'Ticket Close Time (between)' => 'Hora en que fue Cerrado del Ticket (entre)',
        'Ticket Escalation Time (before/after)' => 'Hora en que fue Escalado el Ticket (antes/después)',
        'Ticket Escalation Time (between)' => 'Hora en que fue Escalado el Ticket (entre)',
        'Archive Search' => 'Búsqueda de Archivo',

        # Template: AgentTicketZoom
        'Sender Type' => 'Tipo de remitente',
        'Save filter settings as default' => 'Grabar configuración de filtros como defecto',
        'Event Type' => 'Tipo de Evento',
        'Save as default' => 'Guardar como predeterminado',
        'Drafts' => 'Borradores',
        'Change Queue' => 'Cambiar Fila',
        'There are no dialogs available at this point in the process.' =>
            'No hay diálogos disponibles en este punto del proceso.',
        'This item has no articles yet.' => 'Este ítem todavía no tiene ningún artículo.',
        'Ticket Timeline View' => 'Vista de Linea Temporal del Ticket',
        'Article Overview - %s Article(s)' => 'Resumen del Artículo - %s Artículo(s)',
        'Page %s' => 'Página %s',
        'Add Filter' => 'Añadir Filtro',
        'Set' => 'Ajustar',
        'Reset Filter' => 'Restablecer Filtro',
        'No.' => 'Núm.',
        'Unread articles' => 'Artículos no leídos',
        'Via' => 'A través de',
        'Important' => 'Importante',
        'Unread Article!' => '¡Artículo sin leer!',
        'Incoming message' => 'Mensaje entrante',
        'Outgoing message' => 'Mensaje saliente',
        'Internal message' => 'Mensaje interno',
        'Sending of this message has failed.' => 'El envío de este mensaje ha fallado.',
        'Resize' => 'Cambiar el tamaño',
        'Mark this article as read' => 'Marcar este artículo como leído',
        'Show Full Text' => 'Mostrar Texto Completo',
        'Full Article Text' => 'Texto Completo del Artículo',
        'No more events found. Please try changing the filter settings.' =>
            'No se encontraron más eventos. Por favor, pruebe cambiando las configuraciones del filtro.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'a través de %s',
        'by %s' => 'por %s',
        'Toggle article details' => 'Alternar los detalles del artículo',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Este mensaje está siendo procesado. Ya se ha intentado enviar %s veces. El próximo intento será %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir los enlaces en el siguiente artículo, es posible que usted tenga que pulsar Ctrl o Cmd o la tecla Mayús mientras hace click en el enlace (dependiendo de su navegador y sistema operativo).',
        'Close this message' => 'Cerrar este mensaje',
        'Image' => 'Imágen',
        'PDF' => 'PDF',
        'Unknown' => 'Desconocido',
        'View' => 'Ver',

        # Template: LinkTable
        'Linked Objects' => 'Objetos Enlazados',

        # Template: TicketInformation
        'Archive' => 'Archivar',
        'This ticket is archived.' => 'Este ticket está archivado.',
        'Note: Type is invalid!' => 'Nota: El tipo es inválido!',
        'Pending till' => 'Pendiente hasta',
        'Locked' => 'Bloqueado',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Tiempo contabilizado',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'La vista previa de este artículo no es posible porque falta el canal %s en el sistema.',
        'Please re-install %s package in order to display this article.' =>
            'Por favor, reinstale el paquete %s para poder mostrar este artículo.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para proteger su privacidad, el contenido remoto fue bloqueado.',
        'Load blocked content.' => 'Cargar contenido bloqueado.',

        # Template: Breadcrumb
        'Home' => 'Inicio',
        'Back to admin overview' => 'Volver a la vista general de administrador',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Esta función requiere servicios en la nube',
        'You can' => 'Usted puede',
        'go back to the previous page' => 'regresar a la página anterior',

        # Template: CustomerAccept
        'Mit einem Klick erkläre ich meine Zustimmung.' => 'Con un clic declaro mi consentimiento.',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'El ID de cliente no es modificable, no se puede asignar ningún otro ID de cliente a este ticket.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Primero seleccione un usuario cliente, luego puede seleccionar un ID de cliente para asignar a este ticket.',
        'Select a customer ID to assign to this ticket.' => 'Seleccione un ID de cliente para asignar a este ticket.',
        'From all Customer IDs' => 'De todos los ID de clientes',
        'From assigned Customer IDs' => 'De todos los ID de clientes asignadas',

        # Template: CustomerDashboard
        'Ticket Search' => 'Búsqueda de ticket',
        'New Ticket' => 'Nuevo Ticket',

        # Template: CustomerError
        'An Error Occurred' => 'Se ha producido un error',
        'Error Details' => 'Detalles del error',
        'Traceback' => 'Determinar el origen',

        # Template: CustomerFooter
        'Powered by %s' => 'Desarrollado por %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s ha detectado posibles problemas de red. Puedes intentar recargar esta página manualmente o esperar a que tu navegador restablezca la conexión por sí mismo.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Se ha restablecido la conexión tras una pérdida temporal de la misma. Debido a esto, los elementos de esta página podrían haber dejado de funcionar correctamente. Para poder volver a utilizar todos los elementos correctamente, se recomienda encarecidamente recargar esta página.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript No Disponible',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Para poder disfrutar de este software, tendrá que activar JavaScript en su navegador.',
        'Browser Warning' => 'Advertencia del Explorador',
        'The browser you are using is too old.' => 'El explorador que está usando es muy antiguo.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Este software funciona con una enorme lista de navegadores, por favor, actualice a uno de ellos.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, refiérase a la documentación o pregunte a su administrador para obtener más información.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            'El navegador que estás utilizando no soporta css-grid. Es probable que sea demasiado antiguo.',
        'Internet Explorer is functional, but not all features are fully supported. Please consider updating to a modern browser.' =>
            'Internet Explorer es funcional, pero no todas las características son totalmente compatibles. Por favor, considere la posibilidad de actualizar a un navegador moderno.',
        'One moment please, you are being redirected...' => 'Un momento por favor, está siendo redirigido...',
        'Login' => 'Inicio de sesión',
        'Your user name' => 'Su nombre de usuario',
        'User name' => 'Nombre de usuario',
        'Your password' => 'Su contraseña',
        'Forgot password?' => '¿Olvidó su contraseña?',
        'Your 2 Factor Token' => 'Su token de 2 factores',
        '2 Factor Token' => 'Token de 2 factores',
        'Log In' => 'Iniciar sesión',
        'Request Account' => 'Solicitar cuenta',
        'Request New Password' => 'Solicite una Contraseña Nueva',
        'Your User Name' => 'Su Nombre de Usuario',
        'A new password will be sent to your email address.' => 'Una contraseña nueva se enviará a su dirección de correo electrónico.',
        'Create Account' => 'Crear Cuenta',
        'Please fill out this form to receive login credentials.' => 'Por favor llene los campos de este formulario para recibir sus credenciales del sistema.',
        'How we should address you' => 'Cómo debemos contactarlo',
        'Your First Name' => 'Su Nombre',
        'Your Last Name' => 'Su Apellido',
        'Your email address (this will become your username)' => 'Su dirección de email (esta será su nombre de usuario)',

        # Template: CustomerNavigationBar
        'Logout' => 'Cerrar Sesión',

        # Template: CustomerPassword
        'Change Password' => 'Cambiar contraseña',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            'La contraseña debe contener al menos 3 de las clases de caracteres: minúscula, mayúscula, dígito, carácter especial.',

        # Template: CustomerTicketList
        'Nr.' => 'Nr.',
        'Welcome!' => '¡Bienvenido!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            'Todavía no tiene tickets. Por favor, haga clic aquí, para crear uno nuevo.',
        'Nothing to show.' => 'No hay nada que mostrar.',
        'Click here for an unfiltered list of all your tickets.' => 'Haga clic aquí para ver una lista no filtrada de todos sus tickets.',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => 'Crear un nuevo Ticket',
        'Service level agreement' => 'Acuerdo de nivel de servicio',

        # Template: CustomerTicketOverview
        'Your Tickets' => 'Sus tickets',
        'Page' => 'Página',
        'Sort' => 'Ordenar',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'Por ejemplo: 10*5155 ó 105658*',
        'CustomerID' => 'Identificador del cliente',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Búsqueda de texto completo en las entradas (por ejemplo, "John*n" o "Will*")',
        'Types' => 'Tipos',
        'Time Restrictions' => 'Restricciones de tiempo',
        'No time settings' => 'Sin ajustes de tiempo',
        'All' => 'Todo',
        'Specific date' => 'Fecha específica',
        'Only tickets created' => 'Únicamente tickets creados',
        'Date range' => 'Rango de fechas',
        'Only tickets created between' => 'Únicamente tickets creados entre',
        'Ticket Archive System' => 'Sistema de archivo de tickets',
        'Save Search as Template?' => '¿Guardar Búsqueda como Plantilla?',
        'Save as Template?' => '¿Guardar como Plantilla?',
        'Save as Template' => 'Guardar como Plantilla',
        'Template Name' => 'Nombre de la Plantilla',
        'Pick a profile name' => 'Seleccione un nombre para el perfil',
        'Output to' => 'Salida a',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Buscar Resultados para',
        'Remove this Search Term.' => 'Quitar este Término de Búsqueda.',

        # Template: CustomerTicketZoom
        'Reply' => 'Responder',
        'Discard' => 'Descartar',
        'Ticket Information' => 'Información del Ticket',
        'Categories' => 'Categorías',
        'Further actions' => 'Más acciones',

        # Template: Chat
        'Expand article' => 'Ampliar artículo',

        # Template: MIMEBase
        'Article Information' => 'Artículo de información',

        # Template: CustomerWarning
        'Warning' => 'Advertencia',

        # Template: TileNewTicket
        'Issue%sa ticket' => 'Emitir %s un ticket',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Información del Evento',
        'Ticket fields' => 'Campos del ticket',

        # Template: Error
        'Send a bugreport' => 'Enviar un reporte de error',
        'Expand' => 'Expandir',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Haga clic para eliminar este archivo adjunto.',

        # Template: DraftButtons
        'Update draft' => 'Actualizar borrador',
        'Save as new draft' => 'Guardar como borrador',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Has cargado el borrador "%s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Has cargado el borrador "%s". Lo has modificado por última vez %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Has cargado el borrador "%s". Fue modificado por última vez %s por %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Tenga en cuenta que este borrador está obsoleto porque el ticket fue modificado desde que se creó este borrador.',

        # Template: Header
        'Edit personal preferences' => 'Modificar preferencias presonales',
        'Personal preferences' => 'Preferencias personales',
        'You are logged in as' => 'Ud. inició sesión como',

        # Template: Installer
        'JavaScript not available' => 'JavaScript no disponible',
        'Step %s' => 'Paso %s',
        'License' => 'Licencia',
        'Database Settings' => 'Configuraciones de la Base de Datos',
        'General Specifications and Mail Settings' => 'Especificaciones Generales y Configuraciones de Correo',
        'Finish' => 'Finalizar',
        'Welcome to %s' => 'Bienvenido a %s',
        'Germany' => 'Alemania',
        'Phone' => 'Teléfono',
        'Web site' => 'Sitio web',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar Correo Saliente',
        'Outbound mail type' => 'Tipo de correo saliente',
        'Select outbound mail type.' => 'Seleccione el tipo de correo saliente.',
        'Outbound mail port' => 'Puerto para el correo saliente',
        'Select outbound mail port.' => 'Selecione el puerto para el correo saliente.',
        'SMTP host' => 'Host SMTP',
        'SMTP host.' => 'Host SMTP.',
        'SMTP authentication' => 'Autenticación SMTP',
        'Does your SMTP host need authentication?' => '¿Su host SMTP requiere autenticación?',
        'SMTP auth user' => 'Autenticación de usuario SMTP',
        'Username for SMTP auth.' => 'Nombre de usuario para la autenticación SMTP.',
        'SMTP auth password' => 'Contraseña de autenticación SMTP',
        'Password for SMTP auth.' => 'Contraseña para la autenticación SMTP.',
        'Configure Inbound Mail' => 'Configurar Correo Entrante',
        'Inbound mail type' => 'Tipo de correo entrante',
        'Select inbound mail type.' => 'eleccione el tipo de correo entrante.',
        'Inbound mail host' => 'Host del correo entrante',
        'Inbound mail host.' => 'Host del correo entrante.',
        'Inbound mail user' => 'Usuario del correo entrante',
        'User for inbound mail.' => 'Usuario para el correo entrante.',
        'Inbound mail password' => 'Contraseña del correo entrante',
        'Password for inbound mail.' => 'Contraseña para el correo entrante.',
        'Result of mail configuration check' => 'Resultado de la verificación de la configuración de correo',
        'Check mail configuration' => 'Verificar configuración de correo',
        'Skip this step' => 'Omitir este paso',

        # Template: InstallerDBResult
        'Done' => 'Hecho',
        'Error' => 'Error',
        'Database setup successful!' => '¡Base de Datos configurada con éxito!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de Instalación',
        'Create a new database for OTOBO' => 'Crear una nueva base de datos para OTOBO',
        'Use an existing database for OTOBO' => 'Usar una base de datos existente para OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Si ha establecido una contraseña para root en su base de datos, debe introducirla aquí. Si no, deje este campo en blanco.',
        'Database name' => 'Nombre de la Base de Datos',
        'Check database settings' => 'Verificar las configuraciones de la base de datos',
        'Result of database check' => 'Resultado de la verificación de la base de datos',
        'Database check successful.' => 'Verificación satisfactoria de la base de datos.',
        'Database User' => 'Usuario de la Base de Datos',
        'New' => 'Nuevo',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Un usuario nuevo, con permisos limitados, se creará en este sistema OTOBO, para la base de datos.',
        'Repeat Password' => 'Repetir Contraseña',
        'Generated password' => 'Generar contraseña',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Las contraseñas no coinciden',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar OTOBO debe escribir la siguiente línea en la consola de sistema (Terminal/Shell) como usuario root.',
        'Restart your webserver' => 'Reinicie su servidor web',
        'After doing so your OTOBO is up and running.' => 'Después de hacer esto, su OTOBO estará activo y ejecutándose.',
        'Start page' => 'Página de inicio',
        'Your OTOBO Team' => 'Su equipo OTOBO',

        # Template: InstallerLicense
        'Don\'t accept license' => 'No aceptar licencia',
        'Accept license and continue' => 'Aceptar la licencia y continuar',

        # Template: InstallerSystem
        'SystemID' => 'ID de sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identificador del sistema. Todos los números de tickets e ID\'s de sesiones HTTP contendrán este número.',
        'HTTP Type' => 'Tipo HTTP',
        'Set the request scheme used for cookies and various links. For production purposes always use https.' =>
            'Establezca el esquema de solicitud utilizado para las cookies y los distintos enlaces. Para fines de producción, utilice siempre https.',
        'System FQDN' => 'FQDN del sistema',
        'Fully qualified domain name of your system.' => 'Nombre de dominio totalmente calificado de su sistema.',
        'AdminEmail' => 'Correo del Administrador',
        'Email address of the system administrator.' => 'Dirección de correo electrónico del administrador del sistema.',
        'Organization' => 'Organización',
        'Log' => 'Log',
        'LogModule' => 'MóduloLog',
        'Log backend to use.' => 'Backend a usar para el log.',
        'LogFile' => 'ArchivoLog',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma por defecto',
        'Default language.' => 'Idioma por defecto.',
        'CheckMXRecord' => 'Revisar record MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Las direcciones de correo electrónico que se proporcionan manualmente, se verifican con los records MX encontrados en el DNS. No utilice esta opcion si su DNS es lento o no resuelve direcciones públicas.',
        'Elasticsearch' => 'Elasticsearch',
        'Initialize Elasticsearch' => 'Inicializar Elasticsearch',
        'Elasticsearch server was found, and it has been activated automatically for OTOBO.' =>
            'Se ha encontrado el servidor Elasticsearch y se ha activado automáticamente para OTOBO.',
        'Seemingly either no clean Elasticsearch server is running, or it is not using the standard configuration. To activate Elasticsearch manually, please edit the web service in the admin interface if necessary, activate \'Elasticsearch::Active\' and \'Frontend::ToolBarModule###250-Ticket::ElasticsearchFulltext\' in the SysConfig and run the otobo.Console command \'Maint::Elasticsearch::Migration\'.' =>
            'Al parecer, o bien no se está ejecutando ningún servidor Elasticsearch limpio, o bien no está utilizando la configuración estándar. Para activar Elasticsearch manualmente, edita el servicio web en la interfaz de administración si es necesario, activa \'Elasticsearch::Active\' y \'Frontend::ToolBarModule##250-Ticket::ElasticsearchFulltext\' en el SysConfig y ejecuta el comando de otobo.Console \'Maint::Elasticsearch::Migration\'.',

        # Template: LinkObject
        'Delete link' => 'Borrar enlace',
        'Delete Link' => 'Borrar enlace',
        'Object#' => 'Objecto#',
        'Add links' => 'Agregar enlaces',
        'Delete links' => 'Eliminar enlaces',

        # Template: Login
        'Lost your password?' => '¿Perdió su contraseña?',
        'Back to login' => 'Regresar al inicio de sesión',

        # Template: MetaFloater
        'Scale preview content' => 'Escalar contenido de la vista previa',
        'Open URL in new tab' => 'Abrir la URL en una nueva pestaña',
        'Close preview' => 'Cerrar la vista previa',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'No se puede proporcionar una vista previa de este sitio web porque no permitía ser incrustado.',

        # Template: Copy
        'Start migration' => 'Iniciar la migración',
        'Result of data migration' => 'Resultado de la migración de datos',
        'Last successful task:' => 'Última tarea con éxito:',
        'Migration will restart from the last successfully finished task. Please do a complete rerun if you changed your system in the meantime.' =>
            'La migración se reiniciará a partir de la última tarea finalizada con éxito. Por favor, haga una reejecución completa si ha cambiado su sistema en ese tiempo.',
        'Clean up and finish' => 'Limpiar y terminar',

        # Template: Finish
        'The migration is complete, thank you for trying out OTOBO - we hope you will like it.' =>
            'La migración se ha completado, gracias por probar OTOBO - esperamos que te guste.',

        # Template: Intro
        'This migration script will lead you step by step through the process of migrating your ticket system from OTRS or ((OTRS)) Community Edition version 6 to OTOBO 10.' =>
            'Este script de migración le guiará paso a paso a través del proceso de migración de su sistema de tickets de OTRS o ((OTRS)) Community Edition versión 6 a OTOBO 10.',
        'There is no danger whatsoever for your original system: nothing is changed there.' =>
            'No hay ningún peligro para su sistema original: no se cambia nada.',
        'Instructions and details on migration prerequisites can be found in the migration manual. We strongly recommend reading it before starting migration.' =>
            'Las instrucciones y los detalles sobre los requisitos previos a la migración se encuentran en el manual de migración. Le recomendamos encarecidamente que lo lea antes de iniciar la migración.',
        'In case you have to suspend migration, you can resume it anytime at the same point as long as the cache has not been deleted.' =>
            'En caso de que tenga que suspender la migración, puede reanudarla en cualquier momento en el mismo punto siempre que el caché no haya sido eliminado.',
        'All entered passwords are cached until the migration is finished.' =>
            'Todas las contraseñas introducidas se almacenan en la caché hasta que finaliza la migración.',
        ' Anyone with access to this page, or read permission for the OTOBO Home Directory will be able to read them. If you abort the migration, you are given the option to clear the cache by visiting this page again.' =>
            ' Cualquiera que tenga acceso a esta página, o permiso de lectura para el Directorio de Inicio de OTOBO podrá leerlos. Si aborta la migración, se le da la opción de borrar la caché visitando de nuevo esta página.',
        'If you need support, just ask our experts – either at' => 'Si necesita ayuda, sólo tiene que pedirla a nuestros expertos - ya sea en',
        'OTOBO forum' => 'Foro OTOBO',
        'or directly via mail to' => 'o directamente por correo a',
        'Cached data found' => 'Datos encontrados en caché',
        'You will continue where you aborted the migration last time. If you do not want this, please discard your previous progress.' =>
            'Continuará donde abortó la migración la última vez. Si no quiere esto, por favor, descarte su progreso anterior.',
        'An error occured.' => 'Se ha producido un error.',
        'Discard previous progress' => 'Descartar el progreso anterior',
        'Insecure HTTP connection' => 'Conexión HTTP no segura',
        'You are using the migration script via http. This is highly insecure as various passwords are required during the process, and will be transferred unencrypted. Anyone between you and the OTOBO server will be able to read them! Please consider setting up https instead.' =>
            'Está utilizando el script de migración vía http. Esto es altamente inseguro ya que se requieren varias contraseñas durante el proceso, y serán transferidas sin encriptar. Cualquiera entre usted y el servidor de OTOBO podrá leerlas. Por favor, considere configurar https en su lugar.',
        'Continue anyways :(' => 'Continúa de todos modos :(',
        ' Continue anyways :(' => ' Continúa de todos modos :(',

        # Template: OTRSDBSettings
        'DSN' => 'DSN',
        'Skip DB migration' => 'Omitir la migración de la base de datos',
        'Expert option! Only works if the migration has already been done by hand.' =>
            '¡Opción de experto! Sólo funciona si la migración ya se ha hecho a mano.',
        'Skipped.' => 'Omitido.',

        # Template: OTRSFileSettings
        'OTRS server' => 'Servidor OTRS',
        'SSH User' => 'Usuario SSH',
        'OTRS home directory' => 'Directorio principal de OTRS',
        'Check settings' => 'Verificar los ajustes',
        'Result of settings check' => 'Resultado de la verificación de los ajustes',
        'Settings check successful.' => 'Verificación exitosa de la configuración.',

        # Template: PreChecks
        'Execute migration pre-checks' => 'Ejecutar las comprobaciones previas a la migración',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Función no disponible',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Lo sentimos, pero OTOBO no tiene disponible esta característica para dispositivos móviles. Si aún desea usar la dicha característica, puede hacerlo en el modo escritorio o puede usar una laptop o equipo de escritorio.',

        # Template: Motd
        'Message of the Day' => 'Mensaje del día',
        'This is the message of the day. You can edit this in %s.' => 'Este es el mensaje del día. Puedes editarlo en %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Permisos insuficientes',
        'Back to the previous page' => 'Volver a la página anterior',

        # Template: Alert
        'Alert' => 'Alerta',
        'Powered by' => 'Impulsado por',

        # Template: Pagination
        'Show first page' => 'Mostrar la primera página',
        'Show previous pages' => 'Mostrar la página anterior',
        'Show page %s' => 'Mostrar la página %s',
        'Show next pages' => 'Mostrar la página siguiente',
        'Show last page' => 'Mostrar la última página',

        # Template: PictureUpload
        'Need FormID!' => '¡Se necesita el FormID!',
        'No file found!' => '¡No se encontró el archivo!',
        'The file is not an image that can be shown inline!' => '¡El archivo no es una imagen que se pueda mostrar en línea!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'No se han encontrado notificaciones configurables para el usuario.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Recibir mensajes para notificación \'%s\' por el método de transporte \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Información del Proceso',
        'Dialog' => 'Diálogo',

        # Template: Article
        'Inform Agent' => 'Notificar a Agente',

        # Template: PublicDefault
        'Welcome' => 'Bienvenido',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            '¡Esta es la interfaz pública por defecto de OTOBO! No se ha dado ningún parámetro de acción.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Puedes instalar un módulo público personalizado (a través del gestor de paquetes), por ejemplo el módulo FAQ, que tiene una interfaz pública.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permisos',
        'You can select one or more groups to define access for different agents.' =>
            'Puede seleccionar uno o más grupos para definir el acceso para los diferentes agentes.',
        'Result formats' => 'Apariencia del resultado',
        'Time Zone' => 'Zona Horaria',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Los periodos de tiempo seleccionados en la estadística son de zona horaria neutral.',
        'Create summation row' => 'Crear una fila de agregación',
        'Generate an additional row containing sums for all data rows.' =>
            'Generar una fila adicional que contenga las sumas de todas las filas de datos.',
        'Create summation column' => 'Crear una columna de agregación',
        'Generate an additional column containing sums for all data columns.' =>
            'Generar una columna adicional que contenga las sumas de todas las columnas de datos.',
        'Cache results' => 'Cache de resultados',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Almacena los datos de los resultados estadísticos en una caché para utilizarlos en vistas posteriores con la misma configuración (requiere al menos un campo de tiempo seleccionado).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Proporcionar la estadística como un widget que los agentes pueden activar en su panel de control.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Tenga en cuenta que al habilitar el widget del tablero de instrumentos se activará el almacenamiento en caché de esta estadística en el tablero de instrumentos.',
        'If set to invalid end users can not generate the stat.' => 'Si se define como inválida, los usuarios finales no podrán generar la estadística.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Existe un problema con la configuración de esta estadística:',
        'You may now configure the X-axis of your statistic.' => 'Ahora puede configurar el eje-X de su estadística.',
        'This statistic does not provide preview data.' => 'Esta estadística no provee datos de vista previa.',
        'Preview format' => 'Vista previa del formato',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Por favor tome en cuenta que la Vista Previa usa datos aleatorios y no considera los filtros de datos.',
        'Configure X-Axis' => 'Configurar Eje-X',
        'X-axis' => 'Eje-X',
        'Configure Y-Axis' => 'Configurar Eje-Y',
        'Y-axis' => 'Eje-Y',
        'Configure Filter' => 'Configurar Filtro',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor seleccione sólo un elemento o desactive el botón \'Fijo\'.',
        'Absolute period' => 'Periodo absoluto',
        'Between %s and %s' => 'Entre %s y %s',
        'Relative period' => 'Periodo relativo',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'El pasado completo %s y el actual+próximo completo %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'No permitir cambios en este elemento mientras la estadística es generada.',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Intercambiar Ejes',
        'Configurable Params of Static Stat' => 'Parámetros configurables de las estadísticas estáticas',
        'No element selected.' => 'No hay elemento seleccionado.',
        'Scale' => 'Escala',
        'show more' => 'mostrar más',
        'show less' => 'mostrar menos',

        # Template: D3
        'Download SVG' => 'Descargar SVG',
        'Download PNG' => 'Descargar PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'El período de tiempo seleccionado define el marco temporal por defecto para que esta estadística recoja datos.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Define la unidad de tiempo que se utilizará para dividir el período de tiempo seleccionado en puntos de datos de reporte.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Recuerde que la escala del eje Y tiene que ser mayor que la del eje X (por ejemplo, eje X => Mes, eje Y => Año).',

        # Template: SettingHistoryListCompare
        'On ' => 'En ',
        'Reset to this value' => 'Restablecer este valor',

        # Template: SettingsList
        'This setting is disabled.' => 'Este ajuste está desactivado.',
        'This setting is fixed but not deployed yet!' => '¡Esta configuración está arreglada, pero aún no se ha desplegado!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '¡Este ajuste está siendo anulado en %s y por lo tanto no puede ser cambiado aquí!',
        'Changing this setting is only available in a higher config level!' =>
            '¡La modificación de este ajuste sólo está disponible en un nivel de configuración superior!',
        '%s (%s) is currently working on this setting.' => '%s (%s) está trabajando actualmente en esta configuración.',
        'Toggle advanced options for this setting' => 'Activar las opciones avanzadas de esta configuración',
        'Disable this setting, so it is no longer effective' => 'Desactivar este ajuste, por lo que ya no es eficaz',
        'Disable' => 'Desactivar',
        'Enable this setting, so it becomes effective' => 'Habilitar este ajuste, para que sea efectivo',
        'Enable' => 'Activar',
        'Reset this setting to its default state' => 'Restablecer esta configuración a su estado por defecto',
        'Reset setting' => 'Restablecer la configuración',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Permitir a los usuarios adaptar esta configuración desde sus preferencias personales',
        'Allow users to update' => 'Permitir a los usuarios actualizar',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Ya no permite a los usuarios adaptar esta configuración desde sus preferencias personales',
        'Forbid users to update' => 'Prohibir a los usuarios que se actualicen',
        'Show user specific changes for this setting' => 'Mostrar los cambios específicos del usuario para esta configuración',
        'Show user settings' => 'Mostrar la configuración del usuario',
        'Copy a direct link to this setting to your clipboard' => 'Copie un enlace directo a esta configuración en su portapapeles',
        'Copy direct link' => 'Copiar enlace directo',
        'Remove this setting from your favorites setting' => 'Eliminar este ajuste de su configuración de favoritos',
        'Remove from favourites' => 'Eliminar de los favoritos',
        'Add this setting to your favorites' => 'Añadir esta configuración a tus favoritos',
        'Add to favourites' => 'Añadir a favoritos',
        'Cancel editing this setting' => 'Cancelar la edición de esta configuración',
        'Save changes on this setting' => 'Guardar los cambios en esta configuración',
        'Edit this setting' => 'Editar esta configuración',
        'Enable this setting' => 'Habilitar esta configuración',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Este grupo no contiene ninguna configuración. Por favor, intente navegar a uno de sus subgrupos o a otro grupo.',

        # Template: SettingsListCompare
        'Now' => 'Ahora',
        'User modification' => 'Modificación del usuario',
        'enabled' => 'activado',
        'disabled' => 'desactivado',
        'Setting state' => 'Estado de la configuración',

        # Template: Actions
        'Edit search' => 'Editar búsqueda',
        'Go back to admin: ' => 'Volver a la administración: ',
        'Deployment' => 'Despliegue',
        'My favourite settings' => 'Mis ajustes favoritos',
        'Invalid settings' => 'Ajustes no válidos',

        # Template: DynamicActions
        'Filter visible settings...' => 'Filtrar los ajustes visibles...',
        'Enable edit mode for all settings' => 'Activar el modo de edición para todos los ajustes',
        'Save all edited settings' => 'Guardar todos los ajustes editados',
        'Cancel editing for all settings' => 'Cancelar la edición de todos los ajustes',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Todas las acciones de este widget se aplican sólo a los ajustes visibles de la derecha.',

        # Template: Help
        'Currently edited by me.' => 'Actualmente editado por mí.',
        'Modified but not yet deployed.' => 'Modificado pero aún no desplegado.',
        'Currently edited by another user.' => 'Editado por otro usuario.',
        'Different from its default value.' => 'Diferente de su valor por defecto.',
        'Save current setting.' => 'Guarda el ajuste actual.',
        'Cancel editing current setting.' => 'Cancelar la edición del ajuste actual.',

        # Template: Navigation
        'Navigation' => 'Navegación',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => 'Eliminar el valor del usuario.',

        # Template: Test
        'OTOBO Test Page' => 'Página de Prueba de OTOBO',
        'Unlock' => 'Desbloquear',
        'Welcome %s %s' => 'Bienvenido %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Regresar a la página anterior',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Mostrar',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Título del proyecto',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Mostrar artículo',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '¿Realmente quieres borrar "%s"?',
        'Confirm' => 'Confirmar',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Cargando, por favor espere...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => 'Mostrar todo',
        'Show less' => 'Mostrar menos',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Haga clic para seleccionar un archivo para cargar.',
        'Click to select or drop files here.' => 'Haga clic para seleccionar o arrástrelo archivos aquí.',
        'Click to select files or just drop them here.' => 'Haga clic para seleccionar los archivos o simplemente arrástrelo aquí.',
        'Click to select a file or just drop it here.' => 'Haga clic para seleccionar un archivo o simplemente arrástrelo aquí.',
        'Uploading...' => 'Cargando...',

        # JS Template: MigrationState
        'Time needed' => 'Tiempo necesario',

        # JS Template: PackageResolve
        'Package' => 'Paquete',
        'Uninstall from OTOBO' => 'Desinstalación desde OTOBO',
        'Ignore' => 'Ignore',
        'Migrate' => 'Migrar',

        # JS Template: InformationDialog
        'Process state' => 'Estado del proceso',
        'Running' => 'Corriendo',
        'Finished' => 'Finalizado',
        'No package information available.' => 'Información sobre el paquete no disponible .',

        # JS Template: AddButton
        'Add new entry' => 'Añadir una entrada nueva',

        # JS Template: AddHashKey
        'Add key' => 'Añadir clave',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Comentario sobre el despliegue...',
        'This field can have no more than 250 characters.' => 'Este campo no puede tener más de 250 caracteres.',
        'Deploying, please wait...' => 'Desplegando, por favor espere...',
        'Preparing to deploy, please wait...' => 'Preparando el despliegue, por favor espere...',
        'Deploy now' => 'Despliegue ahora',
        'Try again' => 'Inténtelo de nuevo',

        # JS Template: DialogReset
        'Reset options' => 'Opciones de reinicio',
        'Reset setting on global level.' => 'Restablecer la configuración a nivel global.',
        'Reset globally' => 'Restablecimiento global',
        'Remove all user changes.' => 'Eliminar todos los cambios de usuario.',
        'Reset locally' => 'Restablecer localmente',
        'user(s) have modified this setting.' => 'usuario(s) ha(n) modificado esta configuración.',
        'Do you really want to reset this setting to it\'s default value?' =>
            '¿Realmente quieres restablecer esta configuración a su valor por defecto?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Puede utilizar la selección de la categoría para limitar el árbol de navegación inferior a las entradas de la categoría seleccionada. En cuanto seleccione la categoría, el árbol se volverá a construir.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Base de datos backend',
        'CustomerIDs' => 'Identificadores del cliente',
        'Fax' => 'Fax',
        'Street' => 'Calle',
        'Zip' => 'CP',
        'City' => 'Ciudad',
        'Country' => 'País',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Address' => 'Dirección',
        'View system log messages.' => 'Ver los mensajes del log del sistema.',
        'Edit the system configuration settings.' => 'Modificar la configuración del sistema.',
        'Update and extend your system with software packages.' => 'Actualizar y extender su sistema con paquetes de software.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'La información de las ACL en la base de datos no está sincronizada con la configuración del sistema, por favor, despliegue todas las ACLs.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Las ACLs no pudieron ser importadas debido a un error desconocido, por favor revise los registros de OTOBO para más información',
        'The following ACLs have been added successfully: %s' => 'Las siguientes ACLs se han añadido con éxito: %s',
        'The following ACLs have been updated successfully: %s' => 'Las siguientes ACLs han sido actualizadas con éxito: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Hubo errores al añadir/actualizar las siguientes ACLs: %s. Por favor, compruebe el archivo de registro para obtener más información.',
        'There was an error creating the ACL' => 'Hubo un error al crear la ACL',
        'Need ACLID!' => '¡Necesita ACL ID!',
        'Could not get data for ACLID %s' => 'No se han podido obtener los datos de ACL ID %s',
        'There was an error updating the ACL' => 'Hubo un error al actualizar la ACL',
        'There was an error setting the entity sync status.' => 'Hubo un error al establecer el estado de sincronización de la entidad.',
        'There was an error synchronizing the ACLs.' => 'Se ha producido un error al sincronizar las ACL.',
        'ACL %s could not be deleted' => 'La ACL %s no ha podido ser eliminada',
        'There was an error getting data for ACL with ID %s' => 'Hubo un error al obtener datos para la ACL con ID %s',
        '%s (copy) %s' => '%s (copia) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Tenga en cuenta que las restricciones ACL serán ignoradas para la cuenta de superusuario (UserID 1).',
        'Exact match' => 'Coincidencia exacta',
        'Negated exact match' => 'Coincidencia exacta negada',
        'Regular expression' => 'Expresión regular',
        'Regular expression (ignore case)' => 'Expresión regular (ignorar mayúsculas y minúsculas)',
        'Negated regular expression' => 'Expresión regular negada',
        'Negated regular expression (ignore case)' => 'Expresión regular negada (ignorar mayúsculas y minúsculas)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'El sistema no pudo crear el Calendario!',
        'Please contact the administrator.' => 'Por favor contacte el administrador.',
        'No CalendarID!' => 'No se tiene el CalendarID!',
        'You have no access to this calendar!' => 'No tiene acceso a este calendario!',
        'Error updating the calendar!' => 'Error al actualizer el calendario!',
        'Couldn\'t read calendar configuration file.' => 'No se puede leer el archivo de configuración del calendario.',
        'Please make sure your file is valid.' => 'Por favor asegúrese de que el archivo es válido.',
        'Could not import the calendar!' => 'No se puede importar el calendario!',
        'Calendar imported!' => 'Calendario importado!',
        'Need CalendarID!' => 'Se necesita CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Not se pueden obtener los datos para el CalendarID especificado',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Se han importado %s cita(s) al calendario %s.',
        '+5 minutes' => '+5 minutos',
        '+15 minutes' => '+15 minutos',
        '+30 minutes' => '+30 minutos',
        '+1 hour' => '+1 hora',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'No tiene permisos',
        'System was unable to import file!' => 'El sistema no pudo importar el archivo!',
        'Please check the log for more information.' => 'Consulte el registro para obtener más información.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'El nombre de la notificación ya existe!',
        'Notification added!' => '¡Notificación añadida!',
        'There was an error getting data for Notification with ID:%s!' =>
            '¡Se ha producido un error al obtener los datos de la notificación con ID:%s!',
        'Unknown Notification %s!' => '¡Notificación desconocida %s!',
        '%s (copy)' => '%s (copia)',
        'There was an error creating the Notification' => 'Se ha producido un error al crear la notificación',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Las notificaciones no pudieron ser importadas debido a un error desconocido, por favor revise los registros de OTOBO para más información',
        'The following Notifications have been added successfully: %s' =>
            'Las siguientes notificaciones se han añadido con éxito: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Las siguientes notificaciones han sido actualizadas con éxito: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Se han producido errores al añadir/actualizar las siguientes notificaciones: %s. Por favor, compruebe el archivo de registro para obtener más información.',
        'Notification updated!' => '¡Notificación actualizada!',
        'Agent (resources), who are selected within the appointment' => 'Agentes (recursos), que pueden ser seleccionados dentro de una cita',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Agentes con (al menos) permisos de lectura para la cita (calendario)',
        'All agents with write permission for the appointment (calendar)' =>
            'Todos los agentes con permisos de escritura para la cita (calendario)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '¡Archivo adjunto añadido!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '¡Respuesta Automática agregada!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '¡ID de comunicación inválida!',
        'All communications' => 'Todas las comunicaciones',
        'Last 1 hour' => 'Última hora',
        'Last 3 hours' => 'Últimas 3 horas',
        'Last 6 hours' => 'Últimas 6 horas',
        'Last 12 hours' => 'Últimas 12 horas',
        'Last 24 hours' => 'Últimas 24 horas',
        'Last week' => 'Semana pasada',
        'Last month' => 'Mes pasado',
        'Invalid StartTime: %s!' => '¡Hora de inicio inválida: %s!',
        'Successful' => 'Exitoso',
        'Processing' => 'Procesando',
        'Failed' => 'Falló',
        'Invalid Filter: %s!' => '¡Filtro inválido: %s!',
        'Less than a second' => 'Menos de un segundo',
        'sorted descending' => 'ordenados de forma descendente',
        'sorted ascending' => 'ordenado de forma ascendente',
        'Trace' => 'Rastrear',
        'Debug' => 'Depurar',
        'Info' => 'Información',
        'Warn' => 'Advertencia',
        'days' => 'días',
        'day' => 'día',
        'hour' => 'hora',
        'minute' => 'minuto',
        'seconds' => 'segundos',
        'second' => 'segundo',

        # Perl Module: Kernel/Modules/AdminContactWD.pm
        'No contact is given!' => '¡No se da ningún contacto!',
        'No data found for given contact in given source!' => '¡No se han encontrado datos para el contacto indicado en la fuente indicada!',
        'Contact updated!' => '¡Contacto actualizado!',
        'No field data found!' => '¡No se han encontrado datos!',
        'Contact created!' => '¡Contacto creado!',
        'Error creating contact!' => '¡Error al crear el contacto!',
        'No sources found, at least one "Contact with data" dynamic field must be added to the system!' =>
            'No se han encontrado "Contacto con datos", ¡se debe añadir al sistema al menos un campo dinámico!',
        'No data found for given source!' => '¡No se han encontrado datos para la fuente indicada!',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => '¡La empresa del cliente se actualizó!',
        'Dynamic field %s not found!' => '¡Campo dinámico %s no encontrado!',
        'Unable to set value for dynamic field %s!' => '¡No se ha podido establecer el valor del campo dinámico %s!',
        'Customer Company %s already exists!' => '¡La empresa cliente %s ya existe!',
        'Customer company added!' => '¡Se agregó la empresa del cliente!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '¡No se ha encontrado ninguna configuración para \'CustomerGroupPermissionContext\'!',
        'Please check system configuration.' => 'Por favor, compruebe la configuración del sistema.',
        'Invalid permission context configuration:' => 'Configuración del contexto de permisos no válida:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '¡Cliente actualizado!',
        'New phone ticket' => 'Ticket telefónico nuevo',
        'New email ticket' => 'Ticket de correo electrónico nuevo',
        'Customer %s added' => 'Cliente %s añadido',
        'Customer user updated!' => '¡Usuario del cliente actualizado!',
        'Same Customer' => 'El mismo cliente',
        'Direct' => 'Directo',
        'Indirect' => 'Indirecto',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Cambiar las relaciones del usuario cliente para el grupo',
        'Change Group Relations for Customer User' => 'Modificar las relaciones de grupo para el usuario cliente',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Asignación de usuarios clientes a servicios',
        'Allocate Services to Customer User' => 'Asignación de servicios al usuario cliente',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'La configuración de los campos no es válida',
        'Objects configuration is not valid' => 'La configuración de los objetos no es válida',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'No se ha podido restablecer correctamente el orden de los campos dinámicos, por favor, compruebe el registro de errores para obtener más detalles.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Subacción no definida.',
        'Need %s' => 'Necesitan %s',
        'Add %s field' => 'Añadir campo %s',
        'The field does not contain only ASCII letters and numbers.' => 'El campo no contiene sólo letras y números ASCII.',
        'There is another field with the same name.' => 'Hay otro campo con el mismo nombre.',
        'The field must be numeric.' => 'El campo debe ser numérico.',
        'Need ValidID' => 'Necesita ValidID',
        'Could not create the new field' => 'No se ha podido crear el nuevo campo',
        'Need ID' => 'Necesita ID',
        'Could not get data for dynamic field %s' => 'No se han podido obtener los datos del campo dinámico %s',
        'Change %s field' => 'Cambiar el campo %s',
        'The name for this field should not change.' => 'El nombre de este campo no debe cambiar.',
        'Could not update the field %s' => 'No se ha podido actualizar el campo %s',
        'Currently' => 'Actualmente',
        'Unchecked' => 'Sin comprobar',
        'Checked' => 'Comprobado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => 'Esta clave de este campo está duplicada.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'El valor de este campo está duplicado.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Evitar la introducción de fechas en el futuro',
        'Prevent entry of dates in the past' => 'Evitar la introducción de fechas en el pasado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => 'Se han guardado los ajustes.',
        'System was not able to save the setting!' => '¡El sistema no ha podido guardar la configuración!',
        'Setting is locked by another user!' => '¡La configuración está bloqueada por otro usuario!',
        'System was not able to reset the setting!' => '¡El sistema no ha podido restablecer la configuración!',
        'Settings were reset.' => 'La configuración se ha restablecido.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Seleccione al menos un destinatario.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minuto(s)',
        'hour(s)' => 'hora(s)',
        'Time unit' => 'Unidad de tiempo',
        'within the last ...' => 'dentro del ultimo ...',
        'within the next ...' => 'dentro del siguiente ...',
        'more than ... ago' => 'Desde hace más de...',
        'Unarchived tickets' => 'Tickets No Archivados',
        'archive tickets' => 'tickets archivados',
        'restore tickets from archive' => 'restaurar tickets desde el archivo',
        'Need Profile!' => '¡Necesita un perfil!',
        'Got no values to check.' => 'No hay valores para comprobar.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Por favor, elimine las siguientes palabras ya que no pueden ser usadas para la selección de ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '¡Necesita WebserviceID!',
        'Could not get data for WebserviceID %s' => 'No se han podido obtener los datos de WebserviceID %s',
        'ascending' => 'ascendente',
        'descending' => 'descendente',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '¡Necesita un tipo de comunicación!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '¡El tipo de comunicación debe ser "Solicitante" o "Proveedor"!',
        'Invalid Subaction!' => '¡Subacción inválida!',
        'Need ErrorHandlingType!' => '¡Necesita un gestor de errores!',
        'ErrorHandlingType %s is not registered' => 'El gestor de errores %s no está registrado',
        'Could not update web service' => 'No se ha podido actualizar el servicio web',
        'Need ErrorHandling' => 'Necesidad gestor de errores',
        'Could not determine config for error handler %s' => 'No se ha podido determinar la configuración del gestor de errores %s',
        'Invoker processing outgoing request data' => 'Invocador que procesa los datos de la solicitud saliente',
        'Mapping outgoing request data' => 'Mapeo de los datos de las solicitudes salientes',
        'Transport processing request into response' => 'Transporte de la solicitud de procesamiento a la respuesta',
        'Mapping incoming response data' => 'Mapeo de los datos de respuesta entrantes',
        'Invoker processing incoming response data' => 'Invocador que procesa los datos de respuesta entrantes',
        'Transport receiving incoming request data' => 'Transporte que recibe los datos de la solicitud',
        'Mapping incoming request data' => 'Mapeo de los datos de solicitudes entrantes',
        'Operation processing incoming request data' => 'Operación de procesamiento de los datos de la solicitud entrante',
        'Mapping outgoing response data' => 'Mapeo de los datos de respuesta saliente',
        'Transport sending outgoing response data' => 'Transporte que envía datos de respuesta de salida',
        'skip same backend modules only' => 'omitir sólo los mismos módulos backend',
        'skip all modules' => 'omitir todos los módulos',
        'Operation deleted' => 'Operación eliminada',
        'Invoker deleted' => 'Invocador eliminado',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 segundos',
        '15 seconds' => '15 segundos',
        '30 seconds' => '30 segundos',
        '45 seconds' => '45 segundos',
        '1 minute' => '1 minuto',
        '2 minutes' => '2 minutos',
        '3 minutes' => '3 minutos',
        '4 minutes' => '4 minutos',
        '5 minutes' => '5 minutos',
        '10 minutes' => '10 minutos',
        '15 minutes' => '15 minutos',
        '30 minutes' => '30 minutos',
        '1 hour' => '1 hora',
        '2 hours' => '2 horas',
        '3 hours' => '3 horas',
        '4 hours' => '4 horas',
        '5 hours' => '5 horas',
        '6 hours' => '6 horas',
        '12 hours' => '12 horas',
        '18 hours' => '18 horas',
        '1 day' => '1 día',
        '2 days' => '2 días',
        '3 days' => '3 días',
        '4 days' => '4 días',
        '6 days' => '6 días',
        '1 week' => '1 semana',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'No se ha podido determinar la configuración del invocador %s',
        'InvokerType %s is not registered' => 'El InvokerType %s no está registrado',
        'MappingType %s is not registered' => 'El MappingType %s no está registrado',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '¡Necesita un Invocador!',
        'Need Event!' => '¡Necesita un evento!',
        'Could not get registered modules for Invoker' => 'No se han podido registrar módulos para el Invoker',
        'Could not get backend for Invoker %s' => 'No se pudo obtener el backend para el Invoker %s',
        'The event %s is not valid.' => 'El evento %s no es válido.',
        'Could not update configuration data for WebserviceID %s' => 'No se han podido actualizar los datos de configuración de WebserviceID %s',
        'This sub-action is not valid' => 'Esta sub-acción no es válida',
        'xor' => 'xor',
        'String' => 'Cadena',
        'Regexp' => 'Regexp',
        'Validation Module' => 'Módulo de validación',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Mapeo sencillo de los datos salientes',
        'Simple Mapping for Incoming Data' => 'Mapeo sencillo de los datos entrantes',
        'Could not get registered configuration for action type %s' => 'No se pudo obtener la configuración registrada para el tipo de acción %s',
        'Could not get backend for %s %s' => 'No se pudo obtener el backend para %s %s',
        'Keep (leave unchanged)' => 'Mantener (dejar sin cambios)',
        'Ignore (drop key/value pair)' => 'Ignorar (abandonar el par clave/valor)',
        'Map to (use provided value as default)' => 'Asignar a (utilizar el valor proporcionado por defecto)',
        'Exact value(s)' => 'Valor(es) exacto(s)',
        'Ignore (drop Value/value pair)' => 'Ignorar (eliminar el par valor/valor)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'Mapeo XSLT para datos salientes',
        'XSLT Mapping for Incoming Data' => 'Mapeo XSLT para datos entrantes',
        'Could not find required library %s' => 'No se pudo encontrar la biblioteca requerida %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Datos de la solicitud saliente antes del procesamiento (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Datos de la solicitud saliente antes de la asignación (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Datos de la solicitud saliente tras la asignación (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Datos de la respuesta entrante antes de la asignación (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Datos del gestor de errores salientes tras la gestión de errores (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Datos de la solicitud entrante antes de la asignación (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Datos de la solicitud entrante después del mapeo (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Datos de la respuesta saliente antes de la asignación (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Datos de salida del gestor de errores después de la gestión de errores (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'No se ha podido determinar la configuración para la operación %s',
        'OperationType %s is not registered' => 'El tipo de operación %s no está registrado',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '¡Necesita una sub acción válida!',
        'This field should be an integer.' => 'Este campo debe ser un número entero.',
        'File or Directory not found.' => 'Archivo o directorio no encontrado.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Hay otro servicio web con el mismo nombre.',
        'There was an error updating the web service.' => 'Se ha producido un error al actualizar el servicio web.',
        'There was an error creating the web service.' => 'Se ha producido un error al crear el servicio web.',
        'Web service "%s" created!' => '¡Web service "%s" creado!',
        'Need Name!' => '¡Necesita un nombre!',
        'Need ExampleWebService!' => '¡Necesita un ejemplo de servicio web!',
        'Could not load %s.' => 'No se ha podido cargar %s.',
        'Could not read %s!' => '¡No se ha podido leer %s!',
        'Need a file to import!' => '¡Necesita un archivo para importar!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'El archivo importado no tiene un contenido YAML válido. Por favor, compruebe el registro de OTOBO para más detalles',
        'Web service "%s" deleted!' => '¡Web service "%s" eliminado!',
        'OTOBO as provider' => 'OTOBO como proveedor',
        'Operations' => 'Operaciones',
        'OTOBO as requester' => 'OTOBO como solicitante',
        'Invokers' => 'Invocadores',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '¡No tengo WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'No se han podido obtener los datos del historial del WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '¡Grupo actualizado!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '¡Cuanta de correo agregada!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'La obtención de la cuenta de correo electrónico ya ha sido obtenida por otro proceso. ¡Por favor, inténtelo de nuevo más tarde!',
        'Dispatching by email To: field.' => 'Despachar por el campo Para: del correo electrónico.',
        'Dispatching by selected Queue.' => 'Despachar por la fila seleccionada.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Agente que creó el ticket',
        'Agent who owns the ticket' => 'Agente propietario del ticket',
        'Agent who is responsible for the ticket' => 'El agente responsable por el ticket',
        'All agents watching the ticket' => 'Agentes dando seguimiento al ticket',
        'All agents with write permission for the ticket' => 'Todos los agentes con permisos de escritura para el ticket',
        'All agents subscribed to the ticket\'s queue' => 'Todos los agentes suscritos a la fila de espera del ticket',
        'All agents subscribed to the ticket\'s service' => 'Todos los agentes suscritos al servicio del ticket',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Todos los agentes suscritos tanto a la fila, como al servicio del ticket',
        'Customer user of the ticket' => 'Usuario del cliente del ticket',
        'All recipients of the first article' => 'Todos los destinatarios del primer artículo',
        'All recipients of the last article' => 'Todos los destinatarios del último artículo',
        'Invisible to customer' => 'Invisible para el cliente',
        'Visible to customer' => 'Visible para el cliente',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'El entorno PGP no funciona. ¡Por favor, compruebe el registro para obtener más información!',
        'Need param Key to delete!' => '¡Necesita la llave param para borrar!',
        'Key %s deleted!' => '¡Clave %s borrada!',
        'Need param Key to download!' => '¡Necesita la clave del parámetro para descargar!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Lo sentimos, Apache::Reload es necesario como PerlModule y PerlInitHandler en el archivo de configuración de Apache. Vea también scripts/apache2-httpd.include.conf. ¡Como alternativa, puede utilizar la herramienta de línea de comandos bin/otobo.Console.pl para instalar los paquetes!',
        'No such package!' => '¡No existe el paquete!',
        'No such file %s in package!' => '¡No existe el archivo %s en el paquete!',
        'No such file %s in local file system!' => '¡No existe el archivo %s en el sistema de archivos local!',
        'Can\'t read %s!' => '¡No se puede leer %s!',
        'File is OK' => 'El archivo está bien',
        'Package has locally modified files.' => 'El paquete tiene archivos modificados localmente.',
        'Package not verified by the OTOBO Team!' => '¡Paquete no verificado por el equipo de OTOBO!',
        'Not Started' => 'No iniciado',
        'Updated' => 'Actualizado',
        'Already up-to-date' => 'Ya está al día',
        'Installed' => 'Instalado',
        'Not correctly deployed' => 'No se ha desplegado correctamente',
        'Package updated correctly' => 'Paquete actualizado correctamente',
        'Package was already updated' => 'El paquete ya fue actualizado',
        'Dependency installed correctly' => 'Dependencia instalada correctamente',
        'The package needs to be reinstalled' => 'Es necesario reinstalar el paquete',
        'The package contains cyclic dependencies' => 'El paquete contiene dependencias cíclicas',
        'Not found in on-line repositories' => 'No se encuentra en los repositorios en línea',
        'Required version is higher than available' => 'La versión requerida es superior a la disponible',
        'Dependencies fail to upgrade or install' => 'Las dependencias no se pueden actualizar o instalar',
        'Package could not be installed' => 'No se ha podido instalar el paquete',
        'Package could not be upgraded' => 'No se ha podido actualizar el paquete',
        'Repository List' => 'Lista de Repositorios',
        'No packages found in selected repository. Please check log for more info!' =>
            'No se han encontrado paquetes en el repositorio seleccionado. ¡Por favor, compruebe el registro para obtener más información!',
        'Package not verified due a communication issue with verification server!' =>
            'Paquete no verificado debido a un problema en la comunicación con el servidor de verificación!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => '¡No se puede conectar con el servidor de complementos de OTOBO!',
        'Can\'t get OTOBO Feature Add-on list from server!' => '¡No puedo obtener la lista de complementos del servidor de OTOBO!',
        'Can\'t get OTOBO Feature Add-on from server!' => '¡No puedo obtener el complemento de funciones del servidor de OTOBO!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'No existe el filtro: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '¡Prioridad agregada!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'La información para la gestión de procesos no se encuentra sincronizada con la configuración del sistema, por favor sincronice todos los procesos.',
        'Need ExampleProcesses!' => '¡Necesito ejemplos de procesos!',
        'Need ProcessID!' => '¡Necesita ProcessID!',
        'Yes (mandatory)' => 'Sí (obligatorio)',
        'Unknown Process %s!' => '¡Proceso desconocido %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Hubo un error al generar un nuevo EntityID para este Proceso',
        'The StateEntityID for state Inactive does not exists' => 'El StateEntityID para el estado Inactivo no existe',
        'There was an error creating the Process' => 'Hubo un error al crear el Proceso',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Hubo un error al establecer el estado de sincronización de la entidad para la entidad del proceso: %s',
        'Could not get data for ProcessID %s' => 'No se han podido obtener los datos de ProcessID %s',
        'There was an error updating the Process' => 'Hubo un error al actualizar el Proceso',
        'Process: %s could not be deleted' => 'Proceso: %s no pudo ser borrado',
        'There was an error synchronizing the processes.' => 'Hubo un error al sincronizar los procesos.',
        'The %s:%s is still in use' => 'El %s:%s todavía está en uso',
        'The %s:%s has a different EntityID' => 'El %s:%s tiene un EntityID diferente',
        'Could not delete %s:%s' => 'No se ha podido borrar %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Hubo un error al establecer el estado de sincronización de la entidad %s: %s',
        'Could not get %s' => 'No se ha podido obtener %s',
        'Need %s!' => '¡Necesita %s!',
        'Process: %s is not Inactive' => 'Proceso: %s no está Inactivo',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Hubo un error al generar un nuevo EntityID para esta Actividad',
        'There was an error creating the Activity' => 'Hubo un error al crear la actividad',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Se ha producido un error al establecer el estado de sincronización de la entidad de la actividad: %s',
        'Need ActivityID!' => '¡Necesita ActivityID!',
        'Could not get data for ActivityID %s' => 'No se han podido obtener los datos de ActivityID %s',
        'There was an error updating the Activity' => 'Hubo un error al actualizar la actividad',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Falta un parámetro: ¡Necesita Activity y ActivityDialog!',
        'Activity not found!' => '¡Actividad no encontrada!',
        'ActivityDialog not found!' => '¡Diálogo de actividad no encontrado!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Diálogo de Actividad ya asignado a la Actividad. ¡No se puede añadir un diálogo de actividad dos veces!',
        'Error while saving the Activity to the database!' => '¡Error al guardar la actividad en la base de datos!',
        'This subaction is not valid' => 'Esta sub acción no es válida',
        'Edit Activity "%s"' => 'Editar actividad "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Hubo un error al generar un nuevo EntityID para este Diálogo de Actividad',
        'There was an error creating the ActivityDialog' => 'Se ha producido un error al crear el diálogo de actividad',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Se ha producido un error al establecer el estado de sincronización de la entidad Actividad de Diálogo: %s',
        'Need ActivityDialogID!' => '¡Necesita ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'No se han podido obtener los datos de ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'Se ha producido un error al actualizar el diálogo de actividad',
        'Edit Activity Dialog "%s"' => 'Editar diálogo de actividad "%s"',
        'Agent Interface' => 'Interfaz de agente',
        'Customer Interface' => 'Interfaz del cliente',
        'Agent and Customer Interface' => 'Interfaz de agente y cliente',
        'Do not show Field' => 'No mostrar Campo',
        'Show Field' => 'Mostrar campo',
        'Show Field As Mandatory' => 'Mostrar campo como obligatorio',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Editar Ruta',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Hubo un error al generar un nuevo EntityID para esta Transición',
        'There was an error creating the Transition' => 'Hubo un error al crear la Transición',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Hubo un error al establecer el estado de sincronización de la entidad de Transición: %s',
        'Need TransitionID!' => '¡Necesita TransitionID!',
        'Could not get data for TransitionID %s' => 'No se han podido obtener los datos de TransitionID %s',
        'There was an error updating the Transition' => 'Hubo un error al actualizar la Transición',
        'Edit Transition "%s"' => 'Editar Transición "%s"',
        'Transition validation module' => 'Módulo validación de transición',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Se requiere al menos un parámetro de configuración válido.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Hubo un error al generar un nuevo EntityID para esta Acción de Transición',
        'There was an error creating the TransitionAction' => 'Hubo un error al crear la Acción de Transición',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Se ha producido un error al establecer el estado de sincronización de la entidad Acción de Transición: %s',
        'Need TransitionActionID!' => '¡Necesita TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'No se han podido obtener datos para TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'Hubo un error al actualizar la Acción de Transición',
        'Edit Transition Action "%s"' => 'Editar Acción de Transición "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Error: No todas las claves parecen tener valores o viceversa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => '¡Fila actualizada!',
        'Don\'t use :: in queue name!' => '¡No use :: en el nombre de la fila!',
        'Click back and change it!' => '¡Vuelve a hacer clic y cámbialo!',
        '-none-' => '-ninguno-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Colas ( sin respuestas automáticas )',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Modificar las relaciones de Fila para la Plantilla',
        'Change Template Relations for Queue' => 'Modificar las relaciones de Plantilla para la Fila',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Producción',
        'Test' => 'Prueba',
        'Training' => 'Capacitación',
        'Development' => 'Desarrollo',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '¡Rol actualizado!',
        'Role added!' => '¡Rol añadido!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Modificar Relaciones de Grupo para los Roles',
        'Change Role Relations for Group' => 'Modificar Relaciones de Rol para los Grupos',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Rol',
        'Change Role Relations for Agent' => 'Modificar Relacioes de Rol para los Agentes',
        'Change Agent Relations for Role' => 'Modificar Relacioes de Agente para los Roles',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '¡Favor de activar %s primero!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'El entorno S/MIME no funciona. ¡Por favor, compruebe el registro para obtener más información!',
        'Need param Filename to delete!' => '¡Se necesita el parámetro Nombre de archivo para eliminar!',
        'Need param Filename to download!' => '¡Necesita un parámetro nombre de archivo para descargar!',
        'Needed CertFingerprint and CAFingerprint!' => '¡Se necesita CertFingerprint y CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint debe ser diferente de CertFingerprint',
        'Relation exists!' => '¡La relación existe!',
        'Relation added!' => '¡Relación añadida!',
        'Impossible to add relation!' => '¡Imposible añadir la relación!',
        'Relation doesn\'t exists' => 'La relación no existe',
        'Relation deleted!' => '¡Relación borrada!',
        'Impossible to delete relation!' => '¡Imposibilidad de eliminar la relación!',
        'Certificate %s could not be read!' => '¡No se ha podido leer el certificado %s!',
        'Needed Fingerprint' => 'Huella dactilar necesaria',
        'Handle Private Certificate Relations' => 'Manejar las relaciones de los certificados privados',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '¡Saludo añadido!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '¡Firma actualizada!',
        'Signature added!' => '¡Firma agregada!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '¡Estado añadido!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '¡No se ha podido leer el archivo %s!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '¡Cuenta de correo del sistema actualizada!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Ajustes no válidos',
        'There are no invalid settings active at this time.' => 'En este momento no hay configuraciones inválidas activas.',
        'You currently don\'t have any favourite settings.' => 'Actualmente no tienes ninguna configuración de favoritos.',
        'The following settings could not be found: %s' => 'No se ha podido encontrar la siguiente configuración: %s',
        'Import not allowed!' => '¡No se permite la importación!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'La configuración del sistema no pudo ser importada debido a un error desconocido, por favor revise los registros de OTOBO para más información.',
        'Category Search' => 'Búsqueda por categoría',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Algunos ajustes importados no están presentes en el estado actual de la configuración o no fue posible actualizarlos. Por favor, compruebe el registro de OTOBO para obtener más información.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '¡Este despliegue no contiene cambios en los valores de ajuste!',
        'No DeploymentID received!' => '¡No se ha recibido ningún DeploymentID!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '¡Es necesario activar el ajuste antes de bloquear!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'No puede trabajar en esta configuración porque %s (%s) está trabajando actualmente en ella.',
        'Missing setting name!' => '¡Falta el nombre del ajuste!',
        'Missing ResetOptions!' => '¡Faltan opciones de reinicio!',
        'System was not able to lock the setting!' => '¡El sistema no ha podido bloquear el ajuste!',
        'System was unable to update setting!' => '¡El sistema no ha podido actualizar los ajustes!',
        'Missing setting name.' => 'Falta el nombre del ajuste.',
        'Setting not found.' => 'Ajuste no encontrado.',
        'Missing Settings!' => '¡Faltan ajustes!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationSettingHistory.pm
        'No setting name received!' => '¡No se ha recibido ningún nombre de ajuste!',
        'Modified Version' => 'Versión modificada',
        'Reset To Default' => 'Restablecer los valores por defecto',
        'Default Version' => 'Versión predeterminada',
        'No setting name or modified version id received!' => '¡No se ha recibido el nombre de la configuración o la identificación de la versión modificada!',
        'Was not possible to revert the historical value!' => '¡No fue posible revertir al valor histórico!',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationUser.pm
        'Missing setting name or modified id!' => '¡Falta el nombre de la configuración o la identificación modificada!',
        'System was not able to delete the user setting values!' => '¡El sistema no ha podido borrar los valores de configuración del usuario!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '¡La fecha de inicio no debería definirse después de la fecha de finalización!',
        'There was an error creating the System Maintenance' => 'Se ha producido un error al crear el Mantenimiento del Sistema',
        'Need SystemMaintenanceID!' => '¡Necesita SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'No se han podido obtener los datos de SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => '¡El mantenimiento del sistema se ha añadido con éxito!',
        'System Maintenance was updated successfully!' => '¡El mantenimiento del sistema se ha actualizado con éxito!',
        'Session has been killed!' => '¡La sesión ha sido cerrada!',
        'All sessions have been killed, except for your own.' => 'Todas las sesiones han sido cerradas, excepto por la actual.',
        'There was an error updating the System Maintenance' => 'Se ha producido un error al actualizar el Mantenimiento del Sistema',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '¡No ha sido posible borrar la entrada SystemMaintenance: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '¡Plantilla actualizada!',
        'Template added!' => '¡Plantilla añadida!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Cambiar relaciones de archivos adjuntos para la plantilla',
        'Change Template Relations for Attachment' => 'Cambiar las relaciones de plantilla para el archivo adjunto',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '¡Necesita el tipo!',
        'Type added!' => '¡Tipo añadido!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '¡Agente actualizado!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Modificar Relaciones de Grupo para los Agentes',
        'Change Agent Relations for Group' => 'Modificar Relaciones de Agente para los Grupos',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mes',
        'Week' => 'Semana',
        'Day' => 'Día',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Todas las citas',
        'Appointments assigned to me' => 'Citas asignadas a mí',
        'Showing only appointments assigned to you! Change settings' => '¡Mostrando solo citas asignadas a ti! Cambiar configuración',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '¡La cita no fue encontrada!',
        'Never' => 'Nunca',
        'Every Day' => 'Cada Día',
        'Every Week' => 'Cada Semana',
        'Every Month' => 'Cada Mes',
        'Every Year' => 'Cada Año',
        'Custom' => 'Personalizado',
        'Daily' => 'Diario',
        'Weekly' => 'Semanal',
        'Monthly' => 'Mensual',
        'Yearly' => 'Anual',
        'every' => 'cada',
        'for %s time(s)' => 'por %s vez(ces)',
        'until ...' => 'hasta ...',
        'for ... time(s)' => 'por ... vez(ces)',
        'until %s' => 'hasta %s',
        'No notification' => 'Sin notificaciones',
        '%s minute(s) before' => '%s minuto(s) antes',
        '%s hour(s) before' => '%s hora(s) antes',
        '%s day(s) before' => '%s día(s) antes',
        '%s week before' => '%s semanas antes',
        'before the appointment starts' => 'antes de que la cita inicie',
        'after the appointment has been started' => 'después de que la cita halla iniciado',
        'before the appointment ends' => 'antes de que termine la cita',
        'after the appointment has been ended' => 'después de que la cita halla finalizado',
        'No permission!' => 'No tiene permisos!',
        'Cannot delete ticket appointment!' => 'La cita no puede ser borrada!',
        'No permissions!' => 'No tiene permisos!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s más',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Historial del Cliente',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '¡No se da ningún destinatario!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'No hay una configuración para %s',
        'Statistic' => 'Estadísticas',
        'No preferences for %s!' => '¡No hay preferencias para %s!',
        'Can\'t get element data of %s!' => '¡No se pueden obtener los datos del elemento %s!',
        'Can\'t get filter content data of %s!' => '¡No se pueden obtener los datos del contenido del filtro de %s!',
        'Customer Name' => 'Nombre del cliente',
        'Customer User Name' => 'Nombre de Usuario del Cliente',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '¡Necesito un objeto y una clave de origen!',
        'You need ro permission!' => '¡Necesitas permiso!',
        'Can not delete link with %s!' => '¡No se puede borrar el enlace con %s!',
        '%s Link(s) deleted successfully.' => '%s Enlace(s) borrado(s) con éxito.',
        'Can not create link with %s! Object already linked as %s.' => '¡No se puede crear un enlace con %s! El objeto ya está vinculado como %s.',
        'Can not create link with %s!' => 'No se puede eliminar el enlace con %s!',
        '%s links added successfully.' => '%s enlaces añadidos con éxito.',
        'The object %s cannot link with other object!' => '¡El objeto %s no puede enlazar con otro objeto!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '¡El parámetro Grupo es necesario!',
        'This feature is not available.' => 'Esta función no está disponible.',
        'Updated user preferences' => 'Actualización de las preferencias del usuario',
        'System was unable to deploy your changes.' => 'El sistema no ha podido desplegar sus cambios.',
        'Setting not found!' => '¡Configuración no encontrada!',
        'System was unable to reset the setting!' => '¡El sistema no ha podido restablecer la configuración!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Procesar ticket',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Falta el parámetro %s.',
        'Invalid Subaction.' => 'Subacción inválida.',
        'Statistic could not be imported.' => 'Las estadísticas no pudieron ser importadas.',
        'Please upload a valid statistic file.' => 'Por favor suba un archivo estadístico válido.',
        'Export: Need StatID!' => 'Exportar: ¡Necesita StatID!',
        'Delete: Get no StatID!' => 'Borrar: ¡No obtener ningún StatID!',
        'Need StatID!' => '¡Necesita StatID!',
        'Could not load stat.' => 'No se ha podido cargar la estadística.',
        'Add New Statistic' => 'Agregar Nueva Estadística',
        'Could not create statistic.' => 'No se ha podido crear la estadística.',
        'Run: Get no %s!' => 'Correr: ¡No obtiene ningún %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '¡No se da ningún TicketID!',
        'You need %s permissions!' => '¡Necesitas permisos %s!',
        'Loading draft failed!' => '¡Error al carga el borrador!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Lo sentimos, Usted necesita ser el propietario del ticket para realizar esta acción.',
        'Please change the owner first.' => 'Por favor, primero cambie el propietario.',
        'FormDraft functionality disabled!' => '¡Función de formulario borrador desactivada!',
        'Draft name is required!' => '¡El nombre del borrador es obligatorio!',
        'FormDraft name %s is already in use!' => '¡El nombre del formulario borrador %s ya está en uso!',
        'Could not perform validation on field %s!' => '¡No se ha podido realizar la validación del campo %s!',
        'No subject' => 'Sin título',
        'Could not delete draft!' => '¡No se puede borrar el borrador!',
        'Previous Owner' => 'Propietario Anterior',
        'wrote' => 'escribió',
        'Message from' => 'Mensaje de',
        'End message' => 'Fin del mensaje',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '¡Se necesita %s!',
        'Plain article not found for article %s!' => '¡No se ha encontrado ningún artículo para el artículo %s!',
        'Article does not belong to ticket %s!' => '¡El artículo no pertenece al ticket %s!',
        'Can\'t bounce email!' => '¡No se puede rebotar el correo electrónico!',
        'Can\'t send email!' => '¡No se puede enviar el correo electrónico!',
        'Wrong Subaction!' => '¡Subacción equivocada!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '¡No se pueden bloquear los tickets, no se dan TicketIDs!',
        'Ticket (%s) is not unlocked!' => '¡El ticket (%s) no está desbloqueado!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Los siguientes tickets fueron ignorados porque están bloqueados por otro agente o usted no tiene acceso de escritura a los tickets: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'El siguiente ticket fue ignorado porque está bloqueado por otro agente o usted no tiene acceso de escritura al ticket: %s.',
        'You need to select at least one ticket.' => 'Debe seleccionar al menos un ticket.',
        'Bulk feature is not enabled!' => '¡La función "Bulk" no está activada!',
        'No selectable TicketID is given!' => '¡No se da ningún TicketID seleccionable!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'No ha seleccionado ningún ticket o bien sólo los tickets que están bloqueados por otros agentes.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Los siguientes tickets fueron ignorados porque están bloqueados por otro agente o usted no tiene acceso de escritura a estos tickets: %s.',
        'The following tickets were locked: %s.' => 'Los siguientes tickets fueron bloqueados: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '¡El asunto del artículo estará vacío si el asunto sólo contiene el enlace de la entrada!',
        'Address %s replaced with registered customer address.' => 'La dirección %s fue remplazada con la dirección del cliente registrado.',
        'Customer user automatically added in Cc.' => 'Cliente agregado automáticamente en Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '¡Ticket "%s" creado!',
        'No Subaction!' => '¡No hay subacción!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '¡No tengo TicketID!',
        'System Error!' => '¡Error del sistema!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '¡No se da ningún ArticleID!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Próxima semana',
        'Ticket Escalation View' => 'Vista de Escaladas de Ticket',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '¡No se ha encontrado el artículo %s!',
        'Forwarded message from' => 'Mensaje reenviado por',
        'End forwarded message' => 'Fin del mensaje reenviado',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '¡No se puede mostrar el historial, no se da el TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '¡No se puede bloquear el ticket, no se da el TicketID!',
        'Sorry, the current owner is %s!' => '¡Lo siento, el propietario actual es %s!',
        'Please become the owner first.' => 'Por favor, conviértase primero en el propietario.',
        'Ticket (ID=%s) is locked by %s!' => '¡El ticket (ID=%s) está bloqueado por %s!',
        'Change the owner!' => '¡Cambia de propietario!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Nuevo Artículo',
        'Pending' => 'Pendiente',
        'Reminder Reached' => 'Recordatorios alcanzados',
        'My Locked Tickets' => 'Mis Tickets Bloqueados',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '¡No se puede fusionar el ticket con el mismo!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '¡Necesitas permisos para mover!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'El chat no está activo.',
        'No permission.' => 'Sin permiso.',
        '%s has left the chat.' => '%s ha dejado la conversación.',
        'This chat has been closed and will be removed in %s hours.' => 'Esta conversación ha sido cerrada y será eliminada en %s horas.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Ticket bloqueado.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '¡Sin ArticleID!',
        'This is not an email article.' => 'Este no es un artículo de correo electrónico.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '¡No se puede leer el artículo sin formato! Tal vez no hay ningún correo electrónico plano en el backend Lea el mensaje del backend.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '¡Necesita TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '¡No se ha podido obtener el ActivityDialogEntityID "%s"!',
        'No Process configured!' => '¡No hay proceso configurado!',
        'The selected process is invalid!' => '¡El proceso seleccionado es inválido!',
        'Process %s is invalid!' => '¡El proceso %s no es válido!',
        'Subaction is invalid!' => '¡La subacción no es válida!',
        'Parameter %s is missing in %s.' => 'Falta el parámetro %s en %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => '¡No hay ActivityDialog configurado para %s en _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '¡No se ha encontrado ningún Start ActivityEntityID o Start ActivityDialogEntityID para el proceso: %s en _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'No se ha podido obtener el TicketID: ¡%s en _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'No se ha podido determinar el ActivityEntityID. DynamicField o Config ¡no está configurado correctamente!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s ¡Falta un valor de configuración!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '¡No hay ProcessEntityID ni TicketID ni ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '¡No se puede obtener StartActivityDialog y StartActivityDialog para el ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => '¡No se puede obtener Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '¡No se puede obtener el ProcessEntityID o ActivityEntityID para el ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '¡No se puede obtener la configuración de la actividad para ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '¡No se puede obtener la configuración de ActivityDialog para ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '¡No se pueden obtener los datos del campo "%s" del ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime sólo puede utilizarse si State o StateID están configurados para el mismo ActivityDialog. ActivityDialog: ¡%s!',
        'Pending Date' => 'Fecha pendiente',
        'for pending* states' => 'en estado pendiente*',
        'ActivityDialogEntityID missing!' => '¡Falta el ActivityDialogEntityID!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '¡No se ha podido obtener Config para ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => 'No se puede utilizar CustomerID como campo invisible.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Falta el ProcessEntityID, ¡comprueba tu ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '¡No hay StartActivityDialog o StartActivityDialog para el proceso "%s" configurado!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '¡No se ha podido crear un ticket para el proceso con ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '¡No se ha podido establecer ProcessEntityID "%s" en el TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '¡No se ha podido establecer el ActivityEntityID "%s" en el TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'No se ha podido almacenar el ActivityDialog, ¡TicketID inválido: %s!',
        'Invalid TicketID: %s!' => '¡TicketID inválido: %s!',
        'Missing ActivityEntityID in Ticket %s!' => '¡Falta el ActivityEntityID en el Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '¡Este paso ya no pertenece a la actividad actual en proceso para el ticket \'%s%s%s\'! Otro usuario ha modificado este ticket. Por favor, cierre esta ventana y vuelva a cargar el ticket.',
        'Missing ProcessEntityID in Ticket %s!' => '¡Falta el ProcessEntityID en el Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '¡No se ha podido establecer el valor de DynamicField para %s del Ticket con ID "%s" en ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '¡No se ha podido establecer la hora pendiente para el ticket con ID "%s" en el ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Configuración incorrecta del campo ActivityDialog: ¡%s no puede ser Display => 1 / Mostrar campo (Por favor, cambie su configuración para que sea Display => 0 / No mostrar campo o Display => 2 / Mostrar campo como obligatorio)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '¡No se ha podido establecer %s para el Ticket con ID "%s" en ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => '¡Falta la configuración por defecto de Process::Default%s!',
        'Default Config for Process::Default%s invalid!' => '¡La configuración por defecto de Process::Default%s no es válida!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Tickets disponibles',
        'including subqueues' => 'incluir subcolas',
        'excluding subqueues' => 'excluir subcolas',
        'QueueView' => 'Ver la fila',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Tickets bajo mi Responsabilidad',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'última-búsqueda',
        'Untitled' => 'Sin título',
        'Ticket Number' => 'Ticket Número',
        'Ticket' => 'Ticket',
        'printed by' => 'impreso por',
        'CustomerID (complex search)' => 'CustomerID (búsqueda compleja)',
        'CustomerID (exact match)' => 'CustomerID (coincidencia exacta)',
        'Invalid Users' => 'Usuarios Inválidos',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'en mas de ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '¡Función no activada!',
        'Service View' => 'Vista del Servicio',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Vista de Estados',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Mis Tickets Monitoreados',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'La función no está activa',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Enlace Eliminado',
        'Ticket Locked' => 'Ticket Bloqueado',
        'Pending Time Set' => 'Tiempo de espera fijado',
        'Dynamic Field Updated' => 'Campo Dinámico Actualizado',
        'Outgoing Email (internal)' => 'Correo electrónico saliente (interno)',
        'Ticket Created' => 'Ticket Creado',
        'Type Updated' => 'Tipo actualizado',
        'Escalation Update Time In Effect' => 'Tiempo de actualización de la escalada en vigor',
        'Escalation Update Time Stopped' => 'Tiempo de actualización de la escalada detenido',
        'Escalation First Response Time Stopped' => 'Tiempo de primera respuesta Escalada Detenido',
        'Customer Updated' => 'Cliente Actualizado',
        'Internal Chat' => 'Chat Interno',
        'Automatic Follow-Up Sent' => 'Envío automático de seguimiento',
        'Note Added' => 'Nota Agregada',
        'Note Added (Customer)' => 'Nota Agregada (Cliente)',
        'SMS Added' => 'SMS Añadido',
        'SMS Added (Customer)' => 'SMS añadido (cliente)',
        'State Updated' => 'Estado Actualizado',
        'Outgoing Answer' => 'Respuesta de salida',
        'Service Updated' => 'Servicio actualizado',
        'Link Added' => 'Enlace Agregado',
        'Incoming Customer Email' => 'Correo electrónico entrante del cliente',
        'Incoming Web Request' => 'Petición web entrante',
        'Priority Updated' => 'Prioridad Actualizada',
        'Ticket Unlocked' => 'Ticket Desbloqueado',
        'Outgoing Email' => 'Correo Saliente',
        'Title Updated' => 'Título actualizado',
        'Ticket Merged' => 'Ticket Fucionado',
        'Outgoing Phone Call' => 'Llamada telefónica saliente',
        'Forwarded Message' => 'Mensaje reenviado',
        'Removed User Subscription' => 'Suscripción de usuario eliminada',
        'Time Accounted' => 'Tiempo contabilizado',
        'Incoming Phone Call' => 'Llamada telefónica entrante',
        'System Request.' => 'Solicitud del sistema.',
        'Incoming Follow-Up' => 'Seguimiento de las entradas',
        'Automatic Reply Sent' => 'Respuesta automática enviada',
        'Automatic Reject Sent' => 'Rechazo automático enviado',
        'Escalation Solution Time In Effect' => 'Tiempo de solución de escalada en ejecución',
        'Escalation Solution Time Stopped' => 'Tiempo de Solución escalada detenido',
        'Escalation Response Time In Effect' => 'Tiempo de respuesta escalada en ejecución',
        'Escalation Response Time Stopped' => 'Tiempo de respuesta escalada detenido',
        'SLA Updated' => 'SLA Actualizado',
        'External Chat' => 'Chat Externo',
        'Queue Changed' => 'Fila Modificada',
        'Notification Was Sent' => 'Se envió la notificación',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Este ticket no existe, o no tienes permisos para acceder a él en su estado actual.',
        'Missing FormDraftID!' => '¡Falta FormDraftID!',
        'Can\'t get for ArticleID %s!' => '¡No se puede obtener para ArticleID %s!',
        'Article filter settings were saved.' => 'Se ha guardado la configuración del filtro de artículos.',
        'Event type filter settings were saved.' => 'Se ha guardado la configuración del filtro de tipo de evento.',
        'Need ArticleID!' => '¡Necesita un ID de artículo!',
        'Invalid ArticleID!' => '¡ArticleID inválido!',
        'Forward article via mail' => 'Reenviar artículo por email',
        'Forward' => 'Reenviar',
        'Fields with no group' => 'Campos sin grupo',
        'Invisible only' => 'Sólo invisible',
        'Visible only' => 'Sólo visible',
        'Visible and invisible' => 'Visible e invisible',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'No se ha podido abrir el artículo. ¿Quizás el artículo está en otra página?',
        'Show one article' => 'Mostrar un artículo',
        'Show all articles' => 'Mostrar todos los artículos',
        'Show Ticket Timeline View' => 'Mostrar Vista de Linea Temporal del Ticket',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'No hay FormID.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Error: el archivo no ha podido ser eliminado correctamente. Por favor, póngase en contacto con su administrador (falta el FileID).',

        # Perl Module: Kernel/Modules/CustomerDashboardCommon.pm
        'Registration for tile %s of CustomerDashboard is invalid! Either Module or Template needed.' =>
            '',
        'Registration for tile %s of CustomerDashboard is invalid! Order needs to be a unique number.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '¡Se necesita el ArticleID!',
        'No TicketID for ArticleID (%s)!' => '¡No hay TicketID para ArticleID (%s)!',
        'HTML body attachment is missing!' => '¡Falta el cuerpo HTML adjunto!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '¡El FileID y el ArticleID son necesarios!',
        'No such attachment (%s)!' => '¡No existe el archivo adjunto (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Compruebe la configuración de SysConfig para %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Compruebe la configuración de SysConfig para %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'No tiene permisos suficientes para la creación de tickets en la cola por defecto.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '¡Necesita la identificación del cliente!',
        'My Tickets' => 'Mis Tickets',
        'Company Tickets' => 'Tickets de la Empresa',
        'Untitled!' => '¡Sin título!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Nombre Real del Cliente',
        'Created within the last' => 'Creado dentro del ultimo',
        'Created more than ... ago' => 'Creado hace más de...',
        'Please remove the following words because they cannot be used for the search:' =>
            'Por favor, elimine las siguientes palabras porque no se pueden utilizar para la búsqueda:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'No puedo reabrir el ticket, ¡no es posible en esta cola!',
        'Create a new ticket!' => '¡Cree un nuevo ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '¡Modo seguro activado!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Si quiere volver a ejecutar el instalador, desactive el SecureMode en el SysConfig.',
        'Directory "%s" doesn\'t exist!' => '¡El directorio "%s" no existe!',
        'Configure "Home" in Kernel/Config.pm first!' => '¡Configure primero "Home" en Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => '¡Archivo "%s/Kernel/Config.pm" no encontrado!',
        'Directory "%s" not found!' => '¡Directorio "%s" no encontrado!',
        'Install OTOBO' => 'Instalar OTOBO',
        'Intro' => 'Introducción',
        'Kernel/Config.pm isn\'t writable!' => '¡Kernel/Config.pm es de solo lectura!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Si quieres usar el instalador, ¡pon el Kernel/Config.pm como escribible para el usuario del servidor web!',
        'Database Selection' => 'Selección de la Base de datos',
        'Unknown Check!' => '¡Comprobación Desconocida!',
        'The check "%s" doesn\'t exist!' => 'El comprobador "%s" ¡no existe!',
        'Enter the password for the database user.' => 'Introduzca la contraseña para el usuario de base de datos.',
        'Database %s' => 'Base de datos %s',
        'Configure MySQL' => 'Configurar MySQL',
        'Enter the password for the administrative database user.' => 'Introduzca la contraseña para el usuario administrador de la base de datos.',
        'Configure PostgreSQL' => 'Configurar PostgreSQL',
        'Configure Oracle' => 'Configurar Oracle',
        'Unknown database type "%s".' => 'Tipo de base de datos desconocido "%s".',
        'Please go back.' => 'Por favor, vuelve.',
        'Create Database' => 'Crear Base de Datos',
        'Install OTOBO - Error' => 'Instalar OTOBO - Error',
        'File "%s/%s.xml" not found!' => '¡Archivo "%s/%s.xml" no encontrado!',
        'Contact your Admin!' => '¡Póngase en contacto con su administrador!',
        'https' => 'https',
        'http' => 'http',
        'System Settings' => 'Configuración del sistema',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'Configurar correo',
        'Mail Configuration' => 'Configuración de Correo',
        'Can\'t write Config file!' => '¡No se puede escribir el archivo de configuración!',
        'Unknown Subaction %s!' => '¡Subacción desconocida %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'No se puede conectar a la base de datos, ¡el módulo de Perl DBD::%s no está instalado!',
        'Can\'t connect to database, read comment!' => 'No se puede conectar a la base de datos, ¡lee el comentario!',
        'Database already contains data - it should be empty!' => 'La Base de datos ya contiene datos - debe estar vacía!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Error: Por favor, asegúrese de que su base de datos acepta paquetes de más de %s MB de tamaño (actualmente sólo acepta paquetes de hasta %s MB). Por favor, adapte el ajuste max_allowed_packet de su base de datos para evitar errores.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Error: Por favor, establezca el valor de innodb_log_file_size en su base de datos a un mínimo de %s MB (actual: %s MB, recomendado: %s MB). Para más información, por favor, eche un vistazo a %s.',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            'Si desea volver a ejecutar la herramienta MigrateFromOTRS, desactive el SecureMode en la SysConfig.',
        'OTRS to OTOBO migration' => 'Migración de OTRS a OTOBO',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'No se tiene %s!',
        'No such user!' => 'No existe el usuario!',
        'Invalid calendar!' => '¡Calendario inválido!',
        'Invalid URL!' => 'URL inválido!',
        'There was an error exporting the calendar!' => 'Se produjo un error al exportar el calendario!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Necesita configurar Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => '¡Ha fallado la autenticación de %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Rebotar el artículo a una dirección de correo diferente',
        'Bounce' => 'Rebotar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Responder a todos',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Reenviar este artículo',
        'Resend' => 'Reenviar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Ver detalles del registro de mensajes de este artículo',
        'Message Log' => 'Registro de mensajes',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Responder la nota',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Dividir este artículo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Ver la fuente de este artículo',
        'Plain Format' => 'Sin formato',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Imprimir este artículo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at hello@otobo.io' => 'Póngase en contacto con nosotros en hello@otobo.io',
        'Get Help' => 'Obtener ayuda',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Volver a instalar el paquete',
        'Re-install' => 'Vuelva a instalar',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Encriptado',
        'Sent message encrypted to recipient!' => '¡Mensaje encriptado enviado al destinatario!',
        'Signed' => 'Firmado',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'Se ha encontrado la cabecera "PGP SIGNED MESSAGE", ¡pero no es válida!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'Se ha encontrado la cabecera "S/MIME SIGNED MESSAGE", ¡pero no es válida!',
        'Ticket decrypted before' => 'Ticket descifrado antes de',
        'Impossible to decrypt: private key for email was not found!' => 'Imposible descifrar: ¡no se ha encontrado la clave privada del correo electrónico!',
        'Successful decryption' => 'Desencriptación exitosa',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'No hay claves de cifrado disponibles para las direcciones: \'%s\'. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'No hay claves de cifrado para las direcciones seleccionadas : \'%s\'. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'No se pueden utilizar claves de cifrado caducadas para las direcciones: \'%s\'. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'No se pueden utilizar claves de cifrado revocadas para las direcciones: \'%s\'. ',
        'Encrypt' => 'Cifrar',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Las claves/certificados sólo se mostrarán para los destinatarios con más de una clave/certificado. Se preseleccionará la primera clave/certificado encontrada. Por favor, asegúrese de seleccionar la correcta.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Seguridad del correo electrónico',
        'PGP sign' => 'Firma PGP',
        'PGP sign and encrypt' => 'Firma y encriptación PGP',
        'PGP encrypt' => 'Encriptación PGP',
        'SMIME sign' => 'firma SMIME',
        'SMIME sign and encrypt' => 'Firma y encriptación SMIME',
        'SMIME encrypt' => 'Encriptación SMIME',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'No se puede utilizar la clave de firma caducada: \'%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'No se puede utilizar la clave de firma revocada: \'%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'No hay claves de firma disponibles para las direcciones \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'No hay claves de firma seleccionadas para las direcciones \'%s\'.',
        'Sign' => 'Firma',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Las claves/certificados sólo se mostrarán para un remitente con más de una clave/certificado. Se preseleccionará la primera clave/certificado encontrada. Por favor, asegúrese de seleccionar la correcta.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Mostrados (as)',
        'Refresh (minutes)' => 'Actualization (minutos)',
        'off' => 'apagado',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Id. de cliente mostrados',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Los clientes mostrados',
        'Offline' => 'Fuera de línea',
        'User is currently offline.' => 'El usuario está actualmente desconectado.',
        'User is currently active.' => 'El usuario está actualmente activo.',
        'Away' => 'Fuera de servicio',
        'User was inactive for a while.' => 'El usuario estuvo inactivo durante un tiempo.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '¡La hora de inicio de un ticket se ha fijado después de la hora de finalización!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => '¡No se puede conectar al servidor de OTOBO News!',
        'Can\'t get OTOBO News from server!' => '¡No se pudo obtener las noticias de OTOBO desde el servidor!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '¡No se puede conectar con el servidor de noticias de productos!',
        'Can\'t get Product News from server!' => '¡No puedo obtener noticias de productos del servidor!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '¡No se puede conectar a %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Tickets Mostrados',
        'Shown Columns' => 'Mostrar columnas',
        'filter not active' => 'filtro no activo',
        'filter active' => 'filtro activo',
        'This ticket has no title or subject' => 'Este ticket no tiene título o asunto',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Estadísticas Semanales',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'El usuario ha establecido su estado como no disponible.',
        'Unavailable' => 'No disponible',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Estándar',
        'The following tickets are not updated: %s.' => 'Los siguientes tickets no están actualizados: %s.',
        'h' => 'h',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Este ticket no existe, o no tiene permisos para acceder a él en su estado actual. Puede realizar una de las siguientes acciones:',
        'This is a' => 'Este es un',
        'email' => 'correo',
        'click here' => 'haga click aquí',
        'to open it in a new window.' => 'para abrir en una nueva ventana.',
        'Year' => 'Año',
        'Hours' => 'Horas',
        'Minutes' => 'Minutos',
        'Check to activate this date' => 'Marcar para activar esta fecha',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '¡No tiene permiso!',
        'No Permission' => 'Sin permiso',
        'Show Tree Selection' => 'Mostrar el árbol de selección',
        'Split Quote' => 'Dividir Cita',
        'Remove Quote' => 'Eliminar presupuesto',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Enlazado como',
        'Search Result' => 'Resultados de Búsqueda',
        'Linked' => 'Enlazado',
        'Bulk' => 'Acciones en Lote',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Reducida',
        'Unread article(s) available' => 'Artículo(s) sin leer disponible',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Cita',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Búsqueda de archivos',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Agente Conectado: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '¡No hay más tickets escalados!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Seleccione una zona horaria en sus preferencias y confírmela haciendo clic en el botón de guardar.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Cliente Conectado: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '¡El mantenimiento del sistema está activo!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Un período de mantenimiento del sistema comenzará en: %s y se espera que termine en: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'El Demonio de OTOBO no está en ejecución.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Tiene habilitado «Fuera de la oficina», ¿desea inhabilitarlo?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Tiene %s ajustes no válidos desplegados. Haga clic aquí para mostrar los ajustes no válidos.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Tienes ajustes sin desplegar, ¿quieres desplegarlos?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'La configuración se está actualizando, por favor sea paciente...',
        'There is an error updating the system configuration!' => '¡Hay un error al actualizar la configuración del sistema!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '¡No utilices la cuenta de superusuario para trabajar con %s! Crea nuevos Agentes y trabaja con estas cuentas en su lugar.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Por favor asegúrese de haber seleccionado al menos un método de transporte para las notificaciones obligatorias.',
        'Preferences updated successfully!' => '¡Las preferencias se actualizaron satisfactoriamente!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(en proceso)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Por favor especifique una fecha de término posterior a la fecha de inicio.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Verificar contraseña',
        'The current password is not correct. Please try again!' => '¡Contraseña incorrecta Por favor, intente de nuevo!',
        'Please supply your new password!' => '¡Por favor ingrese una nueva contraseña!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            'No se puede actualizar la contraseña, la nueva contraseña y la repetida no coinciden.',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Esta contraseña está prohibida por la configuración actual del sistema. Por favor, póngase en contacto con el administrador si tiene preguntas adicionales.',
        'Can\'t update password, it must be at least %s characters long!' =>
            '¡No se puede actualizar su contraseña, porque debe contener al menos %s caracteres!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '¡No se puede actualizar la contraseña, debe contener al menos 2 letras minúsculas y 2 mayúsculas!',
        'Can\'t update password, it must contain at least 1 digit!' => '¡No se puede actualizar su contraseña, porque debe contener al menos 1 dígito!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'No se puede actualizar la contraseña, ¡debe contener al menos 2 caracteres de letra!',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            'No se puede actualizar la contraseña, ¡debe contener al menos 3 de 4 (minúscula, mayúscula, numero, carácter especial)!',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '¡Zona horaria actualizada con éxito!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'inválido',
        'valid' => 'válido',
        'No (not supported)' => 'No (no soportado)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'No se ha seleccionado el valor de tiempo relativo completo pasado o completo actual+próximo.',
        'The selected time period is larger than the allowed time period.' =>
            'El período de tiempo seleccionado es mayor que el período de tiempo permitido.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'No hay valor de escala de tiempo disponible para el valor de escala de tiempo seleccionado actualmente en el eje X.',
        'The selected date is not valid.' => 'La fecha seleccionada no es válida.',
        'The selected end time is before the start time.' => 'La hora de finalización seleccionada es anterior a la hora de inicio.',
        'There is something wrong with your time selection.' => 'Hay algo que no funciona en su selección de tiempo.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Por favor, seleccione sólo un elemento o permita la modificación en el momento de generar las estadísticas.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Por favor, seleccione al menos un valor de este campo o permita su modificación en el momento de generar las estadísticas.',
        'Please select one element for the X-axis.' => 'Por favor seleccione un elemento para el Eje-X.',
        'You can only use one time element for the Y axis.' => 'Sólo puede utilizar un elemento de tiempo para el eje Y.',
        'You can only use one or two elements for the Y axis.' => 'Sólo puede utilizar uno o dos elementos para el eje Y.',
        'Please select at least one value of this field.' => 'Por favor, seleccione al menos un valor de este campo.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Por favor, proporcione un valor o permita la modificación en el momento de generar las estadísticas.',
        'Please select a time scale.' => 'Por favor seleccione una escala de tiempo.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'El intervalo de tiempo del informe es demasiado pequeño, por favor, utilice una escala de tiempo mayor.',
        'second(s)' => 'segundo(s)',
        'quarter(s)' => 'trimestre(s)',
        'half-year(s)' => 'semestre(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Por favor, elimine las siguientes palabras porque no se pueden utilizar para las restricciones del ticket: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Cancelar la edición y desbloquear este ajuste',
        'Reset this setting to its default value.' => 'Restablece este ajuste a su valor por defecto.',
        'Unable to load %s!' => '¡No se puede cargar %s!',
        'Content' => 'Contenido',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Desbloquearlo para devolverlo a la fila',
        'Lock it to work on it' => 'Bloquear para trabajar en el',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Dejar de monitorear',
        'Remove from list of watched tickets' => 'Quitar de la lista de tickets monitoreados',
        'Watch' => 'Monitorear',
        'Add to list of watched tickets' => 'Agregar a la lista de tickets monitoreados',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordenar por',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Ticket Bloqueado Nuevo',
        'Locked Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets Bloqueados',
        'Locked Tickets Total' => 'Total de Tickets Bloqueados',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Ticket Nuevo bajo mi Responsabilidad',
        'Responsible Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets bajo mi Responsabilidad',
        'Responsible Tickets Total' => 'Total de Tickets bajo mi Responsabilidad',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Ticket a Monitorear Nuevo',
        'Watched Tickets Reminder Reached' => 'Recordatorio Alcanzado de Tickets Monitoreados',
        'Watched Tickets Total' => 'Total de Tickets Monitoreados',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Campos Dinámicos del Ticket',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'No se ha podido leer el archivo de configuración ACL. Por favor, asegúrese de que el archivo es válido.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Actualmente no es posible iniciar sesión debido a un mantenimiento programado del sistema.',

        # Perl Module: Kernel/System/AuthSession.pm
        'Session limit reached! Please try again later.' => '¡Límite de sesiones alcanzado! Por favor intente más tarde.',
        'Session per user limit reached!' => '¡Se ha alcanzado el límite de sesiones por usuario!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sesión no válida. Por favor, entre de nuevo.',
        'Session has timed out. Please log in again.' => 'La sesión ha caducado. Por favor, conéctese nuevamente.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Solo firmar con PGP',
        'PGP encrypt only' => 'Solo encriptar con PGP',
        'SMIME sign only' => 'Solo firmar con SMIME',
        'SMIME encrypt only' => 'Solo encryptor con SMIME',
        'PGP and SMIME not enabled.' => 'PGP y SMIME no están habilitados.',
        'Skip notification delivery' => 'Omitir entrega de notificación',
        'Send unsigned notification' => 'Enviar notificación sin firmar',
        'Send unencrypted notification' => 'Enviar notificación sin encriptar',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referencia de las Opciones de Configuración',
        'This setting can not be changed.' => 'Esta configuración no puede ser cambiada.',
        'This setting is not active by default.' => 'Esta configuración no está activa por omisión.',
        'This setting can not be deactivated.' => 'Esta configuración no puede ser desactivada.',
        'This setting is not visible.' => 'Este ajuste no es visible.',
        'This setting can be overridden in the user preferences.' => 'Esta configuración se puede anular en las preferencias del usuario.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Esta configuración puede anularse en las preferencias del usuario, pero no está activa por defecto.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'El usuario del cliente "%s" ya existe.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Esta cuenta de correo electrónico se encuentra actualmente en uso por otro usuario del cliente.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'antes/después',
        'between' => 'entre',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'p. ej. Texto o Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Ignorar este campo.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Este campo es requerido o',
        'The field content is too long!' => 'El contenido del campo es demasiado largo!',
        'Maximum size is %s characters.' => 'El tamaño máximo es de %s caracteres.',

        # Perl Module: Kernel/System/MigrateFromOTRS/CloneDB/Backend.pm
        'Sanity checks for database.' => 'Comprobaciones de limpieza para la base de datos.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOACLDeploy.pm
        'Deploy the ACL configuration.' => 'Despliegue de la configuración ACL.',
        'Deployment completed, perfect!' => 'Despliegue completado, ¡perfecto!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOAutoResponseTemplatesMigrate.pm
        'Migrate database table auto_responses.' => 'Migrar la tabla de la base de datos auto_responses.',
        'Migration failed.' => 'La migración falló.',
        'Migrate database table auto_response.' => 'Migrar la tabla de la base de datos auto_response.',
        'Migration completed, perfect!' => 'Migración completada, ¡perfecto!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCacheCleanup.pm
        'OTOBO Cache cleanup.' => 'Limpieza de la caché de OTOBO.',
        'Completed.' => 'Completado.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOCopyFilesFromOTRS.pm
        'Need OTRSData->%s!' => '¡Necesita OTRSData->%s!',
        'Can\'t access OTRS Home: %s!' => '¡No se puede acceder a OTRS Home: %s!',
        'All needed files copied and migrated, perfect!' => 'Todos los archivos necesarios copiados y migrados, ¡perfecto!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Copy database.' => 'Copiar base de datos.',
        'Skipped...' => 'Omitiendo...',
        'System was unable to connect to OTRS database.' => 'El sistema no pudo conectarse a la base de datos OTRS.',
        'System was unable to complete data transfer.' => 'El sistema no pudo completar la transferencia de datos.',
        'Data transfer completed.' => 'Transferencia de datos completada.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO version is correct.' => 'Compruebe si la versión de OTOBO es correcta.',
        'Check if OTOBO and OTRS connect is possible.' => 'Compruebe si la conexión de OTOBO y OTRS es posible.',
        'Can\'t open RELEASE file from OTRSHome: %s!' => '¡No se puede abrir el archivo RELEASE de OTRSHome: %s!',
        'Check if OTOBO and OTRS version is correct.' => 'Compruebe si la versión de OTOBO y OTRS es correcta.',
        '%s does not exist!' => '¡%s no existe!',
        'Can\'t read OTOBO RELEASE file: %s: %s!' => 'No se puede leer el archivo OTOBO RELEASE: ¡%s: %s!',
        'No OTOBO system found!' => '¡No se ha encontrado ningún sistema OTOBO!',
        'You are trying to run this script on the wrong framework version %s!' =>
            '¡Está intentando ejecutar este script en la versión de framework %s incorrecta!',
        'OTOBO Version is correct: %s.' => 'La versión de OTOBO es correcta: %s.',
        'Check if OTRS version is correct.' => 'Compruebe si la versión de OTRS es correcta.',
        'OTRS RELEASE file %s does not exist: %s!' => '¡El archivo OTRS RELEASE %s no existe: %s!',
        'Can\'t read OTRS RELEASE file: %s: %s!' => 'No se puede leer el archivo OTRS RELEASE: ¡%s: %s!',
        'No OTRS system found!' => '¡No se ha encontrado ningún sistema OTRS!',
        'OTRS Version is correct: %s.' => 'La versión de OTRS es correcta: %s.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOItsmTablesMigrate.pm
        'Migrate ITSM database tables.' => '',
        'Nothing to do, as the the table \'%s\' does not exist.' => '',
        'UPDATE of the table \'%s\' failed.' => '',
        'Migration completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => 'Migrar los ajustes de configuración.',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            'Se ha producido un error durante la migración de datos de SysConfig o no existe ninguna configuración.',
        'An error occured during SysConfig migration when writing XML to DB.' =>
            'Se ha producido un error durante la migración de SysConfig al escribir XML en la base de datos.',
        'SysConfig data migration completed.' => 'Se ha completado la migración de datos de SysConfig.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => 'Migrar la configuración del servicio web.',
        'Failed - see the log!' => 'Falló - ¡vea el registro!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => 'Migrar la tabla de notificación de la base de datos.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => '¡No se puede abrir el archivo Kernel/Config.pm desde OTRSHome: %s!',
        'Check if Kernel/Config.pm exists in OTOBO home.' => 'Compruebe si Kernel/Config.pm existe en el home de OTOBO.',
        'Kernel/Config.pm exists in OTOBO home' => 'Kernel/Config.pm existe en el home de OTOBO',
        'Check if we are able to connect to OTRS Home.' => 'Compruebe si podemos conectarnos a l home de OTRS.',
        'Can\'t connect to OTRS file directory.' => 'No se puede conectar al directorio de archivos OTRS.',
        'Connect to OTRS file directory is possible.' => 'La conexión al directorio de archivos OTRS es posible.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => 'Prueba la conexión a la base de datos y las comprobaciones de integridad.',
        'Could not create database object.' => 'No se ha podido crear el objeto base de datos.',
        'Database connect and sanity checks completed.' => 'Conexión de la base de datos y comprobaciones de integridad completadas.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => 'Compruebe si todos los paquetes necesarios están instalados.',
        'The following packages are only installed in OTRS:' => 'Los siguientes paquetes sólo se instalan en OTRS:',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            'Por favor, instale (o desinstale) los paquetes antes de la migración. Si un paquete no existe para OTOBO, por favor contacte con el equipo de OTOBO en bugs\@otobo.org. Encontraremos una solución.',
        'The same packages are installed on both systems, perfect!' => 'Los mismos paquetes están instalados en ambos sistemas, ¡perfecto!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPackageSpecifics.pm
        'Package specific tasks' => 'Tareas específicas del paquete',
        'Done -' => 'Terminado -',
        'Failed at -' => 'Falló en -',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => 'Compruebe si se han instalado todos los módulos Perl necesarios.',
        '%s script does not exist.' => 'El script %s no existe.',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            'Faltan uno o más módulos Perl necesarios. Por favor, instálelos como se recomienda y ejecute de nuevo el script de migración.',
        'All required Perl modules have been installed, perfect!' => 'Se han instalado todos los módulos Perl necesarios, ¡perfecto!',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPostmasterFilterMigrate.pm
        'Migrate postmaster filter.' => 'Migrar el filtro postmaster.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => 'Despliegue de la configuración de gestión de procesos.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => 'Migrar la tabla de la base de datos response_template.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => 'Migrar la tabla de saludos de la base de datos.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => 'Migrar la tabla de firmas de la base de datos.',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOStatsMigrate.pm
        'Migrate statistics.' => 'Migrar las estadísticas.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'No se ha podido leer el archivo de configuración de la notificación. Por favor, asegúrese de que el archivo es válido.',
        'Imported notification has body text with more than 4000 characters.' =>
            'La notificación importada tiene un cuerpo de texto con más de 4000 caracteres.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'no instalado',
        'installed' => 'instalado',
        'Unable to parse repository index document.' => 'No es posible traducir el documento de índice del repositorio.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'No se encontraron paquetes en este repositorio para la versión del framework que ud. utiliza, sólo contiene paquetes para otras versiones.',
        'File is not installed!' => '¡El archivo no está instalado!',
        'File is different!' => '¡El archivo es diferente!',
        'Can\'t read file!' => '¡No se puede leer el archivo!',
        '<p>Additional packages can enhance OTOBO with plenty of useful features. Ensure, however, that the origin of this package is trustworthy, as it can modify OTOBO in any possible way.</p>' =>
            '<p>Los paquetes adicionales pueden mejorar OTOBO con un montón de características útiles. Asegúrese, sin embargo, de que el origen de este paquete es de confianza, ya que puede modificar OTOBO de cualquier manera posible.</p>',
        'Package not verified by the OTOBO community!' => '¡Paquete no verificado por la comunidad OTOBO!',
        '<p>The installation of packages which are not verified is disabled. You can activate the installation of not verified packages via the "Package::AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>La instalación de paquetes no verificados está desactivada. Puede activar la instalación de paquetes no verificados mediante el ajuste de configuración del sistema "Package::AllowNotVerifiedPackages".</p>',
        'Verification not possible (e.g. no internet connection)!' => '¡No es posible la verificación (por ejemplo, si no hay conexión a Internet)!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'El proceso "%s" y todos sus datos han sido importados con éxito.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inactivo',
        'FadeAway' => 'Desaparecer',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'No es posible contactar con el servidor de registro. Por favor, inténtelo de nuevo más tarde.',
        'No content received from registration server. Please try again later.' =>
            'No se ha recibido ningún contenido del servidor de registro. Por favor, inténtelo de nuevo más tarde.',
        'Can\'t get Token from sever' => 'No se puede obtener el Token del servidor',
        'Username and password do not match. Please try again.' => 'El nombre de usuario y contraseña no coinciden. Por favor intente de nuevo.',
        'Problems processing server result. Please try again later.' => 'Problemas al procesar el resultado del servidor. Por favor, inténtelo de nuevo más tarde.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Suma',
        'week' => 'semana',
        'quarter' => 'trimestre',
        'half-year' => 'semestre',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tipo de Estado',
        'Created Priority' => 'Prioridad de Creación',
        'Created State' => 'Estado de Creación',
        'Create Time' => 'Tiempo de Creación',
        'Pending until time' => 'Pendiente hasta el momento',
        'Close Time' => 'Fecha de Cierre',
        'Escalation' => 'Escalada',
        'Escalation - First Response Time' => 'Escalada - Tiempo de Primera Respuesta',
        'Escalation - Update Time' => 'Escalada - Tiempo de Actualización',
        'Escalation - Solution Time' => 'Escalada - Tiempo de Solución',
        'Agent/Owner' => 'Agente/Propietario',
        'Created by Agent/Owner' => 'Creado por Agente/Propietario',
        'Assigned to Customer User Login' => 'Asignado al inicio de sesión del usuario del cliente',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evaluación por',
        'Ticket/Article Accounted Time' => 'Tiempo utilizado por el Ticket/Articulo',
        'Ticket Create Time' => 'Tiempo de creación del ticket',
        'Ticket Close Time' => 'Tiempo de cierre del ticket',
        'Accounted time by Agent' => 'Tiempo utilizado por el Agente',
        'Total Time' => 'Tiempo Total',
        'Ticket Average' => 'Ticket-Promedio',
        'Ticket Min Time' => 'Ticket-Tiempo Mín',
        'Ticket Max Time' => 'Ticket-Tiempo Máx',
        'Number of Tickets' => 'Número de tickets',
        'Article Average' => 'Artículo-Promedio',
        'Article Min Time' => 'Artículo-Tiempo Mín',
        'Article Max Time' => 'Artículo-Tiempo Máx',
        'Number of Articles' => 'Número de artículos',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'ilimitado',
        'Attributes to be printed' => 'Atributos a imprimir',
        'Sort sequence' => 'Secuencia de ordenamiento',
        'State Historic' => 'Historial del Estado',
        'State Type Historic' => 'Historial del Tipo de Estado',
        'Historic Time Range' => 'Rango Tiempo Histórico',
        'Number' => 'Número',
        'Last Changed' => 'Último cambio',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Solución contenedora',
        'Solution Min Time' => 'Tiempo mínimo de Solución',
        'Solution Max Time' => 'Tiempo máximo de Solución',
        'Solution Average (affected by escalation configuration)' => 'Solución Contenedora (afectada por la configuración de la escalada)',
        'Solution Min Time (affected by escalation configuration)' => 'Tiempo mínimo para la solución (afectado por la configuración de la escalada)',
        'Solution Max Time (affected by escalation configuration)' => 'Tiempo máximo para la solución (afectado por la configuración de la escalada)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Promedio del tiempo de trabajo para la solución (afectado por la configuración de la escalada)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Tiempo de trabajo mínimo para la solución (afectado por la configuración de la escalada)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Tiempo máximo de trabajo para la solución (afectado por la configuración de la escalada)',
        'First Response Average (affected by escalation configuration)' =>
            'Promedio para la primera respuesta (afectada por la configuración de la escalada)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Tiempo mínimo para primera respuesta (afectado por la configuración de la escalada)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Tiempo máximo para primera respuesta (afectado por la configuración de la escalada)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Tiempo promedio de trabajo para la primera respuesta (afectado por la configuración de la escalada)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Tiempo de trabajo mínimo para la primera respuesta (afectado por la configuración de la escalada)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Tiempo máximo de trabajo para la primera respuesta (afectado por la configuración de la escalada)',
        'Number of Tickets (affected by escalation configuration)' => 'Número de tickets (afectados por la configuración de la escalada)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Días',
        'Queues / Tickets' => 'Colas / Tickets',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Tablas obsoletas',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'Se han encontrado tablas obsoletas en la base de datos. Se pueden eliminar si están vacías.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabla presente',
        'Internal Error: Could not open file.' => 'Error Interno: No es posible abrir el archivo.',
        'Table Check' => 'Comprobación De Tablas',
        'Internal Error: Could not read file.' => 'Error Interno: No es posible leer el archivo.',
        'Tables found which are not present in the database.' => 'Se encontraron tablas que no están presentes en la base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Tamaño de Base de datos',
        'Could not determine database size.' => 'No fué posible determinar el tamaño de la Base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versión de la Base de datos',
        'Could not determine database version.' => 'No fué posible determinar la versión de la Base de datos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Juego de Caracteres de la Conexión del Cliente',
        'Setting character_set_client needs to be utf8.' => 'Configura character_set_client a un valor de utf8.',
        'Server Database Charset' => 'Juego de Caracteres del Servidor de Base de Datos',
        'Please convert your database to the character set \'utf8mb4\'.' =>
            'Por favor, convierta su base de datos al juego de caracteres \'utf8mb4\'.',
        'Table Charset' => 'Juego de Caracter de la Tabla',
        'There were tables found which do not have \'utf8mb4\' as charset.' =>
            'Se han encontrado tablas que no tienen \'utf8mb4\' como conjunto de caracteres.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Tamaño del Archivo Log de InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'La variable \'innodb_log_file_size\' debe ser de al menos 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Valores por defecto inválidos',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            'Se han encontrado tablas con valores por defecto no válidos. Para solucionarlo automáticamente, ejecute: bin/otobo.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Tamaño Máximo de Consulta',
        'The setting \'max_allowed_packet\' must be 64 MB or higher.' => 'El ajuste \'max_allowed_packet\' debe ser de 64 MB o superior.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Tamaño del Cache de la Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'La varialbe \'query_cache_size\' debe ser usada ( y ser mayor de 10 MB pero no mas de 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Motor de Almacenamiento Predeterminado',
        'Table Storage Engine' => 'Motor de Almacenamiento de Tabla',
        'Tables with a different storage engine than the default engine were found.' =>
            'Se encontraron tablas con diferente motor de almacenamiento que el motor configurado como predeterminado.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Se requiere MySQL 5.x o superior.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Variable NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG debe establecerse como al32utf8 (por ejemplo, GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Configuración de NLS_DATE_FORMAT',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT debe estar configurado como \'AAAA-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Ajuste de la comprobación SQL',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Secuencias de claves primarias y Triggers',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'Se han encontrado las siguientes secuencias y/o triggers con posibles nombres erróneos. Por favor, cámbieles el nombre manualmente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'La configuración de client_encoding debe ser UNICODE o UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'La configuración de server_encoding debe ser UNICODE o UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato de fecha',
        'Setting DateStyle needs to be ISO.' => 'La configuración DateStyle necesita ser ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Secuencias de claves primarias',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'Se han encontrado las siguientes secuencias con posibles nombres erróneos. Por favor, renómbralas manualmente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'Se requiere PostgreSQL 9.2 o superior.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Partición en disco para OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Uso de las particiones en disco',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribución',
        'Could not determine distribution.' => 'No fué posible determinar la distribución.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versión de Kernel',
        'Could not determine kernel version.' => 'No fue posible determinar la versión del Kernel.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carga del Sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'La carga del sistema debe ser como máximo el número de CPUs que el sistema tiene (ej. una carga de 8 o menos en un sistema con 8 CPUs es adecuado).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Módulos Perl',
        'Not all required Perl modules are correctly installed.' => 'No todos los módulos Perl necesarios están instalados correctamente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Auditoría de módulos Perl',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit ha informado de que uno o más módulos de Perl instalados tienen vulnerabilidades conocidas. Tenga en cuenta que puede haber falsos positivos para las distribuciones que parchean los módulos de Perl sin cambiar su número de versión.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::Audit no informó de ninguna vulnerabilidad conocida en los módulos de Perl instalados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Espacio Swap libre (%)',
        'No swap enabled.' => 'Swap no habilitado.',
        'Used Swap Space (MB)' => 'Swap utilizado (MB)',
        'There should be more than 60% free swap space.' => 'Debe estar libre mas del 60% del swap.',
        'There should be no more than 200 MB swap space used.' => 'No deben de usarse más de 200 MB del swap.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Estado del índice de búsqueda de artículos',
        'Indexed Articles' => 'Artículos Indexados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Artículos por canal de comunicación',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Comunicaciones entrantes',
        'Outgoing communications' => 'Comunicaciones salientes',
        'Failed communications' => 'Comunicaciones fallidas',
        'Average processing time of communications (s)' => 'Tiempo medio de procesamiento de las comunicaciones (s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Registro de comunicaciones Estado de la cuenta (últimas 24 horas)',
        'No connections found.' => 'No se ha encontrado ninguna conexión.',
        'ok' => 'Vale',
        'permanent connection errors' => 'errores de conexión permanentes',
        'intermittent connection errors' => 'errores de conexión intermitentes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Ajustes de configuración',
        'Could not determine value.' => 'No es posible determinar el valor.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Demonio',
        'Daemon is running.' => 'Demonio en ejecución.',
        'Daemon is not running.' => 'El demonio no está en ejecución.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Registros de la base de datos',
        'Ticket History Entries' => 'Entradas del Historial de Tickets',
        'Articles' => 'Artículos',
        'Attachments (DB, Without HTML)' => 'Adjuntos (BD, Sin HTML)',
        'Customers With At Least One Ticket' => 'Clientes Con Al Menos Un ticket',
        'Dynamic Field Values' => 'Valores para campos dinámicos',
        'Invalid Dynamic Fields' => 'Campos Dinámicos Invalidos',
        'Invalid Dynamic Field Values' => 'Valorres del Campo Dinámico Invalidos',
        'GenericInterface Webservices' => 'Interfaz genérica de servicios web',
        'Process Tickets' => 'Proceso de Tickets',
        'Months Between First And Last Ticket' => 'Meses Entre el Primer y Último Ticket',
        'Tickets Per Month (avg)' => 'Tickets por Mes (promedio)',
        'Open Tickets' => 'Tickets Abiertos',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Nombre de Usuario y Contraseña SOAP Predeterminados',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Riesgo de seguridad: utiliza la configuración por defecto para SOAP::User y SOAP::Password. Por favor, cámbiela.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Contraseña predeterminada del Administrador',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Riesgo de seguridad: la cuenta del agente root@localhost todavía tiene la contraseña predeterminada. Por favor cambie la contraseña o invalide la cuenta.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Cola de envío de correo electrónico',
        'Emails queued for sending' => 'Correos electrónicos en cola para enviar',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nombre de dominio)',
        'Please configure your FQDN setting.' => 'Por favor configure su FQDN.',
        'Domain Name' => 'Nombre de Dominio',
        'Your FQDN setting is invalid.' => 'La configuración de su FQDN (nombre de dominio totalmente calificado) es inválido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Sistema de Archivo con permisos de Escritura',
        'The file system on your OTOBO partition is not writable.' => 'El sistema de archivos de su partición OTOBO no es escribible.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Copias de seguridad de la configuración heredada',
        'No legacy configuration backup files found.' => 'No se han encontrado archivos de copia de seguridad de la configuración heredada.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Los archivos de copia de seguridad de la configuración heredada se encuentran en la carpeta Kernel/Config/Backups, pero pueden seguir siendo necesarios para algunos paquetes.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Los archivos de copia de seguridad de la configuración heredada ya no son necesarios para los paquetes instalados, por favor, elimínelos de la carpeta Kernel/Config/Backups.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Estado de la Instalación del Paquete',
        'Some packages have locally modified files.' => 'Algunos paquetes tienen archivos modificados localmente.',
        'Some packages are not correctly installed.' => 'Algunos paquetes no están correctamente instalados.',
        'Package Verification Status' => 'Estado de verificación del paquete',
        'Some packages are not verified by the OTOBO Team.' => 'Algunos paquetes no son verificados por el equipo de OTOBO.',
        'Package Framework Version Status' => 'Estado de la versión del Framework',
        'Some packages are not allowed for the current framework version.' =>
            'Algunos paquetes no están permitidos para la versión actual del framework.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Lista de Paquetes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Ajustes de configuración de la sesión',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'Mensajes de correo electrónico en cola',
        'There are emails in var/spool that OTOBO could not process.' => 'Hay correos electrónicos en var/spool que OTOBO no ha podido procesar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'La configuración de su SystemID no es válida, sólo debería contener dígitos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Tipo de Ticket Predeterminado',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'El tipo de ticket configurado por defecto no es válido o no existe. Cambie el ajuste Ticket::Type::Default y seleccione un tipo de ticket válido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Módulo de Indices de Tickets',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Tiene más de 60.000 tickets y debería utilizar el backend StaticDB. Consulte el manual del administrador (Performance Tuning) para obtener más información.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Usuarios no válidos con tickets bloqueados',
        'There are invalid users with locked tickets.' => 'Hay usuarios no válidos con entradas bloqueadas.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'No debería tener más de 8,000 tickets abiertos en su sistema.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Módulo Búsquedas Indexadas de Tickets',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'El proceso de indexación obliga a almacenar el texto original del artículo en el índice de búsqueda de artículos, sin ejecutar filtros ni aplicar listas de palabras de parada. Esto aumentará el tamaño del índice de búsqueda y, por tanto, puede ralentizar las búsquedas de texto completo.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Registros huérfanos en la tabla ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'La tabla ticket_lock_index contiene registros huérfanos. Por favor, ejecute bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpiar el índice de StaticDB.',
        'Orphaned Records In ticket_index Table' => 'Registros huérfanos en la tabla ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'La tabla ticket_index contiene registros huérfanos. Por favor, ejecute bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpiar el índice de StaticDB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Ajustes de tiempo',
        'Server time zone' => 'Zona horaria del servidor',
        'OTOBO time zone' => 'Zona horaria de OTOBO',
        'OTOBO time zone is not set.' => 'La zona horaria de OTOBO no está configurada.',
        'User default time zone' => 'Zona horaria por defecto del usuario',
        'User default time zone is not set.' => 'La zona horaria por defecto del usuario no está configurada.',
        'Calendar time zone is not set.' => 'La zona horaria del calendario no está configurada.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - Uso de la interfaz del agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'IU - Uso del tema del agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'IU - Estadísticas especiales',
        'Agents using custom main menu ordering' => 'Agentes que utilizan la ordenación personalizada del menú principal',
        'Agents using favourites for the admin overview' => 'Agentes que utilizan los favoritos para la visión general del administrador',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Servidor Web',
        'Loaded Apache Modules' => 'Módulos Apache cargados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Modelo MPM',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO requiere que apache se ejecute con el modelo MPM \'prefork\'.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Uso Del Acelerador de CGI',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Debería utilizar FastCGI o mod_perl para aumentar su rendimiento.',
        'mod_deflate Usage' => 'Uso de mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Por favor, instale mod_deflate para mejorar la velocidad de la GUI.',
        'mod_filter Usage' => 'Uso de mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Por favor, instale mod_filter si se utiliza mod_deflate.',
        'mod_headers Usage' => 'Uso de mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Por favor, instale mod_headers para mejorar la velocidad de la GUI.',
        'Apache::Reload Usage' => 'Uso de Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload o Apache2::Reload deben usarse como PerlModule y PerlInitHandler para evitar que se reinicie el servidor web al instalar y actualizar módulos.',
        'Apache2::DBI Usage' => 'Uso de Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI debería utilizarse para obtener un mejor rendimiento con conexiones a bases de datos preestablecidas.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variables de entorno',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Soporte a la Recolección de datos',
        'Support data could not be collected from the web server.' => 'Los datos de soporte no pudieron ser recogidos del servidor web.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/PSGIEnv.pm
        'PSGI Environment' => 'Entorno PSGI',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Plack/RunsUnderPSGI.pm
        'Runs under PSGI' => 'Se ejecuta bajo PSGI',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versión del Servidor Web',
        'Could not determine webserver version.' => 'No se puedo determinar la versión del servidor web.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Detalles de los usuarios concurrentes',
        'Concurrent Users' => 'Usuarios Concurrentes',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'Aceptar',
        'Problem' => 'Problema',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '¡La configuración %s no existe!',
        'Setting %s is not locked to this user!' => '¡La configuración %s no está bloqueada para este usuario!',
        'Setting value is not valid!' => '¡El valor establecido no es válido!',
        'Could not add modified setting!' => '¡No se ha podido añadir la configuración modificada!',
        'Could not update modified setting!' => '¡No se ha podido actualizar la configuración modificada!',
        'Setting could not be unlocked!' => '¡No se ha podido desbloquear el ajuste!',
        'Missing key %s!' => '¡Falta la clave %s!',
        'Invalid setting: %s' => 'Configuración no válida: %s',
        'Could not combine settings values into a perl hash.' => 'No se han podido combinar los valores de configuración en un hash perl.',
        'Can not lock the deployment for UserID \'%s\'!' => '¡No se puede bloquear el despliegue para el UserID \'%s\'!',
        'All Settings' => 'Todos los ajustes',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Por defecto',
        'Value is not correct! Please, consider updating this field.' => 'El valor no es correcto. Por favor, considere actualizar este campo.',
        'Value doesn\'t satisfy regex (%s).' => 'El valor no satisface la regex (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Activado',
        'Disabled' => 'Desactivado',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            '¡El sistema no pudo calcular la fecha del usuario en la OTOBOTimeZone!!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            '¡El sistema no ha podido calcular el DateTime del usuario en OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'El valor no es correcto. Por favor, considere actualizar este módulo.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'El valor no es correcto. Por favor, considere actualizar esta configuración.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Reinicio del tiempo de desbloqueo.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Participante en el chat',
        'Chat Message Text' => 'Texto del mensaje de chat',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many failed login attempts, please retry in %s s.' => 'Demasiados intentos de inicio de sesión fallidos, por favor reintente en %s s.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '¡Inicio de sesión fallido! Nombre de usuario o contraseña incorrecto.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'La autenticación se ha realizado con éxito, pero no se ha encontrado ningún registro de datos de usuario en la base de datos. Por favor, póngase en contacto con el administrador.',
        'Can`t remove SessionID.' => 'No se puede eliminar el SessionID.',
        'Logout successful.' => 'Cierre de sesión con éxito.',
        'Feature not active!' => '¡Funcionalidad inactiva!',
        'Sent password reset instructions. Please check your email.' => 'Instrucciones de restablecimiento de contraseña enviadas. Por favor, revise su correo electrónico.',
        'Invalid Token!' => '¡Información inválida!',
        'Sent new password to %s. Please check your email.' => 'Contraseña nueva enviada a %s. Por favor, revise su correo electrónico.',
        'Error: invalid session.' => 'Error: sesión no válida.',
        'No Permission to use this frontend module!' => '¡No hay permiso para utilizar este módulo del frontend!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'La autenticación se ha realizado con éxito, pero no se ha encontrado ningún registro de cliente en el backend de clientes. Por favor, póngase en contacto con el administrador.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'No se ha podido restablecer la contraseña. Por favor, póngase en contacto con el administrador.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Esta dirección de correo ya existe. Por favor inicie su sesión o reestablezca su contraseña.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Esta dirección de email no se puede usar para registrarse. Por favor contacte al personal de soporte.',
        'Added via Customer Panel (%s)' => 'Añadido a través del panel de clientes (%s)',
        'Customer user can\'t be added!' => '¡El usuario del cliente no puede ser agregado!',
        'Can\'t send account info!' => '¡No se puede enviar la información de la cuenta!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Cuenta nueva creada. Información de inicio de sesión enviada a %s. Por favor, revise su correo electrónico.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'If you want to re-run installer.pl, then disable the SecureMode in the SysConfig.' =>
            'Si quieres volver a ejecutar installer.pl, entonces desactiva el SecureMode en el SysConfig.',
        'Action "%s" not found!' => '¡Acción "%s" no encontrada!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run migration.pl, then disable the SecureMode in the SysConfig.' =>
            'Si quieres volver a ejecutar migration.pl, entonces desactiva el SecureMode en el SysConfig.',

        # Database XML / SOPM Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'temporalmente-inválido',
        'Group for default access.' => 'Grupo de acceso predeterminado.',
        'Group of all administrators.' => 'Grupo para todos los administradores.',
        'Group for statistics access.' => 'Grupo para acceder a las estadísticas.',
        'new' => 'nuevo',
        'All new state types (default: viewable).' => 'Todos los nuevos tipos de estado (por defecto: visible).',
        'open' => 'abierto',
        'All open state types (default: viewable).' => 'Todos los tipos de estado abiertos (por defecto: visibles).',
        'closed' => 'cerrado',
        'All closed state types (default: not viewable).' => 'Todos los tipos de estado cerrados (por defecto: no visibles).',
        'pending reminder' => 'recordatorio pendiente',
        'All \'pending reminder\' state types (default: viewable).' => 'Todos los tipos de estado de "recordatorio pendiente" (por defecto: visible).',
        'pending auto' => 'pendiente automático',
        'All \'pending auto *\' state types (default: viewable).' => 'Todos los tipos de estado \'pendiente de auto *\' (por defecto: visible).',
        'removed' => 'eliminado',
        'All \'removed\' state types (default: not viewable).' => 'Todos los tipos de estado "eliminados" (por defecto: no visibles).',
        'merged' => 'mezclado',
        'State type for merged tickets (default: not viewable).' => 'Tipo de estado para los tickets fusionados (por defecto: no visible).',
        'New ticket created by customer.' => 'Nuevo ticket abierto por un cliente.',
        'closed successful' => 'cerrado exitosamente',
        'Ticket is closed successful.' => 'Ticket cerrado exitosamente.',
        'closed unsuccessful' => 'cerrado sin éxito',
        'Ticket is closed unsuccessful.' => 'Ticket cerrado sin éxito.',
        'Open tickets.' => 'Tickets abiertos.',
        'Customer removed ticket.' => 'El cliente eliminó el ticket.',
        'Ticket is pending for agent reminder.' => 'Este ticket está pendiente para efectuar un recordatorio al agente.',
        'pending auto close+' => 'pendiente auto close+',
        'Ticket is pending for automatic close.' => 'Ticket está pendiente para cierre automático.',
        'pending auto close-' => 'pendiente auto close-',
        'State for merged tickets.' => 'Estado de los tickets mezclados.',
        'system standard salutation (en)' => 'saludo estándar del sistema (en)',
        'Standard Salutation.' => 'Saludo Estándar.',
        'system standard signature (en)' => 'firma estándar del sistema (en)',
        'Standard Signature.' => 'Firma Estándar.',
        'Standard Address.' => 'Dirección Estandar.',
        'possible' => 'posible',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Es posible realizar un seguimiento de los tickets cerrados. El ticket será reabierto.',
        'reject' => 'rechazar',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'No es posible hacer un seguimiento de los tickets cerrados. No se creará un nuevo ticket.',
        'new ticket' => 'nuevo ticket',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'No es posible hacer un seguimiento de los tickets cerrados. Se creará un nuevo ticket.',
        'Postmaster queue.' => 'Fila Postmaster.',
        'All default incoming tickets.' => 'Todo los tickers entrantes predeterminados.',
        'All junk tickets.' => 'Todo los tickets basura.',
        'All misc tickets.' => 'Todos los tickets misceláneos.',
        'auto reply' => 'auto responder',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Respuesta automática que se enviará tras la creación de un nuevo ticket.',
        'auto reject' => 'auto rechazar',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Rechazo automático que se enviará después de que se haya rechazado un seguimiento (en caso de que la opción de seguimiento de la cola sea "rechazar").',
        'auto follow up' => 'auto seguimiento',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Confirmación automática que se envía después de recibir un seguimiento de un ticket (en caso de que la opción de seguimiento de la cola sea "posible").',
        'auto reply/new ticket' => 'auto responder/nuevo ticket',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Respuesta automática que se enviará después de que se haya rechazado un seguimiento y se haya creado un nuevo ticket (en caso de que la opción de seguimiento de la cola sea "nuevo ticket").',
        'auto remove' => 'auto eliminar',
        'Auto remove will be sent out after a customer removed the request.' =>
            'La eliminación automática se enviará después de que el cliente haya eliminado la solicitud.',
        'default reply (after new ticket has been created)' => 'respuesta por defecto (tras la creación de un nuevo ticket)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'rechazo por defecto (tras el seguimiento y rechazo de un ticket cerrado)',
        'default follow-up (after a ticket follow-up has been added)' => 'seguimiento por defecto (después de añadir un seguimiento del ticket)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'rechazo por defecto/nuevo ticket creado (después de un seguimiento cerrado con la creación de un nuevo ticket)',
        'Unclassified' => 'No clasificado',
        '1 very low' => '1 muy bajo',
        '2 low' => '2 bajo',
        '3 normal' => '3 normal',
        '4 high' => '4 alto',
        '5 very high' => '5 muy alto',
        'unlock' => 'desbloquear',
        'lock' => 'bloquear',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'agente',
        'system' => 'sistema',
        'customer' => 'cliente',
        'Ticket create notification' => 'Notificación de ticket creado',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Recibirá una notificación cada vez que se cree un nuevo ticket en una de sus "Mis Colas" o "Mis Servicios".',
        'Ticket follow-up notification (unlocked)' => 'Notificación de seguimiento del ticket (desbloqueado)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Recibirá una notificación si un cliente envía un seguimiento a un ticket desbloqueado que está en "Mis Colas" o "Mis Servicios".',
        'Ticket follow-up notification (locked)' => 'Notificación de seguimiento del ticket (bloqueado)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Recibirá una notificación si un cliente envía un seguimiento a un ticket bloqueado del que usted es el propietario o responsable.',
        'Ticket lock timeout notification' => 'Notificación de bloqueo de tickets por tiempo',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Recibirá una notificación en cuanto se desbloquee automáticamente un ticket de su propiedad.',
        'Ticket owner update notification' => 'Notificación para cambio del propietario del ticket',
        'Ticket responsible update notification' => 'Notificación para cambio del responsable de ticket',
        'Ticket new note notification' => 'Notificación para nueva nota de ticket',
        'Ticket queue update notification' => 'Notificación de cambio en la fila de espera de ticket',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Recibirá una notificación si un ticket se mueve a una de sus "Mis Colas".',
        'Ticket pending reminder notification (locked)' => 'Notificación de recordatorio de ticket pendiente (bloqueado)',
        'Ticket pending reminder notification (unlocked)' => 'Notificación de recordatorio de ticket pendiente (desbloqueado)',
        'Ticket escalation notification' => 'Notificación de escalada de tickets',
        'Ticket escalation warning notification' => 'Notificación de advertencia de escalada de tickets',
        'Ticket service update notification' => 'Notificación de actualización del servicio de tickets',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Recibirá una notificación si el servicio de un ticket se cambia a uno de sus "Mis Servicios".',
        'Appointment reminder notification' => 'Notificación de recordatorio de citas',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Recibirá una notificación cada vez que se alcance una hora de recordatorio para una de sus citas.',
        'Ticket email delivery failure notification' => 'Notificación de fallo en la entrega del ticket por correo electrónico',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Error durante la comunicación AJAX. Estado: %s, Error: %s',
        'This window must be called from compose window.' => 'Esta ventana debe ser llamada desde la ventana de composición.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Agregar todo',
        'An item with this name is already present.' => 'Ya esta presente un item con el mismo nombre.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este ítem todavía contiene sub ítems. Está seguro que desea eliminarlo incluyendo sus sub items?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Más',
        'Less' => 'Menos',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Pulse Ctrl+C (Cmd+C) para copiar al portapapeles',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Eliminar este Archivo Adjunto',
        'Deleting attachment...' => 'Eliminando archivo adjunto...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Se ha producido un error al eliminar el archivo adjunto. Por favor, consulte los registros para obtener más información.',
        'Attachment was deleted successfully.' => 'El archivo adjunto fue eliminado satisfactoriamente.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '¿Seguro que desea eliminar este campo dinámico? ¡Se PERDERÁN TODOS los datos asociados a este campo!',
        'Delete field' => 'Eliminar campo',
        'Deleting the field and its data. This may take a while...' => 'Eliminando el campo y su información. Esto puede tomar un tiempo...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Eliminar este campo dinámico',
        'Remove selection' => 'Quitar selección',
        'Do you really want to delete this generic agent job?' => '¿Realmente quieres eliminar este trabajo de agente genérico?',
        'Delete this Event Trigger' => 'Eliminar este Disparador de Evento',
        'Duplicate event.' => 'Evento duplicado.',
        'This event is already attached to the job, Please use a different one.' =>
            'Este evento ya está ligado al trabajo. Por favor seleccione uno diferente.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Sucedió un error durante la comunicación.',
        'Request Details' => 'Detalles de la petición',
        'Request Details for Communication ID' => 'Solicitar detalles para el ID Comunicación',
        'Show or hide the content.' => 'muestra u oculta el contenido.',
        'Clear debug log' => 'Limpiar log de depuración',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Eliminar el módulo de tratamiento de errores',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'No es posible añadir un nuevo trigger de evento porque el evento no está configurado.',
        'Delete this Invoker' => 'Eliminar este invocador',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Lo siento, la única condición existente no puede ser eliminada.',
        'Sorry, the only existing field can\'t be removed.' => 'Lo siento, el único campo existente no puede ser eliminado.',
        'Delete conditions' => 'Eliminar condiciones',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Asignación de la clave %s',
        'Mapping for Key' => 'Mapeo para la clave',
        'Delete this Key Mapping' => 'Eliminar este mapeo de teclas',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Eliminar esta Operación',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Clonar el web service',
        'Delete operation' => 'Eliminar operación',
        'Delete invoker' => 'Eliminar invocador',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ATENCIÓN: Cuando cambia el nombre del grupo \'admin\', antes de realizar los cambios apropiados en SysConfig, bloqueará el panel de administración! Si esto sucediera, por favor vuelva a renombrar el grupo para administrar por declaración SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Eliminar esta cuenta de correo',
        'Deleting the mail account and its data. This may take a while...' =>
            'Borrar la cuenta de correo y sus datos. Esto puede llevar un tiempo...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '¿Realmente quieres eliminar este lenguaje de notificación?',
        'Do you really want to delete this notification?' => '¿Está Usted seguro que desea eliminar esta notificación?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '¿Realmente quieres borrar esta llave?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Hay un proceso de actualización de paquetes en marcha, haga clic aquí para ver la información sobre el progreso de la actualización.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'Recientemente se ha terminado de actualizar un paquete. Haga clic aquí para ver los resultados.',
        'No response from get package upgrade result.' => 'No hay respuesta del resultado de la actualización del paquete.',
        'Update all packages' => 'Actualizar todos los paquetes',
        'Dismiss' => 'Descartar',
        'Update All Packages' => 'Actualizar todos los paquetes',
        'No response from package upgrade all.' => 'No hay respuesta de la actualización todos los paquetes.',
        'Currently not possible' => 'Actualmente no es posible',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Actualmente está desactivado debido a una actualización de paquetes que está en curso.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Esta opción se encuentra actualmente deshabilitada debido a que el Demonio de OTOBO no está en ejecución.',
        'Are you sure you want to update all installed packages?' => '¿Está seguro de que quiere actualizar todos los paquetes instalados?',
        'No response from get package upgrade run status.' => 'No hay respuesta al obtener el estado de ejecución de la actualización del paquete.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Eliminar este PostMasterFilter',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Borrar el filtro postmaster y sus datos. Esto puede llevar un tiempo...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Eliminar Entidad del Lienzo',
        'No TransitionActions assigned.' => 'No hay TransitionActions asignadas.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Todavía no hay diálogos asignados. Sólo tiene que elegir un diálogo de actividad de la lista de la izquierda y arrastrarlo hasta aquí.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta actividad no puede ser eliminada porque es la actividad de inicio.',
        'Remove the Transition from this Process' => 'Elimine la Transición de este Proceso',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'En cuanto utilice este botón o enlace, saldrá de esta pantalla y su estado actual se guardará automáticamente. ¿Desea continuar?',
        'Delete Entity' => 'Eliminar Entidad',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Actividad ya se utiliza en el Proceso. ¡No puede añadirla dos veces!',
        'Error during AJAX communication' => 'Error durante la comunicación AJAX',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Ya se ha colocado una transición no conectada en el escenario. Por favor, conecte primero esta transición antes de colocar otra.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Esta Transición ya se ha utilizado para esta Actividad. ¡No puede utilizarla dos veces!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta TransitionAction ya se ha utilizado en esta ruta. ¡No puede utilizarla dos veces!',
        'Hide EntityIDs' => 'Ocultar EntityIDs',
        'Edit Field Details' => 'Editar Detalles del Campo',
        'Customer interface does not support articles not visible for customers.' =>
            'La interfaz del cliente no admite artículos no visibles para los clientes.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Lo sentimos, el único parámetro existente no puede ser eliminado.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '¿Realmente quiere eliminar este certificado?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Enviando Actualización...',
        'Support Data information was successfully sent.' => 'Información de Datos de Soporte fue enviada satisfactoriamente.',
        'Was not possible to send Support Data information.' => 'No fue posible enviar los Datos de Soporte.',
        'Update Result' => 'Resultado de la actualización',
        'Generating...' => 'Generando...',
        'It was not possible to generate the Support Bundle.' => 'No ha sido posible generar el paquete de soporte.',
        'Generate Result' => 'Generar Resultado',
        'Support Bundle' => 'Paquete de Soporte',
        'The mail could not be sent' => 'El correo no pudo ser enviado',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'No es posible establecer esta entrada como inválida. Todos los ajustes de configuración afectados tienen que ser cambiados de antemano.',
        'Cannot proceed' => 'No se puede proceder',
        'Update manually' => 'Actualizar manualmente',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Puedes hacer que los ajustes afectados se actualicen automáticamente para reflejar los cambios que acabas de hacer o hacerlo por tu cuenta pulsando "actualizar manualmente".',
        'Save and update automatically' => 'Guardar y actualizar automáticamente',
        'Don\'t save, update manually' => 'No guardar, actualizar manualmente',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'El elemento que está viendo forma parte de un ajuste de configuración aún no desplegado, por lo que es imposible editarlo en su estado actual. Por favor, espere hasta que la configuración haya sido desplegada. Si no está seguro de qué hacer a continuación, póngase en contacto con el administrador del sistema.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Cargando...',
        'Search the System Configuration' => 'Buscar en la configuración del sistema',
        'Please enter at least one search word to find anything.' => 'Por favor, introduzca al menos una palabra de búsqueda para encontrar algo.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Desafortunadamente el despliegue no es posible en este momento, tal vez porque otro agente ya está desplegando. Por favor, inténtelo de nuevo más tarde.',
        'Deploy' => 'Desplegar',
        'The deployment is already running.' => 'El despliegue ya está en marcha.',
        'Deployment successful. You\'re being redirected...' => 'Despliegue exitoso. Está siendo redirigido...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Se ha producido un error. Por favor, guarde todos los ajustes que está editando y compruebe los registros para obtener más información.',
        'Reset option is required!' => '¡La opción de reinicio es necesaria!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Al restaurar este despliegue, todos los ajustes volverán al valor que tenían en el momento del despliegue. ¿Realmente quiere continuar?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Las claves con valores no pueden ser renombradas. Por favor, elimine este par clave/valor y vuelva a añadirla después.',
        'Unlock setting.' => 'Desbloquear la configuración.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '¿Está seguro de que quiere eliminar todos los valores del usuario?',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '¿Realmente quiere eliminar este mantenimiento programado del sistema?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Eliminar esta plantilla',
        'Deleting the template and its data. This may take a while...' =>
            'Borrar la plantilla y sus datos. Esto puede llevar un tiempo...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Saltar a',
        'Timeline Month' => 'Línea de tiempo Mensual',
        'Timeline Week' => 'Línea de tiempo Semanal',
        'Timeline Day' => 'Línea de tiempo Diaria',
        'Previous' => 'Previo(a)',
        'Resources' => 'Recursos',
        'Su' => 'Dom',
        'Mo' => 'Lun',
        'Tu' => 'Mar',
        'We' => 'Miér',
        'Th' => 'Jue',
        'Fr' => 'Vier',
        'Sa' => 'Sáb',
        'This is a repeating appointment' => 'Esta es una cita repetitiva',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '¿Desea editar solo esta ocurrencia o todas las ocurrencias?',
        'All occurrences' => 'Todas las ocurrencias',
        'Just this occurrence' => 'Solo esta',
        'Too many active calendars' => 'Demasiados calendarios activos',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Por favor desactive algunos primero o incremente el límite en la configuración.',
        'Restore default settings' => 'Restaurar la configuración por defecto',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '¿Está seguro de que desea eliminar esta cita? Esta operación no se puede deshacer.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Primero seleccione un usuario cliente, luego seleccione un ID de cliente para asignar a este ticket.',
        'Duplicated entry' => 'Entrada duplicada',
        'It is going to be deleted from the field, please try again.' => 'Se va a borrar del campo, por favor, inténtelo de nuevo.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Introduzca al menos un valor a buscar, o * para buscar todo.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Información acerca del Demonio de OTOBO',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Compruebe que los campos marcados en rojo tienen datos válidos.',
        'month' => 'mes',
        'Remove active filters for this widget.' => 'Eliminar los filtros activos para este widget.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => 'Este valor de la base de datos del campo dinámico ya está seleccionado.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Por favor, espere...',
        'Searching for linkable objects. This may take a while...' => 'Buscando objetos enlazables. Esto puede llevar un tiempo...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '¿Realmente quieres borrar este enlace?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '¿Utilizas un plugin de navegador como AdBlock o AdBlockPlus? Esto puede causar varios problemas y le recomendamos que añada una excepción para este dominio.',
        'Do not show this warning again.' => 'No volver a mostrar esta advertencia.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Lo sentimos, pero no se pueden desactivar todos los métodos de las notificaciones marcadas como obligatorias.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Lo sentimos, pero no se pueden desactivar todos los métodos para esta notificación.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Tenga en cuenta que al menos uno de los ajustes que ha cambiado requiere una recarga de la página. Haga clic aquí para recargar la pantalla actual.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Se ha producido un error desconocido. Por favor, póngase en contacto con el administrador.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Cambiar a modo de escritorio',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor elimine las siguientes palabras a buscar pues estas no pueden ser buscadas por:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Generar',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Este elemento tiene elementos hijos y actualmente no puede ser eliminado.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '¿Realmente desea eliminar esta estadística?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Seleccione un ID de cliente para asignar a este ticket',
        'Do you really want to continue?' => '¿Desea continuar?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...y %s más',
        ' ...show less' => ' ...ver menos',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Agregar borrador',
        'Delete draft' => 'Eliminar borrador',
        'There are no more drafts available.' => 'No hay más borradores disponibles.',
        'It was not possible to delete this draft.' => 'No fue posible eliminar este borrador.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtro de artículos',
        'Apply' => 'Aplicar',
        'Event Type Filter' => 'Filtro de Tipo Evento',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Deslice la barra de navegación',
        'Please turn off Compatibility Mode in Internet Explorer!' => '¡Desactive el modo de compatibilidad en Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Cambiar a modo móvil',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Error: !Fallo la comprobación del navegador!',
        'Reload page' => 'Recargar la página',
        'Reload page (%ss)' => 'Recargar la página (%ss)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'El espacio de nombres %s no pudo ser inicializado, porque %s no pudo ser encontrado.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '¡Se ha producido un error! ¡Por favor, compruebe el registro de errores del navegador para obtener más detalles!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '¡Ha ocurrido al menos un error!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Verificación satisfactoria de correo.',
        'Error in the mail settings. Please correct and try again.' => 'Error en las configuraciones de lcorreo. Por favor, corríjalas y vuelva a intentarlo.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'Abrir este nodo en una nueva ventana',
        'Please add values for all keys before saving the setting.' => 'Por favor, añada valores para todas las claves antes de guardar la configuración.',
        'The key must not be empty.' => 'La clave no debe estar vacía.',
        'A key with this name (\'%s\') already exists.' => 'Ya existe una clave con este nombre (\'%s\').',
        'Do you really want to revert this setting to its historical value?' =>
            '¿Realmente quieres revertir este ajuste a su valor histórico?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Abrir fecha seleccionada',
        'Invalid date (need a future date)!' => '¡Fecha inválida (se requiere una fecha futura)!',
        'Invalid date (need a past date)!' => '¡Fecha inválida (debe ser anterior)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'No disponible',
        'and %s more...' => 'y %s más...',
        'Show current selection' => 'Mostrar la selección actual',
        'Current selection' => 'Selección actual',
        'Clear all' => 'Limpiar todo',
        'Filters' => 'Filtros',
        'Clear search' => 'Limpiar búsqueda',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '¡Si sale de esta página ahora, todas las ventanas pop-up también se cerrarán!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Ya hay una pop-up abierta de esta pantalla. ¿Desea cerrarla y cargar esta en su lugar?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'No se pudo abrir la ventana pop-up. Por favor, deshabilite cualquier bloqueador de pop-ups para esta aplicación.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Ordenación ascendente aplicada, ',
        'Descending sort applied, ' => 'Ordenación descendente aplicada, ',
        'No sort applied, ' => 'No se aplica una ordenación, ',
        'sorting is disabled' => 'la ordenación está desactivada',
        'activate to apply an ascending sort' => 'activar para aplicar una ordenación ascendente',
        'activate to apply a descending sort' => 'activar para aplicar una ordenación descendente',
        'activate to remove the sort' => 'activar para eliminar el ordenamiento',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Eliminar el filtro',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Actualmente no hay elementos disponibles para seleccionar.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Por favor, seleccione sólo un archivo para cargar.',
        'Sorry, you can only upload one file here.' => 'Lo sentimos, sólo puedes subir un archivo aquí.',
        'Sorry, you can only upload %s files.' => 'Lo sentimos, sólo puedes subir archivos %s.',
        'Please only select at most %s files for upload.' => 'Por favor, seleccione sólo un máximo de %s archivos para cargar.',
        'The following files are not allowed to be uploaded: %s' => 'No se permite cargar los siguientes archivos: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Los siguientes archivos exceden el tamaño máximo permitido por archivo de %s y no fueron cargados: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Los siguientes archivos ya fueron cargados y no han sido cargados de nuevo: %s',
        'No space left for the following files: %s' => 'No queda espacio para los siguientes archivos: %s',
        'Available space %s of %s.' => 'Espacio disponible %s de %s.',
        'Upload information' => 'Cargar información',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Se produjo un error desconocido al eliminar el archivo adjunto. Inténtalo de nuevo. Si el error persiste, póngase en contacto con el administrador del sistema.',

        # JS File: Core.Language.UnitTest
        'yes' => 'sí',
        'no' => 'no',
        'This is %s' => 'Esto es %s',
        'Complex %s with %s arguments' => 'Complejo %s con argumentos %s',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'No hay datos disponibles.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Agrupado',
        'Stacked' => 'Apilado',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Flujo',
        'Expanded' => 'Expandido',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Estimado cliente,

Lamentablemente no hemos podido detectar un número de ticket válido
en su asunto, por lo que este correo no puede ser procesado.

Por favor, cree un nuevo ticket a través del panel de cliente.

Gracias por su ayuda.

 Su equipo de asistencia técnica
',
        ' (work units)' => ' (unidades de trabajo)',
        ' 2 minutes' => ' 2 minutos',
        ' 5 minutes' => ' 5 minutos',
        ' 7 minutes' => ' 7 minutos',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Diseño delgado" interfaz que trata de ahorrar espacio en la pantalla para los usuarios avanzados.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(UserLogin) Nombre Apellido',
        '(UserLogin) Lastname Firstname' => '(UserLogin) Apellido Nombre',
        '(UserLogin) Lastname, Firstname' => '(UserLogin) Apellido, Nombre',
        '*** out of office until %s (%s d left) ***' => '*** fuera de la oficina hasta %s (%s d izquierda) ***',
        '0 - Disabled' => '0 - Desactivado',
        '1 - Available' => '1 - Disponible',
        '1 - Enabled' => '1 - Activado',
        '10 Minutes' => '10 Minutos',
        '100 (Expert)' => '100 (Experto)',
        '15 Minutes' => '15 Minutos',
        '2 - Enabled and required' => '2 - Activado y necesario',
        '2 - Enabled and shown by default' => '2 - Activado y mostrado por defecto',
        '2 - Enabled by default' => '2 - Activado por defecto',
        '2 Minutes' => '2 Minutos',
        '200 (Advanced)' => '200 (Avanzado)',
        '30 Minutes' => '30 Minutos',
        '300 (Beginner)' => '300 (principiante)',
        '5 Minutes' => '5 minutos',
        'A TicketWatcher Module.' => 'Un módulo de TicketWatcher.',
        'A Website' => 'Un sito web',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Una lista de campos dinámicos que se fusionan en el ticket principal durante una operación de fusión. Sólo se establecerán los campos dinámicos que estén vacíos en el ticket principal.',
        'A picture' => 'Una imagen',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'Módulo ACL que permite cerrar los tickets padre únicamente si todos sus hijos ya están cerrados ("Estado" muestra cuáles estados no están disponibles para el ticket padre, hasta que todos sus hijos estén cerrados).',
        'Access Control Lists (ACL)' => 'Listas de Control de Acceso (ACL)',
        'AccountedTime' => 'Tiempo contabilizado',
        'Activate Elasticsearch.' => 'Activar Elasticsearch.',
        'Activates Rendering of DynamicFields outside of the DynamicField block.' =>
            'Activa el renderizado de DynamicFields fuera del bloque DynamicField.',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Activa un mecanismo de parpadeo para la fila que contiene el ticket más antiguo.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Activa la función de contraseña perdida para agentes, en la interfaz de los mismos.',
        'Activates lost password feature for customers.' => 'Activa la función de contraseña perdida para clientes.',
        'Activates support for customer and customer user groups.' => 'Activa el soporte para el cliente y grupos de usuarios del cliente.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Activa el filtro de artículos en la vista detallada para especificar qué artículos deben mostrarse.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Activa los temas disponibles en el sistema. Valor 1 significa activo, 0 es inactivo.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Activa la búsqueda del sistema de archivo de tickets en la interfaz del cliente.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Activa el sistema de archivo de tickets para tener un sistema más rápido, al mover algunos tickets fuera del ámbito diario. Para buscar estos tickets, la bandera de archivo tiene que estar habilitada en la ventana de búsqueda.',
        'Activates time accounting.' => 'Activa la contatibilidad de tiempo.',
        'ActivityID' => 'ActivityID',
        'Add a note to this ticket' => 'Agregar una nota a este tieckt',
        'Add an inbound phone call to this ticket' => 'Añadir una llamada telefónica entrante a este ticket',
        'Add an outbound phone call to this ticket' => 'Añadir una llamada telefónica de salida a este ticket',
        'Added %s time unit(s), for a total of %s time unit(s).' => 'Añadidas %s unidades de tiempo, para un total de %s unidades de tiempo.',
        'Added email. %s' => 'Correo añadido. %s',
        'Added follow-up to ticket [%s]. %s' => 'Se ha añadido seguimiento al ticket [%s]. %s',
        'Added link to ticket "%s".' => 'Añadido enlace al ticket "%s".',
        'Added note (%s).' => 'Nota añadida (%s).',
        'Added phone call from customer.' => 'Llamada telefónica añadida del cliente.',
        'Added phone call to customer.' => 'Se ha añadido una llamada telefónica al cliente.',
        'Added subscription for user "%s".' => 'Añadida subscripción para el usuario "%s".',
        'Added system request (%s).' => 'Se ha añadido una solicitud del sistema (%s).',
        'Added web request from customer.' => 'Se ha añadido una solicitud web del cliente.',
        'Adds a suffix with the actual year and month to the OTOBO log file. A logfile for every month will be created.' =>
            'Añade un sufijo con el año y mes actuales al archivo log de OTOBO. Se generará un archivo log distinto para cada mes.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Añade las direcciones de correo electrónico de los clientes a los destinatarios en la pantalla de composición de tickets de la interfaz del agente. La dirección de correo electrónico del cliente no se añadirá si el tipo de artículo es interno.',
        'Adds the one time vacation days for the indicated calendar.' => 'Añade los días de vacaciones únicos para el calendario indicado.',
        'Adds the one time vacation days.' => 'Añade los días de vacaciones únicos.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            'Añade los días de vacaciones permanentes para el calendario indicado.',
        'Adds the permanent vacation days.' => 'Añade los días de vacaciones permanentes.',
        'Admin' => 'Administración',
        'Admin Area.' => 'Área de administración.',
        'Admin Contact With Data' => 'Contacto administrativo con datos',
        'Admin Notification' => 'Notificación del Administrador',
        'Admin area navigation for the agent interface.' => 'Navegación del área de administración para la interfaz del agente.',
        'Admin contact with data.' => 'Contacto administrativo con datos.',
        'Admin modules overview.' => 'Visión general de los módulos de administración.',
        'Admin.' => 'Administración.',
        'Administration' => 'Administración',
        'Agent Contact With Data Search' => 'Contacto con agentes con búsqueda de datos',
        'Agent Customer Search' => 'Búsqueda de clientes en el agente',
        'Agent Customer Search.' => 'Búsqueda de clientes por parte de los agentes.',
        'Agent Dynamic Field Database Detailed Search' => 'Búsqueda detallada en la base de datos de campos dinámicos de los agentes',
        'Agent Dynamic Field Database Details' => 'Detalles de la base de datos del campo dinámico del agente',
        'Agent Dynamic Field Database Search' => 'Búsqueda en la base de datos del campo dinámico del agente',
        'Agent Name' => 'Nombre del agente',
        'Agent Name + FromSeparator + System Address Display Name' => 'Nombre del agente + Separador de origen + Dirección del sistema Nombre de la pantalla',
        'Agent Preferences.' => 'Preferencias de los agentes.',
        'Agent Statistics.' => 'Estadísticas de los agentes.',
        'Agent User Search' => 'Búsqueda de agentes',
        'Agent User Search.' => 'Búsqueda de agentes.',
        'Agent contact with data search.' => 'Contacto del agente con la búsqueda de datos.',
        'Agent dynamic field database detailed search.' => 'Búsqueda detallada en la base de datos de campos dinámicos del agente.',
        'Agent dynamic field database details.' => 'Detalles de la base de datos del campo dinámico del agente.',
        'Agent dynamic field database search.' => 'Búsqueda en la base de datos de campos dinámicos del agente.',
        'Agent frontend module registration (disable \'Edit contacts with data\' link if if there is no source field configured).' =>
            'Registro del módulo frontend del agente (desactive el enlace "Editar contactos con datos" si no hay ningún campo de origen configurado).',
        'Agent interface article notification module to check PGP.' => 'Módulo de notificación de artículos de la interfaz del agente para verificar PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Módulo de notificación de artículos de la interfaz del agente para verificar S/MIME.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de interfaz del agente para acceder a la búsqueda del CIC a través de la barra de navegación. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de interfaz de agente para acceder a la búsqueda de texto completo a través de la barra de navegación. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de interfaz de agente para acceder a los perfiles de búsqueda a través de la barra de navegación. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Módulo de la interfaz del agente para verificar los correos electrónicos entrantes, en la vista detallada del ticket, si la llave S/MIME está disponible y es verdadera.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificación de la interfaz del agente para ver el número de tickets bloqueados. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificación de la interfaz del agente para ver el número de tickets de los que es responsable un agente. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificación de la interfaz del agente para ver el número de tickets en Mis Servicios. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Módulo de notificación de la interfaz del agente para ver el número de tickets vigilados. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'AgentTicketZoom widget that displays Contact with data dynamic field in the side bar.' =>
            'Widget AgentTicketZoom que muestra el campo dinámico Contacto con datos en la barra lateral.',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'Widget AgentTicketZoom que muestra una tabla de objetos vinculados al ticket.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'Widget AgentTicketZoom que muestra la información del cliente del ticket en la barra lateral.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'Widget AgentTicketZoom que muestra los datos del ticket en la barra lateral.',
        'Agents ↔ Groups' => 'Agentes ↔ Grupos',
        'Agents ↔ Roles' => 'Agentes ↔ Roles',
        'All CustomerIDs of a customer user.' => 'Todos los CustomerIDs de un usuario cliente.',
        'All customer users of a CustomerID' => 'Todos los usuarios de cliente de un CustomerID',
        'All escalated tickets' => 'Todos los tickets escalados',
        'All new tickets, these tickets have not been worked on yet' => 'Todos los tickets nuevos en los que aún no se ha trabajado',
        'All open tickets, these tickets have already been worked on.' =>
            'Todos los tickets abiertos, estos tickets ya han sido trabajados.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Todos los tickets que han llegado a la fecha de recordatorio',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de cierre del ticket de la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de texto libre del ticket de la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de notas del ticket de la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla del propietario del ticket de un ticket ampliado en la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de tickets pendientes de un ticket ampliado en la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de prioridad del ticket de un ticket ampliado en la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Permite añadir notas en la pantalla de responsables del ticket de la interfaz del agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Permite a los agentes intercambiar los ejes de la estadística al generar una.',
        'Allows agents to generate individual-related stats.' => 'Permite a los agentes generar estadísticas relacionadas individualmente.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Permite elegir entre mostrar los archivos adjuntos de un ticket en el explorador (en línea), o simplemente permitir descargarlos.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Permite elegir el siguiente estado del ticket al redactar un artículo, en la interfaz del cliente.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Permite a los clientes cambiar la prioridad del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Permite a los clientes definir el SLA del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Permite a los clientes definir la prioridad del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            'Permite a los clientes establecer la cola de tickets en la interfaz de cliente. Si no está habilitado, debe configurarse QueueDefault.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Permite a los clientes definir el servicio del ticket en la interfaz del cliente.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            'Permite a los clientes establecer el tipo de billete en la interfaz de cliente. Si no está habilitado, debe configurarse TicketTypeDefault.',
        'Allows default services to be selected also for non existing customers.' =>
            'Permite seleccionar los servicios por defecto también para los clientes no existentes.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Permite definir servicios y SLAs para los tickets (por ejemplo: correo electrónico, escritorio, red, etc.), así mismo como atributos para los SLAs (si la funcionalidad servicio/SLA está habilitada).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Permite ampliar las condiciones de búsqueda en la búsqueda de tickets de la interfaz del agente. Con esta función puede buscar, por ejemplo, el título del ticket con este tipo de condiciones como "(*clave1*&&*clave2*)" o "(*clave1*||*clave2*)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Permite ampliar las condiciones de búsqueda en la búsqueda de tickets de la interfaz de cliente. Con esta función puede buscar, por ejemplo, el título del ticket con este tipo de condiciones como "(*clave1*&&*clave2*)" o "(*clave1*||*clave2*)".',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Permite ampliar las condiciones de búsqueda en la búsqueda de tickets de la interfaz genérica del agente. Con esta función puede buscar, por ejemplo, el título del ticket con este tipo de condiciones como "(*clave1*&&*clave2*)" o "(*clave1*||*clave2*)".',
        'Allows generic agent to execute custom command line scripts.' =>
            'Permite al agente genérico ejecutar scripts de línea de comandos personalizados.',
        'Allows generic agent to execute custom modules.' => 'Permite que el agente genérico ejecute módulos personalizados.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista mediana para los tickets (InformaciónCliente => 1 - muestra además la información del cliente).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Permite tener un formato de vista pequeña para los tickets (InformaciónCliente => 1 - muestra además la información del cliente).',
        'Allows invalid agents to generate individual-related stats.' => 'Permite a los agentes no válidos generar estadísticas individuales.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Permite a los administradores iniciar sesión como otros clientes a través del panel de administración de usuario de cliente.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Permite al administrador iniciar sesión como otros usuarios, a través del panel de administración de los mismos.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de cierre de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de salida de correo electrónico de la interfaz del agente.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de composición de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de envío de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de texto libre del ticket de la interfaz del agente.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de movimiento de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de notas del ticket de la interfaz del agente.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla del propietario del ticket de la interfaz del agente.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de tickets pendientes de la interfaz del agente.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de entrada del teléfono de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de salida del teléfono de tickets de la interfaz del agente.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla de prioridad del ticket de la interfaz del agente.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            'Permite guardar el trabajo actual como borrador en la pantalla del responsable del ticket de la interfaz del agente.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Permite definir el estado de un ticket nuevo, en la ventana de mover ticket de la interfaz del agente.',
        'Always show RichText if available' => 'Mostrar siempre RichText si está disponible',
        'Answer' => 'Responder',
        'Appointment Calendar overview page.' => 'Página de resumen del Calendario de Citas.',
        'Appointment Notifications' => 'Notificaciones de Citas',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'Módulo de eventos del calendario de citas que prepara entradas para citas.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'Módulo de eventos de calendario que actualiza los datos del ticket desde una cita de ticket.',
        'Appointment edit screen.' => 'Pantalla de edición de citas.',
        'Appointment list' => 'Lista de citas',
        'Appointment list.' => 'Lista de citas.',
        'Appointment notifications' => 'Notificaciones de citas',
        'Appointments' => 'Citas',
        'Arabic (Saudi Arabia)' => 'Árabe (Arabia Saudita)',
        'ArticleTree' => 'Árbol de artículos',
        'Attachment Name' => 'Nombre del Archivo Adjunto',
        'Autoloading of Znuny4OTOBOPasswordPolicy extensions.' => 'Carga automática de las extensiones Znuny4OTOBOPasswordPolicy.',
        'Automated line break in text messages after x number of chars.' =>
            'Salto de línea automático en los mensajes de texto después de x número de caracteres.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            'Cambia automáticamente el estado de un ticket con un propietario no válido una vez que se desbloquea. Asigna desde un tipo de estado a un nuevo estado del ticket.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Bloquear y fijar automáticamente el propietario al agente actual después de abrir la pantalla del ticket de traslado de la interfaz del agente.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Bloquear automáticamente y establecer como propietario al agente actual, luego de elegir realizar una Acción múltiple con Tickets.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Establece automáticamente el propietario de un ticket como responsable del mismo (si la función de responsable del ticket está activada). Esto sólo funcionará mediante acciones manuales del usuario conectado. No funciona para las acciones automatizadas, por ejemplo, GenericAgent, Postmaster y GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Establecer automáticamente el responsable de un ticket (si no está definido aún), luego de realizar la primera actualización de propietario.',
        'Avatar' => 'Avatar',
        'Balanced white skin by Felix Niklas (slim version).' => 'Interfaz blanco equilibrado de Felix Niklas (versión liviana).',
        'Balanced white skin by Felix Niklas.' => 'interfaz blanca balanceada diseñada por Felix Niklas.',
        'Based on global RichText setting' => 'Basado en la configuración global de RichText',
        'Basic fulltext index settings. Execute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            'Configuración básica del índice de texto completo. Ejecute "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild" para generar un nuevo índice.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Bloquea todos los correos electrónicos entrantes que no tienen un número de ticket válido en el asunto con dirección De: @ejemplo.com.',
        'Bounced to "%s".' => 'Reenviado a "%s".',
        'Bulgarian' => 'Búlgaro',
        'Bulk Action' => 'Acción Múltiple',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Ejemplo de configuración CMD. Ignora correos electrónicos donde el CMD externo regresa alguna salida en STDOUT (los correos electrónicos serán dirigidos a STDIN de some.bin).',
        'CSV Separator' => 'Separador CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Tiempo de caché en segundos para la autenticación del agente en la GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Tiempo de caché en segundos para la autenticación del cliente en la GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Tiempo de caché en segundos para el backend de la DB ACL.',
        'Cache time in seconds for the DB process backend.' => 'Tiempo de caché en segundos para el backend del proceso de la BD.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Tiempo de caché en segundos para los atributos del certificado SSL.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Tiempo de caché en segundos para el módulo de salida de la barra de navegación del proceso de tickets.',
        'Cache time in seconds for the web service config backend.' => 'Tiempo de caché en segundos para el backend de configuración del servicio web.',
        'Calendar manage screen.' => 'Pantalla de gestión de Calendarios.',
        'Cancel whole escalation if ticket is in configured suspend state (EscalationSuspendStates). Ticket will not escalate at all in configured suspend state. No escalation times are shown. Ticket will not be shown in escalation view.' =>
            'Cancelar todo el escalamiento si el ticket está en el estado de suspensión configurado (EscalationSuspendStates). El ticket no escalará en absoluto en el estado de suspensión configurado. No se muestran los tiempos de escalado. El ticket no se mostrará en la vista de escalado.',
        'Catalan' => 'Catalán',
        'Categories used in ticket presentation. If no default color is given, item will not be shown if selection is not defined in the color hash.' =>
            'Categorías utilizadas en la presentación del ticket. Si no se da ningún color por defecto, el artículo no se mostrará si la selección no está definida en el hash de color.',
        'Categories used in ticket presentation. Order is only used to determine the starting position before size arrangement. If no default color is given, item will not be shown if selection is not defined in the color hash.' =>
            'Categorías utilizadas en la presentación del ticket. El orden sólo se utiliza para determinar la posición inicial antes de la disposición del tamaño. Si no se da ningún color por defecto, el artículo no se mostrará si la selección no está definida en el hash de color.',
        'Change Ticket' => 'Cambiar ticket',
        'Change Ticket information' => 'Cambiar la información del ticket',
        'Change queue!' => '¡Cambiar fila!',
        'Change the customer for this ticket' => 'Cambiar el cliente para este ticket',
        'Change the owner for this ticket' => 'Cambiar el propietario de este ticket',
        'Change the priority for this ticket' => 'Cambiar la prioridad para este ticket',
        'Change the responsible for this ticket' => 'Cambiar al responsable para este ticket',
        'Change your avatar image.' => 'Cambia la imagen de tu avatar.',
        'Change your password and more.' => 'Cambia tu contraseña y mucho más.',
        'Changed SLA to "%s" (%s).' => 'Cambiado el SLA a "%s" (%s).',
        'Changed archive state to "%s".' => 'Cambiado el estado del archivo a "%s".',
        'Changed customer to "%s".' => 'Cambiado el cliente a "%s".',
        'Changed dynamic field %s from "%s" to "%s".' => 'Cambiado el campo dinámico %s de "%s" a "%s".',
        'Changed owner to "%s" (%s).' => 'Cambiado el propietario a "%s" (%s).',
        'Changed pending time to "%s".' => 'Se ha cambiado la hora pendiente a "%s".',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Cambiar prioridad de "%s" (%s) a "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => 'Se ha cambiado la cola a "%s" (%s) desde "%s" (%s).',
        'Changed responsible to "%s" (%s).' => 'Cambiado el responsable a "%s" (%s).',
        'Changed service to "%s" (%s).' => 'Se ha cambiado el servicio a "%s" (%s).',
        'Changed state from "%s" to "%s".' => 'Se ha cambiado el estado de "%s" a "%s".',
        'Changed title from "%s" to "%s".' => 'Cambiado el título de "%s" a "%s".',
        'Changed type from "%s" (%s) to "%s" (%s).' => 'Se ha cambiado el tipo de "%s" (%s) a "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Cambia el propietario de los tickets a todos (útil para ASP). Normalmente sólo se mostrarán los agentes con permiso rw en la fila del ticket.',
        'Chat communication channel.' => 'Canal de comunicación por chat.',
        'Checkbox' => 'Casilla de verificación',
        'Checks for articles that needs to be updated in the article search index.' =>
            'Comprueba los artículos que deben actualizarse en el índice de búsqueda de artículos.',
        'Checks for communication log entries to be deleted.' => 'Comprueba las entradas del registro de comunicaciones que deben eliminarse.',
        'Checks for queued outgoing emails to be sent.' => 'Comprueba si hay correos electrónicos salientes en cola para ser enviados.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Comprueba si un correo electrónico es un seguimiento de un ticket existente buscando en el asunto un número de ticket válido.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            'Comprueba si un correo electrónico es un seguimiento de un ticket existente con número de ticket externo que puede ser encontrado por el módulo de filtro ExternalTicketNumberRecognition.',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            'Comprueba el SystemID en la detección del número de ticket para el seguimiento. Si no está habilitado, el SystemID se cambiará después de usar el sistema.',
        'Child' => 'Hijo',
        'Chinese (Simplified)' => 'Chino (Simplificado)',
        'Chinese (Traditional)' => 'Chino (Tradicional)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Elija el tipo de cambios en las citas par las cuales desea recibir notificaciones.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Elija para qué tipo de cambios en los tickets quiere recibir notificaciones. Ten en cuenta que no puedes desactivar completamente las notificaciones marcadas como obligatorias.',
        'Choose which notifications you\'d like to receive.' => 'Elige qué notificaciones quieres recibir.',
        'Christmas Eve' => 'Noche buena',
        'Close' => 'Cerrar',
        'Close this ticket' => 'Cerrar este ticket',
        'Closed tickets (customer user)' => 'Tickets cerrados (usuario del cliente)',
        'Closed tickets (customer)' => 'Tickets Cerrados (cliente)',
        'Cloud Services' => 'Servicios en la Nube',
        'Cloud service admin module registration for the transport layer.' =>
            'Registro del módulo de administración de servicios en la nube para la capa de transporte.',
        'Collect support data for asynchronous plug-in modules.' => 'Recoge los datos de soporte de los módulos adicionales asíncronos.',
        'Color definitions for the customer interface.' => 'Definiciones de colores para la interfaz del cliente.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filtros de tickets de columna para resúmenes de tickets de tipo "Pequeño".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de escalada de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista bloqueada de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de cola de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista responsable de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de servicio de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de estado de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de resultados de búsqueda de tickets de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Columnas que pueden filtrarse en la vista de vigilancia de la interfaz del agente. Nota: Sólo se permiten los atributos del ticket, los campos dinámicos (DynamicField_NameX) y los atributos del cliente (por ejemplo, CustomerUserPhone, CustomerCompanyName, ...).',
        'Comment for new history entries in the customer interface.' => 'Comentario para entradas nuevas en la historia, en la interfaz del cliente.',
        'Comment2' => 'Comentario2',
        'Communication' => 'Comunicación',
        'Communication & Notifications' => 'Comunicación y notificaciones',
        'Communication Log GUI' => 'GUI del registro de comunicaciones',
        'Communication log limit per page for Communication Log Overview.' =>
            'Límite de registro de comunicaciones por página para el resumen del registro de comunicaciones.',
        'CommunicationLog Overview Limit' => 'Límite de la visión general de CommunicationLog',
        'Company Status' => 'Estado de la Empresa',
        'Company Tickets.' => 'Tickets de la Empresa.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Nombre de la empresa que se incluirá en los correos electrónicos salientes como un X-Header.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Módulo de compat para AgentZoom a AgentTicketZoom.',
        'Complex' => 'Complejo',
        'Compose' => 'Redactar',
        'Configure Processes.' => 'Configurar Procesos.',
        'Configure and manage ACLs.' => 'Configurar y manejar ACLs.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Configure las bases de datos espejo adicionales de sólo lectura que desee utilizar.',
        'Configure sending of support data to OTOBO Team for improved support.' =>
            'Configurar el envío de datos de soporte a OTOBO Team para mejorar el soporte.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Configure qué pantalla debe mostrarse tras la creación de un nuevo ticket.',
        'Configure your own log text for PGP.' => 'Configure su propio texto largo para PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otobo.org/), chapter "Ticket Event Module".' =>
            'Configura un ajuste TicketDynamicField por defecto. "Nombre" define el campo dinámico que debe utilizarse, "Valor" es el dato que se establecerá, y "Evento" define el evento desencadenante. Consulte el manual del desarrollador (https://doc.otobo.org/), capítulo "Módulo de eventos de tickets".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Controla cómo mostrar las entradas del historial de tickets como valores de lectura.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'Controla si el CustomerID se copia automáticamente de la dirección del remitente para los clientes desconocidos.',
        'Controls if CustomerID is read-only in the agent interface.' => 'Controla si CustomerID es de sólo lectura en la interfaz del agente.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Define es posible que los clientes ordenen sus tickets.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Controla si se puede establecer más de una entrada en el nuevo ticket telefónico en la interfaz del agente.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Controla si el administrador puede importar una configuración del sistema guardada en SysConfig.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Controla si el administrador puede realizar cambios en la base de datos a través del AdminSelectBox.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            'Controla si el campo de autocompletar se utilizará para la selección del ID del cliente en la interfaz AdminCustomerUser.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Controla si los indicadores de ticket y artículo visto se eliminan cuando se archiva un ticket.',
        'Converts HTML mails into text messages.' => 'Convierte correos HTML en mensajes de texto.',
        'Create New process ticket.' => 'Crear un nuevo proceso de ticket.',
        'Create Templates for AdminDynamicFieldTitle.' => 'Crear plantillas para AdminDynamicFieldTitle.',
        'Create Ticket' => 'Crear un ticket',
        'Create a new calendar appointment linked to this ticket' => 'Crear una nueva cita de calendario vinculada a este ticket',
        'Create and manage Service Level Agreements (SLAs).' => 'Crear y gestionar Acuerdos de Nivel de Servicio (SLAs).',
        'Create and manage agents.' => 'Crear y gestionar agentes.',
        'Create and manage appointment notifications.' => 'Crear y gestionar notificaciones de citas.',
        'Create and manage attachments.' => 'Crear y gestionar archivos adjuntos.',
        'Create and manage calendars.' => 'Crear y gestionar calendarios.',
        'Create and manage customer users.' => 'Crear y gestionar usuarios de cliente.',
        'Create and manage customers.' => 'Crear y gestionar clientes.',
        'Create and manage dynamic fields.' => 'Crear y gestionar campos dinámicos.',
        'Create and manage groups.' => 'Crear y gestionar grupos.',
        'Create and manage queues.' => 'Crear y gestionar colas.',
        'Create and manage responses that are automatically sent.' => 'Crear y gestionar respuestas enviadas de forma automática.',
        'Create and manage roles.' => 'Crear y gestionar roles.',
        'Create and manage salutations.' => 'Crear y gestionar saludos.',
        'Create and manage services.' => 'Crear y gestionar servicios.',
        'Create and manage signatures.' => 'Crear y gestionar firmas.',
        'Create and manage templates.' => 'Crear y gestionar plantillas.',
        'Create and manage ticket notifications.' => 'Crear y gestionar notificaciones de tickets.',
        'Create and manage ticket priorities.' => 'Crear y gestionar las prioridades del ticket.',
        'Create and manage ticket states.' => 'Crear y gestionar los estados del ticket.',
        'Create and manage ticket types.' => 'Crear y gestionar los tipos de ticket.',
        'Create and manage web services.' => 'Crear y gestionar web services.',
        'Create new Ticket.' => 'Crear un nuevo ticket.',
        'Create new appointment.' => 'Crear nueva cita.',
        'Create new email ticket and send this out (outbound).' => 'Cree un nuevo ticket de correo electrónico y envíelo (de salida).',
        'Create new email ticket.' => 'Crear un nuevo ticket de correo electrónico.',
        'Create new phone ticket (inbound).' => 'Crear un nuevo ticket telefónico (de entrada).',
        'Create new phone ticket.' => 'Crear un nuevo ticket telefónico.',
        'Create new process ticket.' => 'Crear un nuevo ticket de proceso.',
        'Create tickets.' => 'Crear tickets.',
        'Create your first ticket' => 'Crear su primer ticket',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            'Creado ticket [%s] en "%s" con prioridad "%s" y estado "%s".',
        'Croatian' => 'Croata',
        'Custom RSS Feed' => 'Feed RSS personalizado',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Texto personalizado para la página que se muestra a los clientes que aún no tienen boletos (si necesita esos textos traducidos agréguelos a un módulo de traducción personalizado).',
        'Customer Administration' => 'Administración de Clientes',
        'Customer Companies' => 'Compañías de los Clientes',
        'Customer Dashboard' => 'Panel de control de clientes',
        'Customer Dynamic Field Database Detailed Search' => 'Base de datos de campos dinámicos de clientes Búsqueda detallada',
        'Customer Dynamic Field Database Details' => 'Detalles de la base de datos del campo dinámico del cliente',
        'Customer Dynamic Field Database Search' => 'Búsqueda en la base de datos de campos dinámicos de clientes',
        'Customer IDs' => 'Identificación de clientes',
        'Customer Information Center Search.' => 'Búsqueda en el Centro de Información del Cliente.',
        'Customer Information Center search.' => 'Búsqueda en el Centro de Información del Cliente.',
        'Customer Information Center.' => 'Centro de Información del Cliente.',
        'Customer Password.' => 'Contraseña del cliente.',
        'Customer Ticket Print Module.' => 'Módulo de impresión de tickets del cliente.',
        'Customer User Administration' => 'Administración de Usuario del Cliente',
        'Customer User Information' => 'Centro de Información de Usuario del Cliente',
        'Customer User Information Center Search.' => 'Búsqueda del Centro de Información del Usuario del Cliente.',
        'Customer User Information Center search.' => 'Búsqueda del centro de información del Usuario del Cliente.',
        'Customer User Information Center.' => 'Centro de Información de Usuario del cliente.',
        'Customer Users ↔ Customers' => 'Usuarios del Cliente ↔ Clientes',
        'Customer Users ↔ Groups' => 'Usuarios del Cliente ↔ Grupos',
        'Customer Users ↔ Services' => 'Usuarios del Cliente ↔ Servicios',
        'Customer dynamic field database detailed search.' => 'Búsqueda detallada en la base de datos de campos dinámicos del cliente.',
        'Customer dynamic field database details.' => 'Detalles de la base de datos del campo dinámico del cliente.',
        'Customer dynamic field database search.' => 'Búsqueda en la base de datos de campos dinámicos del cliente.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento del cliente (icono) que muestra los tickets cerrados de este cliente como bloque de información. Si se establece CustomerUserLogin en 1, se buscan los tickets en función del nombre de usuario en lugar del CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Elemento del cliente (icono) que muestra los tickets abiertos de este cliente como bloque de información. Si se establece CustomerUserLogin en 1, se buscan los tickets en función del nombre de usuario en lugar del CustomerID.',
        'Customer preferences.' => 'Preferencias de los clientes.',
        'Customer ticket overview' => 'Resumen de los tickets de clientes',
        'Customer ticket search.' => 'Búsqueda de tickets de clientes.',
        'Customer ticket zoom' => 'Zoom del ticket del cliente',
        'Customer user search' => 'Búsqueda de usuario del cliente',
        'CustomerID search' => 'Búsqueda de CustomerID',
        'CustomerName' => 'Nombre del cliente',
        'CustomerUser' => 'Usuario Cliente',
        'Customers ↔ Groups' => 'Clientes ↔ Grupos',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada personalizables para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Czech' => 'Checo',
        'Danish' => 'Danés',
        'Dashboard overview.' => 'Vista general del tablero.',
        'Data used to export the search result in CSV format.' => 'Datos usados para exportar el resultado de la búsqueda a formato CSV.',
        'Date / Time' => 'Fecha / Hora',
        'Default (Slim)' => 'Por defecto (Liviano)',
        'Default ACL values for ticket actions.' => 'Valores ACL por defecto para las acciones de ticket.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Prefijos de entidad por defecto de ProcessManagement para los ID de entidad que se generan automáticamente.',
        'Default agent name' => 'Nombre del agente por defecto',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Datos por defecto a utilizar en la pantalla de búsqueda de atributos para el ticket. Ejemplo: "TicketCreateTimePointFormat=año;TicketCreateTimePointStart=último;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Datos por defecto a utilizar en la pantalla de búsqueda de atributos para el ticket. Ejemplo: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Tipo de visualización por defecto para los nombres de los destinatarios (To,Cc) en AgentTicketZoom y CustomerTicketZoom.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Tipo de visualización por defecto para los nombres del remitente (From) en AgentTicketZoom y CustomerTicketZoom.',
        'Default loop protection module.' => 'Módulo de protección de bucle por defecto.',
        'Default queue ID used by the system in the agent interface.' => 'ID de fila usado por defecto por el sistema, en la interfaz del agente.',
        'Default skin for the agent interface (slim version).' => 'Diseño por defecto de la interfaz del agente (versión liviana).',
        'Default skin for the agent interface.' => 'Diseño por defecto de la interfaz del agente.',
        'Default skin for the customer interface.' => 'Diseño por defecto de la interfaz del cliente.',
        'Default ticket ID used by the system in the agent interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del agente.',
        'Default ticket ID used by the system in the customer interface.' =>
            'ID de ticket usado por defecto por el sistema, en la interfaz del cliente.',
        'Default value for NameX' => 'Valor por defecto para NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Definir Acciones en las que un botón de configuración está disponible en el widget de objetos vinculados (LinkObject::ViewMode = "complex"). Tenga en cuenta que estas Acciones deben haber registrado los siguientes archivos JS y CSS: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para la salida html para añadir vínculos a ciertas cadenas. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTOBO. La otra posibilidad es insertar el vínculo a la imagen.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            'Definir un mapeo entre las variables de los datos de usuario del cliente (claves) y los campos dinámicos de un ticket (valores). El propósito es almacenar los datos del usuario del cliente en los campos dinámicos del ticket. Los campos dinámicos deben estar presentes en el sistema y deben estar habilitados para AgentTicketFreeText, para que puedan ser configurados/actualizados manualmente por el agente. No deben estar habilitados para AgentTicketPhone, AgentTicketEmail y AgentTicketCustomer. Si lo estuvieran, tendrían prioridad sobre los valores establecidos automáticamente. Para utilizar este mapeo, debe activar también el ajuste Ticket::EventModulePost##4100-DynamicFieldFromCustomerUser.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definir el nombre del campo dinámico para la hora de finalización. Este campo debe añadirse manualmente al sistema como Ticket: "Fecha / Hora" y debe activarse en las pantallas de creación de tickets y/o en cualquier otra pantalla de acción del ticket.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definir el nombre del campo dinámico para la hora de inicio. Este campo debe añadirse manualmente al sistema como Ticket: "Fecha / Hora" y debe activarse en las pantallas de creación de tickets y/o en cualquier otra pantalla de acción del ticket.',
        'Define the max depth of queues.' => 'Define la profundidad máxima de las colas.',
        'Define the queue comment 2.' => 'Definir el comentario de la cola 2.',
        'Define the service comment 2.' => 'Definir el comentario del servicio 2.',
        'Define the sla comment 2.' => 'Definir el comentario de la sla 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Define el día de inicio de la semana para el selector de fechas del calendario indicado.',
        'Define the start day of the week for the date picker.' => 'Define el día inicial de la para el selector de fecha.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Define qué imagen de avatar por defecto se debe utilizar para la vista del artículo si no se asigna ningún gravatar a la dirección de correo. Consulte https://gravatar.com/site/implement/images/ para obtener más información.',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Define qué imagen de avatar por defecto debe utilizarse para el agente actual si no se asigna ningún gravatar a la dirección de correo del agente. Consulte https://gravatar.com/site/implement/images/ para obtener más información.',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            'Define qué motor de avatar se debe utilizar para el avatar del agente en la cabecera y las imágenes del remitente en AgentTicketZoom. Si se selecciona \'Ninguno\', se mostrarán las iniciales en su lugar. Tenga en cuenta que si se selecciona cualquier otra cosa que no sea \'Ninguno\', se transferirá la dirección de correo electrónico encriptada del usuario en cuestión a un servicio externo.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Define cuales columnas serán mostradas en widget de citas vinculadas (LinkObject::ViewMode = "compleja"). Posibles ajustes: 0 = Deshabitada, 1 = Habilitada, 2 = Habilitada por omisión.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Define qué columnas se muestran en el widget de tickets vinculados (LinkObject::ViewMode = "complex"). Nota: Solo se permiten atributos de tickets y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de VinculadoEn, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de XING, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de google, al final de un bloque de información de cliente.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Define un artículo de cliente que genera un ícono de mapas google, al final de un bloque de información de cliente.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números CVE. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTOBO. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números MSBulletin. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTOBO. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a una cadena definida. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTOBO. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTOBO image path will be used. The second possiblity is to insert the link to the image.' =>
            'Define un filtro para salida html para añadir vínculos a los números bugtraq. El elemento Imagen permite dos tipos de entrada: un nombre de imagen (por ejemplo: faq.png). En este caso, se usa la ruta de imágenes de OTOBO. La otra posibilidad es insertar el vínculo a la imagen.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Define un filtro para recoger los números CVE de los textos de los artículos en AgentTicketZoom. Los resultados se mostrarán en una caja meta al lado del artículo. Rellene URLPreview si desea ver una vista previa al mover el cursor del ratón sobre el elemento de enlace. Puede ser la misma URL que en URL, pero también una alternativa. Tenga en cuenta que algunos sitios web rechazan ser mostrados dentro de un iframe (por ejemplo, Google) y por lo tanto no funcionarán con el modo de vista previa.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Define un filtro para procesar el texto de los artículos, con la finalidad de resaltar las palabras llave predefinidas.',
        'Defines a permission context for customer to group assignment.' =>
            'Define un contexto de permiso para la asignación de clientes a grupos.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Define una expresión regular que excluye algunas direcciones de la verificación de sintaxis (si se seleccionó "Sí" en "CheckEmailAddresses"). Por favor, introduzca una expresión regular en este campo para direcciones de correo electrónico que, sintácticamente son inválidas, pero son necesarias para el sistema (por ejemplo: "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Define una expresión regular que filtra todas las direcciones de correo electrónico que no deberían usarse en la aplicación.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Define un tiempo de espera en microsegundos entre los tickets mientras son procesados por un trabajo.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Define un módulo para cargar opciones de usuario específicas o para mostrar noticias.',
        'Defines all the X-headers that should be scanned.' => 'Define todos los encabezados-X que deberán escanearse.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Define todos los idiomas que están disponibles para la aplicación. Especifique aquí sólo los nombres en inglés de los idiomas.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Define todos los idiomas que están disponibles para la aplicación. Especifique aquí sólo los nombres nativos de los idiomas.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Define todos los parámetros para el objeto TiempoDeActualización, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Define todos los parámetros para el objeto TicketsMostrados, en las preferencias del cliente de la interfaz del mismo.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Define todos los parámetros para este elemento, en las preferencias del cliente.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Define todos los parámetros para este elemento en las preferencias del cliente. PasswordRegExp\' permite comparar las contraseñas con una expresión regular. Defina el número mínimo de caracteres utilizando \'PasswordMinSize\'. Defina si se necesitan al menos 2 caracteres de letras minúsculas y 2 de letras mayúsculas estableciendo la opción correspondiente en \'1\'. \'PasswordMin2Characters\' define si es necesario que la contraseña contenga al menos 2 caracteres de letra (configurado a 0 o 1). \'PasswordNeedDigit\' controla la necesidad de al menos 1 dígito (establecido a 0 o 1 para controlar).',
        'Defines all the parameters for this notification transport.' => 'Define todos los parámetros de este transporte de notificaciones.',
        'Defines all the possible stats output formats.' => 'Define todos los formatos de salida posibles de las estadísticas.',
        'Defines an alternate URL, where the login link refers to.' => 'Define una URL sustituta, a la que el vínculo de inicio de sesión se refiera.',
        'Defines an alternate URL, where the logout link refers to.' => 'Define una URL sustituta, a la que el vínculo de término de sesión se refiera.',
        'Defines an alternate login URL for the customer panel..' => 'Define una URL sustituta para el inicio de sesión, en la interfaz del cliente.',
        'Defines an alternate logout URL for the customer panel.' => 'Define una URL sustituta para el término de sesión, en la interfaz del cliente.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Define un enlace externo a la base de datos del cliente (por ejemplo, \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' o \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'Define un icono de vínculo a la pagina de google map de la ubicación actual en la pantalla de edición de citas.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'Define un módulo de resumen para mostrar la vista de la libreta de direcciones de una lista de usuarios de clientes.',
        'Defines available article actions for Chat articles.' => 'Define las acciones disponibles para los artículos del chat.',
        'Defines available article actions for Email articles.' => 'Define las acciones disponibles para los artículos de correo electrónico.',
        'Defines available article actions for Internal articles.' => 'Define las acciones disponibles para los artículos internos.',
        'Defines available article actions for Phone articles.' => 'Define las acciones disponibles para los artículos de llamadas.',
        'Defines available article actions for invalid articles.' => 'Define las acciones disponibles para los artículos no válidos.',
        'Defines available groups for the admin overview screen.' => 'Define los grupos disponibles para la pantalla de resumen del administrador.',
        'Defines chat communication channel.' => 'Define el canal de comunicación del chat.',
        'Defines default headers for outgoing emails.' => 'Define las cabeceras por defecto para los correos electrónicos salientes.',
        'Defines email communication channel.' => 'Define el canal de comunicación por correo electrónico.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Define qué atributos del ticket el agente puede seleccionar el orden de los resultados.',
        'Defines groups for preferences items.' => 'Define los grupos para los elementos de las preferencias.',
        'Defines how many deployments the system should keep.' => 'Define cuántos despliegues debe mantener el sistema.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Define cómo debe lucir el campo De en los correos electrónicos (enviados como respuestas y tickets).',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Define si se debe realizar una preclasificación por prioridad en la vista de colas.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Define si se debe realizar una preordenación por prioridad en la vista del servicio.',
        'Defines if a ticket lock is required for the quick close.' => 'Define si se requiere un bloqueo de ticket para el cierre rápido.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cerrar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo del ticket en la pantalla de salida de correo electrónico de la interfaz del agente (si el ticket no está bloqueado todavía, el ticket se bloquea y el agente actual se establecerá automáticamente como su propietario).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo del ticket en la pantalla de reenvío de correo electrónico de la interfaz del agente (si el ticket no está bloqueado todavía, el ticket se bloquea y el agente actual se establecerá automáticamente como su propietario).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para rebotar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para redactar, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para reenviar dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana de campos libres de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para mezclar dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para agregar una nota a dicho ticket de la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el propietario de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para definir como pendiente dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo del ticket en la pantalla de entrada del teléfono del ticket de la interfaz del agente (si el ticket no está bloqueado todavía, el ticket se bloquea y el agente actual se establecerá automáticamente como su propietario).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para añadir una llamada saliente a dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar la prioridad de dicho ticket, en su vista detallada, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el agente responsable de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Define si se requiere un bloqueo de ticket en la ventana para cambiar el cliente de dicho ticket, en la interfaz del agente (si el ticket aún no está bloqueado, se bloquea y el agente actual se convierte automáticamente en el propietario).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Define si se debe permitir a los agentes iniciar sesión si no tienen ningún clave secreta compartida almacenada en sus preferencias y, por lo tanto, no están utilizando la autenticación de dos factores.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Define si se debe permitir a los clientes iniciar sesión si no tienen ninguna clave secreta compartida almacenado en sus preferencias y, por lo tanto, no están utilizando la autenticación de dos factores.',
        'Defines if the communication between this system and the servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as support data sending, Package Verify™ and product News dashboard widgets, among others.' =>
            'Define si es posible la comunicación entre este sistema y los servidores que proporcionan servicios en la nube. Si se establece en "Desactivar los servicios en la nube", se perderán algunas funcionalidades como el envío de datos de soporte, los widgets de Package Verify™ y el panel de noticias del producto, entre otros.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'Define si se debe utilizar el modo mejorado (permite el uso de tabla, reemplazo, subíndice, superíndice, pegar desde word, etc.) en la interfaz del cliente.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Define si se debe utilizar el modo mejorado (permite el uso de tabla, reemplazo, subíndice, superíndice, pegar desde word, etc.).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            'Define si el primer artículo debe mostrarse como expandido, es decir, visible para el cliente relacionado. Si no se define nada, el último artículo será expandido.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            'Define si el mensaje en la pantalla de salida de correo electrónico de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            'Define si el mensaje en la pantalla de reenvío de correo electrónico de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            'Define si el mensaje en la pantalla de composición del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            'Define si el mensaje en la pantalla de reenvío de tickets de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla de cierre del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla de texto libre del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla de notas del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla del propietario del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla de tickets pendientes de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla de prioridad del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            'Define si la nota en la pantalla del responsable del ticket de la interfaz del agente es visible para el cliente por defecto.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Define si el token previamente válido debe ser aceptado para la autenticación. Esto es ligeramente menos seguro, pero da a los usuarios 30 segundos más de tiempo para introducir su contraseña de un solo uso.',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'Define si los valores para los filtros deben ser recuperados de todos los tickets disponibles. Si se activa, sólo los valores que se utilizan realmente en cualquier ticket estarán disponibles para el filtrado. Nota: La lista de clientes siempre se recuperará así.',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Define si la contabilidad del tiempo es obligatoria en la interfaz del agente. Si está activada, debe introducirse una nota para todas las acciones de ticket (sin importar si la nota en sí está configurada como activa o si es originalmente obligatoria para la pantalla de acción de ticket individual).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Define si la contabilidad de tiempos debe establecerse para todos los tickets en una acción masiva.',
        'Defines internal communication channel.' => 'Define el canal de comunicación interno.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Define la plantilla del mensaje fuera de la oficina. Dos parámetros de cadena (%s) disponibles: fecha de finalización y número de días restantes.',
        'Defines phone communication channel.' => 'Define el canal de comunicación telefónica.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Define las colas que se utilizan para mostrar los tickets como eventos del calendario.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Define el nombre de host HTTP para la recogida de datos de soporte con el módulo público \'PublicSupportDataCollector\' (por ejemplo, utilizado desde el demonio OTOBO).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Define la expresión regular IP para acceder al repositorio local. Es necesario que esto se habilite para tener acceso al repositorio local y el paquete::ListaRepositorio se requiere en el host remoto.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'Define la cabecera PostMaster que se utilizará en el filtro para mantener el estado actual del ticket.',
        'Defines the URL CSS path.' => 'Define la URL de la ruta CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Define la URL de la ruta base para los íconos, CSS y Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Define la URL de la ruta de los íconos para la navegación.',
        'Defines the URL java script path.' => 'Define la URL de la ruta Java Script.',
        'Defines the URL rich text editor path.' => 'Define la URL de la ruta del editor de texto enriquecido.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Define la dirección de un servidor DNS dedicado, si se necesita, para las búsquedas de verificación de registro MX.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Define la clave de preferencias del agente donde se almacena la clave secreta compartida.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            'Define los pasos disponibles en las selecciones de tiempo. Seleccione "Minuto" para poder seleccionar todos los minutos de una hora del 1 al 59. Seleccione "30 minutos" para que sólo estén disponibles las horas completas y las medias horas.',
        'Defines the body for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Define el cuerpo de la acción del cierre rápido, que se utiliza para el historial de tickets en la interfaz del agente.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            'Define el texto del cuerpo de los correos de notificación enviados a los agentes, sobre la nueva contraseña.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            'Define el texto del cuerpo de los correos de notificación enviados a los agentes, con el token sobre la nueva contraseña solicitada.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Define el texto para el cuerpo de las notificaciones electrónicas que se envían a los clientes, acerca de una cuenta nueva.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            'Define el texto del cuerpo de los correos de notificación enviados a los clientes, sobre la nueva contraseña.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            'Define el texto del cuerpo de los correos de notificación enviados a los clientes, con el token sobre la nueva contraseña solicitada.',
        'Defines the body text for rejected emails.' => 'Define el texto para el cuerpo de los correos electrónicos rechazados.',
        'Defines the calendar width in percent. Default is 95%.' => 'Define el ancho del calendario en porcentaje. Por defecto es el 95%.',
        'Defines the close state for quick close.' => 'Define el estado de cierre para el cierre rápido.',
        'Defines the column to store the keys for the preferences table.' =>
            'Define la columna para guardar las llaves en la tabla de preferencias.',
        'Defines the communication chanel for the quick close article action.' =>
            'Define el canal de comunicación para la acción de cierre rápido del artículo.',
        'Defines the config options for the autocompletion feature.' => 'Define las opciones de configuración de la función de autocompletado.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Define los parámetros de configuración de este elemento, para que se muestren en la vista de preferencias.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Define los parámetros de configuración de este elemento, que se mostrarán en la vista de preferencias. PasswordRegExp\' permite comparar las contraseñas con una expresión regular. Defina el número mínimo de caracteres usando \'PasswordMinSize\'. Defina si se necesitan al menos 2 caracteres de letras minúsculas y 2 de letras mayúsculas estableciendo la opción correspondiente a \'1\'. \'PasswordMin2Characters\' define si es necesario que la contraseña contenga al menos 2 caracteres de letra (configurado a 0 o 1). \'PasswordNeedDigit\' controla la necesidad de al menos 1 dígito (establecido a 0 o 1 para controlar). PasswordMaxLoginFailed\' permite establecer un agente como inválido-temporalmente si se alcanza el máximo de inicios de sesión fallidos. Por favor, tenga en cuenta: establecer \'Activo\' a 0 sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Define los parámetros de configuración de este elemento, que se mostrarán en la vista de preferencias. Por favor, tenga en cuenta: establecer \'Activo\' a 0 sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Defines the connections for http/ftp, via a proxy.' => 'Define la conexión para http/ftp, a través de un proxy.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Define la clave de preferencias del cliente donde se almacena la clave secreta compartida.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Define el formato de entrada de las fechas, usado en los formularios (opción o campos de entrada).',
        'Defines the default CSS used in rich text editors.' => 'Define valor por defecto para el CSS de los editores de texto enriquecidos.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            'Define el nombre del agente por defecto en la vista de zoom del ticket de la interfaz del cliente.',
        'Defines the default auto response type of the article for this operation.' =>
            'Define el tipo de respuesta automática por defecto del artículo para esta operación.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            'Define los campos de filtro por defecto en la búsqueda de la libreta de direcciones del usuario cliente (CustomerUser o CustomerCompany). Para los campos ClienteEmpresa hay que añadir un prefijo \'ClienteEmpresa_\'.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otobo.org/.' =>
            'Define el tema por defecto del front-end (HTML) que utilizarán los agentes y los clientes. Si lo desea, puede añadir su propio tema. Consulte el manual del administrador que se encuentra en https://doc.otobo.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Define el lenguaje por defecto del front-end. Todos los valores posibles se determinan por los archivos de idiomas disponible en el sistema (vea la siguiente configuración).',
        'Defines the default history type in the customer interface.' => 'Define el tipo de historia por defecto en la interfaz del cliente.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Define el número máximo por defecto de atributos para el eje X, en la escala de tiempo.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Define el número máximo por defecto de estadísticas por página en la pantalla de resumen.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Define el siguiente estado por defecto de un ticket tras el seguimiento del cliente en la interfaz de cliente.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cerrar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana de nota para dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar el propietario de dicho ticket, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para definir dicho ticket como pendiente, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar la prioridad de dicho ticket, en su vista detallada, en la interfaz del agente.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de agregar una nota en la ventana para cambiar el responsable de dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber sido rebotado, en la ventana para rebotar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber sido reenviado, en la ventana para reenviar dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Define el siguiente estado predeterminado de un ticket después de que se haya enviado el mensaje, en la pantalla de salida de correo electrónico de la interfaz del agente.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haberlo redactado / respondido, en la ventana de redacción de dicho ticket, en la interfaz del agente.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Define el siguiente estado por defecto de un ticket, en la pantalla de conjunto de tickets de la interfaz del agente.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define el texto del cuerpo de la nota por defecto para los tickets telefónicos en la pantalla de entrada de tickets de telefónicos en la interfaz del agente.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de una nota, para tickets telefónicos en la ventana de llamada telefónica saliente de dicho ticket, en la interfaz del agente.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Define la prioridad por defecto de los tickets de seguimiento del cliente en la pantalla de zoom del ticket en la interfaz del cliente.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Define la prioridad por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default priority of new tickets.' => 'Define la prioridad por defecto para los tickets nuevos.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Define la fila por defecto para los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default queue for new tickets in the agent interface.' =>
            'Define la cola por defecto para los nuevos tickets en la interfaz del agente.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para objetos dinámicos (Formulario: Especificación Común).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Define el valor seleccionado por defecto en la lista desplegable para permisos (Formulario: Especificación Común).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Define el valor seleccionado por defecto en la lista desplegable de formatos para las estadisticas (Formulario: Especificación Común).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define el tipo de remitente por defecto para los tickets telefónicos en la pantalla de entrada de tickets telefónicos de la interfaz del agente.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el tipo de remitente por defecto para los tickets telefónicos, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Define el tipo de remitente por defecto para tickets, en la ventana de vista detallada del ticket de la interfaz del agente.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Define el atributo de búsqueda de tickets mostrado por defecto para la pantalla de búsqueda de tickets (AllTickets/ArchivedTickets/NotArchivedTickets).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Define el atributo mostrado por defecto para la búsqueda de tickets, en la ventana de búsqueda.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Define el atributo de búsqueda de tickets mostrado por defecto para la pantalla de búsqueda de tickets. Ejemplo: "Clave" debe tener el nombre del Campo Dinámico en este caso \'X\', "Contenido" debe tener el valor del Campo Dinámico dependiendo del tipo de Campo Dinámico, Texto: \'un texto\', Desplegable: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotSecond=59;\' y o \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Define los criterios de ordenación por defecto para todas las colas mostradas en la vista de colas.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Define el criterio de ordenación por defecto para todos los servicios mostrados en la vista de servicios.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Define el orden por defecto para todas las colas mostradas en la vista de filas, luego de haberse ordenado por prioridad.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Define el orden por defecto de todos los servicios en la vista de servicios, después de la ordenación por prioridad.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Define el estado por defecto de los tickets nuevos de clientes, en la interfaz del cliente.',
        'Defines the default state of new tickets.' => 'Define el estado por defecto para los tickets nuevos.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Define el asunto por defecto para los tickets telefónicos en la pantalla de entrada de tickets telefónicos de la interfaz del agente.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Define el asunto por defecto de los tickets telefónicos, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Define el asunto por defecto de las notas, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Define por defecto el número de segundos (desde la hora actual) para reprogramar una tarea fallida de la interfaz genérica.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la búsqueda, en la interfaz del cliente.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de escaladas, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de tickets bloqueados, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de responsables, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de estados, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets en la vista de monitoreo, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Define el atributo de ticket por defecto para ordenar los tickets del resultado de una búsqueda, en la interfaz del agente.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Define el atributo de ticket por defecto para la clasificación de tickets del resultado de la búsqueda de tickets de esta operación.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Define la notificación por defecto para tickets rebotados, que se enviará al cliente/remitente, en la ventana de rebotar un ticket, en la interfaz del agente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Define el estado predeterminado del siguiente ticket después de añadir una nota telefónica en la pantalla de entrada del teléfono del ticket de la interfaz del agente.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Define el valor por defecto del siguiente estado de un ticket, luego de haber añadido una nota telefónica, en la ventana de ticket telefónico saliente de la interfaz del agente.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de escaladas de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets (luego de haberse ordenado por prioridad), en la vista de estados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de responsables de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets bloqueados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una búsqueda de tickets en la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de las entradas en el resultado de la búsqueda de entradas de esta operación. Arriba: el más antiguo en la parte superior. Abajo: el más reciente en la parte superior.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, en la vista de tickets monitoreados de la interfaz del agente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Define el orden por defecto de los tickets, resultado de una búsqueda de tickets en la interfaz del cliente. Arriba: más antiguo al principio. Abajo: más reciente al principio.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cerrar un ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para agregar una nota al ticket, en la interfaz del agente.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para modificar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Define la prioridad por defecto de los tickets, en la ventana para cambiar el agente responsable de un ticket, en la vista detallada de dicho ticket, en la interfaz del agente.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Define el tipo de ticket por defecto para los nuevos tickets de cliente en la interfaz de cliente.',
        'Defines the default ticket type.' => 'Define el tipo de ticket predeterminado.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Define el módulo frontend usado por defecto si no se proporciona el parámetro Acción en la URL de la interfaz del agente.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Define el módulo frontend usado por defecto si no se proporciona el parámetro Acción en la URL de la interfaz del cliente.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Define el valor por defecto para el parámetro Acción de la interfaz pública. Dicho parámetro se usa en los scripts del sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Define los valores visibles por defecto para el tipo de remitente de un ticket (por defecto: cliente).',
        'Defines the default visibility of the article to customer for this operation.' =>
            'Define la visibilidad por defecto del artículo para el cliente para esta operación.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            'Define el estilo de visualización del campo De en las notas visibles para los clientes. Se puede definir un nombre de agente por defecto en el ajuste Ticket::Frontend::CustomerTicketZoom###DefaultAgentName.',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Define los campos dinámicos que se utilizan para mostrar en los eventos del calendario.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'Define los tipos de objeto de evento que se manejan a través del AdminAppointmentNotificationEvent.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Define la ruta de retorno para abrir el binario de fetchmail. Nota: El nombre del binario tiene que ser \'fetchmail\', si es diferente utilice un enlace simbólico.',
        'Defines the filter that processes the HTML templates.' => 'Define el filtro que procesa las plantillas HTML.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Define el filtro que procesa el texto en los artículos, para resaltar las URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Define el formato de las respuestas en la pantalla de composición de tickets de la interfaz del agente ([% Data.OrigFrom | html %] es From 1:1, [% Data.OrigFromName | html %] es sólo el nombre real de From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTOBO_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Define el nombre del dominio totalmente calificado del sistema. Esta configuración es usada como la variable OTOBO_CONFIG_FQDN, misma que se encuentra en todos los tipos de mensajes usados en la aplicación, para construir vínculos a los tickets del sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            'Define los grupos en los que estará cada usuario cliente (si CustomerGroupSupport está habilitado y no quieres gestionar cada usuario cliente para estos grupos).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            'Define los grupos en los que estará cada cliente (si CustomerGroupSupport está habilitado y no quiere gestionar cada cliente para estos grupos).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define la altura del componente del editor de texto enriquecido para esta pantalla. Introduzca un número (píxeles) o un valor porcentual (relativo).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la altura del componente del editor de texto enriquecido. Introduzca un número (píxeles) o un valor porcentual (relativo).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket de correo electrónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket telefónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el comentario histórico para la acción de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario del historial para la acción de la pantalla de entrada del teléfono del ticket, que se utiliza para el historial del ticket en la interfaz del agente.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana de ticket telefónico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el comentario histórico para la acción de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el comentario histórico para la acción de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Define el comentario del historial para esta operación, que se utiliza para el historial de tickets en la interfaz del agente.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de cerrar un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket de correo electrónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket telefónico. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Define el tipo histórico para la acción de la ventana de campos libres de ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para agregar una nota al ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar el propietario de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para definir un ticket como pendiente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo de historial para la acción de la pantalla de entrada del teléfono del ticket, que se utiliza para el historial del ticket en la interfaz del agente.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana de ticket telefónico saliente. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar la prioridad de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Define el tipo histórico para la acción de la ventana para cambiar el responsable de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Define el tipo histórico para la acción de la ventana de vista detallada de un ticket. Dicho comentario es usado para la historia del ticket, en la interfaz del agente.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Define el tipo de historial para esta operación, que se utiliza para el historial de tickets en la interfaz del agente.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Define las horas y los días de la semana del calendario indicado, para contar el tiempo de trabajo.',
        'Defines the hours and week days to count the working time.' => 'Define las horas y los días laborales de la semana.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Define la llave que se verificará con el módulo Kernel::Modules::AgentInfo. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Define la llave que se verificará con CustomerAccept. Si esta llave de preferencias de usuario es verdadera, el mensaje es aceptado por el sistema.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de vínculo \'Normal\'. Si los nombres fuente y objetivo contienen el mismo valor, el vínculo resultante es no-direccional; de lo contrario, se obtiene un vínculo direccional.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Define el tipo de vínculo \'PadreHijo\'. Si los nombres fuente y objetivo contienen el mismo valor, el vínculo resultante es no-direccional; de lo contrario, se obtiene un vínculo direccional.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Define el tipo de vínculo \'Grupos\'. Los tipos de vínculo del mismo grupo se cancelan mutuamente. Por ejemplo: Si el ticket A está enlazado con el ticket B por un vínculo \'Normal\', no es posible que estos mismos tickets además estén enlazados por un vínculo de relación \'PadreHijo\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Define la lista de repositorios en línea. Se puede utilizar otra instalación como repositorio, por ejemplo: Key="http://example.com/otobo/public.pl?Action=PublicRepository;File=" y Content=" Algún Nombre".',
        'Defines the list of params that can be passed to ticket search function.' =>
            'Define la lista de parámetros que pueden ser enviados a la función de búsqueda de tickets.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Define la lista de posibles acciones siguientes en una pantalla de error, se requiere una ruta completa, luego es posible añadir enlaces externos si es necesario.',
        'Defines the list of types for templates.' => 'Define la lista de tipos para las plantillas.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Define la ubicación para obtener una lista de repositorios en línea para paquetes adicionales. Se usará el primer resultado disponible.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Define el módulo log del sistema. "Archivo" escribe todos los mensajes en un archivo log, "SysLog" usa el demonio syslog del sistema, por ejemplo: syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTOBO instance to stop working (probably any mask which takes input from the user).' =>
            'Define el tamaño máximo (en bytes) para la subida de archivos a través del navegador. Advertencia: Establecer esta opción a un valor demasiado bajo puede hacer que muchas máscaras en su instancia de OTOBO dejen de funcionar (probablemente cualquier máscara que tome la entrada del usuario).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Define el tiempo máximo (en segundos) válido para un id de sesión.',
        'Defines the maximum number of affected tickets per job.' => 'Define el número máximo de tickets afectados por trabajo.',
        'Defines the maximum number of pages per PDF file.' => 'Define el número máximo de páginas por archivo PDF.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Define el número máximo de líneas entrecomilladas que se añadirán a las respuestas.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Define el número máximo de tareas que se ejecutarán al mismo tiempo.',
        'Defines the maximum size (in MB) of the log file.' => 'Define el tamaño máximo (en MG) del archivo log.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Define el tamaño máximo en KiloByte de las respuestas de GenericInterface que se registran en la tabla gi_debugger_entry_content.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Define el módulo que muestra, en la interfaz del agente, una lista de todos los agentes con sesión activa.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'Define el módulo que muestra todos los clientes actualmente conectados en la interfaz del agente.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'Define el módulo que muestra los agentes actualmente conectados en la interfaz del cliente.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'Define el módulo que muestra los clientes actualmente conectados en la interfaz de cliente.',
        'Defines the module to authenticate customers.' => 'Define el módulo para autenticar clientes.',
        'Defines the module to display a notification in the agent interface if the OTOBO Daemon is not running.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente si el demonio OTOBO no se está ejecutando.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente si la configuración del sistema no está sincronizada.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente, si éste aún no ha seleccionado una zona horaria.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente, si el agente está conectado mientras tiene activa la salida de la oficina.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente, si el agente está conectado mientras tiene el mantenimiento del sistema activo.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Define el módulo para desplegar una notificación, en la interfaz del agente, si el sistema está siendo usado por el usuario adminstrador (normalmente no es recomendable trabajar como administrador).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente, si hay ajustes de sysconfig no válidos desplegados.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            'Define el módulo para mostrar una notificación en la interfaz del agente, si hay ajustes de sysconfig modificados que aún no se han desplegado.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            'Define el módulo para mostrar una notificación en la interfaz del cliente, si el cliente está conectado mientras tiene el mantenimiento del sistema activo.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            'Define el módulo para mostrar una notificación en la interfaz del cliente, si el usuario del cliente aún no ha seleccionado una zona horaria.',
        'Defines the module to generate code for periodic page reloads.' =>
            'Define el módulo para generar código para las recargas periódicas de la página.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            'Define el módulo para enviar correos electrónicos. "DoNotSendEmail" no envía correos electrónicos en absoluto. Cualquiera de los mecanismos "SMTP" utiliza un servidor de correo (externo) especificado. "Sendmail" utiliza directamente el binario de sendmail de su sistema operativo. "Test" no envía correos electrónicos, pero los escribe en $OTOBO_HOME/var/tmp/CacheFileStorable/EmailTest/ para fines de prueba.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Define el módulo usado para almacenar los datos de sesión. Con "DB" el servidor frontend puede separarse del servidor de la base de datos. "FS" es más rápido.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Define el nombre de la aplicación, mostrado en la interfaz web, lengüetas (tabs) y en la barra de título del explorador web.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Define el nombre de la columna para guardar los datos en la tabla de preferencias.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Define el nombre de la columna para guardar el identificador del usuario en la tabla de preferencias.',
        'Defines the name of the indicated calendar.' => 'Define el nombre del calendario indicado.',
        'Defines the name of the key for customer sessions.' => 'Define el nombre de la llave para las sesiones de los clientes.',
        'Defines the name of the session key. E.g. Session, SessionID or OTOBO.' =>
            'Define el nombre de las llaves de sesión. Por ejemplo: Sesión, SesiónID u OTOBO.',
        'Defines the name of the table where the user preferences are stored.' =>
            'Define el nombre de la tabla donde se almacenan las preferencias del usuario.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de redactar / responder un ticket, en la ventana de redacción de la interfaz del agente.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de reenviar un ticket, en la ventana de reenvío de tickets de la interfaz del agente.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Define los siguientes estados posibles después de enviar un mensaje en la pantalla de salida de correo electrónico de la interfaz del agente.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Define la lista de posibles estados siguientes para los tickets de los clientes, en la interfaz del cliente.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana de campos libres de ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para añadir una nota al ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para establecer un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de agregar una nota, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de haber sido rebotado, en la ventana para rebotar dicho ticket, en la interfaz del agente.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, luego de moverlo a otra fila, en la ventana para mover un ticket, en la interfaz del agente.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Define el siguiente estado de un ticket, en la pantalla de conjunto de tickets de la interfaz del agente.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Define el número de caracteres por línea utilizados en el caso de una sustitución de la vista previa del artículo HTML en TemplateGenerator para EventNotifications.',
        'Defines the number of days to keep the daemon log files.' => 'Define el número de días para mantener los archivos de registro del demonio.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Define el número de campos de cabecera en los módulos del frontend para añadir y actualizar los filtros del postmaster. Puede ser de hasta 99 campos.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            'Define el número de horas que se almacenará una comunicación, sea cual sea su estado.',
        'Defines the number of hours a successful communication will be stored.' =>
            'Define el número de horas que se almacenará una comunicación exitosa.',
        'Defines the parameters for the customer preferences table.' => 'Define los parámetros para la tabla de preferencias del cliente.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Define los parámetros para el backend del cuadro de mando. "Cmd" se utiliza para especificar el comando con parámetros. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" indica si el plugin está habilitado por defecto o si el usuario debe habilitarlo manualmente. "CacheTTL" indica el periodo de expiración de la caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Define los parámetros para el backend del cuadro de mando. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" indica si el plugin está habilitado por defecto o si el usuario debe habilitarlo manualmente. "CacheTTL" indica el periodo de expiración de la caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Define los parámetros para el backend del dashboard. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" indica si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" define el periodo de expiración de la caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Define los parámetros para el backend del dashboard. "Límite" define el número de entradas mostradas por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" indica si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTL" indica el periodo de expiración de la caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Define los parámetros para el backend del dashboard. "Límite" define el número de entradas mostradas por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" indica si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" define el periodo de expiración de la caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define la contraseña para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita cursiva monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita cursiva proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra negrita proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra cursiva monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra cursiva proporcional, en los documentos PDF.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra con monoespaciado, en los documentos PDF.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Define la ruta y el archivo TTF para manejar el tipo de letra proporcional, en los documentos PDF.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Define la ruta del archivo de información mostrado, que se encuentra en Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'Define la ruta al PGP binario.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Define la ruta al ssl abierto binario.',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Define el período de tiempo (en minutos) antes de que el agente sea marcado como "ausente" debido a la inactividad (por ejemplo, en el widget "Usuarios conectados" o para el chat).',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Define el período de tiempo (en minutos) antes de que el cliente sea marcado como "ausente" debido a la inactividad (por ejemplo, en el widget "Usuarios conectados" o para el chat).',
        'Defines the postmaster default queue.' => 'Define la fila por defecto del administrador de correos.',
        'Defines the priority in which the information is logged and presented.' =>
            'Define la prioridad con la que se registra y presenta la información.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Define el destino del ticket telefónico y el remitente del ticket de correo electrónico ("Cola" muestra todas las colas, "Dirección del sistema" muestra todas las direcciones del sistema) en la interfaz del agente.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Define el destino de los tickets ("Cola" muestra todas las colas, "Dirección del sistema" muestra sólo las colas asignadas a direcciones del sistema) en la interfaz del cliente.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Define los permisos requeridos para mostrar un ticket en la vista de escaladas de la interfaz del agente.',
        'Defines the search limit for the stats.' => 'Define el límite de búsqueda para las estadísticas.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'Define los parámetros de búsqueda para la pantalla AgentCustomerUserAddressBook. Con el ajuste \'CustomerTicketTextField\' se pueden especificar los valores del campo destinatario.',
        'Defines the sender for rejected emails.' => 'Define el remitente de los correos electrónicos rechazados.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Define el separador entre el nombre real de los agentes y la dirección de correo electrónico de la fila proporcionada.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'Define las columnas mostradas y la posición en la pantalla de resultados de AgentCustomerUserAddressBook.',
        'Defines the shown links in the footer area of the customer and public interface of this OTOBO system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            'Define los enlaces mostrados en el área de pie de página de la interfaz de cliente y público de este sistema OTOBO. El valor en "Clave" es la URL externa, el valor en "Contenido" es la etiqueta mostrada.',
        'Defines the source dynamic field for storing historical data.' =>
            'Define el campo dinámico de origen para almacenar los datos históricos.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Define los permisos estándar, disponibles para los clientes en la aplicación. Si se requieren más permisos, pueden agregarse aquí, sin embargo, es necesario codificarlos para que funcionen. Por favor, cuando agregue algún permiso, asegúrese de que "rw" permanezca como la última entrada.',
        'Defines the standard size of PDF pages.' => 'Define el tamaño estándar de las páginas PDF.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Define el estado de un ticket si se le da seguimiento y ya estaba cerrado.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Define el estado de un ticket si se le da seguimiento.',
        'Defines the state type of the reminder for pending tickets.' => 'Define el tipo de estado para el recordatorio para los tickets pendientes.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los agentes, sobre una contraseña nueva.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los agentes, con token sobre una contraseña nueva solicitada.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, sobre una cuenta nueva.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, sobre una contraseña nueva.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Define el asunto para las notificaciones electrónicas enviadas a los clientes, con token sobre una contraseña nueva solicitada.',
        'Defines the subject for rejected emails.' => 'Define el asunto para los correos electrónicos rechazados.',
        'Defines the subject for the quick close action, which gets used for ticket history in the agent interface.' =>
            'Define el asunto para la acción de cierre rápido, que se utiliza para el historial de tickets en la interfaz del agente.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Define la dirección de correo electrónico del administrador del sistema, misma que se desplegará en las ventanas de error de la aplicación.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).' =>
            'Define el identificador del sistema. Cada número de ticket y cadena de sesión http contiene este identificador. Esto asegura que sólo los tickets que pertenecen a su sistema serán procesados como seguimientos (útil cuando se comunica entre dos instancias de OTOBO).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Define el atributo de destino en el enlace a la base de datos externa de clientes. Por ejemplo, \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Define el atributo objetivo en el vínculo para una base de datos de cliente externa. Por ejemplo: \'target="cdb"\'.',
        'Defines the target dynamic fields for storing historical data.' =>
            'Define los campos dinámicos de destino para el almacenamiento de datos históricos.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            'Define el tipo de cita del ticket en el backend para el campo dinámico de fecha-hora del ticket.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            'Define el tipo de cita del ticket en el backend para el tiempo de escalado del mismo.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            'Define el tipo de cita del ticket en el backend para el tiempo de espera del ticket.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Define los campos del ticket que se van a mostrar los eventos del calendario. La "Clave" define el campo o atributo del ticket y el "Contenido" define el nombre a mostrar.',
        'Defines the ticket plugin for calendar appointments.' => 'Define el plugin de ticket para las citas de calendario.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Define la zona horaria del calendario indicado, que puede asignarse posteriormente a una cola específica.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTOBO Daemon).' =>
            'Define el tiempo de espera (en segundos, el mínimo es 20 segundos) para la recogida de datos de soporte con el módulo público \'PublicSupportDataCollector\' (por ejemplo, utilizado desde el Daemon OTOBO).',
        'Defines the two-factor module to authenticate agents.' => 'Define el módulo de dos factores para autenticar a los agentes.',
        'Defines the two-factor module to authenticate customers.' => 'Define el módulo de dos factores para autenticar a los clientes.',
        'Defines the type of protocol that is used by the web server to serve the application. If the webserver uses HTTP instead of of HTTPS, then \'http\' must be specified here. The setting of \'HttpType\' has no affect on the web server\'s settings or behavior. Specifically, it will not change the method of access to the application. If the setting is wrong, it will not prevent you from logging into the application. This setting is used mainly via the template variable OTOBO_CONFIG_HttpType. This variable is found in all forms of messaging used by the application. It is used to build links to the tickets within your system. Another effect of keeping \'HttpType\' set to \'https\' is that the session management cookie will only be set for secure connections.' =>
            'Define el tipo de protocolo que utiliza el servidor web para servir la aplicación. Si el servidor web utiliza HTTP en lugar de HTTPS, entonces debe especificarse aquí \'http\'. La configuración de \'HttpType\' no afecta a la configuración o comportamiento del servidor web. Específicamente, no cambiará el método de acceso a la aplicación. Si la configuración es incorrecta, no impedirá que se acceda a la aplicación. Esta configuración se utiliza principalmente a través de la variable de plantilla OTOBO_CONFIG_HttpType. Esta variable se encuentra en todas las formas de mensajería utilizadas por la aplicación. Se utiliza para construir enlaces a los tickets dentro de su sistema. Otro efecto de mantener \'HttpType\' establecido en \'https\' es que la cookie de gestión de sesión sólo se establecerá para conexiones seguras.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Define el carácter utilizado para las citas de correo electrónico en texto plano en la pantalla de composición de tickets de la interfaz del agente. Si está vacío o inactivo, los correos electrónicos originales no se citarán sino que se añadirán a la respuesta.',
        'Defines the user identifier for the customer panel.' => 'Define el identificador de usuario para la interfaz del cliente.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Define el nombre de usuario para acceder al manejo SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Define el avatar del usuario. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            'Define los tipos de estado válidos para un ticket. Si un ticket está en un estado que tiene cualquier tipo de estado de esta configuración, este ticket se considerará como abierto, de lo contrario como cerrado.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Define los estados válidos para los tickets desbloqueados. Para desbloquear los tickets se puede utilizar el script "bin/otobo.Console.pl Maint::Ticket::UnlockTimeout".',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'Define los bloqueos visibles de un ticket. NOTA: Cuando cambie esta configuración, asegúrese de eliminar la caché para poder utilizar el nuevo valor. Por defecto: desbloqueo, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Define el ancho del componente del editor de texto enriquecido para esta pantalla. Introduzca un número (píxeles) o un valor porcentual (relativo).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Define la anchura del editor de texto enriquecido. Proporcione un número (pixeles) o un porcentaje (relativo).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            'Define el tiempo en minutos desde la última modificación de los borradores del tipo especificado antes de que se consideren caducados.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            'Define si se indexan los tickets archivados para las búsquedas de texto completo.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Define qué tipos de remitentes de artículos deben mostrarse en la vista previa de un ticket.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Define qué elementos están disponibles para la "Acción" en el tercer nivel de la estructura ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Define qué elementos están disponibles en el primer nivel de la estructura ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Define qué elementos están disponibles en el segundo nivel de la estructura ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Define los estados deberán ajustarse automáticamente (Contenido), después de que se cumpla el tiempo pendiente del estado (Llave).',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Define qué tickets de qué tipo de estado de ticket no deben aparecer en las listas de tickets enlazados.',
        'Delete expired cache from core modules.' => 'Eliminar el caché caducado de los módulos centrales.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Borrar el caché del cargador caducado semanalmente (los domingos por la mañana).',
        'Delete expired sessions.' => 'Eliminar sesiones expiradas.',
        'Delete expired ticket draft entries.' => 'Eliminar las entradas de ticket borrador caducados.',
        'Delete expired upload cache hourly.' => 'Borrar el caché de carga caducado cada hora.',
        'Delete this ticket' => 'Eliminar este ticket',
        'Deleted link to ticket "%s".' => 'Eliminado enlace al ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Elimina la sesión si el identificador de la misma está siendo usado con una dirección IP remota inválida.',
        'Deletes requested sessions if they have timed out.' => 'Elimina las sesiones solicitadas, si ya expiraron.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Ofrece información de depuración ampliada en el frontend en caso de que se produzca algún error de AJAX, si está activado.',
        'DeploymentHistory' => 'Historial de despliegue',
        'Detached' => 'Independiente',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            'Determina si se debe mostrar un botón para eliminar un enlace junto a cada enlace en cada máscara de zoom.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Determina si la lista de colas posibles a las que los tickets pueden ser movidos, deberá mostrarse en una lista desplegable o en una nueva ventana, en la interfaz del agente. Si se elije "Ventana nueva", es posible añadir una nota al mover el ticket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Determina si el módulo de estadísticas puede generar listas de tickets.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket de correo electrónico nuevo en la interfaz del agente.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Define la lista de posibles estados siguientes de ticket, luego de haber creado un ticket telefónico nuevo en la interfaz del agente.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Determina los siguientes estados posibles del ticket, para procesar tickets en la interfaz del agente.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'Determina los siguientes estados posibles del ticket, para procesar tickets en la interfaz del cliente.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Determina la pantalla siguiente, luego de haber creado un ticket en la interfaz del cliente.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Determina la siguiente pantalla después de la pantalla de seguimiento de un ticket ampliado en la interfaz del cliente.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Determina la siguiente pantalla después de mover el ticket. LastScreenOverview devolverá la última pantalla de vista general (por ejemplo, resultados de búsqueda, vista de cola, tablero). TicketZoom regresará al TicketZoom.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Determina los estados posibles para tickets pendientes que cambiaron de estado al alcanzar el tiempo límite.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Determina las cadenas que se mostrarán como destinatario (To:) del ticket telefónico y como remitente (From:) del ticket de correo electrónico en la interfaz del agente. Para la cola como NewQueueSelectionType "<Cola>" muestra los nombres de las colas y para SystemAddress "<Nombre real> <<Correo electrónico>>" muestra el nombre y el correo electrónico del destinatario.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Determina las cadenas que se mostrarán como destinatario (To:) del ticket en la interfaz del cliente. Para la cola como CustomerPanelSelectionType, "<Queue>" muestra los nombres de las colas, y para SystemAddress, "<Realname> <<Email>>" muestra el nombre y el correo electrónico del destinatario.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Determina la forma en la que los objetos vinculados se despliegan en cada vista detallada.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Determina qué opciones serán válidas para el destinatario (ticket telefónico) y del remitente (ticket de correo electrónico) en la interfaz del agente.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Determina las colas que serán válidas como remitentes de los ticket, en la interfaz del cliente.',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Desactive la cabecera HTTP "Content-Security-Policy" para permitir la carga de contenidos de scripts externos. Desactivar esta cabecera HTTP puede suponer un problema de seguridad. ¡Sólo desactívela si sabe lo que está haciendo!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTOBO to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Desactive la cabecera HTTP "X-Frame-Options: SAMEORIGIN" para permitir que OTOBO sea incluido como un IFrame en otros sitios web. Desactivar esta cabecera HTTP puede suponer un problema de seguridad. ¡Sólo desactívela si sabe lo que está haciendo!',
        'Disable autocomplete in the login screen.' => 'Desactivar el autocompletado en la pantalla de inicio de sesión.',
        'Disable cloud services' => 'Desactivar los servicios en la nube',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'Desactiva el envío de notificaciones de recordatorio al agente responsable de un ticket (Ticket::Responsible debe estar activado).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            'Desactiva la redirección a la última pantalla de resumen / tablero después de cerrar un ticket.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Mostrar una advertencia e impedir la búsqueda cuando se utilizan palabras de parada en la búsqueda de texto completo.',
        'Display communication log entries.' => 'Muestra las entradas del registro de comunicaciones.',
        'Display settings to override defaults for Process Tickets.' => 'Muestra la configuración para anular los valores predeterminados de los tickets de proceso.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Despliega la contabilidad de tiempo para un artículo, en la vista detallada del ticket.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            'Muestra el número de todos los tickets con el mismo CustomerID que el ticket actual en la vista de zoom del ticket.',
        'Down' => 'Abajo',
        'Dropdown' => 'Desplegable',
        'Dutch' => 'Holandés',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en holandés para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Dynamic Fields Checkbox Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend de campos dinámicos',
        'Dynamic Fields Contact Data Backend GUI' => 'Interfaz gráfica de usuario (GUI) de datos backend de los campos dinámicos de contacto',
        'Dynamic Fields Database Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend de campos dinámicos',
        'Dynamic Fields Date Time Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend de los Campos dinámicos Fecha Hora',
        'Dynamic Fields Drop-down Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend de campos dinámicos desplegables',
        'Dynamic Fields GUI' => 'Interfaz gráfica de usuario (GUI) de campos dinámicos',
        'Dynamic Fields Multiselect Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend de campos dinámicos multiselección',
        'Dynamic Fields Overview Limit' => 'Resumen del Límite campos dinámicos',
        'Dynamic Fields Text Backend GUI' => 'Interfaz gráfica de usuario (GUI) del backend Campos dinámicos Texto',
        'Dynamic Fields Web Service Backend GUI' => 'Interfaz gráfica de usuario (GUI) de los campos dinámicos del servicio web',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Campos dinámicos utilizados para exportar el resultado de la búsqueda en formato CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Grupos de campos dinámicos para el widget de procesos. La clave es el nombre del grupo, el valor contiene los campos a mostrar. Ejemplo: \'Clave => Mi Grupo\', \'Contenido: Nombre_X, NombreY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'Límite de campos dinámicos por página para el resumen de campos dinámicos.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Opciones de campos dinámicos que se muestran en la pantalla de mensajes del ticket de la interfaz del cliente. NOTA. Si desea mostrar estos campos también en el zoom del ticket de la interfaz del cliente, debe habilitarlos en CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            'Opciones de campos dinámicos mostrados en la sección de respuesta del ticket en la pantalla de zoom del ticket de la interfaz del cliente.',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de salida de correo electrónico de la interfaz del agente.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            'Campos dinámicos mostrados en el widget del proceso en la pantalla de zoom del ticket de la interfaz del agente.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            'Campos dinámicos mostrados en la barra lateral de la pantalla de zoom del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de cierre de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de composición de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de correo electrónico del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de envío de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de texto libre del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de resumen del formato del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de movimiento de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de notas del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            'Campos dinámicos mostrados en la pantalla de resumen de tickets de la interfaz de cliente.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla del propietario del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de tickets pendientes de la interfaz del agente.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de entrada del teléfono del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de salida del teléfono del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla del teléfono del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de resumen del formato de vista previa del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de impresión de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            'Campos dinámicos mostrados en la pantalla de impresión de tickets de la interfaz del cliente.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de prioridad del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla del responsable del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            'Campos dinámicos mostrados en la pantalla de resultados de búsqueda de tickets de la interfaz de cliente.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de búsqueda de tickets de la interfaz del agente.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            'Campos dinámicos mostrados en la pantalla de búsqueda de tickets de la interfaz de cliente.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            'Campos dinámicos mostrados en la pantalla de resumen del formato pequeño del ticket de la interfaz del agente.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            'Campos dinámicos mostrados en la pantalla de zoom del ticket de la interfaz del cliente.',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'Registro del backend de DynamicField.',
        'DynamicField object registration.' => 'Registro del objeto DynamicField.',
        'DynamicFieldScreen' => 'DynamicFieldScreen',
        'DynamicField_%s' => 'CampoDinámico_%s',
        'E-Mail Outbound' => 'Correo saliente',
        'Edit Customer Companies.' => 'Editar empresas clientes.',
        'Edit Customer Users.' => 'Editar Usuarios del Cliente.',
        'Edit appointment' => 'Editar cita',
        'Edit contacts with data' => 'Editar contactos con datos',
        'Edit contacts with data.' => 'Editar contactos con datos.',
        'Edit customer company' => 'Editar empresa del cliente',
        'Elasticsearch quick result module.' => 'Módulo de resultados rápidos de Elasticsearch.',
        'Email Addresses' => 'Direcciones de Correo',
        'Email Outbound' => 'Correo electrónico de salida',
        'Email Resend' => 'Reenviar el correo electrónico',
        'Email communication channel.' => 'Canal de comunicación por correo electrónico.',
        'Enable highlighting queues based on ticket age.' => 'Habilitar el resaltado de colas en función de la antigüedad del ticket.',
        'Enable keep-alive connection header for SOAP responses.' => 'Habilitar la cabecera de conexión keep-alive para las respuestas SOAP.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Habilite esto si confía en todas sus claves pgp públicas y privadas, aunque no estén certificadas con una firma de confianza.',
        'Enabled filters.' => 'Filtros Habilitados.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTOBO user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Activa el soporte de PGP. Cuando se habilita el soporte de PGP para firmar y encriptar el correo, es MUY recomendable que el servidor web se ejecute como el usuario OTOBO. De lo contrario, habrá problemas con los privilegios al acceder a la carpeta .gnupg.',
        'Enables S/MIME support.' => 'Habilita el soporte S/MIME.',
        'Enables customers to create their own accounts.' => 'Permite a los clientes crear sus propias cuentas.',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'Habilita la recuperación de S/MIME desde el soporte de backend CustomerUser.',
        'Enables file upload in the package manager frontend.' => 'Permite cargar archivos en el frontend del administrador de paquetes.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Activa o desactiva el almacenamiento en caché de las plantillas. ADVERTENCIA: ¡NO deshabilite el almacenamiento en caché de las plantillas en entornos de producción, ya que provocará una caída masiva del rendimiento! ¡Este ajuste sólo debe ser desactivado por razones de depuración!',
        'Enables or disables the debug mode over frontend interface.' => 'Activa o desactiva el modo de depuración a través del frontend.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Habilita o deshabilita la funcionalidad de monitoreo, para realizar un seguimiento de los tickets, sin ser el propietario o el responsable.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Habilita el log de desempeño (para registrar el tiempo de respuesta de las páginas). El desempeño del sistema se verá afectado. Frontend::Module###AdminPerformanceLog tiene que estar habilitado.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Activa el tamaño mínimo del contador de tickets (si se ha seleccionado "Fecha" como TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Habilita la funcionalidad de acción múltiple sobre tickets para la interfaz del agente.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Habilita la funcionalidad de acción múltiple sobre tickets únicamente para los grupos listados.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Habilita la funcionalidad de responsable del ticket, para realizar un seguimiento de los tickets.',
        'Enables ticket type feature.' => 'Activa la función de tipo de ticket.',
        'Enables ticket watcher feature only for the listed groups.' => 'Habilita la funcionalidad de monitoreo de tickets sólo para los grupos listados.',
        'Enabling SecureMode disables the web installer (http://yourhost.example.com/otobo/installer.pl) and the migrations. This is done in order to prevent the system from being hijacked. When SecureMode is not enabled the system can be reinstalled. In this case the current basic configuration will be used to pre-populate the questions within the installer script. Enabling SecureMode also enables GenericAgent, PackageManager and SQL Box.' =>
            'Al activar SecureMode se desactiva el instalador web (http://yourhost.example.com/otobo/installer.pl) y las migraciones. Esto se hace para evitar que el sistema sea secuestrado. Cuando SecureMode no está habilitado, el sistema puede ser reinstalado. En este caso, se utilizará la configuración básica actual para rellenar previamente las preguntas del script de instalación. Al activar SecureMode también se activan GenericAgent, PackageManager y SQL Box.',
        'English (Canada)' => 'Inglés (Canadá)',
        'English (United Kingdom)' => 'Inglés (Reino Unido)',
        'English (United States)' => 'Inglés (Estados Unidos)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en inglés para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Enroll process for this ticket' => 'Proceso de inscripción para este ticket',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            'Introduzca su clave secreta compartida para activar la autenticación de dos factores. ADVERTENCIA: Asegúrate de que añades la clave secreta compartida a tu aplicación generadora y que la aplicación funciona bien. De lo contrario, ya no podrá iniciar sesión sin el token de dos factores.',
        'Escalated Tickets' => 'Tickets escalados',
        'Escalation view' => 'Vista de escaladas',
        'EscalationTime' => 'EscalationTime',
        'Estonian' => 'Estoniano',
        'Event module registration (store historical data in dynamic fields).' =>
            'Registro del módulo de eventos (almacenar datos históricos en campos dinámicos).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Registro del módulo de eventos. Para un mayor rendimiento, puede definir un evento desencadenante (por ejemplo, Evento => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Registro del módulo de eventos. Para un mayor rendimiento, puede definir un evento desencadenante (por ejemplo, Evento => TicketCreate). Esto sólo es posible si todos los campos dinámicos del ticket necesitan el mismo evento.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Módulo de eventos que realiza una sentencia de actualización en TicketIndex para renombrar el nombre de la cola allí si es necesario y si se utiliza realmente StaticDB.',
        'Event module that updates customer company object name for dynamic fields.' =>
            'Módulo de eventos que actualiza el nombre del objeto empresa del cliente para los campos dinámicos.',
        'Event module that updates customer user object name for dynamic fields.' =>
            'Módulo de eventos que actualiza el nombre del objeto usuario cliente para los campos dinámicos.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Módulo de eventos que actualiza los perfiles de búsqueda de los usuarios clientes si se producen cambios en el inicio de sesión.',
        'Event module that updates customer user service membership if login changes.' =>
            'Módulo de eventos que actualiza la membresía del servicio de usuario cliente si el inicio de sesión cambia.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Módulo de eventos que actualiza los usuarios del cliente después de una actualización del mismo.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Módulo de eventos que actualiza los tickets tras una actualización del usuario cliente.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Módulo de eventos que actualiza los tickets tras una actualización del Cliente.',
        'Events Ticket Calendar' => 'Calendario de eventos',
        'Example package autoload configuration.' => 'Ejemplo de configuración de autocarga de paquetes.',
        'Execute SQL statements.' => 'Ejecutar sentencias SQL.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Ejecuta un comando o módulo personalizado. Nota: si se utiliza un módulo, la función es obligatoria.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta comprobaciones de seguimiento en las cabeceras In-Reply-To o References para los correos que no tienen un número de ticket en el asunto.',
        'Executes follow-up checks on OTOBO Header \'X-OTOBO-Bounce\'.' =>
            'Ejecuta comprobaciones de seguimiento en la cabecera OTOBO \'X-OTOBO-Bounce\'.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta verificaciones de seguimiento en el contenido de los archivos adjuntos para correos que no tienen un número de ticket en el asunto.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta comprobaciones de seguimiento en el cuerpo del correo electrónico para los correos que no tienen un número de ticket en el asunto.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Ejecuta comprobaciones de seguimiento en el correo electrónico de origen en bruto para los correos que no tienen un número de ticket en el asunto.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Exporta el árbol de artículo completo en el resultado de la búsqueda. Esto puede afectar el desempeño del sistema.',
        'External' => 'Externo',
        'External Link' => 'Liga externa',
        'Fetch emails via fetchmail (using SSL).' => 'Recuperar email via fetchmail (usando SSL).',
        'Fetch emails via fetchmail.' => 'Recuperar email via fetchmail.',
        'Fetch incoming emails from configured mail accounts.' => 'Recuperar correos entrantes de las cuentas de email configuradas.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Obtiene paquetes vía proxy. Sobrescribe "WebUserAgent::Proxy".',
        'Fields of the customer company index, used for the company fulltext search. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Campos del índice de la empresa cliente, utilizados para la búsqueda de texto completo de la empresa. Los campos también se almacenan, pero no son obligatorios para la funcionalidad general.',
        'Fields of the ticket index, used for the ticket fulltext search. Fields are also stored, but are not mandatory for the overall functionality. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Campos del índice del ticket, utilizados para la búsqueda de texto completo del ticket. Los campos también se almacenan, pero no son obligatorios para la funcionalidad general. Si se añaden campos que pueden actualizarse (especialmente DynamicFields), ¡su respectivo evento de actualización debe añadirse al invocador TicketManagement del servicio web de Elasticsearch!',
        'Fields stored in the customer company index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Campos almacenados en el índice de empresa cliente que se utilizan para otras cosas además de las búsquedas de texto completo. Para la funcionalidad completa todos los campos son obligatorios.',
        'Fields stored in the customer user index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory.' =>
            'Campos almacenados en el índice de usuario cliente que se utilizan para otras cosas además de las búsquedas de texto completo. Para la funcionalidad completa todos los campos son obligatorios.',
        'Fields stored in the ticket index which are used for other things besides fulltext searches. For the complete functionality all fields are mandatory. If fields are added which can be updated (especially DynamicFields), their respective update event has to be added to the TicketManagement invoker of the Elasticsearch webservice!' =>
            'Campos almacenados en el índice del ticket que se utilizan para otras cosas además de las búsquedas de texto completo. Para la funcionalidad completa todos los campos son obligatorios. Si se añaden campos que pueden ser actualizados (especialmente DynamicFields), ¡su respectivo evento de actualización tiene que ser añadido al invocador TicketManagement del servicio web de Elasticsearch!',
        'Fields to be searched in ticket index. Fields are also stored, but are not mandatory for the overall functionality.' =>
            'Campos a buscar en el índice de tickets. Los campos también se almacenan, pero no son obligatorios para la funcionalidad general.',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Archivo que se muestra en el módulo Kernel::Modules::AgentInfo, si se encuentra en Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filtro para depurar ACLs. Nota: Se pueden añadir más atributos de tickets con el formato <OTOBO_TICKET_Attribute>, por ejemplo, <OTOBO_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTOBO_TICKET_Attribute> e.g. <OTOBO_TICKET_Priority>.' =>
            'Filtro para depurar las transiciones. Nota: Se pueden añadir más filtros con el formato <OTOBO_TICKET_Attribute>, por ejemplo, <OTOBO_TICKET_Priority>.',
        'Filter incoming emails.' => 'Filtrar correos electrónicos entrantes.',
        'Finnish' => 'Finlandés',
        'First Christmas Day' => 'Navidad',
        'First Queue' => 'Primera Fila de Espera',
        'First response time' => 'Tiempo de primera respuesta',
        'FirstLock' => 'Primer bloqueo',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'Nombre Apellido',
        'Firstname Lastname (UserLogin)' => 'Nombre Apellido (UserLogin)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            'Para estos tipos de estado, los números de ticket están tachados en la tabla de enlaces.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Forzar el almacenamiento del texto original del artículo en el índice de búsqueda de artículos, sin ejecutar filtros ni aplicar listas de palabras de parada. Esto aumentará el tamaño del índice de búsqueda y, por tanto, puede ralentizar las búsquedas de texto completo.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Fuerza la codificación de correos electrónicos salientes (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Fuerza a elegir un estado de ticket distinto al actual, luego de bloquear dicho ticket. Define como llave al estado actual y como contenido al estado posterior al bloqueo.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Fuerza a desbloquear los tickets, luego de moverlos a otra fila.',
        'Format of Creation date shown for tickets. As an example \'%Y-%m-%d %H:%M:%S\' would be interpreted as \'2020-01-22 18:07:23\'. Please refer to http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.' =>
            'Formato de la fecha de creación mostrada para los tickets. Por ejemplo, "%Y-%m-%d %H:%M:%S" se interpretaría como "2020-01-22 18:07:23". Consulte http://search.cpan.org/~drolsky/DateTime-1.21/lib/DateTime.pm#strftime_Patterns.',
        'Format to be ingested.' => 'Formato a consumir.',
        'Forwarded to "%s".' => 'Reenviado a "%s".',
        'French' => 'Francés',
        'French (Canada)' => 'Francés (Canadá)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en francés para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Frontend' => 'Frontend',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'Registro del módulo frontend (desactive el enlace AgentTicketService si no se utiliza la función Ticket Service).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Registro de módulo frontend (deshabilita el vínculo de compañía si no se está usando la funcionalidad de compañía).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Registro del módulo Frontend (desactivar la pantalla de procesos de tickets si no hay procesos disponibles) para el Cliente.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Registro del módulo frontend (desactivar la pantalla de procesos del ticket si no hay ningún proceso disponible).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'Registro del módulo frontend (mostrar los favoritos personales como elementos de subnavegación de \'Admin\').',
        'Frontend module registration for the admin interface.' => 'Registro del módulo frontend para la interfaz de administración.',
        'Frontend module registration for the agent interface.' => 'Registro de módulo frontend para la interfaz del agente.',
        'Frontend module registration for the customer interface.' => 'Registro de módulo frontend para la interfaz del cliente.',
        'Frontend module registration for the public interface.' => 'Registro de módulo "Frontend" en la interfaz pública.',
        'Full value' => 'Valor completo',
        'Fulltext index regex filters to remove parts of the text.' => 'Filtros de índice de expresiones regulares de texto completo para eliminar partes del texto.',
        'Fulltext search' => 'Búsqueda de texto completo',
        'Fulltext search using Elasticsearch.' => 'Búsqueda de texto completo mediante Elasticsearch.',
        'FulltextES' => 'FulltextES',
        'Galician' => 'Gallego',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Datos generales del ticket que se muestran en los resúmenes de los tickets (fall-back). Tenga en cuenta que TicketNumber no se puede desactivar, ya que es necesario.',
        'Generate HTML comment hooks for the specified blocks so that filters can use them.' =>
            'Genera los comentarios HTML de los bloques especificados para que los filtros puedan utilizarlos.',
        'Generate dashboard statistics.' => 'Generar estadísticas del panel.',
        'Generic Info module.' => 'Módulo de información genérica.',
        'GenericAgent' => 'AgenteGenérico',
        'GenericInterface Debugger GUI' => 'Interfaz gráfica de usuario (GUI) del depurador de la GenericInterface',
        'GenericInterface ErrorHandling GUI' => 'Interfaz gráfica de usuario (GUI) GenericInterface ErrorHandling',
        'GenericInterface Invoker Event GUI' => 'Interfaz gráfica de usuario (GUI) del invocación de eventos GenericInterface',
        'GenericInterface Invoker GUI' => 'Interfaz gráfica de usuario (GUI) del invocador GenericInterface',
        'GenericInterface Operation GUI' => 'Interfaz gráfica de usuario (GUI) de Operación de GenericInterface',
        'GenericInterface TransportHTTPREST GUI' => 'Interfaz gráfica de usuario (GUI) de GenericInterface TransportHTTPREST',
        'GenericInterface TransportHTTPSOAP GUI' => 'Interfaz gráfica de usuario (GUI) de GenericInterface TransportHTTPSOAP',
        'GenericInterface Web Service GUI' => 'Interfaz gráfica de usuario (GUI) del servicio web GenericInterface',
        'GenericInterface Web Service History GUI' => 'Interfaz gráfica de usuario (GUI) del Historial del servicio web GenericInterface',
        'GenericInterface Web Service Mapping GUI' => 'Interfaz gráfica de usuario (GUI) de mapeo de servicios web GenericInterface',
        'GenericInterface module registration for an error handling module.' =>
            'Registro del módulo GenericInterface para un módulo de gestión de errores.',
        'GenericInterface module registration for the PassThrough invoker layer.' =>
            'Registro del módulo GenericInterface para la capa de invocación de PassThrough.',
        'GenericInterface module registration for the invoker layer.' => 'Registro del módulo GenericInterface para la capa de invocación.',
        'GenericInterface module registration for the mapping layer.' => 'Registro del módulo GenericInterface para la capa de mapeo.',
        'GenericInterface module registration for the operation layer.' =>
            'Registro del módulo GenericInterface para la capa de operación.',
        'GenericInterface module registration for the transport layer.' =>
            'Registro del módulo GenericInterface para la capa de transporte.',
        'German' => 'Alemán',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en alemán para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            'Da a los usuarios cliente acceso basado en grupos a los tickets de los usuarios del mismo cliente (el CustomerID del ticket es un CustomerID del usuario del cliente).',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Da a los usuarios finales la posibilidad de anular el carácter separador para los archivos CSV, definido en los archivos de traducción. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Global Search Module.' => 'Módulo de búsqueda global.',
        'Go to dashboard!' => '¡Ir al panel principal!',
        'Good PGP signature.' => 'Buena firma PGP.',
        'Google Authenticator' => 'Autenticador de Google',
        'Graph: Bar Chart' => 'Gráfico: De barras',
        'Graph: Line Chart' => 'Gráfico: De líneas',
        'Graph: Stacked Area Chart' => 'Gráfico: áreas apiladas',
        'Greek' => 'Griego',
        'Hebrew' => 'Hebrep',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            'Ayuda a ampliar la búsqueda de texto completo de sus artículos (De, Para, CC, Asunto y Cuerpo). Despojará todos los artículos y construirá un índice después de la creación del artículo, aumentando las búsquedas de texto completo alrededor del 50%. Para crear un índice inicial utilice "bin/otobo.Console.pl Maint::Ticket::FulltextIndex --rebuild".',
        'High Contrast' => 'Alto contraste',
        'High contrast skin for visually impaired users.' => 'Diseño de alto contraste para usuarios con problemas de visión.',
        'Hindi' => 'Hindú',
        'Hungarian' => 'Húngaro',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un manejador de base de datos (normalmente se utiliza detección automática).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse una contraseña para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un nombre de usuario para conectarse a la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse un DSN para la conexión con la tabla del cliente.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para la contraseña.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'Si se ha seleccionado "DB" para Customer::AuthModule, se debe especificar el tipo de cifrado de las contraseñas.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la columna de la tabla del cliente para el identificador (llave).',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Si "DB" se eligió como Customer::AuthModule, puede especificarse el nombre de la tabla en la que se guardarán los datos de los clientes.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Si "DB" se eligió como SessionModule, puede especificarse el nombre de la tabla en la que se guardarán los datos de sesión.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Si "FS" se eligió como SessionModule, puede especificarse un directorio en la que se guardarán los datos de sesión.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Si "HTTPBasicAuth" se eligió como Customer::AuthModule, puede especificarse (usando una expresión regular) la eliminación de partes del REMOTE_USER (por ejmplo: para quitar dominios finales). Nota de expresión regular: $1 será el nuevo inicio de sesión.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Si se ha seleccionado "HTTPBasicAuth" para Customer::AuthModule, puede especificar que se eliminen las partes iniciales de los nombres de usuario (por ejemplo, para dominios como example_domain\\user a user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y se desea añadir un sufijo a cada nombre de inicio de sesión de los clientes, especifíquelo aquí. Por ejemplo: se desea escribir únicamente el nombre de usuario, pero en el directorio LDAP está registrado como usuario@dominio.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y se requieren parámetros especiales para el módulo perl Net::LDAP, pueden especificarse aquí. Refiérase a "perldoc Net::LDAP" para mayor información sobre los parámetros.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y sus usuarios sólo tienen acceso anónimo al árbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aquí la contraseña para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule y sus usuarios sólo tienen acceso anónimo al árbol LDAP, pero se desea buscar en los datos; esto puede lograrse con un usuario que tenga acceso al directorio LDAP. Especifique aquí el nombre para dicho usuario.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse la BaseDN.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse el host LDAP.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse el identificador de usuario.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, pueden especificarse atributos de usuario. Para GruposPosix LDAP, use UID y para los demás, utilice el usuario DN completo.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, pueden especificarse aquí atributos de acceso.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede especificarse si las aplicaciones se detendrán si, por ejemplo, no se puede establecer una conexión con el servidor por problemas en la red.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTOBO. Specify the group, who may access the system.' =>
            'Si "LDAP" se eligió como Customer::AuthModule, puede verificarse si al usuario se le permite autenticarse por estar en un GrupoPosix, por ejemplo: el usuario tiene que estar en el grupo xyz para usar OTOBO. Especifique el grupo que puede acceder al sistema.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Si "LDAP" se eligió como Customer::AuthModule, es posible añadir un filtro a cada consulta LDAP, por ejemplo: (mail=*), (objectclass=user) o (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse una contraseña para autenticar al host radius.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse el host radius.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Si "Radius" se eligió como Customer::AuthModule, puede especificarse si las aplicaciones se detendrán si, por ejemplo, no se puede establecer una conexión con el servidor por problemas en la red.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Si "Sendamail" se eligió como SendmailModule, puede especificarse la ubicación del sendmail binario y las opciones necesarias.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Si "SysLog" se eligió como LogModule, puede especificarse un log especial.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Si "SysLog" se eligió como LogModule, puede especificarse el juego de caracteres que debe usarse para el inicio de sesión.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'Si se seleccionó "bcrypt" para el tipo de encriptación, utilice el coste especificado aquí para el hash bcrypt. Actualmente el valor máximo de coste soportado es 31.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Si "File" se eligió como LogModule, puede especificarse el archivo log. Si dicho archivo no existe, será creado por el sistema.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Si está activo, ninguna de las expresiones regulares puede coincidir con la dirección de correo electrónico del usuario para permitir el registro.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Si se activa, una de las expresiones regulares tiene que coincidir con la dirección de correo electrónico del usuario para permitir el registro.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule y se requiere autenticación para el servidor de correos, debe especificarse una contraseña.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule y se requiere autenticación para el servidor de correos, debe especificarse un nombre de usuario.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule, debe especificarse el host que envía los correos.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Si cualquiera de los mecanismos "SMTP" se eligió como SendmailModule, debe especificarse el puerto en el que el servidor de correos estará escuchando para conexiones entrantes.',
        'If enabled debugging information for ACLs is logged.' => 'Si se activa, se registra la información de depuración de las ACL.',
        'If enabled debugging information for transitions is logged.' => 'Si se activa, se registra la información de depuración de las transiciones.',
        'If enabled defines the preselected state for customer follow-up in the customer interface.' =>
            'Si está activado, define el estado preseleccionado para el seguimiento del cliente en la interfaz del cliente.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Si se activa, el demonio redirigirá el flujo de error estándar a un archivo de registro.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Si se activa, el demonio redirigirá el flujo de salida estándar a un archivo de registro.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTOBOHome>/var/run/ can not be used.' =>
            'Si se activa, el demonio utilizará este directorio para crear sus archivos PID. Nota: Por favor, detenga el demonio antes de cualquier cambio y utilice esta configuración sólo si <$OTOBOHome>/var/run/ no puede ser utilizado.',
        'If enabled, OTOBO will deliver all CSS files in minified form.' =>
            'Si se activa, OTOBO entregará todos los archivos CSS en forma minificada.',
        'If enabled, OTOBO will deliver all JavaScript files in minified form.' =>
            'Si se habilita, OTOBO entregará todos los archivos JavaScript en forma reducida (minified).',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Si se habilita, los módulos de tickets telefónico y de correo electrónico, se abrirán en una ventana nueva.',
        'If enabled, the OTOBO version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'Si está activada, la etiqueta de la versión de OTOBO se eliminará de la interfaz web, de las cabeceras HTTP y de las cabeceras X de los correos salientes. NOTA: Si cambia esta opción, asegúrese de borrar la caché.',
        'If enabled, the cache data be held in memory.' => 'Si se activa, los datos de la caché se mantienen en la memoria.',
        'If enabled, the cache data will be stored in cache backend.' => 'Si se activa, los datos del caché se almacenarán en el caché del backend.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Si se activa, el cliente puede buscar tickets en todos los servicios (independientemente de los servicios asignados al cliente).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Si se activa, las diferentes vistas generales (Dashboard, LockedView, QueueView) se actualizarán automáticamente después del tiempo especificado.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Si se habilita, el primer nivel del menú principal se abre al posicionar el cursor sobre él (en lugar de hacer click).',
        'If enabled, the quick close action will create an article.' => 'Si se activa, la acción de cierre rápido creará un artículo.',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTOBOTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            'Si se habilita, los usuarios que aún no hayan seleccionado una zona horaria recibirán una notificación para que lo hagan. Nota: La notificación no se mostrará si (1) el usuario aún no ha seleccionado una zona horaria y (2) OTOBOTimeZone y UserDefaultTimeZone coinciden y (3) no están configurados en UTC.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'Si no se especifica SendmailNotificationEnvelopeFrom, esta configuración permite utilizar la dirección de correo electrónico del remitente en lugar de un remitente vacío (necesario en determinadas configuraciones del servidor de correo).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'Si se establece, esta dirección se utiliza como cabecera del remitente en las notificaciones salientes. Si no se especifica ninguna dirección, la cabecera del remitente estará vacía (a menos que se establezca SendmailNotificationEnvelopeFrom::FallbackToEmailFrom).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Si se establece, esta dirección se utiliza como remitente en los mensajes salientes (no en las notificaciones - véase más adelante). Si no se especifica ninguna dirección, el remitente es igual a la dirección de correo electrónico de la cola.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            'Si esta opción está habilitada, los tickets creados a través de la interfaz web, a través de Clientes o Agentes, si está configurada recibirán una autorespuesta . Si esta opción no está habilitada, no se enviará ninguna autorespuesta.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Si esta expresión regular coincide, ningún mensaje se mandará por el contestador automático.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTOBO Team. These packages could threaten your whole system!' =>
            'Si esta configuración está activada, es posible que se instalen paquetes que no están verificados por el equipo de OTOBO. ¡Estos paquetes podrían amenazar todo su sistema!',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'Si esta configuración está activada, las modificaciones locales no se resaltarán como errores en el gestor de paquetes ni en el recopilador de datos de soporte.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Si vas a estar fuera de la oficina, puedes avisar a los demás usuarios estableciendo las fechas exactas de tu ausencia.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'Ignorar los tipos de artículos del remitente del sistema (por ejemplo, respuestas automáticas o notificaciones por correo electrónico) para que se marquen como "Artículo no leído" en AgentTicketZoom o se expandan automáticamente en las pantallas de vista grande.',
        'Import appointments screen.' => 'Pantalla de importación de citas.',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Incluir tickets de subcolas por defecto al seleccionar una cola.',
        'Include unknown customers in ticket filter.' => 'Incluir clientes desconocidos en el filtro de tickets.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Incluye los tiempos de creación de los artículos en la búsqueda de tickets de la interfaz del agente.',
        'Incoming Phone Call.' => 'Llamada telefónica entrante.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator: para elegir el módulo TicketViewAccelerator del backend. "RuntimeDB" genera cada vista de cola sobre la marcha a partir de la tabla de tickets (sin problemas de rendimiento hasta aproximadamente 60.000 tickets en total y 6.000 tickets abiertos en el sistema). "StaticDB" es el módulo más potente, utiliza una tabla extra de índice de tickets que funciona como una vista (recomendado si se almacenan más de 80.000 y 6.000 tickets abiertos en el sistema). Utilice el comando "bin/otobo.Console.pl Maint::Ticket::QueueIndexRebuild" para la creación del índice inicial.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            'Indica si un correo electrónico rebotado debe tratarse siempre como un seguimiento normal.',
        'Indonesian' => 'Indonesia',
        'Inline' => 'En línea',
        'Input' => 'Entrada',
        'Interface language' => 'Idioma de la interfaz',
        'Internal communication channel.' => 'Canal de comunicación interno.',
        'International Workers\' Day' => 'Día del trabajo',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes interfases, por ejemplo: para diferenciar entre distintos agentes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una interfaz válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes interfases, por ejemplo: para diferenciar entre distintos clientes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una interfaz válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Es posible configurar diferentes pieles, por ejemplo: para diferenciar entre agentes y clientes, para usarse una base por-dominio en la aplicación. Al definir una expresión regular, puede configurarse un par Llave/Contenido para coincidir con el dominio. El valor en "Key" debe coincidir con el dominio, y "Content" tiene que ser una piel válida en el sistema. Por favor, verifique las entradas de ejemplo para la forma de expresión regular correcta.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            'No fue posible comprobar la firma PGP, esto puede ser causado por una clave pública faltante o un algoritmo no soportado.',
        'Italian' => 'Italiano',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en italiano para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Ivory' => 'Marfil',
        'Ivory (Slim)' => 'Marfil (Liviano)',
        'Japanese' => 'Japonés',
        'JavaScript function for the search frontend.' => 'Función JavaScript para el frontend de búsqueda.',
        'Jump to OTOBO!' => '¡Salta a OTOBO!',
        'Korean' => 'Coreano',
        'Language' => 'Idioma',
        'Large' => 'Grande',
        'Last Screen Overview' => 'Resumen de la última pantalla',
        'Last customer subject' => 'Asunto del último cliente',
        'Lastname Firstname' => 'Apellido Nombre',
        'Lastname Firstname (UserLogin)' => 'Apellido Nombre (UserLogin)',
        'Lastname, Firstname' => 'Apellido, Nombre',
        'Lastname, Firstname (UserLogin)' => 'Apellido, Nombre (UserLogin)',
        'LastnameFirstname' => 'ApellidoNombre',
        'Latvian' => 'Letonia',
        'Left' => 'Izquierda',
        'Link Object' => 'Enlazar Objeto',
        'Link Object.' => 'Objeto de enlace.',
        'Link agents to groups.' => 'Vincular agentes con grupos.',
        'Link agents to roles.' => 'Vincular agentes con roles.',
        'Link customer users to customers.' => 'Liga los usuarios del cliente a clientes.',
        'Link customer users to groups.' => 'Liga los usuarios del cliente a grupos.',
        'Link customer users to services.' => 'Liga los usuarios del cliente a servicios.',
        'Link customers to groups.' => 'Vincular clientes con grupos.',
        'Link queues to auto responses.' => 'Vincular colas de espera con respuestas automáticas.',
        'Link roles to groups.' => 'Vincular roles con grupos.',
        'Link templates to attachments.' => 'Vincular plantillas con archivos adjuntos.',
        'Link templates to queues.' => 'Vincular plantillas con colas de espera.',
        'Link this ticket to other objects' => 'Enlazar este ticket a otro objeto',
        'Links 2 tickets with a "Normal" type link.' => 'Vincular 2 tickets con un vículo de tipo "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Vincular 2 tickets con un vículo de tipo "PadreHijo".',
        'Links appointments and tickets with a "Normal" type link.' => 'Vincular citas y tickets con el tipo de vínculo "Normal".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS que siempre se cargarán para la interfaz del agente.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS que siempre se cargarán para la interfaz del cliente.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista de archivos JS que siempre se cargarán para la interfaz del agente.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista de archivos JS que siempre se cargarán para la interfaz del cliente.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Lista de todos los eventos de CustomerCompany que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Lista de todos los eventos de CustomerUser que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all DynamicField events to be displayed in the GUI.' => 'Lista de todos los eventos de DynamicField que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all LinkObject events to be displayed in the GUI.' => 'Lista de todos los eventos de LinkObject que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all Package events to be displayed in the GUI.' => 'Lista de todo el Paquete de eventos que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all appointment events to be displayed in the GUI.' => 'Lista de todos los eventos de citas que son desplegaos en la GUI.',
        'List of all article events to be displayed in the GUI.' => 'Lista de todos los eventos de artículos que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all calendar events to be displayed in the GUI.' => 'Lista de todos los eventos de calendario que son desplegados en la GUI.',
        'List of all queue events to be displayed in the GUI.' => 'Lista de todos los eventos de la cola que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of all ticket events to be displayed in the GUI.' => 'Lista de todos los eventos de tickets que se mostrarán en la Interfaz gráfica de usuario (GUI).',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            'Lista de colores en hexadecimal RGB que estarán disponibles para su selección durante la creación de calendarios. Asegúrese que los colores sean suficientemente obscuros para que el texto banco se vea correctamente sobre ellos.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Lista de plantillas estándar por defecto que se asignan automáticamente a las nuevas colas en el momento de su creación.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Lista de archivos CSS responsive que deben cargarse siempre para la interfaz del agente.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'Lista de archivos CSS responsive que se cargan siempre para la interfaz del cliente.',
        'List of states for which escalations should be suspended.' => 'Lista de estados para los que se deben suspender el escalado.',
        'List view' => 'Vista de Lista',
        'Lithuanian' => 'Lituano',
        'Loader module registration for the agent interface.' => 'Registro del módulo de carga para la interfaz del agente.',
        'Loader module registration for the customer interface.' => 'Registro del módulo de carga para la interfaz del cliente.',
        'Lock / unlock this ticket' => 'Bloquear/desbloquear este ticket',
        'Locked Tickets' => 'Tickets Bloqueados',
        'Locked Tickets.' => 'Tickets Bloqueados.',
        'Locked ticket.' => 'Ticket bloqueado.',
        'Logged in users.' => 'Usuarios registrados.',
        'Logged-In Users' => 'Usuarios conectados',
        'Logout of customer panel.' => 'Cierre de sesión del panel de clientes.',
        'Look into a ticket!' => '¡Revisar un ticket!',
        'Loop protection: no auto-response sent to "%s".' => 'Protección de bucle: no se ha enviado ninguna respuesta automática a "%s".',
        'Macedonian' => 'Macedonia',
        'Mail Accounts' => 'Cuentas de Correo',
        'MailQueue configuration settings.' => 'Ajustes de configuración de MailQueue.',
        'Main menu for the agent interface.' => 'Menú principal de la interfaz del agente.',
        'Main menu item registration.' => 'Registro del elemento del menú principal.',
        'Main menu registration.' => 'Registro menú principal.',
        'Makes the application block external content loading.' => 'Hace que la aplicación bloquee la carga de contenido externo.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Hace que la aplicación verifique el registro MX de las direcciones de correo electrónico, antes de enviar un correo o crear un ticket, ya sea telefónico o de correo electrónico.',
        'Makes the application check the syntax of email addresses.' => 'Hace que la aplicación verifique la sintaxis de las direcciones de correo electrónico.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Hace que la gestión de sesiones utilice cookies html. Si las cookies html están deshabilitadas o si el explorador del cliente las tiene deshabilitadas, el sistema trabajará normalmente y agregará el identificador de sesión a los vínculos.',
        'Malay' => 'Malayo',
        'Manage OTOBO Team cloud services.' => 'Gestiona los servicios en la nube de OTOBO Team.',
        'Manage PGP keys for email encryption.' => 'Gestionar las llaves PGP para encriptación de correos electrónicos.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Gestionar las cuentas POP3 o IMAP de las que se extraen correos.',
        'Manage S/MIME certificates for email encryption.' => 'Gestionar certificados S/MIME para encriptación de correos electrónicos.',
        'Manage System Configuration Deployments.' => 'Gestionar los despliegues de configuración del sistema.',
        'Manage different calendars.' => 'Gestionar diferentes calendarios.',
        'Manage dynamic field in screens.' => 'Gestionar el campo dinámico en las pantallas.',
        'Manage existing sessions.' => 'Gestionar sesiones existentes.',
        'Manage support data.' => 'Gestionar datos de soporte.',
        'Manage system registration.' => 'Gestionar registro del sistema.',
        'Manage tasks triggered by event or time based execution.' => 'Gestione las tareas de triggers por evento o ejecución basada en el tiempo.',
        'Mark as Spam!' => '¡Marcar como correo no deseado!',
        'Mark this ticket as junk!' => 'Marcar este ticket como basura!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Tamaño máximo (en caracteres) para la tabla de información del cliente (teléfono y correo electrónico) en la ventana de redacción.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Tamaño máximo (en filas) del cuadro de agentes informados en la interfaz de agentes.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Tamaño máximo (en filas) del cuadro de agentes participantes en la interfaz de agentes.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Tamaño máximo de los asuntos en una respuesta de correo electrónico y en algunas pantallas de resumen.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Número máximo de respuestas automáticas (vía correos electrónicos) al día para la dirección de correo electrónico propia (protección de bucle).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            'Máxima cantidad de respuestas automáticas a la propia dirección de correo electrónico al día, configurable por dirección de correo electrónico (Protección de bucle).',
        'Maximal number of results returned by ES per field.' => 'Número máximo de resultados devueltos por ES por campo.',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Tamaño máximo en KBytes para correos que pueden obtenerse vía POP3/POP3S/IMAP/IMAPS.',
        'Maximum Number of a calendar shown in a dropdown.' => 'Número máximo de un calendario mostrado en un desplegable.',
        'Maximum file size for the ingest plugin.' => 'Tamaño máximo del archivo para el plugin de carga.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Longitud máxima (en caracteres) del campo dinámico en el artículo de la vista de zoom del ticket.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Longitud máxima (en caracteres) del campo dinámico en la barra lateral de la vista de zoom del ticket.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            'Numero máximo de calendarios activos en las pantallas de resumen. Por favor note que un numero grande de calendarios activos puede tener un impacto negativo en el desempeño del servidor debido a una gran cantidad de llamadas simultáneas.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Número máximo de tickets para ser mostrados en el resultado de una búsqueda, en la interfaz del agente.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Número máximo de tickets para ser mostrados en el resultado de una búsqueda, en la interfaz del cliente.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Número máximo de entradas que se mostrarán en el resultado de esta operación.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Número máximo (en caracteres) de la tabla de información del cliente en la vista detallada del ticket.',
        'Medium' => 'Mediano',
        'Merge this ticket and all articles into another ticket' => 'Fusionar este ticket y todos los artículos en otro ticket',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'Fusionar Ticket (%s/%s) a (%s/%s).',
        'Merged Ticket <OTOBO_TICKET> to <OTOBO_MERGE_TO_TICKET>.' => 'Fusionar Ticket <OTOBO_TICKET> a <OTOBO_MERGE_TO_TICKET>.',
        'Minute' => 'Minuto',
        'Miscellaneous' => 'Varios',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Módulo para la selección del destinatario en la ventana de ticket nuevo, en la interfaz del cliente.',
        'Module to check if a incoming e-mail message is bounce.' => 'Módulo para comprobar si un mensaje de correo electrónico entrante es rebotado.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            'Módulo para comprobar si los correos electrónicos que llegan deben marcarse como internos (debido al correo interno original reenviado). IsVisibleForCustomer y SenderType definen los valores para el correo electrónico/artículo que llega.',
        'Module to check the group permissions for customer access to tickets.' =>
            'Módulo para comprobar los permisos de grupo para el acceso de los clientes a los tickets.',
        'Module to check the group permissions for the access to tickets.' =>
            'Módulo para comprobar los permisos de grupo para el acceso a los tickets.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Módulo para redactar mensajes firmados (PGP o S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            'Módulo para definir las opciones de seguridad del correo electrónico a utilizar (PGP o S/MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => 'Módulo para cifrar los mensajes compuestos (PGP o S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'Módulo para obtener los certificados SMIME de los mensajes entrantes de los usuarios.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Módulo para filtrar y manipular mensajes entrantes. Bloquea/ignora todos los correos no deseados con direcciones De: noreply@.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Módulo para filtrar y manipular mensajes entrantes. Obtenga un número de 4 dígitos para el texto libre de ticket, use una expresión regular en Match, por ejemplo: From => \'(.+?)@.+?\', y utilice () como [***] en Set =>.',
        'Module to filter encrypted bodies of incoming messages.' => 'Módulo para filtrar los cuerpos de los mensajes entrantes cifrados.',
        'Module to generate accounted time ticket statistics.' => 'Módulo para generar estadísticas de la contabilidad de tiempo de los tickets.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Módulo para generar perfil OpenSearch html para búsqueda simple de tickets en la interfaz del agente.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Módulo para generar perfil OpenSearch html para búsqueda simple de tickets en la interfaz del cliente.',
        'Module to generate ticket solution and response time statistics.' =>
            'Módulo para generar estadísticas del tiempo de solución y respuesta de los tickets.',
        'Module to generate ticket statistics.' => 'Módulo para generar estadísticas de tickets.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            'Módulo para conceder acceso si el CustomerID del cliente tiene los permisos de grupo necesarios.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Módulo para conceder acceso si el CustomerID del ticket coincide con el CustomerID del cliente.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Módulo para conceder acceso si el CustomerUserID del ticket coincide con el CustomerUserID del cliente.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Módulo para conceder acceso a cualquier agente que haya estado involucrado en un ticket en el pasado (basado en las entradas del historial de tickets).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Módulo para dar acceso al agente responsable de un ticket.',
        'Module to grant access to the creator of a ticket.' => 'Módulo para conceder acceso al creador de un ticket.',
        'Module to grant access to the owner of a ticket.' => 'Módulo para conceder acceso al propietario de un ticket.',
        'Module to grant access to the watcher agents of a ticket.' => 'Módulo para dar acceso a los agentes observadores de un ticket.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Módulo para mostrar notificaciones y escaladas (ShownMax: Número máximo de escaladas que se muestran, EscalationInMinutes: Muestra el ticket que escalará en estos minutos, CacheTime: Caché de las escaladas calculadas, en segundos).',
        'Module to use database filter storage.' => 'Módulo para utilizar el almacenamiento de base de datos del filtro.',
        'Module used to detect if attachments are present.' => 'Módulo usado para detectar si hay archivos adjuntos presentes.',
        'My Queues' => 'Mis Colas',
        'My Services' => 'Mis Servicios',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Nombre de fila personalizada, misma que es una selección de sus colas de preferencia y puede elegirse en las configuraciones de sus preferencias.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Nombre del servicio personalizado. El servicio personalizado es una selección de sus servicios preferidos y se puede seleccionar en la configuración de preferencias.',
        'NameX' => 'NombreX',
        'New Tickets' => 'Nuevos tickets',
        'New Window' => 'Nueva Ventana',
        'New Year\'s Day' => 'Año nuevo',
        'New Year\'s Eve' => 'Víspera de año nuevo',
        'New process ticket' => 'Nuevo ticket de Proceso',
        'News about OTOBO releases!' => '¡Noticias sobre lanzamientos de OTOBO!',
        'News about OTOBO.' => 'Noticias sobre OTOBO.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Los siguientes estados posibles del ticket después de añadir una nota telefónica en la pantalla de entrada del teléfono del ticket de la interfaz del agente.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Lista de posibles estados siguientes de ticket, luego de haber añadido una nota telefónica a un ticket, en la ventana de ticket telefónico slaiente de la interfaz del agente.',
        'No public key found.' => 'No se ha encontrado ninguna clave pública.',
        'No valid OpenPGP data found.' => 'No se han encontrado datos válidos de OpenPGP.',
        'None' => 'Ninguno',
        'Norwegian' => 'Noruego',
        'Notification Settings' => 'Configuración de Notificaciones',
        'Notified about response time escalation.' => 'Notificado sobre el aumento del tiempo de respuesta.',
        'Notified about solution time escalation.' => 'Notificado sobre la escalada del tiempo de solución.',
        'Notified about update time escalation.' => 'Notificado sobre la escalada de tiempo de actualización.',
        'Number of displayed tickets' => 'Número de tíckets desplegados',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Número de líneas (por ticket) que se muestran por la utilidad de búsqueda de la interfaz del agente.',
        'Number of shards (NS), replicas (NR) and fields limit for the index \'ticket\'.' =>
            'Número de fragmentos (NS), réplicas (NR) y límite de campos para el índice "ticket".',
        'Number of shards (NS), replicas (NR) and fields limit for the index. Note: \'Elasticsearch::ArticleIndexCreationSettings\' is deprecated. For upwards compatibility use \'Elasticsearch::IndexSettings###Default\' instead.' =>
            'Número de fragmentos (NS), réplicas (NR) y límite de campos para el índice. Nota: Elasticsearch::ArticleIndexCreationSettings\' está obsoleto. Para la compatibilidad hacia arriba, utilice \'Elasticsearch::IndexSettings###Default\' en su lugar.',
        'Number of shards (NS), replicas (NR) and fields limit for the indices. This replaces \'Elasticsearch::ArticleIndexCreationSettings\' in future versions. If both are present and not equal this one has priority. Use \'Elasticsearch::IndexSettings###...\' if you want to define special settings for single indices.\'...\' may be one of \'Customer\', \'CustomerUser\', \'Ticket\' or \'ConfigItem\'.' =>
            'Número de fragmentos (NS), réplicas (NR) y límite de campos para los índices. Esto reemplaza a \'Elasticsearch::ArticleIndexCreationSettings\' en futuras versiones. Si ambos están presentes y no son iguales este tiene prioridad. Utiliza \'Elasticsearch::IndexSettings##...\' si quieres definir ajustes especiales para índices individuales.\'...\' puede ser uno de \'Customer\', \'CustomerUser\', \'Ticket\' o \'ConfigItem\'.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Número de tickets desplegados en cada página del resultado de una búsqueda, en la interfaz del agente.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Número de tickets desplegados en cada página del resultado de una búsqueda, en la interfaz del cliente.',
        'OTOBO News' => 'Novedades de OTOBO',
        'OTOBO Team Services' => 'Servicios del equipo OTOBO',
        'OTOBO can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTOBO puede utilizar una o más bases de datos espejo de sólo lectura para operaciones costosas como la búsqueda de texto completo o la generación de estadísticas. Aquí puede especificar el DSN para la primera base de datos espejo.',
        'OTOBO doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTOBO no soporta Citas recurrentes sin fecha de finalización o número de iteraciones. Durante el proceso de importación, puede ocurrir que el archivo ICS contenga tales Citas. En su lugar, el sistema crea todas las Citas del pasado, más las Citas de los próximos N meses (120 meses/10 años por defecto).',
        'Objects to search for, how many entries and which attributs to show.' =>
            'Objetos a buscar, cuántas entradas y qué atributos mostrar.',
        'Objects to search for, how many entries and which attributs to show. Ticket attributes, except queue, have to explicitely be stored via Elasticsearch.' =>
            'Objetos a buscar, cuántas entradas y qué atributos mostrar. Los atributos de las entradas, excepto la cola, tienen que ser almacenados explícitamente a través de Elasticsearch.',
        'Open an external link!' => '¡Abrir un enlace externo!',
        'Open the OTOBO home page in a new window' => 'Abrir la página de inicio de OTOBO en una nueva ventana',
        'Open tickets (customer user)' => 'Tickets Abiertos (usuario del cliente)',
        'Open tickets (customer)' => 'Tickets Abiertos (Cliente)',
        'Option' => 'Opción',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limitación opcional de colas para el módulo de permisos CreatorCheck. Si se establece, el permiso sólo se concede para los tickets de las colas especificadas.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limitación opcional de colas para el módulo de permisos InvolvedCheck. Si se establece, el permiso sólo se concede para los tickets de las colas especificadas.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limitación opcional de colas para el módulo de permisos OwnerCheck. Si se establece, el permiso sólo se concede para los tickets de las colas especificadas.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Limitación opcional de colas para el módulo de permisos ResponsibleCheck. Si se establece, el permiso sólo se concede para los tickets de las colas especificadas.',
        'Other Customers' => 'Otros clientes',
        'Out Of Office' => 'Fuera de la Oficina',
        'Out Of Office Time' => 'Tiempo de ausencia de la oficina',
        'Out of Office users.' => 'Usuarios fuera de la oficina.',
        'Output filter to inject the necessary Dynamic field names in hidden input.' =>
            'Filtro de salida para inyectar los nombres de campos dinámicos necesarios en la entrada oculta.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Sobrecarga (redefine) funciones existentes en Kernel::System::Ticket. Útil para añadir personalizaciones fácilmente.',
        'Overview Escalated Tickets.' => 'Visión general de los tickets escalados.',
        'Overview Refresh Time' => 'Tiempo de actualización de la vista general',
        'Overview of all Tickets per assigned Queue.' => 'Resúmen de todos los tickets por Cola asignada.',
        'Overview of all appointments.' => 'Resumen de todas las citas.',
        'Overview of all escalated tickets.' => 'Resumen de todos los tickets escalados.',
        'Overview of all open Tickets.' => 'Resumen de todos los Tickets abiertos.',
        'Overview of all open tickets.' => 'Resumen de todos los tickets abiertos.',
        'Overview of customer tickets.' => 'Resumen de los tickets de clientes.',
        'PGP Key' => 'Llave PGP',
        'PGP Key Management' => 'Administración de Llave PGP',
        'PGP Keys' => 'Llaves PGP',
        'Package event module file a scheduler task for update registration.' =>
            'El módulo paquete de eventos archiva una tarea del programador para el registro de actualizaciones.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para el objeto CreateNextMask en la vista de preferencias de la interfaz del agente. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otros usuarios. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para el objeto Cola Personalizada en la vista de preferencias de la interfaz del agente. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para el objeto Servicio Personalizado en la vista de preferencias de la interfaz del agente. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para el objeto Hora de Actualización en la vista de preferencias de la interfaz del agente. Por favor, tenga en cuenta que si define \'Activo\' como 0, sólo evitará que los agentes editen la configuración de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar la configuración de otro usuario. Utiliza \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para los filtros de columna de la vista general del ticket pequeño. Por favor, tenga en cuenta que si establece \'Activo\' en 0, sólo evitará que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel de control de la información de la empresa del cliente de la interfaz del agente. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin.',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el panel de control de la lista de identificación de clientes de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el dashboard backend del widget de estado del id de cliente de la interfaz del agente . "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del dashboard de la información de usuario del cliente de la interfaz del agente. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Parámetros para el backend del panel de control de la lista de usuarios cliente de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del panel de control de la vista general de los nuevos tickets de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes. Nota: Sólo se permiten atributos de tickets y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del panel de control de la vista general de los nuevos tickets de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo los atributos del ticket y los campos dinámicos (DynamicField_NameX) están permitidos para DefaultColumns.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el panel de control de la vista general de tickets abiertos de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes. Nota: Sólo los atributos del ticket y los campos dinámicos (DynamicField_NameX) están permitidos para DefaultColumns.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el panel de control de la vista general de tickets abiertos de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo se permiten atributos de entradas y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parámetros para el backend del panel de control del widget de resumen de colas de la interfaz del agente. "Group" se utiliza para restringir el acceso al plugin (por ejemplo, Group: admin;group1;group2;). "QueuePermissionGroup" no es obligatorio, las colas sólo se listan si pertenecen a este grupo de permisos si lo habilita. "States" es una lista de estados, la clave es el orden de clasificación del estado en el widget. "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parámetros para el backend del tablero de mandos de la vista general de entradas del proceso en curso de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Default" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general del escalado de tickets de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes. Nota: Sólo se permiten atributos de tickets y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general del escalado de tickets de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo se permiten atributos de entradas y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general de la escalada de tickets de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo se permiten atributos de entradas y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parámetros para el backend del tablero del calendario de eventos de tickets de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general del recordatorio de tickets pendientes de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes. Nota: Sólo se permiten atributos de tickets y campos dinámicos (DynamicField_NameX) para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general del recordatorio de tickets pendientes de la interfaz del agente . "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo los atributos del ticket y los campos dinámicos (DynamicField_NameX) están permitidos para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Parámetros para el backend del tablero de mandos de la vista general del recordatorio de tickets pendientes de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. Nota: Sólo los atributos del ticket y los campos dinámicos (DynamicField_NameX) están permitidos para DefaultColumns.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parámetros para el backend del panel de control de las estadísticas de los tickets de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Parámetros para el backend del panel de control del widget de próximos eventos de la interfaz del agente. "Límite" es el número de entradas que se muestran por defecto. "Grupo" se utiliza para restringir el acceso al plugin (por ejemplo, Grupo: admin;group1;group2;). "Por defecto" determina si el plugin está habilitado por defecto o si el usuario tiene que habilitarlo manualmente. "CacheTTLLocal" es el tiempo de caché en minutos para el plugin. "Obligatorio" determina si el plugin se muestra siempre y no puede ser eliminado por los agentes.',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            'Parámetros para las páginas (en las que se muestran las entradas del registro de comunicación) del resumen del registro de comunicación.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para las páginas (en las que se muestran los campos dinámicos) del resumen de campos dinámicos. Por favor, tenga en cuenta que si establece \'Activo\' en 0, sólo evitará que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) de la vista general de tickets del medio. Por favor, tenga en cuenta que si establece \'Activo\' a 0 sólo impedirá que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) del resumen de tickets pequeños. Por favor, tenga en cuenta que si establece \'Activo\' a 0 sólo impedirá que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario en su nombre. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Parámetros para las páginas (en las que se muestran los tickets) de la vista previa del ticket. Por favor, tenga en cuenta que si establece \'Activo\' a 0 sólo impedirá que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario en su nombre. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Parameters of the example SLA attribute Comment2.' => 'Parámetros del ejemplo del atributo de SLA, Comment2.',
        'Parameters of the example queue attribute Comment2.' => 'Parámetros del ejemplo del atributo de fila, Comment2.',
        'Parameters of the example service attribute Comment2.' => 'Parámetros del ejemplo del atributo de servicio, Comment2.',
        'Parent' => 'Padre',
        'ParentChild' => 'PadreHijo',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Ruta para el archivo log (aplica únicamente si "FS" se eligió como LoopProtectionModule y si es obligatorio).',
        'Pending time' => 'Tiempo de espera',
        'People' => 'Personas',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            'Realiza la acción configurada para cada evento (como Invocador) para cada servicio web configurado.',
        'Permitted width for compose email windows.' => 'Anchura permitida para las ventanas de redacción de correos electrónicos.',
        'Permitted width for compose note windows.' => 'Anchura permitida para las ventanas de redacción de notas.',
        'Persian' => 'Persa',
        'Phone Call Inbound' => 'Llamada Telefónica Entrante',
        'Phone Call Outbound' => 'Llamada telefónica saliente',
        'Phone Call.' => 'Llamada telefónica.',
        'Phone call' => 'Llamada telefónica',
        'Phone communication channel.' => 'Canal de comunicación telefónica.',
        'Phone-Ticket' => 'Ticket Telefónico',
        'Picture Upload' => 'Cargar imagen',
        'Picture upload module.' => 'Módulo de carga de imágenes.',
        'Picture-Upload' => 'Cargar Imagen',
        'Please click the button below to create your first ticket.' => 'Por favor haga click en el botón inferior para crear su primer ticket.',
        'Plugin search' => 'Búsqueda de plug-ins',
        'Plugin search module for autocomplete.' => 'Módulo Plug-in de búsqueda para auto-completar.',
        'Polish' => 'Polaco',
        'Portuguese' => 'Portugués',
        'Portuguese (Brasil)' => 'Portugués (Brasil)',
        'PostMaster Filters' => 'Filtros del Administrador de Correos',
        'PostMaster Mail Accounts' => 'Cuentas del Administrador de Correos',
        'Print this ticket' => 'Imprimir este ticket',
        'Priorities' => 'Prioridades',
        'Process Management Activity Dialog GUI' => 'Diálogo Interfaz gráfica de usuario (GUI) de actividades de gestión de procesos',
        'Process Management Activity GUI' => 'Interfaz gráfica de usuario (GUI) Actividad de gestión de procesos',
        'Process Management Path GUI' => 'Interfaz gráfica de usuario (GUI) Ruta de la gestión de procesos',
        'Process Management Transition Action GUI' => 'Interfaz gráfica de usuario (GUI) Acción de transición de la gestión de procesos',
        'Process Management Transition GUI' => 'Interfaz gráfica de usuario (GUI) Transición de la gestión de procesos',
        'Process Ticket.' => 'Procesar ticket.',
        'Process pending tickets.' => 'Tickets pendientes de procesar.',
        'ProcessID' => 'ProcessID',
        'Processes & Automation' => 'Procesos y Automatización',
        'Product News' => 'Noticias de Productos',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Protección contra exploits CSRF (Cross Site Request Forgery) (para más información consulte https://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Protection against brute force attacks. MaxAttempt: How many login attempts are allowed before a ban. BanDuration: Duration of the ban. KeepCacheDuration: How long failed attempts are remembered.' =>
            'Protección contra ataques de fuerza bruta. MaxAttempt: Cuántos intentos de inicio de sesión se permiten antes de una prohibición. BanDuration: Duración del baneo. KeepCacheDuration: Cuánto tiempo se recuerdan los intentos fallidos.',
        'Provides a matrix overview of the tickets per state per queue' =>
            'Proporciona una matriz resumen de los tickets por estado y por cola',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            'Proporciona a los usuarios cliente acceso a los tickets incluso si los tickets no están asignados a un usuario del mismo ID de cliente, basándose en los grupos de permisos.',
        'Public Calendar' => 'Calendario Púplico',
        'Public calendar.' => 'Calendario público.',
        'Queue view' => 'Vista de Filas',
        'Queues ↔ Auto Responses' => 'Colas ↔ Respuestas Automáticas',
        'Quick Close' => 'Cierre rápido',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Reconstruye el índice de tickets para AgentTicketQueue.',
        'Rebuilds Elasticsearch indices. Can be used for example, if CustomerUsers are authenticated via ldap. Highly inefficient however, as the whole index is rebuild every time.' =>
            'Reconstruye los índices de Elasticsearch. Se puede utilizar, por ejemplo, si CustomerUsers se autentifica a través de ldap. Sin embargo, es muy ineficiente, ya que todo el índice se reconstruye cada vez.',
        'Rebuilds the ACL preselection cache.' => 'Reconstruye el caché de preselección ACL.',
        'Rebuilds the escalation index.' => 'Reconstruye el índice de escalación.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            'Reconoce si un ticket es un seguimiento de un ticket existente utilizando un número de ticket externo. Nota: el primer grupo de captura de la expresión \'NumberRegExp\' se utilizará como valor del número de ticket.',
        'Redis server address. Example: 127.0.0.1:6379.' => 'Dirección del servidor de Redis. Ejemplo: 127.0.0.1:6379.',
        'Refresh interval' => 'Intervalo de actualización',
        'Registers a log module, that can be used to log communication related information.' =>
            'Registra un módulo de registro, que puede ser utilizado para registrar información relacionada con la comunicación.',
        'Reminder Tickets' => 'Tickets de recordatorios',
        'Removed subscription for user "%s".' => 'Eliminada subscripción para el usuario "%s".',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            'Elimina las entradas antiguas del registro de depuración de la interfaz genérica creadas antes de la cantidad de días especificada.',
        'Removes old system configuration deployments (Sunday mornings).' =>
            'Elimina los antiguos despliegues de configuración del sistema (los domingos por la mañana).',
        'Removes old ticket number counters (each 10 minutes).' => 'Elimina los antiguos contadores de números de tickets (cada 10 minutos).',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Elimina la información del observador de tickets cuando se archiva un ticket.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            'Renovar los certificados SMIME existentes desde el backend del cliente. Nota: SMIME y SMIME::FetchFromCustomer deben estar habilitados en SysConfig y el backend del cliente debe estar configurado para obtener el atributo UserSMIMECertificate.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Reemplaza el destinatario original con la dirección de correo electrónico del cliente actual, al redactar una respuesta en la ventana de redacción de tickets de la interfaz del agente.',
        'Reports' => 'Reportes',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Reprocesar los correos del directorio de spool que no pudieron ser importados en primer lugar.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Permisos necesarios para cambiar el cliente de un ticket, en la interfaz del agente.',
        'Required permissions to use quick close in the agent interface.' =>
            'Permisos necesarios para utilizar el cierre rápido en la interfaz del agente.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para cerrar tickets, en la interfaz del agente.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Permisos necesarios para utilizar la pantalla de salida de correo electrónico en la interfaz del agente.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            'Permisos necesarios para utilizar la pantalla de reenvío de correo electrónico en la interfaz del agente.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para rebotar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para redactar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para reenviar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Permisos necesarios usar la ventana de campos libres de texto de ticket, en la interfaz del agente.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para mezclar tickets, en la interfaz del agente.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para añadir notas a los tickets, en la interfaz del agente.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el propietario de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para definir un ticket como pendiente, en la vista detallada de dicho ticket de la interfaz del agente.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Permisos necesarios para utilizar la pantalla de entrada del teléfono de tickets en la interfaz del agente.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Permisos necesarios usar la ventana de ticket telefónico saliente, en la interfaz del agente.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar la prioridad de un ticket, en la interfaz del agente.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Permisos necesarios usar la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Resend Ticket Email.' => 'Reenvío del ticket por correo electrónico.',
        'Resent email to "%s".' => 'Reenviar correo electrónico a "%s".',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Reinicializa y desbloquea al propietario de un ticket, si este último se mueve a otra fila.',
        'Responsible Tickets' => 'Tickets responsables',
        'Responsible Tickets.' => 'Tickets responsables.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'Restaura un ticket desde el archivo (sólo si el evento es un cambio de estado a cualquier estado abierto disponible ).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Conserva todos los servicios en los listados aunque sean hijos de elementos no válidos.',
        'Right' => 'Derecha',
        'Roles ↔ Groups' => 'Roles ↔ Grupos',
        'Romanian' => 'Rumano',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Ejecutar trabajos de agentes genéricos basados en archivos (Nota: el nombre del módulo debe especificarse en el parámetro -configuration-module, por ejemplo, "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Procesos de Tickets en Ejecución',
        'Runs an initial wildcard search of the existing contacts with data when accessing the AdminContactWD module.' =>
            'Ejecuta una búsqueda inicial con comodines de los contactos existentes con datos al acceder al módulo AdminContactWD.',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Ejecuta una búsqueda inicial con comodines de la empresa cliente existente al acceder al módulo AdminCustomerCompany.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Ejecuta una búsqueda inicial con comodines de los usuarios clientes existentes al acceder al módulo AdminCustomerUser.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Ejecuta el sistema en modo "Demo". Si está activado, los agentes pueden cambiar las preferencias, como la selección del idioma y el tema a través de la interfaz web del agente. Estos cambios sólo son válidos para la sesión actual. Los agentes no podrán cambiar sus contraseñas.',
        'Russian' => 'Ruso',
        'S/MIME Certificates' => 'Certificados S/MIME',
        'Salutations' => 'Saludos',
        'Sample command output' => 'Resultado de ejemplo del comando',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTOBO user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Guarda los archivos adjuntos de los artículos. "DB" almacena todos los datos en la base de datos (no se recomienda para almacenar archivos adjuntos grandes). "FS" almacena los datos en el sistema de archivos; esto es más rápido, pero el servidor web debe ejecutarse bajo el usuario OTOBO. Puede alternar entre los módulos incluso en un sistema que ya está en producción sin ninguna pérdida de datos. Nota: la búsqueda de nombres de archivos adjuntos no se admite cuando se utiliza "FS".',
        'Schedule a maintenance period.' => 'Programe un periodo de mantenimiento.',
        'Screen after new ticket' => 'Pantalla posterior a nuevo ticket',
        'Search Customer' => 'Búsqueda de cliente',
        'Search Ticket.' => 'Buscar ticket.',
        'Search Tickets.' => 'Buscar tickets.',
        'Search User' => 'Buscar Usuario',
        'Search backend default router.' => 'Buscar el router por defecto del backend.',
        'Search backend router.' => 'Buscar el router del backend.',
        'Search.' => 'Buscar.',
        'Second Christmas Day' => 'Segundo día de navidad',
        'Second Queue' => 'Segunda Fila de Espera',
        'Select after which period ticket overviews should refresh automatically.' =>
            'Seleccione después de que periodo las vistas generales de tickets deberán actualizarse automáticamente.',
        'Select how many tickets should be shown in overviews by default.' =>
            'Seleccione cuántos tickets deben mostrarse en las vistas generales de forma predeterminada.',
        'Select the main interface language.' => 'Seleccione el idioma de la interfaz principal.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Seleccione el caracter de separación para los archivos CSV (estadísticas y búsquedas). En caso de que no lo seleccione, se usará el separador por defecto para su idioma.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            'Seleccione su zona horaria personal. Todas las horas se mostrarán en relación con esta zona horaria.',
        'Select your preferred layout for the software.' => 'Seleccione su diseño preferido para el software.',
        'Select your preferred theme for OTOBO.' => 'Seleccione su tema preferido para OTOBO.',
        'Selects the cache backend to use.' => 'Selecciona el caché del backend a utilizar.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Selecciona el módulo para manejar las cargas de archivos en la interfaz web. "DB" almacena todos en la base de datos, mientras que "FS" usa el sistema de archivos.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            'Selecciona el módulo generador de números de ticket. "Autoincremento" incrementa el número de ticket, el SystemID y el contador se utilizan con el formato SystemID.counter (por ejemplo, 1010138, 1010139). Con "Fecha" los números de ticket serán generados por la fecha actual, el SystemID y el contador. El formato es como Año.Mes.Día.SystemID.counter (por ejemplo, 200206231010138, 200206231010139). Con "DateChecksum" el contador se añadirá como suma de comprobación a la cadena de fecha y SystemID. La suma de comprobación se rotará diariamente. El formato es el siguiente: Año.Mes.Día.SystemID.Contador.Suma de comprobación (por ejemplo, 2002070110101520, 2002070110101535).',
        'Send new outgoing mail from this ticket' => 'Enviar nuevo correo saliente desde este ticket',
        'Send notifications to users.' => 'Enviar notificaciones a usuarios.',
        'Sender type for new tickets from the customer inteface.' => 'Tipo de destinatario para tickets nuevos, creados en la interfaz del cliente.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Enviar notificaciones de seguimiento únicamente al agente propietario, si el ticket se desbloquea (por defecto se envían notificaciones a todos los agentes).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Envía todos los correos electrónicos salientes vía bcc a la dirección especificada. Por favor, utilice esta opción únicamente por motivos de copia de seguridad).',
        'Sends customer notifications just to the mapped customer.' => 'Envía notificaciones cliente sólo al cliente mapeado.',
        'Sends registration information to OTOBO group.' => 'Enviar información de registro a Grupo OTOBO.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Envía notificaciones de recordatorio de tickets desbloqueados a sus propietarios, luego que alcanzaron la fecha de recordatorio.',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Envía las notificaciones configuradas en la interfaz de administración en "Notificaciones de ticket".',
        'Sent "%s" notification to "%s" via "%s".' => 'Enviada la notificación "%s" a "%s" a través de "%s".',
        'Sent auto follow-up to "%s".' => 'Enviado seguimiento automático a "%s".',
        'Sent auto reject to "%s".' => 'Enviado rechazo automático a "%s".',
        'Sent auto reply to "%s".' => 'Enviando respuesta automática a "%s".',
        'Sent email to "%s".' => 'Enviado correo electrónico a "%s".',
        'Sent email to customer.' => 'Envié un correo electrónico al cliente.',
        'Sent notification to "%s".' => 'Enviada la notificación a "%s".',
        'Serbian Cyrillic' => 'Servio Cirílico',
        'Serbian Latin' => 'Servio Latino',
        'Service Level Agreements' => 'Acuerdos de Nivel de Servicio',
        'Service view' => 'Vista del Servicio',
        'ServiceView' => 'Vista de servicio',
        'Set a new password by filling in your current password and a new one.' =>
            'Establezca una nueva contraseña introduciendo su contraseña actual y una nueva.',
        'Set sender email addresses for this system.' => 'Define la dirección de correo electrónico remitente del sistema.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura por defecto (en pixeles) de artículos HTML en línea en la vista detallada del ticket de la interfaz del agente.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Establezca el límite de tickets que se ejecutarán en una sola ejecución de trabajo genericagent.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Define la altura máxima (en pixeles) de artículos HTML en línea en la vista detallada del ticket de la interfaz del agente.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            'Establezca el nivel mínimo de registro. Si selecciona \'error\', sólo se registran los errores. Con \'debug\' se obtienen todos los mensajes de registro. El orden de los niveles de registro es: \'debug\', \'info\', \'notice\' y \'error\'.',
        'Set this ticket to pending' => 'Marcar este ticket como pendiente',
        'Sets if SLA must be selected by the agent.' => 'Establece si el SLA debe ser seleccionado por el agente.',
        'Sets if SLA must be selected by the customer.' => 'Establece si el SLA debe ser seleccionado por el cliente.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Establece si la nota debe ser llenada por el agente. Puede ser sobrescrito por Ticket::Frontend::NeedAccountedTime.',
        'Sets if queue must be selected by the agent.' => 'Establece si la cola debe ser seleccionada por el agente.',
        'Sets if service must be selected by the agent.' => 'Establece si el servicio debe ser seleccionado por el agente.',
        'Sets if service must be selected by the customer.' => 'Establece si el servicio debe ser seleccionado por el cliente.',
        'Sets if state must be selected by the agent.' => 'Establece si el estado debe ser seleccionado por el agente.',
        'Sets if ticket owner must be selected by the agent.' => 'Define si el propietario del ticket tiene que ser seleccionado por el agente.',
        'Sets if ticket responsible must be selected by the agent.' => 'Establece si el responsable del ticket debe ser seleccionado por el agente.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Fija el tiempo pendiente de un ticket a 0, si el estado se cambia a uno no pendiente.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (primer nivel) para resaltar colas que contienen tickets sin tocar.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Fija la edad en minutos (segundo nivel) para resaltar colas que contienen tickets sin tocar.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Fija el nivel de configuración del administrador. Dependiendo del nivel de configuración, algunas configuraciones del sistema no se mostrarán. Los niveles están en orden ascendente: Experto, Avanzado, Principiante. Entre más alto sea el nivel de configuración (por ejemplo: Beginner es el más alto), es menos probable que el usuario pueda configurar accidentalemente el sistema de una forma que quede inutilizable.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Establece el número de artículos visibles en el modo de vista previa de los resúmenes de los tickets.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            'Establece la visibilidad del artículo del cliente por defecto para los nuevos tickets de correo electrónico en la interfaz del agente.',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            'Establece la visibilidad artículo del cliente por defecto para los nuevos tickets telefónicos en la interfaz del agente.',
        'Sets the default article customer visibility for quick close action in the agent interface.' =>
            'Establece la visibilidad del cliente del artículo por defecto para la acción de cierre rápido en la interfaz del agente.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el contenido por defecto del cuerpo de las notas que se añaden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Establece el mensaje de error por defecto para la pantalla de inicio de sesión en la interfaz de Agente y Cliente, se muestra cuando está activo un periodo de mantenimiento del sistema.',
        'Sets the default link type of split tickets in the agent interface.' =>
            'Establece el tipo de enlace por defecto de los tickets divididos en la interfaz del agente.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Define el tipo de vínculo por defecto de tickets divididos, en la interfaz del agente.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Establece el mensaje por defecto para la pantalla de inicio de sesión en la interfaz de Agente y Cliente, se muestra cuando está activo un periodo de mantenimiento del sistema.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Establece el mensaje por defecto para la notificación se muestra en un período de mantenimiento del sistema en ejecución.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Define el estado siguiente por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de las notas para tickets telefónicos nuevos, en la interfaz del agente. Por ejemplo: \'Ticket nuevo vía llamada\'.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Define la prioridad por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Define el tipo de remitente por defecto para tickets telefónicos nuevos, en la interfaz del agente.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Define el asunto por defecto para tickets de correo electrónico nuevos, en la interfaz del agente. Por ejemplo: \'Correo electrónico saliente\'.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Define el asunto por defecto para tickets telefónicos nuevos, en la interfaz del agente. Por ejemplo: \'Llamada telefónica\'.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cerrar tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para mover tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para agregar notas a los tickets, en la interfaz del agente.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el asunto por defecto del cuerpo de las notas que se añaden en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Define el asunto por defecto del cuerpo de las notas que se añaden en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Define el contenido por defecto del cuerpo de los tickets de correo electrónico nuevos, en la interfaz del agente.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'Establece el tiempo de inactividad (en segundos) que debe transcurrir antes de que se elimine una sesión y se cierre la sesión del usuario.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'Establece el número máximo de agentes activos dentro del periodo de tiempo definido en SessionMaxIdleTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'Establece el número máximo de clientes activos dentro del periodo de tiempo definido en SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'Establece el número máximo de sesiones activas por agente dentro del intervalo de tiempo definido en SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'Establece el número máximo de sesiones activas por cliente dentro del periodo de tiempo definido en SessionMaxIdleTime.',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            'Establece el método que utilizará PGP para cantar y cifrar los correos electrónicos. Nota El método Inline no es compatible con los mensajes RichText.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Establece el tamaño mínimo del contador de tickets si se ha seleccionado "AutoIncrement" como TicketNumberGenerator. El valor predeterminado es 5, lo que significa que el contador comienza a partir de 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Establece los minutos en que se muestra una notificación para avisar del próximo periodo de mantenimiento del sistema.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Define el número de líneas mostradas en los mensajes de texto (por ejemplo: renglones de ticket en la vista detallada de las filas).',
        'Sets the options for PGP binary.' => 'Define las opciones para PGP binario.',
        'Sets the password for private PGP key.' => 'Define la contraseña para la llave PGP privada.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Define las unidades de tiempo preferidas (por ejemplo: unidades laborales, horas, minutos).',
        'Sets the preferred digest to be used for PGP binary.' => 'Establece el resumen preferido que se utilizará para el binario PGP.',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTOBO_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Define el prefijo para la carpeta que contiene los scripts en el servidor, tal y como se configuró en el servidor web. Esta configuración se usa como una variable (OTOBO_CONFIG_ScriptAlias) y está presente en todas las formas de mensajes que maneja la aplicación, con la finalidad de crear vínculos a los tickets dentro del sistema.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla de cierre de tickets de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla de texto libre de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla de notas de ticket de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla del propietario del ticket de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla de tickets pendientes de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla de prioridad de tickets de un ticket ampliado en la interfaz del agente.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Establece la cola en la pantalla responsable del ticket de un ticket ampliado en la interfaz del agente.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Define el agente responsable de un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla de cierre de tickets de la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla de texto libre del ticket de la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla de notas del ticket de la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla del propietario del ticket de un ticket ampliado en la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla de tickets pendientes de un ticket ampliado en la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla de prioridad del ticket de un ticket ampliado en la interfaz del agente (Ticket::Service debe estar activado).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Establece el servicio en la pantalla responsable del ticket de la interfaz del agente (Ticket::Service debe estar habilitado).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Establece el estado de un ticket en la pantalla de cierre de tickets de la interfaz del agente.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Establece el estado de un ticket en la pantalla de volumen de tickets de la interfaz del agente.',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Establece el estado de un ticket en la pantalla de texto libre del ticket de la interfaz del agente.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Establece el estado de un ticket en la pantalla de notas del ticket de la interfaz del agente.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Establece el estado de un ticket en la pantalla de responsables de tickets de la interfaz del agente.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Establece el estado del ticket en la pantalla del propietario de un ticket ampliado en la interfaz del agente.',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Establece el estado del ticket en la pantalla de tickets pendientes de un ticket ampliado en la interfaz del agente.',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Establece el estado del ticket en la pantalla de prioridad de un ticket ampliado en la interfaz del agente.',
        'Sets the stats hook.' => 'Define el candado para las estadísticas.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Define el agente propietario de un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de cierre de tickets de la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Establece el tipo de ticket en la pantalla de volumen de tickets de la interfaz del agente.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de texto libre del ticket de la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de notas de ticket de la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla del propietario de un ticket ampliado en la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de tickets pendientes de un ticket ampliado en la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de prioridad de un ticket ampliado en la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Establece el tipo de ticket en la pantalla de responsables de tickets de la interfaz del agente (Ticket::Type debe estar activado).',
        'Sets the time zone being used internally by OTOBO to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            'Establece la zona horaria utilizada internamente por OTOBO para, por ejemplo, almacenar fechas y horas en la base de datos. ADVERTENCIA: Esta configuración no debe cambiarse una vez que se haya establecido y se hayan creado tickets o cualquier otro dato que contenga fecha/hora.',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTOBO time zone and the user\'s time zone.' =>
            'Establece la zona horaria que se asignará a los usuarios recién creados y se utilizará para los usuarios que aún no han establecido una zona horaria. Esta es la zona horaria que se utiliza por defecto para convertir la fecha y la hora entre la zona horaria de OTOBO y la zona horaria del usuario.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Define el tiempo de espera (en segundos) para descargas http/ftp.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Define el tiempo de espera (en segundos) para descargas de paquetes.',
        'Settings for the customer login screen.' => 'Configuración de la pantalla de inicio de sesión del cliente.',
        'Shared Secret' => 'Clave secreta compartida',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Muestra una selección del agente responsable, en los tickets telefónico y de correo electrónico de la interfaz del agente.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Mostrar el artículo como texto enriquecido incluso si la escritura de texto enriquecido está desactivada.',
        'Show command line output.' => 'Mostrar la salida de la línea de comandos.',
        'Show queues even when only locked tickets are in.' => 'Mostrar colas incluso cuando sólo hay entradas bloqueadas.',
        'Show the current owner in the customer interface.' => 'Mostrar el propietario actual en la interfaz del cliente.',
        'Show the current queue in the customer interface.' => 'Muestra la cola actual en la interfaz del cliente.',
        'Show the history for this ticket' => 'Mostrar el historial de este ticket',
        'Show the ticket history' => 'Mostrar el historial del ticket',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            'Muestra un recuento de los archivos adjuntos en el zoom del ticket, si el artículo tiene archivos adjuntos.',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un vínculo en el menú para crear una cita de calendario vinculada al ticket directo desde la vista de detalle de ticket de la interface del agente. Adicionalmente se puede hacer in control de acceso para mostrar o no este vínculo usando la Clave "Group" y el Contenido como "rw:group1;move_into:group2". Para agrupar elemento del menú use la Clave "ClusterName" para el Contenido cualquier nombre que desee ver en la interface del usuario. Utilize "ClusterPriority" para configurar el orden de un cierto grupo dentro de la barra de herramientas.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para suscribirse/desuscribirse de un ticket en la vista de zoom del ticket de la interfaz del agente. El control de acceso adicional para mostrar o no este enlace puede hacerse utilizando la Clave "Grupo" y el Contenido como "rw:grupo1;move_into:grupo2". Para agrupar los elementos del menú utilice para la clave "ClusterName" y para el contenido cualquier nombre que quiera ver en la UI. Utilice "ClusterPriority" para configurar el orden de un determinado cluster dentro de la barra de herramientas.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú que permite vincular un ticket con otro objeto en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú que permite fusionar tickets en la vista de zoom de tickets de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para acceder al historial de un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para agregar un campo de texto libre en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para agregar una nota en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite añadir una nota a un ticket, en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para agregar una llamada telefónica entrante en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para agregar una llamada telefónica saliente en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para cambiar el cliente que solicitó el ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para cambiar el propietario de un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para cambiar el agente responsable de un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite cerrar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para cerrar un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un vínculo en el menú, que permite eliminar un ticket en todas y cada una de las vistas de resumen de la interfaz del agente. Puede proporcionarse control de acceso adicional para mostrar u ocultar este vínculo, al usar Key = "Group" y Content algo parecido a "rw:grupo1;move_into:grupo2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para eliminar un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'Muestra un enlace en el menú para inscribir un ticket en un proceso en la vista de zoom del ticket de la interfaz del agente.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para volver a la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite bloquear / desbloquear un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para bloquear / desbloquear tickets en la vista de zoom de tickets de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite mover un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para imprimir un ticket o un artículo en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to quick close a ticket in every ticket overview of the agent interface.' =>
            'Muestra un enlace en el menú para cerrar rápidamente un ticket en cada descripción general de ticket de la interfaz del agente.',
        'Shows a link in the menu to quick close a ticket in the ticket zoom view of the agent interface.' =>
            'Muestra un enlace en el menú para cerrar rápidamente un ticket en la vista de zoom del ticket de la interfaz del agente.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite acceder a la historia de dicho ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para ver la prioridad de un ticket en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para enviar un correo electrónico saliente en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un enlace en el menú para configurar un ticket como basura en cada descripción general de ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace en el menú para establecer un ticket como pendiente en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite modificar la prioridad de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Muestra un vínculo en el menú, que permite acceder a la vista detallada de un ticket en todas y cada una de las vistas de resumen de la interfaz del agente.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Muestra un vínculo para acceder a los archivos adjuntos de un artículo a través de un visualizador html en línea, en la vista detallada de dicho artículo de la interfaz del agente.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Muestra un vínculo para descargar los archivos adjuntos de un artículo, en la vista detallada de dicho artículo de la interfaz del agente.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Muestra un vínculo para visualizar un ticket de correo electrónico en texto plano, en la vista detallada de dicho ticket.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Muestra un enlace para configurar un ticket como basura en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2". Para agrupar elementos del menú, utilice para la clave "ClusterName" y para el contenido cualquier nombre que desee ver en la interfaz de usuario. Utilice "ClusterPriority" para configurar el orden de un determinado clúster dentro de la barra de herramientas.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cerrar dicho ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Muestra una lista de todos los agentes involucrados en un ticket, en la ventana para cambiar el responsable de un ticket, en la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Muestra una lista de todos los agentes posibles (quienes tienen permiso para añadir notas en la fila/ticket), para determinar quién debe ser informado acerca de esta nota, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Muestra una vista previa de la vista de resumen de los tickets (CustomerInfo => 1 - muestra también la información del cliente y CustomerInfoMaxSize define el tamaño máximo, en caracteres, de dicha información).',
        'Shows all both ro and rw queues in the queue view.' => 'Muestra todas las colas ro y rw en la vista de colas.',
        'Shows all both ro and rw tickets in the service view.' => 'Muestra todos los tickets ro y rw en la vista de servicio.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            'Muestra todos los artículos del ticket (expandido) en la vista de zoom del agente.',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            'Muestra todos los artículos del ticket (expandido) en la vista de zoom del cliente.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Muestra todos los identificadores de clientes en un campo de selección múltiple (no es útil si existen muchos identificadores).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            'Muestra todos los identificadores de usuario cliente en un campo de selección múltiple (no es útil si tiene muchos identificadores de usuario cliente).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Muestra una selección de propietario en los tickets telefónico y de correo electrónico de la interfaz del agente.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Muestra tickets del historial del cliente en los tickets telefónico y de correo electrónico, en la interfaz del agente; y en la ventana para añadir un ticket, en la interfaz del cliente.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Muestra el asunto del último artículo añadido por el cliente o el título del ticket, en el formato pequeño de la vista de resumen.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Muestra las filas padre/hijo existentes en el sistema, ya sea en forma de árbol o de lista.',
        'Shows information on how to start OTOBO Daemon' => 'Muestra información sobre cómo iniciar OTOBO Demonio',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Muestra un enlace a una página externa en la vista de zoom del ticket de la interfaz del agente. Se puede realizar un control de acceso adicional para mostrar o no mostrar este enlace utilizando la tecla "Grupo" y Contenido como "rw: group1; move_into: group2".',
        'Shows the article head information in the agent zoom view.' => 'Muestra la información del encabezado del artículo en la vista de zoom del agente.',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Muestra los artículos ordenados normalmente o de forma inversa, en la vista detallada de un ticket, en la interfaz del agente.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Muestra la información del cliente (número telefónico y cuenta de correo electrónico) en la ventana de redacción de artículos.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Muestra los atributos de ticket habilitados en la interfaz del cliente (0 = Deshabilitado y 1 = Habilitado).',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Muestra el mensaje del día (MOTD) en el panel del agente. "Grupo" se utiliza para restringir el acceso al complemento (p. Ej. Grupo: admin; grupo1; grupo2;). "Predeterminado" indica si el complemento está habilitado de forma predeterminada o si el usuario necesita habilitarlo manualmente. "Obligatorio" determina si el complemento siempre se muestra y los agentes no pueden eliminarlo.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Muestra el mensaje del día en la ventana de inicio de sesión de la interfaz del agente.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Muestra la historia del ticket (ordenada inversamente) en la interfaz del agente.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cerrar un ticket de la interfaz del agente.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para mover tickets, en la interfaz del agente.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana de acción múltiple sobre tickets de la interfaz del agente.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana de campos libres de ticket de la interfaz del agente.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para agregar una nota al ticket de la interfaz del agente.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar el propietario de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para definir un ticket como pendiente, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar la prioridad de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Muestra las opciones de prioridad del ticket, en la ventana para cambiar el responsable de un ticket, en su vista detallada de la interfaz del agente.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            'Muestra el campo de título en la pantalla de cierre de ticket de la interfaz del agente.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'Muestra el campo de título en la pantalla de texto libre de tickets de la interfaz del agente.',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            'Muestra el campo de título en la pantalla de notas de ticket de la interfaz del agente.',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Muestra el campo de título en la pantalla del propietario del ticket de un ticket ampliado en la interfaz del agente.',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Muestra el campo de título en la pantalla de ticket pendiente de un ticket ampliado en la interfaz del agente.',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Muestra el campo de título en la pantalla de prioridad del ticket de un ticket ampliado en la interfaz del agente.',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            'Muestra el campo de título en la pantalla responsable del ticket de la interfaz del agente.',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            'Muestra la hora en formato largo (días, horas, minutos), si está habilitado; o en formato corto (días, horas), si no está habilitado.',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            'Muestra una descripción completa del uso del tiempo (días, horas, minutos), si está habilitado; o simplemente la primera letra (d, h, m), si no está habilitado.',
        'Signature data.' => 'Datos de firma.',
        'Signatures' => 'Firmas',
        'Simple' => 'Sencillo',
        'Skin' => 'interfaz',
        'Slovak' => 'Eslovaco',
        'Slovenian' => 'Esloveno',
        'Small' => 'Pequeño',
        'Software Package Manager.' => 'Administrador de paquetes de software.',
        'Solution time' => 'Tiempo de Solución',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => '¡Alguna descripción!',
        'Some picture description!' => '¡Alguna descripción de la imagen!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Ordena los tickets (ascendente o descendentemente), luego de haberse ordenado por prioridad, cuando una sola fila se selecciona en la vista de filas. Values: 0 = ascendente (por defecto, más antiguo arriba), 1 = descendente (más reciente arriba). Use el identificador de la fila como Llave y 0 ó 1 como Valor.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Ordena los tickets (de forma ascendente o descendente) cuando se selecciona una sola cola en la vista de servicio y después de que los tickets se clasifiquen por prioridad. Valores: 0 = ascendente (el más antiguo arriba, predeterminado), 1 = descendente (el más joven arriba). Utilice ServiceID para la clave y 0 o 1 para el valor.',
        'Spam' => 'Correo no deseado',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Ejemplo de configuración del eliminador de correo basura. Ignora los correos electrónicos que están marcados con SpamAssasin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Ejemplo de configuración del eliminador de correo basura. Mueve los correos marcados a la fila basura.',
        'Spanish' => 'Español',
        'Spanish (Colombia)' => 'Español (Colombia)',
        'Spanish (Mexico)' => 'Español (México)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'Palabras de parada en español para el índice de texto completo. Estas palabras se eliminarán del índice de búsqueda.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Especifica si un agente debe recibir notificaciones en su correo electrónico, acerca de sus propias acciones.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            'Especifica el directorio en el que se almacenan los datos, si se ha seleccionado "FS" para ArticleStorage.',
        'Specifies the directory where SSL certificates are stored.' => 'Especifica el directorio donde se guardan los certificados SSL.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Especifica el directorio donde se guardan los certificados privados SSL.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com). You can use the OTOBO_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Especifica la dirección de correo electrónico que debe utilizar la aplicación al enviar notificaciones. La dirección de correo electrónico se utiliza para crear el nombre de visualización completo para el maestro de notificaciones (es decir, "Notificaciones OTOBO" otobo@your.example.com). Puede usar la variable OTOBO_CONFIG_FQDN según lo establecido en su configuración, o elegir otra dirección de correo electrónico.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Especifica las direcciones de correo electrónico para recibir mensajes de notificación de las tareas del programador.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Especifica el grupo donde el usuario necesita permisos rw para poder acceder a la función "SwitchToCustomer".',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            'Especifica el grupo donde el usuario necesita permisos rw para poder editar las preferencias de otros usuarios.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTOBO Notifications" otobo@your.example.com).' =>
            'Especifica el nombre que debe utilizar la aplicación al enviar notificaciones. El nombre del remitente se utiliza para crear el nombre de visualización completo para el maestro de notificaciones (es decir, "Notificaciones OTOBO" otobo@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Especifica el orden en el que se mostrarán el nombre y apellido de los agentes.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Especifica la ruta del archivo que corresponde al logo del encabezado de la página (gif|jpg|png, 700 x 100 pixeles).',
        'Specifies the path of the file for the performance log.' => 'Especifica la ruta del archivo que corresponde al log de desempeño.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Excel en la interfaz web.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos de Microsoft Word en la interfaz web.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar documentos PDF en la interfaz web.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Especifica la ruta del convertidor, que permite visualizar archivos XML en la interfaz web.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Especifica el texto que debe aparecer en el archivo de desempeño para denotar una entrada de script CGI.',
        'Specifies user id of the postmaster data base.' => 'Especifica el identificador de usuario de la base de datos del administrador de correos.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Especifica si se deben verificar todos los backends de almacenamiento al buscar archivos adjuntos. Esto solo es necesario para instalaciones donde algunos adjuntos están en el sistema de archivos y otros en la base de datos.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            'Especifica si los archivos adjuntos del artículo (MIMEBase) serán indexados y se podrán buscar.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Especifica cuántos niveles de subdirectorios se utilizarán al crear archivos de caché. Esto debería evitar que haya demasiados archivos de caché en un mismo directorio.',
        'Specify the password to authenticate for the first mirror database.' =>
            'Especifique la contraseña para autenticar la primera base de datos espejo.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Especifique el nombre de usuario para autenticar la primera base de datos espejo.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Permisos estándar disponibles para los agentes en la aplicación. Si se requieren más permisos, pueden especificarse aquí, pero para que sean efectivos, es necesario definirlos. Otros permisos útiles también se proporcionaron, incorporados al sistema: nota, cerrar, pendiente, cliente, texto libre, mover, redactar, responsable, reenviar y rebotar. Asegúrese de que "rw" permanezca siempre como el último permiso registrado.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Número de inicio para el conteo de estadísticas. Cada estadística nueva incrementa este número.',
        'Started response time escalation.' => 'Se ha iniciado la tiempo de escalado de la respuesta.',
        'Started solution time escalation.' => 'Inició el tiempo de escalado de la solución.',
        'Started update time escalation.' => 'Inició el escalamiento del tiempo de actualización.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Inicia una búsqueda con comodines del objeto activo después de que se inicie la máscara del objeto enlace.',
        'Stat#' => 'Estadística#',
        'States' => 'Estado',
        'Statistics overview.' => 'Resumen de estadísticas.',
        'Status view' => 'Vista de estados',
        'Stopped response time escalation.' => 'Detención del tiempo de escalada de la respuesta.',
        'Stopped solution time escalation.' => 'Detención del tiempo de escalado de la solución.',
        'Stopped update time escalation.' => 'Detención de tiempo de escalada de la actualización.',
        'Stores cookies after the browser has been closed.' => 'Guarda las cookies después de que el explorador se cerró.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Elimina las líneas en blanco de la vista previa de tickets, en la vista de filas.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Elimina las líneas en blanco de la vista previa de tickets, en la vista de servicio.',
        'Support Agent' => 'Agente de soporte',
        'Suspend already escalated tickets.' => 'Suspender los tickets que ya han sido escalados.',
        'Swahili' => 'Suajili',
        'Swedish' => 'Sueco',
        'System Address Display Name' => 'Dirección del sistema muestra Nombre',
        'System Configuration Deployment' => 'Despliegue de la configuración del sistema',
        'System Configuration Group' => 'Grupo de configuración del sistema',
        'System Configuration Setting History' => 'Historial de ajustes de configuración del sistema',
        'System Maintenance' => 'Mantenimiento del Sistema',
        'Templates ↔ Attachments' => 'Plantillas ↔ Anexos',
        'Templates ↔ Queues' => 'Plantillas ↔ Colas',
        'Textarea' => 'Área de Texto',
        'Thai' => 'Tailandés',
        'The PGP signature is expired.' => 'La firma PGP ha caducado.',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            'La firma PGP fue realizada por una clave revocada, esto podría significar que la firma es falsificada.',
        'The PGP signature was made by an expired key.' => 'La firma PGP fue realizada por una clave caducada.',
        'The PGP signature with the keyid has not been verified successfully.' =>
            'La firma PGP con el keyid no ha sido verificada con éxito.',
        'The PGP signature with the keyid is good.' => 'La firma PGP con el keyid es buena.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'El nombre interno del diseño que debe usarse en la interfaz del agente. Por favor, verifique los diseños disponibles en Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'El nombre interno del diseño que debe usarse en la interfaz del cliente. Por favor, verifique los diseños disponibles en Frontend::Customer::Skins.',
        'The daemon registration for the scheduler cron task manager.' =>
            'El registro del demonio para el gestor de tareas del programador cron .',
        'The daemon registration for the scheduler future task manager.' =>
            'El registro del demonio para el planificador del futuro gestor de tareas.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'El registro del demonio para el gestor de tareas del programador del agente genérico.',
        'The daemon registration for the scheduler task worker.' => 'El registro del demonio para el planificador de tareas del trabajador.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            'El registro del demonio para el administrador de la sincronización del despliegue de la configuración del sistema.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'El divisor entre el candado y el número de ticket. Por ejemplo, \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'La duración en minutos después de emitir un evento, en el cual la notificación de nueva escalada, y los eventos de inicio, son suprimidos.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'El formato del asunto. \'Izquierda\' significa \'[TicketHook#:12345] Algún asunto\', \'Derecha\' significa \'Algún asunto [TicketHook#:12345]\', \'Ninguno\' significa \'Algún asunto\' y ningún número de ticket. En este último caso debe verificar que el ajuste PostMaster::CheckFollowUpModule##0200-References está activado para reconocer los seguimientos basados en las cabeceras de los correos electrónicos.',
        'The headline shown in the customer interface.' => 'El encabezado mostrado en la interfaz del cliente.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'El identificador para un ticket, por ejemplo: Ticket#, Llamada#, MiTicket#. El valor por defecto es Ticket#.',
        'The logo and signet shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server. The signet will be scaled to 32px*32px, the logo to 196px*32px. (In the mobile setup both have a height of 24px with variable length.)' =>
            'El logotipo y el sello que se muestran en la cabecera de la interfaz del cliente. La URL de la imagen puede ser una URL relativa al directorio de imágenes del diseño, o una URL completa a un servidor web remoto. El sello será escalado a 32px*32px, el logo a 196px*32px. (En la configuración móvil ambos tienen una altura de 24px con longitud variable.)',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'El logo mostrado en la cabecera de la interfaz del agente para el diseño "por defecto". Ver "AgentLogo" para una mayor descripción.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'El logotipo que se muestra en la cabecera de la interfaz del agente. La URL de la imagen puede ser una URL relativa al directorio de imágenes del diseño, o una URL completa a un servidor web remoto.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'El logotipo que se muestra en la parte superior de la caja de acceso de la interfaz del agente. La URL de la imagen puede ser una URL relativa al directorio de imágenes del diseño, o una URL completa a un servidor web remoto.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'El número máximo de artículos expandidos en una sola página en AgentTicketZoom.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'El número máximo de artículos mostrados en una sola página en AgentTicketZoom.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'El número máximo de correos recuperados a la vez antes de volver a conectarse al servidor.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            'El código secreto que has proporcionado no es válido. El código secreto debe contener sólo letras (A-Z, mayúsculas) y números (2-7) y debe constar de 16 caracteres.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'El texto para anteponer al asunto en una respuesta de correo electrónico, por ejemplo: RE, AW, o AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'El texto para anteponer al asunto cuando un correo electrónico se reenvía, por ejemplo: FW, Fwd, o WG.',
        'The value of the From field' => 'El valor del campo De',
        'Theme' => 'Tema',
        'This configuration defines all possible screens to enable or disable default columns.' =>
            'Esta configuración define todas las pantallas posibles para activar o desactivar las columnas por defecto.',
        'This configuration defines all possible screens to enable or disable dynamic fields.' =>
            'Esta configuración define todas las pantallas posibles para activar o desactivar los campos dinámicos.',
        'This configuration defines if only valids or all (invalids) dynamic fields should be shown.' =>
            'Esta configuración define si sólo deben mostrarse los campos dinámicos válidos o todos (inválidos).',
        'This configuration defines the number of iterations that should be performed at max for calculating the WorkingTime for a Ticket. Attention: Setting this configuration to high can lead to performance issues.' =>
            'Esta configuración define el número de iteraciones que deben realizarse como máximo para calcular el Tiempo de Trabajo de un Ticket. Atención: Establecer esta configuración a un valor alto puede provocar problemas de rendimiento.',
        'This configuration registers an OutputFilter module that injects the javascript functionality to remove PendingTime.' =>
            'Esta configuración registra un módulo OutputFilter que inyecta la funcionalidad javascript para eliminar PendingTime.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            'Este módulo de eventos almacena los atributos de CustomerUser como entradas DynamicFields. Por favor, vea configuración DynamicFieldFromCustomerUser::Mapping para saber de cómo configurar el mapeo.',
        'This is a Description for Comment on Framework.' => 'Se trata de una descripción para comentar el Framework.',
        'This is a Description for DynamicField on Framework.' => 'Esta es una descripción de DynamicField sobre el Framework.',
        'This is the default orange - black skin for the customer interface.' =>
            'Esta es el diseño naranja-negro por defecto de la interfaz del cliente.',
        'This is the default orange - black skin.' => 'Esta es el diseño naranja-negro por defecto.',
        'This key is not certified with a trusted signature!' => '¡Esta clave no está certificada con una firma de confianza!',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Este módulo y su función PreRun() se ejecutarán, si así se define, por cada petición. Este módulo es útil para verificar algunas opciones de usuario o para desplegar noticias acerca de aplicaciones novedosas.',
        'This module is being used to extend the password policy.' => 'Este módulo se utiliza para ampliar la política de contraseñas.',
        'This module is part of the admin area of OTOBO.' => 'Este módulo forma parte del área de administración de OTOBO.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Esta opción define el campo dinámico en el que se almacena un identificador de entidad de la Gestión de Procesos.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Esta opción define el campo dinámico en el que se almacena el ID de la entidad del proceso de la Gestión de Procesos.',
        'This option defines the process tickets default lock.' => 'Esta opción define el bloqueo por defecto de los tickets procesados.',
        'This option defines the process tickets default priority.' => 'Esta opción define la prioridad por defecto de los tickets procesados.',
        'This option defines the process tickets default queue.' => 'Esta opción define la cola por defecto de los tickets procesados.',
        'This option defines the process tickets default state.' => 'Esta opción define el estado por defecto de los tickets procesados.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Esta opción denegará el acceso a los tickets de la empresa cliente, que no son creados por el usuario cliente.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Esta opción le permite anular la lista de países incorporada con su propia lista de países. Esto es especialmente útil si sólo quieres utilizar un pequeño grupo de países seleccionados.',
        'This setting is deprecated. Set OTOBOTimeZone instead.' => 'Este ajuste está obsoleto. Establezca en su lugar OTOBOTimeZone.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            'Esta configuración muestra los atributos de clasificación en toda la pantalla de resumen, no sólo en la vista de colas.',
        'Ticket Close' => 'Ticket cerrado',
        'Ticket Close.' => 'Cerrar Ticket.',
        'Ticket Compose Bounce Email.' => 'Componer Rebote de Correo Electrónico de Ticket.',
        'Ticket Compose email Answer.' => 'Componer Respuesta de Correo Electrónico de Ticket.',
        'Ticket Customer.' => 'Cliente de Ticket.',
        'Ticket Forward Email.' => 'Reenviar Correo Electrónico del Ticket.',
        'Ticket FreeText.' => 'Textos Libres del Ticket.',
        'Ticket History.' => 'Historia del Ticket.',
        'Ticket Lock.' => 'Bloqueo de Ticket.',
        'Ticket Merge.' => 'Combinación de Tickets.',
        'Ticket Move.' => 'Mover Ticket.',
        'Ticket Note.' => 'Nota de Ticket.',
        'Ticket Notifications' => 'Notificaciones de Ticket',
        'Ticket Outbound Email.' => 'Correo electrónico de salida del ticket.',
        'Ticket Overview "Medium" Limit' => 'Límite de la vista de resumen "Mediana" de tickets',
        'Ticket Overview "Preview" Limit' => 'Límite de la vista de resumen "Preliminar" de tickets',
        'Ticket Overview "Small" Limit' => 'Límite de vista de resumen "Pequeña" de tickets',
        'Ticket Owner.' => 'Propietario del ticket.',
        'Ticket Pending.' => 'Ticket pendiente.',
        'Ticket Print.' => 'Impresión de tickets.',
        'Ticket Priority.' => 'Prioridad de tickets.',
        'Ticket Queue Overview' => 'Vista general por fila',
        'Ticket Responsible.' => 'Responsable del ticket.',
        'Ticket Watcher' => 'Observador de tickets',
        'Ticket Zoom' => 'Zoom del ticket',
        'Ticket Zoom.' => 'Zoom del Ticket.',
        'Ticket bulk module.' => 'Módulo de tickets en masa.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Módulo de eventos de Ticket, que dispara los eventos de finalización de tiempo para escalada.',
        'Ticket limit per page for Ticket Overview "Medium".' => 'Límite de tickets por página para el resumen de tickets "Medio".',
        'Ticket limit per page for Ticket Overview "Preview".' => 'Límite de tickets por página para el resumen de tickets "Vista previa".',
        'Ticket limit per page for Ticket Overview "Small".' => 'Límite de tickets por página para el resumen de tickets "Pequeño".',
        'Ticket notifications' => 'Notificaciones del ticket',
        'Ticket overview' => 'Vista de resumen de los tickets',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => 'Diálogo de división de tickets.',
        'Ticket title' => 'Título del ticket',
        'Ticket zoom view.' => 'Vista de zoom del ticket.',
        'TicketNumber' => 'TicketNumber',
        'Tickets in the following queues will not be stored on the Elasticsearch server. To apply this to existing tickets, the ticket migration has to be run via console, after changing this option.' =>
            'Los tickets de las siguientes colas no se almacenarán en el servidor de Elasticsearch. Para aplicar esto a los tickets existentes, hay que ejecutar la migración de tickets a través de la consola, después de cambiar esta opción.',
        'Tickets.' => 'Tickets.',
        'Tile registration for the CustomerDashboard. Module is required.' =>
            'El registro del mosaico para el CustomerDashboard. El módulo es necesario.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Tiempo en segundos que se añade al tiempo actual, si se define un estado-pendiente (por defecto: 86400 = 1 día).',
        'To accept login information, such as an EULA or license.' => 'Para aceptar información de acceso, como un EULA o una licencia.',
        'To download attachments.' => 'Para descargar archivos adjuntos.',
        'To view HTML attachments.' => 'Para ver los archivos adjuntos HTML.',
        'Toggles display of OTOBO FeatureAddons list in PackageManager.' =>
            'Activa la visualización de la lista de FeatureAddons de OTOBO en el PackageManager.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Elemento de la barra de herramientas para un acceso directo. El control de acceso adicional para mostrar o no este enlace se puede hacer utilizando la clave "Grupo" y el contenido como "rw:grupo1;move_into:grupo2".',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Selección de transporte para las notificaciones de citas. Por favor, tenga en cuenta que si establece \'Activo\' a 0 sólo impedirá que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario en su nombre. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Selección de transporte para las notificaciones de tickets. Por favor, tenga en cuenta que si establece \'Activo\' a 0 sólo impedirá que los agentes editen los ajustes de este grupo en sus preferencias personales, pero seguirá permitiendo a los administradores editar los ajustes de otro usuario en su nombre. Utilice \'PreferenceGroup\' para controlar en qué área deben mostrarse estos ajustes en la interfaz de usuario.',
        'Tree view' => 'Vista de árbol',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            'Dispara la acción de añadir o actualizar citas automáticas de calendarios basadas en ciertos tiempos de tickets.',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Activa los eventos de escalado de tickets y los eventos de notificación para el escalado.',
        'Turkish' => 'Turco',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Desactiva la validación del certificado SSL, por ejemplo, si utiliza un proxy HTTPS transparente. ¡Úsalo bajo tu propio riesgo!',
        'Turns on drag and drop for the main navigation.' => 'Activa la función de arrastrar y soltar para la navegación principal.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Activa la comprobación de la dirección ip remota. No debe activarse si la aplicación se utiliza, por ejemplo, a través de una granja de proxies o una conexión de acceso telefónico, porque la dirección ip remota es en su mayoría diferente para las solicitudes.',
        'Tweak the system as you wish.' => 'Ajusta el sistema como quieras.',
        'Type of daemon log rotation to use: Choose \'OTOBO\' to let OTOBO system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            'Tipo de rotación del demonio de registros a utilizar: Elija \'OTOBO\' para dejar que el sistema OTOBO se encargue de la rotación de archivos, o elija \'Externo\' para utilizar un mecanismo de rotación de terceros (por ejemplo, logrotate). Nota: El mecanismo de rotación externo requiere una configuración propia e independiente.',
        'Ukrainian' => 'Ucraniano',
        'Unlock tickets that are past their unlock timeout.' => 'Desbloquear tickets que han sobrepasado su tiempo de desbloqueo.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Desbloquear tickets cuando una nota es añadida y el propietario se encuentra fuera de la oficina.',
        'Unlocked ticket.' => 'Ticket desbloqueado.',
        'Up' => 'Arriba',
        'Upcoming Events' => 'Eventos Próximos',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Actualizar la bandera de ticket "Seen" ("Visto"), si ya se vió cada artículo o si se creó un artículo nuevo.',
        'Update time' => 'Tiempo de Actualización',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Actualiza el índice de escaladas de ticket, luego de que un atributo de ticket se actualizó.',
        'Updates the ticket index accelerator.' => 'Actualiza el acelerador de índice de ticket.',
        'Upload your PGP key.' => 'Subir su llave PGP.',
        'Upload your S/MIME certificate.' => 'Subir su certificado S/MIME.',
        'Use Redis::Fast instead of Redis.' => 'Utilice Redis::Fast en lugar de Redis.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Utilizar el nuevo tipo de campos de selección y autocompletado en la interfaz del agente, cuando sea aplicable (InputFields).',
        'Use specified Redis logical database.' => 'Utilizar la base de datos lógica Redis especificada.',
        'User Profile' => 'Perfil del Usuario',
        'UserFirstname' => 'NombreUsuario',
        'UserLastname' => 'ApellidoUsuario',
        'Users, Groups & Roles' => 'Usuarios, Grupos y Roles',
        'Uses richtext for viewing and editing ticket notification.' => 'Utiliza texto enriquecido para ver y editar la notificación del ticket.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Utiliza texto enriquecido para ver y editar: artículos, saludos, firmas, plantillas estándar, respuestas automáticas y notificaciones.',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'Ver los resultados de rendimiento.',
        'Watch this ticket' => 'Dar seguimiento a este ticket',
        'Watched Tickets' => 'Tickets Monitoreados',
        'Watched Tickets.' => 'Tickets Visualizados.',
        'We are performing scheduled maintenance.' => 'Estamos realizando un mantenimiento programado.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Estamos realizando un mantenimiento programado. El inicio de sesión no está disponible temporalmente.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Estamos realizando un mantenimiento programado. Deberíamos volver a estar en línea en breve.',
        'Web Service' => 'Servicio web',
        'Web Services' => 'Servicios web',
        'Welcome text for the dashboard header. Name will be inserted to %s of the WelcomeText. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" and "UserLogin" will be substituted.' =>
            'Texto de bienvenida para la cabecera del tablero. El nombre se insertará en %s del texto de bienvenida. "UserTitle", "UserFirstname", "UserLastname", "UserEmail" y "UserLogin" serán sustituidos.',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            'Cuando el agente crea un ticket, si el ticket se bloquea o no automáticamente para el agente.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Cuando se fusionan los tickets, se añade automáticamente una nota al ticket que ya no está activo. Aquí puede definir el cuerpo de esta nota (este texto no puede ser modificado por el agente).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Cuando se fusionan los tickets, se añade automáticamente una nota al ticket que ya no está activo. Aquí puede definir el asunto de esta nota (este asunto no puede ser modificado por el agente).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Cuando los tickets se mezclan, el cliente puede ser informado por correo electrónico al seleccionar "Inform Sender". Es posible predefinir el contenido de dicha notificación en esta área de texto, que luego puede ser modificada por los agentes.',
        'Whether extended customer information is shown in the ticket print screen of the customer interface.' =>
            'Si la información ampliada del cliente se muestra en la pantalla de impresión de tickets de la interfaz del cliente.',
        'Whether fields should be automatically filled (1), and in that case also be hidden from ticket formulars (2).' =>
            'Si los campos deben rellenarse automáticamente (1), y en ese caso también deben ocultarse de los formularios de las entradas (2).',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Recoger o no información meta de los artículos utilizando los filtros configurados en Ticket::Frontend::ZoomCollectMetaFilters.',
        'Whether the execution of TicketACL can be avoided by checking cached field dependencies. This can improve loading times of ticket formulars, but has to be disabled, if ACLModules are to be used for Ticket- and Form-ReturnTypes.' =>
            'Si se puede evitar la ejecución de TicketACL comprobando las dependencias de los campos en el caché. Esto puede mejorar los tiempos de carga de los formularios de tickets, pero tiene que estar desactivado, si se van a utilizar ACLModules para Ticket- y Form-ReturnTypes.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            'Para forzar la redirección de todas las peticiones del protocolo http al https. Por favor, compruebe que su servidor web está configurado correctamente para el protocolo https antes de activar esta opción.',
        'Yes, but hide archived tickets' => 'Sí, pero oculta los tickets archivados',
        'Your email with ticket number "<OTOBO_TICKET>" is bounced to "<OTOBO_BOUNCE_TO>". Contact this address for further information.' =>
            'Su correo electrónico con el número de ticket "<OTOBO_TICKET>" ha sido devuelto a "<OTOBO_BOUNCE_TO>". Ponte en contacto con esta dirección para obtener más información.',
        'Your email with ticket number "<OTOBO_TICKET>" is merged to "<OTOBO_MERGE_TO_TICKET>".' =>
            'Su correo con número de ticket "<OTOBO_TICKET>" se unió a "<OTOBO_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Su selección de colas de espera preferidas. También se le notifica acerca de esas colas por correo electrónico si está activado.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Su selección de servicios preferidos. También se le notifica acerca de esos servicios por correo electrónico si está habilitado.',
        'Zoom' => 'Detalle',
        'attachment' => 'Adjuntar archivo',
        'bounce' => 'rebotar',
        'compose' => 'redactar',
        'debug' => 'Depuración',
        'error' => 'Error',
        'forward' => 'reenviar',
        'info' => 'Información',
        'inline' => 'En Línea',
        'normal' => 'normal',
        'notice' => 'Aviso',
        'pending' => 'pendiente',
        'phone' => 'teléfono',
        'responsible' => 'responsable',
        'reverse' => 'revertir',
        'stats' => 'estadísticas',

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
        'Ignore',
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
        'Migrate',
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
