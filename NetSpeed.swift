import Cocoa
import Darwin

// MARK: - Network Stats Reader
class NetworkStatsReader {
    struct Stats {
        var bytesIn: UInt64 = 0
        var bytesOut: UInt64 = 0
    }
    
    private var lastStats: Stats?
    private var lastTime: Date?
    
    func getSpeed() -> (download: String, upload: String) {
        guard let current = readStats() else {
            return ("--", "--")
        }
        
        let now = Date()
        defer {
            lastStats = current
            lastTime = now
        }
        
        guard let prev = lastStats, let prevTime = lastTime else {
            return ("--", "--")
        }
        
        let elapsed = now.timeIntervalSince(prevTime)
        guard elapsed > 0 else { return ("--", "--") }
        
        let dlBytes = current.bytesIn >= prev.bytesIn ? current.bytesIn - prev.bytesIn : 0
        let ulBytes = current.bytesOut >= prev.bytesOut ? current.bytesOut - prev.bytesOut : 0
        
        let dlSpeed = Double(dlBytes) / elapsed
        let ulSpeed = Double(ulBytes) / elapsed
        
        return (formatSpeed(dlSpeed), formatSpeed(ulSpeed))
    }
    
    private func readStats() -> Stats? {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let first = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }
        
        var totalIn: UInt64 = 0
        var totalOut: UInt64 = 0
        var ptr = first
        
        while true {
            let flags = Int32(ptr.pointee.ifa_flags)
            _ = String(cString: ptr.pointee.ifa_name)
            
            // Only count active, non-loopback interfaces
            if (flags & IFF_UP) != 0 && (flags & IFF_LOOPBACK) == 0,
               let data = ptr.pointee.ifa_data {
                let networkData = data.assumingMemoryBound(to: if_data.self).pointee
                totalIn += UInt64(networkData.ifi_ibytes)
                totalOut += UInt64(networkData.ifi_obytes)
            }
            
            guard let next = ptr.pointee.ifa_next else { break }
            ptr = next
        }
        
        return Stats(bytesIn: totalIn, bytesOut: totalOut)
    }
    
    private func formatSpeed(_ bytesPerSec: Double) -> String {
        if bytesPerSec >= 1_000_000 {
            return String(format: "%4.1fM", bytesPerSec / 1_000_000)
        } else if bytesPerSec >= 1_000 {
            return String(format: "%4.1fK", bytesPerSec / 1_000)
        } else if bytesPerSec >= 100 {
            return String(format: "%3.0fK", bytesPerSec / 1_000)
        }
        return String(format: "%3.0f", bytesPerSec)
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var reader = NetworkStatsReader()
    private var timer: Timer?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.font = NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            button.title = "↓ --  ↑ --"
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "NetSpeed v1.0", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.update()
        }
        
        // Hide from Dock
        NSApp.setActivationPolicy(.accessory)
    }
    
    private func update() {
        let (dl, ul) = reader.getSpeed()
        DispatchQueue.main.async {
            self.statusItem.button?.title = "↓ \(dl)  ↑ \(ul)"
        }
    }
    
    @objc func quit() {
        timer?.invalidate()
        NSApp.terminate(nil)
    }
}

// MARK: - Main
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
