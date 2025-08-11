0 rem gfx engine by Alvaro Alonso G.
1 rem depth first search maze - v3-hires by Eyvind Ebsen 2025
2 rem almost any pixel size maze. (min. 5 and max 80 for now)
3 rem load gfx engine from disk if not loaded already
4 g=49152:ifpeek(g)<>76orpeek(g+1)<>173thenload"gfx",8,1
5 plot=g:cl=g+18:line=g+21:hires=g+15:text=g+6
6 rem sys g+27:rem sprite 0 as pencil
8 ms=10:input"cell size ";ms:if ms<4then8:rem need more mem under 5
10 mx=320:my=200:px=int(mx/ms-1.5):py=int(my/ms-1.5):ss=1500
15 dimp%(px,py),v%(px,py),sx%(ss),sy%(ss):rem plane and stack
18 printfre(0)"bytes, init..."
20 forx=.topx:fory=.topy:p%(x,y)=15:next:next:rem close all
22 rem gosub800:rem set some as visited for a logo
25 input"ready - enter to start";d$:x=rnd(-ti*peek(54366)):rem all inited
26 ti$="000000"
27 sys hires,1+rnd(1)*15,0:rem random ink, 0=black background
28 sys cl,1:rem dot on
29 rem goto 70
30 rem fory=.tomystepms:sysline,0,y,mx,y:next:rem draw
45 rem forx=.tomxstepms:sysline,x,0,x,my:next:rem grid
60 rem goto60
70 x=int(px/2):y=int(py/2):rem start in the middle
99 rem main loop
100 sx%(sc)=x:sy%(sc)=y:rem  put on stack
110 d$="":v%(x,y)=1:rem mark as visited
120 q=fre(0):rem to avoid string overflow
150 if y>0thenifv%(x,y-1)=0thend$=d$+"u"
160 if x<pxthenifv%(x+1,y)=0thend$=d$+"r"
170 if y<pythenifv%(x,y+1)=0thend$=d$+"d"
180 if x>0thenifv%(x-1,y)=0thend$=d$+"l"
190 if d$<>""then200:rem we can move
192 rem cant move, backtrack if we can
194 ifsc=0then400:rem maze done
196 sc=sc-1:x=sx%(sc):y=sy%(sc):ifsc>xsthenxs=sc
198 goto110
200 c$=mid$(d$,1+len(d$)*rnd(1),1):rem choose dir
210 if c$="u"thenp%(x,y)=p%(x,y)-1:y=y-1:p%(x,y)=p%(x,y)-4:goto250
220 if c$="l"thenp%(x,y)=p%(x,y)-8:x=x-1:p%(x,y)=p%(x,y)-2:goto250
230 if c$="r"thenp%(x,y)=p%(x,y)-2:x=x+1:p%(x,y)=p%(x,y)-8:goto250
240 if c$="d"thenp%(x,y)=p%(x,y)-4:y=y+1:p%(x,y)=p%(x,y)-1
250 gosub900
265 sc=sc+1:ifsc>ssthen990
270 getq$:ifq$<>""then420
280 goto100
399 rem maze done
400 tt=ti:poke53280,0
410 getd$:ifd$=""then410
420 systext:poke53280,14
430 print"time taken "ti,ti$
435 print"max stack: "xs
440 end
799 rem make some cells visited
800 forx=2topy-2:v%(x,x)=1:v%(x+1,x)=1:next
810 rem fory=.topy:forx=.topx:printv%(x,y);:next:print:next:inputx
830 return
899 rem draw cell
900 ifp%(x,y)and1then syscl,1:sysline,x*ms,y*ms,(1+x)*ms,y*ms:goto915
905 syscl,0:sysline,x*ms+1,y*ms,(1+x)*ms-1,y*ms
915 ifp%(x,y)and2then syscl,1:sysline,(1+x)*ms,y*ms,(1+x)*ms,(1+y)*ms:goto925
917 syscl,0:sysline,(1+x)*ms,y*ms+1,(1+x)*ms,(1+y)*ms-1
925 ifp%(x,y)and4then syscl,1:sysline,(1+x)*ms,(1+y)*ms,x*ms,(1+y)*ms:goto935
927 syscl,0:sysline,(1+x)*ms-1,(1+y)*ms,x*ms+1,(1+y)*ms
935 ifp%(x,y)and8then syscl,1:sysline,x*ms,(1+y)*ms,x*ms,y*ms:return:rem goto950
937 syscl,0:sysline,x*ms,(1+y)*ms-1,x*ms,y*ms+1
950 return
989 rem errors...
990 systext:print"stack overflow"
1000 rem sys text
1010 rem forx=.topx:fory=.topy:printp%(x,y);:next:next
