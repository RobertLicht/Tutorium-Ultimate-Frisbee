%% IWSW Tutorium
%
% Technische Universität Clausthal
%
% Vorlesung: Ingenieurwissenschaftliche Softwarewerkzeuge (IWSW)
%
%
% Uebung 3 A2.1: Spirale mit umgekehrter Drehrichtung
%
% Beschreibung:
% Script mit Anweisungen zur Bearbeitung der Uebung 3
% Bearbeitung des Teils: Zum Warmwerden
%
%......................................................................
% Änderungslog
%
% 2012-11-07    Ahlborn
%               Erstellen: Ursprüngliche Musterlösung
%
% 06/04/2017  Lichterfeld, Robert-Vincent
%             Überarbeitet: Aufgabe 2.1 c) Spirale mit umgekehrter
%             Drehrichtung  


%% Aufräumen
% Ausgewählte Variablen löschen
clear R Rin_b d;
% Command Window leeren
clc;

%% Aufgabe 2.1 a)
%   Parameter initialisieren
% Anzahl der Stützpunkte
d = 16; 
% Stützpunkte           [rad]
phiSt = 0 : ((2*pi)/d) : (2*pi);
% Radius, fest          [m]
% R = 2E-3;
% Abfrage des Radius aus dem Command Window
R = input('Bitte den Radius in [mm] angeben (Kreis): ')/1000;

% Stützpunkte im kartesischen Koordinatensystem
% X-Koordinaten berechnen
x = R*cos(phiSt);
% Y-Koordinaten berechnen
y = R*sin(phiSt);

%% Aufgabe 2.1 b)
%   Weitere Parameter abfragen
% Abfrage des Radius                        [mm]
Rin_b = input('Bitte den Radius in [mm] angeben (Spirale): ')/1000;
% Abfrage der Windungen                     [-]
turns_b = input('Windungen (Spirale): ');
% Berechnen der Spiralkoordinaten
% Stützpunkwinkel                           [rad]
phiSt_b = 0 : ((2*pi) / d): (turns_b*2*pi);
% Stützpunktradius                          [m]
R_b = Rin_b : ((-Rin_b) / (d*turns_b) ): 0;
% Stützpunkte im kartesischen Koordinatensystem
% X-Koordinaten berechnen
x_b = R_b.*cos(phiSt_b);
% Y-Koordinaten berechnen
y_b = R_b.*sin(phiSt_b);

%% Aufgabe 2.1 c)
%   Weitere Parameter abfragen
% Abfrage der Höhe                  [mm]
h_c = input('Bitte Hoehe der Kegelhelix in [mm] angeben: ')/1000;

% Berechnen der Stützpunkthoehe für den Kegel
% Hoehenstützpunkte                 [mm]
z = 0: (h_c /(d*turns_b)) : h_c; 

%% Erweiterung für Ue 3 - A 2.1 c)
% Spirale mit umgekehrter Drehrichtung
% Stützpunkwinkel                           [rad]
phiSt_3b = (turns_b*2*pi) : ((-2*pi) / d): 0;
% Stützpunkte im kartesischen Koordinatensystem
% X-Koordinaten berechnen
x_3b = R_b.*cos(phiSt_3b);
% Y-Koordinaten berechnen
y_3b = R_b.*sin(phiSt_3b);


%% Darstellung Ue 3 - A 2.1 c)
% Erstellen eines figure windows und dieses auf handle referenzieren
fg01 = figure(1); 
% Eigenschaften zum handle antragen, durch den Befehl set(...)
set(fg01,'Name','Lösungsbeispiel | Uebung 3 - A2.1 c)','NumberTitle','on');
% relative Angabe [left bottom width height]
set(fg01,'Units','normalized','Position',[0.12 0.20 0.6 0.58]);

% Matrixartige Anordnung mehrerer Plots
% Erstellen des ersten Plots
subplot(2,2,1)
% Grafische Darstellung des Kreises
plot(x, y, '-b', 'LineWidth', 2);
% Gitterlinien im Hintergrund
grid on;

% Beschriftungen
% Titel für das Diagram - [mehrere Argumente]
title(['Kreis mit Radius ', num2str(R), ' m'], 'FontSize', 14);
% X- Achsenbeschriftung
xlabel('X-Achse (Abzisse)'); 
% Y- Achsenbeschriftung
ylabel('Y-Achse (Ordinate)');
% Gitterlinien im Hintergrund
grid on;
% Achsen mit gleichem Masstab verwenden
axis equal;


% Matrixartige Anordnung mehrerer Plots
% Erstellen des zweiten Plots
subplot(2,2,2)
% Grafische Darstellung der Kegelhelix
plot3(x_b, y_b, z, '-g', 'LineWidth', 2);
% Gitterlinien im Hintergrund
grid on;

% Beschriftungen
% Titel für das Diagram - [mehrere Argumente]
title(['Kegelhelix mit der Höhe ', num2str(h_c), ' m'], 'FontSize', 14);
% X-Achsenbeschriftung
xlabel('X-Achse (Abzisse)'); 
% Y-Achsenbeschriftung
ylabel('Y-Achse (Ordinate)');
% Z-Achsenbeschriftung
zlabel('Z-Achse');
% Gitterlinien im Hintergrund
grid on;
% Achsen mit gleichem Masstab verwenden
axis equal;



% Matrixartige Anordnung mehrerer Plots
% Erstellen des dritten Plots
subplot(2,2,3)
% Grafische Darstellung der Spirale
plot(x_b, y_b, '-cs', 'LineWidth', 2);
% Gitterlinien im Hintergrund
grid on;

% Beschriftungen
% Titel für das Diagram - [mehrere Argumente]
title(['Spirale mit Startradius ', num2str(Rin_b), ' m'], 'FontSize', 14);
% X- Achsenbeschriftung
xlabel('X-Achse (Abzisse)'); 
% Y- Achsenbeschriftung
ylabel('Y-Achse (Ordinate)');
% Gitterlinien im Hintergrund
grid on;
% Achsen mit gleichem Masstab verwenden
axis equal;


% Matrixartige Anordnung mehrerer Plots
% Erstellen des vierten Plots
subplot(2,2,4)
% Grafische Darstellung der Spirale
plot(x_3b, y_3b, '-cd', 'LineWidth', 2);
% Gitterlinien im Hintergrund
grid on;

% Beschriftungen
% Titel für das Diagram - [mehrere Argumente]
title(['Inverse Spirale mit Startradius ', num2str(Rin_b), ' m'], 'FontSize', 14);
% X- Achsenbeschriftung
xlabel('X-Achse (Abzisse)'); 
% Y- Achsenbeschriftung
ylabel('Y-Achse (Ordinate)');
% Gitterlinien im Hintergrund
grid on;
% Achsen mit gleichem Masstab verwenden
axis equal;

%eof|ENDE