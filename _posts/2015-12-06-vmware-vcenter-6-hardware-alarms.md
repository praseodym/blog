---
layout: post
title: Hardware alarms in VMware vCenter 6 not triggering
---

Recently a drive in one of our VMware ESXi servers failed. The drive was part of a RAID array, so this failure did not cause any immediate problems. However, what surprised us was that VMware vCenter did not trigger any alarms about this drive failure.

The first thought was that VMware did not know about this hardware problem. However, the server (CIM) hardware sensor status within vCenter clearly shows that one of our drives has failed:
![ESXi hardware status]({{ site.baseurl }}/images/2015-12-06-vmware-vcenter-6-hardware-alarms/esxi-hardware-status.png)

Now, why does this failure assertion not trigger any alarms in vCenter? The events log of the ESXi server in vCenter sheds some light on this:
![ESXi events]({{ site.baseurl }}/images/2015-12-06-vmware-vcenter-6-hardware-alarms/esxi-events.png)

The 'deassert' status of our other drives appears to override the 'assert' state of our failed drive; vCenter then (incorrectly) overrides the 'red' status with 'green'. Because this all happens within a fraction of a second, an alarm is never triggered or triggered and immediately cleared. In essence, the state of the last hardware sensor entry that is checked decides the entirety of the storage health in VMware.

A proper solution would be to take the minimum health status of all reported entries and use that to determine the alarm status, so that 'green' never overrides 'red'. Unfortunately, the alarm logic in vCenter is limited as a set of triggers without additional logic. As a workaround, we can remove the trigger for 'green' health status in the vCenter 'Host storage status' alarm definition:
![vCenter host storage alarm definition]({{ site.baseurl }}/images/2015-12-06-vmware-vcenter-6-hardware-alarms/vcenter-host-storage-status-alarm-definition.png)

A side effect of this workaround is that any triggered alarm will never clear itself. Because the number of triggered alarms should be minimal in any production system, this should not be a problem. Still, we hope that VMware will enhance the alarm logic in a future update so that it works correctly out of the box.
