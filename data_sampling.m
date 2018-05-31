% Sampling the data from the the contour (from the full contour data)
load('contourdata2.dat')
d = contourdata2;
figure;
scatter(d(:,1), d(:,2));
r = 1;
sampledata = d(1, :);
counter = 0;
for i = 1 : length(d)
    dis = norm(d(i,:) - sampledata(end, :));
    if dis > r
        flag = 0;
        for j = 1 : size(sampledata, 1)
            dis2 = norm(d(i,:) - sampledata(j, :));
            if dis2 < r
                flag = 1;
                counter = counter + 1;
                break;
            end
        end
        if flag == 0
            sampledata = [sampledata ; d(i,:)];
        end
    end
    if counter > 4
        break;
    end
end
figure(2)
plot(sampledata(:,1), sampledata(:,2))
    