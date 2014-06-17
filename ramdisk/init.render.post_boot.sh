#!/system/bin/sh

############################
# various tweaks from CM
#
target=`getprop ro.board.platform`
debuggable=`getprop ro.debuggable`
emmc_boot=`getprop ro.boot.emmc`

echo 2 > /sys/module/lpm_levels/enable_low_power/l2
soc_revision=`cat /sys/devices/soc0/revision`
if [ "$soc_revision" != "1.0" ]; then
		echo 1 > /sys/module/lpm_resources/enable_low_power/pxo
fi

product=`getprop ro.boot.device`
if [ "$product" == "falcon" ]; then
	if [ "$soc_revision" == "1.0" ]; then
		echo 1 > /sys/kernel/debug/clk/cxo_lpm_clk/enable
	fi
fi

case "$emmc_boot"
in "true")
chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
;;
esac

echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/suspend_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
echo 1 > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online
echo 0 > /sys/kernel/sched/gentle_fair_sleepers
chmod 664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
chown -h system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
chown -h system system /sys/devices/system/cpu/cpu1/online
chown -h system system /sys/devices/system/cpu/cpu2/online
chown -h system system /sys/devices/system/cpu/cpu3/online
chmod -h 664 /sys/devices/system/cpu/cpu1/online
chmod -h 664 /sys/devices/system/cpu/cpu2/online
chmod -h 664 /sys/devices/system/cpu/cpu3/online

############################
# CPU-Boost Settings
#
# echo 20 > /sys/module/cpu_boost/parameters/boost_ms
# echo 600000 > /sys/module/cpu_boost/parameters/sync_threshold
# echo 787200 > /sys/module/cpu_boost/parameters/input_boost_freq
# echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 384000 > /sys/module/cpu_boost/parameters/plug_boost_freq

############################
# mount debugfs
#
mount -t debugfs nodev /sys/kernel/debug

############################
# Tweak ZSWAP
#
# echo 70 > /proc/sys/vm/swappiness

############################
# Init VNSWAP
#
# echo 402653184 > /sys/block/vnswap0/disksize
# mkswap /dev/block/vnswap0
# swapon /dev/block/vnswap0

############################
# render tweaks
#
echo 8 > /proc/sys/vm/page-cluster
echo 1 > /proc/sys/kernel/multi_threading

############################
# Script to launch frandom at boot by Ryuinferno @ XDA
#
# chmod 644 /dev/frandom
# chmod 644 /dev/erandom
# mv /dev/random /dev/random.ori
# mv /dev/urandom /dev/urandom.ori
# ln /dev/frandom /dev/random
# chmod 644 /dev/random
# ln /dev/erandom /dev/urandom
# chmod 644 /dev/urandom

############################
# CPUFreq and Governor Settings
#
# Ondemand
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo 90 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo 70 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
echo 3 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
echo 600000 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
echo 600000 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
echo 80 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load

# Interactive
echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo interactive > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo 20000 998400:40000 1190400:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 787200 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo 85 998400:90 1190400:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 40000 998400:80000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 40000 384000:30000 1190400:20000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor
echo -1 600000:30000 787100:40000 1190400:20000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack
echo 50 > /sys/devices/system/cpu/cpufreq/interactive/up_threshold_any_cpu_load
echo 600000 > /sys/devices/system/cpu/cpufreq/interactive/sync_freq
echo 787200 > /sys/devices/system/cpu/cpufreq/interactive/up_threshold_any_cpu_freq
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
echo 1 > /dev/cpuctl/apps/cpu.notify_on_migrate
