!-v2
!-try to store data with pokes, instead of dim vars 
!-no more dim arrays, locating bytes from $1000, just after basic
!-program
!-still not enough mem for cell size 2
!-
!-v3
!-will try to store the visit in bit 4 of the plane
!-done, saved 4k for now
!-now works with cell size 2. But the stack is limited to 2000
!-which is 4000 bytes for x and y. will crash
!-color memory at $4000.
!-graphic memory at $6000
!-
!-v4
!-got the stack up to 3200 bytes in x and y by using
!-memory located after the gfx-engine $C000-C330. still not enough
!-have 3200 bytes for stack 
!-
!-v5
!-optimized vars, and did some precalc. 50 secs faster
!-
!-v6
!-why not save the stack as a 2 bit value, in the plane data?
!-bit5 and bit6, 32, 64
!-instead of saving the old x and y, just save the direction
!-we choose, it can only be 4 possibles.
!-yes. saved the 4 directions as 0..3,
!-and just reverse x and y when backtracking.
!-stack problem solved! :D .. or not
!-weird bug when x or y goes close to edges..
!-backtrack data is somehow wrong, or i miss the visitbit...
!-
!-v7
!-Finally cracked the error. I had to reset the last stackdata bits
!-before OR'ing new data to the bits. Doh.
!-Was oring data into the old stack data getting weird results.
!-old line:
!- pokep+sc,peek(p+sc)or((d*32))
!-new line
!- pokep+sc,(peek(p+sc)and31)or((d*32))
!-
!-this is how the bits are used for each cell
!- bits 0..3 : doors: up,right,down,left
!- bit 4     : visit-bit. If set, the cell has not been visited
!- bits 5-6  : stack: 0..3 which holds a value of the last move
!-             reversing that move will backtrack.
!-
!- v8
!- there is still a bug in cell size 2.... hmmm
!- yes i ran into the color mem which was located at $5c00,
!-  this have been moved to $8c00 in version 07c1 of 
!-  Alvaros gfx engine.
!- 
!- lowered the starting memory position to 6144 ($1800)
!- problem solved.
!- Funny thing is that cell size 2 never goes above stack 6000 ?
!- stack size can never exceed 2/3 of the cellcount? or is it luck?
!- stack size of 6003 reached, now 6500
!- timecheck: with rnd(-1), cell size 10:
!- takes 4m22s
!- need to fix the string gathering into a list of numbers
!- and get rid of the FRE(0) call. done.
!- seems to be 10 secs slower, but atleast its "foolproof"?

!- v9
!- optimized some variables and reused the direction var to e
!- no more sc for stackcount, its now s
!-
!- v10
!- tried to use some asm to fast clear the cell data, but
!- i gives me a weird syntax error every second run. dropped for now
!- Rearranged the order of vars in the dim statement
!- Changed the keywait in the loop getd$:ifd$<>""then ... to 
!- if peek(198)
!- timecheck: with rnd(-1), cell size 10:
!- takes 4m5s
!- 17 seconds faster.
!- Includes the updated gfx engine (07c1) from Alvaro Alonso:
!- msg from Alvaro:
!-
!-  I move color memory to $8c00, hi-res screen to $A000
!-  Set top of BASIC memory at start of BASIC program
!-  poke 55,0:poke 56,139:rem memsiz $8b00
!-  poke 51,peek(55):poke 52,peek(56):rem fretop $8b00
!-
!- Added a CLR after the above pokes.
!- Cool! So the bitmap is now under BASIC ROM ($A000)
!- Color mem at $8c00, leaves about 30kb for basic
!- safe to add more basic code. can go up to 19840
!-
!- bugfix, the rnd init was not pointed at correct address
!- to shuffle up TI with the current raster line. 53266, $D012
!- fixed to: rnd( -(ti*peek(53266))+ti )
!-
!- References:
!- https://en.wikipedia.org/wiki/Maze_generation_algorithm
!-
0 rem gfx engine by Alvaro Alonso G.
1 rem depth first search maze in hires by Eyvind Ebsen 2025
2 rem load gfx engine from disk if not loaded already
3 d=peek(186):ifd<8thend=8:rem get last device number
4 rem print"using device"d:inputd rem the 2 disk drive bug... later
5 ifpeek(49152)<>76orpeek(49152+868)<>7thenload"gfx07c1",d,1
6 poke55,0:poke56,139:rem memsiz $8b00 : to go under colmem
7 poke51,peek(55):poke52,peek(56):clr:rem fretop $8b00 : to go under colmem
8 dimp,x,y,e,w,s,line,cl,m,px,py,n(3),q,r
9 g=49152:cl=g+18:line=g+21:hires=g+15:text=g+6:plot=g
10 rem sys g+27:rem sprite 0 as pencil
11 print:print"thanks to alvaro alonso for gfx engine":print
12 print"hires depth first search maze generator"
14 m=10:input"cell size (2-50) ";m:ifm<2then14:rem need alot of mem under 5
15 mx=320:my=200:px=int(mx/m-1.5)+1:py=int(my/m-1.5):p=19840:rem ss=3279
17 print"cells in x:"px:print"cells in y:"py+1:print"total cells"px*(py+1)
19 print"free bytes:"fre(0):print"init..."px*(py+1)"cells from"p"to"p+px*(py+1)
20 forx=.to(1+px)*(1+py):pokep+x,31:next:rem close all doors and set visits
22 rem gosub800:rem set some as visited for a logo
25 input"ready - enter to start";d$:x=rnd(-(ti*peek(53266))+ti):rem all inited
26 poke53280,11:ti$="000000":s=0
27 sys hires,1+rnd(1)*15,0:rem random ink, 0=black background
28 sys cl,1:rem poke2041,1:v=53248:pokev+2,50:pokev+3,50:pokev+21,3:pokev+40,5:rem forx=24576to25576:pokex,255:next:rem dot on
70 x=int(px/2):y=int(py/2):rem start in the middle
99 rem main loop
100 e=0:rem clear list of directions
115 w=p+y*px+x:pokew,peek(w)and239:rem clear visit bit
150 if y>0thenifpeek(p+(y-1)*px+x)and16thenn(e)=1:e=e+1:rem d$=d$+"u"
160 if x<px-1thenifpeek(p+(y*px)+x+1)and16thenn(e)=2:e=e+1:rem d$=d$+"r"
170 if y<pythenifpeek(p+(y+1)*px+x)and16thenn(e)=4:e=e+1:rem d$=d$+"d"
180 if x>0thenifpeek(p+(y*px)+x-1)and16thenn(e)=8:e=e+1:rem d$=d$+"l"
190 if e>0then200:rem can move
191 rem cant move, backtrack if pos
192 ifs=0then400:rem maze done
193 s=s-1:e=int((peek(p+s)and96)/32):rem reuse e var:print"backtrack"p+sc,f,peek(p+sc)
194 ife=0theny=y+1:goto100
195 ife=1thenx=x+1:goto100
196 ife=2thenx=x-1:goto100
197 y=y-1:goto100:rem iff=3theny=y-1:goto110
198 rem print"backtrack xy error!":goto990
199 rem choose dir ; reuse var e
200 e=int(e*rnd(1)):e=n(e)
205 w=p+px*y+x:rem calc memory pos, open doors
215 ife=1thenpokew,peek(w)-1:y=y-1:e=0:w=p+px*y+x:pokew,peek(w)-4:goto250
225 ife=8thenpokew,peek(w)-8:x=x-1:e=1:w=p+px*y+x:pokew,peek(w)-2:goto250
235 ife=2thenpokew,peek(w)-2:x=x+1:e=2:w=p+px*y+x:pokew,peek(w)-8:goto250
245 ife=4thenpokew,peek(w)-4:y=y+1:e=3:w=p+px*y+x:pokew,peek(w)-1
247 rem ifx<1ory<1orx>=pxory>=pythenprint"out bounds!":goto990
250 w=p+px*y+x:q=x*m:r=y*m:rem precalc, now draw cell
251 ifpeek(w)and1thensyscl,1:sysline,q,r,(1+x)*m,r:goto254
252 syscl,0:sysline,q+1,r,(1+x)*m-1,r
254 ifpeek(w)and2thensyscl,1:sysline,(1+x)*m,r,(1+x)*m,(1+y)*m:goto258
256 syscl,0:sysline,(1+x)*m,r+1,(1+x)*m,(1+y)*m-1
258 ifpeek(w)and4thensyscl,1:sysline,(1+x)*m,(1+y)*m,q,(1+y)*m:goto262
260 syscl,0:sysline,(1+x)*m-1,(1+y)*m,q+1,(1+y)*m
262 ifpeek(w)and8thensyscl,1:sysline,q,(1+y)*m,q,r:goto269
264 syscl,0:sysline,q,(1+y)*m-1,q,r+1
267 rem ifsc>(px*py)thenprint"stackoverflow":goto990:rem stack overflow; cant happen anymore
269 pokep+s,peek(p+s)and31ore*32:s=s+1:ifs>xsthenxs=s:rem record max stack size
270 ifpeek(198)then400:rem getd$:ifd$<>""then420:rem key pressed?
280 goto100
399 rem maze done
400 tt=ti:t$=ti$:poke53280,0:rem record the time taken
410 getd$:ifd$=""then410:rem wait for a keypress
420 systext:poke53280,14:rem go back to text mode
430 print"time taken "tt,t$
435 print"max stack: "xs
440 end
799 rem make some cells visited for a logo
800 rem forx=2topy-2:v%(x,x)=1:v%(x+1,x)=1:next
810 rem fory=.topy:forx=.topx:printv%(x,y);:next:print:next:inputx
830 rem return
989 rem errors...
990 rem poke53280,2:rem red border means stack overflow
