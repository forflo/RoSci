// Datei: visitCounts.sce
// Funktion:
// Scilab-Hilfsfunktion zur Bestimmung der Besuchshäufigkeiten eines absorbierenden  
// markovschen Übergangsmatrix
//
// Voraussetzung: 
// Die Übergangsmatrix und ggfs. die Namen der Zustände müssen bereits 
// mittels der Funktion "transition Matrix" erzeugt worden sein.
//
// Anwendung:
// 1. Form (nur ein einziges Funktionsargument, Float-Matrix)
// V=visitCounts(Übergangsmatrix);
// Es werden alle Besuchshäufigkeiten für alle Startzustände ausgegeben
// (komplette Matrix). 
//
// 2. Form (mit optionalem 2. Funktionsargument)
// V=absorbingTime(Übergangsmatrix, Knotennamen, Startzustand)
// Es werden nur die Besuchshäufigkeiten für den angegebenen Startzustand ausgegeben.
// In diesem Fall kann der Vektor der Besuchszähler mittels
// printMatrixNames(V, nichtabsorbierendeNamen)
// anschaulich ausgegeben werden. Dabei ist "nichtabsorbierendeNamen" ein 
// Rückgabewert der Funktion "absorbingTime".
//
// Autor: L. Frank
// Version 1
// Datum: 27.4.15
// Status: Prototyp, Fehlerbehandlung nur rudimentär
//

//
// Summary: 
// Scilab helper function that outputs the visit counts of an
// absorbing markov chain.
//
// Arguments:
// The transition matrix and the names of the
// states of the markov chain.
//
// Application:
// 1. Option (Only one argument, namely a matrix of floats)
// V = visitCounts(transitionMatrix)
// 2. Option (additional second argument)
//    Only the visit counts for the given state will be put out.
// V = visitCounts(transitionMatrix, node_names, start_state)
// 
// Author: L. Frank
// Datum: 27.4.15
// 

function [V] = visitCounts(P, Namen, startName)
    d = diag(P)               // Diagonale von P
    if (size(P, 1) <> size(P, 2))
        error("Bitte übergeben Sie eine quadratische Matrix!")
    end 

    nonabs = find(d<1)        // finde alle nichtabsorbierenden Zustände (Diag !=1)
    na = size(nonabs, 2)       // Anzahl nichtabsorbierender Zustände
    if (na == size(P, 1)) then
        error("Es gibt keine absorbierenden Zustände!")
    end

    P = P(nonabs, nonabs)      // lösche alle Zeilen und Spalten mit den Einsen in der Diagonale
    V = inv(eye() - P)          // Matrixinversion
    [lhs, rhs] = argn(0)       // Anzahl Argumente

    if (rhs == 3) then        // Zwei aufrufargumente
        start = find(Namen == startName)
        if (size(start, 2) == 0) then
            warning("Kein korrekter Startzustand!")
        else 
            V = V(start, :)
        end
    end
endfunction
