//
//  ZAAFilter.h
//  ZAA
//
//  Copyright (c) 2016 Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@interface ZAAFilter : PluginFilter {
 IBOutlet NSWindow *window;
}

- (long) filterImage:(NSString*) menuName;

- (IBAction) compressImage: (id)sender;

- (IBAction) closeDialog:(id)sender;

@property (assign) IBOutlet NSSlider *slider;

@property (assign) IBOutlet NSButton *compressImageButton;

@property (assign) IBOutlet NSButton *closeWindowButton;

@property (assign) IBOutlet NSTextField *compressionFactor;

@property (strong) DCMPix *originalPix;

@end
