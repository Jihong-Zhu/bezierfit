clear all
load('contourdata.dat')
d = contourdata(1:443, :); 
%% Process the data
% find the maximum distance between the data points
r = 0;  % initialize the distance
for i = 2 : length(d)
    temp = norm(d(i,:) - d(i-1,:));
    if temp > r
        r = temp;
    end
end
sampleDis = 30;
if sampleDis < r
    error('sample distance is too small');
end
processedData = [d(1,:)];
i = 1;      % initialize the counter
while (i < length(d))
    for j = i : length(d)
        if (norm(d(j, :) - processedData(end,:)) > sampleDis)
            processedData = [processedData; d(j, :)];
            i = j;
            break
        end
    end
    if (j == length(d))
        break;
    end
end
% add the end data
if processedData(end,:) ~= d(end,:)
    processedData = [processedData; d(end, :)];
end
% Plot the data
scatter(processedData(:,1), processedData(:,2));
%%
[p,t] = grad7(processedData, 3, -5);