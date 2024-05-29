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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get HTMLUtils object
my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

# DocumentComplete tests
my @Tests = (
    {
        Input  => 'Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => <<'END_HTML',
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>:root{--ck-color-image-caption-background:hsl(0,0%,97%);--ck-color-image-caption-text:hsl(0,0%,20%);--ck-color-mention-background:hsla(341,100%,30%,.1);--ck-color-mention-text:hsl(341,100%,30%);--ck-color-selector-caption-background:hsl(0,0%,97%);--ck-color-selector-caption-text:hsl(0,0%,20%);--ck-highlight-marker-blue:hsl(201,97%,72%);--ck-highlight-marker-green:hsl(120,93%,68%);--ck-highlight-marker-pink:hsl(345,96%,73%);--ck-highlight-marker-yellow:hsl(60,97%,73%);--ck-highlight-pen-green:hsl(112,100%,27%);--ck-highlight-pen-red:hsl(0,85%,49%);--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing) / 2);--ck-todo-list-checkmark-size:16px;--otobo-colMainLight:#001bff}.table .ck-table-resized{table-layout:fixed}.table table{overflow:hidden;border-collapse:collapse;border-spacing:0;width:100%;height:100%;border:1px double #b2b2b2}.image img,img.image_resized{height:auto}.table td,.table th{overflow-wrap:break-word;position:relative}.table{margin:.9em auto;display:table;}table{font-size:inherit;}.table table td,.table table th{min-width:2em;padding:.4em;border:1px solid #bfbfbf}.table table th{font-weight:700;background:hsla(0,0%,0%,5%)}.table[dir=rtl] th{text-align:right}.table[dir=ltr] th,pre{text-align:left}.page-break{position:relative;clear:both;padding:5px 0;display:flex;align-items:center;justify-content:center}.image img,.image.image_resized&gt;figcaption,.media,.page-break__label{display:block}.page-break::after{content:'';position:absolute;border-bottom:2px dashed #c4c4c4;width:100%}.page-break__label{position:relative;z-index:1;padding:.3em .6em;text-transform:uppercase;border:1px solid #c4c4c4;border-radius:2px;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;color:#333;background:#fff;box-shadow:2px 2px 1px hsla(0,0%,0%,.15);-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.media{clear:both;margin:.9em 0;min-width:15em}ol{list-style-type:decimal}ol ol{list-style-type:lower-latin}ol ol ol{list-style-type:lower-roman}ol ol ol ol{list-style-type:upper-latin}ol ol ol ol ol{list-style-type:upper-roman}ul{list-style-type:disc}ul ul{list-style-type:circle}ul ul ul,ul ul ul ul{list-style-type:square}.image{display:table;clear:both;text-align:center;margin:.9em auto;min-width:50px}.image img{margin:0 auto;max-width:100%;min-width:100%}.image-inline{display:inline-flex;max-width:100%;align-items:flex-start}.image-inline picture{display:flex}.image-inline img,.image-inline picture{flex-grow:1;flex-shrink:1;max-width:100%}.image.image_resized{max-width:100%;display:block;box-sizing:border-box}.image.image_resized img{width:100%}.image&gt;figcaption{display:table-caption;caption-side:bottom;word-break:break-word;color:var(--ck-color-image-caption-text);background-color:var(--ck-color-image-caption-background);padding:.6em;font-size:.75em;outline-offset:-1px}.image-style-block-align-left,.image-style-block-align-right{max-width:calc(100% - var(--ck-image-style-spacing))}.image-style-align-left,.image-style-align-right{clear:none}.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.image-style-align-center{margin-left:auto;margin-right:auto}.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.image-style-block-align-right{margin-right:0;margin-left:auto}.image-style-block-align-left{margin-left:0;margin-right:auto}p+.image-style-align-left,p+.image-style-align-right,p+.image-style-side{margin-top:0}.image-inline.image-style-align-left,.image-inline.image-style-align-right{margin-top:var(--ck-inline-image-style-spacing);margin-bottom:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-left{margin-right:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.marker-green{background-color:var(--ck-highlight-marker-green)}.marker-pink{background-color:var(--ck-highlight-marker-pink)}.marker-blue{background-color:var(--ck-highlight-marker-blue)}.pen-green,.pen-red{background-color:transparent}.pen-red{color:var(--ck-highlight-pen-red)}.pen-green{color:var(--ck-highlight-pen-green)}blockquote{overflow:hidden;padding:0 0 0 4pt;margin-left:0;margin-right:0;font-style:normal;border-left:solid var(--otobo-colMainLight) 1.5pt}.ck-content[dir=rtl] blockquote{border-left:0;border-right:solid var(--otobo-colMainLight) 1.5pt}code{background-color:hsla(0,0%,78%,.3);padding:.15em;border-radius:2px}hr{margin:15px 0;height:4px;background:#ddd;border:0}pre{padding:1em;color:hsl(0,0%,20.8%);background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;direction:ltr;tab-size:4;white-space:pre-wrap;font-style:normal;min-width:200px}pre code{background:unset;padding:0;border-radius:0}@media print{.page-break{padding:0}.page-break::after{display:none}}</style></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>
END_HTML
        Name => 'text without markup'
    },
    {
        Input  => 'Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Result => <<'END_HTML',
<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>:root{--ck-color-image-caption-background:hsl(0,0%,97%);--ck-color-image-caption-text:hsl(0,0%,20%);--ck-color-mention-background:hsla(341,100%,30%,.1);--ck-color-mention-text:hsl(341,100%,30%);--ck-color-selector-caption-background:hsl(0,0%,97%);--ck-color-selector-caption-text:hsl(0,0%,20%);--ck-highlight-marker-blue:hsl(201,97%,72%);--ck-highlight-marker-green:hsl(120,93%,68%);--ck-highlight-marker-pink:hsl(345,96%,73%);--ck-highlight-marker-yellow:hsl(60,97%,73%);--ck-highlight-pen-green:hsl(112,100%,27%);--ck-highlight-pen-red:hsl(0,85%,49%);--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing) / 2);--ck-todo-list-checkmark-size:16px;--otobo-colMainLight:#001bff}.table .ck-table-resized{table-layout:fixed}.table table{overflow:hidden;border-collapse:collapse;border-spacing:0;width:100%;height:100%;border:1px double #b2b2b2}.image img,img.image_resized{height:auto}.table td,.table th{overflow-wrap:break-word;position:relative}.table{margin:.9em auto;display:table;}table{font-size:inherit;}.table table td,.table table th{min-width:2em;padding:.4em;border:1px solid #bfbfbf}.table table th{font-weight:700;background:hsla(0,0%,0%,5%)}.table[dir=rtl] th{text-align:right}.table[dir=ltr] th,pre{text-align:left}.page-break{position:relative;clear:both;padding:5px 0;display:flex;align-items:center;justify-content:center}.image img,.image.image_resized&gt;figcaption,.media,.page-break__label{display:block}.page-break::after{content:'';position:absolute;border-bottom:2px dashed #c4c4c4;width:100%}.page-break__label{position:relative;z-index:1;padding:.3em .6em;text-transform:uppercase;border:1px solid #c4c4c4;border-radius:2px;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;color:#333;background:#fff;box-shadow:2px 2px 1px hsla(0,0%,0%,.15);-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.media{clear:both;margin:.9em 0;min-width:15em}ol{list-style-type:decimal}ol ol{list-style-type:lower-latin}ol ol ol{list-style-type:lower-roman}ol ol ol ol{list-style-type:upper-latin}ol ol ol ol ol{list-style-type:upper-roman}ul{list-style-type:disc}ul ul{list-style-type:circle}ul ul ul,ul ul ul ul{list-style-type:square}.image{display:table;clear:both;text-align:center;margin:.9em auto;min-width:50px}.image img{margin:0 auto;max-width:100%;min-width:100%}.image-inline{display:inline-flex;max-width:100%;align-items:flex-start}.image-inline picture{display:flex}.image-inline img,.image-inline picture{flex-grow:1;flex-shrink:1;max-width:100%}.image.image_resized{max-width:100%;display:block;box-sizing:border-box}.image.image_resized img{width:100%}.image&gt;figcaption{display:table-caption;caption-side:bottom;word-break:break-word;color:var(--ck-color-image-caption-text);background-color:var(--ck-color-image-caption-background);padding:.6em;font-size:.75em;outline-offset:-1px}.image-style-block-align-left,.image-style-block-align-right{max-width:calc(100% - var(--ck-image-style-spacing))}.image-style-align-left,.image-style-align-right{clear:none}.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.image-style-align-center{margin-left:auto;margin-right:auto}.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.image-style-block-align-right{margin-right:0;margin-left:auto}.image-style-block-align-left{margin-left:0;margin-right:auto}p+.image-style-align-left,p+.image-style-align-right,p+.image-style-side{margin-top:0}.image-inline.image-style-align-left,.image-inline.image-style-align-right{margin-top:var(--ck-inline-image-style-spacing);margin-bottom:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-left{margin-right:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.marker-green{background-color:var(--ck-highlight-marker-green)}.marker-pink{background-color:var(--ck-highlight-marker-pink)}.marker-blue{background-color:var(--ck-highlight-marker-blue)}.pen-green,.pen-red{background-color:transparent}.pen-red{color:var(--ck-highlight-pen-red)}.pen-green{color:var(--ck-highlight-pen-green)}blockquote{overflow:hidden;padding:0 0 0 4pt;margin-left:0;margin-right:0;font-style:normal;border-left:solid var(--otobo-colMainLight) 1.5pt}.ck-content[dir=rtl] blockquote{border-left:0;border-right:solid var(--otobo-colMainLight) 1.5pt}code{background-color:hsla(0,0%,78%,.3);padding:.15em;border-radius:2px}hr{margin:15px 0;height:4px;background:#ddd;border:0}pre{padding:1em;color:hsl(0,0%,20.8%);background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;direction:ltr;tab-size:4;white-space:pre-wrap;font-style:normal;min-width:200px}pre code{background:unset;padding:0;border-radius:0}@media print{.page-break{padding:0}.page-break::after{display:none}}</style></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">Some <b> Bold Text</b> ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>
END_HTML
        Name => 'text with markup'
    },
    {
        Input  => '<html><body>Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>',
        Result => <<'END_HTML',
<html><body>Some Text ⛄ - U+026C4 - SNOWMAN WITHOUT SNOW</body></html>
END_HTML
        Name => 'document already complete'
    },
);

for my $Test (@Tests) {
    my $CompletedHTML = $HTMLUtilsObject->DocumentComplete(
        String => $Test->{Input},
    );
    is(
        "$CompletedHTML\n",
        $Test->{Result},
        $Test->{Name},
    );
}

done_testing;
