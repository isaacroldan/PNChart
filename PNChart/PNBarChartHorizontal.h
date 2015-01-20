//
//  PNBarChartHorizontal.h
//  PNChartDemo
//
//  Created by Isaac Roldan on 20/1/15.
//  Copyright (c) 2015 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNBar.h"

#define xLabelMargin 15
#define yLabelMargin 15
#define yLabelHeight 11
#define xLabelHeight 20

typedef NSString *(^PNYLabelFormatter)(CGFloat yLabelValue);

@interface PNBarChartHorizontal : UIView

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;
@property (nonatomic) NSArray *barTitles;

@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;


/** Update Values. */
- (void)updateChartData:(NSArray *)data;
- (void)setBarTitles:(NSArray*)titles;

/** Formats the ylabel text. */
@property (copy) PNYLabelFormatter yLabelFormatter;

@property (nonatomic) CGFloat chartMargin;

/** Corner radius for all bars in the chart. */
@property (nonatomic) CGFloat barRadius;

/** Width of all bars in the chart. */
@property (nonatomic) CGFloat barHeight;

/** Background color of all bars in the chart. */
@property (nonatomic) UIColor * barBackgroundColor;

/** Text color for all bars in the chart. */
@property (nonatomic) UIColor * labelTextColor;

/** Font for all bars in the chart. */
@property (nonatomic) UIFont * labelFont;

/** The maximum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMaxValue;

/** The minimum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMinValue;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

@property (nonatomic) CGFloat barSeparation;

@end
