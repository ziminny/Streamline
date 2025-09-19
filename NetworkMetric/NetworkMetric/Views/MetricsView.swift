//
//  MetricsView.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import SwiftUI
import Streamline

struct MetricsView: View {
    let metric: NetworkMetric
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Cabeçalho
            VStack(spacing: 4) {
                Text("Network Metrics")
                    .font(.title2.bold())
                Text(metric.url)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Grid com métricas
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())],
                      spacing: 16) {
                
                MetricItem(title: "Bytes Received",
                           value: formatBytes(metric.bytesReceived))
                
                MetricItem(title: "Bytes Sent",
                           value: formatBytes(metric.bytesSent))
                
                if let statusCode = metric.statusCode {
                    MetricItem(title: "Status Code",
                               value: "\(statusCode)", status: makeStatusCode(statusCode))
                }
                
                MetricItem(title: "Total Duration",
                           value: formatSeconds(metric.totalDuration), status: makeTotalDuration(metric.totalDuration))
                
                if let dns = metric.dnsDuration {
                    MetricItem(title: "DNS Duration",
                               value: formatSeconds(dns), status: makeDNSDuration(dns))
                }
                
                if let tls = metric.tlsDuration {
                    MetricItem(title: "TLS Duration",
                               value: formatSeconds(tls), status: makeTLSDuration(tls))
                }
            }
                      .padding()
                      .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                      )
        }
        .padding()
    }
    
    private func makeDNSDuration(_ seconds: TimeInterval) -> ItemStatus {
        switch seconds {
        case 0...0.20:
            return .good
        case 0.20...0.50:
            return .medium
        default:
            return .bad
        }
    }
    
    private func makeTLSDuration(_ seconds: TimeInterval) -> ItemStatus {
        switch seconds {
        case 0...0.150:
            return .good
        case 0.150...0.300:
            return .medium
        default:
            return .bad
        }
    }
    
    private func makeTotalDuration(_ seconds: TimeInterval) -> ItemStatus {
        switch seconds {
        case 0...0.300:
            return .good
        case 0.300...0.800:
            return .medium
        default:
            return .bad
        }
    }
    
    private func makeStatusCode(_ statusCode: Int) -> ItemStatus {
        if statusCode == 200 {
            return .good
        }
        return .bad
    }
    
    // Helpers
    private func formatBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
    
    private func formatSeconds(_ seconds: TimeInterval) -> String {
        String(format: "%.2f s", seconds)
    }
}

enum ItemStatus {
    case good
    case medium
    case bad
}

struct MetricItem: View {
    let title: String
    let value: String
    let status: ItemStatus?
    
    private var color: Color {
        
        guard let status else {
            return Color(.label)
        }
        
        switch status {
        case .good:
            return .green
        case .medium:
            return .yellow
        case .bad:
            return .red
        }
    }
    
    init(title: String, value: String, status: ItemStatus? = nil) {
        self.title = title
        self.value = value
        self.status = status
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
}

#Preview("Good") {
    MetricsView(metric: .mockGood)
}

#Preview("Medium") {
    MetricsView(metric: .mockMedium)
}

#Preview("Bad") {
    MetricsView(metric: .mockBad)
}

