# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2003 Gilberto Cezar de Almeida <gibalmeida at hotmail.com>
# Copyright (C) 2005 Alterado por Glaucia C. Messina (glauglauu@yahoo.com)
# Copyright (C) 2007-2010 Fabricio Luiz Machado <soprobr gmail.com>
# Copyright (C) 2010-2011 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# Copyright (C) 2013 Alexandre <matrixworkstation@gmail.com>
# Copyright (C) 2013-2014 Murilo Moreira de Oliveira <murilo.moreira 60kg gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::pt_BR;

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
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';
    $Self->{Completeness}        = 0.920324427480916;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = '.';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Gerenciamento de ACL',
        'Actions' => 'Ações',
        'Create New ACL' => 'Criar nova ACL',
        'Deploy ACLs' => 'Implementar ACLs',
        'Export ACLs' => 'Exportar ACLs',
        'Filter for ACLs' => 'Filtrar por ACLs',
        'Just start typing to filter...' => 'Basta começar a digitar para filtrar... ',
        'Configuration Import' => 'Importar configurações',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Aqui você pode fazer o envio de um arquivo de configuração para importar ACLs para o seu sistema. O arquivo precisa estar no formato .yml como exportado pelo módulo de edição de ACL.',
        'This field is required.' => 'Este campo é obrigatório.',
        'Overwrite existing ACLs?' => 'Sobrescrever ACLs existentes?',
        'Upload ACL configuration' => 'Upload configuração de ACL',
        'Import ACL configuration(s)' => 'Importar configuração(ões) de ACL',
        'Description' => 'Descrição',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Para criar uma nova ACL, você pode importar ACLs que foram exportadas de outro sistema ou criar uma completamente nova.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Mudanças nas ACLs apenas afetam o comportamento do sistema se você implementar a ACL na sequência. Implementando a ACL, as alterações realizadas recentemente serão gravadas na configuração.',
        'ACLs' => 'ACLs',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Por favor note: Esta tabela representa a ordem de execução das ACLs. Se você precisa mudar a ordem em que as ACLs são executadas, por favor mude os nomes das ACLs afetadas.',
        'ACL name' => 'Nome da ACL',
        'Comment' => 'Comentário',
        'Validity' => 'Validade',
        'Export' => 'Exportar',
        'Copy' => 'Copiar',
        'No data found.' => 'Nenhum dado encontrado.',
        'No matches found.' => 'Nenhum resultado encontrado.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Editar ACL %s',
        'Edit ACL' => 'Editar ACL',
        'Go to overview' => 'Ir Para Visão Geral',
        'Delete ACL' => 'Excluir ACL',
        'Delete Invalid ACL' => 'Excluir ACL Inválida',
        'Match settings' => 'Configurações de coincidência',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Configure critérios de coincidência para esta ACL. Use \'Properties\' para comparar dados na tela atual ou \'PropertiesDatabase\' para comparar com atributos do chamado atual que está armazenado no banco de dados.',
        'Change settings' => 'Alterar configurações',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Configure o que você quer alterar se o critério coincidir. Mantenha em mente que \'Possible\' é uma adição à lista e \'PossibleNot\', uma exclusão da lista.',
        'Check the official %sdocumentation%s.' => 'Cheque a %s documentação %s oficial.',
        'Show or hide the content' => 'Mostrar ou esconder o conteúdo',
        'Edit ACL Information' => 'Editar informações da ACL',
        'Name' => 'Nome',
        'Stop after match' => 'Parar Após Encontrar',
        'Edit ACL Structure' => 'Editar estrutura da ACL',
        'Save ACL' => 'Salvar ACL',
        'Save' => 'Salvar',
        'or' => 'ou',
        'Save and finish' => 'Salvar e Finalizar',
        'Cancel' => 'Cancelar',
        'Do you really want to delete this ACL?' => 'Você quer realmente excluir esta ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Crie uma nova ACL submetendo os dados do formulário. Após criar a ACL, você será capaz de adicionar itens de configuração no modo de edição.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Gerenciamento de Calendário',
        'Add Calendar' => 'Adicionar Calendário',
        'Edit Calendar' => 'Editar Calendário',
        'Calendar Overview' => 'Visão geral de Calendário',
        'Add new Calendar' => 'Adicionar novo Calendário',
        'Import Appointments' => 'Importar Compromissos',
        'Calendar Import' => 'Importar Calendário',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Aqui você pode carregar um arquivo de configuração para importar um calendário para seu sistema. O arquivo precisa ser em .yml  como o exportado pelo módulo de gerenciamento de calendário.',
        'Overwrite existing entities' => 'Substituir entidades existentes',
        'Upload calendar configuration' => 'Carregar configuração do calendário',
        'Import Calendar' => 'Importar Calendário',
        'Filter for Calendars' => 'Filtrar por Calendários',
        'Filter for calendars' => 'Filtro para calendários',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Dependendo do campo grupo, o sistema liberará usuários para acessar o calendário de acordo com o nível de permissão deles.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Apenas leitura: usuários podem ver e exportar todos os compromissos nesse calendário.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Mover para: usuários poderão modificar compromissos no calendário, mas sem alterar a seleção do calendário.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Criar: usuários podem criar e excluir compromissos no calendário.',
        'Read/write: users can manage the calendar itself.' => 'Leitura/escrita: os usuários podem gerenciar o próprio calendário.',
        'Group' => 'Grupo',
        'Changed' => 'Alterado',
        'Created' => 'Criado',
        'Download' => 'Baixar',
        'URL' => 'URL',
        'Export calendar' => 'Exportar calendário',
        'Download calendar' => 'Baixar calendário',
        'Copy public calendar URL' => 'Copiar URL publica do calendário',
        'Calendar' => 'Calendário',
        'Calendar name' => 'Nome do calendário',
        'Calendar with same name already exists.' => 'Calendário com mesmo nome já existe.',
        'Color' => 'Cor',
        'Permission group' => 'Grupo de permissão',
        'Ticket Appointments' => 'Compromissos de chamado',
        'Rule' => 'Regra',
        'Remove this entry' => 'Remover esta entrada',
        'Remove' => 'Remover',
        'Start date' => 'Data de início',
        'End date' => 'Data final',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Use as opções abaixo para diminuir quais compromissos de chamado serão criados automaticamente.',
        'Queues' => 'Filas',
        'Please select a valid queue.' => 'Por favor, selecione uma fila válida.',
        'Search attributes' => 'Atributos da pesquisa',
        'Add entry' => 'Adicionar entrada',
        'Add' => 'Adicionar',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Definir regras para criação automática de compromissos neste calendário baseado em dados de chamado. ',
        'Add Rule' => 'Adicionar regra',
        'Submit' => 'Enviar',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Importar compromissos',
        'Go back' => 'Voltar',
        'Uploaded file must be in valid iCal format (.ics).' => 'O arquivo enviado deve estar no formato válido iCal (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Se o Calendário desejado não estiver listado aqui, por favor certifique-se que você tenha, pelo menos, permissões para \'criar\'.',
        'Upload' => 'Enviar',
        'Update existing appointments?' => 'Atualizar compromissos existentes?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Todos os compromissos no calendário com o mesmo UniqueID serão sobrescrito.  ',
        'Upload calendar' => 'Carregar calendário',
        'Import appointments' => 'Importar compromissos',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Gerenciamento de notificação do compromisso',
        'Add Notification' => 'Adicionar Notificação',
        'Edit Notification' => 'Alterar Notificação',
        'Export Notifications' => 'Exportar notificações',
        'Filter for Notifications' => 'Filtro para Notificações',
        'Filter for notifications' => 'Filtro para notificações',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Aqui você pode fazer upload de um arquivo de configuração para importar notificações de compromisso para o seu sistema. O arquivo deve estar no formato .yml como exportado pelo módulo de notificação de compromisso.',
        'Overwrite existing notifications?' => 'Sobrescrever notificações existentes?',
        'Upload Notification configuration' => 'Suba a configuração de notificação',
        'Import Notification configuration' => 'Importe a configuração de notificação',
        'List' => 'Lista',
        'Delete' => 'Excluir',
        'Delete this notification' => 'Excluir esta notificação',
        'Show in agent preferences' => 'Mostras nas preferências do atende',
        'Agent preferences tooltip' => 'Tooltip das preferências de agente',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Esta mensagem vai ser exibida na tela de preferências de agente como um tooltip para esta notificação.',
        'Toggle this widget' => 'Chavear este dispositivo',
        'Events' => 'Eventos',
        'Event' => 'Evento',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Aqui você pode escolher quais eventos irão acionar essa notificação. Um filtro de compromisso adicional pode ser aplicado abaixo para enviar apenas compromissos com determinados critérios.',
        'Appointment Filter' => 'Filtrar Compromisso',
        'Type' => 'Tipo',
        'Title' => 'Titulo',
        'Location' => 'Localização',
        'Team' => 'Time',
        'Resource' => 'Recurso',
        'Recipients' => 'Destinatários',
        'Send to' => 'Enviar para',
        'Send to these agents' => 'Enviar para estes atendentes',
        'Send to all group members (agents only)' => 'Enviar para todos os membros do grupo (apenas o agente)',
        'Send to all role members' => 'Enviar para todos os membros da função',
        'Send on out of office' => 'Enviar em fora do esritório',
        'Also send if the user is currently out of office.' => 'Também enviar se o usuário se encontra fora do escritório..',
        'Once per day' => 'Uma vez por dia',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Notificar o usuário apenas uma vez por dia sobre um único compromisso usando um transporte selecionado.',
        'Notification Methods' => 'Métodos de notificação',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Estes são os possíveis métodos que podem ser usados para enviar esta notificação a cada um dos destinatários. Por favor, selecione pelo menos um método abaixo.',
        'Enable this notification method' => 'Ativar esse método de notificação',
        'Transport' => 'Transporte',
        'At least one method is needed per notification.' => 'Pelo menos um método é necessário por notificação.',
        'Active by default in agent preferences' => 'Ativado por padrão nas preferências de agente',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Esse é o valor padrão atribuído para agentes destinatários que ainda não fizeram uma escolha para essa notificação em suas preferências. Se a caixa estiver habilitada, a notificação será enviada para esses agentes.',
        'This feature is currently not available.' => 'Este recurso não está disponível no momento.',
        'Upgrade to %s' => 'Atualize para %s',
        'Please activate this transport in order to use it.' => 'Por favor ative este transporte para usá-lo.',
        'No data found' => 'Dados não encontrado',
        'No notification method found.' => 'Método de notificação não existente',
        'Notification Text' => 'Texto da notificação',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Esta linguagem não está presente ou habilitada no sistema. Este texto de notificação pode ser excluído se não for mais necessário.',
        'Remove Notification Language' => 'Remover notificação de idioma',
        'Subject' => 'Assunto',
        'Text' => 'Texto',
        'Message body' => 'Corpo da mensagem',
        'Add new notification language' => 'Adicionar novo idioma notificação',
        'Save Changes' => 'Salvar Alterações',
        'Tag Reference' => 'Referência de Tag',
        'Notifications are sent to an agent.' => 'As notificações são enviadas a um agente.',
        'You can use the following tags' => 'Você pode usar os seguintes rótulos',
        'To get the first 20 character of the appointment title.' => 'Para obter os 20 primeiros caracteres do título do compromisso.',
        'To get the appointment attribute' => 'Para obter o atributo compromisso',
        ' e. g.' => 'ex.',
        'To get the calendar attribute' => 'Para obter o atributo calendário',
        'Attributes of the recipient user for the notification' => 'Atributos do usuário destinatário da notificação',
        'Config options' => 'Opções de Configuração',
        'Example notification' => 'Exemplo de notificação',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Caixa de endereço de e-mail adicional',
        'This field must have less then 200 characters.' => 'Este campo precisa ter menos de 200 caracteres.',
        'Article visible for customer' => 'Artigo visível para o cliente',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Um artigo será criado se as notificações são enviadas para o usuário ou para um endereço de e-mail adicional.',
        'Email template' => 'Template de e-mail',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Use este modelo para gerar o e-mail completo (somente para e-mails HTML)',
        'Enable email security' => 'Habilitar segurança de email',
        'Email security level' => 'Nível de segurança do email',
        'If signing key/certificate is missing' => 'Se a assinatura de chave/certificado está faltando',
        'If encryption key/certificate is missing' => 'Se a chave/certificado de encriptação está faltando',

        # Template: AdminAttachment
        'Attachment Management' => 'Gerenciamento de Anexos',
        'Add Attachment' => 'Adicionar Anexo',
        'Edit Attachment' => 'Alterar Anexo',
        'Filter for Attachments' => 'Filtrar por Anexos',
        'Filter for attachments' => 'Filtro para anexos',
        'Filename' => 'Nome do arquivo',
        'Download file' => 'Baixar arquivo',
        'Delete this attachment' => 'Deletar este anexo',
        'Do you really want to delete this attachment?' => 'Deseja realmente excluir este anexo?',
        'Attachment' => 'Anexo',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administração de Autorrespostas',
        'Add Auto Response' => 'Adicionar Autorresposta',
        'Edit Auto Response' => 'Alterar Autorresposta',
        'Filter for Auto Responses' => 'Filtrar por Autorrespostas',
        'Filter for auto responses' => 'Filtro para respostas automáticas',
        'Response' => 'Resposta',
        'Auto response from' => 'Autorresposta de',
        'Reference' => 'Referência',
        'To get the first 20 character of the subject.' => 'Para obter os primeiros 20 caracteres do assunto.',
        'To get the first 5 lines of the email.' => 'Para obter as primeiras 5 linhas do e-mail.',
        'To get the name of the ticket\'s customer user (if given).' => 'Para obter o nome do usuário cliente do chamado (se fornecido).',
        'To get the article attribute' => 'Para obter o atributo do artigo',
        'Options of the current customer user data' => 'Opções para os dados do atual usuário cliente',
        'Ticket owner options' => 'Opções do proprietário do chamado',
        'Ticket responsible options' => 'Opções do responsável pelo chamado',
        'Options of the current user who requested this action' => 'Opções do usuário atual que solicitou a ação',
        'Options of the ticket data' => 'Opções dos dados do chamado',
        'Options of ticket dynamic fields internal key values' => 'Opções de valores internos de campos dinâmicos de chamados',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opções de exibição de valores de campos dinâmicos de chamados, úteis para campos Dropdown e Multisseleção',
        'Example response' => 'Resposta de exemplo',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Gestão de Serviço de Nuvem',
        'Support Data Collector' => 'Coletor de dados para suporte',
        'Support data collector' => 'Coletor de dados para suporte',
        'Hint' => 'Dica',
        'Currently support data is only shown in this system.' => 'Atualmente, dados de suporte só são exibidos neste sistema.',
        'It is sometimes recommended to send this data to the OTOBO team in order to get better support.' =>
            '',
        'Configuration' => 'Configuração',
        'Send support data' => 'Enviar dados de suporte',
        'This will allow the system to send additional support data information to the OTOBO team.' =>
            '',
        'Update' => 'Atualizar',
        'System Registration' => 'Registro do Sistema',
        'To enable data sending, please register your system with the OTOBO team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => 'Registrar este Sistema',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'O registro de sistema está desabilitado para o seu sistema. Por favor verifique sua configuração.',

        # Template: AdminCloudServices
        'System registration is a service of OTOBO team, which provides a lot of advantages!' =>
            '',
        'Please note that the use of OTOBO cloud services requires the system to be registered.' =>
            'Por favor, note que o uso dos serviços em nuvem do OTOBO requerem que o sistema esteja registrado.',
        'Register this system' => 'Registrar o sistema',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Aqui você pode configurar os serviços de nuvem disponíveis que se comunicam de forma segura com %s.',
        'Available Cloud Services' => 'Serviços de nuvem disponíveis',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Log de Comunicação',
        'Time Range' => 'Intervalo de Tempo',
        'Show only communication logs created in specific time range.' =>
            'Mostre apenas os logs de comunicação criados em um intervalo de tempo específico.',
        'Filter for Communications' => 'Filtrar por Comunicações',
        'Filter for communications' => 'Filtro para comunicações',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'Nesta tela você pode ver uma visão geral sobre as comunicações de entrada e de saída.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Você pode alterar o tipo e a ordem das colunas clicando no cabeçalho da coluna.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Se você clicar nas diferentes entradas, você será redirecionado para uma tela detalhada sobre a mensagem.',
        'Status for: %s' => 'Estado para:%s',
        'Failing accounts' => 'Contas falhando',
        'Some account problems' => 'Alguns problemas de conta',
        'No account problems' => 'Sem conta com problemas',
        'No account activity' => 'Sem conta com atividade',
        'Number of accounts with problems: %s' => 'Número de contas com problemas:%s',
        'Number of accounts with warnings: %s' => 'Número de contas com avisos:%s',
        'Failing communications' => 'Falha nas comunicações',
        'No communication problems' => 'Sem problemas de comunicação',
        'No communication logs' => 'Sem logs de comunicação',
        'Number of reported problems: %s' => 'Número de problemas relatados:%s',
        'Open communications' => 'Comunicações abertas',
        'No active communications' => 'Nenhuma comunicação ativa',
        'Number of open communications: %s' => 'Número de comunicações abertas:%s',
        'Average processing time' => 'Tempo médio de processamento',
        'List of communications (%s)' => 'Lista de comunicações (%s)',
        'Settings' => 'Configurações',
        'Entries per page' => 'Entradas por página',
        'No communications found.' => 'Não foram encontradas comunicações.',
        '%s s' => '%s s',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Status da Conta',
        'Back to overview' => 'Retornar à visão geral',
        'Filter for Accounts' => 'Filtrar por Contas',
        'Filter for accounts' => 'Filtro para contas',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Você pode alterar o tipo e a ordem dessas colunas, clicando no cabeçalho da coluna.',
        'Account status for: %s' => 'Status da conta para: %s',
        'Status' => 'Estado',
        'Account' => 'Conta',
        'Edit' => 'Editar',
        'No accounts found.' => 'Nenhuma conta encontrada.',
        'Communication Log Details (%s)' => 'Detalhes do log de comunicação (%s)',
        'Direction' => 'Direção',
        'Start Time' => 'Tempo inicial ',
        'End Time' => 'Tempo final',
        'No communication log entries found.' => 'Não foram encontradas entradas de log de comunicação.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Duração',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Prioridade',
        'Module' => 'Módulo',
        'Information' => 'Informação',
        'No log entries found.' => 'Nenhuma entrada de log encontrada.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Visualização de detalhes para %s comunicação iniciada em %s',
        'Filter for Log Entries' => 'Filtrar Entradas do Log',
        'Filter for log entries' => 'Filtro para entradas de log',
        'Show only entries with specific priority and higher:' => 'Mostrar apenas entradas com prioridade específica e superior:',
        'Communication Log Overview (%s)' => 'Visão geral do registro de comunicação (%s)',
        'No communication objects found.' => 'Nenhum objeto de comunicação encontrado.',
        'Communication Log Details' => 'Detalhes do registro de comunicação',
        'Please select an entry from the list.' => 'Por favor selecione uma entrada da lista.',

        # Template: AdminContactWD
        'Contact with data management' => '',
        'Contact with data' => 'Contato com dados',
        'Add contact with data' => '',
        'Edit contact with data' => '',
        'Back to search results' => 'Voltar ao resultado da busca',
        'Select' => 'Selecionar',
        'Search' => 'Procurar',
        'Wildcards like \'*\' are allowed.' => 'Coringas como \'*\' são permitidos.',
        'Please enter a search term to look for contacts with data.' => '',
        'Valid' => 'Válido',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Gerenciamento de Cliente',
        'Add Customer' => 'Adicionar Cliente',
        'Edit Customer' => 'Alterar Cliente',
        'List (only %s shown - more available)' => 'Listar (somente %s mostrado - mais disponível)',
        'total' => 'total',
        'Please enter a search term to look for customers.' => 'Por favor, insira um termo de pesquisa para procurar clientes.',
        'Customer ID' => 'ID do Cliente',
        'Please note' => 'Por favor observe',
        'This customer backend is read only!' => 'Este backend do cliente é somente leitura!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Gerenciar Relações Clientes-Grupos',
        'Notice' => 'Aviso',
        'This feature is disabled!' => 'Esta funcionalidade está desabilitada!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Utilize esta funcionalidade apenas se desejar definir permissões de grupo para os clientes.',
        'Enable it here!' => 'Habilite-a aqui!',
        'Edit Customer Default Groups' => 'Editar os grupos-padrão para clientes',
        'These groups are automatically assigned to all customers.' => 'Estes grupos serão atribuídos automaticamente a todos os clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Você pode gerenciar estes grupos através do parâmetro de configuração "CustomerGroupCompanyAlwaysGroups"',
        'Filter for Groups' => 'Filtrar por Grupos',
        'Select the customer:group permissions.' => 'Selecione as permissões cliente:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Se nada for selecionado, então não há permissões nesse grupo (chamados não estarão disponíveis para o cliente).',
        'Search Results' => 'Resultado da Pesquisa',
        'Customers' => 'Clientes',
        'Groups' => 'Grupos',
        'Change Group Relations for Customer' => 'Alterar as Relações de Grupo para o Cliente',
        'Change Customer Relations for Group' => 'Alterar as Relações de Cliente para o Grupo',
        'Toggle %s Permission for all' => 'Alternar a Permissão %s para todos',
        'Toggle %s permission for %s' => 'Alternar a permissão %s para %s',
        'Customer Default Groups:' => 'Grupos-padrão para clientes:',
        'No changes can be made to these groups.' => 'Nenhuma alteração pode ser feita a estes grupos.',
        'ro' => 'Somente Leitura',
        'Read only access to the ticket in this group/queue.' => 'Acesso somente leitura de chamados neste grupo/fila.',
        'rw' => 'Leitura E Escrita',
        'Full read and write access to the tickets in this group/queue.' =>
            'Acesso de leitura e escrita de chamados neste grupo/fila.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Gerenciamento de Usuário Cliente',
        'Add Customer User' => 'Adicionar Usuário Cliente',
        'Edit Customer User' => 'Editar Usuário Cliente',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Usuário cliente é necessário para ter um histórico de cliente e para logar via interface de cliente.',
        'List (%s total)' => 'Listar (%s total)',
        'Username' => 'Usuário',
        'Email' => 'E-mail',
        'Last Login' => 'Última Autenticação',
        'Login as' => 'Logar-se como',
        'Switch to customer' => 'Trocar para cliente',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Este backend do cliente é somente leitura, mas as preferências do usuário do cliente podem ser alteradas!',
        'This field is required and needs to be a valid email address.' =>
            'Este campo é obrigatório e deve ser um endereço de e-mail válido.',
        'This email address is not allowed due to the system configuration.' =>
            'Este endereço de e-mail não é permitido devido à configuração do sistema.',
        'This email address failed MX check.' => 'Para este endereço de e-mail, o teste MX falhou.',
        'DNS problem, please check your configuration and the error log.' =>
            'Problema de DNS, por favor, verifique sua configuração e o log de erros.',
        'The syntax of this email address is incorrect.' => 'A sintaxe deste endereço de e-mail está incorreta.',
        'This CustomerID is invalid.' => 'Este ID do cliente é inválido.',
        'Effective Permissions for Customer User' => 'Permissões efetivas para o usuário cliente',
        'Group Permissions' => 'Permissões de grupo',
        'This customer user has no group permissions.' => 'Este usuário cliente não possui permissões de grupo.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'A Tabela acima mostra permissões de grupo efetivas para o usuário cliente. A matriz leva em consideração todas as permissões herdadas (por exemplo, através de grupos de clientes). Nota: A tabela não considera alterações feitas a este formulário sem submetê-lo.',
        'Customer Access' => 'Acesso ao cliente',
        'Customer' => 'Cliente',
        'This customer user has no customer access.' => 'Este usuário cliente não possui acesso de cliente.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'A tabela acima mostra o acesso de cliente concedido para o usuário cliente pelo contexto de permissão. A matriz leva em consideração todos os acessos herdados (por exemplo, através de grupos de clientes). Nota: A tabela não considera alterações feitas a este formulário sem submetê-lo.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Gerenciar Relações Usuário Cliente-Cliente',
        'Select the customer user:customer relations.' => 'Selecione o usuário cliente: relações com o cliente.',
        'Customer Users' => 'Usuários Clientes',
        'Change Customer Relations for Customer User' => 'Alterar as relações com o cliente para o usuário cliente',
        'Change Customer User Relations for Customer' => 'Alterar as relações com o usuário cliente para o cliente',
        'Toggle active state for all' => 'Alternar estado ativo para todos',
        'Active' => 'Ativo',
        'Toggle active state for %s' => 'Chavear estado ativo para %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Gerenciar relacionamentos Usuário Cliente - Grupo',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Utilize esta função apenas se você quer determinar permissões de grupo para usuários clientes.',
        'Edit Customer User Default Groups' => 'Editar grupos padrão de Usuário Cliente',
        'These groups are automatically assigned to all customer users.' =>
            'Estes grupos são associados automaticamente a todos usuários clientes.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Você pode gerenciar estes grupos através do parâmetro de configuração "CustomerGroupAlwaysGroups".',
        'Filter for groups' => 'Filtrar por grupos',
        'Select the customer user - group permissions.' => 'Selecione as permissões usuário cliente - grupo',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Se nada for selecionado então não existem permissões neste grupo (chamados não estarão disponíveis para o usuário cliente).',
        'Customer User Default Groups:' => 'Grupos padrão para usuários clientes:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Gerenciar Relacionamentos Usuário Cliente-Serviço',
        'Edit default services' => 'Alterar Serviços Padrão',
        'Filter for Services' => 'Filtrar por Serviços',
        'Filter for services' => 'Filtrar por Serviço',
        'Services' => 'Serviços',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Gerenciamento de Campos Dinâmicos',
        'Add new field for object' => 'Adicionar novo campo ao objeto',
        'Filter for Dynamic Fields' => 'Filtro para Campos Dinâmicos',
        'Filter for dynamic fields' => 'Filtro para campos dinâmicos',
        'New OTOBO Community  Fields' => '',
        'Would you like to benefit from additional dynamic field types? You have full access to the following field types:' =>
            '',
        'Database' => 'Banco de Dados',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Utilize bancos de dados externos como fontes de dado configuráveis para este campo dinâmico.',
        'Web service' => 'Serviço Web',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Web services externos podem ser configurados como fonte de dados para este campo dinâmico.',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Este recurso permite adicionar (multiplos) contatos com dados para chamados.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Para adicionar um novo campo, selecione o tipo de campo em uma das listas de objetos. O objeto define o domínio do campo e não pode ser alterado após a criação.',
        'Dynamic Fields List' => 'Lista de Campos Dinâmicos',
        'Dynamic fields per page' => 'Campos dinâmicos por página',
        'Label' => 'Rótulo',
        'Order' => 'Pedido',
        'Object' => 'Objeto',
        'Delete this field' => 'Remover este campo',

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
        'Dynamic Fields' => 'Campos Dinâmicos',
        'Go back to overview' => 'Ir Para Visão Geral',
        'General' => 'Geral',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Este campo é obrigatório e o valor deve ser composto apenas por caracteres alfabéticos e numéricos.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Deve ser único e só aceitar caracteres alfabéticos e numéricos.',
        'Changing this value will require manual changes in the system.' =>
            'Alterar este valor demandará alterações manuais no sistema.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Este é o nome a ser exibido nas telas onde o campo estará ativo.',
        'Field order' => 'Ordem do Campo',
        'This field is required and must be numeric.' => 'Este campo é obrigatório e deve ser numérico.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Esta é a ordem na qual este campo será exibido nas telas onde ele estará ativo.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Não é possível invalidar esta entrada. Todas as configurações têm de ser alteradas anteriormente.',
        'Field type' => 'Tipo do Campo',
        'Object type' => 'Tipo do Objeto',
        'Internal field' => 'Campo Interno',
        'This field is protected and can\'t be deleted.' => 'Este campo é protegido e não poderá ser apagado.',
        'This dynamic field is used in the following config settings:' =>
            'Este campo dinâmico é utilizado nas seguintes configurações:',
        'Field Settings' => 'Configurações do Campo',
        'Default value' => 'Valor Padrão',
        'This is the default value for this field.' => 'Este é o valor padrão para este campo.',

        # Template: AdminDynamicFieldContactWD
        'Add or edit contacts' => '',
        'To add contacts to this field please fill out all the needed information and save it.' =>
            '',
        'Click on the field name from the overview to edit it and find the corresponding action in the sidebar or from the \'Tickets\' menu.' =>
            '',
        'Name Field' => '',
        'ValidID Field' => '',
        'Other Fields' => '',
        'Key' => 'Chave',
        'Value' => 'Valor',
        'Remove value' => 'Remover Valor',
        'Add Field' => '',
        'Add value' => 'Adicionar valor',
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
        'Translatable values' => 'Valores Traduzíveis',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Se você ativar esta opção, os valores serão traduzidos para o idioma definido pelo usuário.',
        'Note' => 'Nota',
        'You need to add the translations manually into the language translation files.' =>
            'Você precisa adicionar as traduções manualmente nos arquivos de tradução.',

        # Template: AdminDynamicFieldDB
        'Possible values' => 'Valores Possíveis',
        'Datatype' => '',
        'Filter' => 'Filtro',
        'Searchfield' => '',
        'Listfield' => '',
        'Show link' => 'Mostrar Link',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Aqui você pode especificar um link HTTP para o valor deste campo nas telas de Visão Geral e Detalhamento.',
        'Example' => 'Exemplo',
        'Link for preview' => 'Link para visualização',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Se preenchida, esta URL será visualizada ao se flutuar sobre o link no zoom do chamado. Por favor note que para isto funcionar, deve-se preencher também o campo URL comum acima.',
        'SID' => 'SID',
        'Driver' => '',
        'Server' => '',
        'Port' => 'Porta',
        'Table / View' => '',
        'User' => 'Usuário',
        'Password' => 'Senha',
        'Identifier' => 'Identificador',
        'Must be unique column from the table entered in Table/View.' => '',
        'Multiselect' => 'Multisseleção',
        'CacheTTL' => '',
        'Searchprefix' => '',
        'Searchsuffix' => '',
        'Result Limit' => '',
        'Case Sensitive' => '',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Diferença de Tempo Padrão',
        'This field must be numeric.' => 'Este campo deve ser numérico.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'A diferença de AGORA (em segundos) para calcular o valor padrão do campo (ex. 3600 ou -60).',
        'Define years period' => 'Definir Período Anual',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Ative este recurso para definir uma faixa fixa de anos (no futuro e no passado) para exibir na parte anual do campo.',
        'Years in the past' => 'Anos No Passado',
        'Years in the past to display (default: 5 years).' => 'Anos no Passado a Exibir (padrão: 5 anos).',
        'Years in the future' => 'Anos no Futuro',
        'Years in the future to display (default: 5 years).' => 'Anos no Futuro a Exibir (padrão: 5 anos).',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Se carácteres especiais(&, @, :, /, etc.) não deve ser codificado, use o filtro \'url\' em vez de \'uri\'.',
        'Restrict entering of dates' => 'Restringir entrada de datas',
        'Here you can restrict the entering of dates of tickets.' => 'Aqui você pode restringir a entrada de datas de tickets.',

        # Template: AdminDynamicFieldDropdown
        'Add Value' => 'Adicionar Valor',
        'Add empty value' => 'Adicionar valor vazio',
        'Activate this option to create an empty selectable value.' => 'Ative essa opção para criar um valor vazio selecionável.',
        'Tree View' => 'Visualização em Árvore',
        'Activate this option to display values as a tree.' => 'Ativar esta opção para exibir valores como uma árvore.',

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
        'Fields' => 'Campos',
        'Screens' => '',

        # Template: AdminDynamicFieldScreen
        'Management of Dynamic Fields <-> Screens' => '',
        'Overview' => 'Visão Geral',
        'Default Columns Screens' => '',
        'Add DynamicField' => '',
        'You can assign elements to this Screen/Field by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Também é possível ordenar os elementos na lista através de drag \'n\' drop.',
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
        'Reset' => 'Reiniciar',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Número de Linhas',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Especificar a altura (em linhas) para este campo no modo de edição.',
        'Number of cols' => 'Número de Colunas',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Especificar a largura (em caracteres) para este campo no modo de edição.',
        'Check RegEx' => 'Verifique a expressão regular',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Aqui você pode especificar uma expressão regular para validar o valor. A expressão regular será executada com os modificadores xms.',
        'RegEx' => 'Expressão Regular',
        'Invalid RegEx' => 'Expressão Regular Inválida',
        'Error Message' => 'Mensagem de Erro',
        'Add RegEx' => 'Adicionar Expressão Regular',

        # Template: AdminDynamicFieldTitle
        'Template' => 'Modelo',
        'Style' => '',
        'bold' => '',
        'italic' => '',
        'underline' => '',
        'Font style of the label.' => '',
        'Size' => 'Tamanho',
        'Font size of the label.' => '',
        'Color in hex.' => '',

        # Template: AdminDynamicFieldWebService
        'This field is required' => 'Este campo é obrigatório',
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
        'Admin Message' => 'Mensagem Administrativa',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Este módulo permite aos administradores enviar mensagens para os atendentes, membros de grupo ou papel.',
        'Create Administrative Message' => 'Criar Notificação Administrativa',
        'Your message was sent to' => 'Sua mensagem foi enviada para',
        'From' => 'De',
        'Send message to users' => 'Enviar Mensagem Para Usuários',
        'Send message to group members' => 'Enviar Mensagem Para Membros de Grupo',
        'Group members need to have permission' => 'Membros de Grupo Precisam ter Permissão',
        'Send message to role members' => 'Enviar Mensagem Para Membros de Papel',
        'Also send to customers in groups' => 'Enviar também para clientes nos grupos',
        'Body' => 'Corpo',
        'Send' => 'Enviar',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Gerenciamento de Job do Agente Genérico',
        'Edit Job' => 'Editar Job',
        'Add Job' => 'Adicionar Job',
        'Run Job' => 'Executar Job',
        'Filter for Jobs' => 'Filtrar por Jobs',
        'Filter for jobs' => 'Filtrar por jobs',
        'Last run' => 'Última Execução',
        'Run Now!' => 'Executar Agora',
        'Delete this task' => 'Excluir esta Tarefa',
        'Run this task' => 'Executar esta Tarefa',
        'Job Settings' => 'Configurações de Tarefa',
        'Job name' => 'Nome da Tarefa',
        'The name you entered already exists.' => 'O nome digitado já existe.',
        'Automatic Execution (Multiple Tickets)' => 'Execução Automática (Chamados múltiplos)',
        'Execution Schedule' => 'Agenda de execução',
        'Schedule minutes' => 'Minutos Agendados',
        'Schedule hours' => 'Horas Agendadas',
        'Schedule days' => 'Dias Agendados',
        'Automatic execution values are in the system timezone.' => 'Valores de execução automáticos estão no fuso horário do sistema.',
        'Currently this generic agent job will not run automatically.' =>
            'Atualmente, essa tarefa do agente genérico não será executada automaticamente.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Para habilitar a execução automática, selecione pelo menos um valor de minutos, horas e dias!',
        'Event Based Execution (Single Ticket)' => 'Execução Baseada em Evento (Chamado Individual)',
        'Event Triggers' => 'Disparadores de evento',
        'List of all configured events' => 'Lista de todos os eventos configurados',
        'Delete this event' => 'Excluir este evento',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Adicionalmente ou alternativamente para uma execução períodica, você pode definir eventos de chamado que irão disparar esta tarefa.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Se um evento de chamado é disparado, o filtro de chamado será aplicado para verificar se o chamado combina. Só depois a tarefa é executada sobre o chamado.',
        'Do you really want to delete this event trigger?' => 'Você quer realmente excluir este disparador de evento?',
        'Add Event Trigger' => 'Adicionar disparador de evento',
        'To add a new event select the event object and event name' => 'Para adicionar um novo evento, selecione o objeto do evento e o nome do evento',
        'Select Tickets' => 'Selecionar Chamados',
        '(e. g. 10*5155 or 105658*)' => '(ex.: 10*5155 ou 105658*)',
        '(e. g. 234321)' => '(ex.: email@empresa.com.br)',
        'Customer user ID' => 'ID do Usuário Cliente',
        '(e. g. U5150)' => '(ex.: 12345654321)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Pesquisa textual completa no artigo (ex. "Mur*lo" ou "Gleyc*").',
        'To' => 'Para',
        'Cc' => 'Cópia ',
        'Service' => 'Serviço',
        'Service Level Agreement' => 'Acordo de Nível de Serviço',
        'Queue' => 'Fila',
        'State' => 'Estado',
        'Agent' => 'Agente',
        'Owner' => 'Proprietário',
        'Responsible' => 'Responsável',
        'Ticket lock' => 'Bloqueio de Chamado',
        'Dynamic fields' => 'Campos dinâmicos',
        'Add dynamic field' => '',
        'Create times' => 'Horários de criação',
        'No create time settings.' => 'Sem configurações de horário de criação',
        'Ticket created' => 'Chamado criado',
        'Ticket created between' => 'Chamado criado entre',
        'and' => 'e',
        'Last changed times' => 'Última alteração',
        'No last changed time settings.' => 'Nenhuma configuração de horário alterado restante.',
        'Ticket last changed' => 'Última edição do chamado',
        'Ticket last changed between' => 'Última alteração do chamado entre',
        'Change times' => 'Horários de alteração',
        'No change time settings.' => 'Sem configurações de horários de alteração.',
        'Ticket changed' => 'Chamado alterado',
        'Ticket changed between' => 'Chamado alterado entre',
        'Close times' => 'Horários de fechamento',
        'No close time settings.' => 'Ignorar horários de fechamento',
        'Ticket closed' => 'Chamado fechado',
        'Ticket closed between' => 'Chamado fechado entre',
        'Pending times' => 'Horários pendentes',
        'No pending time settings.' => 'Sem configuração de horário pendente',
        'Ticket pending time reached' => 'Prazo de chamado pendente expirado',
        'Ticket pending time reached between' => 'Prazo de chamado pendente expirado entre',
        'Escalation times' => 'Prazos de escalação',
        'No escalation time settings.' => 'Sem configuração de prazo de escalação',
        'Ticket escalation time reached' => 'Prazos de escalações expirado',
        'Ticket escalation time reached between' => 'Prazos de escalação expirado entre',
        'Escalation - first response time' => 'Escalação - prazo da resposta inicial',
        'Ticket first response time reached' => 'Prazo de resposta inicial expirado',
        'Ticket first response time reached between' => 'Prazo de resposta inicial expirado entre',
        'Escalation - update time' => 'Escalação - prazo de atualização',
        'Ticket update time reached' => 'Prazo de atualização expirado',
        'Ticket update time reached between' => 'Prazo de atualização expirado entre',
        'Escalation - solution time' => 'Escalação - prazo de solução',
        'Ticket solution time reached' => 'Prazo de solução expirado',
        'Ticket solution time reached between' => 'Prazo de solução expirado entre',
        'Archive search option' => 'Opção de pesquisa de arquivo',
        'Update/Add Ticket Attributes' => 'Alterar/Adicionar Atributos do Chamado',
        'Set new service' => 'Configurar novo serviço',
        'Set new Service Level Agreement' => 'Configurar novo Acordo de Nível de Serviço',
        'Set new priority' => 'Configurar Nova Prioridade',
        'Set new queue' => 'Configurar Nova Fila',
        'Set new state' => 'Configurar Novo Estado',
        'Pending date' => 'Data de Pendência',
        'Set new agent' => 'Configurar Novo Agente',
        'new owner' => 'Novo Proprietário',
        'new responsible' => 'Novo Responsável',
        'Set new ticket lock' => 'Configurar Novo Bloqueio de Chamado',
        'New customer user ID' => 'Novo ID de Usuário Cliente',
        'New customer ID' => 'Novo ID de Cliente',
        'New title' => 'Novo Título',
        'New type' => 'Novo Tipo',
        'Archive selected tickets' => 'Arquivar chamados selecionados',
        'Add Note' => 'Adicionar Nota',
        'Visible for customer' => 'Visível para o Cliente',
        'Time units' => 'Unidades de tempo',
        'Execute Ticket Commands' => 'Executar Comandos de Chamado',
        'Send agent/customer notifications on changes' => 'Enviar Notificações de Alterações Para Agente/Cliente',
        'CMD' => 'Comando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Este comando será executado. ARG[0] será o número do chamado. ARG[1] o ID do chamado.',
        'Delete tickets' => 'Excluir Chamados',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Atenção: Todos os chamados afetados serão removidos do banco de dados e não poderão ser restaurados!',
        'Execute Custom Module' => 'Executar Módulo Personalizado',
        'Param %s key' => 'Parâmetro Chave %s',
        'Param %s value' => 'Valor do Parâmetro %s',
        'Results' => 'Resultados',
        '%s Tickets affected! What do you want to do?' => '%s chamados afetados! O que você quer fazer?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Atenção: Você usou a opção EXCLUIR. Todos os chamados excluídos serão perdidos!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Atenção: Existem %s tickets afetados mas apenas %s podem ser modificados durante a execução de um job!',
        'Affected Tickets' => 'Chamados Afetados',
        'Age' => 'Idade',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Gerenciamento de Web Service da Interface Genérica',
        'Web Service Management' => 'Gerenciamento de Web Service',
        'Debugger' => 'Depurador',
        'Go back to web service' => 'Voltar para web service',
        'Clear' => 'Limpar',
        'Do you really want to clear the debug log of this web service?' =>
            'Você realmente deseja excluir o registro de depuração deste serviço web?',
        'Request List' => 'Lista de Requisições',
        'Time' => 'Hora',
        'Communication ID' => 'ID da Comunicação',
        'Remote IP' => 'IP Remoto',
        'Loading' => 'Carregando...',
        'Select a single request to see its details.' => 'Selecione uma única requisição para ver os seus detalhes.',
        'Filter by type' => 'Filtrar por tipo',
        'Filter from' => 'Filtrar de',
        'Filter to' => 'Filtrar para',
        'Filter by remote IP' => 'Filtrar por IP remoto',
        'Limit' => 'Limite',
        'Refresh' => 'Atualizar',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Adicionar Tratamento de Erros',
        'Edit ErrorHandling' => 'Editar Tratamento de Erros',
        'Do you really want to delete this error handling module?' => 'Você quer realmente excluir este módulo de tratamento de erros?',
        'All configuration data will be lost.' => 'Todos os dados de configuração serão perdidos.',
        'General options' => 'Opções gerais',
        'The name can be used to distinguish different error handling configurations.' =>
            'O nome pode ser utilizado para distinguir entre diferentes configurações de tratamento de erros.',
        'Please provide a unique name for this web service.' => 'Por favor, forneça um único nome para este web service.',
        'Error handling module backend' => 'Backend do módulo de tratamento de erros',
        'This OTOBO error handling backend module will be called internally to process the error handling mechanism.' =>
            'Este módulo de backend para tratamento de erros será chamado internamente para processar o mecanismo de tratamento de erros.',
        'Processing options' => 'Opções de processamento',
        'Configure filters to control error handling module execution.' =>
            'Configure filtros para controlar a execução do módulo de tratamento de erros.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Somente requisições que contenham todos os filtros configurados (se algum) irá disparar a execução do módulo.',
        'Operation filter' => 'Filtro de operação',
        'Only execute error handling module for selected operations.' => 'Somente execute o módulo de tratamento de erros para as operações selecionadas.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Nota: Operação é indeterminada para erros ocorridos ao receber requisição de dados de entrada. Filtros envolvendo este estágio de erro não devem utilizar filtro de operação.',
        'Invoker filter' => 'Filtro invocador.',
        'Only execute error handling module for selected invokers.' => 'Execute apenas o módulo de tratamento de erros para pessoas invocadas selecionadas.',
        'Error message content filter' => 'Filtro de conteúdo da mensagem de erro',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Insira uma expressão regular para restringir quais mensagens de erro devem causar a execução do módulo de gerenciamento de erros.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Erro assunto da mensagem e dados (como visto na entrada de erro do depurador) serão considerados para uma correspondência.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Exemplo: Digite \'^.*401 Unauthorized.*\$\' para manipular somente erros relacionados à autenticação.',
        'Error stage filter' => 'Erro filtro de estágio',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Só execute o módulo de manipulação de erros em erros que ocorrem durante estágios de processamento específicos.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Exemplo: Manipular somente erros em que o mapeamento de dados de saída não pôde ser aplicado.',
        'Error code' => 'Código de erro',
        'An error identifier for this error handling module.' => 'Um identificador de erro para este módulo de tratamento de erros.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Este identificador estará disponível no mapeamento XSLT (XSLT-Mapping) e será mostrado na console de debug',
        'Error message' => 'Mensagem de erro',
        'An error explanation for this error handling module.' => 'Uma explicação de erro para este módulo de tratamento de erros.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Esta mensagem estará disponível no XSLT-Mapping e mostrado saída do debugger.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Define se o processamento deve ser parado após a execução do módulo, ignorando todos os módulos restantes ou apenas os do mesmo back-end.',
        'Default behavior is to resume, processing the next module.' => 'O comportamento padrão é continuar, processando o próximo módulo.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Este módulo permite configurar novas tentativas agendadas para solicitações com falha.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'O comportamento padrão dos webservices da Interface Genérica é enviar exatamente uma vez a cada solicitação sem reagendar após erros.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Se mais do que um módulo capaz de agendar uma nova tentativa é executado por uma solicitação individual, o módulo executado por último é autoritativo e determina se uma nova tentativa é agendada.',
        'Request retry options' => 'Solicitar opções de repetição',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Opções de nova tentativa são aplicadas quando solicitações causam a execução do módulo de tratamento de erros (baseado nas opções de processamento).',
        'Schedule retry' => 'Programar nova tentativa',
        'Should requests causing an error be triggered again at a later time?' =>
            'Os pedidos que causam erro devem ser acionados novamente mais tarde?',
        'Initial retry interval' => 'Intervalo inicial de repetição',
        'Interval after which to trigger the first retry.' => 'Intervalo após o qual disparar a primeira tentativa.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Nota: Esse e todos os futuros intervalos de nova tentativa são baseados no momento de execução do módulo de tratamento de erros para a solicitação inicial.',
        'Factor for further retries' => 'Fator para novas tentativas',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Se uma solicitação retorna um erro mesmo depois de uma primeira nova tentativa, defina se novas tentativas subsequentes são disparadas usando o mesmo intervalo ou em intervalos crescentes.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Exemplo: Se uma solicitação é inicialmente disparada às 10:00 com intervalo inicial em \'1 minuto\' e fator de nova tentativa em \'2\', novas tentativas seriam disparadas às 10:01 (1 minuto), 10:03 (2*1=2 minutos), 10:07 (2*2=4 minutos), 10:15 (2*4=8 minutos), ...',
        'Maximum retry interval' => 'Intervalo de repetição máximo',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Se um fator de intervalo de nova tentativa de \'1.5\' ou \'2\' está selecionado, intervalos desagradavelmente longos podem ser prevenidos definindo o maior intervalo permitido.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Intervalos calculados para exceder o intervalo máximo de nova tentativa serão então automaticamente encurtados convenientemente.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Exemplo: Se uma solicitação for inicialmente acionada às 10:00 com intervalo inicial em \'1 minuto\', fator de nova tentativa em \'2\' e intervalo máximo em \'5 minutos\', as novas tentativas serão acionadas às 10:01 (1 minuto), 10 : 03 (2 minutos), 10:07 (4 minutos), 10:12 (8 => 5 minutos), 10:17, ...',
        'Maximum retry count' => 'Contagem máxima de repetição',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Número máximo de tentativas antes do descarte de uma requisição falhada, sem contar a requisição inicial',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Exemplo: Se uma solicitação for inicialmente acionada às 10:00 com intervalo inicial em \'1 minuto\', fator de nova tentativa em \'2\' e contagem máxima de novas tentativas em \'2\', as novas tentativas serão acionadas somente às 10h01 e 10h02.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Nota: A contagem máxima de novas tentativas pode não ser atingida se um período máximo de novas tentativas também for configurado e alcançado anteriormente.',
        'This field must be empty or contain a positive number.' => 'Este campo deve ficar vazio ou conter um número positivo.',
        'Maximum retry period' => 'Período máximo de repetição',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Período máximo de tempo para novas tentativas de solicitações que falharam antes de serem descartadas (com base no tempo de execução do módulo de tratamento de erros para a solicitação inicial).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Tentativas que normalmente seriam acionadas após o término do período máximo (de acordo com o cálculo do intervalo de nova tentativa) serão acionadas automaticamente no período máximo.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Exemplo: Se uma solicitação for inicialmente acionada às 10:00 com intervalo inicial em \'1 minuto\', fator de nova tentativa em \'2\' e período máximo de nova tentativa em \'30 minutos \', as novas tentativas serão acionadas às 10:01, 10:03, 10:07, 10:15 e finalmente às 10: 31 => 10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Nota: O período máximo de nova tentativa pode não ser atingido se uma contagem máxima de novas tentativas também for configurada e atingida anteriormente.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Adicionar Invocador',
        'Edit Invoker' => 'Editar Invocador',
        'Do you really want to delete this invoker?' => 'Você deseja realmente excluir este invoker?',
        'Invoker Details' => 'Detalhes do invoker',
        'The name is typically used to call up an operation of a remote web service.' =>
            'O nome é comumente usado para chamar uma operação de um web service remoto.',
        'Invoker backend' => 'Backend do Invocador',
        'This OTOBO invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Este módulo de backend do invoker do OTOBO será chamado para preparar os dados que serão enviados para o sistema remoto, e para processar os dados da resposta.',
        'Mapping for outgoing request data' => 'Mapeamento para os dados de saída da requisição.',
        'Configure' => 'Configurar',
        'The data from the invoker of OTOBO will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os dados do invoker do OTOBO serão processados através deste mapeamento, para transformá-los no tipo de dados esperado pelo sistema remoto.',
        'Mapping for incoming response data' => 'Mapeamento para os dados de chegada da resposta.',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTOBO expects.' =>
            'Os dados da resposta serão processados através deste mapeamento, para transformá-los no tipo de dados esperado pelo invoker do OTOBO.',
        'Asynchronous' => 'Assíncrono',
        'Condition' => 'Condição',
        'Edit this event' => 'Editar este evento',
        'This invoker will be triggered by the configured events.' => 'Este invoker será disparado atráves dos eventos configurados.',
        'Add Event' => 'Adicionar Evento',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Para adicionar um novo evento, selecione um objeto de evento e um nome e clique no botão "+"',
        'Asynchronous event triggers are handled by the OTOBO Scheduler Daemon in background (recommended).' =>
            'Gatilhos de eventos asíncronos são tratados pelo OTOBO Scheduler Daemon em segundo plano (recomendado).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Gatilhos (dispadores) de eventos síncronos precisam ser processados diretamente durante a requisição web.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '%sConfigurações de evento Invoker Interface Generica e para Web Service',
        'Go back to' => 'Voltar para',
        'Delete all conditions' => 'Excluir todas as condições',
        'Do you really want to delete all the conditions for this event?' =>
            'Você realmente quer excluir todas as condições para este evento?',
        'General Settings' => 'Configurações gerais',
        'Event type' => 'Tipo de Evento',
        'Conditions' => 'Condições',
        'Conditions can only operate on non-empty fields.' => 'Condições podem operar somente em campos não vazios.',
        'Type of Linking between Conditions' => 'Tipo de Ligação Entre as Condições',
        'Remove this Condition' => 'Remover Esta Condição',
        'Type of Linking' => 'Tipo de Ligação',
        'Add a new Field' => 'Adicionar Novo Campo',
        'Remove this Field' => 'Remover Este Campo',
        'And can\'t be repeated on the same condition.' => 'E não pode ser repetido na mesma condição.',
        'Add New Condition' => 'Adicionar Nova Condição',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Mapeamento Simple',
        'Default rule for unmapped keys' => 'Regra padrão para chaves não mapeadas',
        'This rule will apply for all keys with no mapping rule.' => 'Esta regra se aplica para todas as chaves sem regra de mapeamento',
        'Default rule for unmapped values' => 'Regra padrão para valores não mapeados.',
        'This rule will apply for all values with no mapping rule.' => 'Esta regra será aplicada para todos os valores sem regra de mapeamento.',
        'New key map' => 'Novo mapa de chave',
        'Add key mapping' => 'Adicionar mapeamento de chave',
        'Mapping for Key ' => 'Mapeamento por Chave',
        'Remove key mapping' => 'Remover mapeamento de chave',
        'Key mapping' => 'Chave mapeada',
        'Map key' => 'Chave de mapa',
        'matching the' => 'correspondendo ao',
        'to new key' => 'para nova chave',
        'Value mapping' => 'Mapeamento de valor',
        'Map value' => 'Valor de mapa',
        'to new value' => 'para novo valor',
        'Remove value mapping' => 'Remover mapeamento de valor',
        'New value map' => 'Novo mapa de valor',
        'Add value mapping' => 'Adiciona mapeamento de valor',
        'Do you really want to delete this key mapping?' => 'Você realmente deseja excluir este mapeamento de chaves?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Atalhos Genéricos',
        'MacOS Shortcuts' => 'Atalhos para MacOS',
        'Comment code' => 'Comentar Código',
        'Uncomment code' => 'Descomentar Código',
        'Auto format code' => 'Auto formatar código',
        'Expand/Collapse code block' => 'Expandir/Colapsar bloco de código',
        'Find' => 'Localizar',
        'Find next' => 'Localizar próximo',
        'Find previous' => 'Localizar anterior',
        'Find and replace' => 'Localizar e substituir',
        'Find and replace all' => 'Localizar e substituir todos',
        'XSLT Mapping' => 'Mapeamento XSLT',
        'XSLT stylesheet' => 'Folha de estilo XSLT',
        'The entered data is not a valid XSLT style sheet.' => 'Os dados inseridos não são uma folha de estilos XSLT válida.',
        'Here you can add or modify your XSLT mapping code.' => 'Os dados inseridos não são uma folha de estilo XSLT válida.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'O campo de edição permite que você use diferentes funções como formatação automática, redimensionamento de janela, bem como preenchimento de tags e colchetes.',
        'Data includes' => 'Dados incluem',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Selecione um ou mais conjuntos de dados que foram criados em estágios anteriores de solicitação/resposta para serem incluídos nos dados mapeáveis.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Esses conjuntos aparecerão na estrutura de dados em \'/ DataInclude /<DataSetName>\' (consulte a saída do depurador de solicitações reais para obter detalhes).',
        'Data key regex filters (before mapping)' => 'Filtros de regex de chave de dados (antes do mapeamento)',
        'Data key regex filters (after mapping)' => 'Filtros de regex de chave de dados (após o mapeamento)',
        'Regular expressions' => 'Expressões regulares',
        'Replace' => 'Substituir',
        'Remove regex' => 'Remover Expressão Regular',
        'Add regex' => 'Adicionar Expressão Regular',
        'These filters can be used to transform keys using regular expressions.' =>
            'Estes filtros podem ser usados para transformar chaves usando expressão regular.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'A estrutura de dados será percorrida recursivamente e todos os regexes configurados serão aplicados a todas as chaves.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Casos de uso são, por exemplo, na remoção de prefixos de chave que são indesejáveis ou na correção de chaves que são inválidas como nomes de elementos XML.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Exemplo 1: Pesquisar = \'^jira:\' / Susbtituir = \'\' transforma \'jira:element\' em \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Exemplo 2: Pesquisar = \'^\' / Substituir = \'_\' torna \'16x16\' em \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Exemplo 3: Pesquisar = \'^(?<number>\d+) (?<text>.+?)\$\' / Substituir = \'_\$+{text}_\$+{number}\' torna \'16 elementname\' em \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'Para informações sobre expressões regulares em Perl, por favor, veja aqui:',
        'Perl regular expressions tutorial' => 'Tutorial de Expressões Regulares Perl',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Se modificadores forem desejados, eles devem ser especificados dentro das expressões regulares.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Expressões regulares definidas aqui serão aplicadas antes do mapeamento XSLT.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Expressões regulares definidas aqui serão aplicadas após o mapeamento XSLT.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Adicionar Operação',
        'Edit Operation' => 'Editar Operação',
        'Do you really want to delete this operation?' => 'Você realmente deseja excluir esta operação?',
        'Operation Details' => 'Detalhes da Operação',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'O nome é normalmente usado para chamar esta operação de web service a partir de um sistema remoto.',
        'Operation backend' => 'Backend de operação',
        'This OTOBO operation backend module will be called internally to process the request, generating data for the response.' =>
            'Este módulo de backend de operação do OTOBO será chamado internamente para processar a requisição, gerando dados para a resposta',
        'Mapping for incoming request data' => 'Mapeamento para dados de chegada da requisição',
        'The request data will be processed by this mapping, to transform it to the kind of data OTOBO expects.' =>
            'Os dados requisitados serão processados por este mapeamento, para transformá-los no tipo de dados esperado pelo OTOBO.',
        'Mapping for outgoing response data' => 'Mapeamento para os dados de saída da resposta',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Os dados da resposta serão processados por este mapeamento, para transformá-los no tipo de dados esperados pelo sistema remoto.',
        'Include Ticket Data' => 'Incluir dados do chamado',
        'Include ticket data in response.' => 'Incluir dados do ticket na resposta.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Transporte de rede',
        'Properties' => 'Propriedades',
        'Route mapping for Operation' => 'Mapeamento da rota para a operação',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Defina a rota que precisa ser mapeada para esta operação. Variáveis marcadas com um \':\' serão mapeadas para o nome de entrada e repassadas com as demais para o mapeamento (ex.: /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Métodos de requisição válidos para a operação',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Limita esta operação para métodos de requisição específicos. Se nenhum método for selecionado, todas as requisições serão aceitas.',
        'Maximum message length' => 'Tamanho máximo da mensagem',
        'This field should be an integer number.' => 'O campo deve ser um valor inteiro.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTOBO will process.' =>
            'Aqui você pode especificar o tamanho máximo (em bytes) das mensagens REST que o OTOBO vai processar.',
        'Send Keep-Alive' => 'Enviar Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Esta configuração define se conexões de entrada devem ficar fechadas ou permanecerem abertas.',
        'Additional response headers' => 'Cabeçalhos de resposta adicionais',
        'Add response header' => 'Adicionar cabeçalho de resposta',
        'Endpoint' => 'Endpoint',
        'URI to indicate specific location for accessing a web service.' =>
            'URI que indica a localização específica para acessar um webservice.',
        'e.g https://www.otobo.ch:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Timeout' => 'Expiração',
        'Timeout value for requests.' => 'Valor de timeout para requisições.',
        'Authentication' => 'Autenticação',
        'An optional authentication mechanism to access the remote system.' =>
            'Um mecanismo opcional de autenticação para acessar o sistema remoto.',
        'BasicAuth User' => 'Usuário BasicAuth ',
        'The user name to be used to access the remote system.' => 'Nome de usuário para acesso ao sistema remoto.',
        'BasicAuth Password' => 'Senha BasicAuth',
        'The password for the privileged user.' => 'A senha para o usuário privilegiado.',
        'Use Proxy Options' => 'Usar Configurações de Proxy',
        'Show or hide Proxy options to connect to the remote system.' => 'Mostrar ou ocultar opções de Proxy para conectar ao sistema remoto.',
        'Proxy Server' => 'Servidor Proxy',
        'URI of a proxy server to be used (if needed).' => 'URL do servidor proxy (se necessário).',
        'e.g. http://proxy_hostname:8080' => 'ex. http://proxy_hostname:8080',
        'Proxy User' => 'Usuário do Servidor Proxy',
        'The user name to be used to access the proxy server.' => 'O nome de usuário usado para acesso ao servidor proxy.',
        'Proxy Password' => 'Senha do Servidor Proxy',
        'The password for the proxy user.' => 'A senha do usuário usado para acesso ao servidor proxy',
        'Skip Proxy' => 'Pular Proxy',
        'Skip proxy servers that might be configured globally?' => 'Pular servidores proxy que podem ser configurados globalmente?',
        'Use SSL Options' => 'Usar opções de SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Exibir ou ocultar as opções SSL para conectar ao sistema remoto.',
        'Client Certificate' => 'Certificado do Cliente',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'O caminho completo o o nome do certificado cliente SSL (deve ser no formato PEM, DER ou PKCS#12)',
        'e.g. /opt/otobo/var/certificates/SOAP/certificate.pem' => 'ex. /opt/otobo/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Chave do Certificado do Cliente',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'O caminho completo e o nome do arquivo de chave do certificado de cliente SSL (se ainda não estiver incluído no arquivo de certificado).',
        'e.g. /opt/otobo/var/certificates/SOAP/key.pem' => 'ex. /opt/otobo/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Senha da Chave de Certificado do Cliente',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'A senha para abrir o certificado SSL se a chave está encriptada.',
        'Certification Authority (CA) Certificate' => 'Certificado da Autoridade Certificadora (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'O caminho completo e nome do arquivo do certificado da autoridade certificadora que valida o certificado SSL.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA/ca.pem' => 'ex. /opt/otobo/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Diretório da Autoridade Certificadora (AC)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'O caminho completo do diretório da autoridade certificadora onde os certificados AC serão armazenados no sistema de arquivos.',
        'e.g. /opt/otobo/var/certificates/SOAP/CA' => 'ex. /opt/otobo/var/certificates/SOAP/CA',
        'SSL hostname verification.' => '',
        'Abort the request if the hostname cannot be verified. Disable with caution! Skipping verification is a security risk! Mainly for testing purposes in case of self-signed SSL certificates, or if you know what you are doing.' =>
            '',
        'Controller mapping for Invoker' => 'Mapeamento do controlador para o invoker',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'O controlador para o qual o invoker necessita enviar requisições. Variáveis marcadas com um \':\' serão substituídas pelos valores dos dados e repassadas com a requisição (ex.: /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Comando válido da requisição para o invoker',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Um comando HTTP específico para usar para as requisições com este invoker (opcional).',
        'Default command' => 'Comando padrão',
        'The default HTTP command to use for the requests.' => 'O comando HTTP padrão para usar para as requisições.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'ex. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Configurar SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Defina para "Sim" em ordem para enviar um cabeçalho SOAPAction preenchido.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Defina para "Não" em ordem para enviar um cabeçalho SOAPAction vazio.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Selecione "Sim" para checar o cabeçalho SOAPAction recebido (sem não estiver vazio).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Selecione "Não" para ignorar o cabeçalho SOAPAction recebido.',
        'SOAPAction scheme' => 'Esquema SOAPAction ',
        'Select how SOAPAction should be constructed.' => 'Selecione como deverá ser construído o SOAPAction ',
        'Some web services require a specific construction.' => 'Alguns web services requerem uma construção específica.',
        'Some web services send a specific construction.' => 'Alguns web services enviam uma construção específica.',
        'SOAPAction separator' => 'Separador SOAPAction',
        'Character to use as separator between name space and SOAP operation.' =>
            'Caractere a ser utilizado como separador entre espaço de nome e operação SOAP.',
        'Usually .Net web services use "/" as separator.' => 'Usualmente webservices .Net utilizam "/" como separador.',
        'SOAPAction free text' => 'Texto livre  SOAPAction',
        'Text to be used to as SOAPAction.' => 'Texto a ser usado no SOAPAction',
        'Namespace' => 'Namespace',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI de contexto dos métodos SOAP, reduzindo ambiguidades.',
        'e.g urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'ex.: urn:otobo-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Solicita esquema de nome',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Seleciona como o encapsulador da função de solicitação SOAP precisa ser construído.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' é usado como exemplo para o verdadeiro nome de invoker/operation.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' é usado como exemplo para o real valor configurado.',
        'Request name free text' => 'Texto livre do nome da requisição',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Texto a ser usado como sufixo ou substituto de nome da função de encapsulamento.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Por favor considere as restrições para nomeação de elementos XML (ex.: não use \'<\' e \'&\').',
        'Response name scheme' => 'Esquema de nome da resposta',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Selecione como a função de encapsulamento da resposta SOAP precisa ser construída.',
        'Response name free text' => 'Nome da resposta free text',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTOBO will process.' =>
            'Aqui você pode especificar o tamanho máximo (em bytes) das mensagens SOAP que o OTOBO vai processar.',
        'Encoding' => 'Codificação',
        'The character encoding for the SOAP message contents.' => 'A codificação de caracteres para o conteúdo da mensagem SOAP.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'ex.: utf-8, latin1, iso-8859-1, cp1250 etc.',
        'Sort options' => 'Ordenar opções',
        'Add new first level element' => 'Adicionar novo elemento de primeiro nível',
        'Element' => 'Elemento',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Sentido de ordenação de saída para campos xml (começo da estrutura abaixo do encapsulamento de nome de função) - veja documentação sobre transporte SOAP.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Adicionar Serviço Web',
        'Edit Web Service' => 'Editar Serviço Web',
        'Clone Web Service' => 'Clonar Serviço Web',
        'The name must be unique.' => 'O nome deve ser único',
        'Clone' => 'Clonar',
        'Export Web Service' => 'Exportar Web Service',
        'Import web service' => 'Importar Web Service',
        'Configuration File' => 'Arquivo de Configuração',
        'The file must be a valid web service configuration YAML file.' =>
            'O arquivo deve ser uma configuração YAML válido.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Aqui você pode especificar um nome para o webservice. Se o campo estiver em branco, o nome do arquivo de configuração é utilizado como nome.',
        'Import' => 'Importar',
        'Configuration History' => 'Histórico de configuração',
        'Delete web service' => 'Apagar Web Service',
        'Do you really want to delete this web service?' => 'Você realmente deseja apagar este web service?',
        'Ready2Adopt Web Services' => 'Webservices Ready2Adopt',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Por favor note que estes web services podem depender de outros módulos disponíveis apenas com certos %s níveis de contrato (haverá uma notificação com maiores detalhes quando da importação).',
        'Import Ready2Adopt web service' => 'Importar web service Ready2Adopt ',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Após salvar as configuração você será redirecionado novamente para a tela de edição.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Se você deseja retornar para a visão geral, clique no botão "Ir para a visão geral"',
        'Remote system' => 'Sistema Remoto',
        'Provider transport' => 'Transporte Provedor',
        'Requester transport' => 'Transporte Requisitante',
        'Debug threshold' => 'Tipo de Debug',
        'In provider mode, OTOBO offers web services which are used by remote systems.' =>
            'No modo provedor, o OTOBO oferece um web service para ser utilizado por sistemas remotos.',
        'In requester mode, OTOBO uses web services of remote systems.' =>
            'No modo requisitante, o OTOBO usa web services de sistemas remotos.',
        'Network transport' => 'Transporte de Rede',
        'Error Handling Modules' => 'Módulos de tratamento de erros',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Módulos de tratamento de erros são utilizados para reagir em casos de erros durante a comunicação. Estes módulos são executados em uma ordem específica, que pode ser alterada ao arrastar e soltar.',
        'Backend' => 'Backend',
        'Add error handling module' => 'Adicionar módulo de tratamento de erros',
        'Operations are individual system functions which remote systems can request.' =>
            'Operações são funções individuais do sistema que podem ser requisitadas pelo sistema remoto.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invocadores prepararam os dados para um pedido de um web service remoto, e processam os dados de sua resposta.',
        'Controller' => 'Controlador',
        'Inbound mapping' => 'Mapeamento de entrada',
        'Outbound mapping' => 'Mapeamento de saída',
        'Delete this action' => 'Excluir esta ação',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Pelo menos um %s tem um controlador que ou não está ativo ou não está presente, por favor verifique o registro do controlador ou exclua o %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Histórico',
        'Go back to Web Service' => 'Voltar para Web Service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Aqui você pode visualizar as versões anteriores da configuração do web service corrente, exportar ou até restaurá-las.',
        'Configuration History List' => 'Lista de histórico da configuração',
        'Version' => 'Versão',
        'Create time' => 'Data de criação',
        'Select a single configuration version to see its details.' => 'Selecione apenas uma versão de configuração para ver seus detalhes.',
        'Export web service configuration' => 'Exportar configuração do web service',
        'Restore web service configuration' => 'Restaurar configuração do web service',
        'Do you really want to restore this version of the web service configuration?' =>
            'Você realmente deseja restaurar esta versão da configuração do web service?',
        'Your current web service configuration will be overwritten.' => 'A sua configuração corrente do web service será sobrescrita.',

        # Template: AdminGroup
        'Group Management' => 'Administração de Grupos',
        'Add Group' => 'Adicionar Grupo',
        'Edit Group' => 'Alterar Grupo',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'O grupo admin é para uso na área de administração e o grupo stats é para uso na área de estatísticas.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Crie novos grupos para manusear diferentes permissões de acesso para diferentes grupos de atendentes (ex. compras, produção, vendas...).',
        'It\'s useful for ASP solutions. ' => 'Isso é útil para soluções ASP.',

        # Template: AdminLog
        'System Log' => 'Eventos do Sistema',
        'Here you will find log information about your system.' => 'Aqui você vai encontrar informações sobre eventos do seu sistema.',
        'Hide this message' => 'Esconder esta mensagem',
        'Recent Log Entries' => 'Entradas Recentes de Log',
        'Facility' => 'Instalação',
        'Message' => 'Mensagem',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Gerenciamento de Contas de E-mail',
        'Add Mail Account' => 'Adicionar Conta de E-mail',
        'Edit Mail Account for host' => 'Editar Conta de E-mail para o host',
        'and user account' => 'e conta de usuário',
        'Filter for Mail Accounts' => 'Filtrar por Contas de E-mail',
        'Filter for mail accounts' => 'Filtrar por contas de e-mail',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Todas entradas de e-mail com uma conta irá ser despachadas na fila selecionada.',
        'If your account is marked as trusted, the X-OTOBO headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Se sua conta está marcada como verdadeira, os cabeçalhos X-OTOBO já existentes no tempo de chegada (por prioridade, etc.) serão mantidos e usados, por exemplo, em filtros PostMaster.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'E-mail enviado pode ser configurado nas definições de Sendmail* em %s.',
        'System Configuration' => 'Configuração do Sistema',
        'Host' => 'Servidor',
        'Delete account' => 'Excluir conta',
        'Fetch mail' => 'Obter E-mails',
        'Do you really want to delete this mail account?' => 'Você realmente quer excluir esta conta de e-mail?',
        'Example: mail.example.com' => 'Exemplo: mail.exemplo.com',
        'IMAP Folder' => 'Pasta IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Apenas modifique aqui se você deseja obter e-mails de uma pasta diferente que INBOX.',
        'Trusted' => 'Confiável',
        'Dispatching' => 'Despachando',
        'Edit Mail Account' => 'Alterar conta de e-mail',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Visão Geral da Administração',
        'Filter for Items' => 'Filtro para Itens',
        'Favorites' => 'Favoritos',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Você pode adicionar favoritos, movendo o cursor sobre os itens do lado direito e clicando no ícone da estrela.',
        'Links' => 'Links',
        'View the admin manual on Github' => 'Veja o manual de administração no Github',
        'No Matches' => 'Sem resultados',
        'Sorry, your search didn\'t match any items.' => 'Desculpe, sua pesquisa não retornou nenhum item.',
        'Set as favorite' => 'Definir como favorito',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Gerenciamento de notificação de chamados',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Aqui você pode fazer upload de um arquivo de configuração para importar Notificações de Chamados para seu sistema. O arquivo deve estar no formato .yml como exportado pelo módulo de Notificação de Chamados.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Aqui você pode escolher quais eventos serão acionados por esta notificação. Um filtro de chamado adicional pode ser aplicado para enviar apenas para o chamado com determinados critérios.',
        'Ticket Filter' => 'Filtro de Chamado',
        'Lock' => 'Bloquear',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID de usuário cliente',
        'Article Filter' => 'Filtro de Artigo',
        'Only for ArticleCreate and ArticleSend event' => 'Apenas para os eventos ArticleCreate e ArticleSend',
        'Article sender type' => 'Tipo de Remetente do Artigo',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Se ArticleCreate ou ArticleSend for usado como evento de disparo, você precisa especificar também um filtro de artigo. Por favor selecione pelo menos um dos campos de filtro de artigo.',
        'Customer visibility' => 'Visibilidade do cliente',
        'Communication channel' => 'Canal de comunicação',
        'Include attachments to notification' => 'Incluir Anexos na Notificação',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Notificar usuário apenas uma vez por dia sobre um chamado simples usando um transporte selecionado.',
        'This field is required and must have less than 4000 characters.' =>
            'Este campo é obrigatório e deve ter menos do que 4000 caracteres.',
        'Notifications are sent to an agent or a customer.' => 'Notificações serão enviadas para um Atendente ou Cliente.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do atendente)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do atendente)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Para buscar os primeiros 20 caracteres do assunto (do último artigo do cliente)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Para buscar as primeiras 5 linhas do corpo (do último artigo do cliente)',
        'Attributes of the current customer user data' => 'Atributos  de dados do usuário cliente atual',
        'Attributes of the current ticket owner user data' => 'Atributos de dados do usuário atual proprietário do chamado',
        'Attributes of the current ticket responsible user data' => 'Atributos de dados do usuário atual responsável pelo chamado',
        'Attributes of the current agent user who requested this action' =>
            'Atributos do usuário agente atual que solicitaram esta ação',
        'Attributes of the ticket data' => 'Atributos dos dados do chamado',
        'Ticket dynamic fields internal key values' => 'Chave de valores interna dos campos dinâmicos do chamado',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Campos dinâmicos bilhete exibem valores, útil para campos do tipo Dropdown e Multiselect',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Use vírgula ou aspas para separar emails.',
        'You can use OTOBO-tags like <OTOBO_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Você pode utilizar OTOBO-tags como <OTOBO_TICKET_DynamicField_...> para inserir valores do chamado atual.',

        # Template: AdminPGP
        'PGP Management' => 'Gerenciamento do PGP',
        'Add PGP Key' => 'Adicionar Chave PGP',
        'PGP support is disabled' => 'Suporte a PGP desabilitado',
        'To be able to use PGP in OTOBO, you have to enable it first.' =>
            'Para poder usar PGP no OTOBO, você precisa ativar isto primeiro.',
        'Enable PGP support' => 'Habilitar suporte a PGP',
        'Faulty PGP configuration' => 'Erro na configuração de PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Suporte a PGP está habilitado, mas a configuração contém erros. Por favor verifique a configuração usando o botão abaixo.',
        'Configure it here!' => 'Configure aqui',
        'Check PGP configuration' => 'Checar configuração de PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Neste caso, você pode editar diretamente o "keyring" configurado no "SysConfig".',
        'Introduction to PGP' => 'Introdução ao PGP',
        'Bit' => 'Bit',
        'Fingerprint' => 'Impressão Digital',
        'Expires' => 'Expira',
        'Delete this key' => 'Excluir esta chave',
        'PGP key' => 'Chave PGP',

        # Template: AdminPackageManager
        'Package Manager' => 'Gerenciador de Pacotes',
        'Uninstall Package' => 'Desinstalar Pacote',
        'Uninstall package' => 'Desinstalar Pacote',
        'Do you really want to uninstall this package?' => 'Você quer realmente desinstalar este pacote?',
        'Reinstall package' => 'Reinstalar Pacote',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Você realmente quer reinstalar este pacote? Quaisquer alterações manuais serão perdidas.',
        'Go to updating instructions' => 'Vá para instruções de atualização',
        'Go to the OTOBO customer portal' => 'Vá para o portal de clientes do OTOBO',
        'package information' => 'informação do pacote',
        'Package installation requires a patch level update of OTOBO.' =>
            'Pacote de Instalação requer atualização do OTOBO',
        'Package update requires a patch level update of OTOBO.' => 'Atualização do pacote requer atualização de nível do OTOBO',
        'Please note that your installed OTOBO version is %s.' => 'Por favor note que a sua versão do OTOBO instalada é %s.',
        'To install this package, you need to update OTOBO to version %s or newer.' =>
            'Para instalar este pacote, você precisa atualizar seu OTOBO para versão %s ou superior.',
        'This package can only be installed on OTOBO version %s or older.' =>
            'Este pacote smente pode ser instalado na versão %s ou inferior do OTOBO.',
        'This package can only be installed on OTOBO version %s or newer.' =>
            'Este pacote smente pode ser instalado na versão %s ou superior do OTOBO.',
        'Why should I keep OTOBO up to date?' => 'Por que eu deveria manter o OTOBO atualizado?',
        'You will receive updates about relevant security issues.' => 'Você receberá atualizações sobre questões de segurança relevantes.',
        'You will receive updates for all other relevant OTOBO issues.' =>
            'Você receberá atualizações para todos os outros problemas relevantes do OTOBO.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Como eu posso fazer uma atualização de nível de patch se eu não tenho um contrato?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Você encontra toda informação relevante dentro das informações de atualização em %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'No caso de você ter mais perguntas, teremos prazer em respondê-las.',
        'Please visit our customer portal and file a request.' => 'Por favor visite nosso portal de clientes e registre um pedido.',
        'Install Package' => 'Instalar Pacote',
        'Update Package' => 'Atualizar Pacote',
        'Continue' => 'Continuar',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Por favor, certifique-se de que seu banco de dados aceita pacotes com mais de %s MB de tamanho (tamanho máximo suportado é de %s MB). Altere o parâmetro max_allowed_packet do seu banco de dados para evitar erros.',
        'Install' => 'Instalar',
        'Update repository information' => 'Atualizar Informação de Repositório',
        'Cloud services are currently disabled.' => 'Serviços de nuvem atualmente desabilitados.',
        'OTOBO Verify can not continue!' => 'OTOBO Verify não pode continuar',
        'Enable cloud services' => 'Habilitar serviços de nuvem',
        'Update all installed packages' => 'Atualiazar todos pacotes instalados',
        'Online Repository' => 'Repositório Online',
        'Vendor' => 'Fornecedor',
        'Action' => 'Ação',
        'Module documentation' => 'Documentação do Módulo',
        'Local Repository' => 'Repositório Local',
        'This package is verified by OTOBOverify (tm)' => 'Este pacote foi verificado por OTOBOverify (tm)',
        'Uninstall' => 'Desinstalar',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pacote não instalado corretamente! Por favor, reinstale o pacote.',
        'Reinstall' => 'Reinstalar',
        'Features for %s customers only' => 'Características %s só para clientes',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Com %s, você pode beneficiar os seguintes recursos opcionais. Por favor, faça contato com %s se precisar de mais informações.',
        'Package Information' => 'Informação de Pacote',
        'Download package' => 'Baixar Pacote',
        'Rebuild package' => 'Reconstruir Pacote',
        'Metadata' => 'Metadados',
        'Change Log' => 'Registro de Alterações',
        'Date' => 'Data',
        'List of Files' => 'Lista de Arquivos',
        'Permission' => 'Permissões',
        'Download file from package!' => 'Baixar arquivo do pacote!',
        'Required' => 'Obrigatório',
        'Primary Key' => 'Chave Primária',
        'Auto Increment' => 'Auto Incremento',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Diferenças do Arquivo para o Arquivo %s',
        'File differences for file %s' => 'Diferenças de arquivo para o arquivo %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Registro de Desempenho',
        'Range' => 'Intervalo',
        'last' => 'último',
        'This feature is enabled!' => 'Esta funcionalidade está habilitada!',
        'Just use this feature if you want to log each request.' => 'Use esta funcionalidade se você quiser logar cada requisição.',
        'Activating this feature might affect your system performance!' =>
            'Ao ativar esta funcionalidade pode-se afetar o desempenho do seu sistema!',
        'Disable it here!' => 'Desabilite-o aqui!',
        'Logfile too large!' => 'Arquivo de registro muito grande!',
        'The logfile is too large, you need to reset it' => 'O arquivo de registro está muito grande, você precisa reiniciá-lo',
        'Interface' => 'Interface',
        'Requests' => 'Requisições',
        'Min Response' => 'Tempo mínimo de resposta',
        'Max Response' => 'Tempo máximo de resposta',
        'Average Response' => 'Média de tempo de resposta',
        'Period' => 'Período',
        'minutes' => 'minutos',
        'Min' => 'Mín.',
        'Max' => 'Máx.',
        'Average' => 'Média',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Gerenciamento de Filtros (Postmaster)',
        'Add PostMaster Filter' => 'Adicionar Filtro PostMaster',
        'Edit PostMaster Filter' => 'Alterar Filtro PostMaster',
        'Filter for PostMaster Filters' => 'Filtrar por Filtros PostMaster',
        'Filter for PostMaster filters' => 'Filtrar por filtros PostMaster',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Para encaminhamento ou filtragem de e-mails recebidos com base em cabeçalhos de e-mail. O casamento usando expressões regulares também é possível.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Se você deseja corresponder apenas o endereço de e-mail, use EMAILADDRESS: info@exemplo.com em De, Para ou Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Se você usar Expressões Regulares, você também pode usar o valor encontrado em () como [***] na ação \'Set\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Você também pode utilizar nomes capturados %s e utilizar os nomes na ação \'Set\'  %s (exemplo: Expressão Regular: %s, Ação Set: %s). Um EMAILADDRESS correspondente tem o nome \'%s\'.',
        'Delete this filter' => 'Excluir este filtro',
        'Do you really want to delete this postmaster filter?' => 'Você realmente quer excluir este filtro postmaster?',
        'A postmaster filter with this name already exists!' => 'Um filtro postmaster com este nome já existe!',
        'Filter Condition' => 'Condição do Filtro',
        'AND Condition' => 'Condição E',
        'Search header field' => 'Buscar campo de cabeçalho',
        'for value' => 'pelo valor',
        'The field needs to be a valid regular expression or a literal word.' =>
            'O campo precisa ser uma expressão regular válida ou uma palavra literal.',
        'Negate' => 'Negado',
        'Set Email Headers' => 'Configurar Cabeçalhos de E-mail',
        'Set email header' => 'Ajustar cabeçalho do email',
        'with value' => 'com valor',
        'The field needs to be a literal word.' => 'O campo precisa ser uma palavra literal.',
        'Header' => 'Cabeçalho',

        # Template: AdminPriority
        'Priority Management' => 'Gerenciamento de Prioridade',
        'Add Priority' => 'Adicionar Prioridade',
        'Edit Priority' => 'Alterar Prioridade',
        'Filter for Priorities' => 'Filtrar por Propriedades',
        'Filter for priorities' => 'Filtrar por propriedades',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Essa prioridade está presente em uma definição da Configuração do Sistema. É necessário confirmar para atualizar definições que apontam para uma nova prioridade!',
        'This priority is used in the following config settings:' => 'Essa prioridade é utilizada nas seguintes configurações:',

        # Template: AdminProcessManagement
        'Process Management' => 'Gerenciamento de Processos',
        'Filter for Processes' => 'Filtrar por Processos',
        'Filter for processes' => 'Filtrar por processos',
        'Create New Process' => 'Criar Novo Processo',
        'Deploy All Processes' => 'Implantar todos os processos',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Você pode enviar um arquivo de configuração para importar processos em seu sistema. O arquivo precisa estar em formato .yml e ser exportado pelo módulo de gerenciamento de processos.',
        'Upload process configuration' => 'Enviar Configuração de Processo',
        'Import process configuration' => 'Importar Configuração de Processo',
        'Ready2Adopt Processes' => 'Processos Ready2Adopt',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Aqui você pode ativar processos Ready2Adopt que demonstram nossas boas práticas. Por favor observe que alguma configuração adicional pode ser necessária.',
        'Import Ready2Adopt process' => 'Importar processos Ready2Adopt',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Para criar um novo Processo você pode importar um Processo exportado de outro sistema ou criar um Processo completamente novo.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Alterações feitas aos Processos só afetam o sistema após a sincronização dos processos. Ao sincronizar os processos as alterações serão escritas nas configurações.',
        'Processes' => 'Processos',
        'Process name' => 'Nome do Processo',
        'Print' => 'Imprimir',
        'Export Process Configuration' => 'Exportar Configuração do Processo',
        'Copy Process' => 'Copiar Processo',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Cancelar e fechar',
        'Go Back' => 'Voltar',
        'Please note, that changing this activity will affect the following processes' =>
            'Por favor, note que alterar esta atividade afetará os seguintes processos',
        'Activity' => 'Atividade',
        'Activity Name' => 'Nome da Atividade',
        'Activity Dialogs' => 'Janelas de Atividade',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Janelas de Atividade à esta Atividade arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Filter available Activity Dialogs' => 'Filtrar Janelas de Atividades Disponíveis',
        'Available Activity Dialogs' => 'Janelas de Atividades Disponíveis',
        'Name: %s, EntityID: %s' => 'Nome: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Criar Nova Janela de Atividade',
        'Assigned Activity Dialogs' => 'Atribuir Janela de Atividade',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Por favor, note que alterar esta janela de atividade afetará as seguintes atividades',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Por favor, note que os usuários clientes não serão capazes de ver ou usar os seguintes campos: Proprietário, Responsável, Bloqueio, PendingTime e CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'O campo Fila só pode ser usado pelos clientes ao criar um novo chamado.',
        'Activity Dialog' => 'Janela de Atividade',
        'Activity dialog Name' => 'Nome da Janela de Atividade',
        'Available in' => 'Disponível em',
        'Description (short)' => 'Descrição (curta)',
        'Description (long)' => 'Descrição (longa)',
        'The selected permission does not exist.' => 'A permissão selecionada não existe.',
        'Required Lock' => 'Requerer Bloqueio',
        'The selected required lock does not exist.' => 'O bloqueio requerido solicitado não existe.',
        'Submit Advice Text' => 'Orientação do texto Enviar',
        'Submit Button Text' => 'Texto do botão enviar',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Campos para esta Janela de Atividades arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Filter available fields' => 'Filtrar campos disponíveis',
        'Available Fields' => 'Campos Disponíveis',
        'Assigned Fields' => 'Campos Atribuidos',
        'Communication Channel' => 'Canal de Comunicação',
        'Is visible for customer' => 'Ficar visível para o Cliente',
        'Display' => 'Exibir',

        # Template: AdminProcessManagementPath
        'Path' => 'Caminho',
        'Edit this transition' => 'Editar esta transição',
        'Transition Actions' => 'Ações de Transição',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Você pode atribuir Ações de Transição à esta transição arrastando os elementos com o mouse a partir da lista da esquerda para a lista da direita.',
        'Filter available Transition Actions' => 'Filtrar Ações de Transições Disponíveis',
        'Available Transition Actions' => 'Ações de Transição Disponíveis',
        'Create New Transition Action' => 'Criar Nova Ação de Transição',
        'Assigned Transition Actions' => 'Atribuir Ação de Transição',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Atividades',
        'Filter Activities...' => 'Filtrar Atividades',
        'Create New Activity' => 'Criar Nova Atividade',
        'Filter Activity Dialogs...' => 'Filtrar Janelas de Atividade',
        'Transitions' => 'Transições',
        'Filter Transitions...' => 'Filtrar Transições',
        'Create New Transition' => 'Criar Nova Transição',
        'Filter Transition Actions...' => 'Filtrar Ações de Transições...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Editar Processo',
        'Print process information' => 'Imprimir Informação do Processo',
        'Delete Process' => 'Excluir Processo',
        'Delete Inactive Process' => 'Excluir Processos Inativos',
        'Available Process Elements' => 'Elementos de Processo Disponíveis',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Os Elementos listamos acima nesta barra lateral podem ser movidos para a área da tela à direita usando drag\'n\'drop.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Você pode colocar Atividades na área da tela atribuindo esta Atividade ao Processo.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Para atribuir uma Janela de Atividade à uma Atividade arraste o elemento de Janela de Atividade desta barra lateral sobre a Atividade colocada na área da tela.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Você pode iniciar uma conexão entre duas atividades arrastando e soltando a transição sobre a atividade inicial da conexão. Depois disso você pode mover a ponta final livre para a atividade final.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Ações podem ser atribuidas para Transições arrastando o elemento de Ação sobre a etiqueta da Transição.',
        'Edit Process Information' => 'Editar Informação do Processo',
        'Process Name' => 'Nome do Processo',
        'The selected state does not exist.' => 'O estado selecionado não existe.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Adicionar e Editar Atividades, Janelas de Atividades e Transições',
        'Show EntityIDs' => 'Mostrar EntityIDs',
        'Extend the width of the Canvas' => 'Expandir Largura da Tela',
        'Extend the height of the Canvas' => 'Expandir Altura da Tela',
        'Remove the Activity from this Process' => 'Remover a Atividade Deste Processo',
        'Edit this Activity' => 'Editar esta Atividade',
        'Save Activities, Activity Dialogs and Transitions' => 'Salvar Atividades, Diálogos de Atividade e Transições',
        'Do you really want to delete this Process?' => 'Você realmente deseja excluir este Processo?',
        'Do you really want to delete this Activity?' => 'Você realmente deseja excluir esta Atividade?',
        'Do you really want to delete this Activity Dialog?' => 'Você realmente deseja excluir esta Janela de Atividade?',
        'Do you really want to delete this Transition?' => 'Você realmente deseja excluir esta Transição?',
        'Do you really want to delete this Transition Action?' => 'Você realmente deseja excluir esta Ação de Transição?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Você realmente deseja excluir esta atividade da tela? Esta ação poderá ser desfeita saindo desta tela sem salvar.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Você realmente deseja excluir esta transição da tela? Esta ação poderá ser desfeita saindo desta tela sem salvar.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'Nesta tela você pode criar um novo processo. Para tornar o novo processo disponível aos usuários, por favor, certifique-se de definir o estado como \'Ativo\' e sincronizar após completar o seu trabalho.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'cancelar e fechar',
        'Start Activity' => 'Início da Atividade',
        'Contains %s dialog(s)' => 'Contém %s janela(s)',
        'Assigned dialogs' => 'Janelas Atribuídas',
        'Activities are not being used in this process.' => 'Atividades não estão em uso neste processo.',
        'Assigned fields' => 'Campos Atribuídos',
        'Activity dialogs are not being used in this process.' => 'Janelas de Atividade não estão em uso neste processo.',
        'Condition linking' => 'Ligação de Condições',
        'Transitions are not being used in this process.' => 'Transições não estão em uso neste processo.',
        'Module name' => 'Nome do Módulo',
        'Transition actions are not being used in this process.' => 'Ações de Transição não estão em uso nesse processo.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Por favor, note que alterar esta transição afetará os seguintes processos',
        'Transition' => 'Transição',
        'Transition Name' => 'Nome da Transição',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Por favor, note que alterar esta transição afetará os seguintes processos',
        'Transition Action' => 'Ação de Transição',
        'Transition Action Name' => 'Nome da Ação de Transição',
        'Transition Action Module' => 'Módulo da Ação de Transição',
        'Config Parameters' => 'Parâmetros de Configuração',
        'Add a new Parameter' => 'Adicionar Novo Parâmetro',
        'Remove this Parameter' => 'Remover Este Parâmetro',

        # Template: AdminQueue
        'Queue Management' => 'Gerenciamento de Fila',
        'Add Queue' => 'Adicionar Filas',
        'Edit Queue' => 'Alterar Filas',
        'Filter for Queues' => 'Filtrar por Filas',
        'Filter for queues' => 'Filtrar por filas',
        'A queue with this name already exists!' => 'Uma fila com esse nome já existe!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Esta fila está presente em uma definição de Configuração de Sistema. Confirmação para atualizar definições que apontam para esta nova fila é necessária!',
        'Sub-queue of' => 'Subfila de',
        'Unlock timeout' => 'Expiração de Desbloqueio',
        '0 = no unlock' => '0 = sem desbloqueio',
        'hours' => 'horas',
        'Only business hours are counted.' => 'Apenas horas úteis são contadas.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Se um atendente bloquear um chamado e não fechá-lo antes de expirado o tempo limite de desbloqueio, o chamado será desbloqueado e ficará disponível para outros atendentes.',
        'Notify by' => 'Notificar Por',
        '0 = no escalation' => '0 = sem escalação',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Se não há um contato com o cliente adicionado, seja por e-mail externo ou telefone, ao novo chamado antes do tempo definido aqui expirar, o chamado é escalado.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Se há um artigo adicionado, tais como revisão via e-mail ou no portal do cliente, o tempo de atualização da escalada é reiniciado. Se não houver um contato com o cliente, seja por e-mail externo ou telefone, adicionado ao chamado antes de o tempo definido aqui expirar, o chamado é escalado.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Se o chamado não é definido como fechado antes de tempo definido aqui expirar, o ticket é escalado.',
        'Follow up Option' => 'Opção de Revisão',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Especifica se a revisão de um chamado fechado deve reabri-lo, ser rejeitada ou conduzir a um novo chamado.',
        'Ticket lock after a follow up' => 'Bloqueio do Chamado após uma Revisão',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Se um chamado está fechado e o cliente envia uma revisão, o chamado será bloqueado para o antigo proprietário.',
        'System address' => 'Endereço de Sistema',
        'Will be the sender address of this queue for email answers.' => 'Será o endereço de remetente desta fila para respostas por e-mail.',
        'Default sign key' => 'Chave de Assinatura Padrão',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'Para utilizar uma chave de assinatura, chaves PGP ou certificados S/MIME precisam ser adicionados com identificadores para o endereço de sistema da fila selecionada.',
        'Salutation' => 'Saudação',
        'The salutation for email answers.' => 'A saudação para respostas por e-mail.',
        'Signature' => 'Assinatura',
        'The signature for email answers.' => 'A assinatura para respostas por e-mail.',
        'This queue is used in the following config settings:' => 'Esta fila é utilizada nas seguintes configurações:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Gerenciar Relações Autorresposta-Fila',
        'Change Auto Response Relations for Queue' => 'Alterar Relações de Autorresposta Para Filas',
        'This filter allow you to show queues without auto responses' => 'Este filtro permite que você visualize filas sem auto respostas',
        'Queues without Auto Responses' => 'Filas sem Respostas Automáticas',
        'This filter allow you to show all queues' => 'Este filtro permite que você mostre todas as filas',
        'Show All Queues' => 'Mostrar Todas as Filas',
        'Auto Responses' => 'Autorrespostas',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Gerenciar Relações Modelo-Fila',
        'Filter for Templates' => 'Filtrar por Modelos',
        'Filter for templates' => 'Filtrar por modelos',
        'Templates' => 'Modelos',

        # Template: AdminRegistration
        'System Registration Management' => 'Gerenciamento do Registro do Sistema',
        'Edit System Registration' => 'Editar Registro do Sistema',
        'System Registration Overview' => 'Visão Geral do Registro do Sistema',
        'Register System' => 'Registrar o Sistema',
        'Validate OTOBO-ID' => 'Validar OTOBO-ID',
        'Deregister System' => 'Desregistrar Sistema',
        'Edit details' => 'Editar detalhes',
        'Show transmitted data' => 'Exibir dados transmitidos',
        'Deregister system' => 'Desregistrar sistema',
        'Overview of registered systems' => 'Visão geral de sistemas registrados',
        'This system is registered with OTOBO Team.' => 'Este sistema está registrado com o Grupo OTRS.',
        'System type' => 'Tipo do sistema',
        'Unique ID' => 'ID Único',
        'Last communication with registration server' => 'Última comunicação com o servidor de registro',
        'System Registration not Possible' => 'Não é possível registrar o sistema',
        'Please note that you can\'t register your system if OTOBO Daemon is not running correctly!' =>
            'Por favor, note que você não pode registrar o seu sistema se OTOBO Daemon não estiver funcionando corretamente!',
        'Instructions' => 'Instruções',
        'System Deregistration not Possible' => 'Não é possível cancelar o registro do sistema',
        'OTOBO-ID Login' => 'Login OTOBO-ID',
        'System registration is a service of OTOBO Team, which provides a lot of advantages!' =>
            'Registro do sistema é um serviço do Grupo OTRS que fornece muitas vantagens!',
        'Read more' => 'Leia mais',
        'You need to log in with your OTOBO-ID to register your system.' =>
            'Você precisa logar com seu OTOBO-ID para registrar seu sistema. ',
        'Your OTOBO-ID is the email address you used to sign up on the OTOBO.com webpage.' =>
            'Seu OTOBO-ID é o endereço de e-mail usado para logar no site OTOBO.com.',
        'Data Protection' => 'Proteção de Dados',
        'What are the advantages of system registration?' => 'Quais são as vantagens de registrar o sistema?',
        'You will receive updates about relevant security releases.' => 'Você irá receber informações sobre atualizações de segurança relevantes.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Com seu registro de sistema podemos melhorar nossos serviços para você, porque nós temos todas as informações relevantes disponíveis.',
        'This is only the beginning!' => 'Este é apenas o começo!',
        'We will inform you about our new services and offerings soon.' =>
            'Informaremos sobre nossos novos serviços e ofertas em breve.',
        'Can I use OTOBO without being registered?' => 'Eu posso utilizar o OTOBO sem registrar ?',
        'System registration is optional.' => 'Registro do sistema é opcional. ',
        'You can download and use OTOBO without being registered.' => 'Você pode baixar o OTOBO e usá-lo sem estar registrado.',
        'Is it possible to deregister?' => 'É possível cancelar o registro?',
        'You can deregister at any time.' => 'Você pode cancelar ser registro a qualquer momento.',
        'Which data is transfered when registering?' => 'Quais dados são transferidos ao se registrar?',
        'A registered system sends the following data to OTOBO Team:' => 'Um sistema registrado envia os seguintes dados ao grupo do OTRS:',
        'Fully Qualified Domain Name (FQDN), OTOBO version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), versão do OTOBO, versão do banco de dados, Sistema Operacional e Perl.',
        'Why do I have to provide a description for my system?' => 'Por que tenho que fornecer uma descrição para o meu sistema?',
        'The description of the system is optional.' => 'A descrição do sistema é opcional.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'A descrição e o tipo de sistema que você especificar lhe ajudará a identificar e gerenciar os detalhes de seus sistemas registrados.',
        'How often does my OTOBO system send updates?' => 'Quantas vezes meu sistema OTOBO envia atualizações?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Seu sistema enviará atualizações para o registro do servidor em intervalos regulares.',
        'Typically this would be around once every three days.' => 'Normalmente, isso seria em torno de uma vez a cada três dias.',
        'If you deregister your system, you will lose these benefits:' =>
            'Se você cancelar o registro de seu sistema, você vai perder estes benefícios:',
        'You need to log in with your OTOBO-ID to deregister your system.' =>
            'Você precisa fazer login com seu OTOBO-ID para cancelar o registro de seu sistema.',
        'OTOBO-ID' => 'OTOBO-ID',
        'You don\'t have an OTOBO-ID yet?' => 'Não possui um OTOBO-ID ainda?',
        'Sign up now' => 'Entrar agora',
        'Forgot your password?' => 'Esqueceu sua senha?',
        'Retrieve a new one' => 'Receba uma nova',
        'Next' => 'Próximo',
        'This data will be frequently transferred to OTOBO Team when you register this system.' =>
            'Estes dados serão transferidos frequentemente para o Grupo OTRS quando você registrar este sistema.',
        'Attribute' => 'Atributo',
        'FQDN' => 'FQDN',
        'OTOBO Version' => 'Versão do OTOBO',
        'Operating System' => 'Sistema Operacional',
        'Perl Version' => 'Versão Perl',
        'Optional description of this system.' => 'Descrição opcional deste sistema.',
        'This will allow the system to send additional support data information to OTOBO Team.' =>
            'Isto permitirá ao sistema enviar informações adicionais de suporte ao Grupo OTRS.',
        'Register' => 'Registrar',
        'Continuing with this step will deregister the system from OTOBO Team.' =>
            'Continuando com este passo irá cancelar o registro de sistema do grupo de OTRS.',
        'Deregister' => 'Desregistrar',
        'You can modify registration settings here.' => 'Você pode modificar configurações de registro aqui.',
        'Overview of Transmitted Data' => 'Visão Geral dos Dados Transmitidos',
        'There is no data regularly sent from your system to %s.' => 'Não há dados regularmente enviados do seu sistema para %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Os seguintes dados de seu sistema são enviados no mínimo a cada 3 dias para %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Os dados serão transferidos através de uma conexão segura https no formato JSON.',
        'System Registration Data' => 'Dados de Registro do Sistema',
        'Support Data' => 'Dados de Suporte',

        # Template: AdminRole
        'Role Management' => 'Gerenciamento de Papéis',
        'Add Role' => 'Adicionar Papel',
        'Edit Role' => 'Alterar Papel',
        'Filter for Roles' => 'Filtrar por Papéis',
        'Filter for roles' => 'Filtrar por Papéis',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Crie um papel e relacione grupos a ele. Então adicione papéis aos usuários.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Até o momento não há papéis definidos. Por favor, use o botão "Adicionar Papel" para criar um novo papel.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Gerenciar Relações Papel-Grupo',
        'Roles' => 'Papéis',
        'Select the role:group permissions.' => 'Selecione as permissões papel:grupo.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Se nada for selecionado, então não há permissões neste grupo (chamados não estarão disponíveis para o papel).',
        'Toggle %s permission for all' => 'Chavear permissão %s para todos',
        'move_into' => 'mover_para',
        'Permissions to move tickets into this group/queue.' => 'Permissões para mover chamados para este grupo/fila.',
        'create' => 'criar',
        'Permissions to create tickets in this group/queue.' => 'Permissões para criar chamados neste grupo/fila. ',
        'note' => 'nota',
        'Permissions to add notes to tickets in this group/queue.' => 'Permissões para adicionar notas aos chamados neste grupo/fila.',
        'owner' => 'proprietário',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Permissões para alterar o proprietário do chamado para este grupo/fila.',
        'priority' => 'prioridade',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Permissões para alterar a prioridade do chamado neste grupo/fila.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Gerenciar Relações Atendente-Papel',
        'Add Agent' => 'Adicionar Atendente',
        'Filter for Agents' => 'Filtrar por Atendentes',
        'Filter for agents' => 'Filtrar por agentes',
        'Agents' => 'Atendentes',
        'Manage Role-Agent Relations' => 'Gerenciar Relações Papel-Atendente',

        # Template: AdminSLA
        'SLA Management' => 'Gerenciamento de SLA',
        'Edit SLA' => 'Alterar SLA',
        'Add SLA' => 'Adicionar SLA',
        'Filter for SLAs' => 'Filtrar por SLA',
        'Please write only numbers!' => 'Por favor, escreva apenas números!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Gerenciamento S/MIME',
        'Add Certificate' => 'Adicionar Certificado',
        'Add Private Key' => 'Adicionar Chave Privada',
        'SMIME support is disabled' => 'Suporte a SMIME desabilitado',
        'To be able to use SMIME in OTOBO, you have to enable it first.' =>
            'Para poder usar o SMIME no OTOBO, você precisa ativar isto primeiro.',
        'Enable SMIME support' => 'Habilitar suporte SMIME',
        'Faulty SMIME configuration' => 'Erro na configuração de SMIME',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Suporte SMIME está ativo, mas configurações importantes estão com erro. Por favor verifique as configurações usando o botão abaixo.',
        'Check SMIME configuration' => 'Verificar configuração de SMIME',
        'Filter for Certificates' => 'Filtrar por Certificado',
        'Filter for certificates' => 'Filtrar por Certificados',
        'To show certificate details click on a certificate icon.' => 'Para mostrar detalhes do certificado clique no ícone do certificado',
        'To manage private certificate relations click on a private key icon.' =>
            'Para gerenciar os certificados privados clique no ícone de chave privada.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Aqui você pode adicionar as relações de seu certificado privado, estes serão incorporados à assinatura de S/MIME toda vez que você usar este certificado para assinar um e-mail.',
        'See also' => 'Veja também',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Neste caso, você pode editar diretamente a certificação e chaves privadas no sistema de arquivos.',
        'Hash' => 'Hash',
        'Create' => 'Criar',
        'Handle related certificates' => 'Gerenciar Certificados Relacionados',
        'Read certificate' => 'Ler Certificado',
        'Delete this certificate' => 'Excluir este certificado',
        'File' => 'Arquivo',
        'Secret' => 'Senha',
        'Related Certificates for' => 'Certificados Relacionados para',
        'Delete this relation' => 'Remover esta relação',
        'Available Certificates' => 'Certificados Disponíveis',
        'Filter for S/MIME certs' => 'Filtrar por certificados S/MIME',
        'Relate this certificate' => 'Relacionar este certificado',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'Certificado S/MIME',
        'Certificate Details' => 'Detalhes do certificado',
        'Close this dialog' => 'Fechar esta janela',

        # Template: AdminSalutation
        'Salutation Management' => 'Gerenciamento de Saudação',
        'Add Salutation' => 'Adicionar Saudação',
        'Edit Salutation' => 'Alterar Saudação',
        'Filter for Salutations' => 'Filtrar por Saudação',
        'Filter for salutations' => 'Filtrar por Saudação',
        'e. g.' => 'ex.',
        'Example salutation' => 'Saudação de exemplo',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'Modo Seguro tem de estar ativado!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'O modo seguro é (normalmente) configurado após a instalação estar completa.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Se o modo seguro não estiver ativado, ative-o através do SysConfig, porque sua aplicação já está executando.',

        # Template: AdminSelectBox
        'SQL Box' => 'Comandos SQL',
        'Filter for Results' => 'Filtrar por Resultados',
        'Filter for results' => 'Filtrar por resultados',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Aqui você pode inserir SQL para enviá-lo diretamente para o banco de dados do aplicativo. Não é possível alterar o conteúdo das tabelas, são permitidas somente consultas.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Aqui você pode entrar consultas SQL para enviá-las diretamente ao banco de dados do aplicativo.',
        'Options' => 'Opções',
        'Only select queries are allowed.' => 'Apenas consultas estão liberadas',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'A sintaxe da sua consulta SQL está incorreta. Por favor, verifique.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Há pelo menos um parâmetro ausente para a ligação. Por favor, verifique.',
        'Result format' => 'Formato de Resultado',
        'Run Query' => 'Executar Consulta',
        '%s Results' => '%s Resultados',
        'Query is executed.' => 'Consulta executada.',

        # Template: AdminService
        'Service Management' => 'Gerenciamento de Serviços',
        'Add Service' => 'Adicionar Serviço',
        'Edit Service' => 'Alterar Serviço',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Tamanho máximo do nome do Serviço é de 200 caracteres (incluindo Sub-Serviços)',
        'Sub-service of' => 'Subserviço de',

        # Template: AdminSession
        'Session Management' => 'Gerenciamento de Sessões',
        'Detail Session View for %s (%s)' => 'Visão Detalhada de Sessão para %s (%s)',
        'All sessions' => 'Todas as Sessões',
        'Agent sessions' => 'Sessões de Atendente',
        'Customer sessions' => 'Sessões de Cliente',
        'Unique agents' => 'Atendentes Únicos',
        'Unique customers' => 'Clientes Únicos',
        'Kill all sessions' => 'Finalizar Todas as Sessões',
        'Kill this session' => 'Finalizar Esta Sessão',
        'Filter for Sessions' => 'Filtrar por Sessões',
        'Filter for sessions' => 'Filtrar por sessões',
        'Session' => 'Sessão',
        'Kill' => 'Finalizar',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Gerenciamento de Assinaturas',
        'Add Signature' => 'Adicionar Assinatura',
        'Edit Signature' => 'Alterar Assinatura',
        'Filter for Signatures' => 'Filtrar por Assinatura',
        'Filter for signatures' => 'Filtrar por Assinatura',
        'Example signature' => 'Assinatura de exemplo',

        # Template: AdminState
        'State Management' => 'Gerenciamento de Estado',
        'Add State' => 'Adicionar Estado',
        'Edit State' => 'Alterar Estado',
        'Filter for States' => 'Filtrar por Estado',
        'Filter for states' => 'Filtrar por Estado',
        'Attention' => 'Atenção',
        'Please also update the states in SysConfig where needed.' => 'Por favor, também atualize os Estados em SysConfig onde necessário.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Este estado faz parte de um item da Configuração do Sistema. É necessário confirmar a atualização desta configuração para referenciar um novo tipo.',
        'State type' => 'Tipo de Estado',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Não é possível invalidar esta entrada porque não existe nenhum outro estado de agrupamento no sistema!',
        'This state is used in the following config settings:' => 'Este estato é utilizado nas seguintes configurações:',

        # Template: AdminSupportDataCollector
        'Sending support data to OTOBO Team is not possible!' => 'Envio de dados de suporte para o grupo OTRS não é possível',
        'Enable Cloud Services' => 'Habilitar Serviços de Nuvem',
        'This data is sent to OTOBO Team on a regular basis. To stop sending this data please update your system registration.' =>
            'Estes dados são enviados para o Grupo OTRS regularmente. Para parar de enviar estes dados, por favor atualize seu registro de sistema.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Você pode disparar manualmente o envio de Dados de Suporte pressionando este botão:',
        'Send Update' => 'Enviar Atualização',
        'Currently this data is only shown in this system.' => 'Atualmente estes dados são mostrados apenas neste sistema.',
        'It is highly recommended to send this data to OTOBO Team in order to get better support.' =>
            'É altamente recomendado enviar estes dados para o grupo OTRS de forma a obter um melhor suporte.',
        'To enable data sending, please register your system with OTOBO Team or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Para habilitar o envio de dados, por favor registre seu sistema no Grupo OTRS ou atualize a informação de registro de seu sistema (tenha certeza de ativar a opção \'enviar dados de suporte\').',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Um pacote de suporte (incluindo: informações de registro do sistema, dados de suporte, uma lista de pacotes instalados e todos os arquivos de código fonte modificados localmente) pode ser gerado pressionando este botão:',
        'Generate Support Bundle' => 'Gerar Pacote de Suporte',
        'The Support Bundle has been Generated' => 'O Pacote de Suporte foi gerado',
        'Please choose one of the following options.' => 'Por favor escolha uma das opções a seguir.',
        'Send by Email' => 'Enviar por E-mail',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'O pacote de suporte é muito grande para enviar via e-mail, esta opção foi desabilitada.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'O endereço de email para este usuário é inválido, esta opção foi desabilitada.',
        'Sending' => 'Enviando',
        'The support bundle will be sent to OTOBO Team via email automatically.' =>
            'O pacote de suporte será enviado para o Grupo OTRS via e-mail automaticamente.',
        'Download File' => 'Baixar Arquivo',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTOBO Team, using an alternate method.' =>
            'Um arquivo contendo o pacote de suporte será baixado para o sistema local. Por favor, salve o arquivo e o envie para o Grupo OTRS usando um método alternativo.',
        'Error: Support data could not be collected (%s).' => 'Erro: Dados de Suporte não podem ser coletados (%s).',
        'Details' => 'Detalhes',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Gerenciamento de Endereço de E-mail de Sistema',
        'Add System Email Address' => 'Adicionar Endereço de E-mail de Sistema',
        'Edit System Email Address' => 'Alterar Endereço de e-mail de Sistema',
        'Add System Address' => 'Adicionar Endereços de Sistema',
        'Filter for System Addresses' => 'Filtrar por Endereços de Sistema',
        'Filter for system addresses' => 'Filtrar por endereços de sistema',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Todos os e-mails recebidos com este endereço no campo Para ou Cc serão encaminhados para a fila selecionada.',
        'Email address' => 'Endereço de E-mail',
        'Display name' => 'Nome de Exibição',
        'This email address is already used as system email address.' => 'Este endereço de e-mail já está sendo usado como Endereço de E-mail do Sistema.',
        'The display name and email address will be shown on mail you send.' =>
            'O nome de exibição e endereço de e-mail serão mostrados no e-mail enviado.',
        'This system address cannot be set to invalid.' => 'O endereço de sistema não pode ser definido como inválido.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'documentação de administrador online',
        'System configuration' => 'Configuração do Sistema',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Navegue pelas configurações disponíveis utilizando a árvore na caixa de navegação no lado esquerdo.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Encontre determinadas configurações utilizando o campo de busca abaixo ou o ícone de busca no topo.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Descubra como utilizar a configuração do sistema ao ler %s.',
        'Search in all settings...' => 'Pesquisar em todas as configurações...',
        'There are currently no settings available. Please make sure to run \'otobo.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Nenhuma definição disponível. Por favor, certifique-se de executar \'otobo.Console.pl Maint::Config::Rebuild\' antes de utilizar o software.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Implementar Mudanças',
        'Help' => 'Ajuda',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Esta é uma visão geral de todas definições que serão parte da implantação se você iniciar agora. Você pode comparar cada definição ao seu estado anterior ao clicar no ícone no canto superior direito.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'Para excluir certas configurações de um desenvolvimento, clique na caixa de seleção na barra de cabeçalho de uma configuração.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Por padrão, você irá implantar definições que você mesmo alterou. Se você desejar implantar alterações feitas por outros usuários também, por favor clique no link no topo da tela para abrir o módulo de implantação avançada.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Uma implantação acabou de ser restaurada, o que significa que todas as definições afetadas foram revertidas ao estado que tinham na implantação selecionada.',
        'Please review the changed settings and deploy afterwards.' => 'Por favor reveja as mudanças de configurações e depois implemente-as.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Uma lista vazia de mudanças significa que não tem diferença entre os estados atual e restaurado das definições afetadas.',
        'Changes Overview' => 'Visão geral de mudanças',
        'There are %s changed settings which will be deployed in this run.' =>
            'Existem %s definições alteradas que serão implantadas nesta execução.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Mude para o modo básico para implantar configurações alteradas apenas por você',
        'You have %s changed settings which will be deployed in this run.' =>
            'Você tem %s alterações de configuração que serão implementadas nesta execução.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Mude para o modo avançado para implementar configurações modificadas por outros usuários, também.',
        'There are no settings to be deployed.' => 'Não há configurações para serem implementadas.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Mude para o modo avançado para visualizar as definições implantáveis alteradas por outros usuários.',
        'Deploy selected changes' => 'Implementar alterações selecionadas.',

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
        'by' => 'por',
        'No settings have been deployed in this run.' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Este grupo não contém definições. Por favor, tente navegar para um de seus subgrupos.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Importar e Exportar',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Carregar o arquivo a ser importado para seu sistema (formato .yml como exportado do módulo Configuração do Sistema).',
        'Upload system configuration' => 'Carregar configuração de sistema',
        'Import system configuration' => 'Importar configuração do sistema',
        'Download current configuration settings of your system in a .yml file.' =>
            'Baixar opções de configuração atuais do seu sistema em um arquivo .yml.',
        'Include user settings' => 'Incluir ajustes do usuário',
        'Export current configuration' => 'Exportar configuração atual',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Buscar por',
        'Search for category' => 'Buscar por categoria',
        'Settings I\'m currently editing' => 'Configurações que estou editando no momento',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Sua pesquisa por "%s" na categoria "%s" não retornou resultados.',
        'Your search for "%s" in category "%s" returned one result.' => 'Sua pesquisa por "%s" na categoria "%s" retornou um resultado.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Sua pesquisa por "%s" na categoria "%s" retornou %s resultados.',
        'You\'re currently not editing any settings.' => 'No momento você não está editando nenhuma configuração.',
        'You\'re currently editing %s setting(s).' => 'Você está editando %s definição(ões) atualmente.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Categoria',
        'Run search' => 'Pesquisar',

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
        'View a custom List of Settings' => 'Visualizar uma lista customizada de configurações',
        'View single Setting: %s' => 'Ver apenas a Definição: %s',
        'Go back to Deployment Details' => 'Retornar para Detalhes de Implantação',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Gerenciamento de Manutenção do Sistema',
        'Schedule New System Maintenance' => 'Agendar Nova Manutenção do Sistema',
        'Filter for System Maintenances' => 'Filtrar por Manutenções do Sistema',
        'Filter for system maintenances' => 'Filtrar por manutenções do sistema',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Agende um período de manutenção do sistema para anunciar aos Atendentes e Clientes que o sistema estará indisponível por um período de tempo.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Algum tempo antes da manutenção do sistema iniciar, os usuários receberão uma notificação em todas as telas anunciando sobre  este fato.',
        'Stop date' => 'Data de fim',
        'Delete System Maintenance' => 'Deletar manutenção do sistema',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Editar Manutenção do Sistema',
        'Edit System Maintenance Information' => 'Editar informação da manutenção de sistema',
        'Date invalid!' => 'Data inválida!',
        'Login message' => 'Mensagem de autenticação',
        'This field must have less then 250 characters.' => 'Este campo deve ter menos do que 250 caracteres.',
        'Show login message' => 'Mostrar mensagem de autenticação',
        'Notify message' => 'Mensagem de notificação',
        'Manage Sessions' => 'Gerenciar Sessões',
        'All Sessions' => 'Todas as Sessões',
        'Agent Sessions' => 'Sessões de Atendente',
        'Customer Sessions' => 'Sessões de Cliente',
        'Kill all Sessions, except for your own' => 'Matar todas as Sessões, exceto a sua.',

        # Template: AdminTemplate
        'Template Management' => 'Gerenciamento de Modelo',
        'Add Template' => 'Adicionar Modelo',
        'Edit Template' => 'Editar Modelo',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Um modelo é um texto padrão que ajuda os atendentes a redigir chamados, respostas ou encaminhamentos mais rapidamente.',
        'Don\'t forget to add new templates to queues.' => 'Não se esqueça de adicionar os novos modelos a filas.',
        'Attachments' => 'Anexos',
        'Delete this entry' => 'Excluir esta entrada',
        'Do you really want to delete this template?' => 'Você quer realmente excluir este modelo?',
        'A standard template with this name already exists!' => 'Um modelo padrão com este nome já existe!',
        'Create type templates only supports this smart tags' => 'Criar modelos de tipo apenas suporta estas etiquetas inteligentes',
        'Example template' => 'Modelo exemplo',
        'The current ticket state is' => 'O estado atual do chamado é',
        'Your email address is' => 'Seu endereço de e-mail é',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Chavear ativado para todos',
        'Link %s to selected %s' => 'Associar %s ao %s selecionado',

        # Template: AdminType
        'Type Management' => 'Gerenciamento de Tipo',
        'Add Type' => 'Adicionar Tipo',
        'Edit Type' => 'Alterar Tipo',
        'Filter for Types' => 'Filtrar por Tipo',
        'Filter for types' => 'Filtrar por Tipo',
        'A type with this name already exists!' => 'Um tipo com esse nome já existe!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Este tipo está presente em uma definição da Configuração do Sistema. Confirmação para atualizar definições para apontar para este novo tipo é necessária!',
        'This type is used in the following config settings:' => 'Este tipo é utilizado nas seguintes definições de configuração:',

        # Template: AdminUser
        'Agent Management' => 'Gerenciamento de Atendente',
        'Edit Agent' => 'Alterar Atendente',
        'Edit personal preferences for this agent' => 'Editar preferências pessoais para este agente',
        'Agents will be needed to handle tickets.' => 'Atendentes serão necessários para lidar com os chamados.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Não se esqueça de adicionar o novo atendente a grupos e/ou papéis!',
        'Please enter a search term to look for agents.' => 'Por favor, digite um termo de pesquisa para localizar atendentes.',
        'Last login' => 'Última autenticação',
        'Switch to agent' => 'Trocar para atendente',
        'Title or salutation' => 'Título ou saudação',
        'Firstname' => 'Nome',
        'Lastname' => 'Sobrenome',
        'A user with this username already exists!' => 'Um usuário com esse Nome de usuário já existe!',
        'Will be auto-generated if left empty.' => 'Será autogerado se deixado em vazio.',
        'Mobile' => 'Celular',
        'Effective Permissions for Agent' => 'Permissões efetivas do agente',
        'This agent has no group permissions.' => 'Este agente não tem permissões de grupo',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'A tabela acima mostra todas as permissões efetivas para o agente. A matriz leva em conta todas as permissões herdadas (como via papeis)',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Gerenciar Relações Atendente-Grupo',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Visão geral da Agenda',
        'Manage Calendars' => 'Gerenciar Calendários',
        'Add Appointment' => 'Adicionar Compromisso',
        'Today' => 'Hoje',
        'All-day' => 'Dia todo',
        'Repeat' => 'Repetir',
        'Notification' => 'Notificações',
        'Yes' => 'Sim',
        'No' => 'Não',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Nenhum calendário encontrado. Por favor, primeiro adicione um calendário usando a página de Gerenciamento de Calendários.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Adicionar novo Compromisso',
        'Calendars' => 'Calendários',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Informação básica',
        'Date/Time' => 'Data/Hora',
        'Invalid date!' => 'Data Inválida',
        'Please set this to value before End date.' => 'Por favor, configure o valor antes da data final.',
        'Please set this to value after Start date.' => 'Por favor, configure o valor antes da data inicial.',
        'This an occurrence of a repeating appointment.' => 'Esta uma ocorrência de um compromisso de repetição.',
        'Click here to see the parent appointment.' => 'Clique aqui para ver o compromisso pai.',
        'Click here to edit the parent appointment.' => 'Clique aqui para editar o compromisso pai.',
        'Frequency' => 'Frequência ',
        'Every' => 'Todos',
        'day(s)' => 'dia(s)',
        'week(s)' => 'semana(s)',
        'month(s)' => 'mês(es)',
        'year(s)' => 'ano(s)',
        'On' => 'Ligado',
        'Monday' => 'Segunda',
        'Mon' => 'Seg',
        'Tuesday' => 'Terça',
        'Tue' => 'Ter',
        'Wednesday' => 'Quarta',
        'Wed' => 'Qua',
        'Thursday' => 'Quinta',
        'Thu' => 'Qui',
        'Friday' => 'Sexta',
        'Fri' => 'Sex',
        'Saturday' => 'Sábado',
        'Sat' => 'Sab',
        'Sunday' => 'Domingo',
        'Sun' => 'Dom',
        'January' => 'Janeiro',
        'Jan' => 'Jan',
        'February' => 'Fevereiro',
        'Feb' => 'Fev',
        'March' => 'Março',
        'Mar' => 'Mar',
        'April' => 'Abril',
        'Apr' => 'Abr',
        'May_long' => 'Maio',
        'May' => 'Mai',
        'June' => 'Junho',
        'Jun' => 'Jun',
        'July' => 'Julho',
        'Jul' => 'Jul',
        'August' => 'Agosto',
        'Aug' => 'Ago',
        'September' => 'Setembro',
        'Sep' => 'Set',
        'October' => 'Outubro',
        'Oct' => 'Out',
        'November' => 'Novembro',
        'Nov' => 'Nov',
        'December' => 'Dezembro',
        'Dec' => 'Dez',
        'Relative point of time' => 'Ponto de tempo relativo',
        'Link' => 'Associar',
        'Remove entry' => 'Remover entrada',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Centro de Informação do Cliente',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Usuário Cliente',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Nota: Cliente inválido!',
        'Start chat' => 'Iniciar chat',
        'Video call' => 'Vídeo chamada',
        'Audio call' => 'Chamada por áudio',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Caderno de Endereços do Usuário Cliente',
        'Search for recipients and add the results as \'%s\'.' => 'Pesquisar por destinatários e adicione os resultados como \'%s\'.',
        'Search template' => 'Modelo de Busca',
        'Create Template' => 'Criar Modelo',
        'Create New' => 'Criar Novo',
        'Save changes in template' => 'Salvar mudanças no modelo',
        'Filters in use' => 'Filtros em uso',
        'Additional filters' => 'Filtros adicionais',
        'Add another attribute' => 'Adicionar outro Atributo',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Os atributos com o identificador \'(Cliente)\' são da empresa cliente.',
        '(e. g. Term* or *Term*)' => '(por exemplo, Term* ou *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Selecionar Todos',
        'The customer user is already selected in the ticket mask.' => 'O usuário cliente já está selecionado na máscara do chamado.',
        'Select this customer user' => 'Selecione este usuário cliente.',
        'Add selected customer user to' => 'Adicionar usuário cliente para',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Alterar as Opções de Busca',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Centro de Informações do Usuário Cliente',

        # Template: AgentDaemonInfo
        'The OTOBO Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'O Daemon do OTOBO é um processo de daemon que executa tarefas assíncronas, por exemplo, escalonamento de chamados, enviando e-mail, etc.',
        'A running OTOBO Daemon is mandatory for correct system operation.' =>
            'A execução do OTOBO Daemon é obrigatório para a correta operação do sistema.',
        'Starting the OTOBO Daemon' => 'Iniciado o OTOBO Daemon',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTOBO Daemon is running and start it if needed.' =>
            'Certifique-se de que existe o arquivo \'%s\' (sem a extensão .dist). Essa tarefa do cron irá verificar a cada 5 minutos se o OTOBO Daemon está em execução e irá iniciá-lo se necessário.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otobo\' user are active.' =>
            'Execute \'%s start\' para certificar-se de que as tarefas do cron do usuário \'otobo\' estão ativos.',
        'After 5 minutes, check that the OTOBO Daemon is running in the system (\'bin/otobo.Daemon.pl status\').' =>
            'Após 5 minutos, verifique se o OTOBO Daemon está em execução no sistema (\'bin/otobo.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Painel',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Novo Compromisso',
        'Tomorrow' => 'Amanhã',
        'Soon' => 'Em breve',
        '5 days' => '5 dias',
        'Start' => 'Início',
        'none' => 'Vazio',

        # Template: AgentDashboardCalendarOverview
        'in' => 'em',

        # Template: AgentDashboardCommon
        'Save settings' => 'Salvar configurações',
        'Close this widget' => 'Fechar este widget',
        'more' => 'mais',
        'Available Columns' => 'Colunas Disponíveis',
        'Visible Columns (order by drag & drop)' => 'Colunas Visíveis (arrastar e soltar p/ reordenar)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Alterar relacionamentos de cliente',
        'Open' => 'Aberto',
        'Closed' => 'Fechado',
        '%s open ticket(s) of %s' => '%s chamado(s) aberto(s) de %s',
        '%s closed ticket(s) of %s' => '%s chamado(s) fechado(s) de %s',
        'Edit customer ID' => 'Editar ID de cliente',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Chamados Escalados',
        'Open tickets' => 'Chamados abertos',
        'Closed tickets' => 'Chamados Fechados',
        'All tickets' => 'Todos os Chamados',
        'Archived tickets' => 'Chamados arquivados',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Nota: Usuário Cliente é inválido!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Informações do Usuário Cliente',
        'Phone ticket' => 'Chamado Fone',
        'Email ticket' => 'Chamado E-mail',
        'New phone ticket from %s' => 'Novo chamado via fone de %s',
        'New email ticket to %s' => 'Novo chamado via e-mail de %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s está disponível!',
        'Please update now.' => 'Por favor atualize agora.',
        'Release Note' => 'Notas da Versão',
        'Level' => 'Nível',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postado há %s atrás.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'A configuração para essa estatística contém erros, favor rever suas configurações.',
        'Download as SVG file' => 'Baixar como arquivo SVG',
        'Download as PNG file' => 'Baixar como arquivo PNG',
        'Download as CSV file' => 'Baixar como arquivo CSV',
        'Download as Excel file' => 'Baixar como arquivo Excel',
        'Download as PDF file' => 'Baixar como arquivo PDF',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Por favor selecione um formato de saída de gráfico válido na configuração desse widget.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'O conteúdo desta estatística está sendo preparado para você, por favor seja paciente.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Essa estatística não pode ser usada nesse momento por que a configuração precisa ser corrigida pelo administrador de estatísticas.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Atribuído ao usuário cliente.',
        'Accessible for customer user' => 'Acessível para o usuário cliente.',
        'My locked tickets' => 'Meus Chamados Bloqueados',
        'My watched tickets' => 'Meus Chamados Monitorados',
        'My responsibilities' => 'Minhas Responsabilidades',
        'Tickets in My Queues' => 'Chamados nas Minhas Filas',
        'Tickets in My Services' => 'Chamados em Meus Serviços',
        'Service Time' => 'Tempo de Serviço',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Total',

        # Template: AgentDashboardUserOnline
        'out of office' => 'fora do escritório',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'até',

        # Template: AgentDynamicFieldDBDetailedSearch
        'Back' => 'Voltar',
        'Detailed search' => '',
        'Add an additional attribute' => '',

        # Template: AgentDynamicFieldDBDetails
        'Details view' => '',

        # Template: AgentElasticsearchQuickResult
        'Ticketnumber' => '',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Para aceitar algumas novidades, uma licença ou algumas mudanças.',
        'Yes, accepted.' => 'Sim, aceito.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Gerenciar links para %s',
        'Create new links' => 'Criar novos links',
        'Manage existing links' => 'Gerenciar links existentes',
        'Link with' => 'Estabelecer link com',
        'Start search' => 'Iniciar busca',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Não existem links no momento. Por favor clique em \'Criar novos links\' no topo para estabelecer um link entre este item e outro objeto.',

        # Template: AgentPassword
        'Password Policy' => '',
        'Your current password is older than %s days. You need to set a new one.' =>
            '',
        'Change password' => 'Alterar senha',
        'Current password' => 'Senha atual',
        'New password' => 'Nova senha',
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
        'Edit your preferences' => 'Alterar Suas Preferências',
        'Personal Preferences' => 'Preferências Pessoais',
        'Preferences' => 'Preferências',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Observe que você está editando a preferência %s no momento.',
        'Go back to editing this agent' => 'Retornar para a edição deste agente',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Defina suas preferências pessoais. Salve cada alteração ao clicar no ícone de verificação à direita.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Você pode utilizar a árvore de navegação abaixo para mostrar apenas as definições de determinados grupos.',
        'Dynamic Actions' => 'Ações Dinâmicas',
        'Filter settings...' => 'Filtrar configurações...',
        'Filter for settings' => 'Filtrar por configurações',
        'Save all settings' => 'Salvar todas configurações',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Avatares foram desabilitados pelo administrador do sistema. Em vez disso, você verá suas iniciais.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Você pode alterar a sua imagem de avatar registrando-se com sua conta de e-mail %s em %s. Por favor note que pode levar algum tempo até que o seu novo avatar fique disponível por conta do cache.',
        'Off' => 'Desligado',
        'End' => 'Fim',
        'This setting can currently not be saved.' => 'Esta configuração não pode ser salva no momento.',
        'This setting can currently not be saved' => 'Esta configuração não pode ser salva no momento',
        'Save this setting' => 'Salvar esta configuração',
        'Did you know? You can help translating OTOBO at %s.' => 'Você sabia? Você pode ajudar a traduzir o OTOBO em %s.',

        # Template: SettingsList
        'Reset to default' => 'Retornar ao padrão',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Escolha entre os grupos à direita para encontrar as definições que você deseja alterar.',
        'Did you know?' => 'Você sabia?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Você pode alterar seu avatar ao registrar seu endereço de e-mail %s em %s',

        # Template: AgentSplitSelection
        'Target' => 'Alvo',
        'Process' => 'Processo',
        'Split' => 'Dividir',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Gestão de Estatísticas',
        'Add Statistics' => 'Adicionar estatísticas',
        'Read more about statistics in OTOBO' => 'Leia mais sobre estatísticas no OTOBO',
        'Dynamic Matrix' => 'Matriz Dinâmica ',
        'Each cell contains a singular data point.' => 'Cada célula contém um ponto de dado singular.',
        'Dynamic List' => 'Lista Dinâmica',
        'Each row contains data of one entity.' => 'Cada linha contem dado de uma entidade.',
        'Static' => 'Estático',
        'Non-configurable complex statistics.' => 'Estatísticas complexas não configuráveis.',
        'General Specification' => 'Especificação Geral',
        'Create Statistic' => 'Criar Estatística',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Editar Estatísticas',
        'Run now' => 'Executar agora',
        'Statistics Preview' => 'Pré-visualização da Estatística ',
        'Save Statistic' => 'Salvar Estatística',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Importar Estatísticas',
        'Import Statistics Configuration' => 'Importar Configurações de Estatísticas',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Estatísticas',
        'Run' => 'Executar',
        'Edit statistic "%s".' => 'Editar estatística "%s".',
        'Export statistic "%s"' => 'Exportar estatística "%s"',
        'Export statistic %s' => 'Exportar estatística %s',
        'Delete statistic "%s"' => 'Excluir estatística "%s"',
        'Delete statistic %s' => 'Excluir estatística %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Visão Geral de Estatísticas',
        'View Statistics' => 'Visualizar Estatísticas',
        'Statistics Information' => 'Informações das Estatísticas',
        'Created by' => 'Criado por',
        'Changed by' => 'Alterado por',
        'Sum rows' => 'Somar Linhas',
        'Sum columns' => 'Somar Colunas',
        'Show as dashboard widget' => 'Exibir como componente no painel',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Esta estatística contém erros de configuração e não pode ser gerada agora.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Alterar Texto Livre de %s%s',
        'Change Owner of %s%s%s' => 'Mudar proprietário de %s%s%s',
        'Close %s%s%s' => 'Fechar %s%s%s',
        'Add Note to %s%s%s' => 'Adicionar nota para %s%s%s',
        'Set Pending Time for %s%s%s' => 'Configurar horário de pendência para %s%s%s',
        'Change Priority of %s%s%s' => 'Alterar Prioridade de %s%s',
        'Change Responsible of %s%s%s' => 'Alterar Responsável de %s%s',
        'The ticket has been locked' => 'O chamado foi bloqueado',
        'Undo & close' => 'Desfazer e fechar',
        'Ticket Settings' => 'Configurações de Chamado',
        'Queue invalid.' => 'Fila inválida.',
        'Service invalid.' => 'Serviço inválido.',
        'SLA invalid.' => 'SLA inválido.',
        'New Owner' => 'Novo Proprietário',
        'Please set a new owner!' => 'Por favor, defina um novo proprietário!',
        'Owner invalid.' => 'Proprietário inválido.',
        'New Responsible' => 'Novo Responsável',
        'Please set a new responsible!' => 'Por favor, defina um novo responsável!',
        'Responsible invalid.' => 'Responsável inválido.',
        'Next state' => 'Próximo estado',
        'State invalid.' => 'Estado inválido.',
        'For all pending* states.' => 'Para todos os estados *pendente*.',
        'Add Article' => 'Adicionar Artigo',
        'Create an Article' => 'Criar um Artigo',
        'Inform agents' => 'Informar atendentes',
        'Inform involved agents' => 'Informar atendentes envolvidos',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Aqui você pode selecionar atendentes adicionais que deveriam receber uma notificação relacionada ao novo artigo.',
        'Text will also be received by' => 'Texto também será recebido por',
        'Text Template' => 'Modelo de Texto',
        'Setting a template will overwrite any text or attachment.' => 'Configurar um modelo irá sobrescrever qualquer texto ou anexo.',
        'Invalid time!' => 'Horário Inválido',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Repassar %s%s%s',
        'Bounce to' => 'Devolver para',
        'You need a email address.' => 'Você precisa de um endereço de e-mail.',
        'Need a valid email address or don\'t use a local email address.' =>
            'ecessita de um endereço de e-mail válido; não use endereços de e-mail locais.',
        'Next ticket state' => 'Próximo Estado do Chamado',
        'Inform sender' => 'Informar ao Remetente',
        'Send mail' => 'Enviar e-mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Ação em Massa em Chamado',
        'Send Email' => 'Enviar E-mail',
        'Merge' => 'Agrupar',
        'Merge to' => 'Agrupar com',
        'Invalid ticket identifier!' => 'Identificador de chamado inválido!',
        'Merge to oldest' => 'Agrupar com o mais antigo',
        'Link together' => 'Associar junto',
        'Link to parent' => 'Associar ao pai',
        'Unlock tickets' => 'Desbloquear chamados',
        'Execute Bulk Action' => 'Executar Ação em Massa',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Compor resposta para %s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Esse endereço está registrado como endereço do sistema e não pode ser usado: %s',
        'Please include at least one recipient' => 'Por favor, inclua pelo menos um destinatário',
        'Select one or more recipients from the customer user address book.' =>
            'Selecione um ou mais destinatários do caderno de endereço do usuário cliente.',
        'Customer user address book' => 'Caderno de endereços do Usuário Cliente',
        'Remove Ticket Customer' => 'Remover Cliente do Chamado',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Por favor, remova esta entrada e digite uma nova com o valor correto.',
        'This address already exists on the address list.' => 'Este endereço já existe na lista de endereços.',
        'Remove Cc' => 'Remover Cc',
        'Bcc' => 'Cópia Oculta',
        'Remove Bcc' => 'Remover Bcc',
        'Date Invalid!' => 'Data Inválida!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Alterar Cliente de %s%s',
        'Customer Information' => 'Informação do Cliente',
        'Customer user' => 'Usuário cliente',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Criar Novo Chamado Via E-mail',
        'Example Template' => 'Exemplo de Modelo',
        'To customer user' => 'Para usuário cliente',
        'Please include at least one customer user for the ticket.' => 'Por favor, inclua ao menos um usuário cliente para este chamado.',
        'Select this customer as the main customer.' => 'Selecione este cliente como principal',
        'Remove Ticket Customer User' => 'Remover Usuário Cliente do Chamado',
        'From queue' => 'Da Fila',
        'Get all' => 'Obter todos',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'E-mail de saída para %s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Reenvie E-mail para %s%s%s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Chamado %s: tempo de resposta inicial ultrapassado (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Chamado %s: tempo de resposta inicial será ultrapassado em %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Chamado %s: tempo de atualização está ultrapassado (%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Chamado %s: tempo de atualização será ultrapassado em %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Chamado %s: tempo de solução ultrapassado (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Chamado %s: tempo de solução será ultrapassado em %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Encaminhar %s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Histórico de %s%s',
        'Filter for history items' => 'Filtro para itens do histórico',
        'Expand/collapse all' => 'Expandir/Colapsar todos',
        'CreateTime' => 'Tempo de criação',
        'Article' => 'Artigo',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Agrupar %s%s',
        'Merge Settings' => 'Configurações de Agrupamento',
        'You need to use a ticket number!' => 'Você deve utilizar um número de chamado!',
        'A valid ticket number is required.' => 'Um número de chamado válido é obrigatório.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Tente digitar uma parte do número do ticket ou do título de forma a pesquisar por ele.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Limitar a pesquisa por tickets com o mesmo ID de Cliente (%s).',
        'Inform Sender' => 'Informar Remetente',
        'Need a valid email address.' => 'É necessário um endereço de e-mail válido.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Mover %s%s',
        'New Queue' => 'Nova Fila',
        'Move' => 'Mover',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Nenhum dado de chamado encontrado.',
        'Open / Close ticket action menu' => 'Menu de Abrir / Fechar chamado',
        'Select this ticket' => 'Selecionar esse chamado',
        'Sender' => 'Remetente',
        'First Response Time' => 'Prazo de Resposta Inicial',
        'Update Time' => 'Prazo de Atualização',
        'Solution Time' => 'Prazo de Solução',
        'Move ticket to a different queue' => 'Mover Chamado Para Uma Fila Diferente',
        'Change queue' => 'Alterar fila',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Remover filtros ativos para esta tela.',
        'Tickets per page' => 'Chamados por página',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Canal faltando',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Redefinir visão',
        'Column Filters Form' => 'Formulário de Filtros de Coluna',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Dividir em Novo Chamado Fone',
        'Save Chat Into New Phone Ticket' => 'Salvar Chat em Novo Chamado Fone',
        'Create New Phone Ticket' => 'Criar Novo Chamado Via Fone',
        'Please include at least one customer for the ticket.' => 'Por favor, inclua pelo menos um cliente para o chamado.',
        'To queue' => 'Para a fila',
        'Chat protocol' => 'Protocolo de bate-papo',
        'The chat will be appended as a separate article.' => 'A conversa será adicionada como um artigo separado.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Telefonema para %s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Visualizar texto do E-mail para %s%s%s',
        'Plain' => 'Plano',
        'Download this email' => 'Baixar este e-mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Criar Novo Chamado de Processo',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Registrar chamado em um Processo',

        # Template: AgentTicketSearch
        'Profile link' => 'Linkar Modelo',
        'Output' => 'Saída',
        'Fulltext' => 'Texto Completo',
        'Customer ID (complex search)' => 'ID de Cliente (pesquisa complexa)',
        '(e. g. 234*)' => '(ex.: 234*)',
        'Customer ID (exact match)' => 'ID de Cliente (correspondência exata)',
        'Assigned to Customer User Login (complex search)' => 'Designado para o Login de Usuário Cliente (pesquisa complexa)',
        '(e. g. U51*)' => '(ex.: U51*)',
        'Assigned to Customer User Login (exact match)' => 'Designado para o Login de Usuário Cliente (correspondência exata)',
        'Accessible to Customer User Login (exact match)' => 'Acessível para o Login de Usuário Cliente (correspondência exata)',
        'Created in Queue' => 'Criado na Fila',
        'Lock state' => 'Estado de bloqueio',
        'Watcher' => 'Monitorante',
        'Article Create Time (before/after)' => 'Tempo de Criação do Artigo (antes/depois)',
        'Article Create Time (between)' => 'Tempo de Criação do Artigo (entre)',
        'Please set this to value before end date.' => 'Por favor, defina este valor para antes da data de término.',
        'Please set this to value after start date.' => 'Por favor, defina este valor para depois da data de início.',
        'Ticket Create Time (before/after)' => 'Tempo de Criação do Chamado (antes/depois)',
        'Ticket Create Time (between)' => 'Tempo de Criação do Chamado (entre)',
        'Ticket Change Time (before/after)' => 'Tempo de Modificação do Chamado (antes/depois)',
        'Ticket Change Time (between)' => 'Tempo de Modificação do Chamado (entre)',
        'Ticket Last Change Time (before/after)' => 'Tempo da Última Modificação do Chamado (antes/depois)',
        'Ticket Last Change Time (between)' => 'Tempo da Última Modificação do Chamado (entre)',
        'Ticket Pending Until Time (before/after)' => 'Ticket Pendete Até o Horário (antes/depois)',
        'Ticket Pending Until Time (between)' => 'Ticket Pendete Até o Horário (entre)',
        'Ticket Close Time (before/after)' => 'Tempo de Fechamento do Chamado (antes/depois)',
        'Ticket Close Time (between)' => 'Tempo de Fechamento do Chamado (durante)',
        'Ticket Escalation Time (before/after)' => 'Tempo de Escalação do Chamado (antes/depois)',
        'Ticket Escalation Time (between)' => 'Tempo de Escalação do Chamado (entre)',
        'Archive Search' => 'Procurar Arquivo',

        # Template: AgentTicketZoom
        'Sender Type' => 'Tipo de Remetente',
        'Save filter settings as default' => 'Salvar configurações de filtro como padrão',
        'Event Type' => 'Tipo de Evento',
        'Save as default' => 'Salvar como padrão',
        'Drafts' => 'Rascunhos',
        'Change Queue' => 'Alterar Fila',
        'There are no dialogs available at this point in the process.' =>
            'Não existem diálogos disponíveis neste ponto do processo.',
        'This item has no articles yet.' => 'Este item não tem artigos ainda.',
        'Ticket Timeline View' => 'Visão da Cronologia do Chamado',
        'Article Overview - %s Article(s)' => 'Visão Geral de Artigos - %s Artigo(s)',
        'Page %s' => 'Página %s',
        'Add Filter' => 'Adicionar Filtro',
        'Set' => 'Configurar',
        'Reset Filter' => 'Reiniciar Filtro',
        'No.' => 'Núm.',
        'Unread articles' => 'Artigos Não Lidos',
        'Via' => 'Via',
        'Important' => 'Importante',
        'Unread Article!' => 'Artigo não Lido!',
        'Incoming message' => 'Mensagem de Entrada',
        'Outgoing message' => 'Mensagem de Saída',
        'Internal message' => 'Mensagem Interna',
        'Sending of this message has failed.' => 'O envio desta mensagem falhou.',
        'Resize' => 'Redimensionar',
        'Mark this article as read' => 'Marcar este artigo como lido',
        'Show Full Text' => 'Mostrar Texto completo',
        'Full Article Text' => 'Texto Completo do Artigo',
        'No more events found. Please try changing the filter settings.' =>
            'Nenhum outro evento foi encontrado. Por favor tente mudar as configurações de filtro.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'via %s',
        'by %s' => 'por %s',
        'Toggle article details' => 'Exibir detalhes do artigo',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Esta mensagem está sendo processada. Já foi(ram) feita(s) %s tentativa(s) de envio. Próxima tentativa será %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Para abrir links no artigo seguinte, talvez você precise pressionar Ctrl, Cmd ou Shift enquanto clica no link (dependendo do seu navegador ou sistema operacional).',
        'Close this message' => 'Fechar esta mensagem',
        'Image' => 'Imagem',
        'PDF' => 'PDF',
        'Unknown' => 'Desconhecido',
        'View' => 'Ver',

        # Template: LinkTable
        'Linked Objects' => 'Objetos Associados',

        # Template: TicketInformation
        'Archive' => 'Arquivar',
        'This ticket is archived.' => 'Este chamado está arquivado.',
        'Note: Type is invalid!' => 'Nota: Tipo é inválido!',
        'Pending till' => 'Pendente até',
        'Locked' => 'Bloqueio',
        '%s Ticket(s)' => '%s Ticket(s)',
        'Accounted time' => 'Tempo Contabilizado',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'Visualização deste artigo não é possível por que o canal %s está faltando neste sistema.',
        'Please re-install %s package in order to display this article.' =>
            'Por favor, reinstale o pacote %s para exibir este artigo.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Para proteger sua privacidade, o conteúdo remoto foi desabilitado.',
        'Load blocked content.' => 'Carregar conteúdo bloqueado.',

        # Template: Breadcrumb
        'Home' => 'Início',
        'Back to admin overview' => 'Retornar para a visão geral da administração',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Esta Funcionalidade Necessita de Serviços em Nuvem',
        'You can' => 'Você pode',
        'go back to the previous page' => 'retornar à página anterior',

        # Template: CustomerAccept
        'Yes, I accepted your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'Este ID de cliente não é alterável. Nenhum outro ID de cliente pode ser atribuído a este ticket.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Primeiro selecione um usuário cliente, então você poderá selecionar uma ID de cliente para atribuir a este ticket.',
        'Select a customer ID to assign to this ticket.' => 'Selecione uma ID de cliente para atribuir a este ticket.',
        'From all Customer IDs' => 'De todos IDs de Cliente',
        'From assigned Customer IDs' => 'De IDs de Cliente designados.',

        # Template: CustomerDashboard
        'Ticket Search' => '',
        'New Ticket' => 'Novo Chamado',

        # Template: CustomerError
        'An Error Occurred' => 'Ocorreu um erro.',
        'Error Details' => 'Detalhes do Erro',
        'Traceback' => 'Rastreamento',

        # Template: CustomerFooter
        'Powered by %s' => 'Powered by %s',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s detectou possíveis problemas de rede. Você pode tentar atualizar a página manualmente ou esperar até que seu navegador tenha reestabelecido a conexão por si só.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'A conexão foi restabelecida após uma perda temporária de conexão. Por causa disso, elementos nesta página podem ter parado de funcionar corretamente. Para ser capaz de novamente usar todos elementos corretamente, é altamente recomendado recarregar esta página.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript não habilitado ou não é suportado.',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Para utilizar este software, você precisa ativar JavaScript em seu navegador.',
        'Browser Warning' => 'Aviso de Navegador',
        'The browser you are using is too old.' => 'O navegador que você está usando é muito antigo.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Este software roda com uma lista imensa de navegadores. Por favor, atualize para um deles.',
        'Please see the documentation or ask your admin for further information.' =>
            'Por favor, consulte a documentação ou pergunte ao seu administrador para mais informações.',
        'The browser you are using doesn\'t support css-grid. It\'s likely too old.' =>
            '',
        'An Internet Explorer compatible version will soon be released nonetheless.' =>
            '',
        'One moment please, you are being redirected...' => 'Um momento por favor, você está sendo redirecionado...',
        'Login' => 'Login',
        'Your user name' => 'Seu nome de usuário',
        'User name' => 'Nome de usuário',
        'Your password' => 'Sua senha',
        'Forgot password?' => 'Esqueceu a senha?',
        'Your 2 Factor Token' => 'Seu fator de 2 autenticação',
        '2 Factor Token' => 'Fator de 2 autenticação',
        'Log In' => 'Entrar',
        'Request Account' => '',
        'Request New Password' => 'Solicitar uma nova senha',
        'Your User Name' => 'Seu Nome de Usuário',
        'A new password will be sent to your email address.' => 'Uma nova senha será enviada ao seu e-mail.',
        'Create Account' => 'Criar Conta',
        'Please fill out this form to receive login credentials.' => 'Por favor, preencha este formulário para receber as credenciais de autenticação.',
        'How we should address you' => 'Como devemos descrever você?',
        'Your First Name' => 'Seu Primeiro Nome',
        'Your Last Name' => 'Seu Último Nome',
        'Your email address (this will become your username)' => 'Seu e-mail (este será seu nome de usuário para login)',

        # Template: CustomerNavigationBar
        'Logout' => 'Sair',

        # Template: CustomerPassword
        'Change Password' => '',
        'Password needs to contain at least 3 of the character classes: lower char, upper char, digit, special character.' =>
            '',

        # Template: CustomerTicketList
        'Nr.' => '',
        'Welcome!' => 'Bem-vindo!',
        'You have no tickets yet. Please click here, to create a new one.' =>
            '',
        'Nothing to show.' => '',
        'Click here for an unfiltered list of all your tickets.' => '',

        # Template: CustomerTicketMessage
        'Issue a new Ticket' => '',
        'Service level agreement' => 'Acordo de nível de serviço',

        # Template: CustomerTicketOverview
        'Your Tickets' => '',
        'Page' => 'Página',
        'Tickets' => 'Chamados',
        'Sort' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Perfil',
        'e. g. 10*5155 or 105658*' => 'ex. 10*5155 ou 105658*',
        'CustomerID' => 'ID do Cliente',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Tipos',
        'Time Restrictions' => 'Restrições de tempo',
        'No time settings' => 'Sem configurações de tempo',
        'All' => 'Todas',
        'Specific date' => 'Data específica',
        'Only tickets created' => 'Apenas chamados criados',
        'Date range' => 'Período de data',
        'Only tickets created between' => 'Apenas chamados criados entre',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Salvar como Modelo?',
        'Save as Template' => 'Salvar como Modelo',
        'Template Name' => 'Nome do Modelo',
        'Pick a profile name' => 'Escolha um nome de perfil',
        'Output to' => 'Saída para',

        # Template: CustomerTicketSearchResultShort
        'of' => 'de',
        'Search Results for' => 'Resultados da pesquisa para',
        'Remove this Search Term.' => 'Remova esse termo da pesquisa',

        # Template: CustomerTicketZoom
        'Reply' => 'Responder',
        'Discard' => '',
        'Ticket Information' => 'Informação do Chamado',
        'Categories' => '',

        # Template: Chat
        'Expand article' => 'Expandir artigo',

        # Template: MIMEBase
        'Article Information' => '',

        # Template: CustomerWarning
        'Warning' => 'Aviso',

        # Template: Tile_NewTicket
        'Issue<br/>a ticket' => '',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Informação do Evento',
        'Ticket fields' => 'Campos de chamado',

        # Template: Error
        'Send a bugreport' => 'Enviar um relatório de erro',
        'Expand' => 'Expandir',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Clique para remover este anexo.',

        # Template: DraftButtons
        'Update draft' => 'Atualizar rascunho',
        'Save as new draft' => 'Salvar como novo rascunho',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Você carregou o rascunho "%s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Você carregou o rascunho "%s". Sua última atualização foi em %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Você carregou o rascunho "%s". A última alteração foi em %s por %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Por favor, observer que este rascunho está desatualizado já que o chamado foi alterado desde quando o rascunho foi criado.',

        # Template: Header
        'Edit personal preferences' => 'Editar preferências pessoais',
        'Personal preferences' => 'Preferências Pessoais',
        'You are logged in as' => 'Você está logado como',

        # Template: Installer
        'JavaScript not available' => 'JavaScript não habilitado ou não é suportado.',
        'Step %s' => 'Passo %s',
        'License' => 'Licença',
        'Database Settings' => 'Configurações de Banco de Dados',
        'General Specifications and Mail Settings' => 'Especificações Gerais e Configurações de E-mail',
        'Finish' => 'Finalizar',
        'Welcome to %s' => 'Bem-vindo a %s',
        'Germany' => 'Alemanha',
        'Phone' => 'Telefone',
        'Switzerland' => '',
        'Web site' => 'Website',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Configurar E-mail de Saída',
        'Outbound mail type' => 'Tipo de E-mail de Saída',
        'Select outbound mail type.' => 'Selecione o tipo de e-mail de saída.',
        'Outbound mail port' => 'Porta do e-mail de saída',
        'Select outbound mail port.' => 'Selecionar a porta do e-mail de saída.',
        'SMTP host' => 'Servidor SMTP',
        'SMTP host.' => 'Servidor SMTP.',
        'SMTP authentication' => 'Autenticação SMPT',
        'Does your SMTP host need authentication?' => 'Seu servidor SMTP precisa de autenticação?',
        'SMTP auth user' => 'Usuário de autenticação SMTP',
        'Username for SMTP auth.' => 'Usuário para autenticação SMTP.',
        'SMTP auth password' => 'Senha de autenticação SMTP',
        'Password for SMTP auth.' => 'Senha para autenticação SMTP.',
        'Configure Inbound Mail' => 'Configurar E-mail de Entrada',
        'Inbound mail type' => 'Tipo de e-mail de entrada',
        'Select inbound mail type.' => 'Selecionar tipo de e-mail de entrada',
        'Inbound mail host' => 'Servidor de e-mail de entrada',
        'Inbound mail host.' => 'Servidor de e-mail de entrada.',
        'Inbound mail user' => 'Usuário de e-mail de entrada',
        'User for inbound mail.' => 'Usuário para e-mail de entrada.',
        'Inbound mail password' => 'Senha de e-mail de entrada',
        'Password for inbound mail.' => 'Senha para e-mail de entrada.',
        'Result of mail configuration check' => 'Resultado da verificação da configuração de e-mail',
        'Check mail configuration' => 'Verificar configuração de e-mail',
        'Skip this step' => 'Pular este passo',

        # Template: InstallerDBResult
        'Done' => 'Feito',
        'Error' => 'Erro',
        'Database setup successful!' => 'Sucesso na configuração do banco de dados!',

        # Template: InstallerDBStart
        'Install Type' => 'Tipo de Instalação',
        'Create a new database for OTOBO' => 'Criar um novo banco para o OTOBO',
        'Use an existing database for OTOBO' => 'Usar um banco existente para o OTOBO',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Se você tiver configurado uma senha root paro seu banco de dados, ela deve ser introduzida aqui. Se não, deixe o campo em branco.',
        'Database name' => 'Nome do banco',
        'Check database settings' => 'Verificar configurações de banco de dados',
        'Result of database check' => 'Resultado da verificação de banco de dados',
        'Database check successful.' => 'Êxito na verificação de banco de dados.',
        'Database User' => 'Usuário do Banco',
        'New' => 'Nova',
        'A new database user with limited permissions will be created for this OTOBO system.' =>
            'Um novo usuário de banco de dados com direitos limitados será criado para este sistema OTOBO.',
        'Repeat Password' => 'Repita a senha',
        'Generated password' => 'Gerar senha',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Senhas não coincidem',

        # Template: InstallerFinish
        'To be able to use OTOBO you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Para poder utilizar o OTOBO você deve digitar o seginte na linha de comando (terminal/shell) como usuário administrador (root)',
        'Restart your webserver' => 'Reiniciar o webserver',
        'After doing so your OTOBO is up and running.' => 'Após fazer isto, seu sistema OTOBO estará pronto para uso.',
        'Start page' => 'Iniciar página',
        'Your OTOBO Team' => 'Sua Equipe de Suporte',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Não aceitar licença',
        'Accept license and continue' => 'Aceite licença e continue',

        # Template: InstallerSystem
        'SystemID' => 'ID do sistema',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'O identificador do sistema. Cada número de chamado e cada ID de sessão HTTP conterão esse número.',
        'System FQDN' => 'FQDN do sistema',
        'Fully qualified domain name of your system.' => 'Nome de domínio completamente qualificado do seu sistema.',
        'AdminEmail' => 'E-mail dos Administradores',
        'Email address of the system administrator.' => 'E-mail do administrador do sistema.',
        'Organization' => 'Organização',
        'Log' => 'Registro',
        'LogModule' => 'Módulo REGISTRO',
        'Log backend to use.' => 'Protocolo de back-end a ser usado.',
        'LogFile' => 'Arquivo de registro',
        'Webfrontend' => 'Interface Web',
        'Default language' => 'Idioma Padrão',
        'Default language.' => 'Idioma Padrão.',
        'CheckMXRecord' => 'Verificar Registro MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Endereços de e-mail que são inseridos manualmente são confrontados com os registros MX encontrados no DNS. Não use esta opção se o seu DNS é lento ou não resolve endereços públicos.',

        # Template: LinkObject
        'Delete link' => 'Excluir link',
        'Delete Link' => 'Excluir link',
        'Object#' => 'Objeto#',
        'Add links' => 'Adicionar Associações',
        'Delete links' => 'Deletar Associações',

        # Template: Login
        'Lost your password?' => 'Esqueceu sua senha?',
        'Back to login' => 'Voltar para o login',

        # Template: MetaFloater
        'Scale preview content' => 'Escalar conteúdo anterior',
        'Open URL in new tab' => 'Abrir URL em nova aba',
        'Close preview' => 'Fechar Pré-visualização',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Uma prévia deste site não pode ser fornecida porque ele não é permitido ser embutido.',

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
        'Feature not Available' => 'Funcionalidade não Disponível',
        'Sorry, but this feature of OTOBO is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Desculpe mas esse recurso do OTOBO não está disponível para dispositivos móveis. Se você quer utilizá-lo, você pode mudar para o modo de Desktop ou usar seu computador.',

        # Template: Motd
        'Message of the Day' => 'Mensagem do Dia',
        'This is the message of the day. You can edit this in %s.' => 'Esta é a mensagem do dia. Você pode editá-la em %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Permissões Insuficientes',
        'Back to the previous page' => 'Voltar para a página anterior',

        # Template: Alert
        'Alert' => 'Alerta',
        'Powered by' => 'Desenvolvido por',

        # Template: Pagination
        'Show first page' => 'Mostrar Primeira Página',
        'Show previous pages' => 'Mostrar Página Anterior',
        'Show page %s' => 'Mostrar Página %s',
        'Show next pages' => 'Mostrar Próxima Página',
        'Show last page' => 'Mostrar Última Página',

        # Template: PictureUpload
        'Need FormID!' => 'Necessário FormID!',
        'No file found!' => 'Nenhum arquivo encontrado!',
        'The file is not an image that can be shown inline!' => 'O arquivo não é uma imagem que pode ser mostrada embutida!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Nenhuma notificação configurável de usuário foi encontrada.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Receba mensagens de notificações \'%s\' pelo método de transporte \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Informação de Processo',
        'Dialog' => 'Diálogo',

        # Template: Article
        'Inform Agent' => 'Informar Atendente',

        # Template: PublicDefault
        'Welcome' => 'Bem-vindo',
        'This is the default public interface of OTOBO! There was no action parameter given.' =>
            'Esta é a interface pública padrão do OTOBO! Não foi dado nenhum parâmetro de ação.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Você pode instalar um módulo público customizado (por meio do gerenciador de pacotes), por exemplo o módulo de FAQ, o qual possui uma interface pública.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Permissões',
        'You can select one or more groups to define access for different agents.' =>
            'Você pode selecionar um ou mais grupos para definir o acesso de diferentes atendentes.',
        'Result formats' => 'Formatos de Resutaldo',
        'Time Zone' => 'Fuso Horário',
        'The selected time periods in the statistic are time zone neutral.' =>
            'O período selecionado na estatística é neutro quanto ao fuso horário.',
        'Create summation row' => 'Criar linha de somatória',
        'Generate an additional row containing sums for all data rows.' =>
            'Gerar uma linha adicional contendo somas para todas as linhas de dados.',
        'Create summation column' => 'Criar coluna de somatória',
        'Generate an additional column containing sums for all data columns.' =>
            'Gerar uma coluna adicional contendo somas para todas as colunas de dados.',
        'Cache results' => 'Resultado em cache',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Armazena em cache dados resultantes de estatísticas para serem usados em visualizações subsequentes com a mesma configuração (requer pelo menos um campo de tempo selecionado).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Prover a estatística como um componente que agentes podem ativar no painel.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Por favor note que habilitando esse widget do tipo dashboard irá ativar o cache para essa estatística no dashboard.',
        'If set to invalid end users can not generate the stat.' => 'Se configurado como inválido, usuários finais não poderão gerar a estatística.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Existem problemas na configuração desta estatística:',
        'You may now configure the X-axis of your statistic.' => 'Você pode agora configurar o eixo X da sua estatística.',
        'This statistic does not provide preview data.' => 'Esta estatística não oferece pré-visualização de dados.',
        'Preview format' => 'Formato de visão prévia',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Por favor, note que a visualização usa dados aleatórios e não considera os filtros de dados.',
        'Configure X-Axis' => 'Configure o eixo X',
        'X-axis' => 'Eixo-X',
        'Configure Y-Axis' => 'Configure o eixo Y',
        'Y-axis' => 'Eixo-Y',
        'Configure Filter' => 'Configurar Filtro',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Por favor, selecione apenas um elemento ou desabilite o botão "Fixo".',
        'Absolute period' => 'Periodo absoluto',
        'Between %s and %s' => 'Entre %s e %s',
        'Relative period' => 'Período relativo',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Os últimos %s completo e o periodo atual + próximo periodo completo %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Não permita alterações nesse elemento quando a estatística for gerada.',

        # Template: StatsParamsWidget
        'Format' => 'Formato',
        'Exchange Axis' => 'Trocar Eixo',
        'Configurable Params of Static Stat' => 'Parâmetros Configuráveis de Estatística Estática',
        'No element selected.' => 'Nenhum elemento selecionado.',
        'Scale' => 'Escala',
        'show more' => 'Mostrar mais',
        'show less' => 'Mostrar menos',

        # Template: D3
        'Download SVG' => 'Download SVG',
        'Download PNG' => 'Download PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'O período de tempo selecionado define o período de tempo padrão para esta estatística coletar dados.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Define a unidade de tempo que será usada para dividir o período de tempo selecionado em pontos de dados de relatórios.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Lembre-se de que a escala do Eixo Y tem que ser maior do que a escala do Eixo X (Por exemplo, Eixo X => Mês, Eixo Y => Ano).',

        # Template: SettingHistoryListCompare
        'On ' => '',
        'Reset to this value' => '',

        # Template: SettingsList
        'This setting is disabled.' => 'Esta definição está desativada.',
        'This setting is fixed but not deployed yet!' => 'Esta definição está fixa mas não foi implantada ainda!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Esta definição está sendo sobrescrita em %s e, por isso, não pode ser alterada aqui!',
        'Changing this setting is only available in a higher config level!' =>
            'A alteração dessa configuração está disponível somente em um nível de configuração mais elevado!',
        '%s (%s) is currently working on this setting.' => '%s (%s) está atuando nesta definição no momento.',
        'Toggle advanced options for this setting' => 'Alternar opções avançadas para esta definição',
        'Disable this setting, so it is no longer effective' => 'Desative esta definição para que ela deixa de ser efetiva',
        'Disable' => 'Desabilitar',
        'Enable this setting, so it becomes effective' => 'Ative esta definição para que ele se torne efetiva',
        'Enable' => 'Habilitar',
        'Reset this setting to its default state' => 'Redefinir esta definição para seu estado padrão',
        'Reset setting' => 'Redefinir definição',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Permitir que usuários ajustem esta definição de dentro de suas preferências pessoais',
        'Allow users to update' => 'Permitir que usuários atualizem',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Não permitir mais que usuários ajustem esta definição em suas preferências pessoais',
        'Forbid users to update' => 'Proibir que usuários atualizem',
        'Show user specific changes for this setting' => 'Mostrar alterações específicas de usuários para esta configuração',
        'Show user settings' => 'Mostrar configurações de usuário',
        'Copy a direct link to this setting to your clipboard' => 'Copiar um link direto a esta definição para o seu clipboard',
        'Copy direct link' => 'Copiar link direto',
        'Remove this setting from your favorites setting' => 'Remover esta definição de suas definições favoritas',
        'Remove from favourites' => 'Remover dos favoritos',
        'Add this setting to your favorites' => 'Adicione essa definição às suas favoritas',
        'Add to favourites' => 'Adicionar aos favoritos',
        'Cancel editing this setting' => 'Cancele a edição desta definição',
        'Save changes on this setting' => 'Salvar mudanças nesta definição',
        'Edit this setting' => 'Editar esta definição',
        'Enable this setting' => 'Ativar esta definição',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Este grupo não contém definições. Por favor, tente navegar para um de seus subgrupos ou para outro grupo.',

        # Template: SettingsListCompare
        'Now' => 'Agora',
        'User modification' => 'Modificação de usuário',
        'enabled' => 'ativado',
        'disabled' => 'desativado',
        'Setting state' => 'Estado da definição',

        # Template: Actions
        'Edit search' => 'Editar pesquisa',
        'Go back to admin: ' => 'Voltar para administração:',
        'Deployment' => 'Implantação',
        'My favourite settings' => 'Minhas definições favoritas',
        'Invalid settings' => 'Definições inválidas',

        # Template: DynamicActions
        'Filter visible settings...' => 'Configurações do filtro de visibilidade...',
        'Enable edit mode for all settings' => 'Habilitar modo de edição para todas as configurações',
        'Save all edited settings' => 'Salvar todas definições editadas',
        'Cancel editing for all settings' => 'Cancelar a edição de todas definições.',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Todas ações deste widget se aplicam às definições visíveis na direita apenas.',

        # Template: Help
        'Currently edited by me.' => 'Sendo editado por mim.',
        'Modified but not yet deployed.' => 'Alterado, mas ainda não implantado.',
        'Currently edited by another user.' => 'Sendo editada por um outro usuário.',
        'Different from its default value.' => 'Diferente do valor padrão.',
        'Save current setting.' => 'Salvar a definição atual.',
        'Cancel editing current setting.' => 'Cancelar a edição da definição atual.',

        # Template: Navigation
        'Navigation' => 'Navegação',

        # Template: UsersSettingListCompare
        'Delete user\'s value.' => '',

        # Template: Test
        'OTOBO Test Page' => 'Página de Teste do Gerenciador de Chamados',
        'Unlock' => 'Desbloquear',
        'Welcome %s %s' => 'Bem-vindo %s %s',
        'Counter' => 'Contador',

        # Template: Warning
        'Go back to the previous page' => 'Voltar para a página anterior',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Mostrar',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Título do rascunho',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Exibição de artigo',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Você realmente quer excluir "%s"?',
        'Confirm' => 'Confirmar',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Carregando, por favor aguarde...',

        # JS Template: ToggleMoreLessCustomer
        'Show all' => '',
        'Show less' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Clique para selecionar um arquivo para carregar.',
        'Click to select or drop files here.' => '',
        'Click to select files or just drop them here.' => 'Clique para selecionar os arquivos ou apenas arraste-os aqui.',
        'Click to select a file or just drop it here.' => 'Clique para selecionar o arquivo ou arraste-o aqui.',
        'Uploading...' => 'Carregando...',

        # JS Template: MigrationState
        'Time needed' => '',

        # JS Template: PackageResolve
        'Package' => '',
        'Uninstall from OTOBO' => '',
        'Ignore' => '',
        'Migrate' => '',

        # JS Template: InformationDialog
        'Process state' => 'Estado de processo',
        'Running' => 'Executando',
        'Finished' => 'Finalizado',
        'No package information available.' => 'Nenhuma informação de pacote disponível.',

        # JS Template: AddButton
        'Add new entry' => 'Adicionar nova entrada',

        # JS Template: AddHashKey
        'Add key' => 'Adicionar chave',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Comentário de implantação...',
        'This field can have no more than 250 characters.' => 'Este campo não pode ter mais de 250 caracteres.',
        'Deploying, please wait...' => 'Implantando, favor esperar...',
        'Preparing to deploy, please wait...' => 'Preparando para implantar, favor esperar...',
        'Deploy now' => 'Implantar agora',
        'Try again' => 'Tente novamente',

        # JS Template: DialogReset
        'Reset options' => 'Opções de redefinição',
        'Reset setting on global level.' => 'Redefinir definição a nível global.',
        'Reset globally' => 'Redefinir globalmente',
        'Remove all user changes.' => 'Remover todas mudanças de usuário',
        'Reset locally' => 'Redefinir localmente',
        'user(s) have modified this setting.' => 'usuário(s) modificou esta configuração.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Você realmente quer redefinir essa definição para seu valor padrão?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Você pode usar a seleção de categoria para limitar a árvore de navegação abaixo para entradas da categoria selecionada. Assim que você selecionar a categoria, a árvore será reconstruída.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'Backend de Banco de Dados',
        'CustomerIDs' => 'IDs do Cliente',
        'Fax' => 'Fax',
        'Street' => 'Rua',
        'Zip' => 'CEP',
        'City' => 'Cidade',
        'Country' => 'País',
        'Mr.' => 'Sr.',
        'Mrs.' => 'Sra.',
        'Address' => 'Endereço',
        'View system log messages.' => 'Ver mensagens de eventos do sistema.',
        'Edit the system configuration settings.' => 'Alterar parâmetros de configuração do sistema.',
        'Update and extend your system with software packages.' => 'Atualizar e estender as funcionalidades do seu sistema com pacotes de software.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'Informação da ACL no banco de dados não está sincronizada com a configuração do sistema, por favor implemente todas as ACLs.',
        'ACLs could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'ACLs não foram importadas devido a um erro desconhecido, por favor verifique os logs do OTOBO para mais informações.',
        'The following ACLs have been added successfully: %s' => 'As seguintes ACLs foram adicionadas com sucesso: %s',
        'The following ACLs have been updated successfully: %s' => 'As seguintes ACLs foram atualizadas com sucesso: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Ocorreram erros ao adicionar/atualizar as seguintes ACLs: %s. Por favor verifique o arquivo de log para mais informações.',
        'There was an error creating the ACL' => 'Ocorreu um erro ao criar a ACL',
        'Need ACLID!' => 'Necessário ACLID!',
        'Could not get data for ACLID %s' => 'Não foi possível obter dados da ACLID %s',
        'There was an error updating the ACL' => 'Houve um erro ao atualizar a ACL',
        'There was an error setting the entity sync status.' => 'Houve um erro ao configurar a status de sincronia da entidade',
        'There was an error synchronizing the ACLs.' => 'Houve um erro sincronizando a ACLs',
        'ACL %s could not be deleted' => 'ACL %s não pode ser excluída',
        'There was an error getting data for ACL with ID %s' => 'Houve um erro ao obter dados da ACL com ID %s',
        '%s (copy) %s' => '%s(copiar)%s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Favor observar que restrições de ACL serão ignoradas para a conta de Super Usuário (ID de Usuário 1).',
        'Exact match' => 'Correspondência exata',
        'Negated exact match' => 'Correspondência exata negada',
        'Regular expression' => 'Expressão Regular',
        'Regular expression (ignore case)' => 'Expressão Regular(ignora maiúsculas)',
        'Negated regular expression' => 'Expressão Regular negada',
        'Negated regular expression (ignore case)' => 'Expressão Regular negada(ignora maiúsculas)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Sistema não foi capaz de criar o Calendário!',
        'Please contact the administrator.' => 'Por favor, entre em contato com o administrador.',
        'No CalendarID!' => 'Nenhum CalendarID!',
        'You have no access to this calendar!' => 'Você não tem acesso a este calendário!',
        'Error updating the calendar!' => 'Erro ao atualizar o calendário!',
        'Couldn\'t read calendar configuration file.' => 'Não foi possível ler arquivo de configuração do calendário.',
        'Please make sure your file is valid.' => 'Por favor, verifique se o seu arquivo é válido.',
        'Could not import the calendar!' => 'Não foi possível importar o calendário!',
        'Calendar imported!' => 'Calendário importado!',
        'Need CalendarID!' => 'Necessário CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Não foi possível obter dados para determinado CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Importado com sucesso %s compromisso(s) para o calendário %s.',
        '+5 minutes' => '+5 minutos',
        '+15 minutes' => '+15 minutos',
        '+30 minutes' => '+30 minutos',
        '+1 hour' => '+1 hora',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Sem permissão',
        'System was unable to import file!' => 'Sistema não foi capaz de importar arquivo!',
        'Please check the log for more information.' => 'Por favor verifique o log para mais informações.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Nome da notificação já existe!',
        'Notification added!' => 'Notificação adicionada!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Houve um erro na obtenção de dados para a Notificação com ID:%s!',
        'Unknown Notification %s!' => 'Notificação Desconhecida %s!',
        '%s (copy)' => '%s(copiar)',
        'There was an error creating the Notification' => 'Houve algum erro ao criar a Notificação',
        'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information' =>
            'Notificações não puderam ser importadas devido a um erro desconhecido. Por favor verifique os logs do OTOBO para mais informações',
        'The following Notifications have been added successfully: %s' =>
            'As seguintes Notificações foram adicionados com êxito: %s',
        'The following Notifications have been updated successfully: %s' =>
            'As seguintes Notificações foram atualizados com sucesso: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Houve erros ao adicionar/atualizar as seguintes Notificações: %s. Por favor, verifique o log para mais informações!',
        'Notification updated!' => 'Notificação atualizada!',
        'Agent (resources), who are selected within the appointment' => 'Atendente (recursos), que são selecionados dentro do compromisso',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Todos os agentes com (no mínimo) permissão de leitura do compromisso (calendário)',
        'All agents with write permission for the appointment (calendar)' =>
            'Todos os atendentes com permissão de escrita no compromisso (calendário)',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Anexo adicionado!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Resposta automática adicionada!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'ID de Comunicação Inválido!',
        'All communications' => 'Todas comunicações',
        'Last 1 hour' => 'Última 1 hora',
        'Last 3 hours' => 'Últimas 3 horas',
        'Last 6 hours' => 'Últimas 6 horas',
        'Last 12 hours' => 'Últimas 12 horas',
        'Last 24 hours' => 'Últimas 24 horas',
        'Last week' => 'Última semana',
        'Last month' => 'Último mes',
        'Invalid StartTime: %s!' => 'Horário de Início Inválido: %s!',
        'Successful' => 'Com êxito',
        'Processing' => 'Processando',
        'Failed' => 'Falhou',
        'Invalid Filter: %s!' => 'Filtro Inválido: %s!',
        'Less than a second' => 'Menos de um segundo',
        'sorted descending' => 'Classificar Descendente',
        'sorted ascending' => 'Classificar Ascendente',
        'Trace' => 'Rastrear',
        'Debug' => 'Depurar',
        'Info' => 'Informação',
        'Warn' => 'Alertar',
        'days' => 'dias',
        'day' => 'dia',
        'hour' => 'hora',
        'minute' => 'minuto',
        'seconds' => 'segundos',
        'second' => 'segundo',

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
        'Customer company updated!' => 'Empresa de cliente atualizada!',
        'Dynamic field %s not found!' => 'Campo dinâmico %s não encontrado!',
        'Unable to set value for dynamic field %s!' => 'Não foi possível definir um valor para o campo dinâmico %s!',
        'Customer Company %s already exists!' => 'Empresa cliente %s já existe!',
        'Customer company added!' => 'Empresa de cliente adicionada!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Nenhuma configuração encontrada para \'CustomerGroupPermissionContext\'!',
        'Please check system configuration.' => 'Favor verificar a configuração do sistema.',
        'Invalid permission context configuration:' => 'Configuração de contexto de permissão inválido.',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Cliente atualizado!',
        'New phone ticket' => 'Novo chamado via fone',
        'New email ticket' => 'Novo chamado via e-mail',
        'Customer %s added' => 'Cliente %s adicionado',
        'Customer user updated!' => 'Usuário cliente atualizado!',
        'Same Customer' => 'Mesmo cliente',
        'Direct' => 'Direto',
        'Indirect' => 'Indireto',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Modifique a relação de Usuário Cliente para o Grupo',
        'Change Group Relations for Customer User' => 'Modifique a relação de Grupo para o Usuário Cliente',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Alocar Usuário Cliente a Serviço',
        'Allocate Services to Customer User' => 'Alocar Serviços a Usuário Cliente',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Configuração do campo não é válida.',
        'Objects configuration is not valid' => 'Configuração dos objetos não são válidas',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Não foi possível resetar corretamente a ordem do campo Dinâmico, verifique o log de erros para obter mais detalhes.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Sub-ação indefinida',
        'Need %s' => 'Necessário %s',
        'Add %s field' => 'Adicionar campo %s',
        'The field does not contain only ASCII letters and numbers.' => 'Esse campo não pode conter somente letras e números ASCII.',
        'There is another field with the same name.' => 'Há outra campo com o mesmo nome.',
        'The field must be numeric.' => 'Esse campo deve ser numérico.',
        'Need ValidID' => 'Necessário ValidID',
        'Could not create the new field' => 'Não foi possível criar o novo campo',
        'Need ID' => 'Necessário ID',
        'Could not get data for dynamic field %s' => 'Não foi possível obter dados do campo dinâmico %s',
        'Change %s field' => 'Alterar campo %s',
        'The name for this field should not change.' => 'O nome desse campo não pode ser alterado.',
        'Could not update the field %s' => 'Não foi possível atualizar o campo %s',
        'Currently' => 'Atualmente',
        'Unchecked' => 'Desmarcado',
        'Checked' => 'Marcado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldContactWD.pm
        'This field key is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDB.pm
        'This field value is duplicated.' => 'O valor deste campo está duplicado.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Prevenir entrada de datas no futuro',
        'Prevent entry of dates in the past' => 'Prevenir entrada de datas no passado',

        # Perl Module: Kernel/Modules/AdminDynamicFieldScreen.pm
        'Settings were saved.' => '',
        'System was not able to save the setting!' => '',
        'Setting is locked by another user!' => 'Definição está bloqueada por um outro usuário!',
        'System was not able to reset the setting!' => 'O sistema não conseguiu redefinir a definição!',
        'Settings were reset.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Selecione pelo menos um destinatário.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'minuto(s)',
        'hour(s)' => 'hora(s)',
        'Time unit' => 'Unidade de Tempo',
        'within the last ...' => 'nos últimos ...',
        'within the next ...' => 'nos próximos ...',
        'more than ... ago' => 'há mais de ... atrás',
        'Unarchived tickets' => 'Chamados não-arquivados',
        'archive tickets' => 'arquivar chamados',
        'restore tickets from archive' => 'restaurar chamados do arquivo',
        'Need Profile!' => 'Usuário Necessário!',
        'Got no values to check.' => 'Não tem nenhum valor para verificar.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Por favor, remova as seguintes palavras, porque não podem ser utilizados para a seleção de ticket:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID Necessário!',
        'Could not get data for WebserviceID %s' => 'Não foi possível obter dados para WebserviceID %s',
        'ascending' => 'ascendente',
        'descending' => 'descendente',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Necessita tipo de comunicação!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Tipo de comunicação precisa ser \'Requester\' ou \'Provider\'!',
        'Invalid Subaction!' => 'Subação Inválida!',
        'Need ErrorHandlingType!' => 'Necessita Tipo de Tratamento de Erro!',
        'ErrorHandlingType %s is not registered' => 'Tipo de Tratamento de Erro %s não foi registrado',
        'Could not update web service' => 'Não foi possível atualizar o webservice',
        'Need ErrorHandling' => 'Necessita de Tratamento de Erro',
        'Could not determine config for error handler %s' => 'Não foi possível determinar a configuração para tratamento de erro %s',
        'Invoker processing outgoing request data' => 'Invoker processando dados de solicitação enviada',
        'Mapping outgoing request data' => 'Mapeando dados de solicitação enviada',
        'Transport processing request into response' => 'Transporte processando solicitação na resposta',
        'Mapping incoming response data' => 'Mapeando dados de resposta recebidos',
        'Invoker processing incoming response data' => 'Invoker processando dados de resposta recebida',
        'Transport receiving incoming request data' => 'Transporte recebendo dados de solicitação recebida',
        'Mapping incoming request data' => 'Mapeando dados de solicitação recebida',
        'Operation processing incoming request data' => 'Operação processando dados de solicitação recebida',
        'Mapping outgoing response data' => 'Mapeando dados de resposta enviados',
        'Transport sending outgoing response data' => 'Transporte enviando dados de resposta enviada',
        'skip same backend modules only' => 'pular os mesmos módulos de backend apenas',
        'skip all modules' => 'pular todos módulos',
        'Operation deleted' => 'Operação excluída',
        'Invoker deleted' => 'Invoker excluído',

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
        '1 day' => '1 dia',
        '2 days' => '2 dias',
        '3 days' => '3 dias',
        '4 days' => '4 dias',
        '6 days' => '6 dias',
        '1 week' => '1 semana',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Não foi possível determinar a configuração para o invoker %s',
        'InvokerType %s is not registered' => 'InvokerType %s não está registrado',
        'MappingType %s is not registered' => 'Tipo de Mapeamento %s não registrado',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Invoker é necessário!',
        'Need Event!' => 'Necessita um Evento!',
        'Could not get registered modules for Invoker' => 'Não podemos registrar módulos para invoker',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => 'O Evento %s não é válido. ',
        'Could not update configuration data for WebserviceID %s' => 'Não foi possível atualizar dados de configuração para WebserviceID %s',
        'This sub-action is not valid' => 'Está sub ação não é válida',
        'xor' => 'xor',
        'String' => 'String',
        'Regexp' => '',
        'Validation Module' => 'Módulo de validação',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Não foi possível obter a configuração registrada para o tipo de ação %s',
        'Could not get backend for %s %s' => 'Não foi possível obter o backend para %s %s',
        'Keep (leave unchanged)' => 'Ignorar (deixar inalterado)',
        'Ignore (drop key/value pair)' => 'Ignorar (apagar par chave/valor)',
        'Map to (use provided value as default)' => 'Mapear para (use o valor fornecido como padrão)',
        'Exact value(s)' => 'Valor(es) exato(s)',
        'Ignore (drop Value/value pair)' => 'Ignorar (descartar valor/par de valor)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => 'Não foi possível encontrar a biblioteca necessária %s',
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
        'Could not determine config for operation %s' => 'Não foi possível determinar a configuração para a operação %s',
        'OperationType %s is not registered' => 'OperationType %s não está registrado',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Necessita Subação válida!',
        'This field should be an integer.' => 'Este campo deveria ser um inteiro.',
        'File or Directory not found.' => 'Arquivo ou Diretório não encontrado.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Há outro web service com o mesmo nome.',
        'There was an error updating the web service.' => 'Houve um erro ao atualizar o web service.',
        'There was an error creating the web service.' => 'Houve um erro ao criar o web service.',
        'Web service "%s" created!' => 'Web service "%s" criado!',
        'Need Name!' => 'Necessário Nome!',
        'Need ExampleWebService!' => 'Necessário ExampleWebService!',
        'Could not load %s.' => 'Não foi possível carregar %s.',
        'Could not read %s!' => 'Não pôde ser lido %s!',
        'Need a file to import!' => 'Necessário um arquivo para importar!',
        'The imported file has not valid YAML content! Please check OTOBO log for details' =>
            'O arquivo importado tem conteúdo YAML inválido! Por favor, verifique o log do OTOBO para obter mais detalhes',
        'Web service "%s" deleted!' => 'Web service "%s" excluído!',
        'OTOBO as provider' => 'OTOBO como provedor',
        'Operations' => 'Operações',
        'OTOBO as requester' => 'OTOBO como requisitante',
        'Invokers' => 'Invokers',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Não há WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Não foi possível obter dados do histórico para WebserviceHistoryID %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Grupo atualizado!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Conta de e-mail adicionada!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Captura de conta de e-mail já foi capturada por um outro processo. Por favor, tente novamente mais tarde!',
        'Dispatching by email To: field.' => 'Distribuição por e-mail por campo: "Para:"',
        'Dispatching by selected Queue.' => 'Distribuição por Fila selecionada',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Agente que criou o ticket.',
        'Agent who owns the ticket' => 'Atendente que possui o chamado',
        'Agent who is responsible for the ticket' => 'Atendente que é responsável pelo chamado',
        'All agents watching the ticket' => 'Todos os atendentes monitorando o chamado',
        'All agents with write permission for the ticket' => 'Todos os atendentes com permissão de escrita no chamado',
        'All agents subscribed to the ticket\'s queue' => 'Todos os atendentes assinantes da fila do chamado',
        'All agents subscribed to the ticket\'s service' => 'Todos os atendentes assinantes do serviço do chamado',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Todos os atendentes assinantes da fila e serviço do chamado',
        'Customer user of the ticket' => 'Usuário cliente do ticket',
        'All recipients of the first article' => 'Todos os destinatários do primeiro artigo',
        'All recipients of the last article' => 'Todos os destinatários do último artigo',
        'Invisible to customer' => 'Não visível para o cliente',
        'Visible to customer' => 'Visível para o cliente',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'Ambiente PGP não está funcionando. Por favor, verifique o log para mais informações!',
        'Need param Key to delete!' => 'Necessário o parâmetro Chave para deletar!',
        'Key %s deleted!' => 'Chave %s deletada!',
        'Need param Key to download!' => 'Necessário parâmetro Chave para o download!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otobo.Console.pl to install packages!' =>
            'Desculpe, Apache::Reload é necessário como PerlModule e PerlInitHandler no arquivo de configuração do Apache. Veja também scripts/apache2-httpd.include.conf. Alternativamente, você pode usar a ferramenta de linha de comando bin/otobo.Console.pl para instalar pacotes!',
        'No such package!' => 'Não existe este pacote!',
        'No such file %s in package!' => 'Arquivo inexistente %s no pacote!',
        'No such file %s in local file system!' => 'Arquivo inexistente %s no sistema de arquivos local!',
        'Can\'t read %s!' => 'Não pôde ser lido %s!',
        'File is OK' => 'Arquivo está ok',
        'Package has locally modified files.' => 'Pacote possui arquivos locais modificados.',
        'Package not verified by the OTOBO Team! It is recommended not to use this package.' =>
            'O pacote não foi verificado pelo Grupo OTRS! O seu uso não é recomendado.',
        'Not Started' => 'Não Iniciado',
        'Updated' => 'Atualizado',
        'Already up-to-date' => 'Atual',
        'Installed' => 'Instalado',
        'Not correctly deployed' => 'Implantado incorretamente',
        'Package updated correctly' => 'Pacote atualizado corretamente',
        'Package was already updated' => 'Pacote já foi atualizado',
        'Dependency installed correctly' => 'Dependência instalada corretamente',
        'The package needs to be reinstalled' => 'O pacote precisa ser reinstalado',
        'The package contains cyclic dependencies' => 'O pacote contém dependências cíclicas',
        'Not found in on-line repositories' => 'Não encontrado nos repositórios on-line',
        'Required version is higher than available' => 'Versão necessária é maior que a disponível',
        'Dependencies fail to upgrade or install' => 'Dependências falham ao atualizar ou instalar',
        'Package could not be installed' => 'O pacote não foi instalado.',
        'Package could not be upgraded' => 'O pacote não foi atualizado.',
        'Repository List' => 'Lista de Repositório',
        'No packages found in selected repository. Please check log for more info!' =>
            'Nenhum pacote encontrado no repositório selecionado. Favor verificar o log para mais informações!',
        'Package not verified due a communication issue with verification server!' =>
            'Pacote não verificado devido a um problema de comunicação com o servidor de verificação!',
        'Can\'t connect to OTOBO Feature Add-on list server!' => 'Não foi possível conectar com o servidor da lista de recursos adicionais (add-ons) da OTOBO!',
        'Can\'t get OTOBO Feature Add-on list from server!' => 'Não foi possível obter do servidor a lista de recursos adicionais (add-ons) da OTOBO!',
        'Can\'t get OTOBO Feature Add-on from server!' => 'Não foi possível obter do servidor o recurso adicional (add-on) da OTOBO!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Filtro inexistente: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Prioridade adicionada!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'As Informações do Gerenciamento de Processo do banco de dados não estão sincronizadas com as configurações do sistema, por favor, sincronize todos os processos.',
        'Need ExampleProcesses!' => 'Requer ExampleProcesses!',
        'Need ProcessID!' => 'Necessário ProcessID!',
        'Yes (mandatory)' => 'Sim (mandatório)',
        'Unknown Process %s!' => 'Processo Desconhecido %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Ocorreu um erro durante a geração de um novo EntityID para este processo',
        'The StateEntityID for state Inactive does not exists' => 'O StateEntityID para o estado Inativo não existe',
        'There was an error creating the Process' => 'Houve um erro ao criar o Processo',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de processo: %s',
        'Could not get data for ProcessID %s' => 'Não foi possível obter dados para ProcessID %s',
        'There was an error updating the Process' => 'Ocorreu um erro durante a atualização do processo',
        'Process: %s could not be deleted' => 'Processo: %s não pode ser excluído',
        'There was an error synchronizing the processes.' => 'Houve um erro na sincronização dos processos.',
        'The %s:%s is still in use' => 'O %s:%s ainda está em uso',
        'The %s:%s has a different EntityID' => 'O s%:%s tem um EntityID diferente',
        'Could not delete %s:%s' => 'Não foi possível deletar %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de %s: %s',
        'Could not get %s' => 'Não foi possível obter %s',
        'Need %s!' => 'Necessário %s!',
        'Process: %s is not Inactive' => 'Processo: %s não é Inativo',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta atividade',
        'There was an error creating the Activity' => 'Ocorreu um erro durante a criação da atividade',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Ocorreu um erro ao configurar o estado de sincronização da entidade de atividade: %s',
        'Need ActivityID!' => 'Necessário ActivityID!',
        'Could not get data for ActivityID %s' => 'Não foi possível obter dados para ActivityID %s',
        'There was an error updating the Activity' => 'Ocorreu um erro durante a atualização da atividade',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Parâmetro faltando: Necessário Activity  e ActivityDialog!',
        'Activity not found!' => 'Atividade não localizada!',
        'ActivityDialog not found!' => 'ActivityDialog não encontrado!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Janela já atribuída à atividade. Você não pode adicionar a mesma janela duas vezes!',
        'Error while saving the Activity to the database!' => 'Erro ao salvar a atividade no banco de dados!',
        'This subaction is not valid' => 'Esta subaction não é valida',
        'Edit Activity "%s"' => 'Editar Activity "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta janela de atividade',
        'There was an error creating the ActivityDialog' => 'Ocorreu um erro durante a criação da janela de atividade',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização da entidade para a janela de diálogo: %s',
        'Need ActivityDialogID!' => 'Necessário ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Não foi possível obter dados para ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'Ocorreu um erro durante a atualização da janela de atividade',
        'Edit Activity Dialog "%s"' => 'Editar Activity Dialog "%s"',
        'Agent Interface' => 'Interface do Agente',
        'Customer Interface' => 'Interface do Cliente',
        'Agent and Customer Interface' => 'Atendente e Interface do Cliente',
        'Do not show Field' => 'Não exibir campo',
        'Show Field' => 'Exibir Campo',
        'Show Field As Mandatory' => 'Exibir campo como mandatório',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Editar Path',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta transição',
        'There was an error creating the Transition' => 'Ocorreu um erro ao criar a alteração',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de transição: %s',
        'Need TransitionID!' => 'Necessário TransitionID!',
        'Could not get data for TransitionID %s' => 'Não foi possível obter dados para TransitionID %s',
        'There was an error updating the Transition' => 'Ocorreu um erro durante a atualização da transição',
        'Edit Transition "%s"' => 'Editar Transição "%s"',
        'Transition validation module' => 'Módulo de validação de transição',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Pelo menos, um parâmetro de configuração válido é necessário.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Ocorreu um erro durante a geração de um novo EntityID para esta ação de transição',
        'There was an error creating the TransitionAction' => 'Ocorreu um erro durante a criação da ação de transição',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Ocorreu um erro durante a configuração do estado de sincronização para a entidade de ação de transição: %s',
        'Need TransitionActionID!' => 'Necessário TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Não foi possível obter dados para TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'Ocorreu um erro durante a atualização da ação de transição',
        'Edit Transition Action "%s"' => 'Editar ação de transição "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Erro: Nem todas as chaves parecem ter valores ou vice versa.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Fila atualizada!',
        'Don\'t use :: in queue name!' => 'Não use :: no nome da fila!',
        'Click back and change it!' => 'Clique voltar para mudá-lo!',
        '-none-' => '-vazio-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Filas (sem auto respostas)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Alterar Relações de Fila para Modelo',
        'Change Template Relations for Queue' => 'Alterar Relações de Modelo para Fila',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produção',
        'Test' => 'Teste',
        'Training' => 'Treinamento',
        'Development' => 'Desenvolvimento',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Papel atualizado!',
        'Role added!' => 'Papel adicionado!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Alterar Relações de Grupo Para Papel',
        'Change Role Relations for Group' => 'Alterar Relações de Papel Para Grupo',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Papel',
        'Change Role Relations for Agent' => 'Alterar Relações de Papel Para Atendente',
        'Change Agent Relations for Role' => 'Alterar Relações de Atendente Para Papel',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Por favor, ative %s primeiro.',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'O ambiente S/MIME não está funcionando. Por favor, verifique o log para mais informações!',
        'Need param Filename to delete!' => 'Necessário o parâmetro Filename  para deletar!',
        'Need param Filename to download!' => 'Necessário o parâmetro Filename  para download!',
        'Needed CertFingerprint and CAFingerprint!' => 'Necessário CertFingerprint e CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint precisa ser diferente do CertFingerprint',
        'Relation exists!' => 'Relação já existe!',
        'Relation added!' => 'Associação adicionada!',
        'Impossible to add relation!' => 'Impossível adicionar relação!',
        'Relation doesn\'t exists' => 'Associação não existe',
        'Relation deleted!' => 'Associação excluída!',
        'Impossible to delete relation!' => 'Impossível excluir associação!',
        'Certificate %s could not be read!' => 'Certificado %s não pode ser lido!',
        'Needed Fingerprint' => 'Necessário Fingerprint',
        'Handle Private Certificate Relations' => 'Tratar Relações de Certificados Privados',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Saudação adicionada!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Assinatura atualizada!',
        'Signature added!' => 'Assinatura adicionada!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Estado adicionado!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Arquivo %s não pode ser lido!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Endereço de e-mail do sistema adicionado!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Configurações inválidas',
        'There are no invalid settings active at this time.' => 'Nenhuma definição inválida ativa no momento.',
        'You currently don\'t have any favourite settings.' => 'No momento você não tem nenhuma configuração favorita.',
        'The following settings could not be found: %s' => 'As seguintes definições não foram encontradas: %s',
        'Import not allowed!' => 'Importação não permitida!',
        'System Configuration could not be imported due to an unknown error, please check OTOBO logs for more information.' =>
            'Configuração do Sistema não pode ser importada devido a um erro desconhecido. Favor verificar logs OTOBO para mais informações.',
        'Category Search' => 'Buscar Categoria',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTOBO log for more information.' =>
            'Algumas definições importadas não estão presentes no estado atual da configuração ou não foi possivel atualizá-las. Favor verificar o log OTOBO para mais informações.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeploymentHistory.pm
        'This deployment does not contain changes in the setting values!' =>
            '',
        'No DeploymentID received!' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'Você precisa ativar esta definição antes de bloquear!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Você não consegue editar esta definição porque %s (%s) a está editando no momento.',
        'Missing setting name!' => 'Falta nome da definição!',
        'Missing ResetOptions!' => 'Opções de Redifinição Faltando!',
        'System was not able to lock the setting!' => 'O sistema não conseguiu bloquear a definição!',
        'System was unable to update setting!' => 'O sistema não conseguiu atualizar a definição!',
        'Missing setting name.' => 'Falta nome de definição.',
        'Setting not found.' => 'Configuração não encontrada.',
        'Missing Settings!' => 'Faltam Definições!',

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
        'Start date shouldn\'t be defined after Stop date!' => 'Data inicial não deve ser definida após data final!',
        'There was an error creating the System Maintenance' => 'Ocorreu um erro durante a criação da manutenção de sistema',
        'Need SystemMaintenanceID!' => 'Necessário SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Não foi possível obter dados para SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => 'Manutenção do Sistema foi criada com sucesso!',
        'System Maintenance was updated successfully!' => 'Manutenção do Sistema foi atualizada com sucesso!',
        'Session has been killed!' => 'Sessão foi eliminada!',
        'All sessions have been killed, except for your own.' => 'Todas sessões foram desconectadas, exceto por esta.',
        'There was an error updating the System Maintenance' => 'Ocorreu um erro durante a atualização da manutenção de sistema',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Não foi possível excluir a entrada de manutenção de sistema: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Modelo Atualizado!',
        'Template added!' => 'Modelo adicionado!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Alterar Relações Anexo para Modelo',
        'Change Template Relations for Attachment' => 'Alterar Relações Modelo para Anexo',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Tipo é necessário!',
        'Type added!' => 'Tipo adicionado!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Agent atualizado!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Alterar Relações de Grupo Para Atendente',
        'Change Agent Relations for Group' => 'Alterar Relações de Atendente Para Grupo',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Mês',
        'Week' => 'Semana',
        'Day' => 'Dia',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Todos os compromissos',
        'Appointments assigned to me' => 'Compromissos atribuídos a mim',
        'Showing only appointments assigned to you! Change settings' => 'Mostrar apenas compromissos assinados a você! Alterar configurações',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Compromisso não encontrado!',
        'Never' => 'Nunca',
        'Every Day' => 'Todo dia',
        'Every Week' => 'Todo semana',
        'Every Month' => 'Todo Mês',
        'Every Year' => 'Todo Ano',
        'Custom' => 'Customizado',
        'Daily' => 'Diário',
        'Weekly' => 'Semanal',
        'Monthly' => 'Mensal',
        'Yearly' => 'Anual',
        'every' => 'todos',
        'for %s time(s)' => 'de %s tempo(s)',
        'until ...' => 'até ...',
        'for ... time(s)' => 'de ... tempo(s)',
        'until %s' => 'até %s',
        'No notification' => 'Nenhuma notificação',
        '%s minute(s) before' => '%s minuto(s) antes',
        '%s hour(s) before' => '%s hora(s) antes',
        '%s day(s) before' => '%s dia(s) antes',
        '%s week before' => '%s semana antes',
        'before the appointment starts' => 'antes do compromisso iniciar',
        'after the appointment has been started' => 'depois que o compromisso foi iniciado',
        'before the appointment ends' => 'antes do compromisso encerrar',
        'after the appointment has been ended' => 'depois que o compromisso foi encerrado',
        'No permission!' => 'Sem permissão!',
        'Cannot delete ticket appointment!' => 'Não é possível excluir o compromisso do chamado.',
        'No permissions!' => 'Sem permissões!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s mais',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Histórico do Cliente',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'Nenhum Campo de Destinatário fornecido!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Nenhuma configuração para %s',
        'Statistic' => 'Estatística',
        'No preferences for %s!' => 'Nenhuma preferência para %s!',
        'Can\'t get element data of %s!' => 'Não foi possível obter dados do elemento %s!',
        'Can\'t get filter content data of %s!' => 'Não foi possível obter dados do conteúdo do filtro %s!',
        'Customer Name' => 'Nome do Cliente',
        'Customer User Name' => 'Nome do Usuário Cliente',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Necessário SourceObject e SourceKey!',
        'You need ro permission!' => 'Você precisa de permissões de ro (apenas leitura)',
        'Can not delete link with %s!' => 'Não é possível excluir associação com %s!',
        '%s Link(s) deleted successfully.' => '%s link(s) excluído(s) com sucesso.',
        'Can not create link with %s! Object already linked as %s.' => 'Não é possível criar associação com %s! Objeto já associado como %s.',
        'Can not create link with %s!' => 'Não é possível criar associação com %s!',
        '%s links added successfully.' => '%s link(s) adicionado(s) com sucesso.',
        'The object %s cannot link with other object!' => 'O Objeto %snão pode ser linkado com outro objeto!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Parametro Grupo é obrigatório. ',
        'This feature is not available.' => '',
        'Updated user preferences' => 'Preferências de usuário atualizadas',
        'System was unable to deploy your changes.' => 'Sistema não conseguiu implantar suas mudanças.',
        'Setting not found!' => 'Configuração não encontrada!',
        'System was unable to reset the setting!' => 'O sistema não conseguiu redefinir a definição!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Ticket de Processo',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Parametro %sestá vazio.',
        'Invalid Subaction.' => 'Subaction Inválida.',
        'Statistic could not be imported.' => 'Estatísticas não podem ser importadas.',
        'Please upload a valid statistic file.' => 'Por Favor, envie um arquivo de estatísticas válido.',
        'Export: Need StatID!' => 'Exportar: StatID é necessário',
        'Delete: Get no StatID!' => 'Deletar: Nenhum StatID obtido!',
        'Need StatID!' => 'StatID é necessário!',
        'Could not load stat.' => 'Não é possível carregar a estatística.',
        'Add New Statistic' => 'Adicionar Nova Estatística',
        'Could not create statistic.' => 'Não foi possível criar estatísticas.',
        'Run: Get no %s!' => 'Executar: %s não obtido.',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Nenhum TicketID informado.',
        'You need %s permissions!' => 'Você precisa %spermissões!',
        'Loading draft failed!' => 'Falha ao carregar rascunho!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Desculpe, você precisa ser o proprietário do chamado para executar esta ação.',
        'Please change the owner first.' => 'Por favor, altere o proprietário primeiro.',
        'FormDraft functionality disabled!' => 'Funcionalidade Rascunho de Formulário desabilitada!',
        'Draft name is required!' => 'Nome de rascunho é necessário!',
        'FormDraft name %s is already in use!' => 'Nome de Rascunho de Formulário %s já está em uso!',
        'Could not perform validation on field %s!' => 'Não é possível realizar validações no campo %s!',
        'No subject' => 'Sem assunto',
        'Could not delete draft!' => 'Não foi possível excluir rascunho!',
        'Previous Owner' => 'Proprietário Anterior',
        'wrote' => 'escreveu',
        'Message from' => 'Mensagem de',
        'End message' => 'Fim da mensagem',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s é necessário!',
        'Plain article not found for article %s!' => 'Artigo simples não encontrado para o artigo %s!',
        'Article does not belong to ticket %s!' => 'Artigo não pertence ao ticket %s!',
        'Can\'t bounce email!' => 'Impossível devolver o e-mail.',
        'Can\'t send email!' => 'Não é possível enviar o email!',
        'Wrong Subaction!' => 'Subação incorreta.',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Impossível bloquear o Chamado, nenhum TicketIDs foi informado!',
        'Ticket (%s) is not unlocked!' => 'Ticket (%s) não está desbloqueado!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => 'Você precisa selecionar ao menos um Ticket.',
        'Bulk feature is not enabled!' => 'Recurso \'em massa\' não está habilitado. ',
        'No selectable TicketID is given!' => 'Nenhum TicketID selecionável foi informado!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Você selecionou nenhum Ticket ou somente ticket os quais estão bloqueados por outro Agente.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Os Tickets a seguir serão ignorados porque eles estão bloquados por outro Agente ou você não tem permissão de escrita para estes Tickets: %s',
        'The following tickets were locked: %s.' => 'Os Tickets a seguir foram bloqueados: %s',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Endereço %s substituído pelo endereço cadastrado do cliente.',
        'Customer user automatically added in Cc.' => 'Cliente automaticamente adicionado no Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Chamado "%s" criado!',
        'No Subaction!' => 'Nenhuma Subaction!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Nenhum TicketID obtido.',
        'System Error!' => 'Erro de sistema!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'Nenhum ID de Artigo foi dado!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Próxima semana',
        'Ticket Escalation View' => 'Visão de Escalação de Chamados',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Artigo %s não foi encontrado!',
        'Forwarded message from' => 'Mensagem encaminhada de',
        'End forwarded message' => 'Fim da mensagem encaminhada',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Não foi possível exibir o histórico, nenhum TicketID informado!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Não foi possível bloquear o Ticket, nenhum TicketID informado!',
        'Sorry, the current owner is %s!' => 'Desculpe, o proprietário atual é %s!',
        'Please become the owner first.' => 'Por favor, torne-se o primeiro proprietário!',
        'Ticket (ID=%s) is locked by %s!' => 'Ticket(ID=%s) está bloqueado por %s!',
        'Change the owner!' => 'Alterar o proprietário!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Novo Artigo',
        'Pending' => 'Pendente',
        'Reminder Reached' => 'Lembrete Expirado',
        'My Locked Tickets' => 'Meus Chamados Bloqueados',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Não é possível mesclar um Ticket com ele mesmo.',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Você precisa da permissão: mover!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Chat não está ativo.',
        'No permission.' => 'Sem permissão.',
        '%s has left the chat.' => '%ssaiu do chat.',
        'This chat has been closed and will be removed in %s hours.' => 'Este chat foi fechado e será removido em %s horas.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Chamado bloqueado.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Nenhum ArticleID!',
        'This is not an email article.' => 'Este não é um artigo do tipo e-mail.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Não foi possível ler o artigo em texto simples.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID necessário!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Não foi possĩvel pegar ActivityDialogEntityID "%s"',
        'No Process configured!' => 'Nenhum Processo configurado!',
        'The selected process is invalid!' => 'O processo selecionado é inválido!',
        'Process %s is invalid!' => 'Processo %s é inválido!',
        'Subaction is invalid!' => 'Subaction é inválida!',
        'Parameter %s is missing in %s.' => 'Parâmetro %s está faltando em %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Nenhum ActivityDialog configurado para %s em _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Nenhum início de ActivityEntityID ou ActivityDialogEntityID para o Processo: %sem _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Não foi possível identificar o Ticket para TicketID %s em _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Não foi possível determinar ActivityEntityID. DynamicField ou a Configuração não está correta.',
        'Process::Default%s Config Value missing!' => 'Process::Default %s Faltando Valor de Configuração!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Nenhum ProcessEntityID ou TicketID e ActivityDialogEntityID identificados!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Não foi possível identificar  StartActivityDialog e StartActivityDialog para o  ProcessEntityID "%s"',
        'Can\'t get Ticket "%s"!' => 'Não foi possível obter Ticket "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Não foi possível obter ProcessEntityID ou ActivityEntityID para o ticket "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Não foi possível obter as configurações da Atividade para ActivityEntityID "%s!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Não foi possível obter configuração da Janela de Atividade para ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Não foi possĩvel obter o campo "%s" para ActivityDialog "%s"',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'PendingTime só pode ser usado se State ou StateID está configurado para a mesma ActivityDialog. ActivityDialog: %s !',
        'Pending Date' => 'Data de Pendência',
        'for pending* states' => 'em estado pendente*',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID faltando!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Não foi possível obter Config para ActivityDialogEntityID " %s"',
        'Couldn\'t use CustomerID as an invisible field.' => 'Não é possível usar CustomerID como um campo invisível.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'ProcessEntityID não encontrado, verifique seu ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Nenhum StartActivityDialog ou StartActivityDialog para o processo: "%s" configurado.',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Não é possĩvel criar Ticket para o Processo com o ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Não é possível definir ProcessEntityID "%s" on TicketID "%s"',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Não é possivel definir ActivityEntityID "%s" no TicketID "%s"',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Não foi possível gravar ActivityDialog, inválido TicketID: %s!',
        'Invalid TicketID: %s!' => 'inválido TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'ActivityEntityID não encontrado no Ticket %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Esse passo não pertence mais à atividade atual no processo para o Ticket \'%s%s%s\'! Outro usuário alterou este ticket enquanto isso. Por favor, feche esta janela e recarregue o Ticket',
        'Missing ProcessEntityID in Ticket %s!' => 'Não encontrado ProcessEntityId no Ticket %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível definir valor para o Campo Dinâmico %sdo Ticket com ID "%s" na Janela de Atividade "%s"',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível definir Tempo de Pendência para o Ticket com ID "%s" na Janela de Atividade "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Configuração incorreta para Janela de Dialogo: %snão foi possível exibir => 1 / Mostrar campo (Favor alterar esta configurar para Exibir => 0 / Não exibir o campo ou Exibir => 2 / Exibir campo como obrigatório.',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Não foi possível setar %spara o Ticket com ID "%s" na Janela de Atividade "%s" !',
        'Default Config for Process::Default%s missing!' => 'Configuração padrão para Process::Default%s não encontrada!',
        'Default Config for Process::Default%s invalid!' => 'Configuração padrão para Process::Default%sinválida!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Chamados Disponíveis',
        'including subqueues' => 'incluindo subfilas',
        'excluding subqueues' => 'excluindo subfilas',
        'QueueView' => 'Fila',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Chamados na Minha Responsabilidade',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'Última-Pesquisa',
        'Untitled' => 'Sem título',
        'Ticket Number' => 'Número do Chamado',
        'Ticket' => 'Chamado',
        'printed by' => 'Impresso por',
        'CustomerID (complex search)' => 'CustomerID (procura complexa)',
        'CustomerID (exact match)' => 'CustomerID (correspondência exata)',
        'Invalid Users' => 'Usuários Inválidos',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'em mais de ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Recurso não habilitado!',
        'Service View' => 'Visão de Serviços',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Visão de Estados',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Meus Chamados Monitorados',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Recurso não está ativo',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Associação deletada',
        'Ticket Locked' => 'Chamado bloqueado',
        'Pending Time Set' => 'Tempo de Pendência definido.',
        'Dynamic Field Updated' => 'Campo dinâmico atualizado',
        'Outgoing Email (internal)' => 'E-mail de Saĩda (interno)',
        'Ticket Created' => 'Chamado criado',
        'Type Updated' => 'Tipo atualizado',
        'Escalation Update Time In Effect' => 'Escalonamento por tempo de Atualização em efeito',
        'Escalation Update Time Stopped' => 'Escalonamento por tempo de Atualização parado.',
        'Escalation First Response Time Stopped' => 'Escalonamento por Tempo de Primeira Resposta parado.',
        'Customer Updated' => 'Cliente Atualizado',
        'Internal Chat' => 'Chat Interno',
        'Automatic Follow-Up Sent' => 'Acompanhamento automático enviado.',
        'Note Added' => 'Nota adicionada',
        'Note Added (Customer)' => 'Nota adicionada (Cliente)',
        'SMS Added' => 'SMS Adicionado',
        'SMS Added (Customer)' => 'SMS Adicionado (Cliente)',
        'State Updated' => 'Estado Atualizado',
        'Outgoing Answer' => 'Resposta de saída',
        'Service Updated' => 'Serviço Atualizado',
        'Link Added' => 'Link Adicionado',
        'Incoming Customer Email' => 'E-mail de entrada do cliente',
        'Incoming Web Request' => 'Requisição Web recebida.',
        'Priority Updated' => 'Prioridade atualizada',
        'Ticket Unlocked' => 'Chamado desbloqueado',
        'Outgoing Email' => 'E-mail de saída',
        'Title Updated' => 'Título atualizado',
        'Ticket Merged' => 'Ticket mesclado.',
        'Outgoing Phone Call' => 'Chamada telefônica recebida',
        'Forwarded Message' => 'Mensagem encaminhada.',
        'Removed User Subscription' => 'Subscrição de usuário removida.',
        'Time Accounted' => 'Tempo contabilizado',
        'Incoming Phone Call' => 'Chamada telefônica recebida.',
        'System Request.' => 'Requisição do Sistema.',
        'Incoming Follow-Up' => 'Acompanhamento recebido.',
        'Automatic Reply Sent' => 'Resposta automática enviada.',
        'Automatic Reject Sent' => 'Rejeição automática enviada.',
        'Escalation Solution Time In Effect' => 'Escalonamento por Tempo de Solução aplicado.',
        'Escalation Solution Time Stopped' => 'Escalonamento por tempo de Solução parado.',
        'Escalation Response Time In Effect' => 'Escalonamento por tempo de resposta em vigor.',
        'Escalation Response Time Stopped' => 'Escalonamento por tempo de Resposta parado.',
        'SLA Updated' => 'SLA Atualizado',
        'External Chat' => 'Chat Externo',
        'Queue Changed' => 'Fila alterada.',
        'Notification Was Sent' => 'Notificação enviada.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Esse ticket não existe ou você não tem permissões para acessá-lo no seu estado atual.',
        'Missing FormDraftID!' => 'Falta ID de Rascunho do Formulário!',
        'Can\'t get for ArticleID %s!' => 'Não foi possível obter o ID da Nota %s!',
        'Article filter settings were saved.' => 'Configuraçãoes de filtro de notas, salvo.',
        'Event type filter settings were saved.' => 'Configurações de filtro por Tipo de Evento, salvo.',
        'Need ArticleID!' => 'O ID do Artigo é necessário.',
        'Invalid ArticleID!' => 'ID do Artigo é inválido.',
        'Forward article via mail' => 'Encaminhar artigo por e-mail',
        'Forward' => 'Encaminhar',
        'Fields with no group' => 'Campo sem grupo.',
        'Invisible only' => 'Somente não visível',
        'Visible only' => 'Somente visível',
        'Visible and invisible' => 'Visível e não visível',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'O artigo não pôde ser aberto! Talvez ele esteja em outra página de artigo?',
        'Show one article' => 'Exibir um Artigo',
        'Show all articles' => 'Exibir Todos os Artigos',
        'Show Ticket Timeline View' => 'Mostrar a Cronologia do Chamado',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'Não contém ID de Formulário.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Erro: o arquivo não pôde ser excluído corretamente. Por favor entrar em contato com seu administrador (Falta ID de Campo)',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'O Id do Artigo é necessário!',
        'No TicketID for ArticleID (%s)!' => 'Nenhum ID do Ticket para o ID da Nota (%s)!',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'ID fo campo e ID da Nota são necessários.',
        'No such attachment (%s)!' => 'Nenhum anexo (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Valide configuração no SysConfig para %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Valide configuração no SysConfig para %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'ID do Cliente é necessário.',
        'My Tickets' => 'Meus Chamados',
        'Company Tickets' => 'Chamados da Empresa',
        'Untitled!' => 'Sem Título.',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Nome real do cliente',
        'Created within the last' => 'Criado no(s) último(s)',
        'Created more than ... ago' => 'Criado há mais de ... atrás',
        'Please remove the following words because they cannot be used for the search:' =>
            'Por Favor, remova a palavras a seguir, visto que elas não podem ser usadas para pesquisa:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Não foi possível reabrir o Ticket nesta fila.',
        'Create a new ticket!' => 'Criar novo Ticket!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Modo Seguro ativdado!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Se você deseja executar novamente o Instalador, desabilite o Modo Seguro no SysConfig.',
        'Directory "%s" doesn\'t exist!' => 'Diretório "%s" não existe!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Configure "Home" em Kernel/Config.pm primeiro!',
        'File "%s/Kernel/Config.pm" not found!' => 'Arquivo "%s /Kernel/Config.pm não encontrado!',
        'Directory "%s" not found!' => 'Diretõrio "%s" não encontrado.',
        'Install OTOBO' => 'Instalar o OTOBO',
        'Intro' => 'Introdução',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm não está gravável.',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Se você deseje usar o Instalador, defina Kernel/Config.pm como gravável para o usuário do servidor Web.',
        'Database Selection' => 'Seleção de banco de dados',
        'Unknown Check!' => 'Verificação desconhecida.',
        'The check "%s" doesn\'t exist!' => 'A verificação "%s" não existe.',
        'Enter the password for the database user.' => 'Digite uma senha para o usuário do banco de dados.',
        'Database %s' => 'Banco de Dados %s',
        'Configure MySQL' => 'Configurar MySQL',
        'Enter the password for the administrative database user.' => 'Digite uma senha para o usuário administrador do banco de dados.',
        'Configure PostgreSQL' => 'Configurar PostgreSQL',
        'Configure Oracle' => 'Configurar Oracle',
        'Unknown database type "%s".' => 'Tipo da Banco de Dados "%s" desconhecido.',
        'Please go back.' => 'Favor retornar.',
        'Create Database' => 'Criar banco de dados',
        'Install OTOBO - Error' => 'Erro ao Installar OTOBO',
        'File "%s/%s.xml" not found!' => 'Arquivo "%s/%s.xml" não encontrado.',
        'Contact your Admin!' => 'Entre em contato com o seu Administrador.',
        'System Settings' => 'Configurações de Sistema',
        'Syslog' => 'Syslog',
        'Configure Mail' => 'Configurar E-mail',
        'Mail Configuration' => 'Configuração de E-mail',
        'Can\'t write Config file!' => 'Não foi possível gravar no arquivo de Configurações.',
        'Unknown Subaction %s!' => 'Ação secundária %s desconhecida!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Não foi possível conectar ao Banco de Dados, Múdlo Perl DBD::%s não instalado!',
        'Can\'t connect to database, read comment!' => 'Não foi possível connectar ao banco de dados, leia os comentários!',
        'Database already contains data - it should be empty!' => 'Banco de dados já contém dados - ele deve estar vazio!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Error: Certifique-se que seu banco da dados aceita pacotes com tamanho acima de %s MB (atualmente ele aceita somente até %sMB). Por Favor, ajuste o parametro max_allowed_packet do seu banco de dados, a fim de previnir erros.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Error: Defina o valor para innodb_log_file_size no seu banco de dados para, ao menos %s MB (atualmente %sMB, recomendado: %sMB). Para mais informações verifique em %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/MigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.' =>
            '',
        'OTRS to OTOBO migration' => '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Nenhum %s!',
        'No such user!' => 'Usuário não encontrado',
        'Invalid calendar!' => 'Calendário invalido!',
        'Invalid URL!' => 'URL inválida!',
        'There was an error exporting the calendar!' => 'Houve um erro ao exportar o calendário!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Configuração Package::RepositoryAccessRegExp necessária.',
        'Authentication failed from %s!' => 'Falha de autenticação à partir de %s!',

        # Perl Module: Kernel/Output/HTML/Article/Chat.pm
        'Chat' => 'Chat',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Devolver artigo para um endereço de e-mail diferente',
        'Bounce' => 'Devolver',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Responder a Todos',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Reenviar este artigo',
        'Resend' => 'Reenviar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Visualizar detalhes do log de mensagens para este artigo',
        'Message Log' => 'Log de Mensagens',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Responder a nota',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Dividir este artigo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Ver código fonte da Nota.',
        'Plain Format' => 'Formato texto',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Imprimir este artigo',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'Contacte-nos em sales@otrs.com',
        'Get Help' => 'Solicitar Ajuda',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Marcar',
        'Unmark' => 'Desmarcar',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Re-install Package' => 'Reinstalar Pacote',
        'Re-install' => 'Reinstalar',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Criptografado',
        'Sent message encrypted to recipient!' => 'Enviou mensagem criptografada ao destinatário!',
        'Signed' => 'Assinado',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => 'Cabeçalho "PGP SIGNED MESSAGE" encontrado porém, inválido!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => 'Cabeçalho "S/MIME SIGNED MESSAGE" encontrado porém, inválido',
        'Ticket decrypted before' => 'Descriptografar Ticket antes.',
        'Impossible to decrypt: private key for email was not found!' => 'Impossível descriptografar: Chave privrada para o e-mail não foi encontrada!',
        'Successful decryption' => 'Descritografado com sucesso.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Nenhuma chave de criptografia disponível para os endereços: \'%s\'. ',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Nenhuma chave de criptografia selecionada para os endereços: \'%s\'. ',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Não pode utilizar chaves de criptografia expiradas para os endereços: \'%s\'. ',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Não pode utilizar chaves de criptografia revogadas para os endereços: \'%s\'. ',
        'Encrypt' => 'Criptografar',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Chaves/certificados só serão exibidos para destinatários com mais de uma chave/certificado. A primeira chave/certificado encontrada será pré-selecionada. Favor garantir que a correta seja selecionada.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Segurança de e-mail',
        'PGP sign' => 'Assinatura PGP',
        'PGP sign and encrypt' => 'Assinatura e criptografia PGP',
        'PGP encrypt' => 'Criptografia PGP',
        'SMIME sign' => 'Assinatura SMIME',
        'SMIME sign and encrypt' => 'Assinatura e criptografia SMIME',
        'SMIME encrypt' => 'Criptografia SMIME',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Não é possível utilizar a chave de assinatura expirada: \'%s\'. ',
        'Cannot use revoked signing key: \'%s\'. ' => 'Não é possível utilizar a chave de assinatura revogada: \'%s\'. ',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Nenhuma chave de assinatura disponível para os endereços \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Nenhuma chave de assinatura selecionada para os endereços \'%s\'.',
        'Sign' => 'Assinar',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Chaves/certificados só serão exibidas para um remetente com mais de uma chave/certificado. A primeira chave/certificado encontrada será pré-selecionada. Favor garantir que a correta seja selecionada.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Exibido',
        'Refresh (minutes)' => 'Atualização (minutos)',
        'off' => 'desligado',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'IDs de clientes mostrados',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Usuários clientes exibidos',
        'Offline' => 'Desconectado.',
        'User is currently offline.' => 'No momento o usuário está desconectado.',
        'User is currently active.' => 'Atualmente o usuário está conectado.',
        'Away' => 'Ausente.',
        'User was inactive for a while.' => 'Usuário está temporariamente inativo.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'O tempo inicial do Ticket foi definido antes do tempo final.',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTOBO News server!' => 'Não foi possível conectar ao servidor de Notícias do OTOBO.',
        'Can\'t get OTOBO News from server!' => 'Não foi possível obter Notícias do servidor OTOBO.',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Não foi possĩvel conectar ao servidor de Novidades do Produto OTRS',
        'Can\'t get Product News from server!' => 'Não foi possível obter Novidades dos Produtos do servidor OTRS.',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Não foi possível coectar em %s',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Chamados Exibidos',
        'Shown Columns' => 'Colunas Exibidas',
        'filter not active' => 'Filtro não ativo.',
        'filter active' => 'Filtro ativo.',
        'This ticket has no title or subject' => 'O Ticket não tem título ou assunto.',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Estatísticas (7 Dias)',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Usuário definei seus status como indisponível.',
        'Unavailable' => 'Indisponível.',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Padrão',
        'The following tickets are not updated: %s.' => 'Os tickets a seguir não foram atualizados: %s.',
        'h' => 'h',
        'm' => 'm',
        'd' => 'd',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'O ticket não existe ou você não tem permissões para acessá-lo no seu estado atual. Você pode tomar uma das seguintes ações:',
        'This is a' => 'Este é um',
        'email' => 'e-mail',
        'click here' => 'clique aqui',
        'to open it in a new window.' => 'para abri-lo em uma nova janela.',
        'Year' => 'Ano',
        'Hours' => 'Horas',
        'Minutes' => 'Minutos',
        'Check to activate this date' => 'Marque para ativar esta data',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Sem permissão!',
        'No Permission' => 'Sem Permissão.',
        'Show Tree Selection' => 'Mostrar Seleção de Árvore',
        'Split Quote' => 'Marca de citação',
        'Remove Quote' => 'Remover citação',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Associado como',
        'Search Result' => 'Resultados da pesquisa',
        'Linked' => 'Associado',
        'Bulk' => 'Massa',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Simples',
        'Unread article(s) available' => 'Artigo(s) Não Lido(s) Disponível(is)',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Compromisso',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Pesquisar arquivamento.',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Atendentes Online: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Há mais chamados escalados!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Selecione o fuso horário de sua preferência e confirme ao clicar no botão salvar.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Clientes Online: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Manutenção de sistema está ativa!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Uma manutenção do sistema irá iniciar às: %s e deverá terminar às: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTOBO Daemon is not running.' => 'OTOBO Daemon não esta executando',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Você habilitou "Fora do Escritório", gostaria de desabilitar?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Você tem %s configuração(ões) inválidas implantadas. Clique aqui para mostrar estas configurações inválidas.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Você tem definições que não foram implantadas. Gostaria de implantá-las?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'A configuração está sendo atualizada. Por favor, tenha paciência...',
        'There is an error updating the system configuration!' => 'Houve um erro ao atualizar a configuração do sistema!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Não use a conta Superusuário para trabalhar com o %s! Crie novos Agentes e trabalhe com essas contas.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Favor, certifique-se de ter escolhido ao menos um meio de transporte para notificações obrigatórias.',
        'Preferences updated successfully!' => 'Preferências atualizadas com sucesso!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(em progresso)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Por favor especifique uma data final posterior à data de início.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Verify password' => 'Verificar senha',
        'The current password is not correct. Please try again!' => 'A senha atual não está correta. Por favor, tente novamente!',
        'Please supply your new password!' => 'Favor, forneça sua senha!',
        'Can\'t update password, the new password and the repeated password do not match.' =>
            '',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Esta senha não é permitida pela configuração do sistema atual. Por favor, contacte o administrador se você tiver perguntas adicionais.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Não é possível atualizar a senha. Ela deve conter pelo menos %s caracteres!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Não é possível atualizar a senha. Ela deve conter, no mínimo, 2 letras caixa baixa e 2 letras caixa alta! ',
        'Can\'t update password, it must contain at least 1 digit!' => 'Não é possível atualizar a senha. Ela deve conter pelo menos 1 número!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Não é possível atualizar a senha. Ela deve conter, no mínimo, 2 letras.',
        'Can\'t update password, it must contain at least 3 of 4 (lower char, upper char, digit, special character)!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Fuso horário atualizado com sucesso!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'inválido',
        'valid' => 'válido',
        'No (not supported)' => 'Não (não suportado)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Nenhum valor selecionado para tempo completado no passado ou completado no momento+no futuro.',
        'The selected time period is larger than the allowed time period.' =>
            'O período de tempo selecionado é maior que o período de tempo permitido.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Nenhum valor para escala de tempo disponĩvel para a escala de tempo selecionado no eixo X.',
        'The selected date is not valid.' => 'A data selecionado não é válida.',
        'The selected end time is before the start time.' => 'O Tempo final é anterior ao tempo inicial.',
        'There is something wrong with your time selection.' => 'Algo errado com a sua seleção de tempo.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Favor, selecione apenas um elemento ou permita modificações em "stat Generation Time".',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Favor, selecionar ao menos um valor par ao campo, ou permitir modificações em "stat generation time"',
        'Please select one element for the X-axis.' => 'Favor selecionar um elemento para o Eixo-X',
        'You can only use one time element for the Y axis.' => 'Vocẽ só pode usar um elemento para o Exito Y.',
        'You can only use one or two elements for the Y axis.' => 'Você pode usar um ou dois elementos para o Eixo-Y',
        'Please select at least one value of this field.' => 'Favor selecionar ao menos um valor para o campo.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Favor preenchar um valor ou permita modificações em "Stat Generations time"',
        'Please select a time scale.' => 'Por favor, selecione um período de tempo.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'O  período  de tempo do seu Relatõrio  é muito pequeno, favor use um período de tempo maior,',
        'second(s)' => 'segundo(s)',
        'quarter(s)' => 'trimestre(s)',
        'half-year(s)' => 'semestre(s)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Favor remover as seguintes palavras, um vez que elas não podem ser usadas para restrições de Ticket %s',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Cancelar edição e desbloquear esta definição',
        'Reset this setting to its default value.' => 'Redefinir esta definição ao seu valor padrão.',
        'Unable to load %s!' => 'Incapaz de carregar %s!',
        'Content' => 'Conteúdo',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Desbloquear para devolver à fila',
        'Lock it to work on it' => 'Bloquear para trabalhar no chamado',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Não monitorar',
        'Remove from list of watched tickets' => 'Remover da lista de chamados monitorados',
        'Watch' => 'Monitorar',
        'Add to list of watched tickets' => 'Adicionar à Lista de Chamados Monitorados',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Ordenar por',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Novos Chamados Bloqueados',
        'Locked Tickets Reminder Reached' => 'Lembrete de Chamados Bloqueados Atingido',
        'Locked Tickets Total' => 'Total de Chamados Bloqueados',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Novos Chamados com Responsável',
        'Responsible Tickets Reminder Reached' => 'Lembrete de Chamados com Responsável Atingido',
        'Responsible Tickets Total' => 'Total de chamados com Responsável',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Novos Chamados Monitorados',
        'Watched Tickets Reminder Reached' => 'Lembrete de Chamados Monitorados Atingido',
        'Watched Tickets Total' => 'Total de Chamados Monitorados',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Campos Dinâmicos de Chamado',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Não foi possível ler o arquivo de configuração ACL. Por favor, certifique-se de que o arquivo é válido.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'De momento não é possível fazer login devido a manutenção no sistema.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Sessão inválida. Por favor, entre novamente.',
        'Session has timed out. Please log in again.' => 'A sessão expirou. Por favor, entre novamente.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Assinatura PGP apenas',
        'PGP encrypt only' => 'Criptografia PGP apenas',
        'SMIME sign only' => 'Assinatura SMIME apenas',
        'SMIME encrypt only' => 'Criptografia SMIME apenas',
        'PGP and SMIME not enabled.' => 'PGP e SMIME não habilitados.',
        'Skip notification delivery' => 'Pular entrega de notificação',
        'Send unsigned notification' => 'Enviar notificação não-assinada',
        'Send unencrypted notification' => 'Enviar notificação não-encriptada',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Referência de Opções de Configuração',
        'This setting can not be changed.' => 'Esta configuração não pode ser alterada.',
        'This setting is not active by default.' => 'Esta configuração não está ativa por padrão.',
        'This setting can not be deactivated.' => 'Esta configuração não pode ser desativada.',
        'This setting is not visible.' => 'Esta configuração não está visível.',
        'This setting can be overridden in the user preferences.' => 'Esta definição pode ser sobrescrita nas preferências de usuário.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Esta definição pode ser sobrescrita nas preferências de usuário, mas não está ativa por padrão.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Usuário cliente "%s" já existe.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Este endereço de e-mail já está em uso por outro usuário cliente.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'antes/após',
        'between' => 'entre',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'ex.: Text ou Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Ignore este campo.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Este campo é requerido ou',
        'The field content is too long!' => 'O conteúdo deste campo é muito longo!',
        'Maximum size is %s characters.' => 'O tamanho máximo é %s caracteres.',

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
        'Check if OTOBO version is correct.' => '',
        'Check if OTOBO and OTRS connect is possible.' => '',
        'Can\'t open RELEASE file from OTRSHome: %s!' => '',
        'Copy and migrate files from OTRS' => '',
        'All needed files copied and migrated, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBODatabaseMigrate.pm
        'Need %s for Oracle db!' => '',
        'Copy database.' => '',
        'System was unable to connect to OTRS database.' => '',
        'System was unable to complete data transfer.' => '',
        'Data transfer completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOFrameworkVersionCheck.pm
        'Check if OTOBO and OTRS version is correct.' => '',
        '%s does not exist!' => '',
        'Can\'t read OTOBO RELEASE file: %s: %s!' => '',
        'No OTOBO system found!' => '',
        'You are trying to run this script on the wrong framework version %s!' =>
            '',
        'OTOBO Version is correct: %s.' => '',
        'Check if OTRS version is correct.' => '',
        'Can\'t read OTRS RELEASE file: %s: %s!' => '',
        'No OTRS system found!' => '',
        'OTRS Version is correct: %s.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOInvalidSettingsCheck.pm
        'Check for invalid configuration settings.' => '',
        'Invalid setting detected.' => '',
        'No invalid setting detected, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateConfigFromOTRS.pm
        'Migrate configuration settings.' => '',
        'An error occured during SysConfig data migration or no configuration exists.' =>
            '',
        'An error occured during SysConfig data migration.' => '',
        'SysConfig data migration completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOMigrateWebServiceConfiguration.pm
        'Migrate web service configuration.' => '',
        'No web service existent, done.' => '',
        'Can\'t add web service for Elasticsearch. File %s not found!.' =>
            '',
        'Migration completed. Please activate the web service in Admin -> Web Service when ElasticSearch installation is completed.' =>
            '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBONotificationMigrate.pm
        'Migrate database table notification.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSConnectionCheck.pm
        'Can\'t open Kernel/Config.pm file from OTRSHome: %s!' => '',
        'OTOBO Home exists.' => '',
        'Check if we are able to connect to OTRS Home.' => '',
        'Can\'t connect to OTRS file directory.' => '',
        'Connect to OTRS file directory is possible.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSDBCheck.pm
        'Try database connect and sanity checks.' => '',
        'Connect to OTRS database or sanity checks failed.' => '',
        'Database connect and sanity checks completed.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageCheck.pm
        'Check if all necessary packages are installed.' => '',
        'The following packages are only installed in OTRS:' => '',
        'Please install (or uninstall) the packages before migration. If a package doesn\'t exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution.' =>
            '',
        'The same packages are installed on both systems, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOOTRSPackageMigration.pm
        'Check if %s!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOPerlModulesCheck.pm
        'Check if all needed Perl modules have been installed.' => '',
        '%s script does not exist.' => '',
        'One or more required Perl modules are missing. Please install them as recommended, and run the migration script again.' =>
            '',
        'All required Perl modules have been installed, perfect!' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOProcessDeploy.pm
        'Deploy the process management configuration.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBORebuildConfig.pm
        'OTOBO config rebuild.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBORebuildConfigCleanup.pm
        'OTOBO Config cleanup.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOResponseTemplatesMigrate.pm
        'Migrate database table response_template.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSalutationsMigrate.pm
        'Migrate database table salutation.' => '',

        # Perl Module: Kernel/System/MigrateFromOTRS/OTOBOSignaturesMigrate.pm
        'Migrate database table signature.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Não foi possível ler o arquivo de configuração de Notificação. Por favor, certifique-se que o arquivo é válido.',
        'Imported notification has body text with more than 4000 characters.' =>
            'A notificação importada tem texto de corpo com mais de 4000 caracteres.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'não instalado',
        'installed' => 'instalado',
        'Unable to parse repository index document.' => 'Impossível analisar documento de índice do repositório.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nenhum pacote para a versão do seu framework foi encontrado neste repositório, ele contém apenas pacotes para outras versões de framework.',
        'File is not installed!' => 'Arquivo não instalado!',
        'File is different!' => 'Arquivo é diferente!',
        'Can\'t read file!' => 'Não pode ler o arquivo!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTOBO service contracts.</p>' =>
            '<p>Se você continuar a instalar este pacote, as seguintes questões podem ocorrer: </p><ul><li>Problemas de segurança</li><li>Problemas de estabilidade</li><li>Problemas de performance</li></ul><p>Observe que questões que são causadas por utilizar este pacote não são cobertas por contratos de serviço OTOBO. </p>',
        '<p>The installation of packages which are not verified by the OTOBO Team is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'O processo "%s" e todos os seus dados foram importados com sucesso.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inativo',
        'FadeAway' => 'FadeAway',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Não é possível contatar o servidor de registro. Por favor, tente novamente mais tarde.',
        'No content received from registration server. Please try again later.' =>
            'Nenhum conteúdo recebido do servidor de registro. Por favor, tente novamente mais tarde.',
        'Can\'t get Token from sever' => 'Não foi possível obter o Token do servidor',
        'Username and password do not match. Please try again.' => 'Usuário e senha não coincidem. Por favor, tente novamente mais tarde.',
        'Problems processing server result. Please try again later.' => 'Problemas ao processar o resultado do servidor. Por favor, tente novamente mais tarde.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Soma',
        'week' => 'semana',
        'quarter' => 'trimestre',
        'half-year' => 'semestre',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tipo de Estado',
        'Created Priority' => 'Prioridade',
        'Created State' => 'Criado com o Estado',
        'Create Time' => 'Hora de Criação',
        'Pending until time' => 'Pendente até o horário',
        'Close Time' => 'Hora de Fechamento',
        'Escalation' => 'Escalação',
        'Escalation - First Response Time' => 'Escalação - Prazo de Resposta Inicial',
        'Escalation - Update Time' => 'Escalação - Prazo de Atualização',
        'Escalation - Solution Time' => 'Escalação - Prazo de Solução',
        'Agent/Owner' => 'Atendente/Proprietário',
        'Created by Agent/Owner' => 'Criado pelo Atendente/Proprietário',
        'Assigned to Customer User Login' => 'Atribuido ao Login de Usuário Cliente',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Avaliado por',
        'Ticket/Article Accounted Time' => 'Tempo contabilizado por Chamado/Artigo',
        'Ticket Create Time' => 'Horário de Criação do Chamado',
        'Ticket Close Time' => 'Horário de Fechamento do Chamado',
        'Accounted time by Agent' => 'Tempo contabilizado por Atendente',
        'Total Time' => 'Tempo Total',
        'Ticket Average' => 'Média de Chamados',
        'Ticket Min Time' => 'Horário Mínimo dos Chamados',
        'Ticket Max Time' => 'Horário Máximo dos Chamados',
        'Number of Tickets' => 'Número de Chamados',
        'Article Average' => 'Média de Artigos',
        'Article Min Time' => 'Horário Mínimo dos Artigos',
        'Article Max Time' => 'Horário Máximo dos Artigos',
        'Number of Articles' => 'Número de Artigos',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'ilimitado',
        'Attributes to be printed' => 'Atributos a serem impressos',
        'Sort sequence' => 'Sequência de Ordenamento',
        'State Historic' => 'Histórico de Estado',
        'State Type Historic' => 'Histórico de Tipo de Estado',
        'Historic Time Range' => 'Intervalo de Tempo Histórico',
        'Number' => 'Número',
        'Last Changed' => 'Última Alteração',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Média de Solução',
        'Solution Min Time' => 'Tempo Mínimo de Solução',
        'Solution Max Time' => 'Tempo Máximo de Solução',
        'Solution Average (affected by escalation configuration)' => 'Média de Solução (impactado pela configuração de escalonamento)',
        'Solution Min Time (affected by escalation configuration)' => 'Tempo Mínimo de Solução (impactado pela configuração de escalonamento)',
        'Solution Max Time (affected by escalation configuration)' => 'Tempo Máximo de Solução (impactado pela configuração de escalonamento)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Média de Tempo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Tempo Mínimo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Tempo Máximo de Funcionamento de Solução (impactada pela configuração de escalonamento)',
        'First Response Average (affected by escalation configuration)' =>
            'Média de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Tempo Mínimo de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Tempo Máximo de Primeira Resposta (impactado pela configuração de escalonamento)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => 'Número de Tickets (impactado pela configuração de escalonamento)',

        # Perl Module: Kernel/System/Stats/Static/OpenTicketCountPerDayPeriod.pm
        'Days' => 'Dias',
        'Queues / Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Tabelas Desatualizadas',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'Tabelas desatualizadas foram encontradas na base de dados. Estas podem ser removidas, se vazias.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabelas presente',
        'Internal Error: Could not open file.' => 'Erro interno: Não foi possível abrir o arquivo.',
        'Table Check' => 'Verificação das tabelas',
        'Internal Error: Could not read file.' => 'Erro Interno: Não foi possível ler o arquivo.',
        'Tables found which are not present in the database.' => 'Foram encontradas tabelas não presentes na base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Tamanho da Base de Dados',
        'Could not determine database size.' => 'Não foi possível determinar o tamanho da base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Versão da base de dados',
        'Could not determine database version.' => 'Não foi possível determinar a versão da base de dados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Charset do Cliente de Conexão',
        'Setting character_set_client needs to be utf8.' => 'Parâmetro character_set_client deve ser utf8.',
        'Server Database Charset' => 'Charset do Banco de dados',
        'The setting character_set_database needs to be \'utf8\'.' => 'A definição character_set_database precisa ser \'utf8\'.',
        'Table Charset' => 'Chartset da Tabela',
        'There were tables found which do not have \'utf8\' as charset.' =>
            'Algumas tabelas foram encontradas que não têm \'utf8\' como charset.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Tamanho de arquivo de log InooDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'O parâmetro innodb_log_file_size deve ser ao menos 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Valores Padrão Inválidos',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otobo.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Tamanho Máximo da Query',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'A definição \'max_allowed_packet\' deve ser maior que 64 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Tamanho do Cache de Consulta',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'A configuração \'query_cache_size\' deve ser usada (maior que 10 MB mas não mais que 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Mecanismo de Armazenamento Padrão',
        'Table Storage Engine' => 'Engine de Armazenamento de Tabela',
        'Tables with a different storage engine than the default engine were found.' =>
            'Tabelas com um mecanismo de armazenamento diferente do mecanismo padrão foram encontrados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x ou superior é requerido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'Parâmetro NLS_LANG',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG deve estar definido como al32utf8 (exemplo: GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'Parâmetro NLS_DATE_FORMAT ',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT deve ser definido para \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT Configurando SQL Check',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Sequências de Chave Primária e Disparadores',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'As seguintes sequências e/ou disparadores com nomes possivelmente incorretos foram encontradas. Por favor, renomear manualmente.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'A configuração client_encoding precisa ser UNICODE ou UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'A configuração server_encoding precisa ser UNICODE ou UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Formato da data',
        'Setting DateStyle needs to be ISO.' => 'A configuração DateStyle precisa ser ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Sequências de Chave Primária',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 ou superior é necessário.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTOBO.pm
        'OTOBO Disk Partition' => 'Partição OTOBO',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Utilização em disco',
        'The partition where OTOBO is located is almost full.' => 'A partição onde o OTOBO se encontra localizado encontra-se quase cheia.',
        'The partition where OTOBO is located has no disk space problems.' =>
            'A partição onde o OTOBO está localizado não apresenta problemas de espaço.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Partições em uso',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribuição',
        'Could not determine distribution.' => 'Não foi possível determinar a distribuição.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Versão do Kernel',
        'Could not determine kernel version.' => 'Não foi possível determinar a versão do kernel.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Carga do sistema',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'A carga do sistema deve estar, no máximo, até o número de CPUs que o sistema tiver (ex.: uma carga de 8 ou menos em um sistema com 8 CPUs é adequada).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Módulos Perl',
        'Not all required Perl modules are correctly installed.' => 'Nem todos os módulos Perl não foram correctamente instalados.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Espaço de Swap livre (%)',
        'No swap enabled.' => 'Nenhum swap ativado.',
        'Used Swap Space (MB)' => 'Utilizar espaço Swap (MB)',
        'There should be more than 60% free swap space.' => 'Deve haver mais de 60% de espaço Swap livre.',
        'There should be no more than 200 MB swap space used.' => 'Não mais de 200 MB de espaço Swap deverá estar em utilização.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticleSearchIndexStatus.pm
        'OTOBO' => 'OTOBO',
        'Article Search Index Status' => 'Status de Índice de Pesquisa de Artigo',
        'Indexed Articles' => 'Artigos Indexados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Artigos Por Canal de Comunicação',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLog.pm
        'Incoming communications' => 'Comunicações recebidas',
        'Outgoing communications' => 'Comunicações enviadas',
        'Failed communications' => 'Comunicações com falhas',
        'Average processing time of communications (s)' => 'Tempo médio de processamento de comunicação(ões)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Status de Conta no Log de Comunicação (últimas 24 horas)',
        'No connections found.' => 'Nenhuma conexão encontrada.',
        'ok' => 'ok',
        'permanent connection errors' => 'erros de conexão permanentes',
        'intermittent connection errors' => 'erros de conexão intermitentes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/ConfigSettings.pm
        'Config Settings' => 'Definições de configuração',
        'Could not determine value.' => 'Não foi possível determinar o valor.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DaemonRunning.pm
        'Daemon' => 'Daemon',
        'Daemon is running.' => 'Daemon está ativo.',
        'Daemon is not running.' => 'Daemon não está ativo.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DatabaseRecords.pm
        'Database Records' => 'Registros de Banco',
        'Ticket History Entries' => 'Entradas de Histórico de Chamados',
        'Articles' => 'Artigos',
        'Attachments (DB, Without HTML)' => 'Anexos (DB, sem HTML)',
        'Customers With At Least One Ticket' => 'Clientes com pelo menos um Chamado',
        'Dynamic Field Values' => 'Valores de Campos Dinâmicos',
        'Invalid Dynamic Fields' => 'Campos dinâmicos inválidos',
        'Invalid Dynamic Field Values' => 'Valor do Campo Dinâmico inválido',
        'GenericInterface Webservices' => 'GenericInterface serviços Web',
        'Process Tickets' => 'Tickets de Processo',
        'Months Between First And Last Ticket' => 'Meses Entre o Primeiro e o Último Chamado',
        'Tickets Per Month (avg)' => 'Chamados por Mês (méd.)',
        'Open Tickets' => 'Chamados Abertos',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Usuário e Senha SOAP padrão',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Risco de segurança: você usou uma configuração padrão para SOAP::User e SOAP::Password. Por favor altere-a.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/DefaultUser.pm
        'Default Admin Password' => 'Senha padrão de Administrador',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Risco de segurança: a conta de atendente root@localhost possui a senha padrão. Por favor altere a senha ou desabilite a conta.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/EmailQueue.pm
        'Email Sending Queue' => 'Fila para Envio de E-mail',
        'Emails queued for sending' => 'E-mails enfileirados para envio',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FQDN.pm
        'FQDN (domain name)' => 'FQDN (nome do domínio)',
        'Please configure your FQDN setting.' => 'Por favor configure o seu FQDN.',
        'Domain Name' => 'Nome de Domínio',
        'Your FQDN setting is invalid.' => 'Suas configurações de FQDN estão inválidas.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/FileSystemWritable.pm
        'File System Writable' => 'Sistema de Arquivo gravável ',
        'The file system on your OTOBO partition is not writable.' => 'O Sistema de Arquivo da partição do OTOBO não está gravável ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Backups de Legado de Configuração',
        'No legacy configuration backup files found.' => 'Nenhum arquivo de backup de legado de configuração foi encontrado.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageDeployment.pm
        'Package Installation Status' => 'Estado da Instalação do Pacote',
        'Some packages have locally modified files.' => 'Alguns pacotes possuem arquivos modificados localmente.',
        'Some packages are not correctly installed.' => 'Alguns pacotes não foram instalados corretamente.',
        'Package Verification Status' => 'Status da verificação do pacote.',
        'Some packages are not verified by the OTOBO Team! It is recommended not to use this packages.' =>
            'Alguns pacotes não são verificados pelo Grupo OTRS! É recomendável que você não utilize estes pacotes.',
        'Package Framework Version Status' => 'Status de Versão de Framework de Pacote',
        'Some packages are not allowed for the current framework version.' =>
            'Alguns pacotes não são permitidos para a versão atual do framework.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/PackageList.pm
        'Package List' => 'Lista de Pacotes',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SessionConfigSettings.pm
        'Session Config Settings' => 'Configurações de Sessão',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SpoolMails.pm
        'Spooled Emails' => 'E-mails enfileirados',
        'There are emails in var/spool that OTOBO could not process.' => 'Existem e-mails em var/spool que o OTOBO não conseguiu processar.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Sua configuração de SystemID não é válida, ela precisa conter apenas dígitos.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Tipo de Ticket Padrão',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'O tipo de ticket padrão configurado está inválido ou faltante. Favor mudar a definição Ticket::Type::Default e selecione um tipo de ticket válido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Módulo de Índice do Ticket',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Você possui mais de 60.000 artigos e deveria usar o backend StaticDB. Veja o manual do administrador (Performance Tuning) para mais informações.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Usuários Inválidos com Tickets Bloqueados',
        'There are invalid users with locked tickets.' => 'Existem usuários inválidos com tickets bloqueados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Você não deveria ter mais que 8.000 chamados abertos em seu sistema.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Módulo de Índice da Pesquisa de Tickets',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Registros órgãos na tabela ticket_lock_index',
        'Table ticket_lock_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A tabela ticket_lock_index contém registros órfãos. Favor executar bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpar o índice StaticDB.',
        'Orphaned Records In ticket_index Table' => 'Registros órfãos na tabela ticket_index',
        'Table ticket_index contains orphaned records. Please run bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'A tabela ticket_index contém registros órfãos. Favor executar bin/otobo.Console.pl "Maint::Ticket::QueueIndexCleanup" para limpar o índice StaticDB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/TimeSettings.pm
        'Time Settings' => 'Configurações de tempo',
        'Server time zone' => 'Servidor de time zone',
        'OTOBO time zone' => 'Fuso horário OTOBO',
        'OTOBO time zone is not set.' => 'O fuso horário OTOBO não foi definido.',
        'User default time zone' => 'Fuso horário padrão para usuário',
        'User default time zone is not set.' => 'O fuso horário padrão para usuário não foi definido.',
        'Calendar time zone is not set.' => 'Fuso horário de calendário não foi definido.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - Utilização de Skin por Agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - Utilização de Tema por Agente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTOBO/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - Estatísticas Especiais',
        'Agents using custom main menu ordering' => 'Agentes utilizando ordenamento padrão no menu principal',
        'Agents using favourites for the admin overview' => 'Agentes utilizando favoritos para a visão geral da administração',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Servidor de Web',
        'Loaded Apache Modules' => 'Módulos Apache Carregados',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'Modelo MPM',
        'OTOBO requires apache to be run with the \'prefork\' MPM model.' =>
            'OTOBO necessita do apache para executar o modelo MPM \'prefork\'',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Uso do CGI Accelerator',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Você deve utilizar o FastCGI ou mod_perl para aumentar o desempenho. ',
        'mod_deflate Usage' => 'Uso do mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Por favor, instale mod_deflate para melhorar o desempenho da GUI.',
        'mod_filter Usage' => 'Uso do mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Por favor instale mod_filter se mod_deflate está sendo usado.',
        'mod_headers Usage' => 'Uso do mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Por favor, instale mod_headers para melhorar o desempenho da GUI',
        'Apache::Reload Usage' => 'Uso do Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ou Apache2::Reload precisa ser usado como PerlModulo e PerlInitHandler para evitar o reset do web server ao instalar e atualizar módulos.',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Variáveis de ambiente',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Coleta de Dados de Suporte',
        'Support data could not be collected from the web server.' => 'Dados de suporte não puderam ser coletados do servidor web.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Versão do Servidor WEB',
        'Could not determine webserver version.' => 'Não foi possível determinar a versão do servidor WEB.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTOBO/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Detalhes de Usuários Concorrentes',
        'Concurrent Users' => 'Usuários Concorrentes',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'OK',
        'Problem' => 'Problema',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Definição %s não existe!',
        'Setting %s is not locked to this user!' => 'Definição %s não está bloqueada para este usuário!',
        'Setting value is not valid!' => 'Valor da definição não é válido!',
        'Could not add modified setting!' => 'Não foi possível adicionar a definição alterada!',
        'Could not update modified setting!' => 'Não foi possível atualizar a definição alterada!',
        'Setting could not be unlocked!' => 'Não foi possível desbloquear a definição!',
        'Missing key %s!' => 'Falta chave %s!',
        'Invalid setting: %s' => 'Definição inválida: %s',
        'Could not combine settings values into a perl hash.' => 'Não foi possível combinar valores de definições em um hash perl.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Não é possível bloquear a implantação para o ID de Usuário \'%s\'!',
        'All Settings' => 'Todas as configurações',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Padrão',
        'Value is not correct! Please, consider updating this field.' => 'Valore não está correto! Por favor, considere atualizar este campo.',
        'Value doesn\'t satisfy regex (%s).' => 'Valor não satisfaz a expressão regular (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Habilitado',
        'Disabled' => 'Desabilitado',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTOBOTimeZone!' =>
            'Sistema não foi capaz de calcular Data de Usuário em OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTOBOTimeZone!' =>
            'Sistema não foi capaz de calcular Data e Hora de Usuário em OTOBOTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Valor não está correto! Por favor, considere atualizar este módulo.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Valor não está correto! Por favos, considere atualizar esta definição.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Redefinir horário de desbloqueio.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Participante de Chat',
        'Chat Message Text' => 'Mensagem de Texto de Chat',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Too many fail attempts, please retry again later' => '',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Autenticação falhou! Nome de usuário ou senha foram digitados incorretamente.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Autenticação realizada com sucesso, mas não foi encontrado registro deste usuário no banco de dados. Entre em contato com o administrador, por favor.',
        'Can`t remove SessionID.' => 'Não é possível remover o ID de Sessão.',
        'Logout successful.' => 'Logout com sucesso.',
        'Feature not active!' => 'Funcionalidade não inativa!',
        'Sent password reset instructions. Please check your email.' => 'Enviadas instruções para redefinição de senha. Por favor, verifique seu e-mail.',
        'Invalid Token!' => 'Token Inválido!',
        'Sent new password to %s. Please check your email.' => 'Enviada nova senha para %s. Por favor, verifique seu e-mail.',
        'Error: invalid session.' => 'Erro: sessão inválida.',
        'No Permission to use this frontend module!' => 'Nenhuma permissão para utilizar este módulo frontend!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Autenticação realizada com sucesso, mas não foi encontrado registro deste cliente no backend. Entre em contato com o administrador, por favor.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Redefinição de senha sem êxito. Por favor, entre em contato com o administrador.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Este endereço de e-mail já existe. Por favor, faça login ou redefina sua senha',
        'This email address is not allowed to register. Please contact support staff.' =>
            'O endereço de email não é permitido para cadastro. Por favor entre em contato com a equipe de suporte.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => 'Usuário cliente não pode ser adicionado@',
        'Can\'t send account info!' => 'Não foi possível enviar informações da conta!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Nova conta criada. Enviadas informações de login para %s. Por favor, verifique seu e-mail.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Ação "%s" não encontrada!',

        # Perl Module: Kernel/System/Web/InterfaceMigrateFromOTRS.pm
        'If you want to re-run the MigrateFromOTRS, disable the SecureMode in the SysConfig.' =>
            '',

        # Database XML Definition: scripts/database/otobo-initial_insert.xml
        'invalid-temporarily' => 'inválido-temporariamente',
        'Group for default access.' => 'Grupo de acesso padrão',
        'Group of all administrators.' => 'Grupo de todos os administradores.',
        'Group for statistics access.' => 'Grupo para acessar estatísticas',
        'new' => 'novo',
        'All new state types (default: viewable).' => 'Todos os tipos de estado (padrão: visível).',
        'open' => 'aberto',
        'All open state types (default: viewable).' => 'Todos os tipos de estado aberto (padrão: visível).',
        'closed' => 'fechado',
        'All closed state types (default: not viewable).' => 'Todos os tipos de estado fechado (padrão: não visível).',
        'pending reminder' => 'lembrete de pendente',
        'All \'pending reminder\' state types (default: viewable).' => 'Todos os tipos \'aviso de pendência\' (padrão: visível).',
        'pending auto' => 'pendente automático',
        'All \'pending auto *\' state types (default: viewable).' => 'Todos os tipos \'pendente auto*\' (padrão: visível).',
        'removed' => 'removido',
        'All \'removed\' state types (default: not viewable).' => 'Todos os tipos de estado \'removido\' (padrão: não visível).',
        'merged' => 'agrupado',
        'State type for merged tickets (default: not viewable).' => 'Tipo de estado para chamados agrupados (padrão: não visível).',
        'New ticket created by customer.' => 'Novo chamado criado pelo cliente.',
        'closed successful' => 'fechado com êxito',
        'Ticket is closed successful.' => 'Chamado fechado com sucesso.',
        'closed unsuccessful' => 'fechado sem êxito',
        'Ticket is closed unsuccessful.' => 'Chamado fechado sem sucesso.',
        'Open tickets.' => 'Chamados abertos.',
        'Customer removed ticket.' => 'Cliente removeu o chamado.',
        'Ticket is pending for agent reminder.' => 'Chamado pendente com alerta de atendente.',
        'pending auto close+' => 'pendente auto fechamento+',
        'Ticket is pending for automatic close.' => 'Chamado pendente com fechamento automático.',
        'pending auto close-' => 'pendente auto fechamento-',
        'State for merged tickets.' => 'Estado para chamados agrupados.',
        'system standard salutation (en)' => 'saudação padrão do sistema (en)',
        'Standard Salutation.' => 'Saudação Padrão.',
        'system standard signature (en)' => 'assinatura padrão do sistema (en)',
        'Standard Signature.' => 'Assinatura Padrão.',
        'Standard Address.' => 'Endereço Padrão.',
        'possible' => 'possível',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Atualização de status dos chamados fechados será possível. Chamados serão reabertos.',
        'reject' => 'rejeitar',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => 'novo chamado',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => 'Fila postmaster.',
        'All default incoming tickets.' => 'Todos tickets recebidos padrão.',
        'All junk tickets.' => 'Todos tickets lixo.',
        'All misc tickets.' => 'Todos tickets diversos.',
        'auto reply' => 'Autorresponder',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Resposta automática que será enviada depois que um novo ticket for criado.',
        'auto reject' => 'Autorrejeitar',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'Autorrevisão',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'Autorresposta/novo chamado',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'Autorremover',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => 'Resposta padrão ( depois que novo chamado foi criado)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'Rejeição padrão (após rejeição do acompanhamento de um chamado fechado).',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => 'Não classificado',
        '1 very low' => '1 Muito Baixo',
        '2 low' => '2 Baixo',
        '3 normal' => '3 Normal',
        '4 high' => '4 Alto',
        '5 very high' => '5 Muito Alto',
        'unlock' => 'desbloqueado',
        'lock' => 'bloqueado',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'atendente',
        'system' => 'sistema',
        'customer' => 'cliente',
        'Ticket create notification' => 'Notificação de criação de ticket',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Você receberá uma notificação a cada vez que um novo ticket for criado em uma de suas "Minhas Filas" ou "Meus Serviços".',
        'Ticket follow-up notification (unlocked)' => 'Notificação de revisão de chamado (desbloqueado)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'Notificação de revisão de chamado (bloqueado)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Notificação de Expiração de Bloqueio de Chamado',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Você irá receber uma notificação assim que um ticket de sua propriedade for desbloqueado automaticamente.',
        'Ticket owner update notification' => 'Notificação de atualização de proprietário de chamado',
        'Ticket responsible update notification' => 'Notificação de atualização de responsável por um ticket',
        'Ticket new note notification' => 'Notificação de nova nota em um ticket',
        'Ticket queue update notification' => 'Notificação de atualização de fila de um ticket',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Você irá receber uma notificação se um ticket for movido a uma de "Minhas Filas".',
        'Ticket pending reminder notification (locked)' => 'Notificação de chamado pendente (bloqueado)',
        'Ticket pending reminder notification (unlocked)' => 'Notificação de chamado pendente (desbloqueado)',
        'Ticket escalation notification' => 'Notificação de escalação de chamado',
        'Ticket escalation warning notification' => 'Notificação de alerta de escalação de chamado',
        'Ticket service update notification' => 'Notificação de atualização de serviço do chamado',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Você receberá uma notificação se o serviço de algum chamado for alterado para um de seus "Meus Serviços".',
        'Appointment reminder notification' => 'Notificação de lembrete do compromisso',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Você receberá uma notificação toda vez que o tempo de lembrete para um de seus compromissos for atingido .',
        'Ticket email delivery failure notification' => 'Notificação de falha na entrega de ticket de e-mail',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Error durante comunicação AJAX. Status: %s, Erro: %s',
        'This window must be called from compose window.' => 'Esta tela deve ser chamada da tela de composição.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Adicionar todos',
        'An item with this name is already present.' => 'Um item com o mesmo nome já está presente.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Este item já contém subitens. Você tem certeza que quer remover este item incluindo seus subitens?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Mais',
        'Less' => 'Menos',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Pressione Ctrl+C (Cmd+C) para copiar para o clipboard',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Excluir este Anexo',
        'Deleting attachment...' => 'Excluindo anexo...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Houve um erro ao excluir este anexo. Por favor verifique os logs para mais informação.',
        'Attachment was deleted successfully.' => 'Anexo foi excluído com sucesso.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Deseja realmente remover este campo dinâmico? TODOS os dados assiciados a ele serão PERDIDOS!',
        'Delete field' => 'Removar campo',
        'Deleting the field and its data. This may take a while...' => 'Delindo o campo e seus dados.  Isto pode levar um tempo…',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Remover tradução',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Excluir este disparador de evento',
        'Duplicate event.' => 'Duplicar evento.',
        'This event is already attached to the job, Please use a different one.' =>
            'Este evento já está associado a uma tarefa, por favor use um diferente.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Ocorreu um erro durante a comunicação.',
        'Request Details' => 'Detalhes da Requisição',
        'Request Details for Communication ID' => 'Detalhes de Solicitação para ID de Comunicação',
        'Show or hide the content.' => 'Exibir ou ocultar conteúdo.',
        'Clear debug log' => 'Limpar log de depuração',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Excluir módulo de tratamento de erros',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Não é possível adicionar um novo disparador de eventos porque o evento não foi definido.',
        'Delete this Invoker' => 'Exclua este invoker',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Desculpe, a única condição existente não pode ser removida.',
        'Sorry, the only existing field can\'t be removed.' => 'Desculpe, o único campo existente não pode ser removido.',
        'Delete conditions' => 'Condições de exclusão',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Mapeamento para Chave %s',
        'Mapping for Key' => 'Mapeamento para Chave',
        'Delete this Key Mapping' => 'Exclui este mapeamento de chaves',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Excluir esta Operação',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Copiar Web Service',
        'Delete operation' => 'Excluir operação',
        'Delete invoker' => 'Excluir invoker',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'AVISO: Quando você altera o nome do grupo \'admin\', antes de fazer as alterações apropriadas no SysConfig, você será bloqueado para fora do painel de administração! Se isso acontecer, por favor renomeie de volta o grupo através de comandos SQL.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Deletar conta de e-mail.',
        'Deleting the mail account and its data. This may take a while...' =>
            'Deletando a conta de e-mail e suas informações. Isto pode demorar um pouco...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Você realmente quer apagar este idioma notificação?',
        'Do you really want to delete this notification?' => 'Você realmente quer apagar essa notificação ?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Você realmente quer excluir esta chave?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Existe um processo de atualização de pacote em andamento, clique aqui para ver o estado em que se encontra o progresso.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'A atualização de um pacote finalizou recentemente. Clique aqui para ver o resultado.',
        'No response from get package upgrade result.' => '',
        'Update all packages' => 'Atualizar todos pacotes',
        'Dismiss' => 'Recusar',
        'Update All Packages' => 'Atualizar Todos Pacotes',
        'No response from package upgrade all.' => '',
        'Currently not possible' => 'Não é possível no momento',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Isso está desabilitado atualmente devido a uma atualização de pacote em andamento.',
        'This option is currently disabled because the OTOBO Daemon is not running.' =>
            'Esta opção não está disponível no momento porque o Daemon OTOBO não está ativo.',
        'Are you sure you want to update all installed packages?' => 'Você tem certeza de que quer atualizar todos os pacotes instalados?',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Deletar Filtro PostMaster',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Excluindo o filtro postmaster e seus dados. Isso pode levar um tempo...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Remover Entidade da tela',
        'No TransitionActions assigned.' => 'Nenhum Ação de Transição atribuída.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Sem Janelas atribuídas ainda. Basta escolher uma Janela de Atividade da lista à esquerda e arrastar aqui.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Esta Atividade não pode ser excluída porque ela é o Início da Atividade.',
        'Remove the Transition from this Process' => 'Remover a transição deste processo',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Assim que você usar este botão ou link, você deixará tela e seu estado atual será salvo automaticamente. Você quer continuar?',
        'Delete Entity' => 'Excluir Entidade',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Esta Atividade já está em uso no Processo. Você não pode adicioná-la novamente!',
        'Error during AJAX communication' => 'Erro durante a comunicação AJAX',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Uma transição sem ligação já está colocada sobre a tela. Por favor conecte esta transição primeiro antes de colocar outra transição.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Esta Transição já está em uso nesta Atividade. Você não pode adicioná-la novamente!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Esta Ação de Transição já está em uso por este Caminho. Você não pode adicioná-la novamente!',
        'Hide EntityIDs' => 'Ocultar EntityIDs',
        'Edit Field Details' => 'Editar Detalhes do Campo',
        'Customer interface does not support articles not visible for customers.' =>
            'A interface de cliente não permite artigos que não estejam visíveis ao cliente.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Desculpe, o único parâmetro existente não pode ser removido.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Você realmente quer excluir este certificado?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Enviando Atualização...',
        'Support Data information was successfully sent.' => 'Informação de Suporte enviada com sucesso.',
        'Was not possible to send Support Data information.' => 'Não foi possível enviar informações dados de suporte.',
        'Update Result' => 'Resultado da Atualização',
        'Generating...' => 'Gerando...',
        'It was not possible to generate the Support Bundle.' => 'Não foi possível gerar o Pacote de Suporte.',
        'Generate Result' => 'Gerar Resultado',
        'Support Bundle' => 'Pacote de Suporte',
        'The mail could not be sent' => 'A mensagem não pôde ser enviada',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Não é possível definir esta entrada como inválida. Todas definições de configuração afetadas precisam ser alteradas anteriormente.',
        'Cannot proceed' => 'Não é possível continuar',
        'Update manually' => 'Atualizar manualmente',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Você pode atualizar automaticamente todas as definições afetas para refletir as alterações que você acabou de fazer ou alterar pessoalmente ao clicar em \'atualizar manualmente\'.',
        'Save and update automatically' => 'Salvar e atualizar automaticamente',
        'Don\'t save, update manually' => 'Não salvar, atualizar manualmente',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'O item que você está visualizando atualmente é parte de uma configuração de uma definição que ainda não foi implantada, o que torna impossível editar em seu estado atual. Por favor, espere até que esta definição seja implantada. Se você estiver inseguro com o que fazer, por favor, entre em contato com o administrador do sistema.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Carregando...',
        'Search the System Configuration' => 'Pesquisar a Configuração do Sistema',
        'Please enter at least one search word to find anything.' => 'Por favor, digite ao menos uma palavra de pesquisa para encontrar algo.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Infelizmente, implantação não é possível no momento possivelmente porque outro agente esta realizando uma implantação. Por favor, tente novamente mais tarde.',
        'Deploy' => 'Implantar',
        'The deployment is already running.' => 'A implantação já está em execução.',
        'Deployment successful. You\'re being redirected...' => 'Implantação bem sucedida. Você está sendo redirecionado...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Ocorreu um erro. Favor salvar todas definições que você está editando e verifique os logs para mais informações.',
        'Reset option is required!' => 'Opção de redefinição é necessária!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Ao restaurar esta implantação, todas as definições serão revertidas para o valor que tinham no momento da implantação. Você realmente deseja continuar?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Chaves com valores não podem ser renomeadas. Ao invés disso, favor remover este par chave/valor e readicionar posteriormente.',
        'Unlock setting.' => 'Desbloquear definição.',

        # JS File: Core.Agent.Admin.SystemConfigurationUser
        'Are you sure you want to remove all user values?' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Você quer mesmo excluir esta manutenção programada do sistema?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Excluir este Modelo',
        'Deleting the template and its data. This may take a while...' =>
            'Excluindo o modelo e os seus dados. Isso pode levar um tempo...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Pular',
        'Timeline Month' => 'Linha de tempo do mês',
        'Timeline Week' => 'Linha de tempo da semana',
        'Timeline Day' => 'Linha de tempo do dia',
        'Previous' => 'Anterior',
        'Resources' => 'Recursos',
        'Su' => 'D',
        'Mo' => 'S',
        'Tu' => 'T',
        'We' => 'Q',
        'Th' => 'Q',
        'Fr' => 'S',
        'Sa' => 'S',
        'This is a repeating appointment' => 'Este é um compromisso repetido',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Você deseja editar apenas essa ocorrência ou todas as ocorrências?',
        'All occurrences' => 'Todas as ocorrências ',
        'Just this occurrence' => 'Apenas essa ocorrência',
        'Too many active calendars' => 'Muitos calendários ativos',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Por favor, desligue alguns primeiro ou aumente o limite na configuração.',
        'Restore default settings' => 'Restaurar configurações padrão',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Tem certeza que deseja remover esse compromisso? Essa operação não pode ser desfeita.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Primeiro selecione um usuário cliente, então você poderá selecionar uma ID de cliente para atribuir a este ticket.',
        'Duplicated entry' => 'Entrada duplicada',
        'It is going to be deleted from the field, please try again.' => 'Será excluído do campo, por favor, tente novamente.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Por favor, insira algum valor para a pesquisa ou * para pesquisar tudo.',

        # JS File: Core.Agent.Daemon
        'Information about the OTOBO Daemon' => 'Informação sobre o OTOBO Daemon',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Por favor, verifique os campos marcados em vermelho para entradas válidas.',
        'month' => 'mês',
        'Remove active filters for this widget.' => 'Remover filtros ativos para este painel.',

        # JS File: Core.Agent.DynamicFieldDBSearch
        'This dynamic field database value is already selected.' => '',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Por favor aguarde...',
        'Searching for linkable objects. This may take a while...' => 'Pesquisando por objetos associáveis. Isso pode levar algum tempo...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Você realmente quer excluir esta associação?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Você está utilizando um plugin de navegador AdBlock ou AdBlockPlus? Isso pode causar diversos problemas e nós recomendamos fortemente que você adicione uma exceção para este domínio.',
        'Do not show this warning again.' => 'Não mostrar este alerta novamente.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Desculpe, mas você não pode desabilitar todos os métodos para notificações marcadas como mandatórias.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Desculpe, mas você não pode desabilitar todos os métodos para esta notificação.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Por favor, note que pelo menos uma das configurações que você modificou recentemente necessita que a página seja atualizada. Clique aqui para atualizar a tela atual.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Ocorreu um erro desconhecido. Favor contatar o administrador.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Trocar para modo desktop',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Por favor, remova as seguintes palavras da sua pesquisa porque elas não podem ser pesquisadas:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Gerar',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Este elemento contém elementos filhos e não pode ser removido no momento.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Você quer realmente excluir esta estatística?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Selecione uma ID de cliente para atribuir a este ticket',
        'Do you really want to continue?' => 'Você realmente quer continuar?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => ' ...e mais %s',
        ' ...show less' => '...mostrar menos',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Adicionar novo rascunho',
        'Delete draft' => 'Remover rascunho',
        'There are no more drafts available.' => 'Mais nenhum rascunho disponível.',
        'It was not possible to delete this draft.' => 'Não foi possível excluir este rascunho.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Filtro Para Artigo',
        'Apply' => 'Aplicar',
        'Event Type Filter' => 'Filtro de Tipo de Evento',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Deslize a barra de navegação',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Por favor desative o Modo de Compatibilidade no Internet Explorer!',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Trocar para modo móvel',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Erro: Falha ao Verificar Navegador!',
        'Reload page' => 'Atualizar página',
        'Reload page (%ss)' => 'Recarregar página (%ss)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'Ocorreu um erro! Favor verificar o log de erro do navegador para mais informações!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Um ou mais erros ocorreram!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Êxito na verificação de e-mail.',
        'Error in the mail settings. Please correct and try again.' => 'Erro nas configurações de e-mail. Por favor, corrija e tente novamente.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => 'Favor adicionar valores para todas as chaves antes de salvar esta definição.',
        'The key must not be empty.' => 'A chave não pode estar vazia.',
        'A key with this name (\'%s\') already exists.' => 'Uma chave com o nome (\'%s\') já existe.',
        'Do you really want to revert this setting to its historical value?' =>
            'Você realmente quer reverte esta definição ao seu valor histórico?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Abrir seleção de data',
        'Invalid date (need a future date)!' => 'Data inválida (é necessária uma data futura)!',
        'Invalid date (need a past date)!' => 'Data inválida (é necessário uma data no passado)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Não disponível',
        'and %s more...' => 'e %s mais...',
        'Show current selection' => 'Mostrar seleção atual',
        'Current selection' => 'Seleção atual',
        'Clear all' => 'Limpar todos',
        'Filters' => 'Filtros',
        'Clear search' => 'Limpar busca',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Se você sair desta página agora, todas as janelas popup aberta serão fechada também!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Um popup desta janela já está aberto. Você quer fechá-lo e carregar este no lugar?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Não foi possível abrir a janela popup. Desative os bloqueadores de popup para esta aplicação.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Ordenamento ascendente aplicado.',
        'Descending sort applied, ' => 'Ordenamento descendente aplicado.',
        'No sort applied, ' => 'Nenhum ordenamento aplicado,',
        'sorting is disabled' => 'ordenamento está desabilitado',
        'activate to apply an ascending sort' => 'ative para aplicar um ordenamento ascendente',
        'activate to apply a descending sort' => 'ative para aplicar um ordenamento descendente',
        'activate to remove the sort' => 'ative para remover o ordenamento',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Remover o filtro',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Não há elementos disponíveis atualmente para seleção.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Por favor, selecione apenas um arquivo para carregar.',
        'Sorry, you can only upload one file here.' => 'Desculpe, você só pode carregar um arquivo aqui.',
        'Sorry, you can only upload %s files.' => 'Desculpe, você só pode carregar %s arquivos.',
        'Please only select at most %s files for upload.' => 'Por favor, selecione no máximo %s arquivos para carregar.',
        'The following files are not allowed to be uploaded: %s' => 'O carregamento dos seguintes arquivos não está autorizado: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Os seguintes arquivos excedem o tamanho máximo permitido de %s por aquivo e não foram carregados: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Os seguintes arquivos já tinham sido carregados e não foram carregados novamente: %s',
        'No space left for the following files: %s' => 'Não sobrou espaço para os seguintes arquivos: %s',
        'Available space %s of %s.' => 'Espaço disponível %s de %s.',
        'Upload information' => 'Atualizar informação',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Um erro desconhecido ocorreu ao excluir o anexo. Por favor, tente novamente. Se o erro persistir, favor contatar seu administrador do sistema.',

        # JS File: Core.Language.UnitTest
        'yes' => 'sim',
        'no' => 'não',
        'This is %s' => 'Isto é %s',
        'Complex %s with %s arguments' => '%s complexo com %s argumentos',

        # JS File: OTOBOLineChart
        'No Data Available.' => 'Nenhum dado disponível.',

        # JS File: OTOBOMultiBarChart
        'Grouped' => 'Agrupado',
        'Stacked' => 'Empilhado',

        # JS File: OTOBOStackedAreaChart
        'Stream' => 'Fluxo',
        'Expanded' => 'Expandido',

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
