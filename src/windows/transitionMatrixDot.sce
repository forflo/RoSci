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
// Notes: The variables rosci_gvpr_convert and rosci_gvpr_normalization
//    store code for the gvpr tool that ships with any valid graphviz
//	  distribution. This code is embedded in this file only for simplicity.
//	  For a thoroughly commented version of the two code snippets, please
//	  visit RoSci/src/gvpr/normalize.gvpr and RoSci/src/gvpr/convert.gvpr,
//    which corresponds to rosci_gvpr_normalization and rosci_gvpr_convert
//	  respectively.
//

rosci_gvpr_convert = rosci_path_gvpr + " ""BEGIN { int cnt = 0; } ..
    BEG_G { printf(\""MAT%d = [\n\"", cnt); } ..
    N { printf(\""\n\""); } ..
    E { printf(\""%s, \"", label); } ..
    END_G { printf(\""];\n\""); cnt++; }"" " + rosci_tempfile_name;

rosci_gvpr_normalization = rosci_path_gvpr + " ""BEG_G { ..
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
                if (NULL == isEdge(tail_node, head_node, \""\"")) { ..
                    e1 = edge(tail_node, head_node, \""\""); ..
                    e1.label = \""0.0\""; ..
                } ..
            } ..
        }    ..
        write($); ..
    }"" ";

function t_matrix = rosci_transition_dot(path)
	// Gvpr is a tool from the graphviz suite
	// it is very well documented in it's man page.
	// The following trick does the following
    //   1) cat <dot-file> 
    //   2) gvpr 'gvpr program that adds missing 0-edges'
    //   3) gvpr 'gvpr program that converts graph to scilab code'
	//   4) Execution of the resulting scilab code through execstr
	
    [res1, a1, b1] = dos(rosci_gvpr_normalization + path + " > " + rosci_tempfile_name);
    [res2, a2, b2] = dos(rosci_gvpr_convert);
    
	// The scilab code will be executed inside the current functions
	// context. Thus the implicitly created matrix MAT0 won't exist
	// anymore once the function returns.
    execstr(res2);
    t_matrix = MAT0;
	mdelete(rosci_tempfile_name);
endfunction
