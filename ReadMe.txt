Compiler:
Matlab 64 bit mcc compilor, in main.m
To run:
Requirement: select the Images_P2 when pop up window
Result: 
1.Euclidean distance to mean descriptor
2.predict result of testing images

Code structure:
main.m: calculate hog features in Training and Testing set
       Train the linear classifier and test
hog_WCX.m: compute hog features of input image
linear_classifier_WCX: customer-class for train and predict with 2-class linear classifier
normalize_L2_WCX.m: normalize feature vector with L2 method
cut_and_convert_WCX: cut the image to [128 64], transfer RGB to Grayscale
correlation_WCX: helper function to conduct correlation between matrix