# Latex Makefile for Lab3.tex
.PHONY: Lab3 all clean

all: Lab3

Lab3: Lab3.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Lab3.tex
	latexmk -c
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make KeyboardATP.tex
	latexmk -c

clean:
	latexmk -CA

update: Lab3
	mv Lab3.pdf ../Lab3.pdf
	mv KeyboardATP.pdf ../Keyboard/KeyboardATP.pdf
