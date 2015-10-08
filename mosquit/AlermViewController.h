//
//  AlermViewController.h
//  mosquit
//
//  Created by Cosaki on 2015/10/03.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);



@interface AlermViewController : UIViewController
{
    AudioUnit aU;
    UInt32 bitRate;
    
    IBOutlet UILabel *label;
    IBOutlet UISlider *slider;
}

@property (nonatomic) double phase;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) Float64 frequency;



@property (nonatomic,assign)double countdown;

@end
