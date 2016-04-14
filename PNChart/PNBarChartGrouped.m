//
//  PNBarChartGrouped.m
//  PNChartDemo
//
//  Created by Isaac on 20/1/15.
//  Copyright (c) 2015 Isaac Roldán. All rights reserved.
//

#import "PNBarChartGrouped.h"
#import "PNColor.h"
#import "PNChartLabel.h"

static const CGFloat xLabelHeight = 40;
static const CGFloat imageViewHeight = 40;

@interface PNBarChartGrouped () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_imageViews;
    NSUInteger numberOfRealElements;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end

@implementation PNBarChartGrouped


#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _barBackgroundColor  = PNLightGrey;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _xChartLabels        = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _imageViews          = [NSMutableArray array];
    _labelMarginTop      = 0;
    _chartMargin         = 15.0;
    _barRadius           = 2.0;
    _yChartLabelWidth    = 18;
    _groupedElements     = 1;
    _barSeparation       = 20;
    _barHeight           = 150;
    _deselectedBarAlpha  = 0.2;
    _minimumGroups       = 4;
    numberOfRealElements = 0;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)setYValues:(NSArray *)yValues
{
    numberOfRealElements = yValues.count/_groupedElements;
    _yValues = [self addEmptyValues:yValues];
    [self getYValueMax:yValues];
}

- (NSArray *)addEmptyValues:(NSArray *)yValues
{
    if (yValues.count >= _minimumGroups*2) return yValues;
    NSMutableArray *array = [NSMutableArray arrayWithArray:yValues];
    for (int i=0; i<(_minimumGroups*2-yValues.count); i++) {
        [array addObject:@0];
    }
    return [NSArray arrayWithArray:array];
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

- (void)setXLabels
{
    NSUInteger numberOfLabels = numberOfRealElements;
    for (int i = 0; i<numberOfLabels; i++) {
        PNBar *firstBar = [_bars objectAtIndex:i*_groupedElements];
        PNBar *lastBar = [_bars objectAtIndex:i*_groupedElements+_groupedElements-1];
        CGFloat origin = firstBar.frame.origin.x + (lastBar.frame.origin.x + lastBar.frame.size.width - firstBar.frame.origin.x)/2 - xLabelHeight/2 - 2;
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(origin, 0, xLabelHeight+4, xLabelHeight)];
        valueLabel.font = _labelFont;
        valueLabel.textColor = firstBar.barColor;;
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.text = [NSString stringWithFormat:@"%@",[_yValues objectAtIndex:(int)i*_groupedElements]];
        [_xChartLabels addObject:valueLabel];
        [self addSubview:valueLabel];
    }
    [self changeGroupedBarsAlpha:1 atIndex:0];
    [self changeGroupedBarsAlpha:_deselectedBarAlpha atIndex:1];
}

- (void)updateXLabelsForIndex:(NSUInteger)index
{
    for (UILabel *label in _xChartLabels) {
        label.hidden = NO;
        NSUInteger labelIndex = [_xChartLabels indexOfObject:label];
        label.textColor = _strokeColors[index];
        label.text = [NSString stringWithFormat:@"%@",[_yValues objectAtIndex:(NSUInteger)labelIndex*_groupedElements+index]];
    }
}

- (void)hideAllLabels
{
    for (UILabel *label in _xChartLabels) {
        label.hidden = YES;
    }
}

- (void)selectGroupedElementAtIndex:(NSUInteger)index
{
    index = index % _groupedElements;
    for (int i = 0 ; i<_xChartLabels.count; i++) {
        UILabel *label = _xChartLabels[i];
        label.textColor = _strokeColors[index];
        label.text = [NSString stringWithFormat:@"%@",[_yValues objectAtIndex:((int)i*_groupedElements+index)]];
    }
    [self changeGroupedBarsAlpha:1 atIndex:index];
    [self changeGroupedBarsAlpha:_deselectedBarAlpha atIndex:(index+1)%2];
}

- (void)changeGroupedBarsAlpha:(CGFloat)alpha atIndex:(NSUInteger)index
{
    for (int i = 0; i<_bars.count; i++) {
        if (i % _groupedElements == index) {
            PNBar *bar = _bars[i];
            bar.chartLine.strokeColor = [bar.barColor colorWithAlphaComponent:alpha].CGColor;
        }
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

- (void)updateBar
{
    
    //Add bars
    CGFloat chartCavanHeight = _barHeight;
    NSInteger index = 0;
    
    for (NSNumber *valueString in _yValues) {
        
        PNBar *bar;
        
        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barXPosition;
            PNBar *lastBar = [_bars lastObject];
            if (_barWidth) {
                barWidth = _barWidth;
                CGFloat stepSeparation = index % _groupedElements == 0 ? _barSeparation*14 : _barSeparation;
                barXPosition = !lastBar ? 4 : lastBar.frame.origin.x + lastBar.frame.size.width + stepSeparation;
            }else{
                barXPosition = index *  _xLabelWidth + _chartMargin + _xLabelWidth * 0.25;
                if (_showLabel) {
                    barWidth = _xLabelWidth * 0.5;
                    
                }
                else {
                    barWidth = _xLabelWidth * 0.6;
                    
                }
            }
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                          xLabelHeight, //Bar Y position
                                                          barWidth, // Bar witdh
                                                          chartCavanHeight)]; //Bar height
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Change Bar Background color
            bar.backgroundColor = index % _groupedElements == 0 ? _barBackgroundColor : _barBackgroundColor2;
            
            bar.alpha = index < numberOfRealElements*2 ? 1 : 0.2;
            
            
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            // Add gradient
            bar.barColorGradientStart = _barColorGradientStart;
            
            //For Click Index
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

- (void)setImageViews
{
    NSUInteger numberOfImages = MAX(numberOfRealElements, _minimumGroups);
    for (NSUInteger i = 0; i<numberOfImages; i++) {
        PNBar *firstBar = [_bars objectAtIndex:i*_groupedElements];
        PNBar *lastBar = [_bars objectAtIndex:i*_groupedElements+_groupedElements-1];
        CGFloat top = firstBar.frame.origin.y + firstBar.frame.size.height;
        CGFloat origin = firstBar.frame.origin.x + (lastBar.frame.origin.x + lastBar.frame.size.width - firstBar.frame.origin.x)/2 - imageViewHeight/2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(origin, top+10, imageViewHeight, imageViewHeight)];
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        [imageView setBackgroundColor:[UIColor colorWithWhite:246/255.0 alpha:1]];
        if (self.imageForImageViewAtIndex) {
            self.imageForImageViewAtIndex(imageView,i);
        };
        [_imageViews addObject:imageView];
        [self addSubview:imageView];
    }
}

- (void)strokeChart
{
    [self viewCleanupForCollection:_bars];
    [self viewCleanupForCollection:_imageViews];
    [self viewCleanupForCollection:_xChartLabels];
    [self regenerateYValues];
    [self updateBar];
    [self setImageViews];
    [self setXLabels];
    [self setScrollViewContentSize];
}

- (void)regenerateYValues
{
    NSArray *realElements = [_yValues subarrayWithRange:NSMakeRange(0, numberOfRealElements*2)];
    [self setYValues:realElements];
}

- (void)setScrollViewContentSize
{
    PNBar *firstBar = _bars.firstObject;
    PNBar *lastBar = _bars.lastObject;
    CGFloat width = firstBar.frame.origin.x + lastBar.frame.origin.x + lastBar.frame.size.width;
    [self setContentSize:CGSizeMake(width, self.frame.size.height)];
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
    if (self.strokeColors) {
        return self.strokeColors[index%_groupedElements];
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
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[PNBar class]] && [self.chartDelegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self selectGroupedElementAtIndex:subview.tag%_groupedElements];
        [self.chartDelegate userClickedOnBarAtIndex:subview.tag];
    }
}


#pragma mark - User Interaction

- (void)activateGroupAtIndex:(NSUInteger)index
{
    [self changeGroupedBarsAlpha:1 atIndex:index];
    [self changeGroupedBarsAlpha:_deselectedBarAlpha atIndex:(index+1)%2];
    [self updateXLabelsForIndex:index];
}

- (void)disableAllGroups
{
    [self changeGroupedBarsAlpha:1 atIndex:0];
    [self changeGroupedBarsAlpha:1 atIndex:1];
    [self hideAllLabels];
}


@end
