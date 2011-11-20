//
//  FirstViewController.m
//  CorePlot2
//
//  Created by Anton on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize dataForPlot, clickerDelegate;

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

- (NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
	NSMutableArray *nums = [NSMutableArray array];
	for (NSUInteger i = 0; i < indexRange.length; ++i) {
		NSNumber *num = [[dataForPlot objectAtIndex:i] valueForKey:(fieldEnum == CPTScatterPlotFieldX) ? @"x" : @"y"];
		[nums addObject:num];
	}
	return nums;
}

//- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
//{
//	NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX) ? @"x" : @"y"];
//	
//	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"]) {
//		if (fieldEnum == CPTScatterPlotFieldY) {
//			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
//		}
//	}
//	return num;
//}

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
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(40.0)];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2.0) length:CPTDecimalFromFloat(30.0)];
	
	plotSpace.allowsUserInteraction = YES;
	
	plotSpace.delegate = self;
	
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineWidth = 2.0f;
	lineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:0.5] CGColor]];
	
	CPTXYAxisSet *axesSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x = axesSet.xAxis;
	x.majorIntervalLength = CPTDecimalFromString(@"4");
	x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	x.minorTicksPerInterval = 0;
	x.axisLineStyle = lineStyle;
	x.majorTickLineStyle = nil; //lineStyle;
	//x.majorTickLength = graph.frame.size.height;
	//x.minorTickLineStyle = nil;
	x.labelOffset = -6;
	x.tickDirection = CPTSignNone;
	x.majorGridLineStyle = lineStyle;
	x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(30.0)];
	
	NSArray *exclusionRanges = [NSArray arrayWithObjects:
								[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.01) length:CPTDecimalFromFloat(0.02)], 
								[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(39.99) length:CPTDecimalFromFloat(0.02)], 
								nil];
	x.labelExclusionRanges = exclusionRanges;
	
	CPTXYAxis *y = axesSet.yAxis;
	y.majorIntervalLength = CPTDecimalFromString(@"3");
	y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"40");
	y.minorTicksPerInterval = 0;
	y.axisLineStyle = lineStyle;
	y.majorTickLineStyle = nil;
	//y.minorTickLineStyle = nil;
	y.majorGridLineStyle = lineStyle;
	y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(40.0)];
	y.labelAlignment = CPTAlignmentTop;

	
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
	scatterPlotWithSymbol = boundLinePlot;
	boundLinePlot.dataSource = self;
	[graph addPlot:boundLinePlot];
	
	NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
	xValues = [[NSMutableArray alloc] initWithCapacity:1000];
	NSUInteger i;
	for (i = 0; i < 190; ++i) {
		id x = [NSNumber numberWithFloat:i*0.18];
		id y = [NSNumber numberWithFloat:10.2 * rand() / (float)RAND_MAX + 10.2];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
		[xValues addObject:x];
	}
	self.dataForPlot = contentArray;
}

- (void)viewDidUnload
{
	[graph release];
	[dataForPlot release];
	[xValues release];
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

#pragma mark - CPTPlotSapceDelegate mathods

- (NSUInteger)selectedPointIndex:(NSDecimal)xCoord
{
#if 1
	if (scatterPlotWithSymbol != nil) {
		NSDecimalNumber *xCoordNum = [NSDecimalNumber decimalNumberWithDecimal:xCoord];
		//CPTScatterPlot *plot = (CPTScatterPlot *)[graph plotWithIdentifier:scatterPlotWithSymbol.identifier];
		for (NSUInteger i = 0; i < [xValues count]; ++i) {
			if ([[xValues objectAtIndex:i] compare:xCoordNum] == NSOrderedDescending) {
				return i;
			}
		}
		return [dataForPlot count] - 1;
	}
#endif
	return 1;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
	if (scatterPlotWithSymbol != nil) {
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
		
		prevTouchPoint = point;
		
		if (space == plotSpace) {
			CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
			selectionAxis = [[[CPTXYAxis alloc] init] autorelease];
			selectionAxis.coordinate = CPTCoordinateY;
			
			point.x -= 11;
			
			NSDecimal pt[2];
			[space plotPoint:pt forPlotAreaViewPoint:point];
			
			selectedPointIndex = [self selectedPointIndex:pt[0]];
			
			selectionAxis.orthogonalCoordinateDecimal = [[xValues objectAtIndex:selectedPointIndex] decimalValue];			
			CPTMutableLineStyle *ls = [axisSet.xAxis.axisLineStyle mutableCopy];
			ls.lineWidth = 3.0;
			
			CGColorRef color = [[UIColor colorWithRed:(16*16-9)/256.0 green:(12*16+9)/256.0 blue:(3*16+14)/256.0 alpha:1.0] CGColor];
			ls.lineColor = [CPTColor colorWithCGColor:color];
			selectionAxis.axisLineStyle = ls;
			[ls release];
			selectionAxis.plotSpace = plotSpace;
			selectionAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
			selectionAxis.visibleRange = axisSet.xAxis.gridLinesRange;
			
			axisSet.axes = [axisSet.axes arrayByAddingObject:selectionAxis];
#if 0
			CPTMutableTextStyle *ts = [[[CPTMutableTextStyle alloc] init] autorelease];
			ts.fontSize = 24;
			ts.fontName = @"Arial";
			ts.color = [CPTColor yellowColor];
			scatterPlotWithSymbol.labelTextStyle = ts;
			scatterPlotWithSymbol.labelFormatter = [[[NSNumberFormatter alloc] init] autorelease];
			[scatterPlotWithSymbol.labelFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
#endif	
			//[axisSet relabelAxes];
			[scatterPlotWithSymbol reloadData];
		}
	}
	return NO;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
#if 1
	if (scatterPlotWithSymbol != nil) {
		//CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		
		if (selectionAxis != nil) {
			point.x -= 11;
			
			NSDecimal pt[2];
			[space plotPoint:pt forPlotAreaViewPoint:point];
			
			selectedPointIndex = [self selectedPointIndex:pt[0]];
			
			selectionAxis.orthogonalCoordinateDecimal = [[xValues objectAtIndex:selectedPointIndex] decimalValue];
			//[axisSet relabelAxes];
			[scatterPlotWithSymbol reloadData];
		}
	}
#endif
	return NO;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceCancelledEvent:(id)event
{
	if (scatterPlotWithSymbol != nil) {
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		
		if ([axisSet.axes containsObject:selectionAxis]) {
			NSRange range;
			range.location = 0;
			range.length = 2;
			axisSet.axes = [axisSet.axes subarrayWithRange:range];
			selectionAxis = nil;
			//[axisSet relabelAxes];
			[scatterPlotWithSymbol reloadData];
		}
	}
	return NO;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
	if (scatterPlotWithSymbol != nil) {
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		
		if ([axisSet.axes containsObject:selectionAxis]) {
			NSRange range;
			range.location = 0;
			range.length = 2;
			axisSet.axes = [axisSet.axes subarrayWithRange:range];
			selectionAxis = nil;
			//[axisSet relabelAxes];
			[scatterPlotWithSymbol reloadData];
		}
	}
	return NO;
}

- (CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
	static CPTPlotSymbol *symbol = nil;
	if (symbol == nil) {
		symbol = [[CPTPlotSymbol ellipsePlotSymbol] retain];
		CGSize size;
		size.width = 10;
		size.height = 10;
		symbol.size = size;
		symbol.lineStyle = nil;
		CGColorRef color = [[UIColor colorWithRed:(16*16-9)/256.0 green:(12*16+9)/256.0 blue:(3*16+14)/256.0 alpha:1.0] CGColor];
		symbol.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
	}
	
	if (scatterPlotWithSymbol == plot) {
		if (index == selectedPointIndex && selectionAxis != nil) {
			return symbol;
		}
	}
	return nil;
}

@end
