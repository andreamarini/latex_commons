SIL   := -silent
ifeq ($(VERB),1)
  SIL := 
endif
#=========================================================
LATEXMK := latexmk
ERR   := -file-line-error 
INT   := -interaction=nonstopmode
OPTS  := -pdf -pdflatex="pdflatex $(INT) $(ERR)" $(SIL) -f
BASE  := /home/marini/Papers_and_Results
DROP  := " "
BIB   := paper.bib
PAPER := paper.tex
POSTER:= poster.tex
SUPP  := SM.tex
arxive:= arxive.tex
FIGS  := " "

#=========================================================
#make stuff
#=========================================================
default:paper
help:
	@echo " "
	@echo " [main] Compilation of $(PAPER)"
	@if test -f $(SUPP); then echo " [sm] Compilation of $(SUPP)"; fi
	@if test -f $(arxive); then echo " [arxive] Compilation of $(arxive)"; fi
	@if test -f $(POSTER); then echo " [poster] Compilation of $(POSTER)"; fi
	@echo " "
	@if test -d $(DROP); then echo " [dropbox] sync with $(DROP)"; fi
	@if test -f $(BASE)/bibliography.bib && test -f $(BIB); then echo " [bibsync] sync base bib with  $(BASE)/bibliography.bib";fi
	@echo " "
	@echo " [clean-no-git] Clean of files, without git support"
	@echo " [clean] Clean of files"
	@echo " [figs] Figures (tikz)"
	@echo " [dropbox] Dropbox"
	@echo " [length] Check length"
	@echo " "

poster: 
	@echo ${POSTER} | awk '{gsub(".tex",".pdf");print}'|xargs rm -f
	@$(LATEXMK) $(OPTS) $(POSTER)
	@$(LATEXMK) $(OPTS) $(POSTER)

length:
	@$(call check_length,$(PAPER))
paper:bib main
sync:dropbox bibsync
join:main sm
	@if test -f $(SUPP); then pdftk $(PAPER).pdf $(SM).pdf cat output JOINT.pdf;fi

dropbox:
	@if test -d $(DROP); then rsync -avz --exclude '*.aux' --exclude '*.log' --exclude '*.bbl' --exclude '*.blg' --exclude '*.zip' --exclude '*.spl' $(DROP) .; fi

bibsync:
	@if test -f $(BASE)/bibliography.bib; then cat $(BASE)/bibliography.bib > base.bib ; fi
bib: bibsync
	@if test ! -f local.bib; then echo "" > local.bib;fi
	@if test -f local.bib; then cat base.bib local.bib > $(BIB);fi

main:
	@echo ${PAPER} | awk '{gsub(".tex",".pdf");print}'|xargs rm -f
	@$(LATEXMK) $(OPTS) $(PAPER)
	@$(LATEXMK) $(OPTS) $(PAPER)

figs: $(FIGS)
 
sm:
	@if test -f $(SUPP); then echo ${SUPP} | awk '{gsub(".tex",".pdf");print}'|xargs rm -f; fi
	@if test -f $(SUPP); then $(LATEXMK) $(OPTS) $(SUPP); fi
	@if test -f $(SUPP); then $(LATEXMK) $(OPTS) $(SUPP); fi

arxive:
	@if test -f $(arxive); then $(LATEXMK) $(OPTS) $(arxive); fi
	@if test -f $(arxive); then $(LATEXMK) $(OPTS) $(arxive); fi

clean-no-git:
	@find -name '*.aux' -o -name '*.log' -o -name '*.bbl' -o -name '*.blg' -o -name '*.zip' -o -name '*.spl' | xargs -d '\n' rm -f

clean:
	@$(LATEXMK) -CA
	@(git ls-files --others| sed 's/\ /\\\ /'| xargs rm -f)

.SUFFIXES: .tikz .pdf

.tikz.pdf:
	cp $*.tikz $*.tex; lualatex -interaction=batchmode -halt-on-error $*.tex;\
	rm -f $*.tex $*.aux $*.log; \
	mv $$(basename $*.tikz | sed 's/\.tikz$$/.pdf/') Figs

define check_length
 awk -f conf/length.awk $(1)
endef
