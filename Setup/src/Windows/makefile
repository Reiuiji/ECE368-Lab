# Latex Makefile for Install_Win.tex
.PHONY: Install_Win.pdf all clean

all: Install_Win.pdf

Install_Win.pdf: Install_Win.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make Install_Win.tex
	latexmk -c

clean:
	latexmk -CA

update: Install_Win.pdf
	mv Install_Win.pdf ../../Install_Win.pdf
