fid1=fopen('checkcheck1.txt','w');
fid = fopen('input10.txt');
fid2=fopen('approxLP10IR2.txt','w');
fid3=fopen('approxIP10IR2.txt','w');
fid4=fopen('timeLP10IR2.txt','w');
fid5=fopen('timeIP10IR2.txt','w');
fid6=fopen('timeIR10IR2.txt','w');
fid7=fopen('highestLP10IR2.txt','w');
fid8=fopen('highestIP10IR2.txt','w');
fid9=fopen('lambda.txt','w');

var2 = 3/0.1;
var3 = 9/0.1;

dim=10;

for p_loop=0.01:0.01:1

p=p_loop
res=0;
res1=0;
t=0;
tlp=0;
tip=0;
tir=0;
hi=0;
hi1=0;

for k=1:1:25



tic

fprintf(fid1,'*******OUTPUT %d for p=%0.2f %dx%dx%d********\n\n',k,p,dim,dim,dim);

tline =fgetl(fid);


in_points=fgetl(fid);
B = strrep(in_points,' ',' ');
C = char(strsplit(B));
points = reshape(str2num(C), 3, [])';


%points=[1,1,1;1,1,2;1,2,2;2,2,2;2,2,3;2,3,3;3,3,3;3,3,4;3,4,4;4,4,4;4,4,5;4,5,5;5,5,5;5,5,6;5,6,6;1,6,6;1,6,1];
%	points=[1 2 4;1 5 4;1 2 9];
	%fprintf(fid,[repmat('%d\t',1,size(points,2)) '\n'],points');
	%fprintf(fid,'\n');

	numberOfPoints=size(points,1)
	var1 = numberOfPoints/1.967;
	fprintf(fid1,'numberofpoints=%d \n',numberOfPoints);
%	fprintf(fid,'\n');
	
	xy=unique(points(:,[1,2]),'rows');
	yz=unique(points(:,[2,3]),'rows');
	xz=unique(points(:,[1,3]),'rows');
	L=size(xy,1)+size(yz,1)+size(xz,1);		%number of lines
	Axy=zeros(size(points,1),size(xy,1));
	Ayz=zeros(size(points,1),size(yz,1));
	Axz=zeros(size(points,1),size(xz,1));
	
	for i=1:size(points,1)
		for j=1:size(xy,1)
			if(points(i,[1,2])==xy(j,:))
				Axy(i,j)=1;
			endif
		end
	end
	Axy;

	
	for i=1:size(points,1)
		for j=1:size(yz,1)
			if(points(i,[2,3])==yz(j,:))
				Ayz(i,j)=1;
			endif
		end
	end
	Ayz;
	
	for i=1:size(points,1)
		for j=1:size(xz,1)
			if(points(i,[1,3])==xz(j,:))
				Axz(i,j)=1;
			endif
		end
	end
	Axz;
	
	Acat=cat(2,Axy,Ayz);
	
	A=cat(2,Acat,Axz);			%constraint matrix
%	fprintf(fid,[repmat('%d\t',1,size(A,2)) '\n'],A);
%	fprintf(fid,'%d\t',A);
	
	c=ones(1,size(A,2))';			%objective function co-efficients matrix
	b=ones(1,size(A,1))';			%constraints' right hand side value matrix
	
	lb=zeros(1,size(A,2));			%variable lower bound matrix
	
	ub=ones(1,size(A,2));			%variable upper bound matrix
	clear ctype
	for i=1:size(A,1)
		ctype(i)="L";
	end
	ctype;
	
	clear vartype;
	for i=1:size(A,2)
		vartype(i)="C";
	end
	vartype;

	clear vartype1;
	for i=1:size(A,2)
		vartype1(i)="I";
	end
	vartype1;
	s = 1;

fprintf(fid1,'var1=%0.8f\n',var1);
fprintf(fid1,'var2=%0.8f\n',var2);
param.msglev = 1;
param.tmlim=inf;
param.dual=3;
param.lpsolver=1;



	tic
	[xmin, fmin, status, extra] = glpk (c, A, b, lb, ub, ctype, vartype, s, param)  ;	%GLPK function
	toc
	tlp=tlp+toc;
%	fprintf(fid1,'fmin=%0.8f\n',fmin);
%	fprintf(fid1,'%0.32f\n',xmin);

	lambda = vertcat(extra.lambda); %// contains the dual variable values
	size_lambda=size(lambda,1);
	fprintf(fid9,'%0.8f\n',lambda);
	ymax=sum(lambda)
%	fprintf(fid1,'ymax=%0.8f\n',ymax);
	

	
	tic
	[ixmin, ifmin] = glpk (c, A, b, lb, ub, ctype, vartype1, s);		%GLPK function
	toc
	tip=tip+toc;
	fprintf(fid1,'IP_value=%d \n',ifmin);
%	fprintf(fid,'\n');


%******************************************************* ITERATIVE ROUNDING ***********************************************

	tic	
	IR= IR8_func(c, A, b, lb, ub, ctype, vartype, vartype1, s, param, var1, var2, var3, fid1);
	toc
	tir=tir+toc;

	fprintf(fid1,'IR_value=%0.8f \n',IR);
	approx_ratio_IR=IR/fmin		%approx_ration=IR/OPT
	fprintf(fid1,'Approx_ratio_IR/LP=%0.8f\n',approx_ratio_IR);
	approx_ratio_IP=IR/ifmin
	fprintf(fid1,'Approximation_ratio_IR/IP=%0.8f\n',approx_ratio_IP);
	%fprintf(fid,'\n\n');

	if(approx_ratio_IR>hi)
		hi=approx_ratio_IR;
	end

	if(approx_ratio_IP>hi1)
		hi1=approx_ratio_IP;
	end



toc
fprintf(fid1,'time=%0.8f\n',toc);
res=res+approx_ratio_IR;
fprintf(fid1,'res=%0.8f\n',res);
res1=res1+approx_ratio_IP;
fprintf(fid1,'res1=%0.8f\n',res1);
t=t+toc;
fprintf(fid1,'t=%0.8f\n\n\n',t);

end

fprintf(fid2,'%0.8f\n',res/25);
fprintf(fid3,'%0.8f\n',res1/25);
fprintf(fid1,'avg time=%0.8f\n',t/25);
fprintf(fid4,'%0.8f\n',tlp/25);
fprintf(fid5,'%0.8f\n',tip/25);
fprintf(fid6,'%0.8f\n',tir/25);
fprintf(fid7,'%0.8f\n',hi);
fprintf(fid8,'%0.8f\n',hi1);

end

fclose('all');










