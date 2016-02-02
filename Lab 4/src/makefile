# Latex Makefile for Lab4.tex
.PHONY: Lab4 all clean

all: Lab4

Lab4: Lab4.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Lab4.tex
	latexmk -c
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make KeyboardATP.tex
	latexmk -c

clean:
	latexmk -CA

update: Lab4
	mv Lab4.pdf ../Lab4.pdf
	mv KeyboardATP.pdf ../Keyboard/KeyboardATP.pdf
