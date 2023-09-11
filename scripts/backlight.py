#!/bin/env python3

import sys
import os
import subprocess
import re
import threading
import logging
from collections import namedtuple


###############################################################
######################## CONFIGURATION ########################
###############################################################

exec_cmd = 'ddcutil'
icon = '/usr/share/icons/hicolor/48x48/status/display-brightness.png'
notify_id_file = '/tmp/backlight-notify-id'

logLevel = logging.INFO
#logLevel = logging.DEBUG

async_set = False
retries = 1

# (Name, SerialNumber, MaxValue, ValueFuction, ExtraDdcutilParams)
Display = namedtuple("Display", ["name", "sn", "maxVal", "cb", "params"])
displays = [
        Display( "DELL", "MY3ND94P0F5T",  100, lambda v: v,           ['--sleep-multiplier=.2'] ),
        Display( "Eizo", "44580023",      200, lambda v: v*2*300/250, ['--sleep-multiplier=.2'] ),
        Display( "ZFTV",  "J257M96B00FL", 100, lambda v: v*300/250,   ['--sleep-multiplier=.2'] ),
        ]

levels = [ 0, 10, 20, 40, 70, 100 ]

###############################################################


if logLevel < logging.INFO:
    logging.basicConfig(format='%(asctime)s %(message)s')
else:
    logging.basicConfig(format='%(message)s')

log = logging.getLogger(__name__)
log.setLevel(logLevel)

cur_val_re = re.compile('VCP.*current value =[ ]*([^ ,]+).*max value =[ ]*([^ ,]+)')


def get_cmd(disp, *args):
    cmd = [ exec_cmd, '--noverify', '--sn', disp.sn ]
    if disp.params:
        cmd += disp.params
    cmd += [ str(x) for x in args ]
    return cmd


def get_value(feature, disp):
    cmd = get_cmd(disp, 'getvcp', feature)
    log.debug(' '.join(cmd))
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    for line in proc.stdout:
        line = line.decode('utf-8')
        cur_val = cur_val_re.match(line)
        if cur_val:
            return int(cur_val.group(1)), int(cur_val.group(2))
    return None, None


def set_value(feature, value, disp):
    cmd = get_cmd(disp, 'setvcp', feature, value)
    log.debug("command: " + ' '.join(cmd))

    res = 0
    for retry in range(retries):
        child = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        child.wait()
        res = child.returncode
        if res == 0:
            if retry > 0:
                log.warning('{}: command succeeded ({} retry)'.format(
                    disp.name, retry+1))
            break
        else:
            log.warning('{}: command failed with code {} ({} retry)'.format(
                disp.name, res, retry+1))

    if res:
        msg = '{}: COMMAND FAILED\n'.format(disp.name) + child.stderr.read().decode()
        show_notify(msg, app_name='brightness', icon='error')


def set_value_async(*args, **kwargs):
    t = threading.Thread(target=set_value, args=args, kwargs=kwargs, daemon=False)
    t.start()
    return t


def show_notify(msg, **kwargs):
    cmd = ['notify-send', '--expire-time=3000', '--print-id', '--transient']
    cmd += [ '--{}={}'.format(k.replace('_', '-'), v) for k, v in kwargs.items() ]
    try:
        with open(notify_id_file, 'r') as fp:
            cmd.append('--replace-id=' + fp.read().strip())
    except:
        pass
    cmd.append(msg)
    #print(' '.join(cmd))

    try:
        fp = open(notify_id_file, 'w')
    except:
        fp = None

    proc = subprocess.Popen(cmd, stdout=fp)
    if fp:
        fp.close()


def parse_argv():
    if len(sys.argv) > 1:
        arg = sys.argv[1]
        if arg.startswith('+') or arg.startswith('-'):
            if len(arg) == 1:
                return ('level', arg)
            else:
                return ('relative', int(arg))
        else:
            return ('absolute', int(arg))
    else:
        return ('read', None)


def get_next_level(val):
    for x in levels:
        if x > val:
            return x
    return levels[-1]


def get_prev_level(val):
    for x in reversed(levels):
        if x < val:
            return x
    return levels[0]


def backlight(mode, newVal):
    if mode != 'absolute':
        disp = displays[0]
        val, maxVal = get_value(10, disp)
        oldVal = int(100 * int(val) / maxVal)

        if maxVal != disp.maxVal:
            log.warning('{}: invalid maxVal={}, should be {}'.format(
                disp.name, disp.maxVal, maxVal))

    if mode == 'read':
        print(oldVal)
        return oldVal

    elif mode == 'absolute':
        pass

    elif mode == 'relative':
        newVal = max(min(oldVal + newVal, 100), 0)

    elif mode == 'level':
        if newVal == '+':
            newVal = get_next_level(oldVal)
        elif newVal == '-':
            newVal = get_prev_level(oldVal)

    show_notify('Backlight: {}%'.format(newVal), app_name='brightness', icon=icon)

    threads = []
    for disp in displays:
        v = max(min(int(disp.cb(newVal)), disp.maxVal), 0)
        log.info('{}: {:.0f}%'.format(disp.name, 100*v/disp.maxVal))

        if async_set:
            threads.append(set_value_async(10, v, disp))
        else:
            set_value(10, v, disp)

    for thread in threads:
        thread.join()


if __name__ == "__main__":
    mode, newVal = parse_argv()
    backlight(mode, newVal)

log.debug("done")
