#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import sys
import os
import json
import psutil
import time
import string
import thread
import subprocess as sp

arr = []
text = ''
current_time = time.time()
last_net_stats = psutil.net_io_counters()

def LOG(content):
    pass

def battery():
    dict = {}
    status = open('/sys/class/power_supply/BAT0/status').read()
    percent = open('/sys/class/power_supply/BAT0/capacity').read()

    if 'Charging' in status or 'Full' in status:
        charge = True
    else:
        charge = False

    if charge == True:
        dict['color'] = '#00ff00'
    elif int(percent) > 25:
        dict['color'] = '#ffff00'
    else:
        dict['color'] = '#ff0000'

    dict["full_text"] = '{0:^15}'.format(status.replace('\n', '') + ' ('+percent[:-1]+'%)')
    dict["name"] = 'bat'
    dict["instance"] = '0'
    return dict

def datetime():
    dict = {}
    dict['full_text'] = time.strftime('%d/%m/%y, %I:%M %p (%a)')
    dict["name"] = 'time'
    dict["instance"] = '0'
    return dict


def click_events():
    global text
    try:
        buff = ''
        while True:
            buff += raw_input()
            text = buff[0].replace(',', '') + buff[1:]
            LOG(text)
            try:
                obj = json.loads(text)
                LOG(str(obj))
                if obj["name"] == "vol":
                    if "relative_x" in obj:
                        obj["x"] = 1500 + obj["relative_x"] - 47
                    if obj["button"] == 1 and obj["x"] >= 1500 and obj["x"] <= 1605:
                        new_vol = 10*((obj["x"] - 1500)/7 + 1)
                        sp.call(["pamixer", "--allow-boost", "--set-volume", str(new_vol)])
                        repaint()
                    if obj["button"] == 2 or obj["button"] == 3:
                        sp.call(["bash", "-c", "pavucontrol&"])
            except Exception as e:
                text = str(e)
            buff = ''
    except KeyboardInterrupt:
       sys.stdout.flush()
       pass

def sound():
    try:
        proc = sp.check_output(["pamixer", "--get-volume"]).replace("\n", "")
    except Exception as e:
        proc = "0"
    text = u"\u266b " + proc
    bar = []
    percent = int(proc)/10
    bar = [u'\u2588']*percent + [u'\u2592']*(15-percent)
    dict = {'full_text': u'{:>21}'.format(text + " " + ''.join(bar))}
    dict["name"] = "vol"
    dict["instance"] = "0"
    return dict

def bright():
    proc = float(sp.check_output(["light"]).replace("\n", ''))
    text = u"\u2600 "+str(int(proc))+"%"
    dict = {'full_text': u'{:^7}'.format(text)}
    dict["name"] = "bright"
    dict["instance"] = "0"
    return dict

def connection(fullName, abbrv):
    ifc = sp.Popen(["ifconfig"], stdout=sp.PIPE)
    grp = sp.Popen(["grep", "-A", "1", fullName],
        stdin=ifc.stdout, stdout=sp.PIPE)
    ans = sp.Popen(["sed", "-En",
        r"s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"],
        stdin=grp.stdout, stdout=sp.PIPE)
    ip = str(ans.stdout.read()).replace("\n", ', ')
    ip = ip[:-2]
    dict = {'name': 'wlan'}
    dict["instance"] = "0"
    if '.' in ip:
        dict["full_text"] = '{:^20}'.format(abbrv + ": "+ip)
        dict['color'] = '#44ff11'
    else:
        dict["full_text"] = '{:^20}'.format(abbrv + ": --.--.--.--" )
        dict['color'] = '#ff4411'
    return dict

def cpu():
    percentage = str(psutil.cpu_percent()) + "%"
    text = "CPU: " + percentage
    dict = {}
    dict["full_text"] = u'{:^12}'.format(text)
    dict["instance"] = "0"
    return dict

def mem():
    percentage = str(psutil.virtual_memory().percent)
    percentage += "%"
    text = "MEM: " + percentage
    dict = {}
    dict["full_text"] = u'{:^12}'.format(text)
    dict["instance"] = "0"
    return dict

def net_stats():
    global current_time
    global last_net_stats
    new_time = time.time()
    counter = psutil.net_io_counters()
    current_stats = (counter.bytes_sent, counter.bytes_recv)

    download_speed = (current_stats[1] - last_net_stats[1]) / 1000.0
    download_speed = download_speed / (new_time - current_time)
    download_speed = "{0:0.1f}".format(download_speed)

    upload_speed = (current_stats[0] - last_net_stats[0]) / 1000.0
    upload_speed = upload_speed / (new_time - current_time)
    upload_speed = "{0:0.1f}".format(upload_speed)

    download_speed = u"\u25bC " + str(download_speed) + " kb/s"
    upload_speed = u"\u25b2 " + str(upload_speed) + " kb/s"
    text = download_speed + " " + upload_speed
    dict = {}
    dict["full_text"] = u'{:^30}'.format(text)
    dict["instance"] = "0"
    current_time = time.time()
    last_net_stats = current_stats
    return dict

def repaint():
    arr = []
    create(arr)
    print ',', json.dumps(arr)
    sys.stdout.flush()


def create(arr):
    # global text
    # arr.append({'full_text': str(text)})
    # arr.append(connection('enp', 'E'))
    arr.append(connection('wlp', 'W'))
    arr.append(net_stats())
    arr.append(cpu())
    arr.append(mem())
    arr.append(bright())
    arr.append(sound())
    arr.append(battery())
    arr.append(datetime())


if __name__ == '__main__':
    thread.start_new_thread(click_events, ())
    print '{ "version": 1, "click_events": true }'
    print '['
    print '[]'
    repaint()
    while True:
        repaint()
        time.sleep(1)
