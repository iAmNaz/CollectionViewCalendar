//
//  ViewController.m
//  CalendarCollectionView
//
//  Created by JMariano on 10/16/14.
//  Copyright (c) 2014 JMariano. All rights reserved.
//

#import "ViewController.h"
#import "CalendarCollectionView-Swift.h"



@interface ViewController ()
{
    CGFloat cellSide;
    NSInteger dayOfFirstDay;
    NSInteger firstDayIndex;
    NSInteger daysInMonth;
    NSInteger date;
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    SmallCalendar *smallCalendar = [[SmallCalendar alloc]init];
//    //0, 156, 320, 257
//    CGRect frame = CGRectMake(0, 0, 320, 257);
//    MonthCalendar *calendar = [[MonthCalendar alloc] init];
//    calendar.frame = frame;
//    calendar.backgroundColor = [UIColor orangeColor];
//    
//    [calendar configureCalendar:[NSDate date] aCalendarConfig:smallCalendar];
//    [self.view addSubview:calendar];
}



@end
