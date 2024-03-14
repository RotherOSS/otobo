# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::Language::es_ArticleFeatures;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Edit'} = 'Editar';
    $Self->{Translation}->{'Restore'} = 'Restaurar';
    $Self->{Translation}->{'Show deleted articles'} = 'Mostrar artículos borrados';
    $Self->{Translation}->{'Hide deleted articles'} = 'Ocultar artículos borrados';
    $Self->{Translation}->{'Are you sure you want to delete this article?'} = 'Está seguro(a) de borrar el artículo?';
    $Self->{Translation}->{'Article Delete'} = 'Borrar Artículo';
    $Self->{Translation}->{'Article deleted successfully!'} = 'Artículo borrado exitosamente!';
    $Self->{Translation}->{'Information'} = 'Información';
    $Self->{Translation}->{'Article Restore'} = 'Restaurar Artículo';
    $Self->{Translation}->{'Are you sure you want to restore this article?'} = 'Está seguro(a) de restaurar el artículo?';
    $Self->{Translation}->{'Article restored successfully!'} = 'Artículo restaurado exitosamente!';
    $Self->{Translation}->{'Edit Article "%s" of %s%s%s'} = 'Editar Artículo "%s" de %s%s%s';
    $Self->{Translation}->{'Viewing Article Version#%s of current Article: #%s %s'} = 'Visualizando Versión#%s del Artículo actual: #%s %s';
    $Self->{Translation}->{'Article Edited'} = 'Artículo Editado';
    $Self->{Translation}->{'The article was edited'} = 'El artículo fue editado';

    $Self->{JavaScriptStrings} = [
        'Are you sure you want to delete this article?',
        'Are you sure you want to restore this article?',
        'Article Delete',
        'Information',
        'Article deleted successfully!',
        'Article Restore',
        'Article restored successfully!'
    ];
    return;
}

1;
