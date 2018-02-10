function dates2csv(Start, Finish)
SDashes = strfind(Start,'/');
FDashesh = strfind(Finish,'/');
Title = 'Day,Month,Year\n';
StartDate = [str2num(Start(1:SDashes(1)-1)),str2num(Start(SDashes(1)+1:SDashes(2)-1)),str2num(Start(SDashes(2)+1:end))];
FinishDate = [str2num(Finish(1:FDashesh(1)-1)), str2num(Finish(FDashesh(1)+1:FDashesh(2)-1)), str2num(Finish(FDashesh(2)+1:end))];

fid = fopen('functions/Crawler/dates.csv', 'w') ;
fprintf(fid, Title) ;
fprintf(fid, '%d,%d,%d\n', StartDate) ;
fprintf(fid, '%d,%d,%d\n', FinishDate) ;
fclose(fid) ;