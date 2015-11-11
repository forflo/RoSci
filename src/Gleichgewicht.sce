//
// Datei: Gleichgewicht.sce
// Funktion:
// Scilab-Hilfsfunktion zur Bestimmung der Gleichgewichtslösung einer 
// homogenen Markov-Kette.
// 
// Voraussetzung: 
// Es muss sichergestellt sein, dass eine Gleichgewichtslösung existiert.
// Die Funktion printMatrixNames.sce muss zur Verfügung stehen
//
// Anwendung in Scilab:
// exec("Pfad/Gleichgewicht.sce") Dies kann auch in der Datei ".scilab"
// im Startup-Verzeichnis stehen. Das Startup-Verzeichnis ist in der
// Standardvariablen SCIHOME verankert und ist in der aktuellen Version
// C:\Users\Benutzername\AppData\Roaming\Scilab\scilab-5.4.1
// Aufruf in Scilab:
// pi=rosci_gleichgewicht(Übergangsmatrix);
//
// Autor: L. Frank
// Datum: 16.3.15
//

//
// Summary:
// Scilab helper function that be used to calculate the equilibrium
// solution of a homogenous markov chain.
//
// Notes:
// A exact solution must exist, else the system of equations can
// not exactly be solved by scilab and the function will return nonsense.
// 
// Application:
// pi = rosci_gleichgewicht(transition_matrix)
//
// Author: L. Frank
// Datum: 16.3.15
//

function pi = rosci_gleichgewicht(P)
    PE = eye() - P					// von Einheitsmatrix abziehen
    [s1, s2] = size(P)              // Dimension

    if (s1 <> s2) then              // Matrix muss quadratisch sein
        error("Bitte übergeben Sie eine quadratische Matrix!", 1)
    end

    d = ones(s1, 1)                 // s1x1-Matrix bestehend aus Einsen für Normierungsgleichung
    PE = [eye() - P, d]
    rs = [zeros(1, s1)]             // Rechte Seite, bestehend aus Nullen
    rs = [rs, 1]                    // Rechte Seite um 1 erweitern für Normierungsgleichung

    pi = rs / PE                    // Lösen des Gleichungssystems pi * PE = rs
endfunction
