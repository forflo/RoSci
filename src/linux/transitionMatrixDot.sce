//
// Summary:
// Scilab helper function that be used to convert a given
// dot file into a transition matrix for a markov chain.
//
// Notes:
// The dot file must have the following format:
// digraph foobar {
//     node_a -> node_b [label="0.2"];
//     ...
// }
// 
// Application:
// P = rosci_transition_matrix_dot(file_name)
//
// Author: Florian Mayer
// Datum: 27.08.15
//

rosci_gvpr_convert = "cat " + path + ' | gvpr ''BEG_G { ..
    node_t new_nodes[]; ..
    int cnt = 0; ..
    int num_nodes = nNodes($); ..
    } ..
      ..
    N { new_nodes[cnt++] = $; } ..
      ..
    END_G { ..
        int i, j; ..
        node_t head_node, tail_node; ..
        edge_t e1;  ..
        for(i = 0; i < num_nodes; i++){ ..
            head_node = new_nodes[i]; ..
            for (j = 0; j < num_nodes; j++){ ..
                tail_node = new_nodes[j]; ..
                if (NULL == isEdge(tail_node, head_node, """")) { ..
                    e1 = edge(tail_node, head_node, """"); ..
                    e1.label = ""0.0""; ..
                } ..
            } ..
        }    ..
        write($); ..
    }'' | gvpr '' BEGIN { int cnt = 0; } ..
    BEG_G { printf(""MAT%d = [\n"", cnt); } ..
    N { printf(""\n""); } ..
    E { printf(""%s, "", label); } ..
    END_G { printf(""];\n""); cnt++; }''";

function t_matrix = rosci_transition_matrix_dot(path)
    // unix_g führt den übergebenen String als
    // unix-Kommando aus.
    // gvpr ist ein Tool aus der Graphviz-Suite
    // und ist sehr gut in der zugehörigen Manpage dokumentiert.
    // Insgesamt werden 3 Prozesse gestartet
    //   1) cat <file> 
    //   2) gvpr 'gvpr-Programm zur Graphnormalisierung'
    //   3) gvpr 'gvpr-Programm zur Konvertierung eines Graphen
    //              in gültigen Scilab-Code
    // Der erste Prozess führt den Graphen-Code (in dot)
    // der Pipeline initial hinzu. Im zweiten Prozess ergänzt
    // gvpr den Graphen um die notwenigen Null-Übergänge und
    // zuletzt generiert der dritte Prozess vollwertigen Scilab-
    // Code, der nun innerhalb des Funktionskontextes ausgeführt
    // werden kann.
    [res, a, b] = unix_g(rosci_gvpr_convert);
    
    // Scilab-Code für die Erzeugung einer Adjazenzmatrix wird
    // im aktuellen Funktionskontext ausgeführt und das Ergebnis
    // der Ergebnisvariable übergeben. Die implizig entstandene
    // temporäre Variable "MAT0" existiert nach Beendigung der
    // Funktion nicht mehr!
    execstr(res);
    t_matrix = MAT0;
endfunction
