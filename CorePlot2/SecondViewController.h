//
//  SecondViewController.h
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SecondViewController : UIViewController <CPTPieChartDelegate, CPTPieChartDataSource> {
	CPTXYGraph *pieChart;
	NSMutableArray *dataForChart;
	NSTimer *timer;
}

@property(readwrite, nonatomic, retain) NSMutableArray *dataForChart;
@property(readwrite, nonatomic, retain) NSTimer *timer;

- (void)timerFired;

@end
