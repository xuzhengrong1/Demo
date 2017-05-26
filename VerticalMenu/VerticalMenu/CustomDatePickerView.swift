//
//  DatePickerView.swift
//  VerticalMenu
//
//  Created by 许正荣 on 2017/5/25.
//  Copyright © 2017年 许正荣. All rights reserved.
//

import Foundation
import UIKit
class CustomDatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    let maxYear = 2050
    let minYear = 1970

    var yearIndex = 0;
    var hoursIndex = 0;
    var miniuteIndex = 0;
    var monthIndex = 0;
    var dayIndex = 0;
    var maxLimitDate: Date = Date.FormatData("2030-01-01 01:59")!
    var minLimitDate: Date = Date.FormatData("2004-01-01 01:59")!
    var scrollToDate: Date
    var daysArray: [String] = [];
    var currentData: Date = Date()

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        self.scrollToDate = self.currentData;
        super.init(frame: frame)

        configData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Delegate DataSource
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.yearArr.count
        case 1:
            return self.monthArray.count
        case 2:
            return self.daysArray.count
        case 3:
            return self.hourArray.count
        case 4:
            return self.minuteArray.count
        default:
            break
        }
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var customLable = view as? UILabel;

        if (customLable == nil) {
            customLable = UILabel()
            customLable?.textAlignment = .center
            customLable?.font = UIFont.systemFont(ofSize: 17)
        }
        var title = "";

        switch component {
        case 0:
            title = String(describing: self.yearArr[row])
        case 1:
            title = monthArray[row];
        case 2:
            title = daysArray[row];
        case 3:
            title = hourArray[row];
        case 4:
            title = minuteArray[row];
        default:
            break
        }

        customLable?.text = title;
        customLable?.textColor = .black;
        return customLable!;

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            yearIndex = row;
        case 1:
            monthIndex = row;
        case 2:
            dayIndex = row;
        case 3:
            hoursIndex = row;
        case 4:
            miniuteIndex = row;
        default:
            break
        }
        if component == 1 || component == 0 {
            let daysCount = self.DaysFrom(yearArr[yearIndex], month: Int(monthArray[monthIndex])!)
            daysArray = Array(self.minuteArray[1...daysCount])
            if (daysArray.count - 1 < dayIndex) {
                dayIndex = daysArray.count - 1;
            }
            self.reloadComponent(2)
        }
        let dataStr = "\(yearArr[yearIndex])-\(monthArray[monthIndex])-\(daysArray[dayIndex]) \(hourArray[hoursIndex]):\(minuteArray[miniuteIndex])"
        self.scrollToDate = Date.FormatData(dataStr)! //Date.FormatData(,)
        if scrollToDate.compare(maxLimitDate) == .orderedDescending {
            scrollToDate = self.maxLimitDate;
            self.scrollToNowDate(self.scrollToDate, animated: true)
            self.reloadAllComponents()
        } else if scrollToDate.compare(minLimitDate) == .orderedAscending {
            scrollToDate = self.minLimitDate;
            self.scrollToNowDate(self.scrollToDate, animated: true)
            self.reloadAllComponents()
        }
        print("%@", self.scrollToDate);
    }

    // MARK: - Public
    func scrollToNowDate(_ date: Date, animated: Bool) {
        let daysCount = self.DaysFrom(date.year(), month: date.month())
        daysArray = Array(self.minuteArray.prefix(daysCount))
        yearIndex = date.year() - minYear;
        monthIndex = date.month() - 1;
        dayIndex = date.day() - 1;
        hoursIndex = date.hour() - 1;
        miniuteIndex = date.minute() - 1;
        
        let arr = [yearIndex, monthIndex, dayIndex, hoursIndex, miniuteIndex];
        
        for (index, item) in arr.enumerated() {
            self.selectRow(item, inComponent: index, animated: animated);
        }
        self.reloadAllComponents();
        
    }
    
    // MARK: - Privite
    

    private func setMinDate(_ data: Date) -> CustomDatePickerView {
        minLimitDate = data;
        if scrollToDate.compare(data) == .orderedAscending {
            scrollToDate = self.minLimitDate;
            self.scrollToNowDate(self.scrollToDate, animated: false)
        }

        return self
    }

    private func setMaxDate(_ data: Date) -> CustomDatePickerView {
        maxLimitDate = data;
        if scrollToDate.compare(data) == .orderedDescending {
            scrollToDate = self.maxLimitDate;
            self.scrollToNowDate(self.scrollToDate, animated: false)
        }

        return self
    }

   private func configData() {
        self.dataSource = self
        self.delegate = self
        self.showsSelectionIndicator = true
        self.scrollToNowDate(currentData, animated: true)
    }

    private func DaysFrom(_ year: Int, month: Int) -> Int {

        let isrunNian = year % 4 == 0 ? ( year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false;
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31

        case 4, 6, 9, 11:
            return 30

        case 2:
            if isrunNian {
                return 29
            } else
            {
                return 28
            }
        default:
            break
        }
        return 0;
    }
    // MARK: - Lazy Load
    lazy var minuteArray: [String] = {
        return Array(0...59).map { String(format: "%02d", $0) };
    }()

    lazy var hourArray: [String] = {
        return Array(self.minuteArray.prefix(24));
    }()
    let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]

    lazy var monthArray: [String] = {
        return Array(self.minuteArray[1...12]);
    }()

    lazy var yearArr: [Int] = {
        return Array(1970...2050);
    }()

}


extension Date {
    static let somecomponentFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal]
    static let sharedCalendar = NSCalendar.autoupdatingCurrent;
    static func FormatData(_ dataStr: String, format: String = "yyyy-MM-dd HH:mm") -> Date? {
        let dataFormat = DateFormatter();
        dataFormat.locale = Locale.current;
        dataFormat.timeZone = TimeZone.current;
        dataFormat.dateFormat = format;
        let data = dataFormat.date(from: dataStr);
        return data;
    }

    func year () -> Int {
        return Date.sharedCalendar.component(.year, from: self);
    }
    func month () -> Int {
        return Date.sharedCalendar.component(.month, from: self);
    }

    func hour () -> Int {
        return Date.sharedCalendar.component(.hour, from: self);
    }

    func minute () -> Int {
        return Date.sharedCalendar.component(.minute, from: self);
    }

    func day () -> Int {
        return Date.sharedCalendar.component(.day, from: self);
    }


}
