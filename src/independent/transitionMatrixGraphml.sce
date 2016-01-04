// Datei: transitionMatrix.sce
// Funktion:
// Scilab-Hilfsfunktion zum Einlesen einer markovschen Übergangsmatrix
// und der Knotennamen des Übergangsgraphen.
// Erzeuge Übergangsmatrix aus einer XML-Datei (graphml-Format), die mit
// yed erzeugt wurde und einen Markov-Übergangsgraphen beschreibt.
//
// Anwendung:
// In Scilab in das Verzeichnis mit der graphml-Datei wechseln.
// (cd, pwd, ls gibts auch in Scilab)
//
// Anwendung in Scilab:
// exec("Pfad/transitionMatrix.sce") Dies kann auch in der Datei ".scilab"
// im Startup-Verzeichnis stehen. Das Startup-Verzeichnis ist in der
// Standardvariablen SCIHOME verankert und ist in der aktuellen Version
// C:\Users\Benutzername\AppData\Roaming\Scilab\scilab-5.4.1
//
// Aufruf in Scilab:
// 1. Form (nur ein einziges Funktionsargument, Float-Matrix)
// [P, Namen] = rosci_transition_matrix("Name der modifizierten graphml-Datei");
// oder 
// rosci_transition_matrix("Name der modifizierten graphml-Datei") (liefert nur die Matrix)
// oder 
// P = rosci_transition_matrix("Name der modifizierten graphml-Datei");
//
// 2. Form (mit optionalem 2. Argument, String-Matrix)
// [P, Namen] = rosci_transition_matrix("Name der modifizierten graphml-Datei", "str");
// oder mit den Varianten oben. Die String-Matrix muss zur weiteren Rechnung 
// mit P_Float=evstr(P_String) umgewandelt werden
//
// Autor: L. Frank
// Datum: 11.3.15
// Status: Prototyp, Fehlerbehandlung fehlt
// Korrekturen: 14.3.15
//
// Version 2
// Konsistenzprüfung: "Mehr Knotennamen als Knoten" eingefügt
// Funktionserweiterung: Alternative Ausgabe der String-Matrix
// Datum: 11.4.15

//
// Summary:
// Scilab helper function that reads in a graphml file and
// outputs a markov chain transition matrix and an additional
// vector containing the node names of the states described
// by the markov chain.
//
// Arguments:
// 1. Option (Only one argument: a file name)
//    In this case, the function only outputs the matrix with members of type float
// 2. Option (Two arguments, the first being the same as in (1), the second being "str")
//    In this case, the function only outputs the matrix with members of type _string_
//    which means that a user has to run evstr(matrix) on the resulting matrix to get
//    a usable double matrix.
//
// Application:
// 1)
// [transitionmatrix, nodenames] = rosci_transition_matrix(graphml_file)
// 2)
// [transitionmatrix, nodenames] = rosci_transition_matrix(graphml_file, string)
//
// Author: L. Frank
// Date: 11.3.15
// 

rosci_toreplace = "xmlns=""http://graphml.graphdrawing.org/xmlns""";

function [P, names] = rosci_transition_matrix(graphml_Datei, string)
	info = fileinfo(graphml_Datei);
	fd = mopen(graphml_Datei);
    graphml_string = mgetstr(info(1), fd);
	graphml_string = strsubst(graphml_string, rosci_toreplace, "");
    doc = xmlReadStr(graphml_string); //* Scilab-Objekt erzeugen
    
    // Alle Knotennamen extrahieren, Namensraum beachten
    nodenames = xmlXPath(doc, "//y:NodeLabel", ["y", "http://www.yworks.com/xml/graphml"])
    for i = 1:nodenames.size
        nodenam(i) = nodenames(i).children(1).content;
    end
    
    // Konsistenzprüfung: Wenn Knoten mit mehreren Namen auftreten, 
    // ist keine vollständige Weiterarbeit möglich.
    nodes = xmlXPath(doc, "//node")
    if (nodenames.size > nodes.size) then
        errorNode = xmlXPath(doc, ..
            "//node[count(data/y:ShapeNode/y:NodeLabel)>1]", ..
            ["y","http://www.yworks.com/xml/graphml"])
        printf("In den Knoten\n")
        for j = 1:errorNode.size
             printf("%s\n",errorNode.content(j))
             printf("-------------\n")
        end
        error("Mehr als ein Knotenname. In graphml-Datei geeignetes Element y:NodeLabel entfernen!")
    end
    
    // Alle Knoten-Ids extrahieren für die Identifizierung der Kanten
    nodeids = xmlXPath(doc, "//node")
    for i = 1:nodeids.size
        nodeid(i) = nodeids(i).attributes.id;
    end
    
    // Alle Knotenbewertungen extrahieren, Namensraum beachten
    edgelabels = xmlXPath(doc, "//y:EdgeLabel", ["y","http://www.yworks.com/xml/graphml"])
    for i=1:edgelabels.size
        edgelab(i)=edgelabels(i).content(1,1)
    end
    
    // Alle Kanten extrahieren, die Bewertungen haben
    // Anfangs- und Endpunkt in den Attributen source bzw. target
    // Die Hierarchiestufe von y:EdgeLabel wurde experimentell ermittelt. Es gibt dafür
    // in der DTD und Schema-Datei keinen Hinweis.
    edges = xmlXPath(doc, "//edge")
    edges = xmlXPath(doc,"//edge[data/*/y:EdgeLabel]", ["y","http://www.yworks.com/xml/graphml"])
    for i = 1:edges.size
        edgesrc(i) = edges(i).attributes.source;
        edgetgt(i) = edges(i).attributes.target;
    end
    
    // Übergangsmatrix erzeugen
    // Zuerst alle Positionen mit dem String "0.0" vorbelegen
    for i = 1:nodeids.size
        for j = 1:nodeids.size 
          P(i, j) = "0.0" 
        end     
    end
    
    // Die edgelab-Werte sind Strings. In Float umwandeln mit eval(edgelab(i))
    // Gibt es keine Kante, dann ist das Matrixelement automatisch 0.0.
    for i = 1:edgelabels.size         //funktioniert merkwürdigerweise nicht mit edges.size
        von = find(nodeid == edgesrc(i));
        nach = find(nodeid == edgetgt(i));
        //P(von,nach)=eval(edgelab(i));
        P(von, nach) = edgelab(i);
    end
    
    [lhs, rhs] = argn(0)       // Anzahl Argumente
    
    if (rhs == 1)  then       // nur ein Argument übergeben, also nicht die STring-Matrix 
        P = evstr(P)      // Matrix in float umwandeln         
    else                // 2 Argumente
        if (strcmpi(string, "str")) then     // 2. (optionales) Argument "str", dann String-Matrix zurückgeben 
            error("Falsches 2. Argument: Entweder weglassen oder in Anführungszeichen str \n")
        end    
    end
    
    // Knotennamen als Zeilenvektor zurückgeben:
    names = nodenam';
endfunction
