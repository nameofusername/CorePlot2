//
//  FirstViewController.h
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FirstViewController : UIViewController <CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDataSource> {
	CPTXYGraph *graph;
	NSMutableArray *dataForPlot;
	NSMutableArray *xValues;
	
	CPTScatterPlot *scatterPlotWithSymbol;
	CPTXYAxis *selectionAxis;
	NSUInteger selectedPointIndex;
	id clickerDelegate;
	CGPoint prevTouchPoint;
}

@property(readwrite, nonatomic, retain) NSMutableArray *dataForPlot;
@property(nonatomic, assign) id clickerDelegate;

@end
