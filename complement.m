function a=complement(b,c);
%
%   a=complement(b,c);
% 
%  a = b - intersection(b,c)
%

maxb=max(b);
maxc=max(c);
mark = zeros(max(maxb,maxc),1);
mark(b)=1;
mark(c)=0;
a = find(mark==1);

return

    d=[b;c];
    [yy,ii] = sort(d);
    dd = diff(yy);
    nn = find(dd==0);
    nn = [nn;nn+1];
    yy(nn)=[];
    a = yy;


