//
//  TestWidget.swift
//  TestWidget
//
//  Created by 王小劣 on 2023/8/19.
//

import ClockRotationEffect
import Intents
import SwiftUI
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct RectangleView2: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 75 * 2, height: 30)
                .foregroundColor(.blue.opacity(0.0))

            Rectangle()
                .frame(width: 90, height: 30)
                .foregroundColor(.black.opacity(0.0))
                .offset(x: 75 / 2 + 7.5)

            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(.black.opacity(1))
                .modifier(ClockRotationModifier(period: ClockRotationPeriod.custom(-10), timezone: TimeZone.current, anchor: .center))
                .offset(x: 75)

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
        .modifier(ClockRotationModifier(period: ClockRotationPeriod.custom(5), timezone: TimeZone.current, anchor: .center))
    }
}

struct RectangleView1: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .frame(width: 150, height: 30)
                .foregroundColor(.red.opacity(0.0))

            Color.white
                .frame(width: 1, height: 1)
                .foregroundColor(.white)
        }
    }
}

struct TestWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 340, height: 1)
                .foregroundColor(.red.opacity(1))
            ZStack {
                RectangleView1()
                RectangleView2()
                    .offset(x: 75)
            }
            .modifier(ClockRotationModifier(period: ClockRotationPeriod.custom(-10), timezone: TimeZone.current, anchor: .center))
        }
    }
}

struct TestWidget: Widget {
    let kind: String = "TestWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TestWidget_Previews: PreviewProvider {
    static var previews: some View {
        TestWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
