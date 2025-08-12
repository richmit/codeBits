
ALLTARG = template.c template.cpp template.cc template.f template.f77 template.f03 template.f08 template.f18 template.f90 template.f95 template.org top.R top.bash top.c top.cc top.clisp top.cmake top.cpp top.el top.elisp top.f03 top.f08 top.f18 top.f77 top.f90 top.f95 top.f top.h top.hh top.hpp top.html top.java top.js top.lisp top.mac top.make top.md top.org top.pde top.perl top.pl top.pov top.rb top.sh top.tex top.texi top.xhtml top.zsh top.net top.cir top.sub top.m template.m top.ps

all: $(ALLTARG)

clean: 
	rm -f $(ALLTARG)

template.c: body-template-CnCPP.txt 
	cp body-template-CnCPP.txt template.c

template.cpp: body-template-CnCPP.txt 
	cp body-template-CnCPP.txt template.cpp

template.cc: body-template-CnCPP.txt 
	cp body-template-CnCPP.txt template.cc

template.f90: body-template-f90.txt 
	cp body-template-f90.txt template.f90

template.f95: body-template-f90.txt 
	cp body-template-f90.txt template.f95

template.f03: body-template-f90.txt 
	cp body-template-f90.txt template.f03

template.f08: body-template-f90.txt 
	cp body-template-f90.txt template.f08

template.f18: body-template-f90.txt 
	cp body-template-f90.txt template.f18

template.f: body-template-f77.txt
	cp body-template-f77.txt template.f

template.f77: body-template-f77.txt
	cp body-template-f77.txt template.f77

top.ps: top-template-perc.txt
	sed 's/STDLANG/PostScript/; s/EMODE/PostScript/; 1i %!PS' < top-template-perc.txt > top.ps

top.org: ../../org-mode/genericOrgTemplate.org 
	grep -m 1 -B 100 '#.H.E.##' ../../org-mode/genericOrgTemplate.org > top.org

template.org: ../../org-mode/genericOrgTemplate.org 
	grep -m 1 -A 1000 '#.H.E.##' ../../org-mode/genericOrgTemplate.org | sed '1d' > template.org

top.tex: top-template-perc.txt 
	sed 's/STDLANG/LaTeX TeX/; s/EMODE/LaTeX/' < top-template-perc.txt > top.tex

top.texi: top-template-perc.txt 
	sed 's/STDLANG/TeXinfo/; s/EMODE/texinfo-mode/' < top-template-perc.txt > top.texi

top.m: top-template-perc-slim.txt 
	sed 's/STDLANG/octave matlab_2022b/; s/EMODE/octave/' < top-template-perc-slim.txt > top.m

template.m: body-template-matlab.txt 
	cp body-template-matlab.txt template.m

top.html: top-template-html.txt 
	sed 's/STDLANG/HTML_2 2.0 HTML_3 HTML_3.2 HTML_4 HTML_4.0 HTML_4.01 HTML_5 HTML_5.1 HTML_5.2/'   < top-template-html.txt > top.html

top.xhtml: top-template-html.txt 
	sed 's/STDLANG/XHTML/' < top-template-html.txt > top.xhtml

top.md: top-template-html.txt 
	sed 's/STDLANG/github/'   < top-template-html.txt > top.md

top.el: top-template-semi.txt 
	sed 's/STDLANG/Emacs Lisp/; s/EMODE/emacs-lisp/' < top-template-semi.txt > top.el

top.elisp: top-template-semi.txt 
	sed 's/STDLANG/Emacs Lisp/; s/EMODE/emacs-lisp/' < top-template-semi.txt > top.elisp

top.lisp: top-template-semi.txt 
	sed 's/STDLANG/Common Lisp/; s/EMODE/Lisp/' < top-template-semi.txt > top.lisp

top.clisp: top-template-semi.txt 
	sed 's/STDLANG/Common Lisp/; s/EMODE/Lisp/' < top-template-semi.txt > top.clisp

top.mrscpi: top-template-pound.txt 
	sed 's/INTERP/mrSCPI.rb/; s/STDLANG/mrscpi/; s/EMODE/mrscpi/'   < top-template-pound.txt > top.mrscpi

top.sh: top-template-pound.txt 
	sed 's/INTERP/sh/; s/STDLANG/POSIX sh/; s/EMODE/Shell-script/' < top-template-pound.txt > top.sh

top.bash: top-template-pound.txt 
	sed 's/INTERP/bash/; s/STDLANG/bash/; s/EMODE/Shell-script/'   < top-template-pound.txt > top.bash

top.R: top-template-pound.txt 
	sed 's/INTERP/Rscript/; s/STDLANG/GNU-R/; s/EMODE/ess-r/'   < top-template-pound.txt > top.R

top.zsh: top-template-pound.txt 
	sed 's/INTERP/zsh/; s/STDLANG/zsh/; s/EMODE/Shell-script/'     < top-template-pound.txt > top.zsh

top.rb: top-template-pound.txt 
	sed 's/INTERP/ruby/; s/STDLANG/Ruby 1.8 1.9 2 3/; s/EMODE/ruby/; s/Coding:us-ascii-unix/Coding:us-ascii/;' < top-template-pound.txt > top.rb

top.perl: top-template-pound.txt
	sed 's/INTERP/perl/; s/STDLANG/Perl4 Perl5 Perl6/; s/EMODE/Perl/' 	 < top-template-pound.txt > top.perl

top.sed: top-template-pound.txt
	sed 's/INTERP/sed/; s/STDLANG/GNU sed/; s/EMODE/text/' 	 < top-template-pound.txt > top.sed

top.gplt: top-template-pound.txt
	sed 's/INTERP/gnuplot/; s/STDLANG/GNUplot/; s/EMODE/text/' 	 < top-template-pound.txt > top.gplt

top.pl: top-template-pound.txt
	sed 's/INTERP/perl/; s/STDLANG/Perl4 Perl5 Perl6/; s/EMODE/Perl/' 	 < top-template-pound.txt > top.pl

top.make: top-template-pound.txt 
	sed '/INTERP/d; s/STDLANG/GNUmake BSDmake SYSVmake GenericMake/; s/EMODE/make/' < top-template-pound.txt > top.make

top.cmake: top-template-pound.txt 
	sed '/INTERP/d; s/STDLANG/cmake/; s/EMODE/cmake/' < top-template-pound.txt > top.cmake

top.cpp: top-template-cpp.txt 
	sed 's/STDLANG/C++23 C++20 C++17 C++14 C++11 C++98 ATTC++ GCC++/; s/EMODE/C++/' < top-template-cpp.txt > top.cpp

top.pov: top-template-cpp.txt 
	sed 's/STDLANG/Povray_3.1 Povray_3.5 Povray_3.7/; s/EMODE/pov/' < top-template-cpp.txt > top.pov

top.hpp: top-template-cpp.txt 
	sed 's/STDLANG/C++98 C++11 C++14 ATTC++ GCC++/; s/EMODE/C++/' < top-template-cpp.txt > top.hpp

top.js: top-template-cpp.txt 
	sed 's/STDLANG/ECMAScript_5 Nashorn ECMAScript_5.1 ECMAScript_2015 ECMAScript_2016 ECMAScript_2017 ECMAScript_2018 GraalVM ECMAScript_2019/; s/EMODE/javascript/' < top-template-cpp.txt > top.js 

top.json: top-template-cpp.txt 
	sed 's/STDLANG/JSON/; s/EMODE/javascript/' < top-template-cpp.txt > top.json 

top.hh: top-template-cpp.txt 
	sed 's/STDLANG/C++98 C++11 C++14 ATTC++ GCC++/; s/EMODE/C++/' < top-template-cpp.txt > top.hh

top.cc: top-template-cpp.txt 
	sed 's/STDLANG/C++98 C++11 C++14 ATTC++ GCC++/; s/EMODE/C++/' < top-template-cpp.txt > top.cc

top.java: top-template-cpp.txt 
	sed 's/STDLANG/Java 1 2 3 4 5 6 7 8/; s/EMODE/Java/' < top-template-cpp.txt > top.java

top.pde: top-template-cpp.txt 
	sed 's/STDLANG/Processing/; s/EMODE/Java/' < top-template-cpp.txt > top.pde

top.h: top-template-c.txt 
	sed 's/STDLANG/C89 C99 C11 ISOC GCC K\&RC/; s/EMODE/C/' < top-template-c.txt > top.h

top.c: top-template-c.txt 
	sed 's/STDLANG/C89 C99 C11 ISOC GCC K\&RC/; s/EMODE/C/' < top-template-c.txt > top.c

top.mac: top-template-c.txt 
	sed 's/STDLANG/maxima/; s/EMODE/maxima/' < top-template-c.txt > top.mac

top.f77: top-template-f77.txt 
	cp top-template-f77.txt top.f77

top.f: top-template-f77.txt 
	cp top-template-f77.txt top.f

top.f90: top-template-f90.txt
	cp top-template-f90.txt top.f90

top.f95: top-template-f90.txt 
	sed 's/F90 F95 F2003 F2008 F2018/F95/' < top-template-f90.txt > top.f95

top.f03: top-template-f90.txt 
	sed 's/F90 F95 F2003 F2008 F2018/F2003/' < top-template-f90.txt > top.f03

top.f08: top-template-f90.txt 
	sed 's/F90 F95 F2003 F2008 F2018/F2008/' < top-template-f90.txt > top.f08

top.f18: top-template-f90.txt 
	sed 's/F90 F95 F2003 F2008 F2018/F2018/' < top-template-f90.txt > top.f18

top.net: top-template-star.txt 
	sed 's/STDLANG/xyce ngspice LTSpice SPICE/; s/EMODE/spice/' < top-template-star.txt > top.net

top.cir: top-template-star.txt 
	sed 's/STDLANG/xyce ngspice LTSpice SPICE/; s/EMODE/spice/' < top-template-star.txt > top.cir

top.sub: top-template-star.txt 
	sed 's/STDLANG/xyce ngspice LTSpice SPICE/; s/EMODE/spice/' < top-template-star.txt > top.sub

