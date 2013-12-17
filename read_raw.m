function [header_cells,variables_cells,data_cells] = read_raw(filename)
% read_raw: usage-- [headers_cels,variables_cells,data_cells]=readraw(file)
% This m-file function reads spice3 ascii "raw" file line-by-line 
% and outputs string and numeric information compatible with MATLAB. 
% Input: The text string containing the full path for the raw file 
% Outputs: [header_cells,variables_cells,data_cells]. 
% header_cells is a cell vector of cell arrays.
% The i-th cell element, i.e. header_cells{i}, is a cell array, which contains 
% the contents of the first six lines of the i-th section of the raw file 
% -- the title of each item (e.g. Title:) is stripped off (leaving, e.g.
% Bridge-T Circuit). 
% variables_cells is a cell vector of cell arrays of strings.
% The i-th cell element, i.e. variables_cells{i}, is a cell array, each
% element of the array contains the spice variable number (e.g. 0),
% variable names (e.g. v(1) or sweep) and the units (e.g. frequency, 
% voltage). 
% data_cell is a cell of numeric arrays, one array for each data section.
% The i-the array, i.e. data_cell{i}, is a numeric 2-D array,
% each column is corresponding to each of the variables (1 to #variables).
% Note: in MATLAB, the variable numbers must be incremented by one 
% to properly locate the column for that variable.
% Written by LJO (Nov. 25, 2012). Based on rawspice6.m
%Start timer
if nargin~=1,
    header_cells={}; variables_cells={}; data_cells={};
    disp('Improper use of read_raw');
    disp('[header_cells,variables_cells,data_cells] = read_raw(filename)');
    disp('See also: help read_raw');
    return;
end
tic
fprintf(1,'Reading raw file\n');
header_cells=[]; variables_cells=[]; data_cells={};
% Create cell array containing each line in the file
fid = fopen(filename, 'rt');
nr=1; titline='';
n=1;
while feof(fid) == 0
    while feof(fid) == 0
        line = fgets(fid);
        line=line(1:end-1);
        if(n>1)
            pos=strfind(line,'Title:');
            if ~isempty(pos) && pos==1
                titline=line; break; 
            end
        end
        s{n}=line;
        n = n+1;
    end
    n=numel(s);
    if n>0
        [header, variables, data] = process_section(s);
        header_cells{nr}=header;
        variables_cells{nr}=variables;
        data_cells{nr}=data;
        s={}; s{1}=titline; n=2;
        nr=nr+1;
    end    
end
fclose(fid);
fprintf(1,'Done with conversion\n')
%Compute elapsed time
toc
end
function [header, variables,data] = process_section(s)
fprintf(1,'File section read, beginning conversion\n');
nlines=numel(s);
%Pre-allocate space for header info
header = cell(6,1);
%Strip out header information--first 6 lines
for k=1:6
    locs=findstr(s{k},':');       %Find the colon after the title
    [nl n2]=size(s{k});
    header{k}=s{k}(locs(1)+2:n2); %Save everything after the colon
end
% Find beginning of Variables subsection
for kv=7:nlines
     pos=strfind(s{kv},'Variables:');
     if ~isempty(pos) && pos==1, break; end
end
if kv>=nlines, error('incorrect file format'); end
%Identify variables and variable types
nvars=str2num(header{5});   %Number of variables is in header lnine 5
variables = cell(nvars,1);  %Create space for variables info

for k=1:nvars           %Variables info starts in line 8
    [nl n2]=size(s{kv+k});
    variables{k}=s{kv+k}(2:n2);
end     %k loop

npts=str2num(header{6});    %Number of values per variable
line=kv+nvars+2;            %Line where data starts

if strncmp(header{4},'complex',4)	 %Identify data type

%If the data is complex, handle it here
    for k=1:npts
        for k2=1:nvars
            if(line>nlines), break; end %LJO
            tabs=findstr(s{line},char(9)); %Locate tabs
            [nl n2]=size(s{line});
            comma=findstr(s{line},',');	%Locate the comma
            data(k,k2)=sscanf(s{line}(tabs(1)+1:comma(1)-1),'%e') +...
                i*(sscanf(s{line}(comma(1)+1:n2),'%e'));  %Store data in complex form  
            line=line+1;
        end             %k2 loop
%        line=line+1;	%Skip blank line between data sets
        end             %k loop

% If the data is real, handle it here    

else
    for k=1:npts 
        for k2=1:nvars
            if(line>nlines), break; end %LJO
            tabs=findstr(s{line},char(9)); %Locate tabs 
            [nl n2]=size(s{line}); 
            data(k,k2)=sscanf(s{line}(tabs(1)+1:n2),'%e'); 
            line=line+1;
        end             %k2 loop
%        line=line+1;    %Skip blank line between data sets
        end             %k loop
end	%end if
end