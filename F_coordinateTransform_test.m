coordinate = [1 0 0; 0 1 0; 0 0 1];
test = xlsread('a.xlsx');
%test = zeros(27, 3);
% temp_count = 1;
%for i = -1 : 1 : 1
%   for j= -1 : 1 : 1
%      for k = -1 : 1 :1
%            test(temp_count, 1) = i;
%           test(temp_count, 2) = j;
%            test(temp_count, 3) = k;
%            temp_count = temp_count + 1;
%        end
%    end
%end
[pitch_t, azimuth_t] = F_coordinateTransform(coordinate, test);
pitch_t = pitch_t * 180/ pi;
azimuth_t = azimuth_t * 180/ pi;