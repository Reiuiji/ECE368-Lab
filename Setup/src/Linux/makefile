# Latex Makefile for Install_Linux.tex
.PHONY: Install_Linux.pdf all clean

all: Install_Linux.pdf

Install_Linux.pdf: Install_Linux.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Install_Linux.tex
	latexmk -c

clean:
	latexmk -CA

update:
	mv Install_Linux.pdf ../../Install_Linux.pdf
