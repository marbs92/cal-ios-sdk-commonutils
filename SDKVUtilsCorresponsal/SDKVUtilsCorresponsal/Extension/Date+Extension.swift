//
//  Date+Properties.swift
//  Near you
//
//  Created by Jorge Cruz on 3/29/20.
//  Copyright © 2020 Servicios de Software Ehecatl. All rights reserved.
//

import UIKit

public extension DateFormatter{
    
    ////
    func dateMXFullformat()->DateFormatter{
        self.dateFormat = "dd/MM/yyyy h:mm a"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateUSFullformatAgo()->DateFormatter{
        self.dateFormat = "MM/dd/yyyy HH:mm:ss"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    
    func dateUTCFullformatAgo()->DateFormatter{
        self.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
        self.timeZone = TimeZone(abbreviation: "UTC")
        return self
    }
    /////
    func dateUSFullformat()->DateFormatter{
        self.dateFormat = "MM/dd/yyyy HH:mm:ss"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateDMYformat()->DateFormatter{
        self.dateFormat = "dd/MM/yyyy"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateDDMMMYYformat()->DateFormatter{
        self.dateFormat = "MM/dd/yyyy"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateDDMMYYformat()->DateFormatter{
        self.dateFormat = "dd/MMM/yyyy"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateUTCFullformat()->DateFormatter{
        self.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateFullSimpleFormat()->DateFormatter{
        self.dateFormat = "dd/MM/yyyy'T'HH:mm:ss"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateUTCFullformatHour()->DateFormatter{
        self.dateFormat = "hh:mm aa"
        self.timeZone = TimeZone(abbreviation: "UTC")
        return self
    }
    
    func dateUTCFormatHourMin()->DateFormatter{
        self.dateFormat = "hh:mm"
        self.timeZone = TimeZone(abbreviation: "UTC")
        return self
    }
    
    func timeUSFullformat()->DateFormatter{
        self.dateFormat = "HH:mm:ss"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    func dateUSSimpleformat()->DateFormatter{
        self.dateFormat = "E, d MMM yyyy HH:mm"
        self.locale = Locale.current
        self.timeZone = TimeZone.current
        return self
    }
    
    
    
}

public extension Date{
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
    func dateUSUserToString()->String{
        return DateFormatter().dateUSSimpleformat().string(from: self)
    }
    
    func timeUTCFullToString()->String{
        return DateFormatter().timeUSFullformat().string(from: self)
    }
    
    func dateUTCFullformatHourString()->String{
        return DateFormatter().dateUTCFullformatHour().string(from: self)
    }
    
    func dateUTCFullformatHourMinString()->String{
        return DateFormatter().dateUTCFormatHourMin().string(from: self)
    }
    
    func dateComplete() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd 'de' MMMM 'del' yyyy"
        return dateFormatter.string(from: self)
    }
    
    func dateWebService() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}


///

public extension Date {
    
    var year2: Int {
        return Calendar.current.component(.year, from: self)
    }
    var weekendsInSameYear: [Date] {
        return Calendar.current.range(of: .day, in: .year, for: self)?.compactMap {
            guard let date = DateComponents(calendar: .current, year: year2, day: $0).date, Calendar.current.isDateInWeekend(date) else {
                return nil
            }
            return date
        } ?? []
        
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    var dateToStringYearMonthDayG : String {
        return DateFormatter().formatWithyyyymmddG().string(from: self)
    }
    
    var dateToStringYearMonthDayD : String {
        return DateFormatter().formatWithyyyymmddD().string(from: self)
    }
    
    var dateToStringDayMonthYearD : String {
        return DateFormatter().formatWithmmddyyyyD().string(from: self)
    }
    
    var dateToStringDayMonthYearG : String {
        return DateFormatter().formatWithmmddyyyyG().string(from: self)
    }
    
    var dateToStringDayMonthYearN : String {
        return DateFormatter().formatWithddmmmmyyyyD().string(from: self)
    }
    
    var dateToStringDayMonthYearHourMinutes: String{
        return DateFormatter().formatWithddmmmmyyyyhhmmWB().string(from: self)
    }
    
    var dateToStringEDayMonthYear: String{
        return DateFormatter().formatWitheddmmmmyyyy().string(from: self)
    }
    
    var dayToStringFormatFull : String{
        return DateFormatter().formatWithFull().string(from: self)
    }
    
    var dayToStringMxFullFormat: String{
        return DateFormatter().dateMXFullformat().string(from: self)
    }
    
    var dayToStringFormatFullSlash : String{
        return DateFormatter().dateFullSimpleFormat().string(from: self)
    }
    
    var dayToStringCommentFormatFull : String{
        return DateFormatter().formatWithdmyhms().string(from: self)
    }
    
    var dayToStringCotizacionFormatFull : String{
        return DateFormatter().formatWithdmy().string(from: self)
    }
    
    
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    var hourMinute: String{
        return DateFormatter().formatWithhhmm().string(from: self)
    }
    
    var hourMinute12: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    var dateToStringMonthYear: String {
        return DateFormatter().formatWithyyyymm().string(from: self)
    }
    
    var dateToStringMounth:String {
        return  DateFormatter().formatMounth().string(from: self)
    }
    
}

public extension String{
    var stringToDateDayMonthYearG: Date {
        return DateFormatter().formatWithmmddyyyyG().date(from: self)!
    }
    
    var stringToDateYearMonthDayG: Date {
        return DateFormatter().formatWithyyyymmddG().date(from: self)!
    }
    
    var stringToDateDayMonthYearD: Date {
        return DateFormatter().formatWithmmddyyyyD().date(from: self)!
    }
    
    var stringToDateYearMonthDayHourMWB: Date{
        return DateFormatter().formatWithyyyymmddHHmmWB().date(from: self) ?? Date()
    }
}

public extension DateFormatter{
    
    func formatWithyyyymm()->DateFormatter{
        self.dateFormat = "MMMM yyyy"
        //  self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithddmmmyyyy()->DateFormatter{
        self.dateFormat = "dd MMMM yyyy"
        // self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithyyyymmddG()->DateFormatter{
        self.dateFormat = "yyyy-MM-dd"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    func formatWithyyyymmddD()->DateFormatter{
        self.dateFormat = "yyyy/MM/dd"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithmmddyyyyD()->DateFormatter{
        self.dateFormat = "dd/MM/yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithddmmmmyyyyD()->DateFormatter{
        self.dateFormat = "dd/MMMM/yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithmmddyyyyG()->DateFormatter{
        self.dateFormat = "MM-dd-yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithyyyymmddHHmmWB()->DateFormatter{
        self.dateFormat = "yyyy-MM-dd HH:mm"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone(secondsFromGMT: 0)
        return self
    }
    
    func formatWithddmmmmyyyyhhmmWB()->DateFormatter{
        self.dateFormat = "dd 'de' MMMM 'de' yyyy h:mm a"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone(secondsFromGMT: 0)
        return self
    }
    
    func formatWitheddmmmmyyyy()->DateFormatter{
        self.dateFormat = "EEEE dd MMMM yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone(secondsFromGMT: 0)
        return self
    }
    
    func formatWithhhmm()->DateFormatter{
        self.dateFormat = "HH:mm"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithdmyhms()->DateFormatter{
        self.dateFormat = "E, d MMM yyyy HH:mm"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithdmy()->DateFormatter{
        self.dateFormat = "E, d MMM yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatWithFull()->DateFormatter{
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatMounth()->DateFormatter{
        self.dateFormat = "MMMM"
        // self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatMounthDay()->DateFormatter{
        self.dateFormat = "dd MMMM"
        // self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatDay()->DateFormatter{
        self.dateFormat = "dd"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatMonth()->DateFormatter{
        self.dateFormat = "MM"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    func formatYear()->DateFormatter{
        self.dateFormat = "yyyy"
        self.locale = NSLocale.init(localeIdentifier: "es-MX") as Locale
        self.timeZone = TimeZone.current
        return self
    }
    
    
    
}
