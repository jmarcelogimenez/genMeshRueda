function [vs1,is1] = mksort(v1,keys)
%
%     [vs1,is1] = mksort(v1,keys)
%
%           vs1 = v1(is1,:)
%

[n,m] = size(v1);
if nargin <2, keys = (1:m); end

ikeys = [];
nkeys=length(keys);

vs1 = v1;
is1 = (1:n)';
for k=nkeys:-1:1,
 vv                 = vs1(:,keys(k));
 [bas,ikeys(1:n,k)] =      sort(vv);
  vs1(:,1:m)        = vs1(ikeys(1:n,k),1:m);
  is1               = is1(ikeys(1:n,k));
end
