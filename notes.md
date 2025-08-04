# CAN

Startup is failing
```
[    0.483455] bcm2835-power bcm2835-power: Broadcom BCM2835 power domains driver
[    0.484677] mcp251x: probe of spi0.0 failed with error -34
[    0.485994] mmc-bcm2835 fe300000.mmcnr: mmc_debug:0 mmc_debug2:0
```
https://github.com/tolgakarakurt/CANBus-MCP2515-Raspi

`ls /sys/bus/spi/devices/spi0.0/net` has no net file
