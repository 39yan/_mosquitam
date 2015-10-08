//
//  AlermViewController.m
//  mosquit
//
//  Created by Cosaki on 2015/10/03.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import "AlermViewController.h"

@interface AlermViewController ()

@end

@implementation AlermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"1.%f秒後にアラームが鳴るらしい", self.countdown);
    // Do any additional setup after loading the view.
    
    //Slider
    slider.maximumValue = 20000.0f;
    slider.minimumValue = 0.0f;
    slider.value = 10000.0f;
    int number = (int)slider.value;
//    label.text = [NSString stringWithFormat:@"%d", number];
    NSLog(@"周波数は%d",number);
//
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        // 遷移ロジック
//    });
}

- (IBAction)changeFrequency:(UISlider *)sender
{
    //周波数（音程）
    self.frequency = sender.value;
    label.text = [NSString stringWithFormat:@"%.1f", self.frequency];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"2.%f秒後にアラームが鳴るらしい", self.countdown);
    [super viewDidAppear:animated];
    
    NSTimer *alermCount = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target:self
                                                selector:@selector(timeAlerm)
                                                userInfo:nil
                                                 repeats:YES];
    [alermCount fire];
}

-(void)timeAlerm{
    
    self.countdown -= 1;
    NSLog(@"countdown == %f", self.countdown);
//    NSString *str = [self.countdown isValid] ? @"yes" : @"no";
    
    if ((self.countdown = 0)) {
        if (!aU) {
            //Sampling rate
            self.sampleRate = 44100.0f;
            
            //Bit rate
            bitRate = 8;  // 8bit
            
            //AudioComponentDescription
            AudioComponentDescription aCD;
            aCD.componentType = kAudioUnitType_Output;
            aCD.componentSubType = kAudioUnitSubType_RemoteIO;
            aCD.componentManufacturer = kAudioUnitManufacturer_Apple;
            aCD.componentFlags = 0;
            aCD.componentFlagsMask = 0;
            
            //AudioComponent
            AudioComponent aC = AudioComponentFindNext(NULL, &aCD);
            AudioComponentInstanceNew(aC, &aU);
            AudioUnitInitialize(aU);
            
            //コールバック
            AURenderCallbackStruct callbackStruct;
            callbackStruct.inputProc = renderer;
            callbackStruct.inputProcRefCon = (__bridge void*)self;
            AudioUnitSetProperty(aU,
                                 kAudioUnitProperty_SetRenderCallback,
                                 kAudioUnitScope_Input,
                                 0,
                                 &callbackStruct,
                                 sizeof(AURenderCallbackStruct));
            
            //AudioStreamBasicDescription
            AudioStreamBasicDescription aSBD;
            aSBD.mSampleRate = _sampleRate;
            aSBD.mFormatID = kAudioFormatLinearPCM;
            aSBD.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
            aSBD.mChannelsPerFrame = 2;
            aSBD.mBytesPerPacket = sizeof(AudioUnitSampleType);
            aSBD.mBytesPerFrame = sizeof(AudioUnitSampleType);
            aSBD.mFramesPerPacket = 1;
            aSBD.mBitsPerChannel = bitRate * sizeof(AudioUnitSampleType);
            aSBD.mReserved = 0;
            
            //AudioUnit
            AudioUnitSetProperty(aU,
                                 kAudioUnitProperty_StreamFormat,
                                 kAudioUnitScope_Input,
                                 0,
                                 &aSBD,
                                 sizeof(aSBD));
            
            //再生
            AudioOutputUnitStart(aU);
            
        
        }   //else if (/*stopをさせる動作がきたら*/){
            // //音を止めた時の処理
            // AudioOutputUnitStop(aU);
            // aU = nil;
            //}

    }
}

// ここから括弧
static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData) {
    
    //キャスト
    AlermViewController *def = (__bridge AlermViewController*)inRef;
    
    //サイン波
    float freq = def.frequency*2.0*M_PI/def.sampleRate;
    
    //値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phase);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outL++ = sample;
        *outR++ = sample;
        def.phase += freq;
    }
    
    return noErr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
