//
//  ViewController.m
//  mosquit
//
//  Created by Cosaki on 2015/10/03.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myClock.delegate = self;        //delegate
    
//    self.myClock.realTime = YES;         //秒針
    self.myClock.currentTime = YES;      //読み込んだ時の時間＝初期設定
    self.myClock.setTimeViaTouch = YES;  //いじれる！！！
    self.myClock.enableDigit = YES;      //数字の表示
    self.myClock.militaryTime = YES;     //24時間表記
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes Seconds:(NSString *)seconds{
    hour = hours.intValue;
    minute = minutes.intValue;
    
    NSLog(@"Hours : %@",hours);
    NSLog(@"Minutes : %@",minutes);
    NSLog(@"Seconds : %@",seconds);
}

-(double)getNowUnixTime{
    return [self convertUnixTimeFromDate:[NSDate new]];
}

-(double)getSetUnixTime{
    NSDate *setDate = [NSDate date];
    NSDateComponents *comps;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:setDate];
    NSDateComponents *new_comps = [[NSDateComponents alloc] init];
    [new_comps setYear:comps.year];
    [new_comps setMonth:comps.month];
    [new_comps setDay:comps.day];
    [new_comps setHour:hour];
    [new_comps setMinute:minute];
    [new_comps setSecond:00];
    setDate = [calendar dateFromComponents:new_comps];
    
    return [self convertUnixTimeFromDate:setDate];
}

- (IBAction)setAlerm:(UIButton *)sender {
    //アラームをセット
    countdown = [self getSetUnixTime] - [self getNowUnixTime];
    NSLog(@"現在時刻：%f",[self getNowUnixTime]);
    NSLog(@"セット時刻：%f",[self getSetUnixTime]);
    NSLog(@"%f秒後にアラーム",countdown);
    
//    if (countdown<0) {
//        countdown = countdown + 86400;
//    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 5分後に通知をする（設定は秒単位）
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:countdown];
    // タイムゾーンの設定
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知時に表示させるメッセージ内容
    notification.alertBody = @"アラーム";
    // 通知に鳴る音の設定
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
    //移動
    [self performSegueWithIdentifier:@"set" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"set"]) {
        AlermViewController *alermView = [segue destinationViewController];
        alermView.countdown = countdown;
    }
}

- (double)convertUnixTimeFromDate:(NSDate *)date
{
    double unixtime = [date timeIntervalSince1970];
    
    return unixtime;
}

@end
