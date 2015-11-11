// Datei: absorbingTime.sce
//
// Funktion:
// Scilab-Hilfsfunktion zur Bestimmung der Absorptionszeiten einer markovschen 
// Übergangsmatrix, und der Knotennamen, die den nichtabsorbierenden Zuständen 
// entsprechen.
//
// Voraussetzung: 
// Die Übergangsmatrix und ggfs. die Namen der Zustände müssen bereits 
// mittels der Funktion "transition Matrix" erzeugt worden sein.
//
// Anwendung:
// 1. Form (nur ein einziges Funktionsargument, Float-Matrix)
// A = rosci_absorbing_time(Übergangsmatrix);
// 2. Form (mit optionalem 2. Funktionsargument)
// [A, nichtabsNamen] = rosci_absorbing_time(Übergangsmatrix, Knotennamen)
// In diesem Fall kann der transponierte Absorptionsvektor mittels
// printMatrixNames(A', nichtabsNamen)
// anschaulich ausgegeben werden.
//
// Autor: L. Frank
// Version 1
// Datum: 27.4.15
// Status: Prototyp, Fehlerbehandlung nur rudimentär
//

//
// Summary:
// This is a helper function that can be used to calculate the
// absorbtion time of a markov chain and the nodes that represent
// non-absorbing states of the chain.
//
// Arguments:
// The transition matrix (P) and, if applicable, the names of the states (Names)
//
// Application:
// 1. Option (only one argument, namely a float matrix)
// A = rosci_absorbing_time(transition_matrix)
// 2. Option (two arguments, namely the transition matrix (float) and
//    a vector storing the node names)
// [A, non_absorbing_names] = rosci_absorbing_time(transition_matrix, nodenames)
// -----
// In the latter case, the transposed absorbition vector can be
// displayed by the function printMatrixNames in a more readable fashion.
//
// Author: L. Frank
// Date: 27.4.15
// Status: Prototype, only rudimentary error treatment
//

function [A, nonabsNames] = rosci_absorbing_time(P, Names)
    d = diag(P)                // Diagonale von P
    if (size(P, 1) <> size(P, 2))
        error("Bitte übergeben Sie eine quadratische Matrix!")
    end    

    nonabs = find(d<1)         // finde alle nichtabsorbierenden Zustände (Diag !=1)
    na = size(nonabs, 2)       // Anzahl nichtabsorbierender Zustände
    if (na == size(P, 1)) then
        error("Es gibt keine absorbierenden Zustände!")
    end

    P = P(nonabs, nonabs)      // lösche alle Zeilen und Spalten mit den Einsen in der Diagonale
    rs = ones(na, 1)
    A = (eye() - P) \ rs
    [lhs, rhs] = argn(0)       // Anzahl Argumente

    if (rhs == 2 & lhs == 2) then
        nonabsNames = Names(nonabs)
    end
endfunction
