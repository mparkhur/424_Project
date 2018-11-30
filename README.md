# Wavelet Video Compression

Video codec designed in MATLAB based on the wavelet transform and block-based motion estimation.

## Main Functions
The following functions are the only functions that the user needs to interact with. Please see function descriptions below.

```function Encoder(infile, outfile, numBins, isCIF)```

This function takes a .y video file and compresses it based on the users desired number of quantization bins.

#### infile
  A string value indicating the name of the video file you wish to compress. File must be .y 
  format and either QCIF or CIF.

#### outfile
  A string value indicating the name of the compressed output file.

#### numBins
  An integer indicating the number of bins in which to quantize the data. A higher number 
  results in higher video quality.

#### isCIF
  A boolean value indicating whether or not the infile is CIF format. True means infile is 
  CIF, false means the file is QCIF.

```function Decoder(infile, outfile)```

This function is the inverse of the above Encoder(...) function. This function will decompress the file produced above and write the results to a new .y file.


#### infile		
  A string value indicating the name of the compressed video file you wish to decompress. 
  This is the output file from the Encoder(...) function above.

#### outfile 		
  A string value indicating the name of the output video file. This will overwrite if outfile is 
  found.

## Additional Required Tools
The only additional MATLAB toolboxes needed to run this codec are the Communication Toolbox and the Wavelet Toolbox. More information can be found at these links:

https://www.mathworks.com/products/communications.html

https://www.mathworks.com/products/wavelet.html 
