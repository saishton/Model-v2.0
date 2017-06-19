function [] = sampleCSV(times,nodes,runtime,sampletime)

timestamp = datestr(now,'yyyymmddTHHMMSS');
dir_ref = ['output_',timestamp];
mkdir(dir_ref);

numint = floor(runtime/sampletime)+1;
timesteps = 0:sampletime:runtime;
massivematrix = [];

for i=1:nodes-1
    for j=i+1:nodes
        ID_ref = sprintf('n%d_n%d', i,j);
        vec = times.(ID_ref);
        
        if ~isempty(vec)
            ontimes = vec(1:2:end);
            offtimes = vec(2:2:end);
            
            thisindicator = zeros(1,numint);
            parfor k=1:numint
                currenttime = (k-1)*sampletime;
                if sum(ontimes<=currenttime & offtimes>=currenttime)
                    thisindicator(k) = 1;
                end
            end
            thistimes = thisindicator.*timesteps;
            thistimes(thistimes==0) = [];
            thistimes = thistimes';
            n = length(thistimes);
            thisc2 = i*ones(n,1);
            thisc3 = j*ones(n,1);
            thisc4 = ones(n,1);
            thisc5 = ones(n,1);
            thisblock = [thistimes,thisc2,thisc3,thisc4,thisc5];
            massivematrix = [massivematrix;thisblock];
        end
    end
end
[~,idx] = sort(massivematrix(:,1));
sortedbytime = massivematrix(idx,:);

filename = 'generated_data.csv';
filepath = [dir_ref,'/',filename];
csvwrite(filepath,sortedbytime)
end