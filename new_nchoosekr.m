function y = new_nchoosekr(v,n)
m = length(v);
X = cell(1, n);
[X{:}] = ndgrid(v);
X = X(end : -1 : 1);
y = cat(n+1, X{:});
y = reshape(y, [m^n, n]);
y=unique(sort(y,2),'rows');


end

