fid1=fopen('checkBB10L.txt','w');
fid=fopen('input10.txt');
fid2=fopen('approxIR1LP10L.txt','w');
fid3=fopen('approxBBLP10L.txt','w');
fid4=fopen('timeLPBB10L.txt','w');
fid5=fopen('timeIPBB10L.txt','w');
fid6=fopen('timeIRBB10L.txt','w');
fid7=fopen('highestIR1LP10L.txt','w');
fid8=fopen('highestBBLP10L.txt','w');
fid9=fopen('approxIR1BB10L.txt','w');
fid10=fopen('highestIR1BB10L.txt','w');
fid11=fopen('timeBB10L.txt','w');
fid12=fopen('IPBB10L.txt','w');
fid13=fopen('numberofnodesL.txt','w');
fid14=fopen('numberofpointsL.txt','w');
fid15=fopen('approxIR1IP10L.txt','w');
fid16=fopen('highestIR1IP10L.txt','w');

dim=10;

for p_loop=0.01:0.01:1

p=p_loop
res=0;
res1=0;
res2=0;
res3=0;
res4=0;
nd=0;
np=0
t=0;
tlp=0;
tip=0;
tir=0;
tbb=0;
hi=0;
hi1=0;
hi2=0;
hi3=0;

for k=1:1:25
tic
clear global NumberofNodes;
clear global UB;
global NumberofNodes = 1;
global UB=inf;

%s=('output %d for p=%0.02f',k,p)
%s='output 1 for p=0.01'

fprintf(fid1,'*******OUTPUT %d for p=%0.2f %dx%dx%d********\n\n',k,p,dim,dim,dim);
tline =fgetl(fid);

%while ischar(tline)

%	if(strcmp(tline,s))
%		in_points=fgetl(fid)
%	end

in_points=fgetl(fid);
B = strrep(in_points,' ',' ');
C = char(strsplit(B));
points = reshape(str2num(C), 3, [])'
%tline=fgetl(fid);
%end
%fclose(fid);


%	points=[1,1,1;1,1,2;1,2,2;2,2,2;2,2,3;2,3,3;3,3,3;3,3,4;3,4,4;4,4,4;4,4,5;4,5,5;5,5,5;5,5,6;5,6,6;1,6,6;1,6,1];

	numberOfPoints=size(points,1)
	fprintf(fid,'numberofpoints=%d \n',numberOfPoints);
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
	%A_size=size(A,2);

	c=ones(1,size(A,2))';			%objective function co-efficients matrix
	b=ones(1,size(A,1))';			%constraints' right hand side value matrix
	lb=zeros(1,size(A,2));			%variable lower bound matrix
	ub=ones(1,size(A,2));			%variable upper bound matrix
	
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
	vartype;
	s = 1;

param.dual = 3;
param.presol = 1;
%param.exact = 1;
%param.round = 1;
param.tmlim=inf;
%param.branch=1;
%global ub3 =0
%global lb3 =0
	
	[xmin, fmin, status] = glpk (c, A, b, lb, ub, ctype, vartype, s, param);		%GLPK function
	

%	fprintf(fid1,'LB=%0.08f\n',fmin);
%	fprintf(fid1,'xmin=%0.32f\n',xmin);
	fmin

	status
	frac_value_2= find(xmin < 0.0001);
	
	xmin(frac_value_2)=0;

	frac_value_1= find(xmin > 0.999);
	
	xmin(frac_value_1)=1;

	one_value=find ( xmin== 1 );		%variables with value 1

	
    	zero_value=find ( xmin==0);		%variables with value 0

    
	
	ub(zero_value)=0	;		%changing ub for 0 values

	
	
	lb(one_value)=1 ;			%changing lb for 1 values

	tic
	[xmin, fmin, status] = glpk (c, A, b, lb, ub, ctype, vartype, s, param);		%GLPK function
	toc
	tlp=tlp+toc;
	fprintf(fid1,'LB=%0.08f\n',fmin);

%     *************************************************IP***********************************************************

	param1.dual = 3;
	param1.presol = 1;
	%param.exact = 1;
%	param1.round = 1;
	param1.tmlim=inf;
	param1.branch=2;
	tic
	[ipxmin, ipfmin, status] = glpk (c, A, b, lb, ub, ctype, vartype1, s, param1);		%GLPK function
	toc
	tip=tip+toc;
	fprintf(fid1,'IP_valueBB=%0.8f\n',ipfmin);
%	fprintf(fid1,'ipxmin=%0.8f\n',ipxmin);
	ipfmin





	%******************************************************* ITERATIVE ROUNDING ***********************************************
	tic
	IR= IRBB_func(c, A, b, lb, ub, ctype, vartype, s, fmin, fid1);
	toc
	tir=tir+toc;
	approx_LP=IR/fmin
	if(approx_LP>hi)
		hi=approx_LP
	end
	approx_IP=IR/ipfmin
	if(approx_IP>hi1)
		hi1=approx_IP
	end
%	fprintf(fid1,'IR=%d \n',IR);
	UB=IR
	fprintf(fid1,'UB=%d\n',UB);
	

%fprintf(fid1,'*******Result for root node********\n\n');



	
	frac_value=intersect(find(xmin >0) , find(xmin < 1))	;	%positions of fractional variables
	
	
	size(frac_value,1);
    	if (isempty(frac_value)) 

		fprintf(fid1,'no fractional value at main\n')
		sp_cost=fmin
		fprintf(fid1,'cost when no frac value=%d\n',sp_cost);
		NumberofNodes=1
		fprintf(fid1,'Number of Nodes=%d \n',NumberofNodes);
%	       	break;
	

	else

		

%		round_value=frac_value(1);
	
%		min_cost_check = inf
%		val=xmin(round_value)
		tic
		[sp_cost]=BB_SP_cost(c, A, b, lb, ub, ctype, vartype, s, param, xmin,fmin, fid1)
		toc
		tbb=tbb+toc;
		fprintf(fid1,'cost when frac value=%d\n',sp_cost);
%		printf("check \n")

		fprintf(fid1,'Number of Nodes=%d \n',NumberofNodes);
			

	end
	fprintf(fid1,'IR=%d\n',IR);
	fprintf(fid1,'sp_cost=%d\n',sp_cost);
	approx_ratio_BB = IR/sp_cost
	if(approx_ratio_BB > hi2)
		hi2=approx_ratio_BB
	end
	approx_BBLP = sp_cost/fmin
	if(approx_BBLP > hi3)
		hi3=approx_BBLP
	end	
	fprintf(fid1,'approx_ratio_cost_BB=%.16f \n',approx_ratio_BB);
	IPBB = ipfmin/sp_cost;
	fprintf(fid1,'IPBB=%.16f \n',IPBB);
%	approx_ratio_IP = 
%	fprintf(fid1,'Number of Nodes=%d \n',NumberofNodes);
	fprintf(fid1,'\n\n');



toc
fprintf(fid1,'time=%0.8f\n',toc);
res=res+approx_LP;
fprintf(fid1,'res=%0.8f\n',res);
res1=res1+approx_IP;
fprintf(fid1,'res1=%0.8f\n',res1);
res2=res2+approx_ratio_BB;
fprintf(fid1,'res2=%0.8f\n',res2);
res3=res3+IPBB;
fprintf(fid1,'res3=%0.8f\n',res3);
res4=res4+approx_BBLP;
fprintf(fid1,'res4=%0.8f\n',res4);
t=t+toc;
fprintf(fid1,'t=%0.8f\n\n\n',t);
nd=nd+NumberofNodes;
np=np+numberOfPoints;

end

fprintf(fid2,'%0.8f\n',res/25);
fprintf(fid3,'%0.8f\n',res4/25);
fprintf(fid1,'avg time=%0.8f\n',t/25);
fprintf(fid4,'%0.8f\n',tlp/25);
fprintf(fid5,'%0.8f\n',tip/25);
fprintf(fid6,'%0.8f\n',tir/25);
fprintf(fid7,'%0.8f\n',hi);
fprintf(fid8,'%0.8f\n',hi3);
fprintf(fid9,'%0.8f\n',res2/25);
fprintf(fid10,'%0.8f\n',hi2);
fprintf(fid11,'%0.8f\n',tbb/25);
fprintf(fid12,'%0.8f\n',res3/25);
fprintf(fid13,'%0.8f\n',nd/25);
fprintf(fid14,'%0.8f\n',np/25);
fprintf(fid15,'%0.8f\n',res1/25);
fprintf(fid16,'%0.8f\n',hi1);

end

fclose('all');









