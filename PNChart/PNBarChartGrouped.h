//
//  PNBarChartGrouped.h
//  PNChartDemo
//
//  Created by Isaac on 20/1/15.
//  Copyright (c) 2015 Isaac Roldán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNBar.h"

#define xLabelMargin 15
#define yLabelMargin 15
#define yLabelHeight 11
#define xLabelHeight 40
#define imageViewHeight 40

typedef NSString *(^PNYLabelFormatter)(CGFloat yLabelValue);

@interface PNBarChartGrouped : UIScrollView

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;

@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;


/** Update Values. */
- (void)updateChartData:(NSArray *)data;

/** Changes chart margin. */
@property (nonatomic) CGFloat yChartLabelWidth;

@property (nonatomic) CGFloat chartMargin;

/** Controls whether labels should be displayed. */
@property (nonatomic) BOOL showLabel;

/** Corner radius for all bars in the chart. */
@property (nonatomic) CGFloat barRadius;

/** Width of all bars in the chart. */
@property (nonatomic) CGFloat barWidth;

@property (nonatomic) CGFloat barHeight;

@property (nonatomic) CGFloat labelMarginTop;

/** Background color of all bars in the chart. */
@property (nonatomic) UIColor * barBackgroundColor;

@property (nonatomic) UIColor * barBackgroundColor2;

/** Text color for all bars in the chart. */
@property (nonatomic) UIColor * labelTextColor;

/** Font for all bars in the chart. */
@property (nonatomic) UIFont * labelFont;

/** The maximum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMaxValue;

/** The minimum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMinValue;

/** Controls whether each bar should have a gradient fill. */
@property (nonatomic) UIColor *barColorGradientStart;
@property (nonatomic) CGFloat deselectedBarAlpha;
@property (nonatomic) CGFloat barSeparation;
@property (nonatomic) int groupedElements;

@property (nonatomic, weak) id<PNChartDelegate> delegate;
@property (nonatomic, copy) void(^imageForImageViewAtIndex)(UIImageView*imageView, NSUInteger index);

- (void)activateGroupAtIndex:(NSUInteger)index;
- (void)disableAllGroups;


@end
