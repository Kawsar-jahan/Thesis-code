function [sp_cost] = BB_SP_cost(c, A, b, lb_cost, ub_cost, ctype, vartype, s, param, xmin_last,fmin_last, fid1);
global NumberofNodes
global UB
%global sp_cost1
%global sp_cost2
%fid=3

	frac_value_1= find(xmin_last > 0.999);
	
	xmin_last(frac_value_1)=1;

	
	frac_value_2= find(xmin_last < 0.0001);
	
	xmin_last(frac_value_2)=0;
	
%	fprintf(fid1,'xmin_last=%0.8f\n',xmin_last);
	frac_value=intersect(find (xmin_last > 0) , find( xmin_last < 1)) 	%positions of fractional variables
	
	frac_value_size=size(frac_value,1)
%	fprintf(fid1,'frac_value=%d\n',frac_value);
%	fprintf(fid1,'frac_value_size=%d\n',frac_value_size);

	size(frac_value,1);
    	if (isempty(frac_value)) 
		fprintf(fid1,'no fractional value BB_SP_cost\n');

		sp_cost = fmin_last
%		sp_cost1=fmin_last
		fprintf(fid1,'sp_cost = %d\n',sp_cost);
		UB=min(UB,sp_cost);



	else
	max_value=find (xmin_last==max(xmin_last(frac_value)))  ; 		%maximum fractional variable
%	fprintf(fid1,'max_value=%d\n',max_value);
%	round_value=frac_value(frac_value_size)
	round_value=frac_value(1)
%	round_value=max_value(1);
%	fprintf(fid1,'round_value=%0.8f\n',round_value);
	xmin_SP1=xmin_last;
	ub1=ub_cost;

	lb1=lb_cost;



	
	xmin_SP1(round_value)=0;
%	fprintf(fid1,'xmin_SP1=%0.8f\n',xmin_SP1);
	NumberofNodes =NumberofNodes +1;

	one_value_SP1=find ( xmin_SP1== 1 );		%variables with value 1

	
    	zero_value_SP1=find ( xmin_SP1==0);		%variables with value 0

    
	
	ub1(round_value)=0	;		%changing ub for 0 values

	
	
%	lb1(round_value)=0 ;			%changing lb for 1 values#############


	param.dual = 3;
	param.presol = 1;
%	param.round = 1;
	param.tmlim=inf;

	[xminSP1, SP1min, status] = glpk (c, A, b, lb1, ub1, ctype, vartype, s, param) 	;	%GLPK function

	LB1=SP1min
	fprintf(fid1,'LB1=%0.8f\n',LB1)
	UB1=IRBB_func(c, A, b, lb1, ub1, ctype, vartype, s, SP1min, fid1)
	fprintf(fid1,'UB1=%d\n',UB1)

	xmin_SP2=xmin_last;
	lb2=lb_cost;
	ub2=ub_cost;

	xmin_SP2(round_value)=1;
%	fprintf(fid1,'xmin_SP2=%0.8f\n',xmin_SP2);
	NumberofNodes =NumberofNodes+1;

	one_value_SP2=find ( xmin_SP2== 1 );		%variables with value 1


    	zero_value_SP2=find ( xmin_SP2==0);		%variables with value 0

%	ub2(round_value)=1;			%changing ub for 0 values################

	lb2(round_value)=1 ;			%changing lb for 1 values


	param.dual = 3;
	param.presol = 1;
%	param.round = 1;
	param.tmlim=inf;
	[xminSP2, SP2min, status] = glpk (c, A, b, lb2, ub2, ctype, vartype, s, param) 	;	%GLPK function

	LB2=SP2min
	fprintf(fid1,'LB2=%0.8f\n',LB2)
	UB2=IRBB_func(c, A, b, lb2, ub2, ctype, vartype, s, SP2min, fid1)
	fprintf(fid1,'UB2=%d\n',UB2)
	NN = NumberofNodes
	UB = min(min(UB1,UB2),UB)
	fprintf(fid1,'UB=%d\n',UB)
	
	if(UB>LB2 & UB>LB1 )

		fprintf(fid1,'########## 0th condition SP1 & SP2 ###################')
		fprintf(fid1,'\n\n');
	end



	if(UB>LB2)

		fprintf(fid1,'########## 1st condition UB > LB2: SP2###################')
		fprintf(fid1,'\n\n');

		
		[sp_cost]=BB_SP_cost(c, A, b, lb2, ub2, ctype, vartype, s, param, xminSP2,SP2min,fid1)
	end
	if(UB>LB1)

		fprintf(fid1,'################ 2nd condition UB > LB1: SP1 #################')
		fprintf(fid1,'\n\n');
		[sp_cost]=BB_SP_cost(c, A, b, lb1, ub1, ctype, vartype, s, param,xminSP1,SP1min,fid1)
	end
	if(UB==LB2 || UB==LB1)

		fprintf(fid1,'################## last condition UB == LB2 or UB == LB1###############')
		fprintf(fid1,'\n\n');
		
		if(LB1==UB)
			sp_cost = LB1

		end
		if(LB2==UB)
			sp_cost = LB2

		end
		fprintf(fid1,'sp_cost=%.16f \n\n',sp_cost);
		%break;

		
	end

	if(!(UB>LB1) & !(UB>LB2) & (!(UB==LB2) || !(UB==LB1)))
  		fprintf(fid1,'################## UB < (LB1 & LB2) & UB!=LB2 or vice versa #################\n\n')
		sp_cost=UB
		fprintf(fid1,'sp_cost=%.16f \n\n',sp_cost);
 		%break
	end
end
%sp_cost=min(sp_cost1,sp_cost2)
endfunction;

