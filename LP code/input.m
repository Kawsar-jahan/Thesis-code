fid=fopen('input201.txt','w');
%fid1=fopen('p-value.txt','w');


dim=20;

for p_loop=0.01:0.01:1
p=p_loop
%fprintf(fid1,'%0.2f\n',p);

for k=1:1:25


c=cartprod(1:dim,1:dim,1:dim);
uni_c=unique(c,'rows');
uni_c_Points=size(uni_c,1);



fprintf(fid,'output %d for p=%0.2f',k,p);
fprintf(fid,'\n');
%p=0.5;
%fprintf(fid,'p=%0.2f\n',p);
%fprintf(fid,'\n');



	%fprintf(fid,'*******OUTPUT %d for p=0.1********\n\n',k);
	i=1;
	j=1;
	while(i<=uni_c_Points)
		f=rand;
		%fprintf(fid,'f=%0.8f\n',f);
		if(f<=p)
			points(j,:)=c(i,:);
			j++;
		end
		i++;
	end
	%fprintf(fid,'\n');
	%fprintf(fid,'points=\n');

%	points=[1,1,1;1,1,2;1,2,2;2,2,2;2,2,3;2,3,3;3,3,3;3,3,4;3,4,4;4,4,4;4,4,5;4,5,5;5,5,5;5,5,6;5,6,6;1,6,6;1,6,1]
%	points
	fprintf(fid,[repmat('%d ',1,size(points,2)) ' '],points');
	fprintf(fid,'\n');
	
	numberOfPoints=size(points,1)
%	fprintf(fid,'numberofpoints=%d \n',numberOfPoints);
%	fprintf(fid,'\n');


end
%fprintf(fid,'\n\n\n');

end

fclose(fid);










