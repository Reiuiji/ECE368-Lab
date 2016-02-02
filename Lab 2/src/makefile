# Latex Makefile for Lab2.tex
.PHONY: Lab2.pdf all clean

all: Lab2.pdf

Lab2.pdf: Lab2.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Lab2.tex
	latexmk -c

clean:
	latexmk -CA

update: Lab2.pdf
	mv Lab2.pdf ../Lab2.pdf
