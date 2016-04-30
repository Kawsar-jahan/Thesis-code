%******************************************************* ITERATIVE ROUNDING ***********************************************

function [UB_SP] = IRBB_func(c, A, b, lb_IR, ub_IR, ctype, vartype, s, tmin,fid1);
tmin;

while (1) 

	
	
	[xminIR, imin] = glpk (c, A, b, lb_IR, ub_IR, ctype, vartype, s);

	frac_value_2= find(xminIR < 0.0001);
	
	xminIR(frac_value_2)=0;

	frac_value_1= find(xminIR > 0.999);
	
	xminIR(frac_value_1)=1;

    
	one_value=find ( xminIR== 1 );		%variables with value 1

    	zero_value=find ( xminIR==0);		%variables with value 0

       
	ub_IR(zero_value)=0;			%changing ub for 0 values

	lb_IR(one_value)=1 ;			%changing lb for 1 values

    
    	frac_value=intersect(find(xminIR < 1) , find(xminIR>0)); 	%positions of fractional variables
	
    	if (isempty(frac_value)) 
        	break;
    	end
	frac_value_size=size(frac_value,1)
    	max_value=find (xminIR==max(xminIR(frac_value)))  ; 		%maximum fractional variable
	
%	round_value=frac_value(1);
	round_value=max_value(1);
%	round_value=frac_value(frac_value_size);
    	lb_IR(round_value)=1;		%changing lb for 1 values
	
   
end
UB_SP=imin	;	
%fprintf(fid1,'IR_value=%d\n',fid1);

endfunction;


