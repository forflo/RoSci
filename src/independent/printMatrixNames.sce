// Datei: printMatrixNames
//
// Funktion:
// Scilab-Hilfsfunktion zur Augabe einer Matrix mit den Knotennamen.
// Die Matrix darf quadratisch sein oder nur eine einzige Zeile haben 
// (Zeilenvektor)
// Eingabe:
// Knotennamen (String-Zeilenvektor!) und (quadratische) Übergangsmatrix  
// (float) wie aus der Funktion transitionMatrix oder Zeilenvektor
// Ausgabe: Anzeige der Matrix oder des Vektorsin String-Form
//
// Anwendung in Scilab:
// M = rosci_print_matrix_names(Übergangsmatrix, Knotennamen);
//
// Autor: L. Frank
// Datum: 12.3.15
// Status: Prototyp. Es fehlen die Konsistenzprüfungen
// 
// Version 2
// Datum: 13.4.15
// Konsistenzprüfungen 
//

//
// Summary:
// Scilab helper function that can be used to print the transition matrix
// of a markov chain in a readable fashion.
//
// Arguments:
// The transition matrix and a string line vector. The matrix must be
// quadratic and of type float.
//
// Application:
// M = rosci_print_matrix_names(transition_matrix, nodenames)
//
// Autor: L. Frank
// Editor: F. Mayer
// Date: 12.3.15
//

function NM = rosci_print_matrix_names(Matrix, names)
    [s1, s2] = size(Matrix)
    [sn1, sn2] = size(names)
    if (sn1 <> 1) then
        error("Der Namensvektor muss ein Zeilenvektor sein!")
    end
    if (s2 <> sn2) then
        error("Anzahl Spalten von Matrix und Namensvektor sind nicht gleich!")
    end
    if ((s1 <> s2) & (s1 > 1)) then
        error("Bitte geben Sie eine quadratische Matrix an!")
    end

    NM(1, 1) = ""

    for i = 1:s2
        NM(1, i + 1) = names(i)
    end

    for i = 1:s1
        if (s1 <> 1) then 
            NM(i + 1, 1) = names(i) 
        end
        for j = 1:s2
            NM(i + 1, j + 1) = string(Matrix(i, j))
        end
    end
 endfunction
