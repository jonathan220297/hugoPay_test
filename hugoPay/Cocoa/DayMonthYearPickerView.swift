//
//  DayMonthYearPickerView.swift
//  Hugo
//
//  Created by Developer on 4/25/19.
//  Copyright © 2019 Clever Mobile Apps. All rights reserved.
//

import UIKit

class DayMonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var days: [Int]!
    var months: [String]!
    var years: [Int]!
    
    var day = Calendar.current.component(.day, from: Date()) {
        didSet {
            selectRow(day - 1, inComponent: 0, animated: true)
        }
    }
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            self.refreshDays()
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.firstIndex(of: year)!, inComponent: 2, animated: true)
        }
    }
    
    var onDateSelected: ((_ day: Int, _ month: Int, _ year: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        let today = Date()
        let baseYear = 1940
        let cal = Calendar.current
        var date = cal.startOfDay(for: today)
        let currentYear = cal.component(.year, from: date)
        let maxYearsToShow = currentYear - baseYear
        
        // population years
        var year_list = [Int]()
        for _ in 0...maxYearsToShow {
            let year = cal.component(.year, from: date)
            
            //move back in time by one year
            year_list.append(year)
            
            if let newDate = cal.date(byAdding: .year, value: -1, to: date) {
                date = newDate
            }
            
        }
        
        // population months with localized names
        var month_list: [String] = []
        var month = 0
        for _ in 1...12 {
            month_list.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        
        self.months = month_list
        self.years = year_list
        
        self.delegate = self
        self.dataSource = self
        
        // population days
        var day_list = [Int]()
        let currentDay = cal.component(.day, from: Date())
        let currentMonth = cal.component(.month, from: Date())
        
        let dateComponents = DateComponents(year: year, month: currentMonth)
        let filterDate = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: filterDate)!
        let daysToShow = range.count
        for day in 1...daysToShow {
            day_list.append(day)
        }
        self.days = day_list
        
        self.selectRow(currentDay - 1, inComponent: 0, animated: true)
        self.selectRow(currentMonth - 1, inComponent: 1, animated: false)
    }
    
    func refreshDays() {
        var day_list = [Int]()
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let daysToShow = range.count
        
        if self.day > daysToShow {
            self.day = daysToShow
        }
        
        self.days.removeAll()
        for day in 1...daysToShow {
            day_list.append(day)
        }
        self.days = day_list
        self.reloadComponent(0)
        
        selectRow(month - 1, inComponent: 1, animated: true)
    }
    
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(days[row])"
        case 1:
            return months[row]
        case 2:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.year = years[self.selectedRow(inComponent: 2)]
        self.month = self.selectedRow(inComponent: 1)+1
        self.day = days[self.selectedRow(inComponent: 0)]
        
        onDateSelected?(day, month, year)
    }
    
}
