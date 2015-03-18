# Latex Makefile for Lab2.tex
.PHONY: ProjectLab2 all clean

all: ProjectLab2

ProjectLab2: ProjectLab2.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make ProjectLab2.tex
	latexmk -c

clean:
	latexmk -CA

update: ProjectLab2
	mv ProjectLab2.pdf ../ProjectLab2.pdf
