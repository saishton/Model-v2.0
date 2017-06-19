function [] = modelv2(runtime,probM)

cut = 20;
nodes = size(probM,1);
linkprobmatrix = probM;

initialoff = zeros(nodes); %SET INITIAL STATE HERE

ondurationpara1 = lognrnd(3.2434,sigma_for_mu_and_mean(30.552,3.2434),nodes);

times = struct();
for i=1:nodes-1
    for j=i+1:nodes
        ID_ref = sprintf('n%d_n%d',i,j);
        if initialoff(i,j)>0
            times.(ID_ref) = [0,initialoff(i,j)];
        else
            times.(ID_ref) = [];
        end
    end
end

currenttime = lognrnd(5.6901e-04,1.7957); %SET DISTRIBUTION FOR INTEREVENTS HERE
while currenttime<runtime
    accept = 0;
    while accept == 0
        [ri,rj] = chooselink(linkprobmatrix);
        ID_ref = sprintf('n%d_n%d',ri,rj);
        vec = times.(ID_ref);
        if isempty(vec)||currenttime>vec(end)
            accept = 1;
            ontime = currenttime;
            offtime = currenttime+exprnd(ondurationpara1(ri,rj));
            vec = [vec,ontime,offtime];
            times.(ID_ref) = vec;
        end
    end
    currenttime = currenttime+lognrnd(5.6901e-04,1.7957); %SET DISTRIBUTION FOR INTEREVENTS HERE
end
sampleCSV(times,nodes,runtime,cut);
end