# Latex Makefile for Lab1.tex
.PHONY: Lab1.pdf all clean

all: Lab1.pdf

Lab1.pdf: Lab1.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Lab1.tex
	latexmk -c

clean:
	latexmk -CA

update: Lab1.pdf
	mv Lab1.pdf ../Lab1.pdf
