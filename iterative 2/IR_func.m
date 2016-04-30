%******************************************************* ITERATIVE ROUNDING ***********************************************

function [approx_ratio_IR, approx_ratio_IP] = IR_func(c, A, b, lb, ub, ctype, vartype, s, param, fmin, ifmin, fid1);

while (1) 
	
	[xmin, imin] = glpk (c, A, b, lb, ub, ctype, vartype, s, param);
	%fprintf(fid,'xmin=\n');
%	fprintf(fid1,'%0.8f\n',xmin);
	%fprintf(fid,'\n');
    
	one_value=find ( xmin== 1 );		%variables with value 1
    	zero_value=find ( xmin==0);		%variables with value 0
    
    
    
	ub(zero_value)=0;			%changing ub for 0 values
	lb(one_value)=1 ;			%changing lb for 1 values
    
    	frac_value=intersect(find (xmin < 1 ), find(xmin>0)) ;		%positions of fractional variables
    	if (isempty(frac_value)) 
        	break;
    	end
    	max_value=find (xmin==max(xmin(frac_value)))   		%maximum fractional variable
	round_value=max_value(1)
%	fprintf(fid1,'round_value=%d\n',round_value);
    	lb(round_value)=1;			%changing lb for 1 values
	
   
end

fprintf(fid1,'IR_value=%0.8f \n',imin);
approx_ratio_IR=imin/fmin		%approx_ration=IR/OPT
fprintf(fid1,'Approx_ratio_IR/LP=%0.8f\n',approx_ratio_IR);
approx_ratio_IP=imin/ifmin
fprintf(fid1,'Approximation_ratio_IR/IP=%0.8f\n',imin/ifmin);
%fprintf(fid,'\n\n');

endfunction;


