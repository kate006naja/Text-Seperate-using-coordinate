%%
clear all;
close all;
fo = fopen('4.txt', 'r');
raw_text = fscanf(fo, '%c');
list_text = strsplit(raw_text, '\n');

X = [];
Y = [];
Z = [];

for el = list_text
   tmp = char(el);
   if tmp(1) == '('
       strip_left  = strip(el, '(');
       cleaned = strip(strip_left, ')');
       splited = split(cleaned, ', ');
       X(end + 1) = str2double(splited(1));
       Y(end + 1) = str2double(splited(2));
       Z(end + 1) = str2double(splited(3));
   end
end
Y = 1-Y;

% this part is contain data for dbscan(testing)
J(:,1) = X;
J(:,2) = Y;
scatter(J(:,1), J(:,2));
idx = DBSCAN(J,0.03,5); % The default distance metric is Euclidean distance
gscatter(J(:,1), J(:,2), idx);


figure;
subplot(1,2,1); plot(X,Y, '.');
subplot(1,2,2); plot(Y,X, '.');

%% new code

% open text file process
clear all;
close all;

fo = fopen('6.txt', 'r');
raw_text = fscanf(fo, '%c');
list_text = strsplit(raw_text, '\n');

X2 = cell(1);
Y2 = cell(1);
Z2 = cell(1);
segCount = 0;
for el = list_text % el = each line of text file
   tmp = char(el); % make each line a character
   if tmp(1) == 'N'
       if segCount > 0 % count per 1 segment
           % Contain X, Y, Z of each segment
           X2(segCount) = {X}; 
           Y2(segCount) = {Y};
           Z2(segCount) = {Z};
           % finish these it mean X2 x of all segment at cell 
           % by 344 column and each column contain each segment
           % and each segment contain their own variable(x or y or z)
       end
       segCount = segCount+1;
       X = []; % to discard old variable
       Y = [];
       Z = [];
   end
   
   % this are step of data cleaning (strip and split)
   if tmp(1) == '('
       strip_left  = strip(el, '(');
       cleaned = strip(strip_left, ')');
       splited = split(cleaned, ', ');
       X(end+1) = str2double(splited(1));
       Y(end+1) = str2double(splited(2));
       Z(end+1) = str2double(splited(3));
   end
end

% This part is plotting.
for i = 1:segCount-1 % Plotting in every segment
   t = X2(i); % Store each segment of 'x' into each column of cell
   X = t{1,1};
   X = 10*X; % for easy calculating
   
   t = Y2(i); % Store each segment of 'y' into each column of cell
   Y = t{1,1}; 
   Y = 1-Y;
   Y = 10*Y;
   
   t = Z2(i); % Store each segment of 'z' into each column of cell
   Z = t{1,1}; % inverse Y first
   
   plot(X, Y); % Plot each segment ( each Char )
   % time pause per each loop
   pause(0.05);
   if i ~= 0, hold on; end
end

