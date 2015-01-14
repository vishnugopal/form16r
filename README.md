# Introduction
Form16r is a tool to extract structured information from 
Indian Tax Return (Form 16) files.

Because of the various PDF converters used that seem to mangle 
text into unprintable chaos, Form16r works by first converting
the PDF file into an image, and then applying OCR on it to extract
text. This text is then fuzzy-matched to extract structured
information.

# Installation
You'll need to install the docsplit gem & its dependencies. See:
http://documentcloud.github.io/docsplit/

# Current Status
This is incomplete currently, you need to put a copy of your Form 16 into spec/fixtures and rename it "form16.pdf". Then run bin/form16r with the path to your PDF file.

Currently, it extracts the following features:
* Certificate Number
* Last Updated On