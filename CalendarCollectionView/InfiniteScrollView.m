//
//  InfiniteScrollView.m
//  CalendarCollectionView
//
//  Created by JMariano on 10/20/14.
//  Copyright (c) 2014 JMariano. All rights reserved.
//

#import "InfiniteScrollView.h"
#import "CalendarCollectionView-Swift.h"

typedef enum {
    Increment,
    Decrement,
    None
} Direction;

@interface InfiniteScrollView()
{
    NSMutableArray *visibleObjects;
    UIView *containerView;
    NSDate *currentDate;
}
@end
@implementation InfiniteScrollView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.contentSize = CGSizeMake(5000, self.bounds.size.height);
        //self.pagingEnabled = YES;
        [self setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
        visibleObjects = [[NSMutableArray alloc]init];
        containerView = [[UIView alloc]init];
        containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        currentDate = [NSDate date];
        [self addSubview:containerView];
        
    }
    return self;
}

-(void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter >  (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);

        // move content by the same amount so it appears to stay still
        for (UIView *label in visibleObjects) {
            CGPoint center = [containerView convertPoint:label.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [self convertPoint:center toView:containerView];
        }
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];
    
    CGRect visibleBounds = [self convertRect:[self bounds] toView:containerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileLabelsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];

}

- (MonthCalendar *)insertLabel:(Direction)direction
{
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    MonthCalendar *calendar = [[MonthCalendar alloc] init];
    calendar.frame = frame;
    calendar.backgroundColor = [UIColor orangeColor];
    SmallCalendar *smallCalendar = [[SmallCalendar alloc]init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    
    if (direction == Increment) {
        comps.month += 1;
    }else if(direction == Decrement){
        comps.month -= 1;
    }
    
    currentDate = [cal dateFromComponents:comps];
    
    [calendar configureCalendar:currentDate aCalendarConfig:smallCalendar];
    [containerView addSubview:calendar];
    
    return calendar;
}

- (CGFloat)placeNewLabel:(CGFloat)rightEdge
{
    MonthCalendar *label = [self insertLabel: None];
    [visibleObjects addObject:label]; // add rightmost label at the end of the array
    
    CGRect frame = [label frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [containerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnRight:(CGFloat)rightEdge
{
    MonthCalendar *label = [self insertLabel: Increment];
    [visibleObjects addObject:label]; // add rightmost label at the end of the array
    
    CGRect frame = [label frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [containerView bounds].size.height - frame.size.height;
    [label setFrame:frame];

    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnLeft:(CGFloat)leftEdge
{
    MonthCalendar *label = [self insertLabel: Decrement];
    [visibleObjects insertObject:label atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [label frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = [containerView bounds].size.height - frame.size.height;
    [label setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([visibleObjects count] == 0)
    {
        [self placeNewLabel:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    MonthCalendar *lastLabel = [visibleObjects lastObject];
    
    lastLabel.backgroundColor = [UIColor orangeColor];
    CGFloat rightEdge = CGRectGetMaxX([lastLabel frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewLabelOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    MonthCalendar *firstLabel = visibleObjects[0];
    CGFloat leftEdge = CGRectGetMinX([firstLabel frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastLabel = [visibleObjects lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX)
    {
        [lastLabel removeFromSuperview];
        [visibleObjects removeLastObject];
        lastLabel = [visibleObjects lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstLabel = visibleObjects[0];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX)
    {
        [firstLabel removeFromSuperview];
        [visibleObjects removeObjectAtIndex:0];
        firstLabel = visibleObjects[0];
    }
}

@end
