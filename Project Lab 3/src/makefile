# Latex Makefile for Lab2.tex
.PHONY: ProjectLab3 all clean

all: ProjectLab3

ProjectLab3: ProjectLab3.tex
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make ProjectLab3.tex
	latexmk -c

clean:
	latexmk -CA

update: ProjectLab3
	mv ProjectLab3.pdf ../ProjectLab3.pdf
