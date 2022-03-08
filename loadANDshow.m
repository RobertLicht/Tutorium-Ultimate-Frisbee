% Skript zum auswaehlen und lesen von Dateien

% Paket laden (Installation: pkg install -forge io)
pkg load io

clear all;
clc;

%   Datei auswaehlen
[fname, fpath, fltidx] = uigetfile ({"*.xlsx", "Excel2007+"; ...
                                     "*.xls", "Excel97-2003"; ...
                                     "*.ods", "OpenOffice"}, "Select File");
                                                
%   Build absolute path
fullpath = sprintf('%s%s', fpath, fname);
 
%% User input
%nbrWrkSht = input('Enter worksheet number (2 or 3): ');
nbrWrkSht = str2double(inputdlg ('Enter worksheet number (2 or 3):', 'Select worksheet'));                        
                           
%   Read from selected File
DataIN = xlsread (fullpath, nbrWrkSht, [], 'OCT');

%   Daten sortieren
% Anstellwinkel
aoa = DataIN(:, 2);
% Widerstandsbeiwert
cw = DataIN(:, 5);
% Auftriebsbeiwert
ca = DataIN(:, 6);

%   Daten anzeigen
fg11 = figure(11);
% Eigenschaften zum handle antragen, durch den Befehl set(...)
set(fg11,'Name','Darstellung der Werte','NumberTitle','on');
plot(aoa, cw, 'o', aoa, ca, 'd'); grid on;
title('Werte aus Datei')
xlabel('Anstellwinkel in [deg]')
ylabel('Beiwerte in [-]')
% Legende
legend('ca', 'cw');

%% Daten Verarbeiten
%   Grad abfragen
% Abfrage ca
%grdCa = input('Grad für ca angeben: ');
grdCa = str2double(inputdlg ('Grad fuer ca angeben (6):', 'Eingabe polyfit ac'));
% Abfrage cw
%grdCw = input('Grad für cw angeben: ');
grdCw = str2double(inputdlg ('Grad fuer cw angeben (6):', 'Eingabe polyfit aw'));

% Berechnug der Koeffizienten durch die Funktion polyfit
% Koeffizienten Auftriebsbeiwert
koeffCa = polyfit(aoa, ca , grdCa);

% Koeffizienten Widerstandsbeiwert
koeffCw = polyfit(aoa, cw, grdCw);

%% Ausgabe der Koeffizienten
% Exportieren der Ergebnisse
% Name der Exportdatei im .csv - Format
datName = 'ExportKoeff.csv';
%   Dateinamen erfragen
%datName = input('\nDateinamen angeben:\n', 's');
% Header für Ca schreiben
headrCa = 'Werte-ca;';
% Header für Cw schreiben
headrCw = 'Werte-cw;';
% Ca - Werte schreiben
valCa = sprintf('%.12f;', koeffCa);
% Cw - Werte schreiben
valCw = sprintf('%.12f;', koeffCw);

% In Datei schreiben
% Header für Ca in Datei schreiben
dlmwrite(datName, headrCa, "delimiter", "", "newline", "pc");
% Ca - Werte zur Datei anhängen
dlmwrite(datName, valCa, "-append", ...
"roffset", 0, "delimiter", "","newline", "pc");

% Header für Cw in Datei schreiben
dlmwrite(datName, headrCw, "delimiter", "", "-append",...
"roffset", 2, "newline", "pc");
% Cw - Werte zur Datei anhängen
dlmwrite(datName, valCw, "-append",...
"roffset", 0, "delimiter", "","newline", "pc");

%% Funktion aufrufen
%   Funkion mit Koeffizienten ausführen
flugScheibe(koeffCa, koeffCw);
