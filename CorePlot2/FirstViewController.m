//
//  FirstViewController.m
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize dataForPlot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"First", @"First");
		self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Plot Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return [dataForPlot count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX) ? @"x" : @"y"];
	
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"]) {
		if (fieldEnum == CPTScatterPlotFieldY) {
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
		}
	}
	return num;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
	[graph applyTheme:theme];
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.collapsesLayers = NO;
	hostingView.hostedGraph = graph;
	
	graph.paddingLeft = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingBottom = 10.0;
	
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(2.0)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.2) length:CPTDecimalFromFloat(3.0)];
	
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth = 2.0f;
	lineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:0.5] CGColor]];
	
	CPTXYAxisSet *axesSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x = axesSet.xAxis;
	x.majorIntervalLength = CPTDecimalFromString(@"0.5");
	x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	x.minorTicksPerInterval = 2;
	x.axisLineStyle = lineStyle;
	x.majorTickLineStyle = lineStyle;
	x.majorTickLength = graph.frame.size.height;
	x.minorTickLineStyle = nil;
	x.tickDirection = CPTSignPositive;
	x.labelOffset = -graph.frame.size.height - 20;
	
	NSArray *exclusionRanges = [NSArray arrayWithObjects:
								[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.01) length:CPTDecimalFromFloat(0.02)], 
								[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99) length:CPTDecimalFromFloat(0.02)], 
								nil];
	x.labelExclusionRanges = exclusionRanges;
	
	CPTXYAxis *y = axesSet.yAxis;
	y.majorIntervalLength = CPTDecimalFromString(@"0.5");
	y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
	y.minorTicksPerInterval = 5;
	y.axisLineStyle = lineStyle;
	y.majorTickLineStyle = nil;
	y.minorTickLineStyle = nil;
	
	exclusionRanges = [NSArray arrayWithObjects:
					   [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.01) length:CPTDecimalFromFloat(0.02)], 
					   nil];
	y.labelExclusionRanges = exclusionRanges;
	
	CPTScatterPlot *boundLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
	lineStyle.miterLimit = 1.0f;
	lineStyle.lineColor = [CPTColor whiteColor];
	lineStyle.lineWidth = 2.0f;
	boundLinePlot.dataLineStyle = lineStyle;
	boundLinePlot.identifier = @"Blue Plot";
	boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	
	
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	NSUInteger i;
	for (i = 0; i < 35; ++i) {
		id x = [NSNumber numberWithFloat:i * 0.05];
		id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.dataForPlot = contentArray;
}

- (void)viewDidUnload
{
	[graph release];
	[dataForPlot release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
	//return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ) {
		
	}
}

@end
