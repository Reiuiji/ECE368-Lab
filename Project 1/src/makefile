# Latex Makefile for Lab2.tex
.PHONY: ProjectLab1 all clean

all: ProjectLab1

ProjectLab1: ProjectLab1.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make ProjectLab1.tex
	latexmk -c

clean:
	latexmk -CA

update: ProjectLab1
	mv ProjectLab1.pdf ../ProjectLab1.pdf
