%******************************************************* ITERATIVE ROUNDING ***********************************************

function IR= IR8_func(c, A, b, lb, ub, ctype, vartype, vartype1, s, param, var1, var2, var3, fid1);
	
	[xmin, imin, status, extra] = glpk (c, A, b, lb, ub, ctype, vartype, s, param);		%GLPK for primal
	fprintf(fid1,'Primal=%0.8f\n', imin);
%	fprintf(fid1, 'xmin=%0.8f\n', xmin);
	lambda = vertcat(extra.lambda);		%contains dual  variable values
	ymax=sum(lambda)
	fprintf(fid1,'dual=%0.8f\n',ymax);
	
	lb_primal=lb;
	ub_primal=ub;

	tic	
	[xipmin, iipmin] = glpk (c, A, b, lb, ub, ctype, vartype1, s);			%GLPK for IP
	toc
%	fprintf(fid1,'time=%0.8f\n',toc);
	fprintf(fid1,'IP=%d\n', iipmin);

	frac_line=intersect(find (xmin < 1 ), find(xmin>=0.508));	%positions for fractional lines >=1/alpha

	frac_value=intersect(find (xmin < 1 ), find(xmin>0)); 		%positions of fractional variables

%	fprintf(fid1,'frac_value=%d\n',frac_value);
	if (isempty(frac_value)) 
	fprintf(fid1,'###### 1st condition ######\n');
		IR=imin  
		fprintf(fid1,'IR=%0.8f\n',IR);

	elseif(ymax >= var1)
		fprintf(fid1,'###### 2nd condition %0.8f>=%0.4f ######\n',imin,var1);
		IR =iipmin
		fprintf(fid1,'IR=%0.8f\n',IR);
	
	elseif(ymax <= var2)

		fprintf(fid1,'###### 3rd condition %0.8f<=%0.4f ######\n',imin,var2);
		IR = iipmin
		fprintf(fid1,'IR=%0.8f\n',IR);
	
	elseif (!isempty(frac_line))  

		fprintf(fid1,'###### 4th condition ######\n');

		round_value=frac_line(1);
	    	lb_primal(round_value)=1;			%changing lb for 1 values  
		
		IR= IR8_func(c, A, b, lb_primal, ub_primal, ctype, vartype, vartype1, s, param, var1, var2, var3, fid1);
	else
		fprintf(fid1,'###### 5th condition ######\n');

		p_pos=(find(lambda<=0.508));	%)intersect(find(lambda>0),find(lambda<=0.508));
		current=1;
	while(1)
		
		yp=p_pos(current);
		
%		fprintf(fid1,'yp=%d\n',yp);
%		lambda(yp)=1;
%		fprintf(fid1,'lambda(yp)=%0.8f',lambda(yp));
		L=find(A(yp,:)==1);
%		fprintf(fid1,'L=%d\n',L);
%		fprintf(fid1,'xmin(L)=%0.8f\n',xmin(L));
%		fprintf(fid1,'lambda(yp)=%0.8f\n',lambda(yp));
		res=lb_primal(L(1));
		for i=2:3
			res=res | lb_primal(L(i));
		end
		res;
			
		if(res==1)
			current=current+1;
%			yp=p_pos(current)
		else	
			fprintf(fid1,'yp=%d\n',yp);
			fprintf(fid1,'L=%d\n',L);
			lb_primal(L)=1;
			break
		end
	end		

#{
		p_pos=(find(lambda<=0.508))	%)intersect(find(lambda>0),find(lambda<=0.508));
		yp=p_pos(1)
		
		fprintf(fid1,'yp=%d\n',yp);
%		lambda(yp)=1;
%		fprintf(fid1,'lambda(yp)=%0.8f',lambda(yp));
		L=find(A(yp,:)==1)
		fprintf(fid1,'L=%d\n',L);
%		fprintf(fid1,'xmin(L)=%0.8f\n',xmin(L));
%		fprintf(fid1,'lambda(yp)=%0.8f\n',lambda(yp));
		if(lb_primal(L)==1)
		lb_primal(L)=1;

#}		

		IR= IR8_func(c, A, b, lb_primal, ub_primal, ctype, vartype, vartype1, s, param, var1, var2, var3, fid1);
		
		
	end	

endfunction;


