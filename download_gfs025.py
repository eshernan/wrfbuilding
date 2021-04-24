#!/usr/bin/env python
#################################################################
# Python Script to retrieve 372 online Data files of 'ds084.1',
# total 123.88G. This script uses 'requests' to download data.
#
# Highlight this script by Select All, Copy and Paste it into a file;
# make the file executable and run it on command line.
#
# You need pass in your password as a parameter to execute
# this script; or you can set an environment variable RDAPSWD
# if your Operating System supports it.
#
# Contact rpconroy@ucar.edu (Riley Conroy) for further assistance.
#################################################################


import sys, os
import requests

def check_file_status(filepath, filesize):
    sys.stdout.write('\r')
    sys.stdout.flush()
    size = int(os.stat(filepath).st_size)
    percent_complete = (size/filesize)*100
    sys.stdout.write('%.3f %s' % (percent_complete, '% Completed'))
    sys.stdout.flush()

# Try to get password
if len(sys.argv) < 2 and not 'RDAPSWD' in os.environ:
    try:
        import getpass
        input = getpass.getpass
    except:
        try:
            input = raw_input
        except:
            pass
    pswd = input('Password: ')
else:
    try:
        pswd = sys.argv[1]
    except:
        pswd = os.environ['RDAPSWD']

url = 'https://rda.ucar.edu/cgi-bin/login'
values = {'email' : 'hrico@javeriana.edu.co', 'passwd' : pswd, 'action' : 'login'}
# Authenticate
ret = requests.post(url,data=values)
if ret.status_code != 200:
    print('Bad Authentication')
    print(ret.text)
    exit(1)
dspath = 'https://rda.ucar.edu/data/ds084.1/'
filelist = [
'2018/20180509/gfs.0p25.2018050900.f000.grib2',
'2018/20180509/gfs.0p25.2018050900.f003.grib2',
'2018/20180509/gfs.0p25.2018050900.f006.grib2',
'2018/20180509/gfs.0p25.2018050900.f009.grib2',
'2018/20180509/gfs.0p25.2018050900.f012.grib2',
'2018/20180509/gfs.0p25.2018050900.f015.grib2',
'2018/20180509/gfs.0p25.2018050900.f018.grib2',
'2018/20180509/gfs.0p25.2018050900.f021.grib2',
'2018/20180509/gfs.0p25.2018050900.f024.grib2',
'2018/20180509/gfs.0p25.2018050900.f027.grib2',
'2018/20180509/gfs.0p25.2018050900.f030.grib2',
'2018/20180509/gfs.0p25.2018050900.f033.grib2',
'2018/20180509/gfs.0p25.2018050900.f036.grib2',
'2018/20180509/gfs.0p25.2018050900.f039.grib2',
'2018/20180509/gfs.0p25.2018050900.f042.grib2',
'2018/20180509/gfs.0p25.2018050900.f045.grib2',
'2018/20180509/gfs.0p25.2018050900.f048.grib2',
'2018/20180509/gfs.0p25.2018050900.f051.grib2',
'2018/20180509/gfs.0p25.2018050900.f054.grib2',
'2018/20180509/gfs.0p25.2018050900.f057.grib2',
'2018/20180509/gfs.0p25.2018050900.f060.grib2',
'2018/20180509/gfs.0p25.2018050900.f063.grib2',
'2018/20180509/gfs.0p25.2018050900.f066.grib2',
'2018/20180509/gfs.0p25.2018050900.f069.grib2',
'2018/20180509/gfs.0p25.2018050900.f072.grib2',
'2018/20180509/gfs.0p25.2018050900.f075.grib2',
'2018/20180510/gfs.0p25.2018051000.f000.grib2',
'2018/20180510/gfs.0p25.2018051000.f003.grib2',
'2018/20180510/gfs.0p25.2018051000.f006.grib2',
'2018/20180510/gfs.0p25.2018051000.f009.grib2',
'2018/20180510/gfs.0p25.2018051000.f012.grib2',
'2018/20180510/gfs.0p25.2018051000.f015.grib2',
'2018/20180510/gfs.0p25.2018051000.f018.grib2',
'2018/20180510/gfs.0p25.2018051000.f021.grib2',
'2018/20180510/gfs.0p25.2018051000.f024.grib2',
'2018/20180510/gfs.0p25.2018051000.f027.grib2',
'2018/20180510/gfs.0p25.2018051000.f030.grib2',
'2018/20180510/gfs.0p25.2018051000.f033.grib2',
'2018/20180510/gfs.0p25.2018051000.f036.grib2',
'2018/20180510/gfs.0p25.2018051000.f039.grib2',
'2018/20180510/gfs.0p25.2018051000.f042.grib2',
'2018/20180510/gfs.0p25.2018051000.f045.grib2',
'2018/20180510/gfs.0p25.2018051000.f048.grib2',
'2018/20180510/gfs.0p25.2018051000.f051.grib2',
'2018/20180510/gfs.0p25.2018051000.f054.grib2',
'2018/20180510/gfs.0p25.2018051000.f057.grib2',
'2018/20180510/gfs.0p25.2018051000.f060.grib2',
'2018/20180510/gfs.0p25.2018051000.f063.grib2',
'2018/20180510/gfs.0p25.2018051000.f066.grib2',
'2018/20180510/gfs.0p25.2018051000.f069.grib2',
'2018/20180510/gfs.0p25.2018051000.f072.grib2',
'2018/20180510/gfs.0p25.2018051000.f075.grib2',
'2018/20180511/gfs.0p25.2018051100.f000.grib2',
'2018/20180511/gfs.0p25.2018051100.f003.grib2',
'2018/20180511/gfs.0p25.2018051100.f006.grib2',
'2018/20180511/gfs.0p25.2018051100.f009.grib2',
'2018/20180511/gfs.0p25.2018051100.f012.grib2',
'2018/20180511/gfs.0p25.2018051100.f015.grib2',
'2018/20180511/gfs.0p25.2018051100.f018.grib2',
'2018/20180511/gfs.0p25.2018051100.f021.grib2',
'2018/20180511/gfs.0p25.2018051100.f024.grib2',
'2018/20180511/gfs.0p25.2018051100.f027.grib2',
'2018/20180511/gfs.0p25.2018051100.f030.grib2',
'2018/20180511/gfs.0p25.2018051100.f033.grib2',
'2018/20180511/gfs.0p25.2018051100.f036.grib2',
'2018/20180511/gfs.0p25.2018051100.f039.grib2',
'2018/20180511/gfs.0p25.2018051100.f042.grib2',
'2018/20180511/gfs.0p25.2018051100.f045.grib2',
'2018/20180511/gfs.0p25.2018051100.f048.grib2',
'2018/20180511/gfs.0p25.2018051100.f051.grib2',
'2018/20180511/gfs.0p25.2018051100.f054.grib2',
'2018/20180511/gfs.0p25.2018051100.f057.grib2',
'2018/20180511/gfs.0p25.2018051100.f060.grib2',
'2018/20180511/gfs.0p25.2018051100.f063.grib2',
'2018/20180511/gfs.0p25.2018051100.f066.grib2',
'2018/20180511/gfs.0p25.2018051100.f069.grib2',
'2018/20180511/gfs.0p25.2018051100.f072.grib2',
'2018/20180511/gfs.0p25.2018051100.f075.grib2']
for file in filelist:
    filename=dspath+file
    file_base = os.path.basename(file)
    print('Downloading',file_base)
    req = requests.get(filename, cookies = ret.cookies, allow_redirects=True, stream=True)
    filesize = int(req.headers['Content-length'])
    with open(file_base, 'wb') as outfile:
        chunk_size=1048576
        for chunk in req.iter_content(chunk_size=chunk_size):
            outfile.write(chunk)
            if chunk_size < filesize:
                check_file_status(file_base, filesize)
    check_file_status(file_base, filesize)
    print()
