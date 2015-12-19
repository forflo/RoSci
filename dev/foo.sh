echo 'digraph markov {
    a -> b [label = 0.7];
    a -> a [label = 0.3];
    b -> a [label = 0.8];
    b -> b [label = 0.2];
}' | gvpr '
    BEGIN { int cnt = 0; }
    BEG_G { printf("MAT%d = [\n", cnt); }
    N { printf("\n"); }
    E { printf("%s, ", label); }
    END_G { printf("]\n"); cnt++; }
'
