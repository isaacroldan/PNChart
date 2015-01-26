//
//  PNPieChart.h
//  PNChartDemo
//
//  Created by Hang Zhang on 14-5-5.
//  Copyright (c) 2014年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNPieChartDataItem.h"

@interface PNPieChart : UIView

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic) NSArray *items;

/** Default is 18-point Avenir Medium. */
@property (nonatomic) UIFont  *descriptionTextFont;

/** Default is white. */
@property (nonatomic) UIColor *descriptionTextColor;

/** Default is black, with an alpha of 0.4. */
@property (nonatomic) UIColor *descriptionTextShadowColor;

/** Default is CGSizeMake(0, 1). */
@property (nonatomic) CGSize   descriptionTextShadowOffset;

/** Default is 1.0. */
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) UIFont *fontForInnerDescriptionText;
@property (nonatomic) UIFont *fontForInnerDescriptionNumber;
@property (nonatomic) UIFont *fontForDetailItemText;
@property (nonatomic) UIFont *fontForDetailItemNumber;
@property (nonatomic) NSString *innerDescriptionText;

- (void)strokeChart;

@end
