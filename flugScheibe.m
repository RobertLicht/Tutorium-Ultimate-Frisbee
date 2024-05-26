function flugScheibe(caKoeff, cwKoeff)
%% IWSW Tutorium
%
% Technische Universität Clausthal
%
% Vorlesung: Ingenieurwissenschaftliche Software-Werkzeuge (IWSW)
%
%
% Uebung 4.2: Erstellen und Aufrufen von Funktionen
%
% Beschreibung:
% Script mit Anweisungen zur Bearbeitung der Uebung 4.2
% Diese Script-Funktion führt Berechnungen zum Flug einer Ultimate-Scheibe
% aus und stellt die Ergebnisse in Grafiken dar.
% Vereinfachend wird die Scheibe als Punktmasse angesehen. 
% Zudem besteht die Annahme, dass der Abwurfwinkel über den 
% gesamten Flug beibehalten wird.
%
%......................................................................
% Änderungslog
%
% 10/04/2017    Lichterfeld, Robert-Vincent
%               Erstellen: Aufgabe 4.2
%
% 15/06/2017  Lichterfeld, Robert-Vincent 
%             Überarbeiten: Prüfung der Nutzereingaben

%% Aufräumen
% Ausgewähltes figure schließen
try
    % Aktive figures ermitteln
    aktveFig =  findobj('Type','figure');
    % Nur figures größer 20 schließen
    if (max(aktveFig)) > 20
        % Versuchen figure(22) zu schließen
        close (max(aktveFig));
    else
        % keine Aktion
    end
catch ME
    disp(ME);
end

%% Basiswerte zur Scheibe initialisiern
% Masse der Scheibe                         [kg]
mS = 0.175;
% Durchmesser der Scheibe                   [m]
dS = 0.275;
% Luftdichte bei 15 [°C] und 950 [hPa]      [kg/(m^3)]
rohLuft = 1.144;
% Erd-Gravitationsbeschleunigung            [m/(s^2)]
g = 9.81;
% Abwurfhöhe                                [m]
hW = 1;
% % Abwurfgeschwindigkeit                   [m/s]
% vW = 5;
% Zeitschritt                               [s]
dt = (1/500);

%   Berechnung weiterer Größen
% Fläche der Scheibe
flA = pi * (dS^2)/4;
% Zeitvektor
t = dt : dt : 5;

% %dbg
% caKoeff = [-0.000000004544, 0.000000152659, 0.000000990731,...
%     -0.000079411104, 0.000562234592, 0.038596639573, 0.118287597976];
% 
% cwKoeff = [-0.000000004544, 0.000000152659, 0.000000990731,...
%     -0.000079411104, 0.000562234592, 0.038596639573, 0.118287597976];


%   Prüfen der Parameter
% Vektor der Auftriebsbeiwerte prüfen
if (length(caKoeff)) == 7
    % keine Aktion
else
    msgGrdCa = 'Der Vektor zu ca muss genau 7 Einträge enthalten! (grdCa=6)';
    error(msgGrdCa);
end
% Vektor der Widerstandsbeiwerte prüfen
if (length(cwKoeff)) == 7
    % keine Aktion
else
    msgGrdCw = 'Der Vektor zu cw muss genau 7 Einträge enthalten! (grdCw=6)';
    error(msgGrdCw);
end

%   Initialisierung weiterer Werte
%--------- Polynomfunktionen ------------------------------------

% Polynomfunktion zu Ca - Scheibe
fpolyCa = @(x) (caKoeff(1,1)*(x^6) + caKoeff(1,2)*(x^5) + ...
    caKoeff(1,3)*(x^4) + caKoeff(1,4)*(x^3) + caKoeff(1,5)*(x^2) + ...
    caKoeff(1,6)*(x^1) + caKoeff(1,7)*(x^0));


% Polynomfunktion zu Cw - Scheibe
fpolyCw = @(x) (cwKoeff(1,1)*(x^6) + cwKoeff(1,2)*(x^5) + ...
    cwKoeff(1,3)*(x^4) + cwKoeff(1,4)*(x^3) + cwKoeff(1,5)*(x^2) + ...
    cwKoeff(1,6)*(x^1) + cwKoeff(1,7)*(x^0));


%% Abfrage des Abwurfwinkels und Abwurfgeschwindigkeit
%   Abwurfgeschwindigkeit                    [m/s]
%vW = input('Abwurfgeschwindigkeit eingeben (5 | 7) in [m/s]: ');
vW = str2double(inputdlg ('Abwurfgeschwindigkeit eingeben (5 | 7) in [m/s]:', 'Eingabe zur Berechnung'));
% Prüfen der Eingabe durch Funktionsaufruf
[vW] = eingabePRUEFvW(vW);

%   Abwurfwinkel                              [deg]
%aoaW = input('Abwurfwinkel eingeben ([-5, 45]) in [deg]: ');
aoaW = str2double(inputdlg ('Abwurfwinkel eingeben ([-5, 45]) in [deg]:', 'Eingabe zur Berechnung'));
% Prüfen der Eingabe durch Funktionsaufruf
[aoaW] = eingabePRUEFaoaW(aoaW);

%   Schlupfwinkel !GESCHÄTZT!                 [deg]
aoaS = (1/(vW*10+0.01))*(aoaW^2);
% aoaS = log(aoaW^2);


%% Berechnungen zum Flug der Scheibe
%   Beiwerte berechnen
% Auftriebsbeiwert
ca = fpolyCa(aoaS);
% Widerstandsbeiwert
cw = fpolyCw(aoaS);

% % Speicherplatz reservieren
% hs = zeros((length(t)), 1);
% vs = zeros((length(t)), 1);

%   -> Initialberechnungen <-
%   Kräfte an der Scheibe
% Gewichtskraft
gF = mS * g;
% Auftriebskraft
aF = (0.5 * ca * rohLuft * (vW^2) * flA) - (gF * cosd(aoaS));
% aF = (0.5 * ca * rohLuft * (vW^2) * flA);
% Widerstandskraft
wF = (0.5 * cw * rohLuft * (vW^2) * flA) + (gF * sind(aoaS));
% wF = (0.5 * cw * rohLuft * (vW^2) * flA);
% Kraft aus Impulsformel (m*v = F*t)                [N]
impF = (mS*(vW-vW))/dt;

% Tangentialkraft
tF = ((wF*cosd(aoaS)) - (aF*sind(aoaS)) - (impF*cosd(aoaW-aoaS)));
% Tangentialbeschleunigung (entgegen Flugrichtung)  [m/(s^2)]
ta = tF/mS;
% Tangentialgeschwindigkeit in Flugrichtung         [m/s]
tv = -(ta * dt) + (vW*cosd(aoaW));
% Tangentialstrecke in Wurfrichtung                 [m]
ts = (tv * (dt)) + 0;

% Normalkraft
nF = (aF*cosd(aoaS)) + (wF*sind(aoaS) + (impF*sind(aoaW-aoaS)));
% Normalbeschleunigung                                  [m/(s^2)]
na = nF/mS;
% Normalgeschwindigkeit (Vorzeichen?)                   [m/s]
nv = (na * dt) + (vW*sind(aoaW));
% Normalstrecke                                         [m]
ns = (nv * (dt)) + hW;

%   Werte der Strecken sammeln
% Horizontalstrecke                                     [m]
hs(1, 1) = (ts*cosd(aoaW-aoaS) + ns*sind(aoaW-aoaS));
% Vertivalstrecke                                       [m]
vs(1, 1) = (ts*sind(aoaW-aoaS) + ns*cosd(aoaW-aoaS));

% Werte aus vorangegangenem Schritt
tvALT = tv; tsALT = ts;
nvALT = nv; nsALT = ns;
vALT = sqrt((tv)^2 + (nv)^2);

% Berechnung der weiteren Werte durch eine for-Schleife
for ti = 2:(length(t))    
    %   Kräfte an der Scheibe
    % Auftriebskraft
    aF = (0.5 * ca * rohLuft * (vALT^2) * flA) - (gF * cosd(aoaS));
%     aF = (0.5 * ca * rohLuft * (vALT^2) * flA);
    % Widerstandskraft
    wF = (0.5 * cw * rohLuft * (vALT^2) * flA) + (gF * sind(aoaS));
%     wF = (0.5 * cw * rohLuft * (vALT^2) * flA);
    % Kraft aus Impulsformel (m*v = F*t)                [N]
    impF = (mS*(vW-vALT))/t(ti);
    
    % Tangentialkraft
    tF = ((wF*cosd(aoaS)) - (aF*sind(aoaS)) - (impF*cosd(aoaW-aoaS)));
    % Tangentialbeschleunigung (entgegen Flugrichtung)  [m/(s^2)]
    ta = tF/mS;
    % Tangentialgeschwindigkeit in Flugrichtung         [m/s]
    tv = -(ta * dt) + tvALT;
    % Tangentialstrecke in Wurfrichtung                 [m]
    ts = (tv * (dt)) + tsALT;
    
    % Normalkraft
    nF = (aF*cosd(aoaS)) + (wF*sind(aoaS) + (impF*sind(aoaW-aoaS)));
    % Normalbeschleunigung                                  [m/(s^2)]
    na = nF/mS;
    % Normalgeschwindigkeit (Vorzeichen?)                   [m/s]
    nv = (na * dt) + nvALT;
    % Normalstrecke                                         [m]
    ns = (nv * (dt)) + nsALT;
    % Vertikalgeschwindigkeit                               [m/s]
    vv(ti, 1) = (tv*sind(aoaW-aoaS) + nv*cosd(aoaW-aoaS));
    
    %   Werte sammeln
    % Horizontalstrecke                                     [m]
    hs(ti, 1) = (ts*cosd(aoaW-aoaS) + ns*sind(aoaW-aoaS));
    % Vertivalstrecke                                       [m]
    vs(ti, 1) = (ts*sind(aoaW-aoaS) + ns*cosd(aoaW-aoaS));
    % Horizontalgeschwindigkeit                             [m/s]
    hv(ti, 1) = (tv*cosd(aoaW-aoaS) + nv*sind(aoaW-aoaS));
    %   Gschwindigkeit                                        [m/s]
    % vDisc(ti, 1) = sqrt(tv^2 + nv^2);
    % vDisc(ti, 1) = norm([vv(ti), hv(ti)]);
    % Fluggeschwindigkeit                                   [km/h]
    vDisckmh(ti, 1) = 3.6 * (norm([vv(ti), hv(ti)]));
    
    % Werte aus vorangegangenem Schritt
    tvALT = tv; tsALT = ts;
    nvALT = nv; nsALT = ns;
    vALT = sqrt((tv^2) + (nv)^2);
    
    % Abbruchkriterium und Iterationswert speichern
    if vs(ti, 1) <= 0; ibreak = ti; break;  end;
    
end%for ti

% Iterationswert speichern
if (ti == length(t)); ibreak = ti; end;


%% Darstellung
fgDisc = figure(22); 
% Eigenschaften zum handle antragen, durch den Befehl set(...)
set(fgDisc,'Name','Übung 4.2 Flugsimulation-Scheibe','NumberTitle','on');
% relative Angabe [left bottom width height]
set(fgDisc,'Units','normalized','Position',[0.12 0.22 0.62 0.6]);

% Grafische Darstellung der Flughöhe über die Strecke
ax = axes;
set(ax,"xlim",[-5 20],"ylim",[0 10]);
hold (ax);
comet(ax, hs, vs, 1E-2);

% Derzeitiges figure leeren
clf;

% relative Angabe [left bottom width height]
set(fgDisc,'Units','normalized','Position',[0.12 0.22 0.62 0.6]);

% % Derzeitige Grafik im figure behalten
% hold on;
% Grafische Darstellung der Flughöhe über die Strecke
% plot(hs, vs, 'bo', hs, vDisc, 'gs', hs,hv,'dr', hs,vv,'*c', 'MarkerSize', 4);
%   Fluggeschwindigkeit auf eigener Achse
% % [AX,H1,H2] = plotyy(hs,vs,hs,vDisckmh);


%   Matrixartige Anordnung mehrerer Plots
% Erstellen des ersten Plots
subplot(2,1,1)
% Grafische Darstellung des Kreises
plot(hs, vs, 'bo', 'MarkerSize', 4);
% Gitterlinien im Hintergrund
grid on;

%   Beschriftungen
% Titel für das Diagram
title('Flug der Scheibe', 'FontSize', 16);
% X-Achsenbeschriftung
xlabel('Flugstrecke in [m]', 'FontSize', 12); 
% Y-Achsenbeschriftung
ylabel('Flughöhe [m]', 'FontSize', 14);



%   Matrixartige Anordnung mehrerer Plots
% Erstellen des zweiten Plots
subplot(2,1,2)
% Grafische Darstellung des Kreises
plot(hs, vDisckmh, 'gs', 'MarkerSize', 4);
% Gitterlinien im Hintergrund
grid on;

%   Beschriftungen
% Titel für das Diagram
title('Fluggeschwindigkeit der Scheibe', 'FontSize', 16);
% X-Achsenbeschriftung
xlabel('Flugstrecke in [m]', 'FontSize', 12); 
% Y-Achsenbeschriftung
ylabel('Fluggeschwindigkeit [km/h]', 'FontSize', 14);



% % Beschriftung plotyy
% set(get(AX(1),'Ylabel'),'String','Flughöhe [m]', 'FontSize', 14);
% set(AX(1),'YTick',0:0.5:8);
% set(get(AX(2),'Ylabel'),'String','Fluggeschwindigkeit [km/h]', 'FontSize', 14);
% set(AX(2),'YTick',0:5:30);
% set(H1,'LineStyle', 'none');
% set(H1, 'Marker', '.', 'MarkerSize', 6);
% set(H2,'LineStyle', 'none');
% set(H2, 'Marker', '.', 'MarkerSize', 6);

% % Gitterlinien im Hintergrund
% grid on;
% % Achsen mit gleichem Masstab verwenden
% axis equal;

% % Legende auf handle referenzieren
% % hlg01 = legend('Höhe [m]', 'Horizontalgeschwindigkeit [m/s]', 'hv', 'vv');
% hlg01 = legend('Höhe [m]', 'Fluggeschwindigkeit [km/h]');
% 
% % Einstellungen zum handle Legende
% set(hlg01,'FontSize', 10, 'Location', 'SouthOutside',...
%     'Orientation', 'horizontal');

%% Informationen im Command Window
%   Information über Maximalwerte
% Maximale Flughöhe                         [m]
maxh = max(vs);
%fprintf('\nMaximale Flughöhe:%.2f [m]\n', maxh);
% Maximale Flugweite                        [m]
maxs = max(hs);
%fprintf('\nMaximale Flugweite:%.2f [m]\n', maxs);
% Maximale Flugzeit                         [s]
tFlug = ibreak * dt;
%fprintf('\nMaximale Flugzeit:%.1f [s]\n', tFlug);

fprnt1 = sprintf('\nMaximale Flughoehe: %.2f [m]\nMaximale Flugweite: %.2f [m]\nMaximale Flugzeit: %.1f [s]', ...
                  maxh, maxs, tFlug);

msg1 = msgbox(fprnt1, 'Berechnungsergebnis', "help");

%% Definition der Funktionen

% Funktion zur Püfung der Eingabe zur Abwurfgeschwindigkeit
    function [vW] = eingabePRUEFvW(vW)
        %   Eingabefehler(leer) abfangen
        while isempty(vW);
            vW = 5;
            % Info an Benutzer
            fprintf('Fehler!\nKorrektur durch Programm:');
            fprintf('\n Abwurfgeschwindigkeit = %1.0f [m/s]\n', vW);
        end
        %   Eingabefehler(vW == 5 oder 7) abfangen
        while vW == (5 || 7);
            vW = 5;
            % Info an Benutzer
            fprintf('Fehler!\nKorrektur durch Programm:');
            fprintf('\n Abwurfgeschwindigkeit = %1.0f [m/s]\n', vW);
        end
        
    end


% Funktion zur Püfung der Eingabe zum Abwurfwinkel
    function [aoaW] = eingabePRUEFaoaW(aoaW)
        %   Eingabefehler(leer) abfangen
        while isempty(aoaW);
            aoaW = 20;
            % Info an Benutzer
            fprintf('Fehler!\nKorrektur durch Programm:');
            fprintf('\n Abwurfwinkel = %1.0f [deg]\n', aoaW);
        end
        %   Eingabefehler(aoaW < -5 ) abfangen
        while aoaW < -5;
            aoaW = -5;
            % Info an Benutzer
            fprintf('Fehler!\nKorrektur durch Programm:');
            fprintf('\n Abwurfwinkel = %1.0f [deg]\n', aoaW);
        end
        
        %   Eingabefehler(aoaW > 45) abfangen
        while aoaW > 45;
            aoaW = 45;
            % Info an Benutzer
            fprintf('Fehler!\nKorrektur durch Programm:');
            fprintf('\n Abwurfwinkel = %1.0f [deg]\n', aoaW);
        end
        
    end
%% Programmende
end

%% eof|ENDE