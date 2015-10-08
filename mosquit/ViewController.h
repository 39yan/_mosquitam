//
//  ViewController.h
//  mosquit
//
//  Created by Cosaki on 2015/10/03.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "AlermViewController.h"

@interface ViewController : UIViewController<BEMAnalogClockDelegate>{
    int hour;
    int minute;
    
    double countdown;
}
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock;
- (IBAction)setAlerm:(UIButton *)sender;


@end

