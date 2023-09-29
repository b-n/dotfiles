let g:abolish_save_file = expand('<sfile>')

cabbrev grpe grep
cabbrev Ggrpe Ggrep
cabbrev GIt Git

if !exists(":Abolish")
  finish
endif

Abolish delimeter{,s}                         delimiter{}
Abolish despara{te,tely,tion}                 despera{}
Abolish gaurantee{,s,d}                       guarantee{}
Abolish lastest                               latest
Abolish persistan{ce,t,tly}                   persisten{}
Abolish referesh{,es}                         refresh{}
Abolish receive{,s}                           recieve{}
Abolish seperat{e,es,ed,ing,ely,ion,ions,or}  separat{}
