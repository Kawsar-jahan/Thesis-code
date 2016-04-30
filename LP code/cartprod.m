function result = cartprod(varargin);
	c=cell(1, numel(varargin));
	[c{:}]=ndgrid(varargin{:});
	result=cell2mat(cellfun(@(v)v(:), c, 'UniformOutput',false));
endfunction;
