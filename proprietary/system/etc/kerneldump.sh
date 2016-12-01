#!/system/bin/sh

DUMP_DIR=/data/hisi_logs/memorydump
# export TIMESTAMP for log tag
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)
closeflag=`cat /proc/balong/stats/close`
if [ $closeflag -ne 1 ]; then
	mkdir -p $DUMP_DIR
	chmod 774 $DUMP_DIR
	cat /proc/balong/memory/kernel_dump > $DUMP_DIR/kerneldump_$TIMESTAMP.bin
	chmod 664 $DUMP_DIR/kerneldump_$TIMESTAMP.bin
	chown root:system $DUMP_DIR/kerneldump_$TIMESTAMP.bin
	
	cd $DUMP_DIR
	fname=`busybox ls -c | busybox head | busybox awk '/kerneldump.*/ {print $1}'`
	count=1
	for i in $fname; do
		if [ $count -gt 3 ]; then
			rm -r $i
		fi

		count=$count+1
	done
	reboot
fi

