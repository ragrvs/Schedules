//
//  EventLineChart.swift
//  Schedules
//
//  Created by Richard Zhunio on 5/20/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import Foundation
import Charts

/// Represents the chart that draws the graphg
class EventLineChart: LineChartView, IValueFormatter, IAxisValueFormatter {
    
    private var _hoursPerDay: [HoursPerDay]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initChart()
    }
    
    // Initializes the chart
    private func initChart() {
        pinchZoomEnabled = true
        noDataTextColor = .white
        minOffset = 25
        legend.enabled = false
        xAxis.valueFormatter = self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateAxis()
    }
    
    // Updates the x and y axis for the graph.
    private func updateAxis() {
        // Update Axis UI
        let axis = [leftAxis, rightAxis, xAxis]
        
        axis.forEach { axes in
            axes.drawLabelsEnabled = false
            axes.drawGridLinesEnabled = false
            axes.drawAxisLineEnabled = false
        }
        
        xAxis.drawLabelsEnabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1.0
    }
    
    /// Updates the chart with the given view model.
    func updateChart(with viewModel: [HoursPerDay]) {
        
        let entries = getEntries(with: viewModel)
        let set = getDataSet(with: entries)

        data = entries.isEmpty ? nil : LineChartData(dataSet: set)
    }
    
    /// Maps the view model to a chart data entry.
    private func getEntries(with viewModel: [HoursPerDay]) -> [ChartDataEntry] {
        
        // Save a copy of hoursPerDay
        _hoursPerDay = viewModel
        
         return _hoursPerDay
            .enumerated()
            .map {  ChartDataEntry(x: Double($0.offset), y: $0.element.hours) }
    }
    
    /// Creates a data set from the chart data entry.
    private func getDataSet(with entries: [ChartDataEntry]) -> ChartDataSet {
        
        let set = LineChartDataSet(entries: entries, label: "")
        
        // Update Set UI
        set.valueTextColor = .white
        set.mode = .cubicBezier
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.valueFormatter = self
        
        return set
    }
    
    /// Formatter for the y-value
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return formatYValue(value)
    }
    
    /// Formats y-value
    private func formatYValue(_ value: Double) -> String {
        return String(format: "%.1f h", value)
    }
    
    /// Formatter for the x-value
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatXValue(value)
    }
    
    /// Format the x-value
    private func formatXValue(_ value: Double) -> String {
        return _hoursPerDay[Int(value)].day.jan10()
    }
}
