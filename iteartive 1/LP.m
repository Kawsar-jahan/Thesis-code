fid=fopen('output10x10x10.txt','w');

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

c=cartprod(1:dim,1:dim,1:dim);
uni_c=unique(c,'rows');
uni_c_Points=size(uni_c,1);



fprintf(fid,'*******OUTPUT %d for p=%0.2f %dx%dx%d********\n\n',k,p,dim,dim,dim);
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

%	points=[1,1,1;1,1,2;1,2,2;2,2,2;2,2,3;2,3,3;3,3,3;3,3,4;3,4,4;4,4,4;4,4,5;4,5,5;5,5,5;5,5,6;5,6,6;1,6,6;1,6,1];
	points;
	%fprintf(fid,[repmat('%d\t',1,size(points,2)) '\n'],points');
	%fprintf(fid,'\n');

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
%	fprintf(fid,[repmat('%d\t',1,size(Axy,2)) '\n'],Axy);
	
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
	fprintf(fid,'%d\t',A);
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
	vartype1;
	s = 1;

%param.msglev = 1;
%param.itlim = 100;
	tic
	[xmin, fmin] = glpk (c, A, b, lb, ub, ctype, vartype, s);		%GLPK function
	toc
	tlp=tlp+toc;
	%NumberofLines=size(xmin,1)
	fprintf(fid,'numberofLines=%d \n',size(xmin,1));
	fprintf(fid,'LP_value=%0.8f \n',fmin);
%	fprintf(fid,'x = %0.4f\n',xmin)
	tic
	[ixmin, ifmin] = glpk (c, A, b, lb, ub, ctype, vartype1, s);		%GLPK function
	toc
	tip=tip+toc;
	fprintf(fid,'IP_value=%d \n',ifmin);
%	fprintf(fid,'\n');


%******************************************************* ITERATIVE ROUNDING ***********************************************
	tic	
	[IR,IP]= IR_func(c, A, b, lb, ub, ctype, vartype, s, fmin, ifmin, fid);
	toc
	tir=tir+toc;
	if(IR>hi)
		hi=IR
	end
	if(IP>hi1)
		hi1=IP
	end

#{
while (1) 
	
	[xmin, imin] = glpk (c, A, b, lb, ub, ctype, vartype, s)
    
	one_value=find ( xmin== 1 );
    	zero_value=find ( xmin==0);
    
    
    
	ub(zero_value)=0;
	lb(one_value)=1 ;
    
    	frac_value=intersect(find (xmin < 1 ), find(xmin>0)) ;
    	if (isempty(frac_value)) 
        	break;
    	end
    	max_value=find (xmin==max(xmin(frac_value)))    ;
    	lb(max_value)=1;
	
   
end
 
approx_ratio_IR=imin/fmin

#}


%******************************************************* RANDOMIZED ROUNDING ***********************************************

%RR= RR_func(c, A, b, lb, ub, ctype, vartype, s, numberOfPoints, fmin);


#{	
while (1) 
	
	[xmin, imin] = glpk (c, A, b, lb, ub, ctype, vartype, s)
	%xmin=[0,0.5,0.5,0,0,0,0.5]
    
	one_value=find ( xmin== 1 );
    	zero_value=find ( xmin==0);
    
    
    
	ub(zero_value)=0;
	lb(one_value)=1 ;
    
    	frac_value=intersect(find (xmin < 1 ), find(xmin>0)) 
    	if (isempty(frac_value)) 
        	break;
    	end
    	%max_value=find (xmin==max(xmin(frac_value)))    
	f=ceil(2*log(numberOfPoints))
	%prob_value=mean(xmin(frac_value))
	
	for i=1:f
		pos=randi(length(frac_value))
		card=frac_value(pos)
		i++
	end
    	lb(card)=1;
	
   
end

 
approx_ratio_RR=imin/fmin

#}
toc
fprintf(fid,'time=%0.8f\n',toc);
res=res+IR;
fprintf(fid,'res=%0.8f\n',res);
res1=res1+IP;
fprintf(fid,'res1=%0.8f\n',res1);
t=t+toc;
fprintf(fid,'t=%0.8f\n\n\n',t);
end

fprintf(fid,'approx_LP=%0.8f\n',res/25);

fprintf(fid,'approx_IP=%0.8f\n',res1/25);
fprintf(fid,'avg time=%0.8f\n',t/25);
fprintf(fid,'time_LP=%0.8f\n',tlp/25);
fprintf(fid,'time_IP=%0.8f\n',tip/25);
fprintf(fid,'time_IR=%0.8f\n',tir/25);
fprintf(fid,'hiLP=%0.8f\n',hi);
fprintf(fid,'hiIP%0.8f\n',hi1);

end

fclose(fid);










