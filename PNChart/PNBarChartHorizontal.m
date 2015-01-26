//
//  PNBarChartHorizontal.m
//  PNChartDemo
//
//  Created by Isaac Roldan on 20/1/15.
//  Copyright (c) 2015 kevinzhow. All rights reserved.
//

#import "PNBarChartHorizontal.h"
#import "PNColor.h"
#import "PNChartLabel.h"


@interface PNBarChartHorizontal () {
    NSMutableArray *_valueLabels;
    NSMutableArray *_titleLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation PNBarChartHorizontal

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self setupDefaultValues];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setupDefaultValues];
    return self;
}

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _barBackgroundColor  = PNLightYellow;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _valueLabels         = [NSMutableArray array];
    _titleLabels         = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _chartMargin         = 15.0;
    _barRadius           = 4.0;
    _barHeight           = 25.0;
    _valueLabelFont      = [UIFont systemFontOfSize:11.0f];
    _barSeparation       = 15;
}

- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self getYValueMax:yValues];
    if (_valueLabels) [self viewCleanupForCollection:_valueLabels];
}

-(void)updateChartData:(NSArray *)data{
    self.yValues = data;
    [self updateBar];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    _yValueMax = [[yLabels valueForKeyPath:@"@max.intValue"] intValue];
    if (_yValueMax == 0)  _yValueMax = _yMinValue;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

- (void)updateBar
{
    NSInteger index = 0;
    for (NSNumber *valueString in _yValues) {
        PNBar *bar;
        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }
        else {
            CGFloat barHeight = 0.0;
            CGFloat barYPosition;
            PNBar *lastBar = [_bars lastObject];
            barHeight = _barHeight;
            barYPosition = lastBar.frame.origin.y + lastBar.frame.size.height + _barSeparation;
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(0, //Bar X position
                                                          barYPosition, //Bar Y position
                                                          self.frame.size.width, // Bar witdh
                                                          barHeight)]; //Bar height
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            bar.horizontal = YES;
            bar.backgroundColor = _barBackgroundColor;
            bar.barColor = self.strokeColor ? self.strokeColor : [self barColorAtIndex:index];
            bar.tag = index;
            [_bars addObject:bar];
            [self addSubview:bar];
        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        float grade = (float)value / (float)_yValueMax;
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.grade = grade;
        
        index += 1;
    }
}

- (void)addValueLabels
{
    for (int i = 0; i<_bars.count; i++) {
        PNBar *bar = _bars[i];
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.font = _valueLabelFont;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%@",[_yValues objectAtIndex:i]];
        valueLabel.alpha = 0;
        [valueLabel sizeToFit];
        CGFloat origin = MIN(self.frame.size.width - valueLabel.frame.size.width - 8, bar.grade*bar.frame.size.width);
        BOOL invertedColor = origin < bar.grade*bar.frame.size.width;
        valueLabel.frame = CGRectMake(origin+4, bar.frame.origin.y-1, valueLabel.frame.size.width, _barHeight);
        valueLabel.textColor = invertedColor ? [UIColor whiteColor] : bar.barColor;
        [_valueLabels addObject:valueLabel];
        [self addSubview:valueLabel];
    }
}

- (void)addBarTitles
{
    for (PNBar *bar in _bars) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = _labelFont;
        titleLabel.textColor = _labelTextColor;
        titleLabel.text = _barTitles[bar.tag];
        [titleLabel sizeToFit];
        [titleLabel setFrame:CGRectMake(0, bar.frame.origin.y-titleLabel.frame.size.height-2, titleLabel.frame.size.width, titleLabel.frame.size.height)];
        [_titleLabels addObject:titleLabel];
        [self addSubview:titleLabel];
    }
}

- (void)strokeChart
{
    [self viewCleanupForCollection:_bars];
    [self updateBar];
    [self addValueLabels];
    [self performSelector:@selector(showLabelsAnimated) withObject:nil afterDelay:1];
    [self addBarTitles];
}


- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}


#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}


- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
    }
}


#pragma mark - Animation Delegate

- (void)showLabelsAnimated
{
    [_valueLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [UIView animateWithDuration:0.2 animations:^(){
            [obj setAlpha:1];
        }];
    }];
}



@end
