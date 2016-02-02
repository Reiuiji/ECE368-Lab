# Latex Makefile for Lab2.tex
.PHONY: Lab2 all clean

all: Lab2

Lab2: Lab2.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Lab2.tex
	latexmk -c
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make KeyboardATP.tex
	latexmk -c

clean:
	latexmk -CA

update: Lab2
	mv Lab2.pdf ../Lab2.pdf
	mv KeyboardATP.pdf ../Keyboard/KeyboardATP.pdf
