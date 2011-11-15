//
//  FirstViewController.h
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FirstViewController : UIViewController <CPTPlotDataSource> {
	CPTXYGraph *graph;
	NSMutableArray *dataForPlot;
}

@property(readwrite, nonatomic, retain) NSMutableArray *dataForPlot;

@end
