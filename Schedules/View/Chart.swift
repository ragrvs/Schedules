//
//  Chart.swift
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
    
    func updateChart(with viewModel: [HoursPerDay]) {
        
        let entries = getEntries(with: viewModel)
        let set = getDataSet(with: entries)

        data = entries.isEmpty ? nil : LineChartData(dataSet: set)
    }
    
    private func getEntries(with viewModel: [HoursPerDay]) -> [ChartDataEntry] {
        
        // Save a copy of hoursPerDay
        _hoursPerDay = viewModel
        
         return _hoursPerDay
            .enumerated()
            .map {  ChartDataEntry(x: Double($0.offset), y: $0.element.hours) }
    }
    
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
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f h", value)
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return _hoursPerDay[Int(value)].day.jan10()
    }
}

extension Array {
    
    func has(index: Int) -> Bool {
        return (0..<count).contains(index)
    }
    
}
