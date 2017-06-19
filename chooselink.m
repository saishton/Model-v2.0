function [startnode,endnode] = chooselink(M)

nodes = size(M,1);

M = M/sum(sum(M));
vecM = reshape(M',1,numel(M));
cumM = cumsum(vecM);

rn = rand(1);

idx = find(cumM>=rn,1);

modrem = mod(idx,nodes);
if modrem == 0
    startnode = idx/nodes;
    endnode = nodes;
else
    startnode = ((idx-modrem)/nodes)+1;
    endnode = modrem;
end

if startnode>endnode
    s = startnode;
    e = endnode;
    startnode = e;
    endnode = s;
end
end