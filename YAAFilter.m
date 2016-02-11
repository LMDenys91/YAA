//
//  YAAFilter.m
//  YAA
//
//  Copyright (c) 2016 Lucas. All rights reserved.
//

#import "YAAFilter.h"

@implementation YAAFilter


- (void) initPlugin
{
    // Make copy of original image stack here?
}

- (long) filterImage:(NSString*) menuName
{
    NSArray *pixList = [viewerController pixList: 0];
    int curSlice = [[viewerController imageView] curImage];
    self.originalPix = [[pixList objectAtIndex: curSlice] copy];
    [NSBundle loadNibNamed:@"Slider" owner:self];
    [NSApp beginSheet: window modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];
    self.slider.maxValue = [pixList count];
    
    return 0;
}

- (IBAction)sliderValueChanged:(id)sender {
    self.compressionFactor.stringValue = [NSString stringWithFormat:@"%i", self.slider.intValue];
   // [self restoreDCM:self.originalPix];
    [viewerController needsDisplayUpdate];
}


- (IBAction)compressImage:(id)sender
{
    
    ViewerController *new2DViewer = [self duplicateCurrent2DViewerWindow];
    float *fImage; // Grey Image
    int compFactor = self.slider.intValue; // Compression factor
    
    NSArray *pixList = [new2DViewer pixList: 0];
    int amountOfImages = [pixList count];
    int imagesPerSample = amountOfImages / compFactor;
    int curSlice = [[new2DViewer imageView] curImage];
    DCMPix *curPix = [pixList objectAtIndex: curSlice];
    
    // Number of Pixels
    int curPos = [curPix pheight] * [curPix pwidth];
    
    // Display a waiting window
    // id waitWindow = [viewerController startWaitWindow:@"Working..."];
    
    
    fImage = [curPix fImage];
    // Initiate a NSArray with the neighboring DCMPix
    NSArray *neighbors = [NSArray array];
    for(int index = MAX(0,curSlice-imagesPerSample/2); index < MIN(curSlice + imagesPerSample/2 - 1, amountOfImages); index++)
    {
        //[viewerController setImageIndex: index];
        neighbors = [neighbors arrayByAddingObject:[pixList objectAtIndex: index]];
    }
    //[viewerController setImageIndex:curSlice];
    while ( curPos--> 0 )
    {
        float GreyValue = fImage[curPos];
        // Iterate over Neighboring DCMPix to calculate the avg for each position
        for (int i = 0; i < [neighbors count]; i++)
        {
            DCMPix *current_Pix = [neighbors objectAtIndex:i];
            float *current_fImage = [current_Pix fImage];
            GreyValue += current_fImage[curPos];
        }
        
        // Writing Pixel
        fImage[curPos] = GreyValue/imagesPerSample;
    }
    
    // if you've changed pixel values,
    // don't forget to update the display
    
    [new2DViewer needsDisplayUpdate];
    
}

//- (void) restoreDCM: (DCMPix*)originalDCM
//{
//    NSArray *pixList = [viewerController pixList: 0];
//    int curSlice = [[viewerController imageView] curImage];
//    DCMPix *curPix = [pixList objectAtIndex: curSlice];
//    int curPos = [curPix pheight] * [curPix pwidth];
//    float *fImage = [curPix fImage];
//    float *originalImage = [originalDCM fImage];
//    
//    while ( curPos--> 0 )
//    {
//        fImage[curPos] = originalImage[curPos];
//    }
//    [viewerController needsDisplayUpdate];
//}

- (IBAction) closeDialog:(id)sender
{
    [window orderOut:sender];
    [NSApp endSheet:window returnCode:[sender tag]];
    
    if( [sender tag] == 1)   // User clicks Close Button
    {
        // Restore the original image.
       // [self restoreDCM:self.originalPix];
        
    }
}

@end
