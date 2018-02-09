import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.Pager
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS2
import System.Taffybar.Battery
import System.Taffybar.NetMonitor

--import WorkspaceHUD

import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

myPagerConfig :: PagerConfig
myPagerConfig = defaultPagerConfig {  activeWorkspace = colorize "yellow" "" . wrap "[" "]" . escape
                                   ,  hiddenWorkspace = wrap " " " " . escape
                                   }

myNetFormat :: String
myNetFormat = "▼ $inKB$kb/s  ▲ $outKB$kb/s"

main = do
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel = Just "RAM"
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "CPU"
                                  }
  let clock = textClockNew Nothing "%a %b %_d %r" 1
      pager = taffyPagerNew myPagerConfig
      note = notifyAreaNew defaultNotificationConfig
      mpris = mpris2New
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
      batt = batteryBarNew defaultBatteryConfig 30
      wnet = netMonitorNewWith 10 "wlp2s0" 1 myNetFormat
      enet = netMonitorNewWith 10 "enp0s20u1" 1 myNetFormat
      -- font  = "liberation mono-20"

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                        , endWidgets = [ tray, clock, mem, cpu, batt, enet, wnet, mpris ]
                                        , barPosition = Top
                                        , barHeight = 20
                                        }
