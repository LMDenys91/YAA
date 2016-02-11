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
    self.slider.maxValue = 256;
    
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
    int compFactor = self.slider.intValue; // Compression factor: the amount of averages that need to be calculated.
    
    NSArray *pixList = [new2DViewer pixList: 0];
    int curSlice = [[new2DViewer imageView] curImage];
    DCMPix *curPix = [pixList objectAtIndex: curSlice];
    float *fImage = [curPix fImage];
    int curPos;
    int pixelsInAvg = [curPix pheight] / compFactor;
    
    for (int width = 0; width < [curPix pwidth]; width ++) {
         for (int avgIndex = 0; avgIndex < compFactor; avgIndex ++) {
             float avg = 0;
             int partHeight = MIN(pixelsInAvg,[curPix pheight] - avgIndex * pixelsInAvg);
             for (int i = 0; i < partHeight; i++) {
                 curPos = width + [curPix pwidth] * (avgIndex * pixelsInAvg + i);
                 avg += fImage[curPos];
             }
             avg = avg / partHeight;
             for (int i = 0; i < partHeight; i++) {
                 curPos = width + [curPix pwidth] * (avgIndex * pixelsInAvg + i);
                 fImage[curPos] = avg;
             }
             //curPos = height * [curPix pwidth] + width;
             
        }
    }
    
    [new2DViewer needsDisplayUpdate];
    
}

- (IBAction) closeDialog:(id)sender
{
    [window orderOut:sender];
    [NSApp endSheet:window returnCode:[sender tag]];
    
    if( [sender tag] == 1)   // User clicks Close Button
    {
        
    }
}

@end
