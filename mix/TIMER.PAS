program time;
uses crtstuff,crt,dos;
var
 h,m,s,ms : word;

begin
  cwritexy(1,2,'|KÄ|WS|wÅîâL³NG|KÄ');
 repeat
  gettime(h,m,s,ms);
  cwritexy(75,2,'|W'+flushrt(n2s(h mod 12),2)+'|w:');
  cwritexy(78,2,'|W'+n2s(m));
 until enterpressed;
end.