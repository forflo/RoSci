function matrix = transition_matrix(string)
    file = string;
    str = "";
    
    fid = popen(cstrcat("cat ", file ," | gvpr 'BEG_G { \
            node_t new_nodes[]; \
            int cnt = 0; \
            int num_nodes = nNodes($); \
        } \
         \
        N { new_nodes[cnt++] = $; } \
         \
        END_G { \
            int i, j; \
            node_t head_node, tail_node; \
            edge_t e1;  \
            for(i = 0; i < num_nodes; i++){ \
                head_node = new_nodes[i]; \
                for (j = 0; j < num_nodes; j++){ \
                    tail_node = new_nodes[j]; \
                    if (NULL == isEdge(tail_node, head_node, \"\")) { \
                        e1 = edge(tail_node, head_node, \"\"); \
                        e1.label = \"0.0\"; \
                    } \
                } \
            }    \
         \
            write($); \
        }' | gvpr ' BEGIN { int cnt = 0; } \
          BEG_G { printf(\"MAT%d = [\\n\", cnt); } \
          N { printf(\"\\n\"); } \
          E { printf(\"%s, \", label); } \
          END_G { printf(\"];\\n\"); cnt++;  \
        }'"), "r");
    
    while (ischar (s = fgets (fid))) 
        str = cstrcat(str, s);
    endwhile 

    eval(str);
    matrix = MAT0;
endfunction
